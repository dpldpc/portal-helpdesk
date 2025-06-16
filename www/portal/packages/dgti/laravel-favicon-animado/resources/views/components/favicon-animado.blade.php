@props([
  'totalFrames' => 40,
  'frameRate' => 10,
  'path' => 'favicons',
])

@php
  $baseFaviconPath = asset($path);
@endphp

<link id="favicon" rel="icon" type="image/png" href="{{ $baseFaviconPath }}/32x32/frame1.webp">

<script>
  (() => {
    const baseFaviconPath = @json($baseFaviconPath);
    const totalFrames = {{ $totalFrames }};
    const frameDelay = 1000 / {{ $frameRate }};

    const deviceRatio = window.devicePixelRatio || 1;
    let size = 32;
    if (deviceRatio >= 3) size = 128;
    else if (deviceRatio >= 2) size = 64;

    const canvas = document.createElement('canvas');
    canvas.width = canvas.height = size;
    const ctx = canvas.getContext('2d');
    const favicon = document.getElementById('favicon');

    let currentFrame = 1;
    const images = [];

    for (let i = 1; i <= totalFrames; i++) {
      const img = new Image();
      img.src = `${baseFaviconPath}/${size}x${size}/frame${i}.webp`;
      images.push(img);
    }

    Promise.all(images.map((img, i) => new Promise(resolve => {
      img.onload = resolve;
      img.onerror = () => {
        console.warn(`Erro ao carregar frame ${i + 1}: ${img.src}`);
        resolve();
      };
    }))).then(() => {
      setInterval(() => {
        const image = images[currentFrame - 1];
        if (image.complete && image.naturalWidth !== 0) {
          ctx.clearRect(0, 0, size, size);
          ctx.drawImage(image, 0, 0, size, size);
          favicon.href = canvas.toDataURL('image/png');
        }
        currentFrame = (currentFrame % totalFrames) + 1;
      }, frameDelay);
    });
  })();
</script>
