#!/usr/bin/env node

/**
 * Development script to compare template vs modified project settings files
 * This replaces the UI button functionality that was available in dev mode
 */

import { compareTemplateModifiedFiles } from '../assets/js/utils/utils.js';

async function main() {
  try {
    console.log('🔍 Comparing template vs modified files...');
    const result = await compareTemplateModifiedFiles();

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