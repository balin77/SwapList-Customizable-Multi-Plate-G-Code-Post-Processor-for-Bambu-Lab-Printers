#!/usr/bin/env node

/**
 * Script to automatically update version numbers across the application
 * Usage: node scripts/update-version.mjs [major|minor|patch|build]
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Get __dirname equivalent in ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Paths
const VERSION_FILE = path.join(__dirname, '..', 'version.json');
const DE_LOCALE = path.join(__dirname, '..', 'assets', 'js', 'i18n', 'locales', 'de.json');
const EN_LOCALE = path.join(__dirname, '..', 'assets', 'js', 'i18n', 'locales', 'en.json');
const INDEX_HTML = path.join(__dirname, '..', 'index.html');

// Read version file
function readVersion() {
  try {
    const content = fs.readFileSync(VERSION_FILE, 'utf8');
    return JSON.parse(content);
  } catch (error) {
    console.error('Error reading version.json:', error.message);
    process.exit(1);
  }
}

// Write version file
function writeVersion(versionData) {
  try {
    fs.writeFileSync(VERSION_FILE, JSON.stringify(versionData, null, 2) + '\n', 'utf8');
    console.log(`✓ Updated version.json to ${versionData.version} (build ${versionData.buildNumber})`);
  } catch (error) {
    console.error('Error writing version.json:', error.message);
    process.exit(1);
  }
}

// Increment version
function incrementVersion(versionData, type = 'build') {
  const parts = versionData.version.split('.').map(Number);
  const [major, minor, patch] = parts;

  switch (type) {
    case 'major':
      versionData.version = `${major + 1}.0.0`;
      versionData.buildNumber = 0;
      break;
    case 'minor':
      versionData.version = `${major}.${minor + 1}.0`;
      versionData.buildNumber = 0;
      break;
    case 'patch':
      versionData.version = `${major}.${minor}.${patch + 1}`;
      versionData.buildNumber = 0;
      break;
    case 'build':
    default:
      versionData.buildNumber += 1;
      break;
  }

  return versionData;
}

// Format version string for display
function formatVersionString(versionData) {
  const shortVersion = versionData.version.split('.').slice(0, 2).join('.');
  return `AutoEject Version V${shortVersion}`;
}

// Update locale file
function updateLocaleFile(filePath, versionString) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const locale = JSON.parse(content);

    // Update all version references
    if (locale.app && locale.app.version) {
      locale.app.version = versionString;
    }
    if (locale.appInfo && locale.appInfo.version) {
      locale.appInfo.version = versionString;
    }

    fs.writeFileSync(filePath, JSON.stringify(locale, null, 2) + '\n', 'utf8');
    console.log(`✓ Updated ${path.basename(filePath)}`);
  } catch (error) {
    console.error(`Error updating ${filePath}:`, error.message);
  }
}

// Update HTML file
function updateHtmlFile(filePath, versionString) {
  try {
    let content = fs.readFileSync(filePath, 'utf8');

    // Update version in HTML (looks for data-i18n="appInfo.version" content)
    content = content.replace(
      /(<p data-i18n="appInfo\.version"><strong>)AutoEject Version V[\d.]+(<\/strong><\/p>)/g,
      `$1${versionString}$2`
    );

    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✓ Updated ${path.basename(filePath)}`);
  } catch (error) {
    console.error(`Error updating ${filePath}:`, error.message);
  }
}

// Main function
function main() {
  const args = process.argv.slice(2);
  const incrementType = args[0] || 'build';

  console.log('🔄 Updating version...\n');

  // Read current version
  let versionData = readVersion();
  console.log(`Current version: ${versionData.version} (build ${versionData.buildNumber})`);

  // Increment version
  versionData = incrementVersion(versionData, incrementType);
  const versionString = formatVersionString(versionData);

  console.log(`New version: ${versionData.version} (build ${versionData.buildNumber})`);
  console.log(`Display string: "${versionString}"\n`);

  // Write updated version
  writeVersion(versionData);

  // Update all files
  updateLocaleFile(DE_LOCALE, versionString);
  updateLocaleFile(EN_LOCALE, versionString);
  updateHtmlFile(INDEX_HTML, versionString);

  console.log('\n✅ Version update complete!');
  console.log(`\nNext steps:`);
  console.log(`  git add .`);
  console.log(`  git commit -m "chore: bump version to ${versionData.version}"`);
  console.log(`  git push`);
}

// Run main function
main();
