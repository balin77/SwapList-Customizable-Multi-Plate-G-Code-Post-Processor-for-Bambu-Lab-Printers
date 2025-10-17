#!/usr/bin/env node

/**
 * Development script to compare original vs modified project settings files
 * This replaces the UI button functionality that was available in dev mode
 */

import { compareProjectSettingsFiles } from '../assets/js/utils/utils.js';

async function main() {
  try {
    console.log('🔍 Comparing project settings files...');
    const result = await compareProjectSettingsFiles();

    if (result.ok) {
      console.log('✅ Comparison completed successfully');
      console.log(`📊 Found ${result.differences} differences`);
    } else {
      console.error('❌ Comparison failed:', result.error);
      process.exit(1);
    }
  } catch (error) {
    console.error('❌ Script failed:', error.message || error);
    process.exit(1);
  }
}

main();