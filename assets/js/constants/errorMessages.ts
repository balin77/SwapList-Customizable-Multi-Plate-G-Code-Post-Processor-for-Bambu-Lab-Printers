// /src/constants/errorMessages.ts

type ErrorKey = 'defaultError' | 'fileNotReadable' | 'noSlicedData';

const ERROR_FALLBACKS: Record<ErrorKey, string> = {
  'defaultError': "Please use sliced files in *.3mf or *.gcode.3mf formats. Usage of plane *.gcode files is not supported.",
  'fileNotReadable': "File not readable.",
  'noSlicedData': "No sliced data found."
} as const;

// Get i18n instance for translations
function getErrorMessage(key: ErrorKey, variables: Record<string, string | number> = {}): string {
  const i18n = window.i18nInstance;
  if (i18n) {
    return i18n.t(`errors.${key}`, variables);
  }
  // Fallback to English if i18n not available
  return ERROR_FALLBACKS[key] || key;
}

export function getErr00(): string {
  return getErrorMessage('fileNotReadable') + "\n" + getErrorMessage('defaultError');
}

export function getErr01(): string {
  return getErrorMessage('noSlicedData') + "\n" + getErrorMessage('defaultError');
}

// Legacy exports for backwards compatibility
export const err_default: string = getErrorMessage('defaultError');
export const err00: string = getErr00();
export const err01: string = getErr01();