#!/usr/bin/env node

/**
 * Development script to compare GCODE test files line by line
 * This replaces the UI button functionality that was available in dev mode
 */

import { readFile } from 'fs/promises';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function main() {
  try {
    console.log('🔍 Comparing GCODE test files...');

    // Read the test files
    const file1Path = join(__dirname, '../assets/js/testfiles/gcode1.gcode');
    const file2Path = join(__dirname, '../assets/js/testfiles/gcode2.gcode');

    const file1Content = await readFile(file1Path, 'utf-8');
    const file2Content = await readFile(file2Path, 'utf-8');

    console.log(`📄 File 1 size: ${file1Content.length} chars`);
    console.log(`📄 File 2 size: ${file2Content.length} chars`);

    // Simple line-by-line comparison
    const lines1 = file1Content.split('\n');
    const lines2 = file2Content.split('\n');

    let differences = 0;
    const maxLines = Math.max(lines1.length, lines2.length);

    console.log(`📄 Lines in file 1: ${lines1.length}`);
    console.log(`📄 Lines in file 2: ${lines2.length}`);

    for (let i = 0; i < maxLines; i++) {
      const line1 = lines1[i] || '';
      const line2 = lines2[i] || '';

      if (line1 !== line2) {
        differences++;
        if (differences <= 300) { // Only log first 300 differences
          console.log(`🔍 Diff at line ${i+1}:`);
          console.log(`  File 1: "${line1}"`);
          console.log(`  File 2: "${line2}"`);
        }
      }
    }

    console.log(`📊 Total differences: ${differences}`);

    if (differences === 0) {
      console.log('✅ Files are identical');
    } else {
      console.log(`⚠️  Found ${differences} differences`);
    }

  } catch (error) {
    console.error('❌ Script failed:', error.message || error);
    process.exit(1);
  }
}

main();