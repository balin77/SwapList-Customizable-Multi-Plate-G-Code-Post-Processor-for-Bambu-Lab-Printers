; clearbed printer:A1 mode:swap submode:3print plates:1 settings:[metadata_override] date:2025-10-17T13:16:46.545Z
; HEADER_BLOCK_START
; BambuStudio 02.02.02.56
; model printing time: 21m 29s; total estimated time: 27m 45s
; total layer number: 128
; total filament length [mm] : 2140.51
; total filament volume [cm^3] : 5148.53
; total filament weight [g] : 6.74
; filament_density: 1.31,1.31,1.31,1.31
; filament_diameter: 1.75,1.75,1.75,1.75
; max_z_height: 25.60
; filament: 2
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0
; additional_cooling_fan_speed = 70,70,70,70
; apply_scarf_seam_on_circles = 1
; apply_top_surface_compensation = 0
; auxiliary_fan = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0,0,0,0
; change_filament_gcode = ;===== A1 20250206 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nM620.10 A0 F[old_filament_e_feedrate]\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\nM620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[nozzle_temperature_range_high]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200,200
; close_fan_the_first_x_layers = 1,1,1,1
; complete_print_exhaust_fan_speed = 70,70,70,70
; cool_plate_temp = 35,35,35,35
; cool_plate_temp_initial_layer = 35,35,35,35
; counter_coef_1 = 0,0,0,0
; counter_coef_2 = 0.008,0.008,0.008,0.008
; counter_coef_3 = -0.041,-0.041,-0.041,-0.041
; counter_limit_max = 0.033,0.033,0.033,0.033
; counter_limit_min = -0.035,-0.035,-0.035,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 6000
; default_filament_colour = ;;;
; default_filament_profile = "Bambu PLA Basic @BBL A1"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL A1
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50,50
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70
; elefant_foot_compensation = 0.075
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1,1,1,1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0,0,0,0
; enable_prime_tower = 0
; enable_support = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 0,0,0,0
; eng_plate_temp_initial_layer = 0,0,0,0
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 56.5
; extruder_clearance_height_to_lid = 256
; extruder_clearance_height_to_rod = 25
; extruder_clearance_max_radius = 73
; extruder_colour = #018001
; extruder_offset = 0x0
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard"
; fan_cooling_layer_time = 80,80,80,80
; fan_max_speed = 80,80,80,80
; fan_min_speed = 60,60,60,60
; filament_adaptive_volumetric_speed = 0,0,0,0
; filament_adhesiveness_category = 100,100,100,100
; filament_change_length = 10,10,10,10
; filament_colour = #FFFFFF;#E9AFCF;#443089;#A03CF7
; filament_colour_type = 0;0;0;0
; filament_cost = 25.4,25.4,25.4,25.4
; filament_density = 1.31,1.31,1.31,1.31
; filament_diameter = 1.75,1.75,1.75,1.75
; filament_end_gcode = "; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n"
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.98,0.98,0.98,0.98
; filament_flush_temp = 0,0,0,0
; filament_flush_volumetric_speed = 0,0,0,0
; filament_ids = GFL01;GFL01;GFL01;GFL01
; filament_is_support = 0,0,0,0
; filament_map = 1,1,1,1
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 22,22,22,22
; filament_minimal_purge_on_wipe_tower = 15,15,15,15
; filament_multi_colour = #FFFFFF;#E9AFCF;#443089;#A03CF7
; filament_notes = 
; filament_pre_cooling_temperature = 0,0,0,0
; filament_prime_volume = 45,45,45,45
; filament_printable = 3,3,3,3
; filament_ramming_travel_time = 0,0,0,0
; filament_ramming_volumetric_speed = -1,-1,-1,-1
; filament_scarf_gap = 15%,15%,15%,15%
; filament_scarf_height = 10%,10%,10%,10%
; filament_scarf_length = 10,10,10,10
; filament_scarf_seam_type = none,none,none,none
; filament_self_index = 1,2,3,4
; filament_settings_id = "PolyTerra PLA @BBL A1";"PolyTerra PLA @BBL A1";"PolyTerra PLA @BBL A1";"PolyTerra PLA @BBL A1"
; filament_shrink = 100%,100%,100%,100%
; filament_soluble = 0,0,0,0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_type = PLA;PLA;PLA;PLA
; filament_velocity_adaptation_factor = 1,1,1,1
; filament_vendor = Polymaker;Polymaker;Polymaker;Polymaker
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,155,213,287,323,0,201,252,594,493,0,326,575,447,196,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 17.4
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 226x224,256x224,256x256,226x256
; hole_coef_1 = 0,0,0,0
; hole_coef_2 = -0.008,-0.008,-0.008,-0.008
; hole_coef_3 = 0.23415,0.23415,0.23415,0.23415
; hole_limit_max = 0.22,0.22,0.22,0.22
; hole_limit_min = 0.088,0.088,0.088,0.088
; host_type = octoprint
; hot_plate_temp = 65,65,65,65
; hot_plate_temp_initial_layer = 65,65,65,65
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 10,10,10,10
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 50
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 300
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 250
; ironing_direction = 45
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0,0,0,0
; machine_end_gcode = ;===== date: 20231229 =====================\nG392 S0 ;turn off nozzle clog detect\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-13.0 F3000 ; move to safe pos\n{if !spiral_mode && print_sequence != "by object"}\nM1002 judge_flag timelapse_record_flag\nM622 J1\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM991 S0 P-1 ;end timelapse at safe pos\nM623\n{endif}\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n;G1 X27 F15000 ; wipe\n\n; pull back filament to AMS\nM620 S255\nG1 X267 F15000\nT255\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nM621 S255\n\nM104 S0 ; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 256}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z256 F600\n    G1 Z256\n{endif}\nM400 P100\nM17 R ; restore z current\n\nG90\nG1 X-48 Y180 F3600\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N80\nM1006 A44 B20 L100 C49 D20 M80 E41 F20 N80\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N80\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n;=====printer finish  sound=========\n\n;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM400\nM18 X Y Z\n\n
; machine_load_filament_time = 25
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 12000,12000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 12000,12000
; machine_max_acceleration_y = 12000,12000
; machine_max_acceleration_z = 1500,1500
; machine_max_jerk_e = 3,3
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: A1 =========================\n;===== date: 20240620 =====================\nG392 S0\nM9833.2\n;M400\n;M73 P1.717\n\n;===== start to heat heatbead&hotend==========\nM1002 gcode_claim_action : 2\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM104 S140\nM140 S[bed_temperature_initial_layer_single]\n\n;=====start printer sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A43 B10 L100 C46 D10 M70 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C43 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C41 D10 M80 E41 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E44 F10 N80\nM1006 A0 B10 L100 C49 D10 M80 E49 F10 N80\nM1006 A0 B10 L100 C0 D10 M80 E0 F10 N80\nM1006 A44 B10 L100 C48 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A43 B10 L100 C46 D10 M60 E39 F10 N80\nM1006 W\nM18 \n;=====start printer sound ===================\n\n;=====avoid end stop =================\nG91\nG380 S2 Z40 F1200\nG380 S3 Z-15 F1200\nG90\n\n;===== reset machine status =================\n;M290 X39 Y39 Z8\nM204 S6000\n\nM630 S0 P0\nG91\nM17 Z0.3 ; lower the z-motor current\n\nG90\nM17 X0.65 Y1.2 Z0.6 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\n;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\nM1002 gcode_claim_action : 13\n\nG28 X\nG91\nG1 Z5 F1200\nG90\nG0 X128 F30000\nG0 Y254 F3000\nG91\nG1 Z-5 F1200\n\nM109 S25 H140\n\nM17 E0.3\nM83\nG1 E10 F1200\nG1 E-0.5 F30\nM17 D\n\nG28 Z P0 T140; home z with low precision,permit 300deg temperature\nM104 S{nozzle_temperature_initial_layer[initial_extruder]}\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n  G39.4\n  G90\n  G1 Z5 F1200\nM623\n\n;M400\n;M73 P1.717\n\n;===== prepare print temperature and material ==========\nM1002 gcode_claim_action : 24\n\nM400\n;G392 S1\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on\n\nG90\nG1 X-28.5 F30000\nG1 X-48.2 F3000\n\nM620 M ;enable remap\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M1002 gcode_claim_action : 4\n    M400\n    M1002 set_filament_type:UNKNOWN\n    M109 S[nozzle_temperature_initial_layer]\n    M104 S250\n    M400\n    T[initial_no_support_extruder]\n    G1 X-48.2 F3000\n    M400\n\n    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}\n    M109 S250 ;set nozzle to common flush temp\n    M106 P1 S0\n    G92 E0\n    G1 E50 F200\n    M400\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300\nG92 E0\nG1 E50 F200 ; lower extrusion speed to avoid clog\nM400\nM106 P1 S178\nG92 E0\nG1 E5 F200\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG92 E0\nG1 E-0.5 F300\n\nG1 X-28.5 F30000\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\n\n;G392 S0\n\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n;M400\n;M73 P1.717\n\n;===== auto extrude cali start =========================\nM975 S1\n;G392 S1\n\nG90\nM83\nT1000\nG1 X-48.2 Y0 Z10 F10000\nM400\nM1002 set_filament_type:UNKNOWN\n\nM412 S1 ;  ===turn on  filament runout detection===\nM400 P10\nM620.3 W1; === turn on filament tangle detection===\nM400 S2\n\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n;M1002 set_flag extrude_cali_flag=1\nM1002 judge_flag extrude_cali_flag\n\nM622 J1\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_extruder]}\n    G1 E10 F{outer_wall_volumetric_speed/2.4*60}\n    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n\n    M106 P1 S255\n    M400 S5\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\n\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n        M106 P1 S255\n        M400 S5\n        G1 X-28.5 F18000\n        G1 X-48.2 F3000\n        G1 X-28.5 F18000 ;wipe and shake\n        G1 X-48.2 F3000\n        G1 X-28.5 F12000 ;wipe and shake\n        M400\n        M106 P1 S0\n    M623\n    \n    G1 X-48.2 F3000\n    M400\n    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]\n    M106 P1 S178\n    M400 S7\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\nM623 ; end of "draw extrinsic para cali paint"\n\n;G392 S0\n;===== auto extrude cali end ========================\n\n;M400\n;M73 P1.717\n\nM104 S170 ; prepare to wipe nozzle\nM106 S255 ; turn on fan\n\n;===== mech mode fast check start =====================\nM1002 gcode_claim_action : 3\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q1 A5 K0 O3\nM974 Q1 S2 P0\n\nM970.2 Q1 K1 W58 Z0.1\nM974 S2\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q0 A10 K0 O1\nM974 Q0 S2 P0\n\nM970.2 Q0 K1 W78 Z0.1\nM974 S2\n\nM975 S1\nG1 F30000\nG1 X0 Y5\nG28 X ; re-home XY\n\nG1 Z4 F1200\n\n;===== mech mode fast check end =======================\n\n;M400\n;M73 P1.717\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\n\nM975 S1\nM106 S255 ; turn on fan (G28 has turn off fan)\nM211 S; push soft endstop status\nM211 X0 Y0 Z0 ;turn off Z axis endstop\n\n;===== remove waste by touching start =====\n\nM104 S170 ; set temp down to heatbed acceptable\n\nM83\nG1 E-1 F500\nG90\nM83\n\nM109 S170\nG0 X108 Y-0.5 F30000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X110 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X112 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X114 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X116 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X118 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X120 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X122 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X124 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X126 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X128 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X130 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X132 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X134 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X136 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X138 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X140 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X142 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X144 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X146 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X148 F10000\nG380 S3 Z-5 F1200\n\nG1 Z5 F30000\n;===== remove waste by touching end =====\n\nG1 Z10 F1200\nG0 X118 Y261 F30000\nG1 Z5 F1200\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-50}\n\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nM104 S140 ; prepare to abl\nG0 Z5 F20000\n\nG0 X128 Y261 F20000  ; move to exposed steel surface\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nG90\nG1 Z10 F1200\n\n;===== brush material wipe nozzle =====\n\nG90\nG1 Y250 F30000\nG1 X55\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X-35 F30000\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Z5.000 F1200\n\nG90\nG1 X30 Y250.000 F30000\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X35 F30000\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Z10.000 F1200\n\n;===== brush material wipe nozzle end =====\n\nG90\n;G0 X128 Y261 F20000  ; move to exposed steel surface\nG1 Y250 F30000\nG1 X138\nG1 Y261\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nM109 S140\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM211 R; pop softend status\n\n;===== wipe nozzle end ================================\n\n;M400\n;M73 P1.717\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\n\nG90\nG1 Z5 F1200\nG1 X0 Y0 F30000\nG29.2 S1 ; turn on ABL\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n\n;===== home after wipe mouth end =======================\n\n;M400\n;M73 P1.717\n\nG1 X108.000 Y-0.500 F30000\nG1 Z0.300 F1200\nM400\nG2814 Z0.32\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print\n\n;===== nozzle load line ===============================\n;G90\n;M83\n;G1 Z5 F1200\n;G1 X88 Y-0.5 F20000\n;G1 Z0.3 F1200\n\n;M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n\n;G1 E2 F300\n;G1 X168 E4.989 F6000\n;G1 Z1 F1200\n;===== nozzle load line end ===========================\n\n;===== extrude cali test ===============================\n\nM400\n    M900 S\n    M900 C\n    G90\n    M83\n\n    M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n    G0 X128 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\n\nM900 R\n\nM1002 judge_flag extrude_cali_flag\nM622 J1\n    G90\n    G1 X108.000 Y1.000 F30000\n    G91\n    G1 Z-0.700 F1200\n    G90\n    M83\n    G0 X128 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\nM623\n\nG1 Z0.2\n\n;M400\n;M73 P1.717\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.02} ; for Textured PEI Plate\n{endif}\n\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n\nM211 X0 Y0 Z0 ;turn off soft endstop\n;G392 S1 ; turn on clog detection\nM1007 S1 ; turn on mass estimation\nG29.4\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 29
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 0
; nozzle_height = 4.76
; nozzle_temperature = 220,220,220,220
; nozzle_temperature_initial_layer = 220,220,220,220
; nozzle_temperature_range_high = 240,240,240,240
; nozzle_temperature_range_low = 190,190,190,190
; nozzle_type = stainless_steel
; nozzle_volume = 92
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100,100,100,100
; overhang_fan_threshold = 50%,50%,50%,50%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0,0,0,0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 0
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; print_compatible_printers = "Bambu Lab A1 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL A1
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 256
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab A1
; printer_notes = 
; printer_settings_id = Bambu Lab A1 0.4 nozzle
; printer_structure = i3
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1,1,1,1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 255
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0,0,0,0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1,1,1,1
; slow_down_layer_time = 8,8,8,8
; slow_down_min_speed = 20,20,20,20
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 80
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 1
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 15%
; sparse_infill_filament = 1
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = grid
; sparse_infill_speed = 270
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 45,45,45,45
; supertack_plate_temp_initial_layer = 45,45,45,45
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 2
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45,45,45,45
; template_custom_gcode = 
; textured_plate_temp = 65,65,65,65
; textured_plate_temp_initial_layer = 65,65,65,65
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;===================== date: 20250206 =====================\n{if !spiral_mode && print_sequence != "by object"}\n; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\nG92 E0\nG1 Z{max_layer_z + 0.4}\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-48.2 F3000 ; move to safe pos\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X0 F18000\nM623\n\n; SKIPTYPE: head_wrap_detect\nM622.1 S1\nM1002 judge_flag g39_3rd_layer_detect_flag\nM622 J1\n    ; enable nozzle clog detect at 3rd layer\n    {if layer_num == 2}\n      M400\n      G90\n      M83\n      M204 S5000\n      G0 Z2 F4000\n      G0 X261 Y250 F20000\n      M400 P200\n      G39 S1\n      G0 Z2 F4000\n    {endif}\n\n\n    M622.1 S1\n    M1002 judge_flag g39_detection_flag\n    M622 J1\n      {if !in_head_wrap_detect_zone}\n        M622.1 S0\n        M1002 judge_flag g39_mass_exceed_flag\n        M622 J1\n        {if layer_num > 2}\n            G392 S0\n            M400\n            G90\n            M83\n            M204 S5000\n            G0 Z{max_layer_z + 0.4} F4000\n            G39.3 S1\n            G0 Z{max_layer_z + 0.4} F4000\n            G392 S0\n          {endif}\n        M623\n    {endif}\n    M623\nM623\n; SKIPPABLE_END\n{endif}\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 200
; travel_acceleration = 10000
; travel_jerk = 9
; travel_speed = 700
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 1
; wall_generator = classic
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 216.972
; wrapping_detection_gcode = 
; wrapping_detection_layers = 20
; wrapping_exclude_area = 
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START

