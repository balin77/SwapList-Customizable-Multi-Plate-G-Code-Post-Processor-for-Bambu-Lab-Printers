; HEADER_BLOCK_START
; BambuStudio 02.02.01.60
; model printing time: 7m 31s; total estimated time: 14m 52s
; total layer number: 90
; total filament length [mm] : 1016.79
; total filament volume [cm^3] : 2445.68
; total filament weight [g] : 3.20
; filament_density: 1.31,1.31,1.31,1.31,1.22
; filament_diameter: 1.75,1.75,1.75,1.75,1.75
; max_z_height: 18.00
; filament: 1
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0,0
; additional_cooling_fan_speed = 70,70,70,70,70
; apply_scarf_seam_on_circles = 1
; apply_top_surface_compensation = 0
; auxiliary_fan = 1
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 0x0,18x0,18x28,0x28
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
; chamber_temperatures = 0,0,0,0,0
; change_filament_gcode = M620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nG1 X70 F21000\nG1 Y245\nG1 Y265 F3000\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\n{else}\nM620.11 S0\n{endif}\nM400\nG1 X90 F3000\nG1 Y255 F4000\nG1 X100 F5000\nG1 X120 F15000\nG1 X20 Y50 F21000\nG1 Y-3\n{if toolchange_count == 2}\n; get travel path for change filament\nM620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\nM620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\nM620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\n\n{if next_extruder < 255}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\nG92 E0\n{if flush_length_1 > 1}\nM83\n; FLUSH_START\n; always use highest temperature to flush\nM400\n{if filament_type[next_extruder] == "PETG"}\nM109 S260\n{elsif filament_type[next_extruder] == "PVA"}\nM109 S210\n{else}\nM109 S[nozzle_temperature_range_high]\n{endif}\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_4 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n; FLUSH_START\nM400\nM109 S[new_filament_temp]\nG1 E2 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\n; FLUSH_END\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM106 P1 S255\nM400 S3\n\nG1 X70 F5000\nG1 X90 F3000\nG1 Y255 F4000\nG1 X105 F5000\nG1 Y265 F5000\nG1 X70 F10000\nG1 X100 F5000\nG1 X70 F10000\nG1 X100 F5000\n\nG1 X70 F10000\nG1 X80 F15000\nG1 X60\nG1 X80\nG1 X60\nG1 X80 ; shake to put down garbage\nG1 X100 F5000\nG1 X165 F15000; wipe and shake\nG1 Y256 ; move Y to aside, prevent collision\nM400\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200,200,200
; close_fan_the_first_x_layers = 1,1,1,1,1
; complete_print_exhaust_fan_speed = 70,70,70,70,70
; cool_plate_temp = 35,35,35,35,30
; cool_plate_temp_initial_layer = 35,35,35,35,30
; counter_coef_1 = 0,0,0,0,0
; counter_coef_2 = 0.008,0.008,0.008,0.008,0.008
; counter_coef_3 = -0.041,-0.041,-0.041,-0.041,-0.041
; counter_limit_max = 0.033,0.033,0.033,0.033,0.033
; counter_limit_min = -0.035,-0.035,-0.035,-0.035,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 10000
; default_filament_colour = ;;;;
; default_filament_profile = "Bambu PLA Basic @BBL X1C"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL X1C
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50,50,50
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70,70
; elefant_foot_compensation = 0.15
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1,1,1,1,1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0,0,0,0,0
; enable_prime_tower = 0
; enable_support = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 0,0,0,0,30
; eng_plate_temp_initial_layer = 0,0,0,0,30
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 33
; extruder_clearance_height_to_lid = 90
; extruder_clearance_height_to_rod = 34
; extruder_clearance_max_radius = 68
; extruder_colour = #018001
; extruder_offset = 0x2
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard"
; fan_cooling_layer_time = 100,100,100,100,100
; fan_max_speed = 100,100,100,100,100
; fan_min_speed = 100,100,100,100,100
; filament_adaptive_volumetric_speed = 0,0,0,0,0
; filament_adhesiveness_category = 100,100,100,100,600
; filament_change_length = 10,10,10,10,10
; filament_colour = #FCECD6;#FFFFFF;#161616;#BCBCBC;#FFFFFF
; filament_colour_type = 0;0;0;0;0
; filament_cost = 25.4,25.4,25.4,25.4,41.99
; filament_density = 1.31,1.31,1.31,1.31,1.22
; filament_diameter = 1.75,1.75,1.75,1.75,1.75
; filament_end_gcode = "; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n"
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.98,0.98,0.98,0.98,1
; filament_flush_temp = 0,0,0,0,0
; filament_flush_volumetric_speed = 0,0,0,0,0
; filament_ids = GFL01;GFL01;GFL01;GFL01;GFU00
; filament_is_support = 0,0,0,0,0
; filament_map = 1,1,1,1,1
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 22,22,22,22,12
; filament_minimal_purge_on_wipe_tower = 15,15,15,15,15
; filament_multi_colour = #FCECD6;#FFFFFF;#161616;#BCBCBC;#FFFFFF
; filament_notes = 
; filament_pre_cooling_temperature = 0,0,0,0,0
; filament_prime_volume = 45,45,45,45,45
; filament_printable = 3,3,3,3,3
; filament_ramming_travel_time = 0,0,0,0,0
; filament_ramming_volumetric_speed = -1,-1,-1,-1,-1
; filament_retraction_length = nil,nil,nil,nil,0.8
; filament_scarf_gap = 15%,15%,15%,15%,0%
; filament_scarf_height = 10%,10%,10%,10%,10%
; filament_scarf_length = 10,10,10,10,10
; filament_scarf_seam_type = none,none,none,none,none
; filament_self_index = 1,2,3,4,5
; filament_settings_id = "PolyTerra PLA @BBL X1C";"PolyTerra PLA @BBL X1C";"PolyTerra PLA @BBL X1C";"PolyTerra PLA @BBL X1C";"Bambu TPU 95A HF @BBL X1C"
; filament_shrink = 100%,100%,100%,100%,100%
; filament_soluble = 0,0,0,0,0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >35)||(bed_temperature_initial_layer[current_extruder] >35)}M106 P3 S255\n{elsif(bed_temperature[current_extruder] >30)||(bed_temperature_initial_layer[current_extruder] >30)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_type = PLA;PLA;PLA;PLA;TPU
; filament_velocity_adaptation_factor = 1,1,1,1,1
; filament_vendor = Polymaker;Polymaker;Polymaker;Polymaker;"Bambu Lab"
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,211,197,167,211,167,0,180,167,167,624,632,0,521,632,306,326,167,0,326,167,167,180,167,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0,0,0,0,0
; hole_coef_2 = -0.008,-0.008,-0.008,-0.008,-0.008
; hole_coef_3 = 0.23415,0.23415,0.23415,0.23415,0.23415
; hole_limit_max = 0.22,0.22,0.22,0.22,0.22
; hole_limit_min = 0.088,0.088,0.088,0.088,0.088
; host_type = octoprint
; hot_plate_temp = 55,55,55,55,35
; hot_plate_temp_initial_layer = 55,55,55,55,35
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 10,10,10,10,86.3
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
; long_retractions_when_ec = 0,0,0,0,0
; machine_end_gcode = ;===== date: 20240528 =====================\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X65 Y245 F12000 ; move to safe pos\nG1 Y265 F3000\n\nG1 X65 Y245 F12000\nG1 Y265 F3000\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\nG1 X100 F12000 ; wipe\n; pull back filament to AMS\nM620 S255\nG1 X20 Y50 F12000\nG1 Y-3\nT255\nG1 X65 F12000\nG1 Y265\nG1 X100 F12000 ; wipe\nM621 S255\nM104 S0 ; turn off hotend\n\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S3 ;wait for last picture to be taken\nM623; end of "timelapse_record_flag"\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 250}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z250 F600\n    G1 Z248\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N100\nM1006 A49 B20 L100 C44 D20 M100 E41 F20 N100\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N100\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n\nM17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM960 S5 P0 ; turn off logo lamp\n
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,200
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: X1 ====================\n;===== date: 20240919 ==================\n;===== start printer sound ================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A46 B10 L100 C43 D10 M70 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A43 B10 L100 C0 D10 M60 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A41 B10 L100 C0 D10 M100 E41 F10 N100\nM1006 A44 B10 L100 C0 D10 M100 E44 F10 N100\nM1006 A49 B10 L100 C0 D10 M100 E49 F10 N100\nM1006 A0 B10 L100 C0 D10 M100 E0 F10 N100\nM1006 A48 B10 L100 C44 D10 M60 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A44 B10 L100 C0 D10 M90 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A46 B10 L100 C43 D10 M60 E39 F10 N100\nM1006 W\n;===== turn on the HB fan =================\nM104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle\n;===== reset machine status =================\nM290 X40 Y40 Z2.6666666\nG91\nM17 Z0.4 ; lower the z-motor current\nG380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed\nG380 S2 Z-25 F300 ;\nG1 Z5 F300;\nG90\nM17 X1.2 Y1.2 Z0.75 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 5\nM221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\nG29.1 Z{+0.0} ; clear z-trim value first\nM204 S10000 ; init ACC set to 10m/s^2\n\n;===== heatbed preheat ====================\nM1002 gcode_claim_action : 2\nM140 S[bed_temperature_initial_layer_single] ;set bed temp\nM190 S[bed_temperature_initial_layer_single] ;wait for bed temp\n\n{if scan_first_layer}\n;=========register first layer scan=====\nM977 S1 P60\n{endif}\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]=="PLA"}\n    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n;===== prepare print temperature and material ==========\nM104 S[nozzle_temperature_initial_layer] ;set extruder temp\nG91\nG0 Z10 F1200\nG90\nG28 X\nM975 S1 ; turn on\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nM620 M\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M109 S[nozzle_temperature_initial_layer]\n    G1 X120 F12000\n\n    G1 X20 Y50 F12000\n    G1 Y-3\n    T[initial_no_support_extruder]\n    G1 X54 F12000\n    G1 Y265\n    M400\nM621 S[initial_no_support_extruder]A\nM620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}\n\nM412 S1 ; ===turn on filament runout detection===\n\nM109 S250 ;set nozzle to common flush temp\nM106 P1 S0\nG92 E0\nG1 E50 F200\nM400\nM104 S[nozzle_temperature_initial_layer]\nG92 E0\nG1 E50 F200\nM400\nM106 P1 S255\nG92 E0\nG1 E5 F300\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20} ; drop nozzle temp, make filament shink a bit\nG92 E0\nG1 E-0.5 F300\n\nG1 X70 F9000\nG1 X76 F15000\nG1 X65 F15000\nG1 X76 F15000\nG1 X65 F15000; shake to put down garbage\nG1 X80 F6000\nG1 X95 F15000\nG1 X80 F15000\nG1 X165 F15000; wipe and shake\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\nM975 S1\nM106 S255\nG1 X65 Y230 F18000\nG1 Y264 F6000\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}\nG1 X100 F18000 ; first wipe mouth\n\nG0 X135 Y253 F20000  ; move to exposed steel surface edge\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nG0 Z5 F20000\n\nG1 X60 Y265\nG92 E0\nG1 E-0.5 F300 ; retrack more\nG1 X100 F5000; second wipe mouth\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X90 F5000\nG0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle\nM104 S140 ; set temp down to heatbed acceptable\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM221 S; push soft endstop status\nM221 Z0 ;turn off Z axis endstop\nG0 Z0.5 F20000\nG0 X125 Y259.5 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 X128\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\n\nM109 S140 ; wait nozzle temp down to heatbed acceptable\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\n\nM221 R; pop softend status\nG1 Z10 F1200\nM400\nG1 Z10\nG1 F30000\nG1 X128 Y128\nG29.2 S1 ; turn on ABL\n;G28 ; home again after hard wipe mouth\nM106 S0 ; turn off fan , too noisy\n;===== wipe nozzle end ================================\n\n;===== check scanner clarity ===========================\nG1 X128 Y128 F24000\nG28 Z P0\nM972 S5 P0\nG1 X230 Y15 F24000\n;===== check scanner clarity end =======================\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\nM622 J1\n\n    M1002 gcode_claim_action : 1\n    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\n\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n;===== home after wipe mouth end =======================\n\nM975 S1 ; turn on vibration supression\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]=="PLA"}\n    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; set extrude temp earlier, to reduce wait time\n\n;===== mech mode fast check============================\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q1 A7 B30 C80  H15 K0\nM974 Q1 S2 P0\n\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q0 A7 B30 C90 Q0 H15 K0\nM974 Q0 S2 P0\n\nM975 S1\nG1 F30000\nG1 X230 Y15\nG28 X ; re-home XY\n;===== mech mode fast check============================\n\n{if scan_first_layer}\n;start heatbed  scan====================================\nM976 S2 P1\nG90\nG1 X128 Y128 F20000\nM976 S3 P2  ;register void printing detection\n{endif}\n\n;===== nozzle load line ===============================\nM975 S1\nG90\nM83\nT1000\nG1 X18.0 Y1.0 Z0.8 F18000;Move to start position\nM109 S{nozzle_temperature[initial_no_support_extruder]}\nG1 Z0.2\nG0 E2 F300\nG0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nG0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\nG0 X239.5\nG0 E0.2\nG0 Y1.5 E0.700\nG0 X231 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.04} ; for Textured PEI Plate\n{endif}\n\n;===== draw extrinsic para cali paint =================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M1002 gcode_claim_action : 8\n\n    T1000\n\n    G0 F1200.0 X231 Y15   Z0.2 E0.741\n    G0 F1200.0 X226 Y15   Z0.2 E0.275\n    G0 F1200.0 X226 Y8    Z0.2 E0.384\n    G0 F1200.0 X216 Y8    Z0.2 E0.549\n    G0 F1200.0 X216 Y1.5  Z0.2 E0.357\n\n    G0 X48.0 E12.0 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X48.0 Y14 E0.92 F1200.0\n    G0 X35.0 Y6.0 E1.03 F1200.0\n\n    ;=========== extruder cali extrusion ==================\n    T1000\n    M83\n    {if default_acceleration > 0}\n        {if outer_wall_acceleration > 0}\n            M204 S[outer_wall_acceleration]\n        {else}\n            M204 S[default_acceleration]\n        {endif}\n    {endif}\n    G0 X35.000 Y6.000 Z0.300 F30000 E0\n    G1 F1500.000 E0.800\n    M106 S0 ; turn off fan\n    G0 X185.000 E9.35441 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G0 X187 Z0\n    G1 F1500.000 E-0.800\n    G0 Z1\n    G0 X180 Z0.3 F18000\n\n    M900 L1000.0 M1.0\n    M900 K0.040\n    G0 X45.000 F30000\n    G0 Y8.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.020\n    G0 X45.000 F30000\n    G0 Y10.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.000\n    G0 X45.000 F30000\n    G0 Y12.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n\n    G0 X45.000 F30000 ; move to start point\n\nM623 ; end of "draw extrinsic para cali paint"\n\n\nM1002 judge_flag extrude_cali_flag\nM622 J0\n    G0 X231 Y1.5 F30000\n    G0 X18 E14.3 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM623\n\nM104 S140\n\n\n;=========== laser and rgb calibration ===========\nM400\nM18 E\nM500 R\n\nM973 S3 P14\n\nG1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nT1100\nG1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nM400 P100\nM960 S1 P1\nM400 P100\nM973 S6 P0; use auto exposure for horizontal laser by xcam\nM960 S0 P0\n\nG1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos\nM960 S2 P1\nM400 P100\nM973 S6 P1; use auto exposure for vertical laser by xcam\nM960 S0 P0\n\n;=========== handeye calibration ======================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M973 S3 P1 ; camera start stream\n    M400 P500\n    M973 S1\n    G0 F6000 X228.500 Y4.500 Z0.000\n    M960 S0 P1\n    M973 S1\n    M400 P800\n    M971 S6 P0\n    M973 S2 P0\n    M400 P500\n    G0 Z0.000 F12000\n    M960 S0 P0\n    M960 S1 P1\n    G0 X221.00 Y4.50\n    M400 P200\n    M971 S5 P1\n    M973 S2 P1\n    M400 P500\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y11.0\n    M400 P200\n    M971 S5 P3\n    G0 Z0.500 F12000\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y11.0\n    M400 P200\n    M971 S5 P4\n    M973 S2 P0\n    M400 P500\n    M960 S0 P0\n    M960 S1 P1\n    G0 X221.00 Y4.50\n    M400 P500\n    M971 S5 P2\n    M963 S1\n    M400 P1500\n    M964\n    T1100\n    G0 F6000 X228.500 Y4.500 Z0.000\n    M960 S0 P1\n    M973 S1\n    M400 P800\n    M971 S6 P0\n    M973 S2 P0\n    M400 P500\n    G0 Z0.000 F12000\n    M960 S0 P0\n    M960 S1 P1\n    G0 X221.00 Y4.50\n    M400 P200\n    M971 S5 P1\n    M973 S2 P1\n    M400 P500\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y11.0\n    M400 P200\n    M971 S5 P3\n    G0 Z0.500 F12000\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y11.0\n    M400 P200\n    M971 S5 P4\n    M973 S2 P0\n    M400 P500\n    M960 S0 P0\n    M960 S1 P1\n    G0 X221.00 Y4.50\n    M400 P500\n    M971 S5 P2\n    M963 S1\n    M400 P1500\n    M964\n    T1100\n    G1 Z3 F3000\n\n    M400\n    M500 ; save cali data\n\n    M104 S{nozzle_temperature[initial_no_support_extruder]} ; rise nozzle temp now ,to reduce temp waiting time.\n\n    T1100\n    M400 P400\n    M960 S0 P0\n    G0 F30000.000 Y10.000 X65.000 Z0.000\n    M400 P400\n    M960 S1 P1\n    M400 P50\n\n    M969 S1 N3 A2000\n    G0 F360.000 X181.000 Z0.000\n    M980.3 A70.000 B{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60/4} C5.000 D{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60} E5.000 F175.000 H1.000 I0.000 J0.020 K0.040\n    M400 P100\n    G0 F20000\n    G0 Z1 ; rise nozzle up\n    T1000 ; change to nozzle space\n    G0 X45.000 Y4.000 F30000 ; move to test line pos\n    M969 S0 ; turn off scanning\n    M960 S0 P0\n\n\n    G1 Z2 F20000\n    T1000\n    G0 X45.000 Y4.000 F30000 E0\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n    G0 Z0.3\n    G1 F1500.000 E3.600\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n\n    ; see if extrude cali success, if not ,use default value\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M400\n        M900 K0.02 M{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*0.02}\n    M623\n\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X185.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X190.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X195.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X200.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X205.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X210.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X215.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X220.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X225.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    M973 S4\n\nM623\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM973 S4 ; turn off scanner\nM400 ; wait all motion done before implement the emprical L parameters\n;M900 L500.0 ; Empirical parameters\nM109 S[nozzle_temperature_initial_layer]\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n;===== purge line to wipe the nozzle ============================\nG1 E{-retraction_length[initial_no_support_extruder]} F1800\nG1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position\nG1 E{retraction_length[initial_no_support_extruder]} F1800\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG1 Z0.2\nG0 X239 E15 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\nG0 Y12 E0.7 F{outer_wall_volumetric_speed/(0.3*0.5)/4* 60}\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 28
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
; nozzle_height = 4.2
; nozzle_temperature = 220,220,220,220,230
; nozzle_temperature_initial_layer = 220,220,220,220,230
; nozzle_temperature_range_high = 240,240,240,240,250
; nozzle_temperature_range_low = 190,190,190,190,200
; nozzle_type = hardened_steel
; nozzle_volume = 107
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
; overhang_fan_speed = 100,100,100,100,100
; overhang_fan_threshold = 50%,50%,50%,50%,95%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%,95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0,0,0,0,0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02,0.02
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
; print_compatible_printers = "Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab P1S 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL X1C
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 250
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab X1 Carbon
; printer_notes = 
; printer_settings_id = Bambu Lab X1 Carbon 0.4 nozzle
; printer_structure = corexy
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
; reduce_fan_stop_start_freq = 1,1,1,1,1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3,3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 249
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0,0,0,0,0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 1
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
; slow_down_for_layer_cooling = 1,1,1,1,1
; slow_down_layer_time = 4,4,4,4,8
; slow_down_min_speed = 20,20,20,20,10
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 150
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
; supertack_plate_temp = 45,45,45,45,0
; supertack_plate_temp_initial_layer = 45,45,45,45,0
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
; temperature_vitrification = 45,45,45,45,30
; template_custom_gcode = 
; textured_plate_temp = 55,55,55,55,35
; textured_plate_temp_initial_layer = 55,55,55,55,35
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;========Date 20250206========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\nM971 S11 C10 O0\nM1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\nG92 E0\nG1 X65 Y245 F20000 ; move to safe pos\nG17\nG2 Z{layer_z} I0.86 J0.86 P1 F20000\nG1 Y265 F3000\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C10 O0\nG92 E0\nG1 X100 F5000\nG1 Y255 F20000\n{endif}\nM623\n; SKIPPABLE_END\n
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
; travel_speed = 500
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab P1S 0.4 nozzle";"Bambu Lab P1P 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle";"Bambu Lab A1 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
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
; wipe_tower_x = 165
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
; start printing plate 1
M73 P0 R14
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: X1 ====================
;===== date: 20240919 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S55 ;set bed temp
M190 S55 ;wait for bed temp


