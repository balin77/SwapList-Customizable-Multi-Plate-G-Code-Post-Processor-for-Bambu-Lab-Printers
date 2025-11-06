// /src/constants/errorMessages.js

// Get i18n instance for translations
function getErrorMessage(key, variables = {}) {
  const i18n = window.i18nInstance;
  if (i18n) {
    return i18n.t(`errors.${key}`, variables);
  }
  // Fallback to English if i18n not available
  const fallbacks = {
    'defaultError': "Please use sliced files in *.3mf or *.gcode.3mf formats. Usage of plane *.gcode files is not supported.",
    'fileNotReadable': "File not readable.",
    'noSlicedData': "No sliced data found."
  };
  return fallbacks[key] || key;
}

export function getErr00() {
  return getErrorMessage('fileNotReadable') + "\n" + getErrorMessage('defaultError');
}

export function getErr01() {
  return getErrorMessage('noSlicedData') + "\n" + getErrorMessage('defaultError');
}

// Legacy exports for backwards compatibility
export const err_default = getErrorMessage('defaultError');
export const err00 = getErr00();
export const err01 = getErr01();