; ==== A1 PLATE_GRAB_ONLY ====
G91                     ; relative positioning
G380 S2 Z50 F1200       ; lift Z by 50mm
G380 S3 Z-20 F1200      ; lower Z by 20mm
G90                     ; return to absolute positioning
G28 XY                  ; home XY axes
G0  X-10 F5000          ; move X slightly out of the way

; --- Grab/Set Sequence ---
;M211 S0                 ; disable soft endstops
G0  Y0   F2500          ; "grab": grip at the back
G0  Y170 F2000          ; "pull": plate forward
G0  Y43 F2000           ; rehook
G0  Y266 F2000          ; pull new plate forward
G0  Y20 F2000           ; move to "set" position
G4  P500
G0  Y0 F300             ; snap plate
G0  Y5 F300             ; let plate fall
G4  P500
G0  X150 Y150 F5000          ; safe park position
G28 Z                   ; home Z axis
; ==== End GRAB_ONLY ====; start printing plate 1
M73 P0 R27
M201 X12000 Y12000 Z1500 E5000
M203 X500 Y500 Z30 E30
M204 P12000 R5000 T12000
M205 X9.00 Y9.00 Z3.00 E3.00
; FEATURE: Custom
;===== machine: A1 =========================
;===== date: 20240620 =====================
G392 S0
M9833.2
;M400
;M73 P1.717

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2
M1002 set_filament_type:PLA
M104 S140
M140 S65

;=====start printer sound ===================

;=====avoid end stop =================
G91
G380 S2 Z40 F1200
G380 S3 Z-15 F1200
G90

;===== reset machine status =================
;M290 X39 Y39 Z8
M204 S6000

M630 S0 P0
G91
M17 Z0.3 ; lower the z-motor current

G90
M17 X0.65 Y1.2 Z0.6 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

M1002 gcode_claim_action : 13

G28 X
G91
G1 Z5 F1200
G90
G0 X128 F30000
G0 Y254 F3000
G91
G1 Z-5 F1200

M109 S25 H140

M17 E0.3
M83
G1 E10 F1200
G1 E-0.5 F30
M17 D

G28 Z P0 T140; home z with low precision,permit 300deg temperature
M104 S220

M1002 judge_flag build_plate_detect_flag
M622 S1
  G39.4
  G90
  G1 Z5 F1200
M623

;M400
;M73 P1.717

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24

M400
;G392 S1
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on

G90
G1 X-28.5 F30000
G1 X-48.2 F3000

M620 M ;enable remap
M620 S1A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S220
    M104 S250
    M400
    T1
    G1 X-48.2 F3000
    M400

    M620.1 E F548.788 T240
    M109 S250 ;set nozzle to common flush temp
    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:PLA
M621 S1A

M109 S240 H300
G92 E0
G1 E50 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S178
G92 E0
G1 E5 F200
M104 S220
G92 E0
M73 P2 R27
G1 E-0.5 F300

G1 X-28.5 F30000
M73 P2 R26
G1 X-48.2 F3000
M73 P3 R26
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000

;G392 S0

M400
M106 P1 S0
;===== prepare print temperature and material end =====

;M400
;M73 P1.717

;===== auto extrude cali start =========================
M975 S1
;G392 S1

G90
M83
T1000
G1 X-48.2 Y0 Z10 F10000
M400
M1002 set_filament_type:UNKNOWN

M412 S1 ;  ===turn on  filament runout detection===
M400 P10
M620.3 W1; === turn on filament tangle detection===
M400 S2

M1002 set_filament_type:PLA

;M1002 set_flag extrude_cali_flag=1
M1002 judge_flag extrude_cali_flag

M622 J1
    M1002 gcode_claim_action : 8

    M109 S220
M73 P4 R26
    G1 E10 F377.08
    M983 F6.28466 A0.3 H0.4; cali dynamic extrusion compensation

    M106 P1 S255
    M400 S5
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0

    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F6.28466 A0.3 H0.4; cali dynamic extrusion compensation
        M106 P1 S255
        M400 S5
M73 P5 R26
        G1 X-28.5 F18000
        G1 X-48.2 F3000
        G1 X-28.5 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-28.5 F12000 ;wipe and shake
        M400
        M106 P1 S0
    M623
    
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F6.28466 H0.4
    M106 P1 S178
    M400 S7
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0
M623 ; end of "draw extrinsic para cali paint"

;G392 S0
;===== auto extrude cali end ========================

;M400
;M73 P1.717

M104 S170 ; prepare to wipe nozzle
M106 S255 ; turn on fan

;===== mech mode fast check start =====================
M1002 gcode_claim_action : 3

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q1 A5 K0 O3
M974 Q1 S2 P0

M970.2 Q1 K1 W58 Z0.1
M974 S2

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q0 A10 K0 O1
M974 Q0 S2 P0

M970.2 Q0 K1 W78 Z0.1
M974 S2

M975 S1
G1 F30000
G1 X0 Y5
G28 X ; re-home XY

G1 Z4 F1200

;===== mech mode fast check end =======================

;M400
;M73 P1.717

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14

M975 S1
M106 S255 ; turn on fan (G28 has turn off fan)
M211 S; push soft endstop status
M211 X0 Y0 Z0 ;turn off Z axis endstop

;===== remove waste by touching start =====

M104 S170 ; set temp down to heatbed acceptable

M83
G1 E-1 F500
G90
M83

M109 S170
G0 X108 Y-0.5 F30000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X110 F10000
G380 S3 Z-5 F1200
M73 P21 R21
G1 Z2 F1200
G1 X112 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X114 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X116 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X118 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X120 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X122 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X124 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X126 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X128 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X130 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X132 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X134 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X136 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X138 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X140 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X142 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X144 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X146 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X148 F10000
G380 S3 Z-5 F1200

G1 Z5 F30000
;===== remove waste by touching end =====

G1 Z10 F1200
G0 X118 Y261 F30000
G1 Z5 F1200
M109 S170

G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
M104 S140 ; prepare to abl
G0 Z5 F20000

G0 X128 Y261 F20000  ; move to exposed steel surface
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

G90
G1 Z10 F1200

;===== brush material wipe nozzle =====

G90
G1 Y250 F30000
G1 X55
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X-35 F30000
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200

G90
G1 X30 Y250.000 F30000
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X35 F30000
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200

;===== brush material wipe nozzle end =====

G90
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000
G1 X138
G1 Y261
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
M73 P22 R21
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

M109 S140
M106 S255 ; turn on fan (G28 has turn off fan)

M211 R; pop softend status

;===== wipe nozzle end ================================

;M400
;M73 P1.717

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag

G90
G1 Z5 F1200
G1 X0 Y0 F30000
G29.2 S1 ; turn on ABL

M190 S65; ensure bed temp
M109 S140
M106 S0 ; turn off fan , too noisy

M622 J1
    M1002 gcode_claim_action : 1
    G29 A1 X115.2 Y115.2 I25.6 J25.6
    M400
    M500 ; save cali data
M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623

;===== home after wipe mouth end =======================

;M400
;M73 P1.717

G1 X108.000 Y-0.500 F30000
G1 Z0.300 F1200
M400
G2814 Z0.32

M104 S220 ; prepare to print

;===== nozzle load line ===============================
;G90
;M83
;G1 Z5 F1200
;G1 X88 Y-0.5 F20000
;G1 Z0.3 F1200

;M109 S220

;G1 E2 F300
;G1 X168 E4.989 F6000
;G1 Z1 F1200
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400
    M900 S
    M900 C
    G90
    M83

    M109 S220
    G0 X128 E8  F904.991
    G0 X133 E.3742  F1508.32
    G0 X138 E.3742  F6033.27
    G0 X143 E.3742  F1508.32
    G0 X148 E.3742  F6033.27
    G0 X153 E.3742  F1508.32
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400

M900 R

M1002 judge_flag extrude_cali_flag
M622 J1
    G90
    G1 X108.000 Y1.000 F30000
    G91
    G1 Z-0.700 F1200
    G90
    M83
    G0 X128 E10  F904.991
    G0 X133 E.3742  F1508.32
    G0 X138 E.3742  F6033.27
    G0 X143 E.3742  F1508.32
    G0 X148 E.3742  F6033.27
    G0 X153 E.3742  F1508.32
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400
M623

G1 Z0.2

;M400
;M73 P1.717

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.02 ; for Textured PEI Plate


M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4
; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S255


