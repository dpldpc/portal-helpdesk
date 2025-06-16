<?php

namespace dgti\FaviconAnimado;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Blade;

class FaviconAnimadoServiceProvider extends ServiceProvider
{
    public function boot()
    {
        $this->loadViewsFrom(__DIR__.'/../resources/views', 'favicon-animado');
        $this->publishes([
            __DIR__.'/../public/favicons' => public_path('favicons'),
        ], 'public');
        Blade::component('favicon-animado::components.favicon-animado', 'favicon-animado');
        Blade::component('favicon-animado::components.barra-ouvidoria', 'barra-ouvidoria');
    }

    public function register()
    {
        //
    }
}
