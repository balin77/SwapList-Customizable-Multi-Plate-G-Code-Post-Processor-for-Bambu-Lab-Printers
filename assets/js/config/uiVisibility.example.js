/**
 * UI Visibility Configuration Examples
 *
 * This file shows examples of how to modify UI visibility rules.
 * Copy patterns from here to uiVisibility.js to customize the UI.
 */

// Example: Adding a new UI element
const EXAMPLE_UI_ELEMENTS = {
  // Add new elements like this:
  MY_NEW_BUTTON: 'my_button_id',
  MY_NEW_PANEL: 'my_panel_id'
};

// Example: Adding new visibility rules for a mode
const EXAMPLE_MODE_RULES = {
  SWAP: {
    visible: [
      'existing_element',
      'MY_NEW_BUTTON' // Add new elements to visible list
    ],
    hidden: [
      'existing_hidden_element',
      'MY_NEW_PANEL' // Add new elements to hidden list
    ],
    deviceRules: {
      A1M: {
        visible: ['element_only_for_a1m'],
        hidden: ['element_hidden_for_a1m']
      },
      // Add new device types:
      NEW_DEVICE: {
        visible: ['element_for_new_device'],
        hidden: ['element_hidden_for_new_device']
      }
    }
  }
};

// Example: Creating conditional visibility
function exampleConditionalVisibility() {
  // Show element only if certain conditions are met
  const shouldShow = someCondition && anotherCondition;
  toggleElement('my_element_id', shouldShow);

  // Show different elements based on feature flags
  if (FEATURE_FLAGS.newFeature) {
    showElement('new_feature_button');
  } else {
    hideElement('new_feature_button');
  }

  // Show element only for specific logo selection
  if (state.SWAP_MODE === 'printflow') {
    showElement('printflow_specific_option');
  } else {
    hideElement('printflow_specific_option');
  }
}

// Example: Custom visibility function for complex logic
function exampleCustomVisibility(appMode, deviceMode, userSettings) {
  // Complex logic that can't be easily expressed in rules
  const isAdvancedUser = userSettings.advanced === true;
  const isPowerDevice = ['X1', 'P1'].includes(deviceMode);

  if (isAdvancedUser && isPowerDevice && appMode === 'SWAP') {
    showElement('advanced_settings_panel');
  } else {
    hideElement('advanced_settings_panel');
  }

  // Show different panels based on multiple conditions
  const showExpertMode = isAdvancedUser && deviceMode !== 'A1M';
  toggleElement('expert_mode_panel', showExpertMode);
}

// Example: Adding new printer support
const EXAMPLE_NEW_PRINTER_RULES = {
  SWAP: {
    deviceRules: {
      // Add support for new printer model
      'NEW_PRINTER': {
        visible: [
          'logo', // Standard swap logo
          'new_printer_specific_setting',
          'export_button'
        ],
        hidden: [
          'swap_mode_logos', // No dual logos for this printer
          'ams_optimization' // No AMS for this printer
        ]
      }
    }
  },
  PUSHOFF: {
    deviceRules: {
      'NEW_PRINTER': {
        visible: [
          'pushoff_logo',
          'new_printer_pushoff_setting'
        ],
        hidden: [
          'test_file_export_container' // No test files in pushoff
        ]
      }
    }
  }
};

export {
  EXAMPLE_UI_ELEMENTS,
  EXAMPLE_MODE_RULES,
  exampleConditionalVisibility,
  exampleCustomVisibility,
  EXAMPLE_NEW_PRINTER_RULES
};