;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/128
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
; OBJECT_ID: 69
G1 X140.018 Y140.018 F42000
M204 S6000
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X115.982 Y140.018 E.89525
G1 X115.982 Y115.982 E.89525
G1 X140.018 Y115.982 E.89525
G1 X140.018 Y139.958 E.89301
M204 S6000
G1 X140.475 Y140.475 F42000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X115.525 Y140.475 E.92929
G1 X115.525 Y115.525 E.92929
G1 X140.475 Y115.525 E.92929
G1 X140.475 Y140.415 E.92706
; WIPE_START
G1 X138.475 Y140.42 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X138.906 Y116.165 F42000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50236
G1 F6300
M204 S500
G1 X139.629 Y116.888 E.0383
G1 X139.629 Y117.538 E.02433
G1 X138.462 Y116.371 E.06181
G1 X137.812 Y116.371 E.02433
G1 X139.629 Y118.188 E.09621
G1 X139.629 Y118.837 E.02433
G1 X137.163 Y116.371 E.13061
G1 X136.513 Y116.371 E.02433
G1 X139.629 Y119.487 E.16501
G1 X139.629 Y120.137 E.02433
G1 X135.863 Y116.371 E.19941
G1 X135.213 Y116.371 E.02433
G1 X139.629 Y120.787 E.23381
G1 X139.629 Y121.436 E.02433
G1 X134.564 Y116.371 E.26822
G1 X133.914 Y116.371 E.02433
G1 X139.629 Y122.086 E.30262
G1 X139.629 Y122.736 E.02433
G1 X133.264 Y116.371 E.33702
G1 X132.614 Y116.371 E.02433
G1 X139.629 Y123.386 E.37142
G1 X139.629 Y124.035 E.02433
G1 X131.965 Y116.371 E.40582
G1 X131.315 Y116.371 E.02433
G1 X139.629 Y124.685 E.44022
G1 X139.629 Y125.335 E.02433
G1 X130.665 Y116.371 E.47463
G1 X130.015 Y116.371 E.02433
G1 X139.629 Y125.985 E.50903
G1 X139.629 Y126.634 E.02433
G1 X129.366 Y116.371 E.54343
G1 X128.716 Y116.371 E.02433
M73 P23 R21
G1 X139.629 Y127.284 E.57783
G1 X139.629 Y127.934 E.02433
G1 X128.066 Y116.371 E.61223
G1 X127.416 Y116.371 E.02433
G1 X139.629 Y128.584 E.64663
G1 X139.629 Y129.233 E.02433
G1 X126.767 Y116.371 E.68103
G1 X126.117 Y116.371 E.02433
G1 X139.629 Y129.883 E.71544
G1 X139.629 Y130.533 E.02433
G1 X125.467 Y116.371 E.74984
G1 X124.817 Y116.371 E.02433
G1 X139.629 Y131.183 E.78424
G1 X139.629 Y131.832 E.02433
G1 X124.168 Y116.371 E.81864
G1 X123.518 Y116.371 E.02433
G1 X139.629 Y132.482 E.85304
G1 X139.629 Y133.132 E.02433
G1 X122.868 Y116.371 E.88744
G1 X122.218 Y116.371 E.02433
G1 X139.629 Y133.782 E.92185
G1 X139.629 Y134.431 E.02433
G1 X121.569 Y116.371 E.95625
G1 X120.919 Y116.371 E.02433
G1 X139.629 Y135.081 E.99065
G1 X139.629 Y135.731 E.02433
G1 X120.269 Y116.371 E1.02505
G1 X119.619 Y116.371 E.02433
G1 X139.629 Y136.381 E1.05945
G1 X139.629 Y137.03 E.02433
G1 X118.97 Y116.371 E1.09385
G1 X118.32 Y116.371 E.02433
G1 X139.629 Y137.68 E1.12825
G1 X139.629 Y138.33 E.02433
G1 X117.67 Y116.371 E1.16266
G1 X117.02 Y116.371 E.02433
G1 X139.629 Y138.98 E1.19706
G1 X139.629 Y139.629 E.02433
G1 X116.371 Y116.371 E1.23146
G1 X116.371 Y117.02 E.02432
G1 X138.98 Y139.629 E1.19707
G1 X138.33 Y139.629 E.02433
G1 X116.371 Y117.67 E1.16267
G1 X116.371 Y118.32 E.02433
G1 X137.68 Y139.629 E1.12827
G1 X137.031 Y139.629 E.02433
G1 X116.371 Y118.969 E1.09386
G1 X116.371 Y119.619 E.02433
G1 X136.381 Y139.629 E1.05946
G1 X135.731 Y139.629 E.02433
G1 X116.371 Y120.269 E1.02506
G1 X116.371 Y120.919 E.02433
G1 X135.081 Y139.629 E.99066
G1 X134.432 Y139.629 E.02433
G1 X116.371 Y121.568 E.95626
G1 X116.371 Y122.218 E.02433
G1 X133.782 Y139.629 E.92186
G1 X133.132 Y139.629 E.02433
G1 X116.371 Y122.868 E.88746
G1 X116.371 Y123.518 E.02433
G1 X132.482 Y139.629 E.85305
G1 X131.833 Y139.629 E.02433
G1 X116.371 Y124.167 E.81865
G1 X116.371 Y124.817 E.02433
G1 X131.183 Y139.629 E.78425
G1 X130.533 Y139.629 E.02433
G1 X116.371 Y125.467 E.74985
G1 X116.371 Y126.117 E.02433
G1 X129.883 Y139.629 E.71545
G1 X129.234 Y139.629 E.02433
G1 X116.371 Y126.766 E.68105
G1 X116.371 Y127.416 E.02433
G1 X128.584 Y139.629 E.64664
G1 X127.934 Y139.629 E.02433
G1 X116.371 Y128.066 E.61224
G1 X116.371 Y128.716 E.02433
G1 X127.284 Y139.629 E.57784
G1 X126.635 Y139.629 E.02433
G1 X116.371 Y129.365 E.54344
G1 X116.371 Y130.015 E.02433
G1 X125.985 Y139.629 E.50904
G1 X125.335 Y139.629 E.02433
M73 P24 R21
G1 X116.371 Y130.665 E.47464
G1 X116.371 Y131.315 E.02433
G1 X124.685 Y139.629 E.44024
G1 X124.036 Y139.629 E.02433
G1 X116.371 Y131.964 E.40583
G1 X116.371 Y132.614 E.02433
G1 X123.386 Y139.629 E.37143
G1 X122.736 Y139.629 E.02433
G1 X116.371 Y133.264 E.33703
G1 X116.371 Y133.914 E.02433
G1 X122.086 Y139.629 E.30263
G1 X121.437 Y139.629 E.02433
G1 X116.371 Y134.563 E.26823
G1 X116.371 Y135.213 E.02433
G1 X120.787 Y139.629 E.23383
G1 X120.137 Y139.629 E.02433
G1 X116.371 Y135.863 E.19943
G1 X116.371 Y136.513 E.02433
G1 X119.487 Y139.629 E.16502
G1 X118.838 Y139.629 E.02433
G1 X116.371 Y137.162 E.13062
G1 X116.371 Y137.812 E.02433
G1 X118.188 Y139.629 E.09622
G1 X117.538 Y139.629 E.02433
G1 X116.371 Y138.462 E.06182
G1 X116.371 Y139.112 E.02433
G1 X117.094 Y139.835 E.03831
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X116.371 Y139.112 E-.38882
G1 X116.371 Y138.462 E-.2469
G1 X116.602 Y138.693 E-.12428
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/128
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S201.45
; open powerlost recovery
M1003 S1
; OBJECT_ID: 69
M204 S10000
G17
M73 P24 R20
G3 Z.6 I-.077 J1.214 P1  F42000
G1 X140.198 Y140.198 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X139.268 Y140.034 F42000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42171
G1 F15000
M204 S6000
G1 X139.865 Y139.438 E.02603
G1 X139.865 Y138.902 E.01653
G1 X138.902 Y139.865 E.042
G1 X138.367 Y139.865 E.01653
G1 X139.865 Y138.367 E.06539
G1 X139.865 Y137.831 E.01653
G1 X137.831 Y139.865 E.08877
G1 X137.295 Y139.865 E.01653
G1 X139.865 Y137.295 E.11215
G1 X139.865 Y136.76 E.01653
G1 X136.76 Y139.865 E.13554
G1 X136.224 Y139.865 E.01653
G1 X139.865 Y136.224 E.15892
G1 X139.865 Y135.688 E.01653
G1 X135.688 Y139.865 E.18231
G1 X135.153 Y139.865 E.01653
G1 X139.865 Y135.153 E.20569
G1 X139.865 Y134.617 E.01653
G1 X134.617 Y139.865 E.22907
G1 X134.081 Y139.865 E.01653
G1 X139.865 Y134.081 E.25246
G1 X139.865 Y133.546 E.01653
G1 X133.546 Y139.865 E.27584
G1 X133.01 Y139.865 E.01653
G1 X139.865 Y133.01 E.29923
G1 X139.865 Y132.474 E.01653
G1 X132.474 Y139.865 E.32261
G1 X131.938 Y139.865 E.01653
G1 X139.865 Y131.938 E.34599
G1 X139.865 Y131.403 E.01653
G1 X131.403 Y139.865 E.36938
G1 X130.867 Y139.865 E.01653
G1 X139.865 Y130.867 E.39276
G1 X139.865 Y130.331 E.01653
G1 X130.331 Y139.865 E.41615
G1 X129.796 Y139.865 E.01653
G1 X139.865 Y129.796 E.43953
G1 X139.865 Y129.26 E.01653
G1 X129.26 Y139.865 E.46291
G1 X128.724 Y139.865 E.01653
G1 X139.865 Y128.724 E.4863
G1 X139.865 Y128.189 E.01653
G1 X128.189 Y139.865 E.50968
G1 X127.653 Y139.865 E.01653
G1 X139.865 Y127.653 E.53307
G1 X139.865 Y127.117 E.01653
G1 X127.117 Y139.865 E.55645
G1 X126.582 Y139.865 E.01653
G1 X139.865 Y126.582 E.57983
G1 X139.865 Y126.046 E.01653
G1 X126.046 Y139.865 E.60322
G1 X125.51 Y139.865 E.01653
G1 X139.865 Y125.51 E.6266
G1 X139.865 Y124.975 E.01653
G1 X124.975 Y139.865 E.64998
G1 X124.439 Y139.865 E.01653
G1 X139.865 Y124.439 E.67337
G1 X139.865 Y123.903 E.01653
G1 X123.903 Y139.865 E.69675
G1 X123.367 Y139.865 E.01653
G1 X139.865 Y123.367 E.72014
G1 X139.865 Y122.832 E.01653
G1 X122.832 Y139.865 E.74352
G1 X122.296 Y139.865 E.01653
G1 X139.865 Y122.296 E.7669
G1 X139.865 Y121.76 E.01653
G1 X121.76 Y139.865 E.79029
G1 X121.225 Y139.865 E.01653
G1 X139.865 Y121.225 E.81367
G1 X139.865 Y120.689 E.01653
G1 X120.689 Y139.865 E.83706
G1 X120.153 Y139.865 E.01653
G1 X139.865 Y120.153 E.86044
G1 X139.865 Y119.618 E.01653
G1 X119.618 Y139.865 E.88382
G1 X119.082 Y139.865 E.01653
G1 X139.865 Y119.082 E.90721
G1 X139.865 Y118.546 E.01653
G1 X118.546 Y139.865 E.93059
G1 X118.011 Y139.865 E.01653
G1 X139.865 Y118.011 E.95398
G1 X139.865 Y117.475 E.01653
G1 X117.475 Y139.865 E.97736
G1 X116.939 Y139.865 E.01653
G1 X139.865 Y116.939 E1.00074
G1 X139.865 Y116.403 E.01653
G1 X116.403 Y139.865 E1.02413
G1 X116.135 Y139.865 E.00828
G1 X116.135 Y139.597 E.00826
G1 X139.597 Y116.135 E1.02415
G1 X139.061 Y116.135 E.01653
G1 X116.135 Y139.061 E1.00077
G1 X116.135 Y138.526 E.01653
G1 X138.526 Y116.135 E.97739
G1 X137.99 Y116.135 E.01653
G1 X116.135 Y137.99 E.954
G1 X116.135 Y137.454 E.01653
G1 X137.454 Y116.135 E.93062
G1 X136.919 Y116.135 E.01653
G1 X116.135 Y136.919 E.90723
G1 X116.135 Y136.383 E.01653
G1 X136.383 Y116.135 E.88385
M73 P25 R20
G1 X135.847 Y116.135 E.01653
G1 X116.135 Y135.847 E.86047
G1 X116.135 Y135.312 E.01653
G1 X135.312 Y116.135 E.83708
G1 X134.776 Y116.135 E.01653
G1 X116.135 Y134.776 E.8137
G1 X116.135 Y134.24 E.01653
G1 X134.24 Y116.135 E.79031
G1 X133.705 Y116.135 E.01653
G1 X116.135 Y133.705 E.76693
G1 X116.135 Y133.169 E.01653
G1 X133.169 Y116.135 E.74355
G1 X132.633 Y116.135 E.01653
G1 X116.135 Y132.633 E.72016
G1 X116.135 Y132.097 E.01653
G1 X132.097 Y116.135 E.69678
G1 X131.562 Y116.135 E.01653
G1 X116.135 Y131.562 E.6734
G1 X116.135 Y131.026 E.01653
G1 X131.026 Y116.135 E.65001
G1 X130.49 Y116.135 E.01653
G1 X116.135 Y130.49 E.62663
G1 X116.135 Y129.955 E.01653
G1 X129.955 Y116.135 E.60324
G1 X129.419 Y116.135 E.01653
G1 X116.135 Y129.419 E.57986
G1 X116.135 Y128.883 E.01653
G1 X128.883 Y116.135 E.55648
G1 X128.348 Y116.135 E.01653
G1 X116.135 Y128.348 E.53309
G1 X116.135 Y127.812 E.01653
G1 X127.812 Y116.135 E.50971
G1 X127.276 Y116.135 E.01653
G1 X116.135 Y127.276 E.48632
G1 X116.135 Y126.741 E.01653
G1 X126.741 Y116.135 E.46294
G1 X126.205 Y116.135 E.01653
G1 X116.135 Y126.205 E.43956
G1 X116.135 Y125.669 E.01653
G1 X125.669 Y116.135 E.41617
G1 X125.134 Y116.135 E.01653
G1 X116.135 Y125.134 E.39279
G1 X116.135 Y124.598 E.01653
G1 X124.598 Y116.135 E.3694
G1 X124.062 Y116.135 E.01653
G1 X116.135 Y124.062 E.34602
G1 X116.135 Y123.526 E.01653
G1 X123.526 Y116.135 E.32264
G1 X122.991 Y116.135 E.01653
G1 X116.135 Y122.991 E.29925
G1 X116.135 Y122.455 E.01653
G1 X122.455 Y116.135 E.27587
G1 X121.919 Y116.135 E.01653
G1 X116.135 Y121.919 E.25249
G1 X116.135 Y121.384 E.01653
G1 X121.384 Y116.135 E.2291
G1 X120.848 Y116.135 E.01653
G1 X116.135 Y120.848 E.20572
G1 X116.135 Y120.312 E.01653
G1 X120.312 Y116.135 E.18233
G1 X119.777 Y116.135 E.01653
G1 X116.135 Y119.777 E.15895
G1 X116.135 Y119.241 E.01653
G1 X119.241 Y116.135 E.13557
G1 X118.705 Y116.135 E.01653
G1 X116.135 Y118.705 E.11218
G1 X116.135 Y118.17 E.01653
G1 X118.17 Y116.135 E.0888
G1 X117.634 Y116.135 E.01653
G1 X116.135 Y117.634 E.06541
G1 X116.135 Y117.098 E.01653
G1 X117.098 Y116.135 E.04203
G1 X116.562 Y116.135 E.01653
G1 X115.966 Y116.732 E.02605
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X116.562 Y116.135 E-.32074
G1 X117.098 Y116.135 E-.20356
G1 X116.66 Y116.574 E-.2357
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/128
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z.8 I-.862 J.859 P1  F42000
G1 X140.198 Y140.198 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    
      M400
      G90
      M83
      M204 S5000
      G0 Z2 F4000
      G0 X261 Y250 F20000
      M400 P200
      G39 S1
      G0 Z2 F4000
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X116.732 Y140.034 F42000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42171
G1 F15000
M204 S6000
G1 X116.135 Y139.438 E.02605
G1 X116.135 Y138.902 E.01653
G1 X117.098 Y139.865 E.04203
G1 X117.634 Y139.865 E.01653
G1 X116.135 Y138.366 E.06541
G1 X116.135 Y137.83 E.01653
G1 X118.17 Y139.865 E.0888
G1 X118.705 Y139.865 E.01653
G1 X116.135 Y137.295 E.11218
G1 X116.135 Y136.759 E.01653
G1 X119.241 Y139.865 E.13557
G1 X119.777 Y139.865 E.01653
G1 X116.135 Y136.223 E.15895
G1 X116.135 Y135.688 E.01653
G1 X120.312 Y139.865 E.18233
G1 X120.848 Y139.865 E.01653
G1 X116.135 Y135.152 E.20572
G1 X116.135 Y134.616 E.01653
G1 X121.384 Y139.865 E.2291
G1 X121.919 Y139.865 E.01653
G1 X116.135 Y134.081 E.25249
G1 X116.135 Y133.545 E.01653
G1 X122.455 Y139.865 E.27587
G1 X122.991 Y139.865 E.01653
G1 X116.135 Y133.009 E.29925
G1 X116.135 Y132.474 E.01653
G1 X123.526 Y139.865 E.32264
G1 X124.062 Y139.865 E.01653
G1 X116.135 Y131.938 E.34602
G1 X116.135 Y131.402 E.01653
G1 X124.598 Y139.865 E.3694
G1 X125.134 Y139.865 E.01653
G1 X116.135 Y130.866 E.39279
G1 X116.135 Y130.331 E.01653
G1 X125.669 Y139.865 E.41617
G1 X126.205 Y139.865 E.01653
G1 X116.135 Y129.795 E.43956
G1 X116.135 Y129.259 E.01653
G1 X126.741 Y139.865 E.46294
G1 X127.276 Y139.865 E.01653
G1 X116.135 Y128.724 E.48632
G1 X116.135 Y128.188 E.01653
G1 X127.812 Y139.865 E.50971
G1 X128.348 Y139.865 E.01653
G1 X116.135 Y127.652 E.53309
G1 X116.135 Y127.117 E.01653
G1 X128.883 Y139.865 E.55648
G1 X129.419 Y139.865 E.01653
G1 X116.135 Y126.581 E.57986
G1 X116.135 Y126.045 E.01653
G1 X129.955 Y139.865 E.60324
G1 X130.49 Y139.865 E.01653
G1 X116.135 Y125.51 E.62663
G1 X116.135 Y124.974 E.01653
G1 X131.026 Y139.865 E.65001
G1 X131.562 Y139.865 E.01653
G1 X116.135 Y124.438 E.6734
G1 X116.135 Y123.903 E.01653
G1 X132.097 Y139.865 E.69678
G1 X132.633 Y139.865 E.01653
G1 X116.135 Y123.367 E.72016
G1 X116.135 Y122.831 E.01653
G1 X133.169 Y139.865 E.74355
G1 X133.705 Y139.865 E.01653
G1 X116.135 Y122.295 E.76693
G1 X116.135 Y121.76 E.01653
G1 X134.24 Y139.865 E.79031
G1 X134.776 Y139.865 E.01653
G1 X116.135 Y121.224 E.8137
G1 X116.135 Y120.688 E.01653
G1 X135.312 Y139.865 E.83708
G1 X135.847 Y139.865 E.01653
G1 X116.135 Y120.153 E.86047
G1 X116.135 Y119.617 E.01653
G1 X136.383 Y139.865 E.88385
G1 X136.919 Y139.865 E.01653
G1 X116.135 Y119.081 E.90723
G1 X116.135 Y118.546 E.01653
G1 X137.454 Y139.865 E.93062
G1 X137.99 Y139.865 E.01653
G1 X116.135 Y118.01 E.954
G1 X116.135 Y117.474 E.01653
G1 X138.526 Y139.865 E.97739
G1 X139.061 Y139.865 E.01653
G1 X116.135 Y116.939 E1.00077
G1 X116.135 Y116.403 E.01653
G1 X139.597 Y139.865 E1.02415
G1 X139.865 Y139.865 E.00826
G1 X139.865 Y139.597 E.00828
G1 X116.403 Y116.135 E1.02413
G1 X116.939 Y116.135 E.01653
G1 X139.865 Y139.061 E1.00074
G1 X139.865 Y138.525 E.01653
G1 X117.475 Y116.135 E.97736
G1 X118.011 Y116.135 E.01653
G1 X139.865 Y137.989 E.95398
G1 X139.865 Y137.454 E.01653
G1 X118.546 Y116.135 E.93059
G1 X119.082 Y116.135 E.01653
G1 X139.865 Y136.918 E.90721
G1 X139.865 Y136.382 E.01653
G1 X119.618 Y116.135 E.88382
G1 X120.153 Y116.135 E.01653
G1 X139.865 Y135.847 E.86044
G1 X139.865 Y135.311 E.01653
G1 X120.689 Y116.135 E.83706
G1 X121.225 Y116.135 E.01653
G1 X139.865 Y134.775 E.81367
G1 X139.865 Y134.24 E.01653
G1 X121.76 Y116.135 E.79029
G1 X122.296 Y116.135 E.01653
G1 X139.865 Y133.704 E.7669
G1 X139.865 Y133.168 E.01653
G1 X122.832 Y116.135 E.74352
G1 X123.367 Y116.135 E.01653
M73 P26 R20
G1 X139.865 Y132.633 E.72014
G1 X139.865 Y132.097 E.01653
G1 X123.903 Y116.135 E.69675
G1 X124.439 Y116.135 E.01653
G1 X139.865 Y131.561 E.67337
G1 X139.865 Y131.025 E.01653
G1 X124.975 Y116.135 E.64998
G1 X125.51 Y116.135 E.01653
G1 X139.865 Y130.49 E.6266
G1 X139.865 Y129.954 E.01653
G1 X126.046 Y116.135 E.60322
G1 X126.582 Y116.135 E.01653
G1 X139.865 Y129.418 E.57983
G1 X139.865 Y128.883 E.01653
G1 X127.117 Y116.135 E.55645
G1 X127.653 Y116.135 E.01653
G1 X139.865 Y128.347 E.53307
G1 X139.865 Y127.811 E.01653
G1 X128.189 Y116.135 E.50968
G1 X128.724 Y116.135 E.01653
G1 X139.865 Y127.276 E.4863
G1 X139.865 Y126.74 E.01653
G1 X129.26 Y116.135 E.46291
G1 X129.796 Y116.135 E.01653
G1 X139.865 Y126.204 E.43953
G1 X139.865 Y125.669 E.01653
G1 X130.331 Y116.135 E.41615
G1 X130.867 Y116.135 E.01653
G1 X139.865 Y125.133 E.39276
G1 X139.865 Y124.597 E.01653
G1 X131.403 Y116.135 E.36938
G1 X131.938 Y116.135 E.01653
G1 X139.865 Y124.062 E.34599
G1 X139.865 Y123.526 E.01653
G1 X132.474 Y116.135 E.32261
G1 X133.01 Y116.135 E.01653
G1 X139.865 Y122.99 E.29923
G1 X139.865 Y122.454 E.01653
G1 X133.546 Y116.135 E.27584
G1 X134.081 Y116.135 E.01653
G1 X139.865 Y121.919 E.25246
G1 X139.865 Y121.383 E.01653
G1 X134.617 Y116.135 E.22907
G1 X135.153 Y116.135 E.01653
G1 X139.865 Y120.847 E.20569
G1 X139.865 Y120.312 E.01653
G1 X135.688 Y116.135 E.18231
G1 X136.224 Y116.135 E.01653
G1 X139.865 Y119.776 E.15892
G1 X139.865 Y119.24 E.01653
G1 X136.76 Y116.135 E.13554
G1 X137.295 Y116.135 E.01653
G1 X139.865 Y118.705 E.11215
G1 X139.865 Y118.169 E.01653
G1 X137.831 Y116.135 E.08877
G1 X138.367 Y116.135 E.01653
G1 X139.865 Y117.633 E.06539
G1 X139.865 Y117.098 E.01653
G1 X138.902 Y116.135 E.042
G1 X139.438 Y116.135 E.01653
G1 X140.034 Y116.732 E.02603
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X139.438 Y116.135 E-.32041
G1 X138.902 Y116.135 E-.20356
G1 X139.342 Y116.575 E-.23603
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/128
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z1 I-1.216 J.044 P1  F42000
G1 X140.198 Y140.198 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4289
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4289
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.2 F4000
            G39.3 S1
            G0 Z1.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4289
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4289
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4289
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4289
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/128
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z1.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.4 F4000
            G39.3 S1
            G0 Z1.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
