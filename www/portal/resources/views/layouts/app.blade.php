<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- TallStackUI e Livewire Styles -->
    <!-- <tallstackui:script />  -->
    <script src="/portal/tallstackui/script/tallstackui-BwhF6rEa.js" defer></script>
    <link href="/portal/tallstackui/style/tippy-BHH8rdGj.css" rel="stylesheet" type="text/css">
    @livewireStyles

    <!-- Vite -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script src="https://kit.fontawesome.com/a9d0042508.js" crossorigin="anonymous"></script>
    <!-- Favicon Animado -->
    <x-favicon-animado :total-frames="40" :frame-rate="10" path="favicons" />
</head>

<body>
    <x-barra-ouvidoria />
    <x-layout>
        <x-slot:header>
            <x-layout.header without-mobile-button class="!bg-[#152f4e] min-h-24 ">
                <x-slot:left>
                    <img src="{{ asset('pics/Logo_DGTi+Uerj_fundoEscuro+transparencia-01.png') }}"
                        class="py-4 w-full h-auto max-h-16 sm:max-h-24 md:max-h-22 lg:max-h-24 xl:max-h-28 object-contain object-center block">
                </x-slot:left>
                <x-slot:middle>
                    <h1 class="py-4 text-white font-bold text-1xl sm:text-2xl md:text-3xl lg:text-4xl">
                        Portal de Serviços do Helpdesk DGTi/UERJ
                    </h1>
                </x-slot:middle>
                <x-slot:right>
                    <!-- ... -->
                </x-slot:right>
            </x-layout.header>
        </x-slot:header>

        @yield('content')

        <x-slot:footer>
            <div class="bg-[#152f4e] text-white">
                <p>&copy; {{ date('Y') }} - {{ config('app.name') }}</p>
            </div>
        </x-slot:footer>
    </x-layout>

    @livewireScripts
</body>

</html>
