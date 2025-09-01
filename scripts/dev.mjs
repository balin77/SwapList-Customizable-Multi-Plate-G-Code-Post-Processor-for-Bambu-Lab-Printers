import esbuild from "esbuild";
import importGlob from "esbuild-plugin-import-glob";

const ctx = await esbuild.context({
  entryPoints: ["assets/js/index.js"],
  bundle: true,
  outfile: "dist/bundle.js",
  format: "iife",
  target: "es2020",
  sourcemap: true,
  plugins: [(importGlob.default ?? importGlob)()]
});

// Watch einschalten
await ctx.watch();
console.log("👀 watching…");

// Wenn du ein Dev-Serve möchtest (esbuild 0.24: context.serve)
const server = await ctx.serve({
  servedir: ".",       // Projekt-Root serven (dein index.html)
  port: 5173
});
console.log(`📡 dev server on http://localhost:${server.port}`);
