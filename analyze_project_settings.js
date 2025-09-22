// Analyze differences between template and modified A1 project settings
import { project_settings_template } from "./assets/js/testfiles/project_settings_template_data.js";
import { project_settings_modified } from "./assets/js/testfiles/project_settings_modified_data.js";

console.log("=== ANALYZING A1 PROJECT SETTINGS DIFFERENCES ===\n");

// Find all differences
const differences = [];
const allKeys = new Set([...Object.keys(project_settings_template), ...Object.keys(project_settings_modified)]);

for (const key of allKeys) {
  const original = project_settings_template[key];
  const modified = project_settings_modified[key];

  if (JSON.stringify(original) !== JSON.stringify(modified)) {
    differences.push({
      key,
      original: original,
      modified: modified,
      originalType: Array.isArray(original) ? `array[${original?.length}]` : typeof original,
      modifiedType: Array.isArray(modified) ? `array[${modified?.length}]` : typeof modified
    });
  }
}

console.log(`Found ${differences.length} differences between original and modified:\n`);

// Group differences by type
const groups = {
  arrayLengthChanges: [],
  colorChanges: [],
  matrixChanges: [],
  otherChanges: []
};

for (const diff of differences) {
  if (diff.key.includes('colour') || diff.key.includes('color')) {
    groups.colorChanges.push(diff);
  } else if (diff.key.includes('matrix') || diff.key.includes('vector')) {
    groups.matrixChanges.push(diff);
  } else if (Array.isArray(diff.original) && Array.isArray(diff.modified) &&
             diff.original.length !== diff.modified.length) {
    groups.arrayLengthChanges.push(diff);
  } else {
    groups.otherChanges.push(diff);
  }
}

console.log("=== COLOR CHANGES (expected) ===");
groups.colorChanges.forEach(diff => {
  console.log(`${diff.key}:`);
  console.log(`  Original: ${JSON.stringify(diff.original)}`);
  console.log(`  Modified: ${JSON.stringify(diff.modified)}`);
  console.log('');
});

console.log("=== MATRIX/VECTOR CHANGES (expected) ===");
groups.matrixChanges.forEach(diff => {
  console.log(`${diff.key}:`);
  console.log(`  Original: ${JSON.stringify(diff.original)}`);
  console.log(`  Modified: ${JSON.stringify(diff.modified)}`);
  console.log('');
});

console.log("=== ARRAY LENGTH CHANGES ===");
groups.arrayLengthChanges.forEach(diff => {
  console.log(`${diff.key}: ${diff.originalType} -> ${diff.modifiedType}`);
  if (diff.original?.length === 1 && diff.modified?.length === 2) {
    console.log(`  ✓ Single value duplicated: ${JSON.stringify(diff.original)} -> ${JSON.stringify(diff.modified)}`);
  } else {
    console.log(`  ⚠ Unexpected change: ${JSON.stringify(diff.original)} -> ${JSON.stringify(diff.modified)}`);
  }
  console.log('');
});

console.log("=== OTHER CHANGES (unexpected) ===");
groups.otherChanges.forEach(diff => {
  console.log(`${diff.key}:`);
  console.log(`  Original (${diff.originalType}): ${JSON.stringify(diff.original)}`);
  console.log(`  Modified (${diff.modifiedType}): ${JSON.stringify(diff.modified)}`);
  console.log('');
});

// Analyze which fields were duplicated from single to double
const duplicatedFields = groups.arrayLengthChanges
  .filter(diff => diff.original?.length === 1 && diff.modified?.length === 2)
  .map(diff => diff.key)
  .sort();

console.log("=== FIELDS THAT NEED DUPLICATION FOR A1 (1->2 slots) ===");
console.log(duplicatedFields.join('\n'));

console.log(`\n=== SUMMARY ===`);
console.log(`Total differences: ${differences.length}`);
console.log(`Color changes: ${groups.colorChanges.length} (expected)`);
console.log(`Matrix changes: ${groups.matrixChanges.length} (expected)`);
console.log(`Array length changes: ${groups.arrayLengthChanges.length}`);
console.log(`Other unexpected changes: ${groups.otherChanges.length}`);
console.log(`Fields requiring duplication: ${duplicatedFields.length}`);