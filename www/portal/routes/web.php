<?php

use Livewire\Livewire;

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
])->group(function () {
    Route::get('/dashboard', function () {
        return view('dashboard');
    })->name('dashboard');
});


Livewire::setUpdateRoute(function ($handle) {
return Route::post('/portal/livewire/update', $handle)->name('livewire.update');
});
