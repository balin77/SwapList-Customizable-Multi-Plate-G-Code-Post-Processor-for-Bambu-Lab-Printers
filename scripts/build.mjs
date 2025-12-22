import esbuild from 'esbuild';
import importGlobPlugin from 'esbuild-plugin-import-glob';

const watch = process.argv.includes('--watch');

const buildOptions = {
  entryPoints: ['assets/js/index.ts'],
  outfile: 'dist/bundle.js',
  bundle: true,
  format: 'iife',
  target: ['es2020'],
  sourcemap: true,
  minify: !watch,
  loader: {
    '.json': 'json',      // ← wichtig: JSON als Module laden
    '.gcode': 'text',     // GCODE-Dateien als Text laden
    '.ts': 'ts',          // TypeScript-Dateien
    '.js': 'js'           // JavaScript-Dateien (während der Migration)
  },
  plugins: [importGlobPlugin.default ? importGlobPlugin.default() : importGlobPlugin()],
  resolveExtensions: ['.ts', '.js', '.json'],
  // Alias for @swapmod/core to point to the monorepo package
  alias: {
    '@swapmod/core': '../swapmod-monorepo/packages/core/src/index.ts'
  },
};

if (watch) {
  const ctx = await esbuild.context(buildOptions);
  await ctx.watch();
  console.log('Watching for changes...');
} else {
  await esbuild.build(buildOptions).catch(() => process.exit(1));
}