M73 P27 R20
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/128
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z1.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.6 F4000
            G39.3 S1
            G0 Z1.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/128
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z1.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.8 F4000
            G39.3 S1
            G0 Z1.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
M73 P27 R19
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
M73 P28 R19
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/128
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z1.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2 F4000
            G39.3 S1
            G0 Z2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/128
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M73 P29 R19
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.2 F4000
            G39.3 S1
            G0 Z2.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/128
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z2.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.4 F4000
            G39.3 S1
            G0 Z2.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
M73 P30 R19
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/128
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z2.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.6 F4000
            G39.3 S1
            G0 Z2.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/128
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z2.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.8 F4000
            G39.3 S1
            G0 Z2.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P31 R19
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/128
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z2.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3 F4000
            G39.3 S1
            G0 Z3 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
M73 P31 R18
G1 E-.04 F1800
; layer num/total_layer_count: 14/128
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z3 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.2 F4000
            G39.3 S1
            G0 Z3.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
M73 P32 R18
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/128
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z3.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.4 F4000
            G39.3 S1
            G0 Z3.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/128
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z3.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.6 F4000
            G39.3 S1
            G0 Z3.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
M73 P33 R18
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/128
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z3.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.8 F4000
            G39.3 S1
            G0 Z3.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/128
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z3.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4 F4000
            G39.3 S1
            G0 Z4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
M73 P34 R18
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/128
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.2 F4000
            G39.3 S1
            G0 Z4.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/128
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z4.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
M73 P35 R18
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.4 F4000
            G39.3 S1
            G0 Z4.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
M73 P35 R17
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/128
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z4.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.6 F4000
            G39.3 S1
            G0 Z4.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/128
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z4.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
M73 P36 R17
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.8 F4000
            G39.3 S1
            G0 Z4.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/128
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z4.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5 F4000
            G39.3 S1
            G0 Z5 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/128
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z5 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
M73 P37 R17
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.2 F4000
            G39.3 S1
            G0 Z5.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/128
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z5.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.4 F4000
            G39.3 S1
            G0 Z5.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
M73 P38 R17
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/128
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z5.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z5.4
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.6 F4000
            G39.3 S1
            G0 Z5.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/128
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z5.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z5.6
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.8
M73 P38 R16
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.8 F4000
            G39.3 S1
            G0 Z5.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
M73 P39 R16
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/128
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z5.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z5.8
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6 F4000
            G39.3 S1
            G0 Z6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/128
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z6
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.2 F4000
            G39.3 S1
            G0 Z6.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
M73 P40 R16
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/128
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z6.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.4 F4000
            G39.3 S1
            G0 Z6.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/128
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z6.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z6.4
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.6 F4000
            G39.3 S1
            G0 Z6.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
M73 P41 R16
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/128
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z6.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z6.6
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.8 F4000
            G39.3 S1
            G0 Z6.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/128
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z6.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z6.8
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
M73 P42 R16
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7 F4000
            G39.3 S1
            G0 Z7 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
M73 P42 R15
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 34/128
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z7 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z7
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.2 F4000
            G39.3 S1
            G0 Z7.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/128
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z7.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z7.2
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
M73 P43 R15
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.4 F4000
            G39.3 S1
            G0 Z7.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/128
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z7.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z7.4
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.6 F4000
            G39.3 S1
            G0 Z7.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
M73 P44 R15
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/128
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z7.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z7.6
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.8 F4000
            G39.3 S1
            G0 Z7.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/128
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z7.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z7.8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8 F4000
            G39.3 S1
            G0 Z8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
M73 P45 R15
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/128
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z8
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.2 F4000
            G39.3 S1
            G0 Z8.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/128
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z8.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.4 F4000
            G39.3 S1
            G0 Z8.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
M73 P45 R14
G1 X132.174 Y139.85 E.02227
M73 P46 R14
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/128
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z8.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z8.4
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.6 F4000
            G39.3 S1
            G0 Z8.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/128
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z8.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z8.6
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.8 F4000
            G39.3 S1
            G0 Z8.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
M73 P47 R14
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/128
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z8.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z8.8
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9 F4000
            G39.3 S1
            G0 Z9 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/128
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z9 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z9
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
M73 P48 R14
G1 Z9.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.2 F4000
            G39.3 S1
            G0 Z9.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/128
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z9.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z9.2
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.4 F4000
            G39.3 S1
            G0 Z9.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/128
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z9.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z9.4
G1 Z9.2
M73 P49 R14
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.6 F4000
            G39.3 S1
            G0 Z9.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/128
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z9.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z9.6
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
M73 P49 R13
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z9.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z9.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z9.8 F4000
            G39.3 S1
            G0 Z9.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
M73 P50 R13
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/128
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z9.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z9.8
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z10
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10 F4000
            G39.3 S1
            G0 Z10 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/128
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z10 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z10
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z10.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10.2 F4000
            G39.3 S1
            G0 Z10.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
M73 P51 R13
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/128
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z10.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z10.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z10.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10.4 F4000
            G39.3 S1
            G0 Z10.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/128
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z10.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z10.4
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z10.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10.6 F4000
            G39.3 S1
            G0 Z10.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
M73 P52 R13
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/128
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z10.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z10.6
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z10.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z10.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z10.8 F4000
            G39.3 S1
            G0 Z10.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/128
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z10.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z10.8
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z11
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z11 F4000
            G39.3 S1
            G0 Z11 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
M73 P53 R13
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
M73 P53 R12
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/128
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z11 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z11
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z11.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z11.2 F4000
            G39.3 S1
            G0 Z11.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/128
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z11.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z11.2
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
M73 P54 R12
G1 Z11.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z11.4 F4000
            G39.3 S1
            G0 Z11.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z11
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/128
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z11.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z11.4
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z11.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z11.6 F4000
            G39.3 S1
            G0 Z11.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/128
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z11.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z11.6
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
M73 P55 R12
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z11.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z11.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z11.8 F4000
            G39.3 S1
            G0 Z11.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/128
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z11.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z11.8
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z12
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z12 F4000
            G39.3 S1
            G0 Z12 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/128
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z12 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z12
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
M73 P56 R12
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z12.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z12.2 F4000
            G39.3 S1
            G0 Z12.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/128
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z12.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z12.2
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z12.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z12.4 F4000
            G39.3 S1
            G0 Z12.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
M73 P56 R11
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
M73 P57 R11
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/128
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z12.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z12.4
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z12.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z12.6 F4000
            G39.3 S1
            G0 Z12.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/128
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z12.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z12.6
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z12.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z12.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z12.8 F4000
            G39.3 S1
            G0 Z12.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
M73 P58 R11
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/128
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z12.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z12.8
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z13 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z13
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z13 F4000
            G39.3 S1
            G0 Z13 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z12.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/128
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z13 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z13
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z13.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z13.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z13.2 F4000
            G39.3 S1
            G0 Z13.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
M73 P59 R11
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/128
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z13.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z13.2
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z13.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z13.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z13.4 F4000
            G39.3 S1
            G0 Z13.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z13
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/128
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z13.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z13.4
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z13.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z13.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z13.6 F4000
            G39.3 S1
            G0 Z13.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
M73 P60 R11
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/128
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z13.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z13.6
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z13.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
M73 P60 R10
G1 Z13.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z13.8 F4000
            G39.3 S1
            G0 Z13.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/128
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z13.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z13.8
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z14
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z14 F4000
            G39.3 S1
            G0 Z14 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


M73 P61 R10
G1 X137.55 Y139.85 F42000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/128
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z14 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z14
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z14.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z14.2 F4000
            G39.3 S1
            G0 Z14.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/128
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z14.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z14.2
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
M73 P62 R10
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z14.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z14.4 F4000
            G39.3 S1
            G0 Z14.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z14
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/128
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z14.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z14.4
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z14.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z14.6 F4000
            G39.3 S1
            G0 Z14.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
M73 P63 R10
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/128
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z14.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z14.6
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z14.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z14.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z14.8 F4000
            G39.3 S1
            G0 Z14.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/128
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z14.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z14.8
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z15
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z15 F4000
            G39.3 S1
            G0 Z15 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z14.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
M73 P64 R9
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/128
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z15 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z15
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z15.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z15.2 F4000
            G39.3 S1
            G0 Z15.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/128
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z15.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z15.2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z15.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z15.4 F4000
            G39.3 S1
            G0 Z15.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z15
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
M73 P65 R9
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/128
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z15.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z15.4
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z15.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z15.6 F4000
            G39.3 S1
            G0 Z15.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/128
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z15.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z15.6
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z15.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z15.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z15.8 F4000
            G39.3 S1
            G0 Z15.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
