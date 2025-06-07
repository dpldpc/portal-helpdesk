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
</head>
<body>
    @yield('content')
    @livewireScripts
</body>
</html>
