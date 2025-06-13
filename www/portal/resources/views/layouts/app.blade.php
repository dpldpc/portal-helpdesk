<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- TallStackUI e Livewire Styles -->
    <!-- <tallstackui:script />  -->
    <script src="/portal/tallstackui/script/tallstackui-BA56JFsq.js" defer></script>
    <link href="/portal/tallstackui/style/tippy-BHH8rdGj.css" rel="stylesheet" type="text/css">
    @livewireStyles

    <!-- Vite -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <script src="https://kit.fontawesome.com/a9d0042508.js" crossorigin="anonymous"></script>
    <!-- Favicon Animado -->
    <x-favicon-animado
  :total-frames="40"
  :frame-rate="10"
     path="favicons"
/>

</head>
<body>
    <x-barra-ouvidoria />
    @yield('content')
    @livewireScripts
</body>
</html>
