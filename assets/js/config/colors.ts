// Color configuration system for the application
// Central place to manage all theme colors

/**
 * Color constants used throughout the application
 */
export const COLORS = {
  // Theme Colors
  THEME_YELLOW: '#EDF07A',      // A1M Swap Mode (default)
  THEME_GRAY: '#B0B0B0',        // 3Print A1 Swap Mode
  THEME_RED: '#E8A8A8',         // Push Off Mode
  THEME_PRINTFLOW_BLUE: '#8892e0ff', // Printflow A1 Swap Mode
  THEME_JOBOX_BLUE: '#8bd4e1ff',       // Jobox A1 Swap Mode (matches logo)

  // UI Colors
  CI_1: '#00BBDC',              // Primary blue
  CI_2: '#00eeff',              // Secondary blue

  // Neutral Colors
  WHITE: '#ffffff',
  BLACK: '#000000',
  LIGHT_GRAY: '#f5f5f5',
  MEDIUM_GRAY: '#888',
  DARK_GRAY: '#555',

  // Status Colors
  SUCCESS_GREEN: '#A8E6A3',
  ERROR_RED: '#ffcccc',
  WARNING_ORANGE: '#ffa500',

  // Background Colors
  CONTENT_BG: '#eee',
  SETTINGS_BG: '#f9f9f9',
  DROPDOWN_BG: '#D9E6E6'
} as const;

/**
 * Theme configuration type
 */
export interface ThemeConfig {
  name: string;
  primary: string;
  bodyClass: string;
  cssVarName: string;
}

/**
 * Available theme names
 */
export type ThemeName = 'A1M_SWAP' | 'A1_SWAP' | 'PUSHOFF' | 'PRINTFLOW' | 'JOBOX';

/**
 * Theme configurations for different printer modes
 */
export const THEMES: Record<ThemeName, ThemeConfig> = {
  A1M_SWAP: {
    name: 'A1M Swap',
    primary: COLORS.THEME_YELLOW,
    bodyClass: '',
    cssVarName: '--primary-color'
  },
  A1_SWAP: {
    name: 'A1 Swap',
    primary: COLORS.THEME_GRAY,
    bodyClass: 'a1-swap-mode',
    cssVarName: '--a1-swap-color'
  },
  PUSHOFF: {
    name: 'Push Off',
    primary: COLORS.THEME_RED,
    bodyClass: 'pushoff-mode',
    cssVarName: '--pushoff-color'
  },
  PRINTFLOW: {
    name: 'Printflow',
    primary: COLORS.THEME_PRINTFLOW_BLUE,
    bodyClass: 'printflow-mode',
    cssVarName: '--printflow-color'
  },
  JOBOX: {
    name: 'Jobox',
    primary: COLORS.THEME_JOBOX_BLUE,
    bodyClass: 'jobox-mode',
    cssVarName: '--jobox-color'
  }
};

/**
 * Apply a theme to the document
 * @param themeName - The name of the theme to apply
 */
export function applyTheme(themeName: ThemeName): void {
  const theme = THEMES[themeName];
  if (!theme) {
    console.warn(`Theme "${themeName}" not found`);
    return;
  }

  // Remove all theme body classes
  document.body.classList.remove(
    'a1-swap-mode',
    'pushoff-mode',
    'printflow-mode',
    'jobox-mode'
  );

  // Add the theme's body class if it has one
  if (theme.bodyClass) {
    document.body.classList.add(theme.bodyClass);
  }

  // Update the appropriate CSS custom property
  document.documentElement.style.setProperty(theme.cssVarName, theme.primary);

  // Also update --primary-color for backward compatibility
  document.documentElement.style.setProperty('--primary-color', theme.primary);

  console.log(`Applied theme: ${theme.name} with color ${theme.primary}`);
}

/**
 * Get current theme based on body classes
 * @returns The current theme name
 */
export function getCurrentTheme(): ThemeName {
  if (document.body.classList.contains('pushoff-mode')) {
    return 'PUSHOFF';
  } else if (document.body.classList.contains('a1-swap-mode')) {
    return 'A1_SWAP';
  } else if (document.body.classList.contains('printflow-mode')) {
    return 'PRINTFLOW';
  } else if (document.body.classList.contains('jobox-mode')) {
    return 'JOBOX';
  }
  return 'A1M_SWAP'; // default
}

/**
 * Get hex color from theme
 * @param themeName - The theme to get the color from
 * @param colorKey - The color property to retrieve (defaults to 'primary')
 * @returns The hex color value
 */
export function getThemeColor(themeName: ThemeName, colorKey: keyof ThemeConfig = 'primary'): string {
  const theme = THEMES[themeName];
  return theme ? theme[colorKey] : COLORS.THEME_YELLOW;
}

/**
 * Initialize all CSS variables with current JavaScript values
 * Should be called during application initialization
 */
export function initializeCSSVariables(): void {
  // Update all theme color CSS variables
  document.documentElement.style.setProperty('--primary-color', COLORS.THEME_YELLOW);
  document.documentElement.style.setProperty('--a1-swap-color', COLORS.THEME_GRAY);
  document.documentElement.style.setProperty('--pushoff-color', COLORS.THEME_RED);
  document.documentElement.style.setProperty('--printflow-color', COLORS.THEME_PRINTFLOW_BLUE);
  document.documentElement.style.setProperty('--jobox-color', COLORS.THEME_JOBOX_BLUE);

  // Update UI color variables
  document.documentElement.style.setProperty('--ci_1', COLORS.CI_1);
  document.documentElement.style.setProperty('--ci_2', COLORS.CI_2);

  console.log('CSS variables initialized from JavaScript config');
}
