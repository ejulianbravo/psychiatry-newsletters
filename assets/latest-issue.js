(function () {
  "use strict";

  var script = document.currentScript;
  if (!script) return;

  var target = new URL(script.getAttribute("data-latest-target"), window.location.href);
  if (target.origin !== window.location.origin) return;

  // Keep QR campaign attribution on the issue; this redirect page records no visit.
  var incoming = new URLSearchParams(window.location.search);
  ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term"].forEach(function (key) {
    if (incoming.has(key)) target.searchParams.set(key, incoming.get(key));
  });

  window.location.replace(target.pathname + target.search);
}());
