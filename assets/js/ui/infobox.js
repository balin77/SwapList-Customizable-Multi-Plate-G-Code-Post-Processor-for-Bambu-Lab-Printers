// Infobox module for displaying messages (error, warning, info, success)

let infoboxContainer = null;

// Initialize infobox
export function initInfobox() {
  if (infoboxContainer) return; // Already initialized

  // Create infobox container
  infoboxContainer = document.createElement('div');
  infoboxContainer.id = 'infobox_container';
  infoboxContainer.className = 'infobox-container';

  // Insert above drop zone
  const dropZonesWrapper = document.getElementById('drop_zones_wrapper');
  if (dropZonesWrapper) {
    dropZonesWrapper.parentNode.insertBefore(infoboxContainer, dropZonesWrapper);
  } else {
    console.warn('drop_zones_wrapper not found, appending infobox to body');
    document.body.appendChild(infoboxContainer);
  }
}

// Show message in infobox
export function showMessage(message, type = 'info', duration = 20000) {
  if (!infoboxContainer) {
    initInfobox();
  }

  // Create infobox element
  const infobox = document.createElement('div');
  infobox.className = `infobox infobox-${type}`;
  
  // Message content
  const messageContent = document.createElement('div');
  messageContent.className = 'infobox-content';
  messageContent.textContent = message;
  
  // Close button
  const closeBtn = document.createElement('button');
  closeBtn.className = 'infobox-close';
  closeBtn.innerHTML = '×';
  closeBtn.onclick = () => hideMessage(infobox);
  
  infobox.appendChild(messageContent);
  infobox.appendChild(closeBtn);
  
  // Add to container
  infoboxContainer.appendChild(infobox);
  
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

// Hide specific message
export function hideMessage(infobox) {
  if (infobox && infobox.parentNode) {
    infobox.style.opacity = '0';
    setTimeout(() => {
      if (infobox.parentNode) {
        infobox.parentNode.removeChild(infobox);
      }
    }, 300); // Match CSS transition duration
  }
}

// Clear all messages
export function clearAllMessages() {
  if (infoboxContainer) {
    while (infoboxContainer.firstChild) {
      infoboxContainer.removeChild(infoboxContainer.firstChild);
    }
  }
}

// Convenience methods
export function showError(message, duration = 20000) {
  return showMessage(message, 'error', duration);
}

export function showWarning(message, duration = 20000) {
  return showMessage(message, 'warning', duration);
}

export function showInfo(message, duration = 20000) {
  return showMessage(message, 'info', duration);
}

export function showSuccess(message, duration = 20000) {
  return showMessage(message, 'success', duration);
}