;=========register first layer scan=====

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S220 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S0A   ; switch material if AMS exist
    M109 S220
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T0
    G1 X54 F12000
    G1 Y265
    M400
M621 S0A
M620.1 E F548.788 T240

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P3 R14
G1 E50 F200
M400
M104 S220
G92 E0
M73 P33 R9
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P34 R9
G1 E-0.5 F300

M73 P36 R9
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S200
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
M73 P37 R9
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================

;===== check scanner clarity end =======================

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X119 Y119 I18 J18
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

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S220 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
M73 P38 R9
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== mech mode fast check============================


;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000

M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate


;===== draw extrinsic para cali paint =================

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S220
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================

; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S150


;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/90
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.143 Y134.143
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X119.857 Y134.143 E3
G1 X119.857 Y117.857 E.60659
G1 X136.143 Y117.857 E.60659
G1 X136.143 Y134.083 E.60435
M204 S6000
G1 X136.6 Y134.6 F30000
; FEATURE: Outer wall
G1 F3000
M204 S500
M73 P44 R8
G1 X119.4 Y134.6 E.64064
G1 X119.4 Y117.4 E.64064
G1 X136.6 Y117.4 E.64064
G1 X136.6 Y134.54 E.6384
; WIPE_START
G1 X134.6 Y134.547 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X134.798 Y126.917 Z.6 F30000
G1 X135.028 Y118.04 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50372
G1 F6300
M204 S500
G1 X135.754 Y118.766 E.03856
G1 X135.754 Y119.418 E.02447
G1 X134.582 Y118.246 E.06225
G1 X133.931 Y118.246 E.02447
G1 X135.754 Y120.069 E.09685
G1 X135.754 Y120.721 E.02447
G1 X133.279 Y118.246 E.13146
G1 X132.627 Y118.246 E.02447
G1 X135.754 Y121.373 E.16606
G1 X135.754 Y122.024 E.02447
G1 X131.976 Y118.246 E.20067
G1 X131.324 Y118.246 E.02447
G1 X135.754 Y122.676 E.23527
G1 X135.754 Y123.328 E.02447
G1 X130.672 Y118.246 E.26988
G1 X130.021 Y118.246 E.02447
G1 X135.754 Y123.979 E.30448
G1 X135.754 Y124.631 E.02447
M73 P45 R8
G1 X129.369 Y118.246 E.33909
G1 X128.717 Y118.246 E.02447
G1 X135.754 Y125.283 E.37369
G1 X135.754 Y125.934 E.02447
G1 X128.066 Y118.246 E.4083
G1 X127.414 Y118.246 E.02447
G1 X135.754 Y126.586 E.44291
G1 X135.754 Y127.238 E.02447
G1 X126.762 Y118.246 E.47751
G1 X126.111 Y118.246 E.02447
G1 X135.754 Y127.889 E.51212
G1 X135.754 Y128.541 E.02447
G1 X125.459 Y118.246 E.54672
M73 P46 R8
G1 X124.807 Y118.246 E.02447
M73 P48 R7
G1 X135.754 Y129.193 E.58133
G1 X135.754 Y129.844 E.02447
G1 X124.156 Y118.246 E.61593
G1 X123.504 Y118.246 E.02447
G1 X135.754 Y130.496 E.65054
G1 X135.754 Y131.148 E.02447
G1 X122.852 Y118.246 E.68514
G1 X122.201 Y118.246 E.02447
G1 X135.754 Y131.799 E.71975
G1 X135.754 Y132.451 E.02447
G1 X121.549 Y118.246 E.75436
G1 X120.897 Y118.246 E.02447
G1 X135.754 Y133.103 E.78896
G1 X135.754 Y133.754 E.02447
G1 X120.246 Y118.246 E.82356
G1 X120.246 Y118.897 E.02447
G1 X135.103 Y133.754 E.78895
G1 X134.451 Y133.754 E.02447
G1 X120.246 Y119.549 E.75435
G1 X120.246 Y120.201 E.02447
G1 X133.799 Y133.754 E.71974
G1 X133.148 Y133.754 E.02447
G1 X120.246 Y120.852 E.68514
G1 X120.246 Y121.504 E.02447
G1 X132.496 Y133.754 E.65053
G1 X131.844 Y133.754 E.02447
G1 X120.246 Y122.156 E.61593
G1 X120.246 Y122.807 E.02447
G1 X131.193 Y133.754 E.58132
G1 X130.541 Y133.754 E.02447
G1 X120.246 Y123.459 E.54672
G1 X120.246 Y124.111 E.02447
G1 X129.889 Y133.754 E.51211
G1 X129.238 Y133.754 E.02447
G1 X120.246 Y124.762 E.47751
G1 X120.246 Y125.414 E.02447
G1 X128.586 Y133.754 E.4429
G1 X127.934 Y133.754 E.02447
G1 X120.246 Y126.066 E.40829
G1 X120.246 Y126.717 E.02447
G1 X127.283 Y133.754 E.37369
G1 X126.631 Y133.754 E.02447
M73 P49 R7
G1 X120.246 Y127.369 E.33908
G1 X120.246 Y128.021 E.02447
G1 X125.979 Y133.754 E.30448
G1 X125.328 Y133.754 E.02447
G1 X120.246 Y128.672 E.26987
G1 X120.246 Y129.324 E.02447
G1 X124.676 Y133.754 E.23527
G1 X124.024 Y133.754 E.02447
G1 X120.246 Y129.976 E.20066
G1 X120.246 Y130.627 E.02447
G1 X123.373 Y133.754 E.16606
G1 X122.721 Y133.754 E.02447
G1 X120.246 Y131.279 E.13145
G1 X120.246 Y131.931 E.02447
G1 X122.069 Y133.754 E.09684
G1 X121.418 Y133.754 E.02447
G1 X120.246 Y132.582 E.06224
G1 X120.246 Y133.234 E.02447
G1 X120.972 Y133.96 E.03856
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X120.246 Y133.234 E-.39019
G1 X120.246 Y132.582 E-.24763
G1 X120.473 Y132.81 E-.12218
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/90
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
M976 S1 P1 ; scan model before printing 2nd layer
M400 P100
G1 E.8
G1 E-.8
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13548
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13548
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
M73 P50 R7
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
M73 P51 R7
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/90
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z1 F30000
G1 X136.234 Y118.54 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
M73 P52 R7
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/90
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z1 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4019
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4019
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4019
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/90
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.4 F30000
G1 X136.05 Y120.326 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/90
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
M73 P53 R6
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/90
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.8 F30000
G1 X136.05 Y120.326 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/90
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P54 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/90
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.2 F30000
G1 X136.05 Y120.326 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/90
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P55 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/90
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.6 F30000
G1 X136.05 Y120.326 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/90
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
M73 P56 R6
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/90
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3 F30000
G1 X136.05 Y120.326 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/90
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.2 F30000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P57 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/90
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.4 F30000
G1 X136.05 Y120.326 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/90
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.6 F30000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P58 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/90
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.8 F30000
G1 X136.05 Y120.326 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/90
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4 F30000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
M73 P59 R6
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/90
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.2 F30000
G1 X136.05 Y120.326 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/90
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P59 R5
G1 X136.05 Y131.674 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P60 R5
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/90
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.6 F30000
G1 X136.05 Y120.326 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/90
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4.8 F30000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P61 R5
G1 E-.04 F1800
; layer num/total_layer_count: 23/90
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5 F30000
G1 X136.05 Y120.326 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/90
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.2 F30000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P62 R5
G1 E-.04 F1800
; layer num/total_layer_count: 25/90
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.4 F30000
G1 X136.05 Y120.326 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/90
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.6 F30000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P63 R5
G1 E-.04 F1800
; layer num/total_layer_count: 27/90
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.8 F30000
G1 X136.05 Y120.326 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/90
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6 F30000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/90
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
M73 P64 R5
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.2 F30000
G1 X136.05 Y120.326 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/90
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/90
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z6.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
M73 P65 R5
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.6 F30000
G1 X136.05 Y120.326 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/90
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z6.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.8 F30000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/90
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z6.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P66 R5
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7 F30000
G1 X136.05 Y120.326 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
M73 P66 R4
G1 E-.04 F1800
; layer num/total_layer_count: 34/90
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z7 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.2 F30000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/90
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z7.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P67 R4
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.4 F30000
G1 X136.05 Y120.326 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/90
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z7.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/90
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P68 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.8 F30000
G1 X136.05 Y120.326 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/90
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z7.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/90
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P69 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.2 F30000
G1 X136.05 Y120.326 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/90
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z8.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.4 F30000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/90
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z8.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P70 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.6 F30000
G1 X136.05 Y120.326 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/90
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z8.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/90
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z8.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P71 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9 F30000
G1 X136.05 Y120.326 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/90
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/90
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z9.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P72 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.4 F30000
G1 X136.05 Y120.326 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/90
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z9.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.6 F30000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/90
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z9.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P73 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.8 F30000
G1 X136.05 Y120.326 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P73 R3
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/90
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z9.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10 F30000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/90
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z10 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P74 R3
G1 X135.455 Y127.133 Z10.2 F30000
G1 X136.05 Y120.326 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/90
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z10.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.4 F30000
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/90
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P75 R3
G1 X135.455 Y127.133 Z10.6 F30000
G1 X136.05 Y120.326 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/90
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z10.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.8 F30000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/90
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
G17
G3 Z10.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11 F30000
M73 P76 R3
G1 X136.05 Y120.326 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/90
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
G17
G3 Z11 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.2 F30000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/90
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z11.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.4 F30000
M73 P77 R3
G1 X136.05 Y120.326 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/90
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z11.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.6 F30000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/90
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z11.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.8 F30000
M73 P78 R3
G1 X136.05 Y120.326 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/90
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/90
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.2 F30000
G1 X136.05 Y120.326 Z12.2
M73 P79 R3
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/90
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
G17
G3 Z12.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/90
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
G17
G3 Z12.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P79 R2
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.6 F30000
G1 X136.05 Y120.326 Z12.6
M73 P80 R2
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/90
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z12.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.8 F30000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/90
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z12.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13 F30000
G1 X136.05 Y120.326 Z13
G1 Z12.6
M73 P81 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/90
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z13 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.2 F30000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/90
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.4 F30000
G1 X136.05 Y120.326 Z13.4
G1 Z13
M73 P82 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/90
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z13.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.6 F30000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/90
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
G17
G3 Z13.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.8 F30000
G1 X136.05 Y120.326 Z13.8
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
M73 P83 R2
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/90
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z13.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14 F30000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/90
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z14 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.2 F30000
G1 X136.05 Y120.326 Z14.2
G1 Z13.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
M73 P84 R2
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/90
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z14.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.4 F30000
G1 Z14
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/90
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z14.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.6 F30000
G1 X136.05 Y120.326 Z14.6
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P85 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/90
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.8 F30000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/90
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
G17
G3 Z14.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15 F30000
G1 X136.05 Y120.326 Z15
G1 Z14.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P86 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/90
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
G17
G3 Z15 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.2 F30000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P86 R1
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/90
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
G17
G3 Z15.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.4 F30000
G1 X136.05 Y120.326 Z15.4
G1 Z15
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
M73 P87 R1
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/90
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
G17
G3 Z15.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.6 F30000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/90
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
G17
G3 Z15.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.8 F30000
G1 X136.05 Y120.326 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P88 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/90
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
G17
G3 Z15.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16 F30000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/90
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.2 F30000
G1 X136.05 Y120.326 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P89 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/90
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
G17
G3 Z16.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.4 F30000
G1 Z16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/90
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
G17
G3 Z16.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.6 F30000
G1 X136.05 Y120.326 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
M73 P90 R1
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/90
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
G17
G3 Z16.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/90
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
G17
G3 Z16.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z17 F30000
G1 X136.05 Y120.326 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
M73 P91 R1
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/90
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
G17
G3 Z17 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/90
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
G17
G3 Z17.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5760
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5760
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.044 Y133.673 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5760
G1 X135.673 Y133.673 E.05401
G1 X120.327 Y118.327 E.71987
G1 X127.997 Y118.327 E.2544
G1 X120.327 Y125.997 E.35977
G1 X127.997 Y133.673 E.35993
G1 X135.673 Y126.003 E.35993
G1 X128.003 Y118.327 E.35993
G1 X135.673 Y118.327 E.2544
G1 X120.327 Y133.673 E.71987
G1 X120.327 Y132.044 E.05401
G1 X136.008 Y117.992 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.399311
G1 F3000;_EXTRUDE_SET_SPEED
G1 X136.035 Y118.124 E.00391
G1 X136.035 Y133.876 E.45746
G1 X136.008 Y134.008 E.00391
G1 X135.876 Y134.035 E.00391
G1 X120.124 Y134.035 E.45746
G1 X119.992 Y134.008 E.00391
G1 X119.965 Y133.876 E.00391
M73 P92 R1
G1 X119.965 Y118.124 E.45746
G1 X119.992 Y117.992 E.00391
G1 X120.124 Y117.965 E.00391
G1 X135.876 Y117.965 E.45746
G1 X135.949 Y117.98 E.00217
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F3000
G1 X135.876 Y117.965 E-.02837
G1 X133.951 Y117.965 E-.73163
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/90
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.305 Y134.231 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40771
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X136.028 Y133.507 E.05443
G1 X136.028 Y132.86 E.03443
G1 X134.86 Y134.028 E.08789
G1 X134.213 Y134.028 E.03443
G1 X136.028 Y132.213 E.13658
G1 X136.028 Y131.565 E.03443
G1 X133.565 Y134.028 E.18527
G1 X132.918 Y134.028 E.03443
G1 X136.028 Y130.918 E.23397
G1 X136.028 Y130.271 E.03443
G1 X132.271 Y134.028 E.28266
G1 X131.623 Y134.028 E.03443
G1 X136.028 Y129.623 E.33136
G1 X136.028 Y128.976 E.03443
G1 X130.976 Y134.028 E.38005
G1 X130.329 Y134.028 E.03443
G1 X136.028 Y128.329 E.42874
G1 X136.028 Y127.681 E.03443
G1 X129.681 Y134.028 E.47744
G1 X129.034 Y134.028 E.03443
G1 X136.028 Y127.034 E.52613
G1 X136.028 Y126.387 E.03443
G1 X128.387 Y134.028 E.57482
G1 X127.74 Y134.028 E.03443
G1 X136.028 Y125.74 E.62352
G1 X136.028 Y125.092 E.03443
G1 X127.092 Y134.028 E.67221
G1 X126.445 Y134.028 E.03443
G1 X136.028 Y124.445 E.72091
G1 X136.028 Y123.798 E.03443
G1 X125.798 Y134.028 E.7696
G1 X125.15 Y134.028 E.03443
G1 X136.028 Y123.15 E.81829
G1 X136.028 Y122.503 E.03443
G1 X124.503 Y134.028 E.86699
G1 X123.856 Y134.028 E.03443
G1 X136.028 Y121.856 E.91568
G1 X136.028 Y121.208 E.03443
G1 X123.208 Y134.028 E.96437
G1 X122.561 Y134.028 E.03443
G1 X136.028 Y120.561 E1.01307
G1 X136.028 Y119.914 E.03443
G1 X121.914 Y134.028 E1.06176
G1 X121.267 Y134.028 E.03443
G1 X136.028 Y119.267 E1.11046
G1 X136.028 Y118.619 E.03443
G1 X120.619 Y134.028 E1.15915
G1 X119.972 Y134.028 E.03443
G1 X136.028 Y117.972 E1.20784
G1 X135.381 Y117.972 E.03442
G1 X119.972 Y133.381 E1.15918
G1 X119.972 Y132.734 E.03443
G1 X134.734 Y117.972 E1.11049
G1 X134.087 Y117.972 E.03443
G1 X119.972 Y132.087 E1.06179
G1 X119.972 Y131.439 E.03443
G1 X133.439 Y117.972 E1.0131
G1 X132.792 Y117.972 E.03443
G1 X119.972 Y130.792 E.96441
G1 X119.972 Y130.145 E.03443
G1 X132.145 Y117.972 E.91571
G1 X131.497 Y117.972 E.03443
G1 X119.972 Y129.497 E.86702
G1 X119.972 Y128.85 E.03443
G1 X130.85 Y117.972 E.81833
G1 X130.203 Y117.972 E.03443
G1 X119.972 Y128.203 E.76963
G1 X119.972 Y127.555 E.03443
G1 X129.555 Y117.972 E.72094
M73 P93 R1
G1 X128.908 Y117.972 E.03443
G1 X119.972 Y126.908 E.67224
G1 X119.972 Y126.261 E.03443
G1 X128.261 Y117.972 E.62355
G1 X127.614 Y117.972 E.03443
G1 X119.972 Y125.614 E.57486
G1 X119.972 Y124.966 E.03443
G1 X126.966 Y117.972 E.52616
G1 X126.319 Y117.972 E.03443
G1 X119.972 Y124.319 E.47747
G1 X119.972 Y123.672 E.03443
G1 X125.672 Y117.972 E.42878
G1 X125.024 Y117.972 E.03443
G1 X119.972 Y123.024 E.38008
G1 X119.972 Y122.377 E.03443
G1 X124.377 Y117.972 E.33139
G1 X123.73 Y117.972 E.03443
G1 X119.972 Y121.73 E.28269
G1 X119.972 Y121.082 E.03443
G1 X123.082 Y117.972 E.234
G1 X122.435 Y117.972 E.03443
G1 X119.972 Y120.435 E.18531
G1 X119.972 Y119.788 E.03443
G1 X121.788 Y117.972 E.13661
G1 X121.141 Y117.972 E.03443
G1 X119.972 Y119.141 E.08792
G1 X119.972 Y118.493 E.03443
G1 X120.696 Y117.769 E.05446
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3000
G1 X119.972 Y118.493 E-.38905
G1 X119.972 Y119.141 E-.24597
G1 X120.204 Y118.908 E-.12498
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/90
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
G17
G3 Z17.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13595
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z17.8 F30000
M73 P93 R0
G1 X136.234 Y118.54 Z17.8
G1 Z17.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13595
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
M73 P94 R0
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/90
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
G17
G3 Z17.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13299
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13299
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
M73 P95 R0
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/90
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
G17
G3 Z18 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z18.2 F30000
G1 X136.234 Y118.54 Z18.2
G1 Z17.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
M73 P96 R0
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/90
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
G17
G3 Z18.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.79 Y134.79
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
M204 S10000
G1 X136.583 Y134.215 F30000
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X136.215 Y134.583 E.01598
G1 X135.682 Y134.583
G1 X136.583 Y133.682 E.03915
G1 X136.583 Y133.148
G1 X135.148 Y134.583 E.06232
G1 X134.615 Y134.583
G1 X136.583 Y132.615 E.0855
G1 X136.583 Y132.082
G1 X134.082 Y134.583 E.10867
G1 X133.549 Y134.583
G1 X136.583 Y131.549 E.13184
G1 X136.583 Y131.015
G1 X133.015 Y134.583 E.15501
G1 X132.482 Y134.583
G1 X136.583 Y130.482 E.17819
G1 X136.583 Y129.949
G1 X131.949 Y134.583 E.20136
G1 X131.416 Y134.583
G1 X136.583 Y129.416 E.22453
G1 X136.583 Y128.882
G1 X130.882 Y134.583 E.2477
G1 X130.349 Y134.583
G1 X136.583 Y128.349 E.27088
G1 X136.583 Y127.816
G1 X129.816 Y134.583 E.29405
G1 X129.283 Y134.583
G1 X136.583 Y127.283 E.31722
G1 X136.583 Y126.749
G1 X128.749 Y134.583 E.3404
G1 X128.216 Y134.583
G1 X136.583 Y126.216 E.36357
G1 X136.583 Y125.683
G1 X127.683 Y134.583 E.38674
G1 X127.15 Y134.583
G1 X136.583 Y125.15 E.40991
G1 X136.583 Y124.616
G1 X126.616 Y134.583 E.43309
G1 X126.083 Y134.583
G1 X136.583 Y124.083 E.45626
G1 X136.583 Y123.55
G1 X125.55 Y134.583 E.47943
G1 X125.017 Y134.583
G1 X136.583 Y123.017 E.5026
G1 X136.583 Y122.483
G1 X124.483 Y134.583 E.52578
G1 X123.95 Y134.583
G1 X136.583 Y121.95 E.54895
G1 X136.583 Y121.417
G1 X123.417 Y134.583 E.57212
G1 X122.883 Y134.583
G1 X136.583 Y120.883 E.59529
G1 X136.583 Y120.35
G1 X122.35 Y134.583 E.61847
G1 X121.817 Y134.583
G1 X136.583 Y119.817 E.64164
G1 X136.583 Y119.284
G1 X121.284 Y134.583 E.66481
G1 X120.75 Y134.583
G1 X136.583 Y118.75 E.68798
G1 X136.583 Y118.217
G1 X120.217 Y134.583 E.71116
G1 X119.684 Y134.583
G1 X136.583 Y117.684 E.73433
G1 X136.316 Y117.417
G1 X119.417 Y134.316 E.73432
G1 X119.417 Y133.783
G1 X135.783 Y117.417 E.71115
G1 X135.249 Y117.417
G1 X119.417 Y133.249 E.68798
G1 X119.417 Y132.716
G1 X134.716 Y117.417 E.66481
G1 X134.183 Y117.417
G1 X119.417 Y132.183 E.64163
M73 P97 R0
G1 X119.417 Y131.65
G1 X133.65 Y117.417 E.61846
G1 X133.116 Y117.417
G1 X119.417 Y131.116 E.59529
G1 X119.417 Y130.583
G1 X132.583 Y117.417 E.57212
G1 X132.05 Y117.417
G1 X119.417 Y130.05 E.54894
G1 X119.417 Y129.517
G1 X131.517 Y117.417 E.52577
G1 X130.983 Y117.417
G1 X119.417 Y128.983 E.5026
G1 X119.417 Y128.45
G1 X130.45 Y117.417 E.47943
G1 X129.917 Y117.417
G1 X119.417 Y127.917 E.45625
G1 X119.417 Y127.384
G1 X129.384 Y117.417 E.43308
G1 X128.85 Y117.417
G1 X119.417 Y126.85 E.40991
G1 X119.417 Y126.317
G1 X128.317 Y117.417 E.38674
G1 X127.784 Y117.417
G1 X119.417 Y125.784 E.36356
G1 X119.417 Y125.251
G1 X127.251 Y117.417 E.34039
G1 X126.717 Y117.417
G1 X119.417 Y124.717 E.31722
G1 X119.417 Y124.184
G1 X126.184 Y117.417 E.29404
G1 X125.651 Y117.417
G1 X119.417 Y123.651 E.27087
G1 X119.417 Y123.118
G1 X125.118 Y117.417 E.2477
G1 X124.584 Y117.417
G1 X119.417 Y122.584 E.22453
G1 X119.417 Y122.051
G1 X124.051 Y117.417 E.20135
G1 X123.518 Y117.417
G1 X119.417 Y121.518 E.17818
G1 X119.417 Y120.984
G1 X122.984 Y117.417 E.15501
G1 X122.451 Y117.417
G1 X119.417 Y120.451 E.13184
G1 X119.417 Y119.918
G1 X121.918 Y117.417 E.10866
G1 X121.385 Y117.417
G1 X119.417 Y119.385 E.08549
G1 X119.417 Y118.851
G1 X120.851 Y117.417 E.06232
G1 X120.318 Y117.417
G1 X119.417 Y118.318 E.03915
G1 X119.417 Y117.785
G1 X119.785 Y117.417 E.01597
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S10000
G1 X119.417 Y117.785 E-.19754
G1 X119.417 Y118.318 E-.20264
G1 X120.087 Y117.649 E-.35982
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z18.5 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S