M73 P66 R9
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/128
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z15.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z15.8
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z16
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z16 F4000
            G39.3 S1
            G0 Z16 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/128
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z16 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z16
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z16.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
M73 P67 R9
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z16.2 F4000
            G39.3 S1
            G0 Z16.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/128
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z16.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z16.2
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z16.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z16.4 F4000
            G39.3 S1
            G0 Z16.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
M73 P67 R8
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/128
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z16.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z16.4
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
M73 P68 R8
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z16.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z16.6 F4000
            G39.3 S1
            G0 Z16.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/128
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z16.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z16.6
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z16.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z16.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z16.8 F4000
            G39.3 S1
            G0 Z16.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
M73 P69 R8
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/128
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z16.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z16.8
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z17 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z17
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z17 F4000
            G39.3 S1
            G0 Z17 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/128
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z17 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z17
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z17.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z17.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z17.2 F4000
            G39.3 S1
            G0 Z17.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
M73 P70 R8
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/128
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z17.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z17.2
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z17.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z17.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z17.4 F4000
            G39.3 S1
            G0 Z17.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/128
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z17.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z17.4
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z17.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z17.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z17.6 F4000
            G39.3 S1
            G0 Z17.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
M73 P71 R8
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/128
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z17.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z17.6
G1 Z17.4
M73 P71 R7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z17.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z17.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z17.8 F4000
            G39.3 S1
            G0 Z17.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/128
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z17.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z17.8
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z18 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z18
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z18 F4000
            G39.3 S1
            G0 Z18 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
M73 P72 R7
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/128
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z18 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z18
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z18.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z18.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z18.2 F4000
            G39.3 S1
            G0 Z18.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/128
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z18.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z18.2
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z18.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z18.4
M73 P73 R7
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z18.4 F4000
            G39.3 S1
            G0 Z18.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z18
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 91/128
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z18.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z18.4
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z18.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z18.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z18.6 F4000
            G39.3 S1
            G0 Z18.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 92/128
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z18.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z18.6
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
M73 P74 R7
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z18.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z18.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z18.8 F4000
            G39.3 S1
            G0 Z18.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 93/128
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z18.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z18.8
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z19 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z19
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z19 F4000
            G39.3 S1
            G0 Z19 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
M73 P74 R6
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 94/128
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z19 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z19
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
M73 P75 R6
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z19.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z19.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z19.2 F4000
            G39.3 S1
            G0 Z19.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z18.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 95/128
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z19.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z19.2
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z19.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z19.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z19.4 F4000
            G39.3 S1
            G0 Z19.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z19
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 96/128
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z19.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z19.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
M73 P76 R6
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z19.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z19.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z19.6 F4000
            G39.3 S1
            G0 Z19.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 97/128
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z19.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z19.6
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z19.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z19.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z19.8 F4000
            G39.3 S1
            G0 Z19.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z19.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
M73 P77 R6
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 98/128
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z19.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z19.8
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z20
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z20 F4000
            G39.3 S1
            G0 Z20 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z19.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 99/128
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z20 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z20
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z20.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z20.2 F4000
            G39.3 S1
            G0 Z20.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z19.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
M73 P78 R6
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 100/128
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z20.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z20.2
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z20.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z20.4 F4000
            G39.3 S1
            G0 Z20.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z20
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
M73 P78 R5
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 101/128
; update layer progress
M73 L101
M991 S0 P100 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z20.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z20.4
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z20.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z20.6 F4000
            G39.3 S1
            G0 Z20.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z20.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
M73 P79 R5
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 102/128
; update layer progress
M73 L102
M991 S0 P101 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z20.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z20.6
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z20.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z20.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z20.8 F4000
            G39.3 S1
            G0 Z20.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z20.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 103/128
; update layer progress
M73 L103
M991 S0 P102 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z20.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z20.8
G1 Z20.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z21 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z21
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z21 F4000
            G39.3 S1
            G0 Z21 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z20.6
M73 P80 R5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 104/128
; update layer progress
M73 L104
M991 S0 P103 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z21 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z21
G1 Z20.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z21.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z21.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z21.2 F4000
            G39.3 S1
            G0 Z21.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z20.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 105/128
; update layer progress
M73 L105
M991 S0 P104 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z21.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z21.2
G1 Z21
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
M73 P81 R5
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z21.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z21.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z21.4 F4000
            G39.3 S1
            G0 Z21.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z21
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 106/128
; update layer progress
M73 L106
M991 S0 P105 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z21.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z21.4
G1 Z21.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z21.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z21.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z21.6 F4000
            G39.3 S1
            G0 Z21.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z21.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
M73 P82 R5
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 107/128
; update layer progress
M73 L107
M991 S0 P106 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z21.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z21.6
G1 Z21.4
M73 P82 R4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z21.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z21.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z21.8 F4000
            G39.3 S1
            G0 Z21.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z21.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 108/128
; update layer progress
M73 L108
M991 S0 P107 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z21.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z21.8
G1 Z21.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z22
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z22 F4000
            G39.3 S1
            G0 Z22 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z21.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
M73 P83 R4
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 109/128
; update layer progress
M73 L109
M991 S0 P108 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z22 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z22
G1 Z21.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z22.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z22.2 F4000
            G39.3 S1
            G0 Z22.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z21.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 22
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 110/128
; update layer progress
M73 L110
M991 S0 P109 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z22.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z22.2
G1 Z22
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z22.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z22.4 F4000
            G39.3 S1
            G0 Z22.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z22
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
M73 P84 R4
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 22.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 111/128
; update layer progress
M73 L111
M991 S0 P110 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z22.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z22.4
G1 Z22.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z22.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z22.6 F4000
            G39.3 S1
            G0 Z22.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z22.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 22.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 112/128
; update layer progress
M73 L112
M991 S0 P111 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z22.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z22.6
G1 Z22.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z22.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z22.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z22.8 F4000
            G39.3 S1
            G0 Z22.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z22.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
M73 P85 R4
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 22.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 113/128
; update layer progress
M73 L113
M991 S0 P112 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z22.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z22.8
G1 Z22.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z23
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z23 F4000
            G39.3 S1
            G0 Z23 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z22.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
M73 P85 R3
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 22.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 114/128
; update layer progress
M73 L114
M991 S0 P113 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z23 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z23
G1 Z22.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z23.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z23.2 F4000
            G39.3 S1
            G0 Z23.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z22.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
M73 P86 R3
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 23
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 115/128
; update layer progress
M73 L115
M991 S0 P114 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z23.2 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z23.2
G1 Z23
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z23.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z23.4 F4000
            G39.3 S1
            G0 Z23.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z23
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 23.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 116/128
; update layer progress
M73 L116
M991 S0 P115 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z23.4 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z23.4
G1 Z23.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
M73 P87 R3
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z23.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z23.6 F4000
            G39.3 S1
            G0 Z23.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z23.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 23.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 117/128
; update layer progress
M73 L117
M991 S0 P116 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z23.6 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z23.6
G1 Z23.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z23.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z23.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z23.8 F4000
            G39.3 S1
            G0 Z23.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z23.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
M73 P88 R3
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 23.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 118/128
; update layer progress
M73 L118
M991 S0 P117 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z23.8 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z23.8
G1 Z23.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z24 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z24
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z24 F4000
            G39.3 S1
            G0 Z24 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z23.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 23.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 119/128
; update layer progress
M73 L119
M991 S0 P118 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z24 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z24
G1 Z23.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z24.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z24.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z24.2 F4000
            G39.3 S1
            G0 Z24.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z23.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
M73 P89 R3
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 24
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 120/128
; update layer progress
M73 L120
M991 S0 P119 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z24.2 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z24.2
G1 Z24
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
M73 P89 R2
G3 Z24.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z24.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z24.4 F4000
            G39.3 S1
            G0 Z24.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z24
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 24.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 121/128
; update layer progress
M73 L121
M991 S0 P120 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z24.4 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z24.4
G1 Z24.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4275
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4275
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z24.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z24.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z24.6 F4000
            G39.3 S1
            G0 Z24.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X122.198 Y139.85 F42000
G1 Z24.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4275
M204 S6000
G1 X123.826 Y139.85 E.05401
G1 X139.85 Y123.826 E.75169
G1 X139.85 Y124.498 E.02227
G1 X131.502 Y116.15 E.3916
G1 X132.174 Y116.15 E.02227
G1 X116.15 Y132.174 E.75169
G1 X116.15 Y131.502 E.02227
G1 X124.498 Y139.85 E.3916
G1 X126.126 Y139.85 E.05401
M204 S10000
G1 X116.15 Y137.55 F42000
G1 F4275
M204 S6000
G1 X116.15 Y139.178 E.05401
G1 X116.822 Y139.85 E.0315
G1 X116.15 Y139.85 E.02227
G1 X139.85 Y116.15 E1.11179
G1 X139.178 Y116.15 E.02227
G1 X139.85 Y116.822 E.0315
G1 X139.85 Y118.45 E.05401
M204 S10000
G1 X118.45 Y116.15 F42000
G1 F4275
M204 S6000
G1 X116.822 Y116.15 E.05401
G1 X116.15 Y116.822 E.0315
G1 X116.15 Y116.15 E.02227
G1 X139.85 Y139.85 E1.11179
G1 X139.85 Y139.178 E.02227
G1 X139.178 Y139.85 E.0315
G1 X137.55 Y139.85 E.05401
M204 S10000
G1 X116.15 Y122.198 F42000
G1 F4275
M204 S6000
G1 X116.15 Y123.826 E.05401
M73 P90 R2
G1 X132.174 Y139.85 E.75169
G1 X131.502 Y139.85 E.02227
G1 X139.85 Y131.502 E.3916
G1 X139.85 Y132.174 E.02227
G1 X123.826 Y116.15 E.75169
G1 X124.498 Y116.15 E.02227
G1 X116.15 Y124.498 E.3916
G1 X116.15 Y126.126 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 24.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X116.15 Y124.498 E-.61876
G1 X116.413 Y124.235 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 122/128
; update layer progress
M73 L122
M991 S0 P121 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z24.6 I-.678 J1.01 P1  F42000
G1 X140.198 Y140.198 Z24.6
G1 Z24.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4294
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4294
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z24.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z24.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z24.8 F4000
            G39.3 S1
            G0 Z24.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.55 Y139.85 F42000
G1 Z24.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4294
M204 S6000
G1 X139.178 Y139.85 E.05401
G1 X139.85 Y139.178 E.0315
G1 X139.85 Y139.85 E.02227
G1 X116.15 Y116.15 E1.11179
G1 X116.15 Y116.822 E.02227
G1 X116.822 Y116.15 E.0315
G1 X118.45 Y116.15 E.05401
M204 S10000
G1 X116.15 Y126.126 F42000
G1 F4294
M204 S6000
G1 X116.15 Y124.498 E.05401
G1 X124.498 Y116.15 E.3916
G1 X123.826 Y116.15 E.02227
G1 X139.85 Y132.174 E.75169
G1 X139.85 Y131.502 E.02227
G1 X131.502 Y139.85 E.3916
G1 X132.174 Y139.85 E.02227
G1 X116.15 Y123.826 E.75169
G1 X116.15 Y122.198 E.05401
M204 S10000
G1 X126.126 Y139.85 F42000
G1 F4294
M204 S6000
G1 X124.498 Y139.85 E.05401
G1 X116.15 Y131.502 E.3916
G1 X116.15 Y132.174 E.02227
G1 X132.174 Y116.15 E.75169
G1 X131.502 Y116.15 E.02227
G1 X139.85 Y124.498 E.3916
G1 X139.85 Y123.826 E.02227
G1 X123.826 Y139.85 E.75169
G1 X122.198 Y139.85 E.05401
M204 S10000
G1 X139.85 Y118.45 F42000
G1 F4294
M204 S6000
G1 X139.85 Y116.822 E.05401
G1 X139.178 Y116.15 E.0315
G1 X139.85 Y116.15 E.02227
G1 X116.15 Y139.85 E1.11179
G1 X116.822 Y139.85 E.02227
G1 X116.15 Y139.178 E.0315
G1 X116.15 Y137.55 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 24.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X116.15 Y139.178 E-.61876
G1 X116.413 Y139.441 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 123/128
; update layer progress
M73 L123
M991 S0 P122 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z24.8 I-.039 J1.216 P1  F42000
G1 X140.198 Y140.198 Z24.8
G1 Z24.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F6046
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6046
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
G1 F12000
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z25 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z25
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z25 F4000
            G39.3 S1
            G0 Z25 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X137.844 Y139.473 F42000
G1 Z24.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6046
M204 S6000
G1 X139.473 Y139.473 E.05401
G1 X116.527 Y116.527 E1.0764
G1 X124.121 Y116.527 E.25188
G1 X116.527 Y124.121 E.35621
G1 X116.527 Y124.203 E.00275
G1 X131.797 Y139.473 E.7163
G1 X131.879 Y139.473 E.00275
G1 X139.473 Y131.879 E.35621
G1 X139.473 Y131.797 E.00275
G1 X124.203 Y116.527 E.7163
G1 X125.832 Y116.527 E.05401
M204 S10000
G1 X139.473 Y118.156 F42000
G1 F6046
M204 S6000
G1 X139.473 Y116.527 E.05401
G1 X116.527 Y139.473 E1.0764
M73 P91 R2
G1 X116.527 Y131.879 E.25188
G1 X124.121 Y139.473 E.35621
G1 X124.203 Y139.473 E.00275
G1 X139.473 Y124.203 E.7163
G1 X139.473 Y124.121 E.00275
G1 X131.879 Y116.527 E.35621
G1 X131.797 Y116.527 E.00275
G1 X116.527 Y131.797 E.7163
G1 X116.527 Y130.168 E.05401
M204 S10000
G1 X139.808 Y116.192 F42000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.399345
G1 F3000;_EXTRUDE_SET_SPEED
M204 S6000
G1 X139.835 Y116.324 E.00391
G1 X139.835 Y139.676 E.67824
G1 X139.808 Y139.808 E.00391
G1 X139.676 Y139.835 E.00391
G1 X116.324 Y139.835 E.67824
G1 X116.192 Y139.808 E.00391
G1 X116.165 Y139.676 E.00391
G1 X116.165 Y116.324 E.67824
G1 X116.192 Y116.192 E.00391
G1 X116.324 Y116.165 E.00391
G1 X139.676 Y116.165 E.67824
G1 X139.749 Y116.18 E.00217
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 24.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3000
G1 X139.676 Y116.165 E-.02837
G1 X137.751 Y116.165 E-.73163
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 124/128
; update layer progress
M73 L124
M991 S0 P123 ;notify layer change
M106 S188.7
; OBJECT_ID: 69
M204 S10000
G17
G3 Z25 I-1.211 J.123 P1  F42000
G1 X140.198 Y140.198 Z25
G1 Z24.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z25.2 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z25.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z25.2 F4000
            G39.3 S1
            G0 Z25.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X139.111 Y140.031 F42000
