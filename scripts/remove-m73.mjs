#!/usr/bin/env node

/**
 * Development script to remove M73 commands from GCODE test files
 * M73 commands are progress indicators (M73 P15 R151 or M73 L4)
 */

import { readFileSync, writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// GCODE test files
const gcodeFiles = [
  join(__dirname, '..', 'assets', 'js', 'testfiles', 'gcode1.gcode'),
  join(__dirname, '..', 'assets', 'js', 'testfiles', 'gcode2.gcode')
];

console.log('🧹 Removing M73 commands from GCODE test files...\n');

let totalRemoved = 0;

gcodeFiles.forEach(filePath => {
  try {
    // Read file
    const content = readFileSync(filePath, 'utf8');
    const lines = content.split('\n');

    // Count M73 lines before removal
    const m73Count = lines.filter(line => /^\s*M73\s+/.test(line)).length;

    // Remove lines that start with M73 (with optional whitespace)
    const filteredLines = lines.filter(line => !/^\s*M73\s+/.test(line));

    // Write back to file
    writeFileSync(filePath, filteredLines.join('\n'), 'utf8');

    console.log(`✓ ${filePath.split('\\').pop()}`);
    console.log(`  Removed ${m73Count} M73 command(s)\n`);

    totalRemoved += m73Count;
  } catch (error) {
    console.error(`✗ Error processing ${filePath}:`, error.message);
    process.exit(1);
  }
});

console.log(`✅ Done! Total M73 commands removed: ${totalRemoved}`);