M17 R ; restore z current
;<<< INSERT:cooldown_fans_wait START
; ====== Cool Down =====
M106 P2 S255        ;turn Aux fan on
M106 P3 S200        ;turn on chamber cooling fan
M400
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
; total max wait time of all lines = 40 min
M106 P2 S0         ;turn off Aux fan
M106 P3 S0         ;turn off chamber cooling fan
M400
;>>> Cooldown_fans_wait END
;<<< INSERT:raise_bed_after_cooldown START
;=== Raise Bed Level (after cooldown) ===
M400
G1 Z1 F600
M400 P100
;>>> INSERT:raise_bed_after_cooldown END
;<<< INSERT:push_off_sequence START
G1 X120.00 Y254 F2000
G1 X120.00 Y5 F300
G1 X120.00 Y254 F2000
;--- PUSH_OFF at Z=9 mm ---
G1 Z9 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;--- PUSH_OFF at Z=1 mm ---
G1 Z1 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;>>> INSERT:push_off_sequence END
;>>> INSERT:cooldown_fans_wait END

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
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp

; EXECUTABLE_BLOCK_END



; EXECUTABLE_BLOCK_START
; start printing plate 2
M73 P0 R14
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: X1 ====================
;===== date: 20240919 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S55 ;set bed temp
M190 S55 ;wait for bed temp


