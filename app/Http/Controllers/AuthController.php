<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Intervention\Image\ImageManager;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name'     => 'required|string',
            'email'    => 'required|email|unique:users',
            'password' => 'required|min:6',
        ]);

        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => bcrypt($request->password),
        ]);

        return response()->json(['message' => 'Registration success']);
    }

    public function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Email or password invalid'],
            ]);
        }

        $token = $user->createToken('api_token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user'  => $user,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }

    public function forgot(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        return response()->json([
            'message' => 'Password reset link sent to your email (simulasi)',
            'email' => $request->email,
        ]);
    }
    
    public function getProfile(Request $request)
    {
        return response()->json($request->user());
    }

    public function updateProfile(Request $request, ImageManager $imageManager)
    {
        $user = $request->user();

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|min:6',
            'avatar' => 'sometimes|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($request->has('name')) {
            $user->name = $request->name;
        }

        if ($request->has('email')) {
            $user->email = $request->email;
        }

        if ($request->has('password')) {
            $user->password = Hash::make($request->password);
        }

        if ($request->hasFile('avatar')) {
            if ($user->avatar) {
                Storage::delete('public/avatars/' . $user->avatar);
            }

            // 👉 Crop & Resize Image 300x300 px
            $image = $imageManager->read($request->file('avatar')->getPathname())
                ->cover(300, 300)
                ->toJpeg();

            $filename = uniqid() . '.jpg';
            Storage::put('public/avatars/' . $filename, (string) $image);
            $user->avatar = $filename;
        }

        $user->save();

        return response()->json(['message' => 'Profile updated', 'user' => $user]);
    }
}
