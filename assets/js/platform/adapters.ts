/**
 * Platform Adapters
 *
 * Provides platform-agnostic interfaces for file operations and downloads.
 * Automatically uses the correct implementation based on environment (Web vs Tauri).
 */

import { isTauri } from './detection.js';

/**
 * Select a file using native dialog (Tauri) or browser file input (Web)
 *
 * @param accept - File extension filter (e.g., '.3mf,.gcode')
 * @returns Promise<File | null>
 */
export async function selectFile(accept?: string): Promise<File | null> {
  if (isTauri()) {
    // Tauri: Use native file dialog
    try {
      const { open } = await import('@tauri-apps/plugin-dialog');
      const { readFile } = await import('@tauri-apps/plugin-fs');

      const extensions = accept
        ? accept.split(',').map(ext => ext.trim().replace('.', ''))
        : undefined;

      const filePath = await open({
        multiple: false,
        directory: false,
        filters: extensions ? [{
          name: '3D Printing Files',
          extensions
        }] : undefined
      });

      if (!filePath || Array.isArray(filePath)) return null;

      // Read file content
      const content = await readFile(filePath);
      const filename = filePath.split(/[/\\]/).pop() || 'file';

      return new File([content], filename, {
        type: getMimeType(filename)
      });
    } catch (error) {
      console.error('[Platform] Failed to select file (Tauri):', error);
      return null;
    }
  } else {
    // Web: Use browser file input
    return new Promise((resolve) => {
      const input = document.createElement('input');
      input.type = 'file';
      if (accept) input.accept = accept;
      input.style.display = 'none';

      input.onchange = () => {
        const file = input.files?.[0] || null;
        document.body.removeChild(input);
        resolve(file);
      };

      input.oncancel = () => {
        document.body.removeChild(input);
        resolve(null);
      };

      document.body.appendChild(input);
      input.click();
    });
  }
}

/**
 * Download a file using native save dialog (Tauri) or browser download (Web)
 *
 * @param filename - Target filename
 * @param data - File content (Blob, string, or Uint8Array)
 * @returns Promise<boolean> - true if saved successfully
 */
export async function downloadFile(
  filename: string,
  data: Blob | string | Uint8Array
): Promise<boolean> {
  console.log('[Platform] downloadFile called:', { filename, isTauri: isTauri() });

  if (isTauri()) {
    console.log('[Platform] Using Tauri native save dialog');
    // Tauri: Use native save dialog
    try {
      console.log('[Platform] Importing Tauri plugins...');
      const { save } = await import('@tauri-apps/plugin-dialog');
      const { writeFile } = await import('@tauri-apps/plugin-fs');
      console.log('[Platform] Tauri plugins imported successfully');

      const ext = filename.split('.').pop()?.toLowerCase();
      const filters = ext ? [{
        name: getFilterName(ext),
        extensions: [ext]
      }] : undefined;

      console.log('[Platform] Opening native save dialog with:', { filename, filters });
      const savePath = await save({
        defaultPath: filename,
        filters
      });
      console.log('[Platform] Save dialog returned:', savePath);

      if (!savePath) {
        console.log('[Platform] Save cancelled by user');
        return false;
      }

      // Convert data to Uint8Array
      let content: Uint8Array;
      if (data instanceof Blob) {
        const arrayBuffer = await data.arrayBuffer();
        content = new Uint8Array(arrayBuffer);
      } else if (typeof data === 'string') {
        const encoder = new TextEncoder();
        content = encoder.encode(data);
      } else {
        content = data;
      }

      // Write file
      await writeFile(savePath, content);

      console.log(`[Platform] File saved: ${savePath}`);
      return true;
    } catch (error) {
      console.error('[Platform] Failed to save file (Tauri):', error);
      return false;
    }
  } else {
    // Web: Use browser download
    try {
      const blob = data instanceof Blob ? data : new Blob([data]);
      const url = URL.createObjectURL(blob);

      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      link.style.display = 'none';

      document.body.appendChild(link);
      link.click();

      setTimeout(() => {
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
      }, 100);

      return true;
    } catch (error) {
      console.error('[Platform] Failed to download file (Web):', error);
      return false;
    }
  }
}

/**
 * Get MIME type from filename
 */
function getMimeType(filename: string): string {
  const ext = filename.split('.').pop()?.toLowerCase();

  switch (ext) {
    case '3mf':
      return 'application/vnd.ms-package.3dmanufacturing-3dmodel+xml';
    case 'gcode':
      return 'text/x-gcode';
    case 'zip':
      return 'application/zip';
    default:
      return 'application/octet-stream';
  }
}

/**
 * Get filter name for file extension
 */
function getFilterName(ext: string): string {
  switch (ext) {
    case 'gcode':
      return 'GCODE Files';
    case '3mf':
      return '3MF Files';
    case 'zip':
      return 'ZIP Archives';
    default:
      return 'All Files';
  }
}