;=========register first layer scan=====

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S220 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S1A   ; switch material if AMS exist
    M109 S220
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T1
    G1 X54 F12000
    G1 Y265
    M400
M621 S1A
M620.1 E F548.788 T240

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P3 R14
G1 E50 F200
M400
M104 S220
G92 E0
M73 P33 R9
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P34 R9
G1 E-0.5 F300

M73 P36 R9
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S200
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
M73 P37 R9
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================

;===== check scanner clarity end =======================

;===== bed leveling ==================================

;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S220 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================

;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000

M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate


;===== draw extrinsic para cali paint =================

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S220
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================

; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S150


;VT1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/90
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.143 Y134.143
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X119.857 Y134.143 E3
G1 X119.857 Y117.857 E.60659
G1 X136.143 Y117.857 E.60659
G1 X136.143 Y134.083 E.60435
M204 S6000
G1 X136.6 Y134.6 F30000
; FEATURE: Outer wall
G1 F3000
M204 S500
M73 P44 R8
G1 X119.4 Y134.6 E.64064
G1 X119.4 Y117.4 E.64064
G1 X136.6 Y117.4 E.64064
G1 X136.6 Y134.54 E.6384
; WIPE_START
G1 X134.6 Y134.547 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X134.798 Y126.917 Z.6 F30000
G1 X135.028 Y118.04 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50372
G1 F6300
M204 S500
G1 X135.754 Y118.766 E.03856
G1 X135.754 Y119.418 E.02447
G1 X134.582 Y118.246 E.06225
G1 X133.931 Y118.246 E.02447
G1 X135.754 Y120.069 E.09685
G1 X135.754 Y120.721 E.02447
G1 X133.279 Y118.246 E.13146
G1 X132.627 Y118.246 E.02447
G1 X135.754 Y121.373 E.16606
G1 X135.754 Y122.024 E.02447
G1 X131.976 Y118.246 E.20067
G1 X131.324 Y118.246 E.02447
G1 X135.754 Y122.676 E.23527
G1 X135.754 Y123.328 E.02447
G1 X130.672 Y118.246 E.26988
G1 X130.021 Y118.246 E.02447
G1 X135.754 Y123.979 E.30448
G1 X135.754 Y124.631 E.02447
M73 P45 R8
G1 X129.369 Y118.246 E.33909
G1 X128.717 Y118.246 E.02447
G1 X135.754 Y125.283 E.37369
G1 X135.754 Y125.934 E.02447
G1 X128.066 Y118.246 E.4083
G1 X127.414 Y118.246 E.02447
G1 X135.754 Y126.586 E.44291
G1 X135.754 Y127.238 E.02447
G1 X126.762 Y118.246 E.47751
G1 X126.111 Y118.246 E.02447
G1 X135.754 Y127.889 E.51212
G1 X135.754 Y128.541 E.02447
G1 X125.459 Y118.246 E.54672
M73 P46 R8
G1 X124.807 Y118.246 E.02447
M73 P48 R7
G1 X135.754 Y129.193 E.58133
G1 X135.754 Y129.844 E.02447
G1 X124.156 Y118.246 E.61593
G1 X123.504 Y118.246 E.02447
G1 X135.754 Y130.496 E.65054
G1 X135.754 Y131.148 E.02447
G1 X122.852 Y118.246 E.68514
G1 X122.201 Y118.246 E.02447
G1 X135.754 Y131.799 E.71975
G1 X135.754 Y132.451 E.02447
G1 X121.549 Y118.246 E.75436
G1 X120.897 Y118.246 E.02447
G1 X135.754 Y133.103 E.78896
G1 X135.754 Y133.754 E.02447
G1 X120.246 Y118.246 E.82356
G1 X120.246 Y118.897 E.02447
G1 X135.103 Y133.754 E.78895
G1 X134.451 Y133.754 E.02447
G1 X120.246 Y119.549 E.75435
G1 X120.246 Y120.201 E.02447
G1 X133.799 Y133.754 E.71974
G1 X133.148 Y133.754 E.02447
G1 X120.246 Y120.852 E.68514
G1 X120.246 Y121.504 E.02447
G1 X132.496 Y133.754 E.65053
G1 X131.844 Y133.754 E.02447
G1 X120.246 Y122.156 E.61593
G1 X120.246 Y122.807 E.02447
G1 X131.193 Y133.754 E.58132
G1 X130.541 Y133.754 E.02447
G1 X120.246 Y123.459 E.54672
G1 X120.246 Y124.111 E.02447
G1 X129.889 Y133.754 E.51211
G1 X129.238 Y133.754 E.02447
G1 X120.246 Y124.762 E.47751
G1 X120.246 Y125.414 E.02447
G1 X128.586 Y133.754 E.4429
G1 X127.934 Y133.754 E.02447
G1 X120.246 Y126.066 E.40829
G1 X120.246 Y126.717 E.02447
G1 X127.283 Y133.754 E.37369
G1 X126.631 Y133.754 E.02447
M73 P49 R7
G1 X120.246 Y127.369 E.33908
G1 X120.246 Y128.021 E.02447
G1 X125.979 Y133.754 E.30448
G1 X125.328 Y133.754 E.02447
G1 X120.246 Y128.672 E.26987
G1 X120.246 Y129.324 E.02447
G1 X124.676 Y133.754 E.23527
G1 X124.024 Y133.754 E.02447
G1 X120.246 Y129.976 E.20066
G1 X120.246 Y130.627 E.02447
G1 X123.373 Y133.754 E.16606
G1 X122.721 Y133.754 E.02447
G1 X120.246 Y131.279 E.13145
G1 X120.246 Y131.931 E.02447
G1 X122.069 Y133.754 E.09684
G1 X121.418 Y133.754 E.02447
G1 X120.246 Y132.582 E.06224
G1 X120.246 Y133.234 E.02447
G1 X120.972 Y133.96 E.03856
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X120.246 Y133.234 E-.39019
G1 X120.246 Y132.582 E-.24763
G1 X120.473 Y132.81 E-.12218
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/90
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
M976 S1 P1 ; scan model before printing 2nd layer
M400 P100
G1 E.8
G1 E-.8
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13548
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13548
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
M73 P50 R7
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
M73 P51 R7
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/90
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z1 F30000
G1 X136.234 Y118.54 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
M73 P52 R7
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/90
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z1 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4019
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4019
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4019
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/90
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.4 F30000
G1 X136.05 Y120.326 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/90
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
M73 P53 R6
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/90
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.8 F30000
G1 X136.05 Y120.326 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/90
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P54 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/90
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.2 F30000
G1 X136.05 Y120.326 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/90
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P55 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/90
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.6 F30000
G1 X136.05 Y120.326 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/90
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
M73 P56 R6
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/90
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3 F30000
G1 X136.05 Y120.326 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/90
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.2 F30000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P57 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/90
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.4 F30000
G1 X136.05 Y120.326 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/90
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.6 F30000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P58 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/90
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.8 F30000
G1 X136.05 Y120.326 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/90
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4 F30000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
M73 P59 R6
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/90
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.2 F30000
G1 X136.05 Y120.326 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/90
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P59 R5
G1 X136.05 Y131.674 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P60 R5
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/90
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.6 F30000
G1 X136.05 Y120.326 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/90
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4.8 F30000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P61 R5
G1 E-.04 F1800
; layer num/total_layer_count: 23/90
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5 F30000
G1 X136.05 Y120.326 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/90
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.2 F30000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P62 R5
G1 E-.04 F1800
; layer num/total_layer_count: 25/90
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.4 F30000
G1 X136.05 Y120.326 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/90
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.6 F30000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P63 R5
G1 E-.04 F1800
; layer num/total_layer_count: 27/90
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.8 F30000
G1 X136.05 Y120.326 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/90
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6 F30000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/90
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
M73 P64 R5
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.2 F30000
G1 X136.05 Y120.326 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/90
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/90
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z6.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
M73 P65 R5
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.6 F30000
G1 X136.05 Y120.326 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/90
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z6.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.8 F30000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/90
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z6.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P66 R5
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7 F30000
G1 X136.05 Y120.326 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
M73 P66 R4
G1 E-.04 F1800
; layer num/total_layer_count: 34/90
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z7 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.2 F30000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/90
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z7.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P67 R4
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.4 F30000
G1 X136.05 Y120.326 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/90
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z7.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/90
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P68 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.8 F30000
G1 X136.05 Y120.326 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/90
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z7.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/90
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P69 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.2 F30000
G1 X136.05 Y120.326 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/90
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z8.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.4 F30000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/90
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z8.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P70 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.6 F30000
G1 X136.05 Y120.326 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/90
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z8.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/90
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z8.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P71 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9 F30000
G1 X136.05 Y120.326 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/90
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/90
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z9.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P72 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.4 F30000
G1 X136.05 Y120.326 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/90
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z9.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.6 F30000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/90
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z9.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P73 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.8 F30000
G1 X136.05 Y120.326 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P73 R3
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/90
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z9.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10 F30000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/90
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z10 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P74 R3
G1 X135.455 Y127.133 Z10.2 F30000
G1 X136.05 Y120.326 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/90
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z10.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.4 F30000
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/90
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P75 R3
G1 X135.455 Y127.133 Z10.6 F30000
G1 X136.05 Y120.326 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/90
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z10.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.8 F30000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/90
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
G17
G3 Z10.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11 F30000
M73 P76 R3
G1 X136.05 Y120.326 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/90
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
G17
G3 Z11 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.2 F30000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/90
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z11.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.4 F30000
M73 P77 R3
G1 X136.05 Y120.326 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/90
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z11.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.6 F30000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/90
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z11.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.8 F30000
M73 P78 R3
G1 X136.05 Y120.326 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/90
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/90
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.2 F30000
G1 X136.05 Y120.326 Z12.2
M73 P79 R3
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/90
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
G17
G3 Z12.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/90
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
G17
G3 Z12.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P79 R2
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.6 F30000
G1 X136.05 Y120.326 Z12.6
M73 P80 R2
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/90
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z12.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.8 F30000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/90
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z12.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13 F30000
G1 X136.05 Y120.326 Z13
G1 Z12.6
M73 P81 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/90
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z13 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.2 F30000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/90
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.4 F30000
G1 X136.05 Y120.326 Z13.4
G1 Z13
M73 P82 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/90
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z13.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.6 F30000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/90
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
G17
G3 Z13.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.8 F30000
G1 X136.05 Y120.326 Z13.8
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
M73 P83 R2
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/90
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z13.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14 F30000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/90
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z14 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.2 F30000
G1 X136.05 Y120.326 Z14.2
G1 Z13.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
M73 P84 R2
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/90
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z14.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.4 F30000
G1 Z14
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/90
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z14.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.6 F30000
G1 X136.05 Y120.326 Z14.6
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P85 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/90
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.8 F30000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/90
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
G17
G3 Z14.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15 F30000
G1 X136.05 Y120.326 Z15
G1 Z14.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P86 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/90
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
G17
G3 Z15 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.2 F30000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P86 R1
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/90
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
G17
G3 Z15.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.4 F30000
G1 X136.05 Y120.326 Z15.4
G1 Z15
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
M73 P87 R1
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/90
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
G17
G3 Z15.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.6 F30000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/90
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
G17
G3 Z15.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.8 F30000
G1 X136.05 Y120.326 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P88 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/90
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
G17
G3 Z15.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16 F30000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/90
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.2 F30000
G1 X136.05 Y120.326 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P89 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/90
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
G17
G3 Z16.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.4 F30000
G1 Z16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/90
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
G17
G3 Z16.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.6 F30000
G1 X136.05 Y120.326 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
M73 P90 R1
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/90
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
G17
G3 Z16.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/90
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
G17
G3 Z16.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z17 F30000
G1 X136.05 Y120.326 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
M73 P91 R1
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/90
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
G17
G3 Z17 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/90
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
G17
G3 Z17.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5760
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5760
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.044 Y133.673 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5760
G1 X135.673 Y133.673 E.05401
G1 X120.327 Y118.327 E.71987
G1 X127.997 Y118.327 E.2544
G1 X120.327 Y125.997 E.35977
G1 X127.997 Y133.673 E.35993
G1 X135.673 Y126.003 E.35993
G1 X128.003 Y118.327 E.35993
G1 X135.673 Y118.327 E.2544
G1 X120.327 Y133.673 E.71987
G1 X120.327 Y132.044 E.05401
G1 X136.008 Y117.992 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.399311
G1 F3000;_EXTRUDE_SET_SPEED
G1 X136.035 Y118.124 E.00391
G1 X136.035 Y133.876 E.45746
G1 X136.008 Y134.008 E.00391
G1 X135.876 Y134.035 E.00391
G1 X120.124 Y134.035 E.45746
G1 X119.992 Y134.008 E.00391
G1 X119.965 Y133.876 E.00391
M73 P92 R1
G1 X119.965 Y118.124 E.45746
G1 X119.992 Y117.992 E.00391
G1 X120.124 Y117.965 E.00391
G1 X135.876 Y117.965 E.45746
G1 X135.949 Y117.98 E.00217
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F3000
G1 X135.876 Y117.965 E-.02837
G1 X133.951 Y117.965 E-.73163
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/90
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.305 Y134.231 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40771
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X136.028 Y133.507 E.05443
G1 X136.028 Y132.86 E.03443
G1 X134.86 Y134.028 E.08789
G1 X134.213 Y134.028 E.03443
G1 X136.028 Y132.213 E.13658
G1 X136.028 Y131.565 E.03443
G1 X133.565 Y134.028 E.18527
G1 X132.918 Y134.028 E.03443
G1 X136.028 Y130.918 E.23397
G1 X136.028 Y130.271 E.03443
G1 X132.271 Y134.028 E.28266
G1 X131.623 Y134.028 E.03443
G1 X136.028 Y129.623 E.33136
G1 X136.028 Y128.976 E.03443
G1 X130.976 Y134.028 E.38005
G1 X130.329 Y134.028 E.03443
G1 X136.028 Y128.329 E.42874
G1 X136.028 Y127.681 E.03443
G1 X129.681 Y134.028 E.47744
G1 X129.034 Y134.028 E.03443
G1 X136.028 Y127.034 E.52613
G1 X136.028 Y126.387 E.03443
G1 X128.387 Y134.028 E.57482
G1 X127.74 Y134.028 E.03443
G1 X136.028 Y125.74 E.62352
G1 X136.028 Y125.092 E.03443
G1 X127.092 Y134.028 E.67221
G1 X126.445 Y134.028 E.03443
G1 X136.028 Y124.445 E.72091
G1 X136.028 Y123.798 E.03443
G1 X125.798 Y134.028 E.7696
G1 X125.15 Y134.028 E.03443
G1 X136.028 Y123.15 E.81829
G1 X136.028 Y122.503 E.03443
G1 X124.503 Y134.028 E.86699
G1 X123.856 Y134.028 E.03443
G1 X136.028 Y121.856 E.91568
G1 X136.028 Y121.208 E.03443
G1 X123.208 Y134.028 E.96437
G1 X122.561 Y134.028 E.03443
G1 X136.028 Y120.561 E1.01307
G1 X136.028 Y119.914 E.03443
G1 X121.914 Y134.028 E1.06176
G1 X121.267 Y134.028 E.03443
G1 X136.028 Y119.267 E1.11046
G1 X136.028 Y118.619 E.03443
G1 X120.619 Y134.028 E1.15915
G1 X119.972 Y134.028 E.03443
G1 X136.028 Y117.972 E1.20784
G1 X135.381 Y117.972 E.03442
G1 X119.972 Y133.381 E1.15918
G1 X119.972 Y132.734 E.03443
G1 X134.734 Y117.972 E1.11049
G1 X134.087 Y117.972 E.03443
G1 X119.972 Y132.087 E1.06179
G1 X119.972 Y131.439 E.03443
G1 X133.439 Y117.972 E1.0131
G1 X132.792 Y117.972 E.03443
G1 X119.972 Y130.792 E.96441
G1 X119.972 Y130.145 E.03443
G1 X132.145 Y117.972 E.91571
G1 X131.497 Y117.972 E.03443
G1 X119.972 Y129.497 E.86702
G1 X119.972 Y128.85 E.03443
G1 X130.85 Y117.972 E.81833
G1 X130.203 Y117.972 E.03443
G1 X119.972 Y128.203 E.76963
G1 X119.972 Y127.555 E.03443
G1 X129.555 Y117.972 E.72094
M73 P93 R1
G1 X128.908 Y117.972 E.03443
G1 X119.972 Y126.908 E.67224
G1 X119.972 Y126.261 E.03443
G1 X128.261 Y117.972 E.62355
G1 X127.614 Y117.972 E.03443
G1 X119.972 Y125.614 E.57486
G1 X119.972 Y124.966 E.03443
G1 X126.966 Y117.972 E.52616
G1 X126.319 Y117.972 E.03443
G1 X119.972 Y124.319 E.47747
G1 X119.972 Y123.672 E.03443
G1 X125.672 Y117.972 E.42878
G1 X125.024 Y117.972 E.03443
G1 X119.972 Y123.024 E.38008
G1 X119.972 Y122.377 E.03443
G1 X124.377 Y117.972 E.33139
G1 X123.73 Y117.972 E.03443
G1 X119.972 Y121.73 E.28269
G1 X119.972 Y121.082 E.03443
G1 X123.082 Y117.972 E.234
G1 X122.435 Y117.972 E.03443
G1 X119.972 Y120.435 E.18531
G1 X119.972 Y119.788 E.03443
G1 X121.788 Y117.972 E.13661
G1 X121.141 Y117.972 E.03443
G1 X119.972 Y119.141 E.08792
G1 X119.972 Y118.493 E.03443
G1 X120.696 Y117.769 E.05446
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3000
G1 X119.972 Y118.493 E-.38905
G1 X119.972 Y119.141 E-.24597
G1 X120.204 Y118.908 E-.12498
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/90
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
G17
G3 Z17.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13595
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z17.8 F30000
M73 P93 R0
G1 X136.234 Y118.54 Z17.8
G1 Z17.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13595
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
M73 P94 R0
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/90
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
G17
G3 Z17.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13299
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13299
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
M73 P95 R0
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/90
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
G17
G3 Z18 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z18.2 F30000
G1 X136.234 Y118.54 Z18.2
G1 Z17.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
M73 P96 R0
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/90
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
G17
G3 Z18.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.79 Y134.79
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
M204 S10000
G1 X136.583 Y134.215 F30000
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X136.215 Y134.583 E.01598
G1 X135.682 Y134.583
G1 X136.583 Y133.682 E.03915
G1 X136.583 Y133.148
G1 X135.148 Y134.583 E.06232
G1 X134.615 Y134.583
G1 X136.583 Y132.615 E.0855
G1 X136.583 Y132.082
G1 X134.082 Y134.583 E.10867
G1 X133.549 Y134.583
G1 X136.583 Y131.549 E.13184
G1 X136.583 Y131.015
G1 X133.015 Y134.583 E.15501
G1 X132.482 Y134.583
G1 X136.583 Y130.482 E.17819
G1 X136.583 Y129.949
G1 X131.949 Y134.583 E.20136
G1 X131.416 Y134.583
G1 X136.583 Y129.416 E.22453
G1 X136.583 Y128.882
G1 X130.882 Y134.583 E.2477
G1 X130.349 Y134.583
G1 X136.583 Y128.349 E.27088
G1 X136.583 Y127.816
G1 X129.816 Y134.583 E.29405
G1 X129.283 Y134.583
G1 X136.583 Y127.283 E.31722
G1 X136.583 Y126.749
G1 X128.749 Y134.583 E.3404
G1 X128.216 Y134.583
G1 X136.583 Y126.216 E.36357
G1 X136.583 Y125.683
G1 X127.683 Y134.583 E.38674
G1 X127.15 Y134.583
G1 X136.583 Y125.15 E.40991
G1 X136.583 Y124.616
G1 X126.616 Y134.583 E.43309
G1 X126.083 Y134.583
G1 X136.583 Y124.083 E.45626
G1 X136.583 Y123.55
G1 X125.55 Y134.583 E.47943
G1 X125.017 Y134.583
G1 X136.583 Y123.017 E.5026
G1 X136.583 Y122.483
G1 X124.483 Y134.583 E.52578
G1 X123.95 Y134.583
G1 X136.583 Y121.95 E.54895
G1 X136.583 Y121.417
G1 X123.417 Y134.583 E.57212
G1 X122.883 Y134.583
G1 X136.583 Y120.883 E.59529
G1 X136.583 Y120.35
G1 X122.35 Y134.583 E.61847
G1 X121.817 Y134.583
G1 X136.583 Y119.817 E.64164
G1 X136.583 Y119.284
G1 X121.284 Y134.583 E.66481
G1 X120.75 Y134.583
G1 X136.583 Y118.75 E.68798
G1 X136.583 Y118.217
G1 X120.217 Y134.583 E.71116
G1 X119.684 Y134.583
G1 X136.583 Y117.684 E.73433
G1 X136.316 Y117.417
G1 X119.417 Y134.316 E.73432
G1 X119.417 Y133.783
G1 X135.783 Y117.417 E.71115
G1 X135.249 Y117.417
G1 X119.417 Y133.249 E.68798
G1 X119.417 Y132.716
G1 X134.716 Y117.417 E.66481
G1 X134.183 Y117.417
G1 X119.417 Y132.183 E.64163
M73 P97 R0
G1 X119.417 Y131.65
G1 X133.65 Y117.417 E.61846
G1 X133.116 Y117.417
G1 X119.417 Y131.116 E.59529
G1 X119.417 Y130.583
G1 X132.583 Y117.417 E.57212
G1 X132.05 Y117.417
G1 X119.417 Y130.05 E.54894
G1 X119.417 Y129.517
G1 X131.517 Y117.417 E.52577
G1 X130.983 Y117.417
G1 X119.417 Y128.983 E.5026
G1 X119.417 Y128.45
G1 X130.45 Y117.417 E.47943
G1 X129.917 Y117.417
G1 X119.417 Y127.917 E.45625
G1 X119.417 Y127.384
G1 X129.384 Y117.417 E.43308
G1 X128.85 Y117.417
G1 X119.417 Y126.85 E.40991
G1 X119.417 Y126.317
G1 X128.317 Y117.417 E.38674
G1 X127.784 Y117.417
G1 X119.417 Y125.784 E.36356
G1 X119.417 Y125.251
G1 X127.251 Y117.417 E.34039
G1 X126.717 Y117.417
G1 X119.417 Y124.717 E.31722
G1 X119.417 Y124.184
G1 X126.184 Y117.417 E.29404
G1 X125.651 Y117.417
G1 X119.417 Y123.651 E.27087
G1 X119.417 Y123.118
G1 X125.118 Y117.417 E.2477
G1 X124.584 Y117.417
G1 X119.417 Y122.584 E.22453
G1 X119.417 Y122.051
G1 X124.051 Y117.417 E.20135
G1 X123.518 Y117.417
G1 X119.417 Y121.518 E.17818
G1 X119.417 Y120.984
G1 X122.984 Y117.417 E.15501
G1 X122.451 Y117.417
G1 X119.417 Y120.451 E.13184
G1 X119.417 Y119.918
G1 X121.918 Y117.417 E.10866
G1 X121.385 Y117.417
G1 X119.417 Y119.385 E.08549
G1 X119.417 Y118.851
G1 X120.851 Y117.417 E.06232
G1 X120.318 Y117.417
G1 X119.417 Y118.318 E.03915
G1 X119.417 Y117.785
G1 X119.785 Y117.417 E.01597
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S10000
G1 X119.417 Y117.785 E-.19754
G1 X119.417 Y118.318 E-.20264
G1 X120.087 Y117.649 E-.35982
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z18.5 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S