G1 Z24.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40455
; LAYER_HEIGHT: 0.4
M106 S255
G1 F3000
M204 S6000
G1 X139.828 Y139.314 E.05309
G1 X139.828 Y138.671 E.03367
G1 X138.671 Y139.828 E.0857
G1 X138.028 Y139.828 E.03367
G1 X139.828 Y138.028 E.13331
G1 X139.828 Y137.385 E.03367
G1 X137.385 Y139.828 E.18092
G1 X136.743 Y139.828 E.03367
G1 X139.828 Y136.743 E.22854
G1 X139.828 Y136.1 E.03367
G1 X136.1 Y139.828 E.27615
G1 X135.457 Y139.828 E.03367
G1 X139.828 Y135.457 E.32376
G1 X139.828 Y134.814 E.03367
G1 X134.814 Y139.828 E.37137
G1 X134.171 Y139.828 E.03367
G1 X139.828 Y134.171 E.41898
G1 X139.828 Y133.528 E.03367
G1 X133.528 Y139.828 E.46659
G1 X132.886 Y139.828 E.03367
G1 X139.828 Y132.886 E.5142
G1 X139.828 Y132.243 E.03367
G1 X132.243 Y139.828 E.56181
G1 X131.6 Y139.828 E.03367
G1 X139.828 Y131.6 E.60942
G1 X139.828 Y130.957 E.03367
G1 X130.957 Y139.828 E.65703
G1 X130.314 Y139.828 E.03367
G1 X139.828 Y130.314 E.70464
G1 X139.828 Y129.671 E.03367
G1 X129.671 Y139.828 E.75225
G1 X129.029 Y139.828 E.03367
G1 X139.828 Y129.029 E.79987
G1 X139.828 Y128.386 E.03367
G1 X128.386 Y139.828 E.84748
G1 X127.743 Y139.828 E.03367
G1 X139.828 Y127.743 E.89509
G1 X139.828 Y127.1 E.03367
G1 X127.1 Y139.828 E.9427
G1 X126.457 Y139.828 E.03367
G1 X139.828 Y126.457 E.99031
G1 X139.828 Y125.814 E.03367
G1 X125.814 Y139.828 E1.03792
G1 X125.172 Y139.828 E.03367
G1 X139.828 Y125.172 E1.08553
G1 X139.828 Y124.529 E.03367
G1 X124.529 Y139.828 E1.13314
G1 X123.886 Y139.828 E.03367
G1 X139.828 Y123.886 E1.18075
G1 X139.828 Y123.243 E.03367
G1 X123.243 Y139.828 E1.22836
G1 X122.6 Y139.828 E.03367
G1 X139.828 Y122.6 E1.27597
G1 X139.828 Y121.957 E.03367
G1 X121.957 Y139.828 E1.32359
G1 X121.315 Y139.828 E.03367
G1 X139.828 Y121.315 E1.3712
G1 X139.828 Y120.672 E.03367
G1 X120.672 Y139.828 E1.41881
G1 X120.029 Y139.828 E.03367
G1 X139.828 Y120.029 E1.46642
G1 X139.828 Y119.386 E.03367
G1 X119.386 Y139.828 E1.51403
G1 X118.743 Y139.828 E.03367
G1 X139.828 Y118.743 E1.56164
G1 X139.828 Y118.1 E.03367
M73 P92 R2
G1 X118.1 Y139.828 E1.60925
G1 X117.458 Y139.828 E.03367
G1 X139.828 Y117.458 E1.65686
G1 X139.828 Y116.815 E.03367
G1 X116.815 Y139.828 E1.70447
G1 X116.172 Y139.828 E.03367
G1 X139.828 Y116.172 E1.75208
G1 X139.186 Y116.172 E.03366
G1 X116.172 Y139.186 E1.7045
G1 X116.172 Y138.543 E.03367
G1 X138.543 Y116.172 E1.65689
G1 X137.9 Y116.172 E.03367
G1 X116.172 Y137.9 E1.60928
G1 X116.172 Y137.257 E.03367
G1 X137.257 Y116.172 E1.56167
G1 X136.614 Y116.172 E.03367
G1 X116.172 Y136.614 E1.51406
G1 X116.172 Y135.971 E.03367
G1 X135.971 Y116.172 E1.46645
G1 X135.329 Y116.172 E.03367
G1 X116.172 Y135.329 E1.41884
G1 X116.172 Y134.686 E.03367
G1 X134.686 Y116.172 E1.37123
G1 X134.043 Y116.172 E.03367
G1 X116.172 Y134.043 E1.32361
G1 X116.172 Y133.4 E.03367
G1 X133.4 Y116.172 E1.276
G1 X132.757 Y116.172 E.03367
G1 X116.172 Y132.757 E1.22839
G1 X116.172 Y132.114 E.03367
G1 X132.114 Y116.172 E1.18078
G1 X131.472 Y116.172 E.03367
G1 X116.172 Y131.472 E1.13317
G1 X116.172 Y130.829 E.03367
G1 X130.829 Y116.172 E1.08556
G1 X130.186 Y116.172 E.03367
G1 X116.172 Y130.186 E1.03795
G1 X116.172 Y129.543 E.03367
G1 X129.543 Y116.172 E.99034
G1 X128.9 Y116.172 E.03367
G1 X116.172 Y128.9 E.94273
G1 X116.172 Y128.257 E.03367
G1 X128.257 Y116.172 E.89512
G1 X127.615 Y116.172 E.03367
G1 X116.172 Y127.615 E.84751
G1 X116.172 Y126.972 E.03367
G1 X126.972 Y116.172 E.7999
G1 X126.329 Y116.172 E.03367
G1 X116.172 Y126.329 E.75228
G1 X116.172 Y125.686 E.03367
G1 X125.686 Y116.172 E.70467
G1 X125.043 Y116.172 E.03367
G1 X116.172 Y125.043 E.65706
G1 X116.172 Y124.4 E.03367
G1 X124.4 Y116.172 E.60945
G1 X123.758 Y116.172 E.03367
G1 X116.172 Y123.758 E.56184
G1 X116.172 Y123.115 E.03367
G1 X123.115 Y116.172 E.51423
G1 X122.472 Y116.172 E.03367
G1 X116.172 Y122.472 E.46662
G1 X116.172 Y121.829 E.03367
G1 X121.829 Y116.172 E.41901
G1 X121.186 Y116.172 E.03367
G1 X116.172 Y121.186 E.3714
G1 X116.172 Y120.543 E.03367
G1 X120.543 Y116.172 E.32379
G1 X119.901 Y116.172 E.03367
G1 X116.172 Y119.901 E.27618
G1 X116.172 Y119.258 E.03367
G1 X119.258 Y116.172 E.22856
G1 X118.615 Y116.172 E.03367
G1 X116.172 Y118.615 E.18095
G1 X116.172 Y117.972 E.03367
G1 X117.972 Y116.172 E.13334
G1 X117.329 Y116.172 E.03367
G1 X116.172 Y117.329 E.08573
G1 X116.172 Y116.686 E.03367
G1 X116.889 Y115.969 E.05312
M106 S188.7
; CHANGE_LAYER
; Z_HEIGHT: 25
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F3000
G1 X116.172 Y116.686 E-.38542
G1 X116.172 Y117.329 E-.24428
G1 X116.414 Y117.087 E-.1303
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 125/128
; update layer progress
M73 L125
M991 S0 P124 ;notify layer change
M106 S201.45
; OBJECT_ID: 69
M204 S10000
G17
G3 Z25.2 I-.848 J.873 P1  F42000
G1 X140.198 Y140.198 Z25.2
G1 Z25
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z25.4 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z25.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z25.4 F4000
            G39.3 S1
            G0 Z25.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X116.732 Y140.034 F42000
G1 Z25
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42171
G1 F15000
M204 S6000
G1 X116.135 Y139.438 E.02605
G1 X116.135 Y138.902 E.01653
G1 X117.098 Y139.865 E.04203
G1 X117.634 Y139.865 E.01653
G1 X116.135 Y138.366 E.06541
G1 X116.135 Y137.83 E.01653
G1 X118.17 Y139.865 E.0888
G1 X118.705 Y139.865 E.01653
M73 P92 R1
G1 X116.135 Y137.295 E.11218
G1 X116.135 Y136.759 E.01653
G1 X119.241 Y139.865 E.13557
G1 X119.777 Y139.865 E.01653
G1 X116.135 Y136.223 E.15895
G1 X116.135 Y135.688 E.01653
G1 X120.312 Y139.865 E.18233
G1 X120.848 Y139.865 E.01653
G1 X116.135 Y135.152 E.20572
G1 X116.135 Y134.616 E.01653
G1 X121.384 Y139.865 E.2291
G1 X121.919 Y139.865 E.01653
G1 X116.135 Y134.081 E.25249
M73 P93 R1
G1 X116.135 Y133.545 E.01653
G1 X122.455 Y139.865 E.27587
G1 X122.991 Y139.865 E.01653
G1 X116.135 Y133.009 E.29925
G1 X116.135 Y132.474 E.01653
G1 X123.526 Y139.865 E.32264
G1 X124.062 Y139.865 E.01653
G1 X116.135 Y131.938 E.34602
G1 X116.135 Y131.402 E.01653
G1 X124.598 Y139.865 E.3694
G1 X125.134 Y139.865 E.01653
G1 X116.135 Y130.866 E.39279
G1 X116.135 Y130.331 E.01653
G1 X125.669 Y139.865 E.41617
G1 X126.205 Y139.865 E.01653
G1 X116.135 Y129.795 E.43956
G1 X116.135 Y129.259 E.01653
G1 X126.741 Y139.865 E.46294
G1 X127.276 Y139.865 E.01653
G1 X116.135 Y128.724 E.48632
G1 X116.135 Y128.188 E.01653
G1 X127.812 Y139.865 E.50971
G1 X128.348 Y139.865 E.01653
G1 X116.135 Y127.652 E.53309
G1 X116.135 Y127.117 E.01653
G1 X128.883 Y139.865 E.55648
G1 X129.419 Y139.865 E.01653
G1 X116.135 Y126.581 E.57986
G1 X116.135 Y126.045 E.01653
G1 X129.955 Y139.865 E.60324
G1 X130.49 Y139.865 E.01653
G1 X116.135 Y125.51 E.62663
G1 X116.135 Y124.974 E.01653
G1 X131.026 Y139.865 E.65001
G1 X131.562 Y139.865 E.01653
G1 X116.135 Y124.438 E.6734
G1 X116.135 Y123.903 E.01653
G1 X132.097 Y139.865 E.69678
G1 X132.633 Y139.865 E.01653
G1 X116.135 Y123.367 E.72016
G1 X116.135 Y122.831 E.01653
G1 X133.169 Y139.865 E.74355
G1 X133.705 Y139.865 E.01653
G1 X116.135 Y122.295 E.76693
G1 X116.135 Y121.76 E.01653
G1 X134.24 Y139.865 E.79031
G1 X134.776 Y139.865 E.01653
G1 X116.135 Y121.224 E.8137
G1 X116.135 Y120.688 E.01653
G1 X135.312 Y139.865 E.83708
G1 X135.847 Y139.865 E.01653
G1 X116.135 Y120.153 E.86047
G1 X116.135 Y119.617 E.01653
G1 X136.383 Y139.865 E.88385
G1 X136.919 Y139.865 E.01653
G1 X116.135 Y119.081 E.90723
G1 X116.135 Y118.546 E.01653
G1 X137.454 Y139.865 E.93062
G1 X137.99 Y139.865 E.01653
G1 X116.135 Y118.01 E.954
G1 X116.135 Y117.474 E.01653
G1 X138.526 Y139.865 E.97739
G1 X139.061 Y139.865 E.01653
G1 X116.135 Y116.939 E1.00077
G1 X116.135 Y116.403 E.01653
G1 X139.597 Y139.865 E1.02415
G1 X139.865 Y139.865 E.00826
G1 X139.865 Y139.597 E.00828
G1 X116.403 Y116.135 E1.02413
G1 X116.939 Y116.135 E.01653
G1 X139.865 Y139.061 E1.00074
G1 X139.865 Y138.525 E.01653
G1 X117.475 Y116.135 E.97736
G1 X118.011 Y116.135 E.01653
G1 X139.865 Y137.989 E.95398
G1 X139.865 Y137.454 E.01653
G1 X118.546 Y116.135 E.93059
G1 X119.082 Y116.135 E.01653
G1 X139.865 Y136.918 E.90721
G1 X139.865 Y136.382 E.01653
G1 X119.618 Y116.135 E.88382
G1 X120.153 Y116.135 E.01653
G1 X139.865 Y135.847 E.86044
G1 X139.865 Y135.311 E.01653
G1 X120.689 Y116.135 E.83706
G1 X121.225 Y116.135 E.01653
G1 X139.865 Y134.775 E.81367
G1 X139.865 Y134.24 E.01653
G1 X121.76 Y116.135 E.79029
G1 X122.296 Y116.135 E.01653
G1 X139.865 Y133.704 E.7669
G1 X139.865 Y133.168 E.01653
G1 X122.832 Y116.135 E.74352
G1 X123.367 Y116.135 E.01653
G1 X139.865 Y132.633 E.72014
G1 X139.865 Y132.097 E.01653
G1 X123.903 Y116.135 E.69675
G1 X124.439 Y116.135 E.01653
G1 X139.865 Y131.561 E.67337
G1 X139.865 Y131.025 E.01653
G1 X124.975 Y116.135 E.64998
G1 X125.51 Y116.135 E.01653
G1 X139.865 Y130.49 E.6266
G1 X139.865 Y129.954 E.01653
G1 X126.046 Y116.135 E.60322
G1 X126.582 Y116.135 E.01653
G1 X139.865 Y129.418 E.57983
G1 X139.865 Y128.883 E.01653
G1 X127.117 Y116.135 E.55645
G1 X127.653 Y116.135 E.01653
G1 X139.865 Y128.347 E.53307
G1 X139.865 Y127.811 E.01653
G1 X128.189 Y116.135 E.50968
G1 X128.724 Y116.135 E.01653
G1 X139.865 Y127.276 E.4863
G1 X139.865 Y126.74 E.01653
G1 X129.26 Y116.135 E.46291
G1 X129.796 Y116.135 E.01653
G1 X139.865 Y126.204 E.43953
G1 X139.865 Y125.669 E.01653
G1 X130.331 Y116.135 E.41615
G1 X130.867 Y116.135 E.01653
G1 X139.865 Y125.133 E.39276
G1 X139.865 Y124.597 E.01653
G1 X131.403 Y116.135 E.36938
G1 X131.938 Y116.135 E.01653
G1 X139.865 Y124.062 E.34599
G1 X139.865 Y123.526 E.01653
G1 X132.474 Y116.135 E.32261
G1 X133.01 Y116.135 E.01653
M73 P94 R1
G1 X139.865 Y122.99 E.29923
G1 X139.865 Y122.454 E.01653
G1 X133.546 Y116.135 E.27584
G1 X134.081 Y116.135 E.01653
G1 X139.865 Y121.919 E.25246
G1 X139.865 Y121.383 E.01653
G1 X134.617 Y116.135 E.22907
G1 X135.153 Y116.135 E.01653
G1 X139.865 Y120.847 E.20569
G1 X139.865 Y120.312 E.01653
G1 X135.688 Y116.135 E.18231
G1 X136.224 Y116.135 E.01653
G1 X139.865 Y119.776 E.15892
G1 X139.865 Y119.24 E.01653
G1 X136.76 Y116.135 E.13554
G1 X137.295 Y116.135 E.01653
G1 X139.865 Y118.705 E.11215
G1 X139.865 Y118.169 E.01653
G1 X137.831 Y116.135 E.08877
G1 X138.367 Y116.135 E.01653
G1 X139.865 Y117.633 E.06539
G1 X139.865 Y117.098 E.01653
G1 X138.902 Y116.135 E.042
G1 X139.438 Y116.135 E.01653
G1 X140.034 Y116.732 E.02603
; CHANGE_LAYER
; Z_HEIGHT: 25.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X139.438 Y116.135 E-.32041
G1 X138.902 Y116.135 E-.20356
G1 X139.342 Y116.575 E-.23603
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 126/128
; update layer progress
M73 L126
M991 S0 P125 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z25.4 I-1.216 J.044 P1  F42000
G1 X140.198 Y140.198 Z25.4
G1 Z25.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z25.6 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z25.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z25.6 F4000
            G39.3 S1
            G0 Z25.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X139.268 Y140.034 F42000
