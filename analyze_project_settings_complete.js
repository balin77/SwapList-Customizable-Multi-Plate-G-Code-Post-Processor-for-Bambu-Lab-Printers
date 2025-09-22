// Complete analysis: Original (1 filament) vs Template (2 filament, correct) vs Modified (2 filament, our code)
import { project_settings_original } from "./assets/js/testfiles/project_settings_original_data.js";
import { project_settings_template } from "./assets/js/testfiles/project_settings_template_data.js";
import { project_settings_modified } from "./assets/js/testfiles/project_settings_modified_data.js";

console.log("=== COMPLETE A1 PROJECT SETTINGS ANALYSIS ===\n");

function analyzeArrayChanges(orig, templ, modi, key) {
  const origArray = Array.isArray(orig);
  const templArray = Array.isArray(templ);
  const modiArray = Array.isArray(modi);

  if (!origArray || !templArray || !modiArray) return null;

  const origLen = orig.length;
  const templLen = templ.length;
  const modiLen = modi.length;

  return {
    key,
    originalLength: origLen,
    templateLength: templLen,
    modifiedLength: modiLen,
    shouldDuplicate: origLen === 1 && templLen === 2,
    correctlyDuplicated: origLen === 1 && templLen === 2 && modiLen === 2,
    templateMatches: JSON.stringify(templ) === JSON.stringify(modi),
    originalValue: origLen === 1 ? orig[0] : null,
    templateValues: templ,
    modifiedValues: modi
  };
}

// Alle Keys sammeln
const allKeys = new Set([
  ...Object.keys(project_settings_original),
  ...Object.keys(project_settings_template),
  ...Object.keys(project_settings_modified)
]);

const arrayAnalysis = [];
const shouldDuplicate = [];
const correctlyHandled = [];
const incorrectlyHandled = [];
const nonArrayDifferences = [];

for (const key of allKeys) {
  const orig = project_settings_original[key];
  const templ = project_settings_template[key];
  const modi = project_settings_modified[key];

  // Nur Array-Felder analysieren
  if (Array.isArray(orig) || Array.isArray(templ) || Array.isArray(modi)) {
    const analysis = analyzeArrayChanges(orig, templ, modi, key);
    if (analysis) {
      arrayAnalysis.push(analysis);

      if (analysis.shouldDuplicate) {
        shouldDuplicate.push(analysis);

        if (analysis.correctlyDuplicated && analysis.templateMatches) {
          correctlyHandled.push(analysis);
        } else {
          incorrectlyHandled.push(analysis);
        }
      }
    }
  } else {
    // Non-Array Unterschiede
    if (JSON.stringify(orig) !== JSON.stringify(templ) ||
        JSON.stringify(orig) !== JSON.stringify(modi) ||
        JSON.stringify(templ) !== JSON.stringify(modi)) {
      nonArrayDifferences.push({
        key,
        original: orig,
        template: templ,
        modified: modi
      });
    }
  }
}

console.log("=== FIELDS THAT SHOULD BE DUPLICATED (1->2) ===");
console.log(`Found ${shouldDuplicate.length} fields that should be duplicated:\n`);
shouldDuplicate.forEach(field => {
  console.log(`${field.key}: [${field.originalValue}] -> [${field.originalValue}, ${field.originalValue}]`);
});

console.log("\n=== CORRECTLY HANDLED FIELDS ===");
correctlyHandled.forEach(field => {
  console.log(`✓ ${field.key}: Template matches our output`);
});

console.log("\n=== INCORRECTLY HANDLED FIELDS ===");
incorrectlyHandled.forEach(field => {
  console.log(`❌ ${field.key}:`);
  console.log(`   Original: [${field.originalValue}] (length: ${field.originalLength})`);
  console.log(`   Template: [${field.templateValues.join(', ')}] (length: ${field.templateLength})`);
  console.log(`   Our Code: [${field.modifiedValues.join(', ')}] (length: ${field.modifiedLength})`);
  console.log(`   Expected: Should duplicate to match template`);
  console.log('');
});

console.log("=== NON-ARRAY DIFFERENCES ===");
nonArrayDifferences.forEach(diff => {
  console.log(`${diff.key}:`);
  console.log(`   Original: ${JSON.stringify(diff.original)}`);
  console.log(`   Template: ${JSON.stringify(diff.template)}`);
  console.log(`   Modified: ${JSON.stringify(diff.modified)}`);
  console.log('');
});

console.log("=== SUMMARY ===");
console.log(`Total array fields analyzed: ${arrayAnalysis.length}`);
console.log(`Fields that should be duplicated: ${shouldDuplicate.length}`);
console.log(`Correctly handled: ${correctlyHandled.length}`);
console.log(`Incorrectly handled: ${incorrectlyHandled.length}`);
console.log(`Non-array differences: ${nonArrayDifferences.length}`);

console.log("\n=== FIELDS FOR A1 DUPLICATION TEMPLATE ===");
const fieldsForTemplate = shouldDuplicate.map(f => f.key).sort();
console.log(fieldsForTemplate.join('\n'));