M17 R ; restore z current
;<<< INSERT:cooldown_fans_wait START
; ====== Cool Down =====
M106 P2 S255        ;turn Aux fan on
M106 P3 S200        ;turn on chamber cooling fan
M400
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
; total max wait time of all lines = 40 min
M106 P2 S0         ;turn off Aux fan
M106 P3 S0         ;turn off chamber cooling fan
M400
;>>> Cooldown_fans_wait END
;<<< INSERT:raise_bed_after_cooldown START
;=== Raise Bed Level (after cooldown) ===
M400
G1 Z1 F600
M400 P100
;>>> INSERT:raise_bed_after_cooldown END
;<<< INSERT:push_off_sequence START
G1 X120.00 Y254 F2000
G1 X120.00 Y5 F300
G1 X120.00 Y254 F2000
;--- PUSH_OFF at Z=9 mm ---
G1 Z9 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;--- PUSH_OFF at Z=1 mm ---
G1 Z1 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;>>> INSERT:push_off_sequence END
;>>> INSERT:cooldown_fans_wait END

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
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp

; EXECUTABLE_BLOCK_END



; EXECUTABLE_BLOCK_START
; start printing plate 3
M73 P0 R14
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: X1 ====================
;===== date: 20240919 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S55 ;set bed temp
M190 S55 ;wait for bed temp


