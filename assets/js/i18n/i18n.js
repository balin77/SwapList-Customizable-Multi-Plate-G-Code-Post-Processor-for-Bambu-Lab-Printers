/**
 * i18n - Internationalization Module
 * Provides translation functionality for the CLEAR.bed application
 */

class I18n {
  constructor() {
    this.locale = 'en';
    this.fallbackLocale = 'en';
    this.translations = {};
    this.supportedLocales = ['en', 'de', 'fr', 'es', 'it', 'pt', 'ru', 'zh'];
  }

  /**
   * Load translations for a specific locale
   * @param {string} locale - The locale to load (e.g., 'en', 'de')
   */
  async loadLocale(locale) {
    if (!this.supportedLocales.includes(locale)) {
      console.warn(`Locale "${locale}" not supported, falling back to "${this.fallbackLocale}"`);
      locale = this.fallbackLocale;
    }

    try {
      // Import the JSON file directly (will be bundled by esbuild)
      let translations;
      if (locale === 'en') {
        translations = (await import('./locales/en.json')).default;
      } else if (locale === 'de') {
        translations = (await import('./locales/de.json')).default;
      } else if (locale === 'fr') {
        translations = (await import('./locales/fr.json')).default;
      } else if (locale === 'es') {
        translations = (await import('./locales/es.json')).default;
      } else if (locale === 'it') {
        translations = (await import('./locales/it.json')).default;
      } else if (locale === 'pt') {
        translations = (await import('./locales/pt.json')).default;
      } else if (locale === 'ru') {
        translations = (await import('./locales/ru.json')).default;
      } else if (locale === 'zh') {
        translations = (await import('./locales/zh.json')).default;
      } else {
        throw new Error(`Unsupported locale: ${locale}`);
      }

      this.translations = translations;
      this.locale = locale;
      document.documentElement.setAttribute('lang', locale);
      console.log(`Loaded locale "${locale}" with ${Object.keys(translations).length} top-level keys`);
    } catch (error) {
      console.error(`Error loading locale "${locale}":`, error);
      if (locale !== this.fallbackLocale) {
        console.log(`Attempting to load fallback locale "${this.fallbackLocale}"`);
        await this.loadLocale(this.fallbackLocale);
      }
    }
  }

  /**
   * Get translated text for a key
   * @param {string} key - Translation key (e.g., 'ui.buttons.export')
   * @param {Object} variables - Variables to interpolate (e.g., {count: 5})
   * @returns {string} Translated text or key if not found
   */
  t(key, variables = {}) {
    // Navigate through nested object using dot notation
    let text = key.split('.').reduce((obj, k) => obj?.[k], this.translations);

    // If translation not found, return the key itself as fallback
    if (text === undefined || text === null) {
      console.warn(`Translation missing for key: "${key}" in locale "${this.locale}"`);
      return key;
    }

    // Replace variables in the format {{variableName}}
    if (variables && typeof text === 'string') {
      Object.keys(variables).forEach(varKey => {
        const placeholder = new RegExp(`{{${varKey}}}`, 'g');
        text = text.replace(placeholder, variables[varKey]);
      });
    }

    return text;
  }

  /**
   * Translate all elements with data-i18n attribute
   */
  translatePage() {
    const elements = document.querySelectorAll('[data-i18n]');
    console.log(`Translating ${elements.length} elements with data-i18n attribute`);

    elements.forEach(element => {
      const key = element.getAttribute('data-i18n');
      const translated = this.t(key);

      // Check if element allows HTML content (for tooltips with <b>, <code> tags and documentation content)
      const allowHTML = element.hasAttribute('data-i18n-html') ||
                        element.tagName === 'P' ||
                        element.tagName === 'DIV' ||
                        element.tagName === 'H3' ||
                        element.tagName === 'H4' ||
                        element.tagName === 'LI' ||
                        element.tagName === 'SUMMARY';

      // Handle different element types
      if (element.tagName === 'INPUT' && (element.type === 'button' || element.type === 'submit')) {
        element.value = translated;
      } else if (element.tagName === 'INPUT' && element.hasAttribute('placeholder')) {
        element.placeholder = translated;
      } else if (element.tagName === 'OPTION') {
        element.textContent = translated;
      } else if (element.tagName === 'BUTTON') {
        element.textContent = translated;
      } else if (allowHTML) {
        // Use innerHTML for elements that may contain HTML tags
        element.innerHTML = translated;
      } else {
        // For other elements, only update if we have children or simple text
        if (element.children.length === 0 || element.querySelector('[data-i18n]')) {
          element.textContent = translated;
        } else {
          // Has children, so we update only the text nodes
          const textNodes = Array.from(element.childNodes).filter(node => node.nodeType === Node.TEXT_NODE);
          if (textNodes.length > 0) {
            textNodes[0].textContent = translated;
          }
        }
      }
    });
  }

  /**
   * Get the current locale
   * @returns {string} Current locale code
   */
  getCurrentLocale() {
    return this.locale;
  }

  /**
   * Detect user's preferred language from browser or localStorage
   * @returns {string} Preferred locale
   */
  detectPreferredLocale() {
    // Check localStorage first
    const savedLocale = localStorage.getItem('preferredLanguage');
    if (savedLocale && this.supportedLocales.includes(savedLocale)) {
      return savedLocale;
    }

    // Check browser language
    const browserLang = navigator.language.split('-')[0]; // 'de-DE' → 'de'
    if (this.supportedLocales.includes(browserLang)) {
      return browserLang;
    }

    // Default to fallback
    return this.fallbackLocale;
  }

  /**
   * Set and persist locale preference
   * @param {string} locale - Locale to set
   */
  async setLocale(locale) {
    await this.loadLocale(locale);
    localStorage.setItem('preferredLanguage', locale);
  }
}

// Create singleton instance
export const i18n = new I18n();
