import esbuild from 'esbuild';
import importGlob from 'esbuild-plugin-import-glob';

const watch = process.argv.includes('--watch');

esbuild.build({
  entryPoints: ['assets/js/index.js'],
  outfile: 'dist/bundle.js',
  bundle: true,
  format: 'iife',
  target: ['es2020'],
  sourcemap: true,
  minify: !watch,
  loader: { 
    '.json': 'json',      // ← wichtig: JSON als Module laden
    '.gcode': 'text'      // GCODE-Dateien als Text laden
  },
}).catch(() => process.exit(1));
