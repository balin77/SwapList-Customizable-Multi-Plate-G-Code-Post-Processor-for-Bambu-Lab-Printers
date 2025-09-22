; HEADER_BLOCK_START
; BambuStudio 02.02.02.56
; model printing time: 4m 1s; total estimated time: 10m 16s
; total layer number: 25
; total filament length [mm] : 120.79
; total filament volume [cm^3] : 290.55
; total filament weight [g] : 0.38
; model label id: 69,141
; filament_density: 1.31,1.31
; filament_diameter: 1.75,1.75
; max_z_height: 5.00
; filament: 1
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0
; additional_cooling_fan_speed = 70,70
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
; chamber_temperatures = 0,0
; change_filament_gcode = ;===== A1 20250206 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nM620.10 A0 F[old_filament_e_feedrate]\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\nM620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[nozzle_temperature_range_high]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200
; close_fan_the_first_x_layers = 1,1
; complete_print_exhaust_fan_speed = 70,70
; cool_plate_temp = 35,35
; cool_plate_temp_initial_layer = 35,35
; counter_coef_1 = 0,0
; counter_coef_2 = 0.008,0.008
; counter_coef_3 = -0.041,-0.041
; counter_limit_max = 0.033,0.033
; counter_limit_min = -0.035,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 6000
; default_filament_colour = ;
; default_filament_profile = "Bambu PLA Basic @BBL A1"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL A1
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50
; different_settings_to_system = enable_prime_tower;;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70
; elefant_foot_compensation = 0.075
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1,1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0,0
; enable_prime_tower = 0
; enable_support = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 0,0
; eng_plate_temp_initial_layer = 0,0
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
; fan_cooling_layer_time = 80,80
; fan_max_speed = 80,80
; fan_min_speed = 60,60
; filament_adaptive_volumetric_speed = 0,0
; filament_adhesiveness_category = 100,100
; filament_change_length = 10,10
; filament_colour = #C12E1E;#FFFF00
; filament_colour_type = 0;1
; filament_cost = 25.4,25.4
; filament_density = 1.31,1.31
; filament_diameter = 1.75,1.75
; filament_end_gcode = "; filament end gcode \n\n";"; filament end gcode \n\n"
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.98,0.98
; filament_flush_temp = 0,0
; filament_flush_volumetric_speed = 0,0
; filament_ids = GFL01;GFL01
; filament_is_support = 0,0
; filament_map = 1,1
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 22,22
; filament_minimal_purge_on_wipe_tower = 15,15
; filament_multi_colour = #C12E1E;#FFFF00
; filament_notes = 
; filament_pre_cooling_temperature = 0,0
; filament_prime_volume = 45,45
; filament_printable = 3,3
; filament_ramming_travel_time = 0,0
; filament_ramming_volumetric_speed = -1,-1
; filament_scarf_gap = 15%,15%
; filament_scarf_height = 10%,10%
; filament_scarf_length = 10,10
; filament_scarf_seam_type = none,none
; filament_self_index = 1,2
; filament_settings_id = "PolyTerra PLA @BBL A1";"PolyTerra PLA @BBL A1"
; filament_shrink = 100%,100%
; filament_soluble = 0,0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_type = PLA;PLA
; filament_velocity_adaptation_factor = 1,1
; filament_vendor = Polymaker;Polymaker
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,512,182,0
; flush_volumes_vector = 140,140,140,140
; full_fan_speed_layer = 0,0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 17.4
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 226x224,256x224,256x256,226x256
; hole_coef_1 = 0,0
; hole_coef_2 = -0.008,-0.008
; hole_coef_3 = 0.23415,0.23415
; hole_limit_max = 0.22,0.22
; hole_limit_min = 0.088,0.088
; host_type = octoprint
; hot_plate_temp = 65,65
; hot_plate_temp_initial_layer = 65,65
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 10,10
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
; long_retractions_when_ec = 0,0
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
; nozzle_temperature = 220,220
; nozzle_temperature_initial_layer = 220,220
; nozzle_temperature_range_high = 240,240
; nozzle_temperature_range_low = 190,190
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
; overhang_fan_speed = 100,100
; overhang_fan_threshold = 50%,50%
; overhang_threshold_participating_cooling = 95%,95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0,0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02
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
; reduce_fan_stop_start_freq = 1,1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3,3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 255
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0,0
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
; slow_down_for_layer_cooling = 1,1
; slow_down_layer_time = 8,8
; slow_down_min_speed = 20,20
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
; supertack_plate_temp = 45,45
; supertack_plate_temp_initial_layer = 45,45
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
; temperature_vitrification = 45,45
; template_custom_gcode = 
; textured_plate_temp = 65,65
; textured_plate_temp_initial_layer = 65,65
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
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0"
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
M73 P0 R10
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
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18 
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
M73 P1 R10
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
M620 S0A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S220
    M104 S250
    M400
    T0
    G1 X-48.2 F3000
    M400

    M620.1 E F548.788 T240
    M109 S250 ;set nozzle to common flush temp
    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:PLA
