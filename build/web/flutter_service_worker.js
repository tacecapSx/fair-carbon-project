'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "71ae6d7f966503067a863c4c78003171",
"assets/AssetManifest.bin.json": "87a1c267f048d38ef87f442167d00ec1",
"assets/AssetManifest.json": "ab6aac70bfe5bfffc4b86d1387150a04",
"assets/assets/apple_macbook_pro_16.jpg": "f1effaa76c3e2cf2642bbb93f0e99741",
"assets/assets/apple_macbook_pro_16_2.jpg": "bda6a73a714255a42be02580f193a1e4",
"assets/assets/Background.png": "e2a80f7eceaf1cabe2add6956e8b28c0",
"assets/assets/bacon.jpg": "e199e83a96bdc4bc3d9b2409d553e825",
"assets/assets/beef.jpg": "451c5bb25f85adcc13578373996d18f5",
"assets/assets/black.png": "b920aafc73d7da0e2ae6085effad6a0a",
"assets/assets/bus.jpeg": "2484abc696744aa28f6760b4c82c80b0",
"assets/assets/calculator.jpg": "b144d396c4869bc7ba1d5d1e46308c33",
"assets/assets/cheese.jpg": "29c82d1ae7ae6a850e2bd5a495bb982c",
"assets/assets/coals.jpg": "cd3b2d32faaf38b1bb538803f1f87ff0",
"assets/assets/facts.json": "6f10e016d902e01f5389a4dccb539a0c",
"assets/assets/flights.txt": "a83949fd279b0d60f4f1b2eae7deae57",
"assets/assets/Flying.jpg": "452b1f1a5bd3f35fd055e52f9cd68f1c",
"assets/assets/forest_fire.jpg": "8239798fdb1edc2bcad866658d586a44",
"assets/assets/higherlowerpage.png": "b96ceecbd795c510a29f35a25be046df",
"assets/assets/hydro.jpg": "72c61e340d3bf903df1eb91a2b70e774",
"assets/assets/Logo.png": "f69d928596956a0d8178646761d4e3c2",
"assets/assets/naturalgas.jpg": "6fc9d2603b7476faaebb2f5e83d3bcb9",
"assets/assets/nuclear.jpg": "04ad1f07cd2b8fa707cd3f93945895cd",
"assets/assets/PlasticBag.jpg": "79397dd1db2a08f444ba25a7b7297530",
"assets/assets/private_jet.jpg": "fe6fb690feece052cc00fb30a81c9142",
"assets/assets/questions.json": "433730a1318e122c08543a9837478969",
"assets/assets/sheep.jpg": "77616a70b71fe322910ad0aca2b0c083",
"assets/assets/train.jpg": "a6885feab65a76a2550ac91130625cd0",
"assets/assets/vwgolf.png": "c64cde21884b5399026c1154499203df",
"assets/assets/washer.jpg": "8892f50021a8cd92abcbbf3b1a82f354",
"assets/assets/wind.jpg": "31f83c0fbcb497d45125a0bf9383d404",
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
"favicon.png": "f69d928596956a0d8178646761d4e3c2",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "156401592ed7fa8d496fa973db739971",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9d0c3c5d2bae26069308e6af3a30acaf",
"/": "9d0c3c5d2bae26069308e6af3a30acaf",
"main.dart.js": "dc554797ac720610a3ac3799866c7109",
"manifest.json": "00d0cd9f4fae21edd0f72d56ce6a95fc",
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