;=========register first layer scan=====

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S220 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S2A   ; switch material if AMS exist
    M109 S220
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T2
    G1 X54 F12000
    G1 Y265
    M400
M621 S2A
M620.1 E F548.788 T240

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P3 R14
G1 E50 F200
M400
M104 S220
G92 E0
M73 P33 R9
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P34 R9
G1 E-0.5 F300

M73 P36 R9
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S200
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
M73 P37 R9
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================

;===== check scanner clarity end =======================

;===== bed leveling ==================================

;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming
    M142 P1 R35 S40

M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S220 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================

;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000

M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate


;===== draw extrinsic para cali paint =================

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S220
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================

; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S150


;VT2
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/90
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.143 Y134.143
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X119.857 Y134.143 E3
G1 X119.857 Y117.857 E.60659
G1 X136.143 Y117.857 E.60659
G1 X136.143 Y134.083 E.60435
M204 S6000
G1 X136.6 Y134.6 F30000
; FEATURE: Outer wall
G1 F3000
M204 S500
M73 P44 R8
G1 X119.4 Y134.6 E.64064
G1 X119.4 Y117.4 E.64064
G1 X136.6 Y117.4 E.64064
G1 X136.6 Y134.54 E.6384
; WIPE_START
G1 X134.6 Y134.547 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X134.798 Y126.917 Z.6 F30000
G1 X135.028 Y118.04 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50372
G1 F6300
M204 S500
G1 X135.754 Y118.766 E.03856
G1 X135.754 Y119.418 E.02447
G1 X134.582 Y118.246 E.06225
G1 X133.931 Y118.246 E.02447
G1 X135.754 Y120.069 E.09685
G1 X135.754 Y120.721 E.02447
G1 X133.279 Y118.246 E.13146
G1 X132.627 Y118.246 E.02447
G1 X135.754 Y121.373 E.16606
G1 X135.754 Y122.024 E.02447
G1 X131.976 Y118.246 E.20067
G1 X131.324 Y118.246 E.02447
G1 X135.754 Y122.676 E.23527
G1 X135.754 Y123.328 E.02447
G1 X130.672 Y118.246 E.26988
G1 X130.021 Y118.246 E.02447
G1 X135.754 Y123.979 E.30448
G1 X135.754 Y124.631 E.02447
M73 P45 R8
G1 X129.369 Y118.246 E.33909
G1 X128.717 Y118.246 E.02447
G1 X135.754 Y125.283 E.37369
G1 X135.754 Y125.934 E.02447
G1 X128.066 Y118.246 E.4083
G1 X127.414 Y118.246 E.02447
G1 X135.754 Y126.586 E.44291
G1 X135.754 Y127.238 E.02447
G1 X126.762 Y118.246 E.47751
G1 X126.111 Y118.246 E.02447
G1 X135.754 Y127.889 E.51212
G1 X135.754 Y128.541 E.02447
G1 X125.459 Y118.246 E.54672
M73 P46 R8
G1 X124.807 Y118.246 E.02447
M73 P48 R7
G1 X135.754 Y129.193 E.58133
G1 X135.754 Y129.844 E.02447
G1 X124.156 Y118.246 E.61593
G1 X123.504 Y118.246 E.02447
G1 X135.754 Y130.496 E.65054
G1 X135.754 Y131.148 E.02447
G1 X122.852 Y118.246 E.68514
G1 X122.201 Y118.246 E.02447
G1 X135.754 Y131.799 E.71975
G1 X135.754 Y132.451 E.02447
G1 X121.549 Y118.246 E.75436
G1 X120.897 Y118.246 E.02447
G1 X135.754 Y133.103 E.78896
G1 X135.754 Y133.754 E.02447
G1 X120.246 Y118.246 E.82356
G1 X120.246 Y118.897 E.02447
G1 X135.103 Y133.754 E.78895
G1 X134.451 Y133.754 E.02447
G1 X120.246 Y119.549 E.75435
G1 X120.246 Y120.201 E.02447
G1 X133.799 Y133.754 E.71974
G1 X133.148 Y133.754 E.02447
G1 X120.246 Y120.852 E.68514
G1 X120.246 Y121.504 E.02447
G1 X132.496 Y133.754 E.65053
G1 X131.844 Y133.754 E.02447
G1 X120.246 Y122.156 E.61593
G1 X120.246 Y122.807 E.02447
G1 X131.193 Y133.754 E.58132
G1 X130.541 Y133.754 E.02447
G1 X120.246 Y123.459 E.54672
G1 X120.246 Y124.111 E.02447
G1 X129.889 Y133.754 E.51211
G1 X129.238 Y133.754 E.02447
G1 X120.246 Y124.762 E.47751
G1 X120.246 Y125.414 E.02447
G1 X128.586 Y133.754 E.4429
G1 X127.934 Y133.754 E.02447
G1 X120.246 Y126.066 E.40829
G1 X120.246 Y126.717 E.02447
G1 X127.283 Y133.754 E.37369
G1 X126.631 Y133.754 E.02447
M73 P49 R7
G1 X120.246 Y127.369 E.33908
G1 X120.246 Y128.021 E.02447
G1 X125.979 Y133.754 E.30448
G1 X125.328 Y133.754 E.02447
G1 X120.246 Y128.672 E.26987
G1 X120.246 Y129.324 E.02447
G1 X124.676 Y133.754 E.23527
G1 X124.024 Y133.754 E.02447
G1 X120.246 Y129.976 E.20066
G1 X120.246 Y130.627 E.02447
G1 X123.373 Y133.754 E.16606
G1 X122.721 Y133.754 E.02447
G1 X120.246 Y131.279 E.13145
G1 X120.246 Y131.931 E.02447
G1 X122.069 Y133.754 E.09684
G1 X121.418 Y133.754 E.02447
G1 X120.246 Y132.582 E.06224
G1 X120.246 Y133.234 E.02447
G1 X120.972 Y133.96 E.03856
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X120.246 Y133.234 E-.39019
G1 X120.246 Y132.582 E-.24763
G1 X120.473 Y132.81 E-.12218
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/90
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
M976 S1 P1 ; scan model before printing 2nd layer
M400 P100
G1 E.8
G1 E-.8
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13548
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13548
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
M73 P50 R7
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
M73 P51 R7
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/90
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z1 F30000
G1 X136.234 Y118.54 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
M73 P52 R7
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/90
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z1 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4019
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4019
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4019
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/90
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.4 F30000
G1 X136.05 Y120.326 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/90
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
M73 P53 R6
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/90
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z1.8 F30000
G1 X136.05 Y120.326 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/90
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P54 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/90
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.2 F30000
G1 X136.05 Y120.326 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/90
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
M73 P55 R6
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/90
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z2.6 F30000
G1 X136.05 Y120.326 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/90
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
M73 P56 R6
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/90
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3 F30000
G1 X136.05 Y120.326 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/90
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.2 F30000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P57 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/90
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.4 F30000
G1 X136.05 Y120.326 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/90
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z3.6 F30000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
M73 P58 R6
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/90
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z3.8 F30000
G1 X136.05 Y120.326 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/90
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4 F30000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
M73 P59 R6
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/90
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.2 F30000
G1 X136.05 Y120.326 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/90
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P59 R5
G1 X136.05 Y131.674 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P60 R5
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/90
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z4.6 F30000
G1 X136.05 Y120.326 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/90
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z4.8 F30000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P61 R5
G1 E-.04 F1800
; layer num/total_layer_count: 23/90
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5 F30000
G1 X136.05 Y120.326 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/90
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.2 F30000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P62 R5
G1 E-.04 F1800
; layer num/total_layer_count: 25/90
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.4 F30000
G1 X136.05 Y120.326 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/90
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z5.6 F30000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
M73 P63 R5
G1 E-.04 F1800
; layer num/total_layer_count: 27/90
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z5.8 F30000
G1 X136.05 Y120.326 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/90
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6 F30000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/90
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
M73 P64 R5
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.2 F30000
G1 X136.05 Y120.326 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/90
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/90
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z6.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
M73 P65 R5
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z6.6 F30000
G1 X136.05 Y120.326 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/90
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z6.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z6.8 F30000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/90
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z6.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P66 R5
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7 F30000
G1 X136.05 Y120.326 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
M73 P66 R4
G1 E-.04 F1800
; layer num/total_layer_count: 34/90
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z7 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.2 F30000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/90
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z7.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
M73 P67 R4
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.4 F30000
G1 X136.05 Y120.326 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/90
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z7.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/90
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P68 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z7.8 F30000
G1 X136.05 Y120.326 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/90
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z7.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/90
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
M73 P69 R4
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.2 F30000
G1 X136.05 Y120.326 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/90
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z8.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.4 F30000
G1 Z8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/90
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z8.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P70 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z8.6 F30000
G1 X136.05 Y120.326 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/90
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z8.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/90
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z8.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
M73 P71 R4
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9 F30000
G1 X136.05 Y120.326 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/90
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/90
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z9.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P72 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.4 F30000
G1 X136.05 Y120.326 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/90
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z9.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z9.6 F30000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/90
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z9.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P73 R4
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z9.8 F30000
G1 X136.05 Y120.326 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P73 R3
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/90
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z9.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10 F30000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/90
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z10 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P74 R3
G1 X135.455 Y127.133 Z10.2 F30000
G1 X136.05 Y120.326 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/90
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z10.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.4 F30000
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/90
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P75 R3
G1 X135.455 Y127.133 Z10.6 F30000
G1 X136.05 Y120.326 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/90
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z10.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z10.8 F30000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/90
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
G17
G3 Z10.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11 F30000
M73 P76 R3
G1 X136.05 Y120.326 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/90
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
G17
G3 Z11 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.2 F30000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/90
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z11.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.4 F30000
M73 P77 R3
G1 X136.05 Y120.326 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/90
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z11.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z11.6 F30000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/90
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z11.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z11.8 F30000
M73 P78 R3
G1 X136.05 Y120.326 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/90
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/90
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.2 F30000
G1 X136.05 Y120.326 Z12.2
M73 P79 R3
G1 Z11.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/90
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
G17
G3 Z12.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/90
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
G17
G3 Z12.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M73 P79 R2
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z12.6 F30000
G1 X136.05 Y120.326 Z12.6
M73 P80 R2
G1 Z12.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/90
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z12.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z12.8 F30000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/90
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z12.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13 F30000
G1 X136.05 Y120.326 Z13
G1 Z12.6
M73 P81 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/90
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z13 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.2 F30000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/90
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.4 F30000
G1 X136.05 Y120.326 Z13.4
G1 Z13
M73 P82 R2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/90
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z13.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z13.6 F30000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/90
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
G17
G3 Z13.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z13.8 F30000
G1 X136.05 Y120.326 Z13.8
G1 Z13.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
M73 P83 R2
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/90
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z13.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14 F30000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/90
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z14 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.2 F30000
G1 X136.05 Y120.326 Z14.2
G1 Z13.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
M73 P84 R2
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/90
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z14.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.4 F30000
G1 Z14
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/90
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z14.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z14.6 F30000
G1 X136.05 Y120.326 Z14.6
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P85 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/90
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z14.8 F30000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/90
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
G17
G3 Z14.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15 F30000
G1 X136.05 Y120.326 Z15
G1 Z14.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
M73 P86 R2
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/90
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
G17
G3 Z15 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.2 F30000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P86 R1
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/90
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
G17
G3 Z15.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.4 F30000
G1 X136.05 Y120.326 Z15.4
G1 Z15
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
M73 P87 R1
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/90
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
G17
G3 Z15.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z15.6 F30000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/90
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
G17
G3 Z15.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z15.8 F30000
G1 X136.05 Y120.326 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P88 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/90
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
G17
G3 Z15.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16 F30000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/90
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.2 F30000
G1 X136.05 Y120.326 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
M73 P89 R1
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/90
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
G17
G3 Z16.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.4 F30000
G1 Z16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/90
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
G17
G3 Z16.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z16.6 F30000
G1 X136.05 Y120.326 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
M73 P90 R1
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/90
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
G17
G3 Z16.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/90
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
G17
G3 Z16.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4042
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4042
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.455 Y127.133 Z17 F30000
G1 X136.05 Y120.326 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4042
G1 X136.05 Y118.698 E.05401
G1 X135.302 Y117.95 E.03506
G1 X136.05 Y117.95 E.02479
G1 X119.95 Y134.05 E.75525
G1 X120.698 Y134.05 E.02479
G1 X119.95 Y133.302 E.03506
G1 X119.95 Y126.374 E.22983
G1 X128.374 Y117.95 E.39516
G1 X127.626 Y117.95 E.02479
G1 X136.05 Y126.374 E.39516
G1 X136.05 Y125.626 E.02479
G1 X127.626 Y134.05 E.39516
G1 X128.374 Y134.05 E.02479
G1 X119.95 Y125.626 E.39516
G1 X119.95 Y118.698 E.22983
G1 X120.698 Y117.95 E.03506
G1 X119.95 Y117.95 E.02479
G1 X136.05 Y134.05 E.75525
M73 P91 R1
G1 X135.302 Y134.05 E.02479
G1 X136.05 Y133.302 E.03506
G1 X136.05 Y131.674 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X136.05 Y133.302 E-.61876
G1 X135.787 Y133.565 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/90
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
G17
G3 Z17 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3988
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3988
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y131.674 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3988
G1 X136.05 Y133.302 E.05401
G1 X135.302 Y134.05 E.03506
G1 X136.05 Y134.05 E.02479
G1 X119.95 Y117.95 E.75525
G1 X120.698 Y117.95 E.02479
G1 X119.95 Y118.698 E.03506
G1 X119.95 Y125.626 E.22983
G1 X128.374 Y134.05 E.39516
G1 X127.626 Y134.05 E.02479
G1 X136.05 Y125.626 E.39516
G1 X136.05 Y126.374 E.02479
G1 X127.626 Y117.95 E.39516
G1 X128.374 Y117.95 E.02479
G1 X119.95 Y126.374 E.39516
G1 X119.95 Y133.302 E.22983
G1 X120.698 Y134.05 E.03506
G1 X119.95 Y134.05 E.02479
G1 X136.05 Y117.95 E.75525
G1 X135.302 Y117.95 E.02479
G1 X136.05 Y118.698 E.03506
G1 X136.05 Y120.326 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X136.05 Y118.698 E-.61876
G1 X135.787 Y118.435 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/90
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
G17
G3 Z17.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5760
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5760
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
G1 F12000
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.044 Y133.673 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5760
G1 X135.673 Y133.673 E.05401
G1 X120.327 Y118.327 E.71987
G1 X127.997 Y118.327 E.2544
G1 X120.327 Y125.997 E.35977
G1 X127.997 Y133.673 E.35993
G1 X135.673 Y126.003 E.35993
G1 X128.003 Y118.327 E.35993
G1 X135.673 Y118.327 E.2544
G1 X120.327 Y133.673 E.71987
G1 X120.327 Y132.044 E.05401
G1 X136.008 Y117.992 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.399311
G1 F3000;_EXTRUDE_SET_SPEED
G1 X136.035 Y118.124 E.00391
G1 X136.035 Y133.876 E.45746
G1 X136.008 Y134.008 E.00391
G1 X135.876 Y134.035 E.00391
G1 X120.124 Y134.035 E.45746
G1 X119.992 Y134.008 E.00391
G1 X119.965 Y133.876 E.00391
M73 P92 R1
G1 X119.965 Y118.124 E.45746
G1 X119.992 Y117.992 E.00391
G1 X120.124 Y117.965 E.00391
G1 X135.876 Y117.965 E.45746
G1 X135.949 Y117.98 E.00217
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F3000
G1 X135.876 Y117.965 E-.02837
G1 X133.951 Y117.965 E-.73163
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/90
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.305 Y134.231 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40771
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X136.028 Y133.507 E.05443
G1 X136.028 Y132.86 E.03443
G1 X134.86 Y134.028 E.08789
G1 X134.213 Y134.028 E.03443
G1 X136.028 Y132.213 E.13658
G1 X136.028 Y131.565 E.03443
G1 X133.565 Y134.028 E.18527
G1 X132.918 Y134.028 E.03443
G1 X136.028 Y130.918 E.23397
G1 X136.028 Y130.271 E.03443
G1 X132.271 Y134.028 E.28266
G1 X131.623 Y134.028 E.03443
G1 X136.028 Y129.623 E.33136
G1 X136.028 Y128.976 E.03443
G1 X130.976 Y134.028 E.38005
G1 X130.329 Y134.028 E.03443
G1 X136.028 Y128.329 E.42874
G1 X136.028 Y127.681 E.03443
G1 X129.681 Y134.028 E.47744
G1 X129.034 Y134.028 E.03443
G1 X136.028 Y127.034 E.52613
G1 X136.028 Y126.387 E.03443
G1 X128.387 Y134.028 E.57482
G1 X127.74 Y134.028 E.03443
G1 X136.028 Y125.74 E.62352
G1 X136.028 Y125.092 E.03443
G1 X127.092 Y134.028 E.67221
G1 X126.445 Y134.028 E.03443
G1 X136.028 Y124.445 E.72091
G1 X136.028 Y123.798 E.03443
G1 X125.798 Y134.028 E.7696
G1 X125.15 Y134.028 E.03443
G1 X136.028 Y123.15 E.81829
G1 X136.028 Y122.503 E.03443
G1 X124.503 Y134.028 E.86699
G1 X123.856 Y134.028 E.03443
G1 X136.028 Y121.856 E.91568
G1 X136.028 Y121.208 E.03443
G1 X123.208 Y134.028 E.96437
G1 X122.561 Y134.028 E.03443
G1 X136.028 Y120.561 E1.01307
G1 X136.028 Y119.914 E.03443
G1 X121.914 Y134.028 E1.06176
G1 X121.267 Y134.028 E.03443
G1 X136.028 Y119.267 E1.11046
G1 X136.028 Y118.619 E.03443
G1 X120.619 Y134.028 E1.15915
G1 X119.972 Y134.028 E.03443
G1 X136.028 Y117.972 E1.20784
G1 X135.381 Y117.972 E.03442
G1 X119.972 Y133.381 E1.15918
G1 X119.972 Y132.734 E.03443
G1 X134.734 Y117.972 E1.11049
G1 X134.087 Y117.972 E.03443
G1 X119.972 Y132.087 E1.06179
G1 X119.972 Y131.439 E.03443
G1 X133.439 Y117.972 E1.0131
G1 X132.792 Y117.972 E.03443
G1 X119.972 Y130.792 E.96441
G1 X119.972 Y130.145 E.03443
G1 X132.145 Y117.972 E.91571
G1 X131.497 Y117.972 E.03443
G1 X119.972 Y129.497 E.86702
G1 X119.972 Y128.85 E.03443
G1 X130.85 Y117.972 E.81833
G1 X130.203 Y117.972 E.03443
G1 X119.972 Y128.203 E.76963
G1 X119.972 Y127.555 E.03443
G1 X129.555 Y117.972 E.72094
M73 P93 R1
G1 X128.908 Y117.972 E.03443
G1 X119.972 Y126.908 E.67224
G1 X119.972 Y126.261 E.03443
G1 X128.261 Y117.972 E.62355
G1 X127.614 Y117.972 E.03443
G1 X119.972 Y125.614 E.57486
G1 X119.972 Y124.966 E.03443
G1 X126.966 Y117.972 E.52616
G1 X126.319 Y117.972 E.03443
G1 X119.972 Y124.319 E.47747
G1 X119.972 Y123.672 E.03443
G1 X125.672 Y117.972 E.42878
G1 X125.024 Y117.972 E.03443
G1 X119.972 Y123.024 E.38008
G1 X119.972 Y122.377 E.03443
G1 X124.377 Y117.972 E.33139
G1 X123.73 Y117.972 E.03443
G1 X119.972 Y121.73 E.28269
G1 X119.972 Y121.082 E.03443
G1 X123.082 Y117.972 E.234
G1 X122.435 Y117.972 E.03443
G1 X119.972 Y120.435 E.18531
G1 X119.972 Y119.788 E.03443
G1 X121.788 Y117.972 E.13661
G1 X121.141 Y117.972 E.03443
G1 X119.972 Y119.141 E.08792
G1 X119.972 Y118.493 E.03443
G1 X120.696 Y117.769 E.05446
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3000
G1 X119.972 Y118.493 E-.38905
G1 X119.972 Y119.141 E-.24597
G1 X120.204 Y118.908 E-.12498
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/90
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
G17
G3 Z17.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13595
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z17.8 F30000
M73 P93 R0
G1 X136.234 Y118.54 Z17.8
G1 Z17.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13595
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
M73 P94 R0
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/90
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
G17
G3 Z17.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13299
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.46 Y134.234 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13299
G1 X136.065 Y133.63 E.02666
G1 X136.065 Y133.089 E.01688
G1 X135.089 Y134.065 E.04304
G1 X134.547 Y134.065 E.01688
G1 X136.065 Y132.547 E.06691
G1 X136.065 Y132.006 E.01688
G1 X134.006 Y134.065 E.09077
G1 X133.465 Y134.065 E.01688
G1 X136.065 Y131.465 E.11464
G1 X136.065 Y130.924 E.01688
G1 X132.924 Y134.065 E.13851
G1 X132.383 Y134.065 E.01688
G1 X136.065 Y130.383 E.16237
G1 X136.065 Y129.842 E.01688
G1 X131.842 Y134.065 E.18624
M73 P95 R0
G1 X131.3 Y134.065 E.01688
G1 X136.065 Y129.3 E.21011
G1 X136.065 Y128.759 E.01688
G1 X130.759 Y134.065 E.23397
G1 X130.218 Y134.065 E.01688
G1 X136.065 Y128.218 E.25784
G1 X136.065 Y127.677 E.01688
G1 X129.677 Y134.065 E.28171
G1 X129.136 Y134.065 E.01688
G1 X136.065 Y127.136 E.30557
G1 X136.065 Y126.594 E.01688
G1 X128.594 Y134.065 E.32944
G1 X128.053 Y134.065 E.01688
G1 X136.065 Y126.053 E.35331
G1 X136.065 Y125.512 E.01688
G1 X127.512 Y134.065 E.37717
G1 X126.971 Y134.065 E.01688
G1 X136.065 Y124.971 E.40104
G1 X136.065 Y124.43 E.01688
G1 X126.43 Y134.065 E.42491
G1 X125.888 Y134.065 E.01688
G1 X136.065 Y123.888 E.44877
G1 X136.065 Y123.347 E.01688
G1 X125.347 Y134.065 E.47264
G1 X124.806 Y134.065 E.01688
G1 X136.065 Y122.806 E.49651
G1 X136.065 Y122.265 E.01688
G1 X124.265 Y134.065 E.52037
G1 X123.724 Y134.065 E.01688
G1 X136.065 Y121.724 E.54424
G1 X136.065 Y121.182 E.01688
G1 X123.182 Y134.065 E.56811
G1 X122.641 Y134.065 E.01688
G1 X136.065 Y120.641 E.59197
G1 X136.065 Y120.1 E.01688
G1 X122.1 Y134.065 E.61584
G1 X121.559 Y134.065 E.01688
G1 X136.065 Y119.559 E.63971
G1 X136.065 Y119.018 E.01688
G1 X121.018 Y134.065 E.66357
G1 X120.477 Y134.065 E.01688
G1 X136.065 Y118.477 E.68744
G1 X136.065 Y117.935 E.01688
G1 X119.935 Y134.065 E.71131
G1 X119.935 Y133.523 E.01688
G1 X135.523 Y117.935 E.68744
G1 X134.982 Y117.935 E.01688
G1 X119.935 Y132.982 E.66358
G1 X119.935 Y132.441 E.01688
G1 X134.441 Y117.935 E.63971
G1 X133.9 Y117.935 E.01688
G1 X119.935 Y131.9 E.61584
G1 X119.935 Y131.359 E.01688
G1 X133.359 Y117.935 E.59198
G1 X132.818 Y117.935 E.01688
G1 X119.935 Y130.818 E.56811
G1 X119.935 Y130.276 E.01688
G1 X132.276 Y117.935 E.54424
G1 X131.735 Y117.935 E.01688
G1 X119.935 Y129.735 E.52038
G1 X119.935 Y129.194 E.01688
G1 X131.194 Y117.935 E.49651
G1 X130.653 Y117.935 E.01688
G1 X119.935 Y128.653 E.47264
G1 X119.935 Y128.112 E.01688
G1 X130.112 Y117.935 E.44878
G1 X129.57 Y117.935 E.01688
G1 X119.935 Y127.57 E.42491
G1 X119.935 Y127.029 E.01688
G1 X129.029 Y117.935 E.40104
G1 X128.488 Y117.935 E.01688
G1 X119.935 Y126.488 E.37718
G1 X119.935 Y125.947 E.01688
G1 X127.947 Y117.935 E.35331
G1 X127.406 Y117.935 E.01688
G1 X119.935 Y125.406 E.32944
G1 X119.935 Y124.864 E.01688
G1 X126.864 Y117.935 E.30558
G1 X126.323 Y117.935 E.01688
G1 X119.935 Y124.323 E.28171
G1 X119.935 Y123.782 E.01688
G1 X125.782 Y117.935 E.25784
G1 X125.241 Y117.935 E.01688
G1 X119.935 Y123.241 E.23398
G1 X119.935 Y122.7 E.01688
G1 X124.7 Y117.935 E.21011
G1 X124.158 Y117.935 E.01688
G1 X119.935 Y122.158 E.18624
G1 X119.935 Y121.617 E.01688
G1 X123.617 Y117.935 E.16238
G1 X123.076 Y117.935 E.01688
G1 X119.935 Y121.076 E.13851
G1 X119.935 Y120.535 E.01688
G1 X122.535 Y117.935 E.11464
G1 X121.994 Y117.935 E.01688
G1 X119.935 Y119.994 E.09078
G1 X119.935 Y119.453 E.01688
G1 X121.453 Y117.935 E.06691
G1 X120.911 Y117.935 E.01688
G1 X119.935 Y118.911 E.04304
G1 X119.935 Y118.37 E.01688
G1 X120.54 Y117.766 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X119.935 Y118.37 E-.32486
G1 X119.935 Y118.911 E-.20565
G1 X120.362 Y118.484 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/90
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
G17
G3 Z18 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.398 Y134.398
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13467
G1 X119.602 Y134.398 E.55715
G1 X119.602 Y117.602 E.55715
G1 X136.398 Y117.602 E.55715
G1 X136.398 Y134.338 E.55516
G1 X136.79 Y134.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
; WIPE_START
M204 S10000
G1 X134.79 Y134.737 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.468 Y127.135 Z18.2 F30000
G1 X136.234 Y118.54 Z18.2
G1 Z17.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F13467
G1 X135.63 Y117.935 E.02666
G1 X135.089 Y117.935 E.01688
G1 X136.065 Y118.911 E.04304
G1 X136.065 Y119.452 E.01688
G1 X134.547 Y117.935 E.06691
G1 X134.006 Y117.935 E.01688
G1 X136.065 Y119.994 E.09077
G1 X136.065 Y120.535 E.01688
G1 X133.465 Y117.935 E.11464
G1 X132.924 Y117.935 E.01688
G1 X136.065 Y121.076 E.13851
G1 X136.065 Y121.617 E.01688
G1 X132.383 Y117.935 E.16237
G1 X131.842 Y117.935 E.01688
G1 X136.065 Y122.158 E.18624
G1 X136.065 Y122.7 E.01688
G1 X131.3 Y117.935 E.21011
G1 X130.759 Y117.935 E.01688
G1 X136.065 Y123.241 E.23397
G1 X136.065 Y123.782 E.01688
G1 X130.218 Y117.935 E.25784
G1 X129.677 Y117.935 E.01688
G1 X136.065 Y124.323 E.28171
G1 X136.065 Y124.864 E.01688
G1 X129.136 Y117.935 E.30557
G1 X128.594 Y117.935 E.01688
G1 X136.065 Y125.406 E.32944
G1 X136.065 Y125.947 E.01688
G1 X128.053 Y117.935 E.35331
G1 X127.512 Y117.935 E.01688
G1 X136.065 Y126.488 E.37717
G1 X136.065 Y127.029 E.01688
G1 X126.971 Y117.935 E.40104
G1 X126.43 Y117.935 E.01688
G1 X136.065 Y127.57 E.42491
G1 X136.065 Y128.112 E.01688
G1 X125.888 Y117.935 E.44877
G1 X125.347 Y117.935 E.01688
G1 X136.065 Y128.653 E.47264
G1 X136.065 Y129.194 E.01688
G1 X124.806 Y117.935 E.49651
G1 X124.265 Y117.935 E.01688
G1 X136.065 Y129.735 E.52037
G1 X136.065 Y130.276 E.01688
G1 X123.724 Y117.935 E.54424
G1 X123.182 Y117.935 E.01688
G1 X136.065 Y130.818 E.56811
G1 X136.065 Y131.359 E.01688
G1 X122.641 Y117.935 E.59197
G1 X122.1 Y117.935 E.01688
G1 X136.065 Y131.9 E.61584
G1 X136.065 Y132.441 E.01688
G1 X121.559 Y117.935 E.63971
G1 X121.018 Y117.935 E.01688
G1 X136.065 Y132.982 E.66357
G1 X136.065 Y133.523 E.01688
G1 X120.477 Y117.935 E.68744
G1 X119.935 Y117.935 E.01688
G1 X136.065 Y134.065 E.71131
G1 X135.523 Y134.065 E.01688
G1 X119.935 Y118.476 E.68744
G1 X119.935 Y119.018 E.01688
G1 X134.982 Y134.065 E.66358
G1 X134.441 Y134.065 E.01688
G1 X119.935 Y119.559 E.63971
G1 X119.935 Y120.1 E.01688
G1 X133.9 Y134.065 E.61584
G1 X133.359 Y134.065 E.01688
G1 X119.935 Y120.641 E.59198
G1 X119.935 Y121.182 E.01688
G1 X132.818 Y134.065 E.56811
G1 X132.276 Y134.065 E.01688
G1 X119.935 Y121.724 E.54424
G1 X119.935 Y122.265 E.01688
G1 X131.735 Y134.065 E.52038
G1 X131.194 Y134.065 E.01688
G1 X119.935 Y122.806 E.49651
G1 X119.935 Y123.347 E.01688
G1 X130.653 Y134.065 E.47264
G1 X130.112 Y134.065 E.01688
M73 P96 R0
G1 X119.935 Y123.888 E.44878
G1 X119.935 Y124.43 E.01688
G1 X129.57 Y134.065 E.42491
G1 X129.029 Y134.065 E.01688
G1 X119.935 Y124.971 E.40104
G1 X119.935 Y125.512 E.01688
G1 X128.488 Y134.065 E.37718
G1 X127.947 Y134.065 E.01688
G1 X119.935 Y126.053 E.35331
G1 X119.935 Y126.594 E.01688
G1 X127.406 Y134.065 E.32944
G1 X126.864 Y134.065 E.01688
G1 X119.935 Y127.136 E.30558
G1 X119.935 Y127.677 E.01688
G1 X126.323 Y134.065 E.28171
G1 X125.782 Y134.065 E.01688
G1 X119.935 Y128.218 E.25784
G1 X119.935 Y128.759 E.01688
G1 X125.241 Y134.065 E.23398
G1 X124.7 Y134.065 E.01688
G1 X119.935 Y129.3 E.21011
G1 X119.935 Y129.842 E.01688
G1 X124.158 Y134.065 E.18624
G1 X123.617 Y134.065 E.01688
G1 X119.935 Y130.383 E.16238
G1 X119.935 Y130.924 E.01688
G1 X123.076 Y134.065 E.13851
G1 X122.535 Y134.065 E.01688
G1 X119.935 Y131.465 E.11464
G1 X119.935 Y132.006 E.01688
G1 X121.994 Y134.065 E.09078
G1 X121.453 Y134.065 E.01688
G1 X119.935 Y132.547 E.06691
G1 X119.935 Y133.089 E.01688
G1 X120.911 Y134.065 E.04304
G1 X120.37 Y134.065 E.01688
G1 X119.766 Y133.46 E.02666
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.37 Y134.065 E-.32486
G1 X120.911 Y134.065 E-.20565
G1 X120.484 Y133.638 E-.22948
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/90
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
G17
G3 Z18.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; OBJECT_ID: 69
G1 X136.79 Y134.79
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X119.21 Y134.79 E.54018
G1 X119.21 Y117.21 E.54018
G1 X136.79 Y117.21 E.54018
G1 X136.79 Y134.73 E.53834
M204 S10000
G1 X136.583 Y134.215 F30000
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X136.215 Y134.583 E.01598
G1 X135.682 Y134.583
G1 X136.583 Y133.682 E.03915
G1 X136.583 Y133.148
G1 X135.148 Y134.583 E.06232
G1 X134.615 Y134.583
G1 X136.583 Y132.615 E.0855
G1 X136.583 Y132.082
G1 X134.082 Y134.583 E.10867
G1 X133.549 Y134.583
G1 X136.583 Y131.549 E.13184
G1 X136.583 Y131.015
G1 X133.015 Y134.583 E.15501
G1 X132.482 Y134.583
G1 X136.583 Y130.482 E.17819
G1 X136.583 Y129.949
G1 X131.949 Y134.583 E.20136
G1 X131.416 Y134.583
G1 X136.583 Y129.416 E.22453
G1 X136.583 Y128.882
G1 X130.882 Y134.583 E.2477
G1 X130.349 Y134.583
G1 X136.583 Y128.349 E.27088
G1 X136.583 Y127.816
G1 X129.816 Y134.583 E.29405
G1 X129.283 Y134.583
G1 X136.583 Y127.283 E.31722
G1 X136.583 Y126.749
G1 X128.749 Y134.583 E.3404
G1 X128.216 Y134.583
G1 X136.583 Y126.216 E.36357
G1 X136.583 Y125.683
G1 X127.683 Y134.583 E.38674
G1 X127.15 Y134.583
G1 X136.583 Y125.15 E.40991
G1 X136.583 Y124.616
G1 X126.616 Y134.583 E.43309
G1 X126.083 Y134.583
G1 X136.583 Y124.083 E.45626
G1 X136.583 Y123.55
G1 X125.55 Y134.583 E.47943
G1 X125.017 Y134.583
G1 X136.583 Y123.017 E.5026
G1 X136.583 Y122.483
G1 X124.483 Y134.583 E.52578
G1 X123.95 Y134.583
G1 X136.583 Y121.95 E.54895
G1 X136.583 Y121.417
G1 X123.417 Y134.583 E.57212
G1 X122.883 Y134.583
G1 X136.583 Y120.883 E.59529
G1 X136.583 Y120.35
G1 X122.35 Y134.583 E.61847
G1 X121.817 Y134.583
G1 X136.583 Y119.817 E.64164
G1 X136.583 Y119.284
G1 X121.284 Y134.583 E.66481
G1 X120.75 Y134.583
G1 X136.583 Y118.75 E.68798
G1 X136.583 Y118.217
G1 X120.217 Y134.583 E.71116
G1 X119.684 Y134.583
G1 X136.583 Y117.684 E.73433
G1 X136.316 Y117.417
G1 X119.417 Y134.316 E.73432
G1 X119.417 Y133.783
G1 X135.783 Y117.417 E.71115
G1 X135.249 Y117.417
G1 X119.417 Y133.249 E.68798
G1 X119.417 Y132.716
G1 X134.716 Y117.417 E.66481
G1 X134.183 Y117.417
G1 X119.417 Y132.183 E.64163
M73 P97 R0
G1 X119.417 Y131.65
G1 X133.65 Y117.417 E.61846
G1 X133.116 Y117.417
G1 X119.417 Y131.116 E.59529
G1 X119.417 Y130.583
G1 X132.583 Y117.417 E.57212
G1 X132.05 Y117.417
G1 X119.417 Y130.05 E.54894
G1 X119.417 Y129.517
G1 X131.517 Y117.417 E.52577
G1 X130.983 Y117.417
G1 X119.417 Y128.983 E.5026
G1 X119.417 Y128.45
G1 X130.45 Y117.417 E.47943
G1 X129.917 Y117.417
G1 X119.417 Y127.917 E.45625
G1 X119.417 Y127.384
G1 X129.384 Y117.417 E.43308
G1 X128.85 Y117.417
G1 X119.417 Y126.85 E.40991
G1 X119.417 Y126.317
G1 X128.317 Y117.417 E.38674
G1 X127.784 Y117.417
G1 X119.417 Y125.784 E.36356
G1 X119.417 Y125.251
G1 X127.251 Y117.417 E.34039
G1 X126.717 Y117.417
G1 X119.417 Y124.717 E.31722
G1 X119.417 Y124.184
G1 X126.184 Y117.417 E.29404
G1 X125.651 Y117.417
G1 X119.417 Y123.651 E.27087
G1 X119.417 Y123.118
G1 X125.118 Y117.417 E.2477
G1 X124.584 Y117.417
G1 X119.417 Y122.584 E.22453
G1 X119.417 Y122.051
G1 X124.051 Y117.417 E.20135
G1 X123.518 Y117.417
G1 X119.417 Y121.518 E.17818
G1 X119.417 Y120.984
G1 X122.984 Y117.417 E.15501
G1 X122.451 Y117.417
G1 X119.417 Y120.451 E.13184
G1 X119.417 Y119.918
G1 X121.918 Y117.417 E.10866
G1 X121.385 Y117.417
G1 X119.417 Y119.385 E.08549
G1 X119.417 Y118.851
G1 X120.851 Y117.417 E.06232
G1 X120.318 Y117.417
G1 X119.417 Y118.318 E.03915
G1 X119.417 Y117.785
G1 X119.785 Y117.417 E.01597
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S10000
G1 X119.417 Y117.785 E-.19754
G1 X119.417 Y118.318 E-.20264
G1 X120.087 Y117.649 E-.35982
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z18.5 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S

