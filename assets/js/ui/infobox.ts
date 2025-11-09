/**
 * Infobox module for displaying messages (error, warning, info, success)
 */

type MessageType = 'error' | 'warning' | 'info' | 'success';

let infoboxContainer: HTMLDivElement | null = null;

/**
 * Initialize the infobox container and insert it into the DOM
 */
export function initInfobox(): void {
  if (infoboxContainer) return; // Already initialized

  // Create infobox container
  infoboxContainer = document.createElement('div');
  infoboxContainer.id = 'infobox_container';
  infoboxContainer.className = 'infobox-container';

  // Insert above drop zone
  const dropZonesWrapper = document.getElementById('drop_zones_wrapper');
  if (dropZonesWrapper && dropZonesWrapper.parentNode) {
    dropZonesWrapper.parentNode.insertBefore(infoboxContainer, dropZonesWrapper);
  } else {
    console.warn('drop_zones_wrapper not found, appending infobox to body');
    document.body.appendChild(infoboxContainer);
  }
}

/**
 * Show a message in the infobox
 * @param message - The message text to display
 * @param type - The type of message (error, warning, info, success)
 * @param duration - Auto-hide duration in milliseconds (0 to disable auto-hide)
 * @param allowHTML - Whether to allow HTML in the message content
 * @returns The created infobox element
 */
export function showMessage(
  message: string,
  type: MessageType = 'info',
  duration: number = 20000,
  allowHTML: boolean = false
): HTMLDivElement {
  if (!infoboxContainer) {
    initInfobox();
  }

  // Create infobox element
  const infobox = document.createElement('div');
  infobox.className = `infobox infobox-${type}`;

  // Message content
  const messageContent = document.createElement('div');
  messageContent.className = 'infobox-content';

  if (allowHTML) {
    messageContent.innerHTML = message;
  } else {
    messageContent.textContent = message;
  }

  // Close button
  const closeBtn = document.createElement('button');
  closeBtn.className = 'infobox-close';
  closeBtn.innerHTML = '×';
  closeBtn.onclick = () => hideMessage(infobox);

  infobox.appendChild(messageContent);
  infobox.appendChild(closeBtn);

  // Add to container
  infoboxContainer!.appendChild(infobox);

  // Auto-hide after duration (if specified)
  if (duration > 0) {
    setTimeout(() => {
      if (infobox.parentNode) {
        hideMessage(infobox);
      }
    }, duration);
  }

  return infobox;
}

/**
 * Hide a specific message element
 * @param infobox - The infobox element to hide
 */
export function hideMessage(infobox: HTMLDivElement): void {
  if (infobox && infobox.parentNode) {
    infobox.style.opacity = '0';
    setTimeout(() => {
      if (infobox.parentNode) {
        infobox.parentNode.removeChild(infobox);
      }
    }, 300); // Match CSS transition duration
  }
}

/**
 * Clear all messages from the infobox container
 */
export function clearAllMessages(): void {
  if (infoboxContainer) {
    while (infoboxContainer.firstChild) {
      infoboxContainer.removeChild(infoboxContainer.firstChild);
    }
  }
}

/**
 * Show an error message
 * @param message - The error message text
 * @param duration - Auto-hide duration in milliseconds
 * @param allowHTML - Whether to allow HTML in the message
 * @returns The created infobox element
 */
export function showError(message: string, duration: number = 20000, allowHTML: boolean = false): HTMLDivElement {
  return showMessage(message, 'error', duration, allowHTML);
}

/**
 * Show a warning message
 * @param message - The warning message text
 * @param duration - Auto-hide duration in milliseconds
 * @param allowHTML - Whether to allow HTML in the message
 * @returns The created infobox element
 */
export function showWarning(message: string, duration: number = 20000, allowHTML: boolean = false): HTMLDivElement {
  return showMessage(message, 'warning', duration, allowHTML);
}

/**
 * Show an info message
 * @param message - The info message text
 * @param duration - Auto-hide duration in milliseconds
 * @param allowHTML - Whether to allow HTML in the message
 * @returns The created infobox element
 */
export function showInfo(message: string, duration: number = 20000, allowHTML: boolean = false): HTMLDivElement {
  return showMessage(message, 'info', duration, allowHTML);
}

/**
 * Show a success message
 * @param message - The success message text
 * @param duration - Auto-hide duration in milliseconds
 * @param allowHTML - Whether to allow HTML in the message
 * @returns The created infobox element
 */
export function showSuccess(message: string, duration: number = 20000, allowHTML: boolean = false): HTMLDivElement {
  return showMessage(message, 'success', duration, allowHTML);
}