G1 Z25.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42171
G1 F15000
M204 S6000
G1 X139.865 Y139.438 E.02603
G1 X139.865 Y138.902 E.01653
G1 X138.902 Y139.865 E.042
G1 X138.367 Y139.865 E.01653
G1 X139.865 Y138.367 E.06539
G1 X139.865 Y137.831 E.01653
G1 X137.831 Y139.865 E.08877
G1 X137.295 Y139.865 E.01653
G1 X139.865 Y137.295 E.11215
G1 X139.865 Y136.76 E.01653
M73 P95 R1
G1 X136.76 Y139.865 E.13554
G1 X136.224 Y139.865 E.01653
G1 X139.865 Y136.224 E.15892
G1 X139.865 Y135.688 E.01653
G1 X135.688 Y139.865 E.18231
G1 X135.153 Y139.865 E.01653
G1 X139.865 Y135.153 E.20569
G1 X139.865 Y134.617 E.01653
G1 X134.617 Y139.865 E.22907
G1 X134.081 Y139.865 E.01653
G1 X139.865 Y134.081 E.25246
G1 X139.865 Y133.546 E.01653
G1 X133.546 Y139.865 E.27584
G1 X133.01 Y139.865 E.01653
G1 X139.865 Y133.01 E.29923
G1 X139.865 Y132.474 E.01653
G1 X132.474 Y139.865 E.32261
G1 X131.938 Y139.865 E.01653
G1 X139.865 Y131.938 E.34599
G1 X139.865 Y131.403 E.01653
G1 X131.403 Y139.865 E.36938
G1 X130.867 Y139.865 E.01653
G1 X139.865 Y130.867 E.39276
G1 X139.865 Y130.331 E.01653
G1 X130.331 Y139.865 E.41615
G1 X129.796 Y139.865 E.01653
G1 X139.865 Y129.796 E.43953
G1 X139.865 Y129.26 E.01653
G1 X129.26 Y139.865 E.46291
G1 X128.724 Y139.865 E.01653
G1 X139.865 Y128.724 E.4863
G1 X139.865 Y128.189 E.01653
G1 X128.189 Y139.865 E.50968
G1 X127.653 Y139.865 E.01653
G1 X139.865 Y127.653 E.53307
G1 X139.865 Y127.117 E.01653
G1 X127.117 Y139.865 E.55645
G1 X126.582 Y139.865 E.01653
G1 X139.865 Y126.582 E.57983
G1 X139.865 Y126.046 E.01653
G1 X126.046 Y139.865 E.60322
G1 X125.51 Y139.865 E.01653
G1 X139.865 Y125.51 E.6266
G1 X139.865 Y124.975 E.01653
G1 X124.975 Y139.865 E.64998
G1 X124.439 Y139.865 E.01653
G1 X139.865 Y124.439 E.67337
G1 X139.865 Y123.903 E.01653
G1 X123.903 Y139.865 E.69675
G1 X123.367 Y139.865 E.01653
G1 X139.865 Y123.367 E.72014
G1 X139.865 Y122.832 E.01653
G1 X122.832 Y139.865 E.74352
G1 X122.296 Y139.865 E.01653
G1 X139.865 Y122.296 E.7669
G1 X139.865 Y121.76 E.01653
G1 X121.76 Y139.865 E.79029
G1 X121.225 Y139.865 E.01653
G1 X139.865 Y121.225 E.81367
G1 X139.865 Y120.689 E.01653
G1 X120.689 Y139.865 E.83706
G1 X120.153 Y139.865 E.01653
G1 X139.865 Y120.153 E.86044
G1 X139.865 Y119.618 E.01653
G1 X119.618 Y139.865 E.88382
G1 X119.082 Y139.865 E.01653
G1 X139.865 Y119.082 E.90721
G1 X139.865 Y118.546 E.01653
G1 X118.546 Y139.865 E.93059
G1 X118.011 Y139.865 E.01653
G1 X139.865 Y118.011 E.95398
G1 X139.865 Y117.475 E.01653
G1 X117.475 Y139.865 E.97736
G1 X116.939 Y139.865 E.01653
G1 X139.865 Y116.939 E1.00074
G1 X139.865 Y116.403 E.01653
G1 X116.403 Y139.865 E1.02413
G1 X116.135 Y139.865 E.00828
G1 X116.135 Y139.597 E.00826
G1 X139.597 Y116.135 E1.02415
G1 X139.061 Y116.135 E.01653
G1 X116.135 Y139.061 E1.00077
G1 X116.135 Y138.526 E.01653
G1 X138.526 Y116.135 E.97739
G1 X137.99 Y116.135 E.01653
G1 X116.135 Y137.99 E.954
G1 X116.135 Y137.454 E.01653
G1 X137.454 Y116.135 E.93062
G1 X136.919 Y116.135 E.01653
G1 X116.135 Y136.919 E.90723
G1 X116.135 Y136.383 E.01653
G1 X136.383 Y116.135 E.88385
G1 X135.847 Y116.135 E.01653
G1 X116.135 Y135.847 E.86047
G1 X116.135 Y135.312 E.01653
G1 X135.312 Y116.135 E.83708
G1 X134.776 Y116.135 E.01653
G1 X116.135 Y134.776 E.8137
G1 X116.135 Y134.24 E.01653
G1 X134.24 Y116.135 E.79031
G1 X133.705 Y116.135 E.01653
G1 X116.135 Y133.705 E.76693
G1 X116.135 Y133.169 E.01653
G1 X133.169 Y116.135 E.74355
G1 X132.633 Y116.135 E.01653
G1 X116.135 Y132.633 E.72016
G1 X116.135 Y132.097 E.01653
G1 X132.097 Y116.135 E.69678
G1 X131.562 Y116.135 E.01653
G1 X116.135 Y131.562 E.6734
G1 X116.135 Y131.026 E.01653
G1 X131.026 Y116.135 E.65001
G1 X130.49 Y116.135 E.01653
G1 X116.135 Y130.49 E.62663
G1 X116.135 Y129.955 E.01653
G1 X129.955 Y116.135 E.60324
G1 X129.419 Y116.135 E.01653
G1 X116.135 Y129.419 E.57986
G1 X116.135 Y128.883 E.01653
G1 X128.883 Y116.135 E.55648
G1 X128.348 Y116.135 E.01653
G1 X116.135 Y128.348 E.53309
G1 X116.135 Y127.812 E.01653
G1 X127.812 Y116.135 E.50971
G1 X127.276 Y116.135 E.01653
G1 X116.135 Y127.276 E.48632
G1 X116.135 Y126.741 E.01653
G1 X126.741 Y116.135 E.46294
G1 X126.205 Y116.135 E.01653
G1 X116.135 Y126.205 E.43956
G1 X116.135 Y125.669 E.01653
G1 X125.669 Y116.135 E.41617
G1 X125.134 Y116.135 E.01653
G1 X116.135 Y125.134 E.39279
G1 X116.135 Y124.598 E.01653
G1 X124.598 Y116.135 E.3694
G1 X124.062 Y116.135 E.01653
G1 X116.135 Y124.062 E.34602
G1 X116.135 Y123.526 E.01653
G1 X123.526 Y116.135 E.32264
G1 X122.991 Y116.135 E.01653
G1 X116.135 Y122.991 E.29925
G1 X116.135 Y122.455 E.01653
G1 X122.455 Y116.135 E.27587
G1 X121.919 Y116.135 E.01653
G1 X116.135 Y121.919 E.25249
G1 X116.135 Y121.384 E.01653
G1 X121.384 Y116.135 E.2291
G1 X120.848 Y116.135 E.01653
G1 X116.135 Y120.848 E.20572
G1 X116.135 Y120.312 E.01653
G1 X120.312 Y116.135 E.18233
G1 X119.777 Y116.135 E.01653
G1 X116.135 Y119.777 E.15895
G1 X116.135 Y119.241 E.01653
G1 X119.241 Y116.135 E.13557
G1 X118.705 Y116.135 E.01653
G1 X116.135 Y118.705 E.11218
G1 X116.135 Y118.17 E.01653
G1 X118.17 Y116.135 E.0888
G1 X117.634 Y116.135 E.01653
G1 X116.135 Y117.634 E.06541
G1 X116.135 Y117.098 E.01653
G1 X117.098 Y116.135 E.04203
G1 X116.562 Y116.135 E.01653
G1 X115.966 Y116.732 E.02605
; CHANGE_LAYER
; Z_HEIGHT: 25.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X116.562 Y116.135 E-.32074
G1 X117.098 Y116.135 E-.20356
G1 X116.66 Y116.574 E-.2357
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 127/128
; update layer progress
M73 L127
M991 S0 P126 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z25.6 I-.862 J.859 P1  F42000
G1 X140.198 Y140.198 Z25.6
G1 Z25.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
M204 S6000
G1 X115.802 Y140.198 E.80926
G1 X115.802 Y115.802 E.80926
G1 X140.198 Y115.802 E.80926
G1 X140.198 Y140.138 E.80727
M204 S10000
G1 X140.59 Y140.59 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z25.8 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z25.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z25.8 F4000
            G39.3 S1
            G0 Z25.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X116.732 Y140.034 F42000
