// /src/config/xmlConfig.js
import { state } from "./state.js";
import { generateFilenameFormat } from "../io/ioUtils.js";

export function generateModelSettingsXml() {
  // Generate dynamic plater_name using same pattern as filename (without extension and basename)
  const platerName = generateFilenameFormat("", false).substring(1); // Remove leading dot

  return `<?xml version="1.0" encoding="UTF-8"?>
<config>
  <plate>
    <metadata key="plater_id" value="1"/>
    <metadata key="plater_name" value="${platerName}"/>
    <metadata key="locked" value="false"/>
    <metadata key="filament_map_mode" value="Auto For Flush"/>
    <metadata key="filament_maps" value="1 1 1"/>
    <metadata key="gcode_file" value="Metadata/plate_1.gcode"/>
    <metadata key="thumbnail_file" value="Metadata/plate_1.png"/>
    <metadata key="thumbnail_no_light_file" value="Metadata/plate_no_light_1.png"/>
    <metadata key="top_file" value="Metadata/top_1.png"/>
    <metadata key="pick_file" value="Metadata/pick_1.png"/>
    <metadata key="pattern_bbox_file" value="Metadata/plate_1.json"/>
  </plate>
</config>`;
}

// Keep the old export for backward compatibility, but mark as deprecated
export const model_settings_xml = generateModelSettingsXml();
