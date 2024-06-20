'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "397272275649547ad9db1743b6078530",
"assets/AssetManifest.bin.json": "8087dbb6690fcefe93e23673d2d75aa7",
"assets/AssetManifest.json": "134e77136846d9a32246c912c4edff1d",
"assets/assets/apple_macbook_pro_16.jpg": "f1effaa76c3e2cf2642bbb93f0e99741",
"assets/assets/apple_macbook_pro_16_2.jpg": "bda6a73a714255a42be02580f193a1e4",
"assets/assets/Background.png": "e2a80f7eceaf1cabe2add6956e8b28c0",
"assets/assets/black.png": "b920aafc73d7da0e2ae6085effad6a0a",
"assets/assets/bus.jpeg": "b115ac5b7944d9fc0ef4a73894cea2fc",
"assets/assets/calculator.jpg": "b144d396c4869bc7ba1d5d1e46308c33",
"assets/assets/cheese.jpg": "142c8d0e083e60f5bd2f44448c0b962a",
"assets/assets/coals.jpg": "cd3b2d32faaf38b1bb538803f1f87ff0",
"assets/assets/facts.json": "6f10e016d902e01f5389a4dccb539a0c",
"assets/assets/flights.txt": "8d2e0f6e7c26854cffee58eafd88e6e5",
"assets/assets/Flying.jpg": "d7d7fd9584bdaed04f21051d2c6e9f4c",
"assets/assets/forest_fire.jpg": "8239798fdb1edc2bcad866658d586a44",
"assets/assets/higherlowerpage.png": "b96ceecbd795c510a29f35a25be046df",
"assets/assets/hydro.jpg": "a59e2d31f4d6c0c36b2e3395de8ecdc2",
"assets/assets/Logo.png": "154da86b54decd38e37bf737046a5f7c",
"assets/assets/Meat.jpg": "02cc5a338d92682978689828bd39a877",
"assets/assets/naturalgas.jpg": "f5893f8fcbf9e4da3503ad695306baea",
"assets/assets/nuclear.jpg": "d940ae0211b4a1bd647fe800232bb8bd",
"assets/assets/PlasticBag.jpg": "a7f8dff611954a5f19ddc6b6b1446172",
"assets/assets/private_jet.jpg": "fe6fb690feece052cc00fb30a81c9142",
"assets/assets/questions.json": "04a128a79f294370db7d7774a4af8d7e",
"assets/assets/sheep.jpg": "4f1227d658f613735226773c1e1cf09e",
"assets/assets/train.jpg": "1e00446341a466a76efc49eb9f49465c",
"assets/assets/vwgolf.png": "c64cde21884b5399026c1154499203df",
"assets/assets/washer.jpg": "b0e78109c0c37ec6fb6ae1e18ac3e78f",
"assets/assets/wind.jpg": "82d1f09b10dfcc12de5d7d0e854f2991",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/NOTICES": "c73f3bd61aec6444ef61c04281e929f7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "154da86b54decd38e37bf737046a5f7c",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "f06ba3f4ac80a9d0c5218597b0e1fc32",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "b33b0ed4596bc318ae6134fadf602b58",
"/": "b33b0ed4596bc318ae6134fadf602b58",
"main.dart.js": "5d525ab35ce0f1e14f90b8f4b433842e",
"manifest.json": "dac88f063a7d3dd736e9c49818c0a130",
"version.json": "d4ea58f2ac136174b8d5ba63472c81a7"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