M621 S0A

M109 S240 H300
G92 E0
G1 E50 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S178
G92 E0
G1 E5 F200
M104 S220
G92 E0
M73 P5 R9
G1 E-0.5 F300

G1 X-28.5 F30000
M73 P8 R9
G1 X-48.2 F3000
M73 P10 R9
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
    G1 E10 F377.08
    M983 F6.28466 A0.3 H0.4; cali dynamic extrusion compensation

    M106 P1 S255
    M400 S5
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
M73 P11 R9
    G1 X-48.2 F3000
M73 P13 R8
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0

    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F6.28466 A0.3 H0.4; cali dynamic extrusion compensation
        M106 P1 S255
        M400 S5
        G1 X-28.5 F18000
        G1 X-48.2 F3000
        G1 X-28.5 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-28.5 F12000 ;wipe and shake
        M400
        M106 P1 S0
    M623
    
M73 P14 R8
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F6.28466 H0.4
    M106 P1 S178
    M400 S7
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
M73 P15 R8
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
M73 P57 R4
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
M73 P58 R4
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
M73 P59 R4
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
    G29 A1 X119.5 Y125.5 I11 J5
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
; layer num/total_layer_count: 1/25
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X129.718 Y129.718 F42000
M204 S6000
G1 Z.4
M73 P60 R4
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F1200
M204 S500
G1 X126.282 Y129.718 E.12797
G1 X126.282 Y126.282 E.12797
G1 X129.718 Y126.282 E.12797
G1 X129.718 Y129.658 E.12574
M204 S6000
G1 X130.175 Y130.175 F42000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X125.825 Y130.175 E.16202
G1 X125.825 Y125.825 E.16202
G1 X130.175 Y125.825 E.16202
G1 X130.175 Y130.115 E.15979
; WIPE_START
G1 F3000
G1 X128.175 Y130.143 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 1 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer1 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.542 Y126.465 F42000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.53253
G1 F1200
M204 S500
G1 X129.329 Y127.252 E.04442
G1 X129.329 Y127.945 E.02763
G1 X128.055 Y126.671 E.07188
G1 X127.363 Y126.671 E.02763
G1 X129.329 Y128.637 E.11095
G1 X129.329 Y129.329 E.02763
G1 X126.671 Y126.671 E.15002
M73 P61 R4
G1 X126.671 Y127.363 E.02763
G1 X128.637 Y129.329 E.11095
G1 X127.945 Y129.329 E.02763
G1 X126.671 Y128.055 E.07188
G1 X126.671 Y128.748 E.02763
G1 X127.458 Y129.535 E.04442
; OBJECT_ID: 141
; WIPE_START
G1 F6300
G1 X126.671 Y128.748 E-.42309
M73 P61 R3
G1 X126.671 Y128.055 E-.26312
G1 X126.808 Y128.193 E-.07379
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S6000
G1 X123.718 Y129.718 Z.6 F42000
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F1200
M204 S500
G1 X120.282 Y129.718 E.12797
G1 X120.282 Y126.282 E.12797
G1 X123.718 Y126.282 E.12797
G1 X123.718 Y129.658 E.12574
M204 S6000
G1 X124.175 Y130.175 F42000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X119.825 Y130.175 E.16202
G1 X119.825 Y125.825 E.16202
G1 X124.175 Y125.825 E.16202
G1 X124.175 Y130.115 E.15979
; WIPE_START
G1 F3000
G1 X122.175 Y130.143 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X122.542 Y126.465 Z.6 F42000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.53253
G1 F1200
M204 S500
G1 X123.329 Y127.252 E.04442
G1 X123.329 Y127.945 E.02763
G1 X122.055 Y126.671 E.07188
G1 X121.363 Y126.671 E.02763
G1 X123.329 Y128.637 E.11095
G1 X123.329 Y129.329 E.02763
G1 X120.671 Y126.671 E.15002
G1 X120.671 Y127.363 E.02763
G1 X122.637 Y129.329 E.11095
G1 X121.945 Y129.329 E.02763
G1 X120.671 Y128.055 E.07188
G1 X120.671 Y128.748 E.02763
G1 X121.458 Y129.535 E.04442
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X120.671 Y128.748 E-.42309
G1 X120.671 Y128.055 E-.26312
G1 X120.808 Y128.193 E-.07379
; WIPE_END
M73 P62 R3
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 2/25
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S201.45
; open powerlost recovery
M1003 S1
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z.6 I-.224 J1.196 P1  F42000
G1 X129.898 Y129.898 Z.6
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1291
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1291
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 2 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer2 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1291
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1291
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1291
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1291
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1291
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z.8 F42000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1291
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
M73 P63 R3
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1291
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z.8 F42000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1291
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1291
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1291
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1291
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1291
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 3/25
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z.8
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 3 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer3 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
M73 P64 R3
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z1 F42000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z1 F42000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
M73 P65 R3
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 4/25
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z1
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 4 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer4 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
M73 P66 R3
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z1.2 F42000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z1.2 F42000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 5/25
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z1.2
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 5 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer5 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
M73 P67 R3
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z1.4 F42000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z1.4 F42000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
M73 P68 R3
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 6/25
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z1.4
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 6 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer6 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z1.6 F42000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
M73 P69 R3
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z1.6 F42000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 7/25
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.6 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z1.6
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 7 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer7 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
M73 P70 R3
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z1.8 F42000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z1.8 F42000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
M73 P70 R2
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 8/25
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.8 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z1.8
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
M73 P71 R2
G1 E-.04 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 8 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer8 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z2 F42000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z2 F42000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
M73 P72 R2
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 9/25
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 9 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer9 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
M73 P73 R2
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z2.2 F42000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z2.2 F42000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 10/25
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.2 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z2.2
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 10 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer10 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
M73 P74 R2
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z2.4 F42000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z2.4 F42000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
M73 P75 R2
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 11/25
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.4 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z2.4
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 11 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer11 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z2.6 F42000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P76 R2
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z2.6 F42000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 12/25
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.6 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z2.6
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 12 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer12 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
M73 P77 R2
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z2.8 F42000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z2.8 F42000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
M73 P78 R2
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 13/25
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.8 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z2.8
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 13 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer13 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z3 F42000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
M73 P79 R2
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z3 F42000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 14/25
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z3
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 14 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer14 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
M73 P80 R2
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z3.2 F42000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z3.2 F42000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
M73 P80 R1
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 15/25
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.2 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z3.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
M73 P81 R1
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 15 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer15 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z3.4 F42000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
M73 P82 R1
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z3.4 F42000
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 16/25
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.4 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z3.4
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 16 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer16 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z3.6 F42000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
M73 P83 R1
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z3.6 F42000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 17/25
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.6 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z3.6
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.8 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 17 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer17 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z3.4
M73 P84 R1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z3.8 F42000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z3.8 F42000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
M73 P85 R1
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 18/25
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.8 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z3.8
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 18 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer18 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z4 F42000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
M73 P86 R1
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z4 F42000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 19/25
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z4
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 19 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer19 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
M73 P87 R1
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z4.2 F42000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z4.2 F42000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
M73 P88 R1
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 20/25
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.2 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z4.2
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 20 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer20 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z4.4 F42000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z4.4 F42000
G1 Z4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
M73 P89 R1
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 21/25
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.4 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z4.4
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 21 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer21 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
M73 P90 R1
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z4.6 F42000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z4.6 F42000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
M73 P90 R0
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 22/25
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.6 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z4.6
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
M73 P91 R0
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 22 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer22 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z4.8 F42000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z4.8 F42000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
M73 P92 R0
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 23/25
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.8 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z4.8
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 23 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer23 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z5 F42000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
M73 P93 R0
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z5 F42000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 24/25
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5 I-.069 J1.215 P1  F42000
G1 X129.898 Y129.898 Z5
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X126.102 Y129.898 E.12592
G1 X126.102 Y126.102 E.12592
G1 X129.898 Y126.102 E.12592
G1 X129.898 Y129.838 E.12393
M204 S10000
G1 X130.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.2 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 24 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer24 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X128.023 Y127.96 F42000
M73 P94 R0
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X127.953 Y128 E.00244
G1 X128.012 Y128.034 E.00204
M204 S10000
G1 X128.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X128.375 Y127.625 E.01151
G1 X127.625 Y127.625 E.02302
G1 X127.625 Y128.375 E.02302
G1 X128.375 Y128.375 E.02302
G1 X128.375 Y128.06 E.00967
M204 S10000
G1 X128.752 Y128 F42000
G1 F1288
M204 S6000
G1 X128.752 Y127.248 E.0231
G1 X127.248 Y127.248 E.0462
G1 X127.248 Y128.752 E.0462
G1 X128.752 Y128.752 E.0462
G1 X128.752 Y128.06 E.02125
M204 S10000
G1 X129.129 Y128 F42000
G1 F1288
M204 S6000
G1 X129.129 Y126.871 E.03468
G1 X126.871 Y126.871 E.06937
G1 X126.871 Y129.129 E.06937
G1 X129.129 Y129.129 E.06937
G1 X129.129 Y128.06 E.03284
M204 S10000
G1 X129.506 Y128 F42000
G1 F1288
M204 S6000
G1 X129.506 Y126.494 E.04627
G1 X126.494 Y126.494 E.09254
G1 X126.494 Y129.506 E.09254
G1 X129.506 Y129.506 E.09254
G1 X129.506 Y128.06 E.04443
; OBJECT_ID: 141
; WIPE_START
G1 F15000
G1 X129.506 Y129.506 E-.54943
G1 X128.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.898 Y129.898 Z5.2 F42000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1288
M204 S6000
G1 X120.102 Y129.898 E.12592
G1 X120.102 Y126.102 E.12592
G1 X123.898 Y126.102 E.12592
G1 X123.898 Y129.838 E.12393
M204 S10000
G1 X124.29 Y130.29 F42000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1288
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X122.023 Y127.96 Z5.2 F42000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F1288
M204 S6000
G1 X121.953 Y128 E.00244
G1 X122.012 Y128.034 E.00204
M204 S10000
G1 X122.375 Y128 F42000
; LINE_WIDTH: 0.41999
G1 F1288
M204 S6000
G1 X122.375 Y127.625 E.01151
G1 X121.625 Y127.625 E.02302
G1 X121.625 Y128.375 E.02302
G1 X122.375 Y128.375 E.02302
G1 X122.375 Y128.06 E.00967
M204 S10000
G1 X122.752 Y128 F42000
G1 F1288
M204 S6000
G1 X122.752 Y127.248 E.0231
M73 P95 R0
G1 X121.248 Y127.248 E.0462
G1 X121.248 Y128.752 E.0462
G1 X122.752 Y128.752 E.0462
G1 X122.752 Y128.06 E.02125
M204 S10000
G1 X123.129 Y128 F42000
G1 F1288
M204 S6000
G1 X123.129 Y126.871 E.03468
G1 X120.871 Y126.871 E.06937
G1 X120.871 Y129.129 E.06937
G1 X123.129 Y129.129 E.06937
G1 X123.129 Y128.06 E.03284
M204 S10000
G1 X123.506 Y128 F42000
G1 F1288
M204 S6000
G1 X123.506 Y126.494 E.04627
G1 X120.494 Y126.494 E.09254
G1 X120.494 Y129.506 E.09254
G1 X123.506 Y129.506 E.09254
G1 X123.506 Y128.06 E.04443
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.506 Y129.506 E-.54943
G1 X122.952 Y129.506 E-.21057
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
; layer num/total_layer_count: 25/25
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
; OBJECT_ID: 69
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5.2 I-.129 J1.21 P1  F42000
G1 X130.29 Y130.29 Z5.2
G1 Z5
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1480
M204 S5000
G1 X125.71 Y130.29 E.14073
G1 X125.71 Y125.71 E.14073
G1 X130.29 Y125.71 E.14073
G1 X130.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X128.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.4 I1.217 J0 P1  F42000
; stop printing object, unique label id: 69
M625
; object ids of layer 25 start: 69,141
M624 AwAAAAAAAAA=
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