M17 R ; restore z current
;<<< INSERT:cooldown_fans_wait START
; ====== Cool Down =====
M106 P2 S255        ;turn Aux fan on
M106 P3 S200        ;turn on chamber cooling fan
M400
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
M190 S18 ; wait for bed temp
; total max wait time of all lines = 40 min
M106 P2 S0         ;turn off Aux fan
M106 P3 S0         ;turn off chamber cooling fan
M400
;>>> Cooldown_fans_wait END
;<<< INSERT:raise_bed_after_cooldown START
;=== Raise Bed Level (after cooldown) ===
M400
G1 Z1 F600
M400 P100
;>>> INSERT:raise_bed_after_cooldown END
;<<< INSERT:push_off_sequence START
G1 X120.00 Y254 F2000
G1 X120.00 Y5 F300
G1 X120.00 Y254 F2000
;--- PUSH_OFF at Z=9 mm ---
G1 Z9 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;--- PUSH_OFF at Z=1 mm ---
G1 Z1 F600
G1 X192 Y254 F2000
G1 X192 Y5   F1000
G1 X192 Y254 F2000
G1 X142 Y254 F2000
G1 X142 Y5   F1000
G1 X142 Y254 F2000
G1 X92 Y254 F2000
G1 X92 Y5   F1000
G1 X92 Y254 F2000
G1 X42 Y254 F2000
G1 X42 Y5   F1000
G1 X42 Y254 F2000
;>>> INSERT:push_off_sequence END
;>>> INSERT:cooldown_fans_wait END

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
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp
M73 P100 R0
; EXECUTABLE_BLOCK_END

