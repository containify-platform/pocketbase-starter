/// <reference path="../pb_data/types.d.ts" />

// An example hook: GET /hello returns JSON. PocketBase loads every
// *.pb.js file in pb_hooks on start. Its own health check is /api/health.
routerAdd("GET", "/hello", (e) => {
  return e.json(200, { message: "Hello from PocketBase on Containify" });
});
