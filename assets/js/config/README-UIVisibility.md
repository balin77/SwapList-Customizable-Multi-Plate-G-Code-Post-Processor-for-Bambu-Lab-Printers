# UI Visibility Configuration System

This centralized system manages when UI elements are shown or hidden based on the current app mode (SWAP/PUSHOFF) and device type (A1M/A1/X1/P1).

## Files

- **`uiVisibility.js`** - Main configuration file with all visibility rules
- **`uiVisibility.example.js`** - Examples and patterns for extending the system
- **`README-UIVisibility.md`** - This documentation

## How It Works

### 1. Element Registration
All UI elements are registered in `UI_ELEMENTS` with their DOM IDs:

```javascript
export const UI_ELEMENTS = {
  TEST_FILE_EXPORT: 'test_file_export_container',
  PURGE_PLATE: 'opt_purge_plate',
  // ... more elements
};
```

### 2. Visibility Rules
Rules are defined for each app mode with device-specific overrides:

```javascript
export const VISIBILITY_RULES = {
  PUSHOFF: {
    visible: ['pushoff_logo', 'export_gcode_button'],
    hidden: ['test_file_export', 'swap_logo'],
    deviceRules: {
      A1M: { visible: ['printer_sounds'], hidden: [] },
      X1: { visible: [], hidden: ['printer_sounds'] }
    }
  },
  SWAP: {
    // Similar structure for SWAP mode
  }
};
```

### 3. Automatic Application
The system automatically applies rules when:
- App mode changes (SWAP ↔ PUSHOFF)
- Device type is detected/changed
- Manual calls to `applyVisibilityRules()`

## Adding New Elements

### Step 1: Register the Element
Add the element to `UI_ELEMENTS`:

```javascript
export const UI_ELEMENTS = {
  // Existing elements...
  MY_NEW_FEATURE: 'my_feature_container',
};
```

### Step 2: Add Visibility Rules
Add the element to the appropriate visibility lists:

```javascript
export const VISIBILITY_RULES = {
  SWAP: {
    visible: [
      // Existing elements...
      UI_ELEMENTS.MY_NEW_FEATURE,
    ],
    deviceRules: {
      A1M: {
        visible: [UI_ELEMENTS.MY_NEW_FEATURE],
        hidden: []
      },
      X1: {
        visible: [],
        hidden: [UI_ELEMENTS.MY_NEW_FEATURE] // Hide for X1
      }
    }
  }
};
```

## Adding New Device Support

Add device-specific rules for new printer models:

```javascript
deviceRules: {
  // Existing devices...
  'NEW_PRINTER': {
    visible: ['logo', 'export_button'],
    hidden: ['swap_mode_logos']
  }
}
```

## Advanced Usage

### Conditional Visibility
For complex logic that can't be expressed in simple rules:

```javascript
import { showElement, hideElement, toggleElement } from './uiVisibility.js';

// Show element only under specific conditions
if (complexCondition && anotherCondition) {
  showElement(UI_ELEMENTS.COMPLEX_FEATURE);
} else {
  hideElement(UI_ELEMENTS.COMPLEX_FEATURE);
}
```

### Global Rules
Elements that should always be visible/hidden regardless of mode:

```javascript
export const GLOBAL_RULES = {
  alwaysVisible: [UI_ELEMENTS.APP_MODE_TOGGLE],
  alwaysHidden: [UI_ELEMENTS.DEPRECATED_FEATURE]
};
```

## Current Element Mapping

| UI Element | ID | Visible In | Notes |
|------------|----|-----------:|-------|
| Test File Export | `test_file_export_container` | SWAP only | Hidden in PUSHOFF mode |
| AMS Optimization | `ams-optimization-settings` | SWAP A1/A1M | Only for AMS-enabled devices |
| Printer Sounds | `printer-sounds-settings` | A1/A1M only | Not available for X1/P1 |
| Secure Pushoff | `opt_secure_pushoff` | PUSHOFF only | Push-off specific setting |
| Purge Options | `opt_purge_plate` | SWAP X1/P1 | Advanced printer features |

## Integration Points

The system is automatically integrated into:
- **`initialize.js`** - `updateAppModeDisplay()` function
- **`mode.js`** - `setMode()` function
- **Theme system** - Applied alongside color themes

## Benefits

1. **Centralized Control** - All visibility logic in one place
2. **Easy Maintenance** - Simple to add new elements or change rules
3. **Consistent Behavior** - Same rules applied everywhere
4. **Device-Specific** - Fine-grained control per printer model
5. **Mode-Aware** - Different rules for SWAP vs PUSHOFF modes

## Migration from Old System

The old system used scattered `classList.add('hidden')` calls throughout the codebase. This new system replaces those with centralized, declarative rules that are easier to understand and maintain.