G1 Z25.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42171
G1 F15000
M204 S6000
G1 X116.135 Y139.438 E.02605
G1 X116.135 Y138.902 E.01653
G1 X117.098 Y139.865 E.04203
G1 X117.634 Y139.865 E.01653
G1 X116.135 Y138.366 E.06541
G1 X116.135 Y137.83 E.01653
G1 X118.17 Y139.865 E.0888
G1 X118.705 Y139.865 E.01653
G1 X116.135 Y137.295 E.11218
G1 X116.135 Y136.759 E.01653
G1 X119.241 Y139.865 E.13557
G1 X119.777 Y139.865 E.01653
G1 X116.135 Y136.223 E.15895
G1 X116.135 Y135.688 E.01653
G1 X120.312 Y139.865 E.18233
G1 X120.848 Y139.865 E.01653
G1 X116.135 Y135.152 E.20572
G1 X116.135 Y134.616 E.01653
G1 X121.384 Y139.865 E.2291
G1 X121.919 Y139.865 E.01653
G1 X116.135 Y134.081 E.25249
G1 X116.135 Y133.545 E.01653
G1 X122.455 Y139.865 E.27587
G1 X122.991 Y139.865 E.01653
G1 X116.135 Y133.009 E.29925
G1 X116.135 Y132.474 E.01653
G1 X123.526 Y139.865 E.32264
G1 X124.062 Y139.865 E.01653
G1 X116.135 Y131.938 E.34602
G1 X116.135 Y131.402 E.01653
G1 X124.598 Y139.865 E.3694
G1 X125.134 Y139.865 E.01653
G1 X116.135 Y130.866 E.39279
G1 X116.135 Y130.331 E.01653
G1 X125.669 Y139.865 E.41617
G1 X126.205 Y139.865 E.01653
G1 X116.135 Y129.795 E.43956
G1 X116.135 Y129.259 E.01653
G1 X126.741 Y139.865 E.46294
G1 X127.276 Y139.865 E.01653
G1 X116.135 Y128.724 E.48632
G1 X116.135 Y128.188 E.01653
G1 X127.812 Y139.865 E.50971
G1 X128.348 Y139.865 E.01653
G1 X116.135 Y127.652 E.53309
G1 X116.135 Y127.117 E.01653
G1 X128.883 Y139.865 E.55648
M73 P96 R1
G1 X129.419 Y139.865 E.01653
G1 X116.135 Y126.581 E.57986
G1 X116.135 Y126.045 E.01653
G1 X129.955 Y139.865 E.60324
G1 X130.49 Y139.865 E.01653
G1 X116.135 Y125.51 E.62663
G1 X116.135 Y124.974 E.01653
G1 X131.026 Y139.865 E.65001
G1 X131.562 Y139.865 E.01653
G1 X116.135 Y124.438 E.6734
G1 X116.135 Y123.903 E.01653
G1 X132.097 Y139.865 E.69678
G1 X132.633 Y139.865 E.01653
G1 X116.135 Y123.367 E.72016
G1 X116.135 Y122.831 E.01653
G1 X133.169 Y139.865 E.74355
G1 X133.705 Y139.865 E.01653
G1 X116.135 Y122.295 E.76693
G1 X116.135 Y121.76 E.01653
G1 X134.24 Y139.865 E.79031
G1 X134.776 Y139.865 E.01653
G1 X116.135 Y121.224 E.8137
G1 X116.135 Y120.688 E.01653
G1 X135.312 Y139.865 E.83708
G1 X135.847 Y139.865 E.01653
G1 X116.135 Y120.153 E.86047
G1 X116.135 Y119.617 E.01653
G1 X136.383 Y139.865 E.88385
G1 X136.919 Y139.865 E.01653
G1 X116.135 Y119.081 E.90723
G1 X116.135 Y118.546 E.01653
G1 X137.454 Y139.865 E.93062
G1 X137.99 Y139.865 E.01653
G1 X116.135 Y118.01 E.954
G1 X116.135 Y117.474 E.01653
G1 X138.526 Y139.865 E.97739
G1 X139.061 Y139.865 E.01653
G1 X116.135 Y116.939 E1.00077
G1 X116.135 Y116.403 E.01653
G1 X139.597 Y139.865 E1.02415
G1 X139.865 Y139.865 E.00826
G1 X139.865 Y139.597 E.00828
G1 X116.403 Y116.135 E1.02413
G1 X116.939 Y116.135 E.01653
G1 X139.865 Y139.061 E1.00074
G1 X139.865 Y138.525 E.01653
G1 X117.475 Y116.135 E.97736
G1 X118.011 Y116.135 E.01653
G1 X139.865 Y137.989 E.95398
G1 X139.865 Y137.454 E.01653
G1 X118.546 Y116.135 E.93059
G1 X119.082 Y116.135 E.01653
G1 X139.865 Y136.918 E.90721
G1 X139.865 Y136.382 E.01653
G1 X119.618 Y116.135 E.88382
G1 X120.153 Y116.135 E.01653
G1 X139.865 Y135.847 E.86044
G1 X139.865 Y135.311 E.01653
G1 X120.689 Y116.135 E.83706
G1 X121.225 Y116.135 E.01653
G1 X139.865 Y134.775 E.81367
G1 X139.865 Y134.24 E.01653
G1 X121.76 Y116.135 E.79029
G1 X122.296 Y116.135 E.01653
G1 X139.865 Y133.704 E.7669
G1 X139.865 Y133.168 E.01653
G1 X122.832 Y116.135 E.74352
G1 X123.367 Y116.135 E.01653
G1 X139.865 Y132.633 E.72014
G1 X139.865 Y132.097 E.01653
G1 X123.903 Y116.135 E.69675
G1 X124.439 Y116.135 E.01653
G1 X139.865 Y131.561 E.67337
G1 X139.865 Y131.025 E.01653
G1 X124.975 Y116.135 E.64998
G1 X125.51 Y116.135 E.01653
G1 X139.865 Y130.49 E.6266
G1 X139.865 Y129.954 E.01653
G1 X126.046 Y116.135 E.60322
G1 X126.582 Y116.135 E.01653
G1 X139.865 Y129.418 E.57983
G1 X139.865 Y128.883 E.01653
G1 X127.117 Y116.135 E.55645
G1 X127.653 Y116.135 E.01653
G1 X139.865 Y128.347 E.53307
G1 X139.865 Y127.811 E.01653
G1 X128.189 Y116.135 E.50968
G1 X128.724 Y116.135 E.01653
G1 X139.865 Y127.276 E.4863
G1 X139.865 Y126.74 E.01653
G1 X129.26 Y116.135 E.46291
M73 P96 R0
G1 X129.796 Y116.135 E.01653
G1 X139.865 Y126.204 E.43953
G1 X139.865 Y125.669 E.01653
G1 X130.331 Y116.135 E.41615
G1 X130.867 Y116.135 E.01653
G1 X139.865 Y125.133 E.39276
G1 X139.865 Y124.597 E.01653
G1 X131.403 Y116.135 E.36938
G1 X131.938 Y116.135 E.01653
G1 X139.865 Y124.062 E.34599
G1 X139.865 Y123.526 E.01653
G1 X132.474 Y116.135 E.32261
G1 X133.01 Y116.135 E.01653
G1 X139.865 Y122.99 E.29923
G1 X139.865 Y122.454 E.01653
G1 X133.546 Y116.135 E.27584
G1 X134.081 Y116.135 E.01653
G1 X139.865 Y121.919 E.25246
G1 X139.865 Y121.383 E.01653
G1 X134.617 Y116.135 E.22907
G1 X135.153 Y116.135 E.01653
G1 X139.865 Y120.847 E.20569
G1 X139.865 Y120.312 E.01653
G1 X135.688 Y116.135 E.18231
G1 X136.224 Y116.135 E.01653
G1 X139.865 Y119.776 E.15892
G1 X139.865 Y119.24 E.01653
G1 X136.76 Y116.135 E.13554
G1 X137.295 Y116.135 E.01653
G1 X139.865 Y118.705 E.11215
G1 X139.865 Y118.169 E.01653
G1 X137.831 Y116.135 E.08877
G1 X138.367 Y116.135 E.01653
G1 X139.865 Y117.633 E.06539
G1 X139.865 Y117.098 E.01653
G1 X138.902 Y116.135 E.042
G1 X139.438 Y116.135 E.01653
G1 X140.034 Y116.732 E.02603
; CHANGE_LAYER
; Z_HEIGHT: 25.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X139.438 Y116.135 E-.32041
G1 X138.902 Y116.135 E-.20356
G1 X139.342 Y116.575 E-.23603
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 128/128
; update layer progress
M73 L128
M991 S0 P127 ;notify layer change
; OBJECT_ID: 69
M204 S10000
G17
G3 Z25.8 I-1.215 J.063 P1  F42000
G1 X140.59 Y140.59 Z25.8
G1 Z25.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X115.41 Y140.59 E.77371
G1 X115.41 Y115.41 E.77371
G1 X140.59 Y115.41 E.77371
G1 X140.59 Y140.53 E.77187
; WIPE_START
M204 S6000
G1 X138.59 Y140.535 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z26 I1.217 J0 P1  F42000
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z26
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z26 F4000
            G39.3 S1
            G0 Z26 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


G1 X140.383 Y139.881 F42000
G1 Z25.6
G1 E.8 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X139.881 Y140.383 E.02182
G1 X139.347 Y140.383
G1 X140.383 Y139.347 E.04499
G1 X140.383 Y138.814
G1 X138.814 Y140.383 E.06816
G1 X138.281 Y140.383
G1 X140.383 Y138.281 E.09134
G1 X140.383 Y137.747
G1 X137.747 Y140.383 E.11451
G1 X137.214 Y140.383
G1 X140.383 Y137.214 E.13768
G1 X140.383 Y136.681
G1 X136.681 Y140.383 E.16085
G1 X136.148 Y140.383
G1 X140.383 Y136.148 E.18403
G1 X140.383 Y135.614
G1 X135.614 Y140.383 E.2072
G1 X135.081 Y140.383
G1 X140.383 Y135.081 E.23037
G1 X140.383 Y134.548
G1 X134.548 Y140.383 E.25355
G1 X134.015 Y140.383
G1 X140.383 Y134.015 E.27672
G1 X140.383 Y133.481
G1 X133.481 Y140.383 E.29989
G1 X132.948 Y140.383
G1 X140.383 Y132.948 E.32306
G1 X140.383 Y132.415
G1 X132.415 Y140.383 E.34624
G1 X131.882 Y140.383
G1 X140.383 Y131.882 E.36941
G1 X140.383 Y131.348
G1 X131.348 Y140.383 E.39258
G1 X130.815 Y140.383
G1 X140.383 Y130.815 E.41575
G1 X140.383 Y130.282
G1 X130.282 Y140.383 E.43893
G1 X129.749 Y140.383
G1 X140.383 Y129.749 E.4621
G1 X140.383 Y129.215
G1 X129.215 Y140.383 E.48527
G1 X128.682 Y140.383
G1 X140.383 Y128.682 E.50844
G1 X140.383 Y128.149
G1 X128.149 Y140.383 E.53162
G1 X127.616 Y140.383
G1 X140.383 Y127.616 E.55479
G1 X140.383 Y127.082
G1 X127.082 Y140.383 E.57796
G1 X126.549 Y140.383
G1 X140.383 Y126.549 E.60113
G1 X140.383 Y126.016
G1 X126.016 Y140.383 E.62431
G1 X125.483 Y140.383
G1 X140.383 Y125.483 E.64748
G1 X140.383 Y124.949
G1 X124.949 Y140.383 E.67065
G1 X124.416 Y140.383
G1 X140.383 Y124.416 E.69382
G1 X140.383 Y123.883
G1 X123.883 Y140.383 E.717
G1 X123.35 Y140.383
G1 X140.383 Y123.35 E.74017
G1 X140.383 Y122.816
G1 X122.816 Y140.383 E.76334
G1 X122.283 Y140.383
G1 X140.383 Y122.283 E.78652
G1 X140.383 Y121.75
M73 P97 R0
G1 X121.75 Y140.383 E.80969
G1 X121.217 Y140.383
G1 X140.383 Y121.217 E.83286
G1 X140.383 Y120.683
G1 X120.683 Y140.383 E.85603
G1 X120.15 Y140.383
G1 X140.383 Y120.15 E.87921
G1 X140.383 Y119.617
G1 X119.617 Y140.383 E.90238
G1 X119.083 Y140.383
G1 X140.383 Y119.083 E.92555
G1 X140.383 Y118.55
G1 X118.55 Y140.383 E.94872
G1 X118.017 Y140.383
G1 X140.383 Y118.017 E.9719
G1 X140.383 Y117.484
G1 X117.484 Y140.383 E.99507
G1 X116.95 Y140.383
G1 X140.383 Y116.95 E1.01824
G1 X140.383 Y116.417
G1 X116.417 Y140.383 E1.04141
G1 X115.884 Y140.383
G1 X140.383 Y115.884 E1.06459
G1 X140.116 Y115.617
G1 X115.617 Y140.116 E1.06458
G1 X115.617 Y139.583
G1 X139.583 Y115.617 E1.04141
G1 X139.049 Y115.617
G1 X115.617 Y139.049 E1.01824
G1 X115.617 Y138.516
G1 X138.516 Y115.617 E.99506
G1 X137.983 Y115.617
G1 X115.617 Y137.983 E.97189
G1 X115.617 Y137.45
G1 X137.45 Y115.617 E.94872
G1 X136.916 Y115.617
G1 X115.617 Y136.916 E.92555
G1 X115.617 Y136.383
G1 X136.383 Y115.617 E.90237
G1 X135.85 Y115.617
G1 X115.617 Y135.85 E.8792
G1 X115.617 Y135.317
G1 X135.317 Y115.617 E.85603
G1 X134.783 Y115.617
G1 X115.617 Y134.783 E.83286
G1 X115.617 Y134.25
G1 X134.25 Y115.617 E.80968
G1 X133.717 Y115.617
G1 X115.617 Y133.717 E.78651
G1 X115.617 Y133.184
G1 X133.184 Y115.617 E.76334
G1 X132.65 Y115.617
G1 X115.617 Y132.65 E.74016
G1 X115.617 Y132.117
G1 X132.117 Y115.617 E.71699
G1 X131.584 Y115.617
G1 X115.617 Y131.584 E.69382
G1 X115.617 Y131.051
G1 X131.051 Y115.617 E.67065
G1 X130.517 Y115.617
G1 X115.617 Y130.517 E.64747
G1 X115.617 Y129.984
G1 X129.984 Y115.617 E.6243
G1 X129.451 Y115.617
G1 X115.617 Y129.451 E.60113
G1 X115.617 Y128.918
G1 X128.918 Y115.617 E.57796
G1 X128.384 Y115.617
G1 X115.617 Y128.384 E.55478
G1 X115.617 Y127.851
G1 X127.851 Y115.617 E.53161
G1 X127.318 Y115.617
G1 X115.617 Y127.318 E.50844
G1 X115.617 Y126.784
G1 X126.784 Y115.617 E.48527
G1 X126.251 Y115.617
G1 X115.617 Y126.251 E.46209
G1 X115.617 Y125.718
G1 X125.718 Y115.617 E.43892
G1 X125.185 Y115.617
G1 X115.617 Y125.185 E.41575
G1 X115.617 Y124.651
G1 X124.651 Y115.617 E.39258
G1 X124.118 Y115.617
G1 X115.617 Y124.118 E.3694
G1 X115.617 Y123.585
G1 X123.585 Y115.617 E.34623
G1 X123.052 Y115.617
G1 X115.617 Y123.052 E.32306
G1 X115.617 Y122.518
G1 X122.518 Y115.617 E.29988
G1 X121.985 Y115.617
G1 X115.617 Y121.985 E.27671
G1 X115.617 Y121.452
G1 X121.452 Y115.617 E.25354
G1 X120.919 Y115.617
G1 X115.617 Y120.919 E.23037
G1 X115.617 Y120.385
G1 X120.385 Y115.617 E.20719
G1 X119.852 Y115.617
G1 X115.617 Y119.852 E.18402
G1 X115.617 Y119.319
G1 X119.319 Y115.617 E.16085
G1 X118.786 Y115.617
G1 X115.617 Y118.786 E.13768
G1 X115.617 Y118.252
G1 X118.252 Y115.617 E.1145
G1 X117.719 Y115.617
G1 X115.617 Y117.719 E.09133
G1 X115.617 Y117.186
G1 X117.186 Y115.617 E.06816
G1 X116.653 Y115.617
G1 X115.617 Y116.653 E.04499
G1 X115.617 Y116.119
G1 X116.119 Y115.617 E.02181
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S6000
G1 X115.617 Y116.119 E-.26976
G1 X115.617 Y116.653 E-.20264
G1 X116.153 Y116.117 E-.2876
; WIPE_END
G1 E-.04 F1800
M106 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20231229 =====================
G392 S0 ;turn off nozzle clog detect

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z26.1 F900 ; lower z a little
G1 X0 Y128 F18000 ; move to safe pos
G1 X-13.0 F3000 ; move to safe pos

M1002 judge_flag timelapse_record_flag
M622 J1
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M991 S0 P-1 ;end timelapse at safe pos
M623


M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

;G1 X27 F15000 ; wipe

; pull back filament to AMS
M620 S255
G1 X267 F15000
T255
G1 X-28.5 F18000
G1 X-48.2 F3000
G1 X-28.5 F18000
G1 X-48.2 F3000
M621 S255

M104 S0 ; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z125.6 F600
    G1 Z123.6

M400 P100
M17 R ; restore z current

G90
G1 X-48 Y180 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M400
M18 X Y Z

M73 P100 R0
; ==== A1 PLATE_SWAP_FULL ====
G90;
;M211 S0                ; disable soft endstops

; --- Pull off sequence ---

G0 Y266 Z260 F2500      ; bring plate in position and raise Z to activate front hook
G4 P1000
G0 Y50 F1000
G0 Y0 Z160 F2500        ; hook new plate and lower Z

; --- Push build plate off buildplate ---

G0 Y170 F2000           ; rehook old plate at second front hook
G0 Y43 F2000            ; release old plate from bed almost entirely

; --- Set new plate sequence ---

G0 Y266 F2000           ; pull new plate forward and push off old plate
G0  Y20 F2000           ; move to "set" position
G4  P500
G0  Y0 F300             ; snap plate
G0  Y5 F300             ; let plate fall
G4  P500
G0  Y150 F2000          ; safe park position
; ==== Ende SWAP_FULL ====
; EXECUTABLE_BLOCK_END