; object ids of this layer25 end: 69,141
M625
; start printing object, unique label id: 69
M624 AQAAAAAAAAA=
G1 X129.383 Y125.917 F42000
G1 Z5
G1 E.8 F1800
; FEATURE: Top surface
G1 F1480
M204 S2000
G1 X130.083 Y126.617 E.03038
G1 X130.083 Y127.15
G1 X128.85 Y125.917 E.05355
G1 X128.317 Y125.917
G1 X130.083 Y127.683 E.07673
G1 X130.083 Y128.216
G1 X127.784 Y125.917 E.0999
G1 X127.25 Y125.917
G1 X130.083 Y128.75 E.12307
G1 X130.083 Y129.283
G1 X126.717 Y125.917 E.14624
G1 X126.184 Y125.917
G1 X130.083 Y129.816 E.16942
G1 X129.816 Y130.083
G1 X125.917 Y126.184 E.16941
G1 X125.917 Y126.717
G1 X129.283 Y130.083 E.14624
G1 X128.749 Y130.083
G1 X125.917 Y127.251 E.12307
G1 X125.917 Y127.784
G1 X128.216 Y130.083 E.09989
G1 X127.683 Y130.083
G1 X125.917 Y128.317 E.07672
G1 X125.917 Y128.85
G1 X127.15 Y130.083 E.05355
G1 X126.616 Y130.083
G1 X125.917 Y129.384 E.03038
; OBJECT_ID: 141
; WIPE_START
G1 F12000
M204 S6000
G1 X126.616 Y130.083 E-.37565
G1 X127.15 Y130.083 E-.20264
G1 X126.812 Y129.744 E-.18171
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 69
M625
; start printing object, unique label id: 141
M624 AgAAAAAAAAA=
M204 S10000
G1 X124.29 Y130.29 Z5.4 F42000
G1 Z5
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1480
M204 S5000
G1 X119.71 Y130.29 E.14073
G1 X119.71 Y125.71 E.14073
G1 X124.29 Y125.71 E.14073
G1 X124.29 Y130.23 E.13889
; WIPE_START
G1 F12000
M204 S6000
G1 X122.29 Y130.256 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X123.383 Y125.917 Z5.4 F42000
G1 Z5
G1 E.8 F1800
; FEATURE: Top surface
G1 F1480
M204 S2000
G1 X124.083 Y126.617 E.03038
G1 X124.083 Y127.15
G1 X122.85 Y125.917 E.05355
G1 X122.317 Y125.917
G1 X124.083 Y127.683 E.07673
G1 X124.083 Y128.216
G1 X121.784 Y125.917 E.0999
G1 X121.25 Y125.917
G1 X124.083 Y128.75 E.12307
G1 X124.083 Y129.283
G1 X120.717 Y125.917 E.14624
G1 X120.184 Y125.917
G1 X124.083 Y129.816 E.16942
G1 X123.816 Y130.083
G1 X119.917 Y126.184 E.16941
M73 P96 R0
G1 X119.917 Y126.717
G1 X123.283 Y130.083 E.14624
G1 X122.749 Y130.083
G1 X119.917 Y127.251 E.12307
G1 X119.917 Y127.784
G1 X122.216 Y130.083 E.09989
G1 X121.683 Y130.083
G1 X119.917 Y128.317 E.07672
G1 X119.917 Y128.85
G1 X121.15 Y130.083 E.05355
G1 X120.616 Y130.083
G1 X119.917 Y129.384 E.03038
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S6000
G1 X120.616 Y130.083 E-.37565
G1 X121.15 Y130.083 E-.20264
G1 X120.812 Y129.744 E-.18171
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 141
M625
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
G1 Z5.5 F900 ; lower z a little
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

    G1 Z105 F600
    G1 Z103

M400 P100
M17 R ; restore z current

G90
G1 X-48 Y180 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W
;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M400
M18 X Y Z

M73 P100 R0
; EXECUTABLE_BLOCK_END

