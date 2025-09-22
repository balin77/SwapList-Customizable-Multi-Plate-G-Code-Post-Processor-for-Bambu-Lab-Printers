export const project_settings_template = {
    "accel_to_decel_enable": "0",
    "accel_to_decel_factor": "50%",
    "activate_air_filtration": [
        "0",
        "0"
    ],
    "additional_cooling_fan_speed": [
        "70",
        "70"
    ],
    "apply_scarf_seam_on_circles": "1",
    "apply_top_surface_compensation": "0",
    "auxiliary_fan": "0",
    "bed_custom_model": "",
    "bed_custom_texture": "",
    "bed_exclude_area": [],
    "bed_temperature_formula": "by_first_filament",
    "before_layer_change_gcode": "",
    "best_object_pos": "0.5,0.5",
    "bottom_color_penetration_layers": "3",
    "bottom_shell_layers": "3",
    "bottom_shell_thickness": "0",
    "bottom_surface_pattern": "monotonic",
    "bridge_angle": "0",
    "bridge_flow": "1",
    "bridge_no_support": "0",
    "bridge_speed": [
        "50"
    ],
    "brim_object_gap": "0.1",
    "brim_type": "auto_brim",
    "brim_width": "5",
    "chamber_temperatures": [
        "0",
        "0"
    ],
    "change_filament_gcode": ";===== A1 20250206 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nM620.10 A0 F[old_filament_e_feedrate]\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\nM620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[nozzle_temperature_range_high]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n",
    "circle_compensation_manual_offset": "0",
    "circle_compensation_speed": [
        "200",
        "200"
    ],
    "close_fan_the_first_x_layers": [
        "1",
        "1"
    ],
    "complete_print_exhaust_fan_speed": [
        "70",
        "70"
    ],
    "cool_plate_temp": [
        "35",
        "35"
    ],
    "cool_plate_temp_initial_layer": [
        "35",
        "35"
    ],
    "counter_coef_1": [
        "0",
        "0"
    ],
    "counter_coef_2": [
        "0.008",
        "0.008"
    ],
    "counter_coef_3": [
        "-0.041",
        "-0.041"
    ],
    "counter_limit_max": [
        "0.033",
        "0.033"
    ],
    "counter_limit_min": [
        "-0.035",
        "-0.035"
    ],
    "curr_bed_type": "Textured PEI Plate",
    "default_acceleration": [
        "6000"
    ],
    "default_filament_colour": [
        "",
        ""
    ],
    "default_filament_profile": [
        "Bambu PLA Basic @BBL A1"
    ],
    "default_jerk": "0",
    "default_nozzle_volume_type": [
        "Standard"
    ],
    "default_print_profile": "0.20mm Standard @BBL A1",
    "deretraction_speed": [
        "30"
    ],
    "detect_floating_vertical_shell": "1",
    "detect_narrow_internal_solid_infill": "1",
    "detect_overhang_wall": "1",
    "detect_thin_wall": "0",
    "diameter_limit": [
        "50",
        "50"
    ],
    "draft_shield": "disabled",
    "during_print_exhaust_fan_speed": [
        "70",
        "70"
    ],
    "elefant_foot_compensation": "0.075",
    "enable_arc_fitting": "1",
    "enable_circle_compensation": "0",
    "enable_height_slowdown": [
        "0"
    ],
    "enable_long_retraction_when_cut": "2",
    "enable_overhang_bridge_fan": [
        "1",
        "1"
    ],
    "enable_overhang_speed": [
        "1"
    ],
    "enable_pre_heating": "0",
    "enable_pressure_advance": [
        "0",
        "0"
    ],
    "enable_prime_tower": "1",
    "enable_support": "0",
    "enable_wrapping_detection": "0",
    "enforce_support_layers": "0",
    "eng_plate_temp": [
        "0",
        "0"
    ],
    "eng_plate_temp_initial_layer": [
        "0",
        "0"
    ],
    "ensure_vertical_shell_thickness": "enabled",
    "exclude_object": "1",
    "extruder_ams_count": [
        "1#0|4#0",
        "1#0|4#0"
    ],
    "extruder_clearance_dist_to_rod": "56.5",
    "extruder_clearance_height_to_lid": "256",
    "extruder_clearance_height_to_rod": "25",
    "extruder_clearance_max_radius": "73",
    "extruder_colour": [
        "#018001"
    ],
    "extruder_offset": [
        "0x0"
    ],
    "extruder_printable_area": [],
    "extruder_printable_height": [],
    "extruder_type": [
        "Direct Drive"
    ],
    "extruder_variant_list": [
        "Direct Drive Standard"
    ],
    "fan_cooling_layer_time": [
        "80",
        "80"
    ],
    "fan_max_speed": [
        "80",
        "80"
    ],
    "fan_min_speed": [
        "60",
        "60"
    ],
    "filament_adaptive_volumetric_speed": [
        "0",
        "0"
    ],
    "filament_adhesiveness_category": [
        "100",
        "100"
    ],
    "filament_change_length": [
        "10",
        "10"
    ],
    "filament_colour": [
        "#C12E1E",
        "#FFFF00"
    ],
    "filament_colour_type": [
        "0",
        "1"
    ],
    "filament_cost": [
        "25.4",
        "25.4"
    ],
    "filament_density": [
        "1.31",
        "1.31"
    ],
    "filament_deretraction_speed": [
        "nil",
        "nil"
    ],
    "filament_diameter": [
        "1.75",
        "1.75"
    ],
    "filament_end_gcode": [
        "; filament end gcode \n\n",
        "; filament end gcode \n\n"
    ],
    "filament_extruder_variant": [
        "Direct Drive Standard",
        "Direct Drive Standard"
    ],
    "filament_flow_ratio": [
        "0.98",
        "0.98"
    ],
    "filament_flush_temp": [
        "0",
        "0"
    ],
    "filament_flush_volumetric_speed": [
        "0",
        "0"
    ],
    "filament_ids": [
        "GFL01",
        "GFL01"
    ],
    "filament_is_support": [
        "0",
        "0"
    ],
    "filament_long_retractions_when_cut": [
        "nil",
        "nil"
    ],
    "filament_map": [
        "1",
        "1"
    ],
    "filament_map_mode": "Auto For Flush",
    "filament_max_volumetric_speed": [
        "22",
        "22"
    ],
    "filament_minimal_purge_on_wipe_tower": [
        "15",
        "15"
    ],
    "filament_multi_colour": [
        "#C12E1E",
        "#FFFF00"
    ],
    "filament_notes": "",
    "filament_pre_cooling_temperature": [
        "0",
        "0"
    ],
    "filament_prime_volume": [
        "45",
        "45"
    ],
    "filament_printable": [
        "3",
        "3"
    ],
    "filament_ramming_travel_time": [
        "0",
        "0"
    ],
    "filament_ramming_volumetric_speed": [
        "-1",
        "-1"
    ],
    "filament_retract_before_wipe": [
        "nil",
        "nil"
    ],
    "filament_retract_restart_extra": [
        "nil",
        "nil"
    ],
    "filament_retract_when_changing_layer": [
        "nil",
        "nil"
    ],
    "filament_retraction_distances_when_cut": [
        "nil",
        "nil"
    ],
    "filament_retraction_length": [
        "nil",
        "nil"
    ],
    "filament_retraction_minimum_travel": [
        "nil",
        "nil"
    ],
    "filament_retraction_speed": [
        "nil",
        "nil"
    ],
    "filament_scarf_gap": [
        "15%",
        "15%"
    ],
    "filament_scarf_height": [
        "10%",
        "10%"
    ],
    "filament_scarf_length": [
        "10",
        "10"
    ],
    "filament_scarf_seam_type": [
        "none",
        "none"
    ],
    "filament_self_index": [
        "1",
        "2"
    ],
    "filament_settings_id": [
        "PolyTerra PLA @BBL A1",
        "PolyTerra PLA @BBL A1"
    ],
    "filament_shrink": [
        "100%",
        "100%"
    ],
    "filament_soluble": [
        "0",
        "0"
    ],
    "filament_start_gcode": [
        "; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}",
        "; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
    ],
    "filament_type": [
        "PLA",
        "PLA"
    ],
    "filament_velocity_adaptation_factor": [
        "1",
        "1"
    ],
    "filament_vendor": [
        "Polymaker",
        "Polymaker"
    ],
    "filament_wipe": [
        "nil",
        "nil"
    ],
    "filament_wipe_distance": [
        "nil",
        "nil"
    ],
    "filament_z_hop": [
        "nil",
        "nil"
    ],
    "filament_z_hop_types": [
        "nil",
        "nil"
    ],
    "filename_format": "{input_filename_base}_{filament_type[0]}_{print_time}.gcode",
    "filter_out_gap_fill": "0",
    "first_layer_print_sequence": [
        "0"
    ],
    "flush_into_infill": "0",
    "flush_into_objects": "0",
    "flush_into_support": "1",
    "flush_multiplier": [
        "1"
    ],
    "flush_volumes_matrix": [
        "0",
        "512",
        "182",
        "0"
    ],
    "flush_volumes_vector": [
        "140",
        "140",
        "140",
        "140"
    ],
    "from": "project",
    "full_fan_speed_layer": [
        "0",
        "0"
    ],
    "fuzzy_skin": "none",
    "fuzzy_skin_point_distance": "0.8",
    "fuzzy_skin_thickness": "0.3",
    "gap_infill_speed": [
        "250"
    ],
    "gcode_add_line_number": "0",
    "gcode_flavor": "marlin",
    "grab_length": [
        "17.4"
    ],
    "has_scarf_joint_seam": "0",
    "head_wrap_detect_zone": [
        "226x224",
        "256x224",
        "256x256",
        "226x256"
    ],
    "hole_coef_1": [
        "0",
        "0"
    ],
    "hole_coef_2": [
        "-0.008",
        "-0.008"
    ],
    "hole_coef_3": [
        "0.23415",
        "0.23415"
    ],
    "hole_limit_max": [
        "0.22",
        "0.22"
    ],
    "hole_limit_min": [
        "0.088",
        "0.088"
    ],
    "host_type": "octoprint",
    "hot_plate_temp": [
        "65",
        "65"
    ],
    "hot_plate_temp_initial_layer": [
        "65",
        "65"
    ],
    "hotend_cooling_rate": [
        "2"
    ],
    "hotend_heating_rate": [
        "2"
    ],
    "impact_strength_z": [
        "10",
        "10"
    ],
    "independent_support_layer_height": "1",
    "infill_combination": "0",
    "infill_direction": "45",
    "infill_jerk": "9",
    "infill_lock_depth": "1",
    "infill_rotate_step": "0",
    "infill_shift_step": "0.4",
    "infill_wall_overlap": "15%",
    "initial_layer_acceleration": [
        "500"
    ],
    "initial_layer_flow_ratio": "1",
    "initial_layer_infill_speed": [
        "105"
    ],
    "initial_layer_jerk": "9",
    "initial_layer_line_width": "0.5",
    "initial_layer_print_height": "0.2",
    "initial_layer_speed": [
        "50"
    ],
    "initial_layer_travel_acceleration": [
        "6000"
    ],
    "inner_wall_acceleration": [
        "0"
    ],
    "inner_wall_jerk": "9",
    "inner_wall_line_width": "0.45",
    "inner_wall_speed": [
        "300"
    ],
    "interface_shells": "0",
    "interlocking_beam": "0",
    "interlocking_beam_layer_count": "2",
    "interlocking_beam_width": "0.8",
    "interlocking_boundary_avoidance": "2",
    "interlocking_depth": "2",
    "interlocking_orientation": "22.5",
    "internal_bridge_support_thickness": "0.8",
    "internal_solid_infill_line_width": "0.42",
    "internal_solid_infill_pattern": "zig-zag",
    "internal_solid_infill_speed": [
        "250"
    ],
    "ironing_direction": "45",
    "ironing_flow": "10%",
    "ironing_inset": "0.21",
    "ironing_pattern": "zig-zag",
    "ironing_spacing": "0.15",
    "ironing_speed": "30",
    "ironing_type": "no ironing",
    "is_infill_first": "0",
    "layer_change_gcode": "; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change",
    "layer_height": "0.2",
    "line_width": "0.42",
    "locked_skeleton_infill_pattern": "zigzag",
    "locked_skin_infill_pattern": "crosszag",
    "long_retractions_when_cut": [
        "0"
    ],
    "long_retractions_when_ec": [
        "0",
        "0"
    ],
    "machine_end_gcode": ";===== date: 20231229 =====================\nG392 S0 ;turn off nozzle clog detect\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-13.0 F3000 ; move to safe pos\n{if !spiral_mode && print_sequence != \"by object\"}\nM1002 judge_flag timelapse_record_flag\nM622 J1\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM991 S0 P-1 ;end timelapse at safe pos\nM623\n{endif}\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n;G1 X27 F15000 ; wipe\n\n; pull back filament to AMS\nM620 S255\nG1 X267 F15000\nT255\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nM621 S255\n\nM104 S0 ; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 256}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z256 F600\n    G1 Z256\n{endif}\nM400 P100\nM17 R ; restore z current\n\nG90\nG1 X-48 Y180 F3600\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N80\nM1006 A44 B20 L100 C49 D20 M80 E41 F20 N80\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N80\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n;=====printer finish  sound=========\n\n;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM400\nM18 X Y Z\n\n",
    "machine_load_filament_time": "25",
    "machine_max_acceleration_e": [
        "5000",
        "5000"
    ],
    "machine_max_acceleration_extruding": [
        "12000",
        "12000"
    ],
    "machine_max_acceleration_retracting": [
        "5000",
        "5000"
    ],
    "machine_max_acceleration_travel": [
        "9000",
        "9000"
    ],
    "machine_max_acceleration_x": [
        "12000",
        "12000"
    ],
    "machine_max_acceleration_y": [
        "12000",
        "12000"
    ],
    "machine_max_acceleration_z": [
        "1500",
        "1500"
    ],
    "machine_max_jerk_e": [
        "3",
        "3"
    ],
    "machine_max_jerk_x": [
        "9",
        "9"
    ],
    "machine_max_jerk_y": [
        "9",
        "9"
    ],
    "machine_max_jerk_z": [
        "3",
        "3"
    ],
    "machine_max_speed_e": [
        "30",
        "30"
    ],
    "machine_max_speed_x": [
        "500",
        "200"
    ],
    "machine_max_speed_y": [
        "500",
        "200"
    ],
    "machine_max_speed_z": [
        "30",
        "30"
    ],
    "machine_min_extruding_rate": [
        "0",
        "0"
    ],
    "machine_min_travel_rate": [
        "0",
        "0"
    ],
    "machine_pause_gcode": "M400 U1",
    "machine_prepare_compensation_time": "260",
    "machine_start_gcode": ";===== machine: A1 =========================\n;===== date: 20240620 =====================\nG392 S0\nM9833.2\n;M400\n;M73 P1.717\n\n;===== start to heat heatbead&hotend==========\nM1002 gcode_claim_action : 2\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM104 S140\nM140 S[bed_temperature_initial_layer_single]\n\n;=====start printer sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A43 B10 L100 C46 D10 M70 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C43 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C41 D10 M80 E41 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E44 F10 N80\nM1006 A0 B10 L100 C49 D10 M80 E49 F10 N80\nM1006 A0 B10 L100 C0 D10 M80 E0 F10 N80\nM1006 A44 B10 L100 C48 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A43 B10 L100 C46 D10 M60 E39 F10 N80\nM1006 W\nM18 \n;=====start printer sound ===================\n\n;=====avoid end stop =================\nG91\nG380 S2 Z40 F1200\nG380 S3 Z-15 F1200\nG90\n\n;===== reset machine status =================\n;M290 X39 Y39 Z8\nM204 S6000\n\nM630 S0 P0\nG91\nM17 Z0.3 ; lower the z-motor current\n\nG90\nM17 X0.65 Y1.2 Z0.6 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\n;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\nM1002 gcode_claim_action : 13\n\nG28 X\nG91\nG1 Z5 F1200\nG90\nG0 X128 F30000\nG0 Y254 F3000\nG91\nG1 Z-5 F1200\n\nM109 S25 H140\n\nM17 E0.3\nM83\nG1 E10 F1200\nG1 E-0.5 F30\nM17 D\n\nG28 Z P0 T140; home z with low precision,permit 300deg temperature\nM104 S{nozzle_temperature_initial_layer[initial_extruder]}\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n  G39.4\n  G90\n  G1 Z5 F1200\nM623\n\n;M400\n;M73 P1.717\n\n;===== prepare print temperature and material ==========\nM1002 gcode_claim_action : 24\n\nM400\n;G392 S1\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on\n\nG90\nG1 X-28.5 F30000\nG1 X-48.2 F3000\n\nM620 M ;enable remap\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M1002 gcode_claim_action : 4\n    M400\n    M1002 set_filament_type:UNKNOWN\n    M109 S[nozzle_temperature_initial_layer]\n    M104 S250\n    M400\n    T[initial_no_support_extruder]\n    G1 X-48.2 F3000\n    M400\n\n    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}\n    M109 S250 ;set nozzle to common flush temp\n    M106 P1 S0\n    G92 E0\n    G1 E50 F200\n    M400\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300\nG92 E0\nG1 E50 F200 ; lower extrusion speed to avoid clog\nM400\nM106 P1 S178\nG92 E0\nG1 E5 F200\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG92 E0\nG1 E-0.5 F300\n\nG1 X-28.5 F30000\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\n\n;G392 S0\n\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n;M400\n;M73 P1.717\n\n;===== auto extrude cali start =========================\nM975 S1\n;G392 S1\n\nG90\nM83\nT1000\nG1 X-48.2 Y0 Z10 F10000\nM400\nM1002 set_filament_type:UNKNOWN\n\nM412 S1 ;  ===turn on  filament runout detection===\nM400 P10\nM620.3 W1; === turn on filament tangle detection===\nM400 S2\n\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n;M1002 set_flag extrude_cali_flag=1\nM1002 judge_flag extrude_cali_flag\n\nM622 J1\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_extruder]}\n    G1 E10 F{outer_wall_volumetric_speed/2.4*60}\n    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n\n    M106 P1 S255\n    M400 S5\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\n\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n        M106 P1 S255\n        M400 S5\n        G1 X-28.5 F18000\n        G1 X-48.2 F3000\n        G1 X-28.5 F18000 ;wipe and shake\n        G1 X-48.2 F3000\n        G1 X-28.5 F12000 ;wipe and shake\n        M400\n        M106 P1 S0\n    M623\n    \n    G1 X-48.2 F3000\n    M400\n    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]\n    M106 P1 S178\n    M400 S7\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\nM623 ; end of \"draw extrinsic para cali paint\"\n\n;G392 S0\n;===== auto extrude cali end ========================\n\n;M400\n;M73 P1.717\n\nM104 S170 ; prepare to wipe nozzle\nM106 S255 ; turn on fan\n\n;===== mech mode fast check start =====================\nM1002 gcode_claim_action : 3\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q1 A5 K0 O3\nM974 Q1 S2 P0\n\nM970.2 Q1 K1 W58 Z0.1\nM974 S2\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q0 A10 K0 O1\nM974 Q0 S2 P0\n\nM970.2 Q0 K1 W78 Z0.1\nM974 S2\n\nM975 S1\nG1 F30000\nG1 X0 Y5\nG28 X ; re-home XY\n\nG1 Z4 F1200\n\n;===== mech mode fast check end =======================\n\n;M400\n;M73 P1.717\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\n\nM975 S1\nM106 S255 ; turn on fan (G28 has turn off fan)\nM211 S; push soft endstop status\nM211 X0 Y0 Z0 ;turn off Z axis endstop\n\n;===== remove waste by touching start =====\n\nM104 S170 ; set temp down to heatbed acceptable\n\nM83\nG1 E-1 F500\nG90\nM83\n\nM109 S170\nG0 X108 Y-0.5 F30000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X110 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X112 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X114 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X116 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X118 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X120 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X122 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X124 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X126 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X128 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X130 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X132 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X134 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X136 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X138 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X140 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X142 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X144 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X146 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X148 F10000\nG380 S3 Z-5 F1200\n\nG1 Z5 F30000\n;===== remove waste by touching end =====\n\nG1 Z10 F1200\nG0 X118 Y261 F30000\nG1 Z5 F1200\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-50}\n\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nM104 S140 ; prepare to abl\nG0 Z5 F20000\n\nG0 X128 Y261 F20000  ; move to exposed steel surface\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nG90\nG1 Z10 F1200\n\n;===== brush material wipe nozzle =====\n\nG90\nG1 Y250 F30000\nG1 X55\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X-35 F30000\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Z5.000 F1200\n\nG90\nG1 X30 Y250.000 F30000\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X35 F30000\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Z10.000 F1200\n\n;===== brush material wipe nozzle end =====\n\nG90\n;G0 X128 Y261 F20000  ; move to exposed steel surface\nG1 Y250 F30000\nG1 X138\nG1 Y261\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nM109 S140\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM211 R; pop softend status\n\n;===== wipe nozzle end ================================\n\n;M400\n;M73 P1.717\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\n\nG90\nG1 Z5 F1200\nG1 X0 Y0 F30000\nG29.2 S1 ; turn on ABL\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n\n;===== home after wipe mouth end =======================\n\n;M400\n;M73 P1.717\n\nG1 X108.000 Y-0.500 F30000\nG1 Z0.300 F1200\nM400\nG2814 Z0.32\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print\n\n;===== nozzle load line ===============================\n;G90\n;M83\n;G1 Z5 F1200\n;G1 X88 Y-0.5 F20000\n;G1 Z0.3 F1200\n\n;M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n\n;G1 E2 F300\n;G1 X168 E4.989 F6000\n;G1 Z1 F1200\n;===== nozzle load line end ===========================\n\n;===== extrude cali test ===============================\n\nM400\n    M900 S\n    M900 C\n    G90\n    M83\n\n    M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n    G0 X128 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\n\nM900 R\n\nM1002 judge_flag extrude_cali_flag\nM622 J1\n    G90\n    G1 X108.000 Y1.000 F30000\n    G91\n    G1 Z-0.700 F1200\n    G90\n    M83\n    G0 X128 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\nM623\n\nG1 Z0.2\n\n;M400\n;M73 P1.717\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type==\"Textured PEI Plate\"}\nG29.1 Z{-0.02} ; for Textured PEI Plate\n{endif}\n\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n\nM211 X0 Y0 Z0 ;turn off soft endstop\n;G392 S1 ; turn on clog detection\nM1007 S1 ; turn on mass estimation\nG29.4\n",
    "machine_switch_extruder_time": "0",
    "machine_unload_filament_time": "29",
    "master_extruder_id": "1",
    "max_bridge_length": "0",
    "max_layer_height": [
        "0.28"
    ],
    "max_travel_detour_distance": "0",
    "min_bead_width": "85%",
    "min_feature_size": "25%",
    "min_layer_height": [
        "0.08"
    ],
    "minimum_sparse_infill_area": "15",
    "mmu_segmented_region_interlocking_depth": "0",
    "mmu_segmented_region_max_width": "0",
    "name": "project_settings",
    "nozzle_diameter": [
        "0.4"
    ],
    "nozzle_flush_dataset": [
        "0"
    ],
    "nozzle_height": "4.76",
    "nozzle_temperature": [
        "220",
        "220"
    ],
    "nozzle_temperature_initial_layer": [
        "220",
        "220"
    ],
    "nozzle_temperature_range_high": [
        "240",
        "240"
    ],
    "nozzle_temperature_range_low": [
        "190",
        "190"
    ],
    "nozzle_type": [
        "stainless_steel"
    ],
    "nozzle_volume": [
        "92"
    ],
    "nozzle_volume_type": [
        "Standard"
    ],
    "only_one_wall_first_layer": "0",
    "ooze_prevention": "0",
    "other_layers_print_sequence": [
        "0"
    ],
    "other_layers_print_sequence_nums": "0",
    "outer_wall_acceleration": [
        "5000"
    ],
    "outer_wall_jerk": "9",
    "outer_wall_line_width": "0.42",
    "outer_wall_speed": [
        "200"
    ],
    "overhang_1_4_speed": [
        "0"
    ],
    "overhang_2_4_speed": [
        "50"
    ],
    "overhang_3_4_speed": [
        "30"
    ],
    "overhang_4_4_speed": [
        "10"
    ],
    "overhang_fan_speed": [
        "100",
        "100"
    ],
    "overhang_fan_threshold": [
        "50%",
        "50%"
    ],
    "overhang_threshold_participating_cooling": [
        "95%",
        "95%"
    ],
    "overhang_totally_speed": [
        "10"
    ],
    "override_filament_scarf_seam_setting": "0",
    "physical_extruder_map": [
        "0"
    ],
    "post_process": [],
    "pre_start_fan_time": [
        "0",
        "0"
    ],
    "precise_outer_wall": "0",
    "precise_z_height": "0",
    "pressure_advance": [
        "0.02",
        "0.02"
    ],
    "prime_tower_brim_width": "3",
    "prime_tower_enable_framework": "0",
    "prime_tower_extra_rib_length": "0",
    "prime_tower_fillet_wall": "1",
    "prime_tower_flat_ironing": "0",
    "prime_tower_infill_gap": "150%",
    "prime_tower_lift_height": "-1",
    "prime_tower_lift_speed": "90",
    "prime_tower_max_speed": "90",
    "prime_tower_rib_wall": "1",
    "prime_tower_rib_width": "8",
    "prime_tower_skip_points": "1",
    "prime_tower_width": "35",
    "print_compatible_printers": [
        "Bambu Lab A1 0.4 nozzle"
    ],
    "print_extruder_id": [
        "1"
    ],
    "print_extruder_variant": [
        "Direct Drive Standard"
    ],
    "print_flow_ratio": "1",
    "print_sequence": "by layer",
    "print_settings_id": "0.20mm Standard @BBL A1",
    "printable_area": [
        "0x0",
        "256x0",
        "256x256",
        "0x256"
    ],
    "printable_height": "256",
    "printer_extruder_id": [
        "1"
    ],
    "printer_extruder_variant": [
        "Direct Drive Standard"
    ],
    "printer_model": "Bambu Lab A1",
    "printer_notes": "",
    "printer_settings_id": "Bambu Lab A1 0.4 nozzle",
    "printer_structure": "i3",
    "printer_technology": "FFF",
    "printer_variant": "0.4",
    "printhost_authorization_type": "key",
    "printhost_ssl_ignore_revoke": "0",
    "printing_by_object_gcode": "",
    "process_notes": "",
    "raft_contact_distance": "0.1",
    "raft_expansion": "1.5",
    "raft_first_layer_density": "90%",
    "raft_first_layer_expansion": "-1",
    "raft_layers": "0",
    "reduce_crossing_wall": "0",
    "reduce_fan_stop_start_freq": [
        "1",
        "1"
    ],
    "reduce_infill_retraction": "1",
    "required_nozzle_HRC": [
        "3",
        "3"
    ],
    "resolution": "0.012",
    "retract_before_wipe": [
        "0%"
    ],
    "retract_length_toolchange": [
        "2"
    ],
    "retract_lift_above": [
        "0"
    ],
    "retract_lift_below": [
        "255"
    ],
    "retract_restart_extra": [
        "0"
    ],
    "retract_restart_extra_toolchange": [
        "0"
    ],
    "retract_when_changing_layer": [
        "1"
    ],
    "retraction_distances_when_cut": [
        "18"
    ],
    "retraction_distances_when_ec": [
        "0",
        "0"
    ],
    "retraction_length": [
        "0.8"
    ],
    "retraction_minimum_travel": [
        "1"
    ],
    "retraction_speed": [
        "30"
    ],
    "role_base_wipe_speed": "1",
    "scan_first_layer": "0",
    "scarf_angle_threshold": "155",
    "seam_gap": "15%",
    "seam_placement_away_from_overhangs": "0",
    "seam_position": "aligned",
    "seam_slope_conditional": "1",
    "seam_slope_entire_loop": "0",
    "seam_slope_gap": "0",
    "seam_slope_inner_walls": "1",
    "seam_slope_min_length": "10",
    "seam_slope_start_height": "10%",
    "seam_slope_steps": "10",
    "seam_slope_type": "none",
    "silent_mode": "0",
    "single_extruder_multi_material": "1",
    "skeleton_infill_density": "15%",
    "skeleton_infill_line_width": "0.45",
    "skin_infill_density": "15%",
    "skin_infill_depth": "2",
    "skin_infill_line_width": "0.45",
    "skirt_distance": "2",
    "skirt_height": "1",
    "skirt_loops": "0",
    "slice_closing_radius": "0.049",
    "slicing_mode": "regular",
    "slow_down_for_layer_cooling": [
        "1",
        "1"
    ],
    "slow_down_layer_time": [
        "8",
        "8"
    ],
    "slow_down_min_speed": [
        "20",
        "20"
    ],
    "slowdown_end_acc": [
        "100000"
    ],
    "slowdown_end_height": [
        "400"
    ],
    "slowdown_end_speed": [
        "1000"
    ],
    "slowdown_start_acc": [
        "100000"
    ],
    "slowdown_start_height": [
        "0"
    ],
    "slowdown_start_speed": [
        "1000"
    ],
    "small_perimeter_speed": [
        "50%"
    ],
    "small_perimeter_threshold": [
        "0"
    ],
    "smooth_coefficient": "80",
    "smooth_speed_discontinuity_area": "1",
    "solid_infill_filament": "1",
    "sparse_infill_acceleration": [
        "100%"
    ],
    "sparse_infill_anchor": "400%",
    "sparse_infill_anchor_max": "20",
    "sparse_infill_density": "15%",
    "sparse_infill_filament": "1",
    "sparse_infill_line_width": "0.45",
    "sparse_infill_pattern": "grid",
    "sparse_infill_speed": [
        "270"
    ],
    "spiral_mode": "0",
    "spiral_mode_max_xy_smoothing": "200%",
    "spiral_mode_smooth": "0",
    "standby_temperature_delta": "-5",
    "start_end_points": [
        "30x-3",
        "54x245"
    ],
    "supertack_plate_temp": [
        "45",
        "45"
    ],
    "supertack_plate_temp_initial_layer": [
        "45",
        "45"
    ],
    "support_air_filtration": "0",
    "support_angle": "0",
    "support_base_pattern": "default",
    "support_base_pattern_spacing": "2.5",
    "support_bottom_interface_spacing": "0.5",
    "support_bottom_z_distance": "0.2",
    "support_chamber_temp_control": "0",
    "support_critical_regions_only": "0",
    "support_expansion": "0",
    "support_filament": "0",
    "support_interface_bottom_layers": "2",
    "support_interface_filament": "0",
    "support_interface_loop_pattern": "0",
    "support_interface_not_for_body": "1",
    "support_interface_pattern": "auto",
    "support_interface_spacing": "0.5",
    "support_interface_speed": [
        "80"
    ],
    "support_interface_top_layers": "2",
    "support_line_width": "0.42",
    "support_object_first_layer_gap": "0.2",
    "support_object_xy_distance": "0.35",
    "support_on_build_plate_only": "0",
    "support_remove_small_overhang": "1",
    "support_speed": [
        "150"
    ],
    "support_style": "default",
    "support_threshold_angle": "30",
    "support_top_z_distance": "0.2",
    "support_type": "tree(auto)",
    "symmetric_infill_y_axis": "0",
    "temperature_vitrification": [
        "45",
        "45"
    ],
    "template_custom_gcode": "",
    "textured_plate_temp": [
        "65",
        "65"
    ],
    "textured_plate_temp_initial_layer": [
        "65",
        "65"
    ],
    "thick_bridges": "0",
    "thumbnail_size": [
        "50x50"
    ],
    "time_lapse_gcode": ";===================== date: 20250206 =====================\n{if !spiral_mode && print_sequence != \"by object\"}\n; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\nG92 E0\nG1 Z{max_layer_z + 0.4}\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-48.2 F3000 ; move to safe pos\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X0 F18000\nM623\n\n; SKIPTYPE: head_wrap_detect\nM622.1 S1\nM1002 judge_flag g39_3rd_layer_detect_flag\nM622 J1\n    ; enable nozzle clog detect at 3rd layer\n    {if layer_num == 2}\n      M400\n      G90\n      M83\n      M204 S5000\n      G0 Z2 F4000\n      G0 X261 Y250 F20000\n      M400 P200\n      G39 S1\n      G0 Z2 F4000\n    {endif}\n\n\n    M622.1 S1\n    M1002 judge_flag g39_detection_flag\n    M622 J1\n      {if !in_head_wrap_detect_zone}\n        M622.1 S0\n        M1002 judge_flag g39_mass_exceed_flag\n        M622 J1\n        {if layer_num > 2}\n            G392 S0\n            M400\n            G90\n            M83\n            M204 S5000\n            G0 Z{max_layer_z + 0.4} F4000\n            G39.3 S1\n            G0 Z{max_layer_z + 0.4} F4000\n            G392 S0\n          {endif}\n        M623\n    {endif}\n    M623\nM623\n; SKIPPABLE_END\n{endif}\n",
    "timelapse_type": "0",
    "top_area_threshold": "200%",
    "top_color_penetration_layers": "5",
    "top_one_wall_type": "all top",
    "top_shell_layers": "5",
    "top_shell_thickness": "1",
    "top_solid_infill_flow_ratio": "1",
    "top_surface_acceleration": [
        "2000"
    ],
    "top_surface_jerk": "9",
    "top_surface_line_width": "0.42",
    "top_surface_pattern": "monotonicline",
    "top_surface_speed": [
        "200"
    ],
    "travel_acceleration": [
        "10000"
    ],
    "travel_jerk": "9",
    "travel_speed": [
        "700"
    ],
    "travel_speed_z": [
        "0"
    ],
    "tree_support_branch_angle": "45",
    "tree_support_branch_diameter": "2",
    "tree_support_branch_diameter_angle": "5",
    "tree_support_branch_distance": "5",
    "tree_support_wall_count": "-1",
    "upward_compatible_machine": [
        "Bambu Lab H2D 0.4 nozzle",
        "Bambu Lab H2D Pro 0.4 nozzle",
        "Bambu Lab H2S 0.4 nozzle"
    ],
    "use_firmware_retraction": "0",
    "use_relative_e_distances": "1",
    "version": "02.02.02.56",
    "vertical_shell_speed": [
        "80%"
    ],
    "volumetric_speed_coefficients": [
        "0 0 0 0 0 0",
        "0 0 0 0 0 0"
    ],
    "wall_distribution_count": "1",
    "wall_filament": "1",
    "wall_generator": "classic",
    "wall_loops": "2",
    "wall_sequence": "inner wall/outer wall",
    "wall_transition_angle": "10",
    "wall_transition_filter_deviation": "25%",
    "wall_transition_length": "100%",
    "wipe": [
        "1"
    ],
    "wipe_distance": [
        "2"
    ],
    "wipe_speed": "80%",
    "wipe_tower_no_sparse_layers": "0",
    "wipe_tower_rotation_angle": "0",
    "wipe_tower_x": [
        "15"
    ],
    "wipe_tower_y": [
        "216.972"
    ],
    "wrapping_detection_gcode": "",
    "wrapping_detection_layers": "20",
    "wrapping_exclude_area": [],
    "xy_contour_compensation": "0",
    "xy_hole_compensation": "0",
    "z_direction_outwall_speed_continuous": "0",
    "z_hop": [
        "0.4"
    ],
    "z_hop_types": [
        "Auto Lift"
    ]
}
