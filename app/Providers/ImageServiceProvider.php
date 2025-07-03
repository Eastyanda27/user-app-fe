<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Intervention\Image\ImageManager;
use Intervention\Image\Drivers\Gd\Driver;

class ImageServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->singleton('image', function () {
            return new ImageManager(new Driver());
        });
    }

    public function boot(): void
    {
        //
    }
}
