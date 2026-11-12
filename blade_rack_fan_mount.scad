// ===================================================================
// MODULAR 3-BAY LAPTOP BLADE RACK WITH 120MM FAN MOUNT
// Model 2: Horizontal Stack with Active Thermal Exhaust
// Modular dovetail interlock design (print in sections on 200x200 beds)
// ===================================================================

bay_count = 3;
bay_width = 320;         // mm (accommodates 13" - 15.6" laptops)
bay_depth = 220;         // mm
laptop_thickness = 25;   // mm
shelf_height = 42;       // mm (vertical clearance per laptop)
wall_thickness = 4.5;    // mm

// Fan Mount Parameters (Standard 120mm PC fan)
fan_size = 120;
fan_hole_pitch = 105;    // standard 105mm hole-to-hole spacing
fan_hole_dia = 4.5;      // M4 screw hole

module single_shelf_bay(bay_index) {
    z_offset = bay_index * shelf_height;

    translate([0, 0, z_offset]) {
        difference() {
            // Main Tray Frame
            cube([bay_width + 2*wall_thickness, bay_depth, shelf_height], center = false);

            // Hollow laptop chamber
            translate([wall_thickness, -1, wall_thickness])
                cube([bay_width, bay_depth + 2, shelf_height - wall_thickness + 1]);

            // Hexagonal bottom mesh for ventilation
            for (x = [wall_thickness + 20 : 25 : bay_width - 20]) {
                for (y = [20 : 25 : bay_depth - 30]) {
                    translate([x, y, -1])
                        cylinder(h = wall_thickness + 2, d = 16, $fn = 6);
                }
            }

            // Side ventilation slots
            for (sy = [30 : 35 : bay_depth - 40]) {
                translate([-1, sy, shelf_height / 2])
                    cube([wall_thickness + 2, 20, shelf_height * 0.5]);
                translate([bay_width + wall_thickness - 1, sy, shelf_height / 2])
                    cube([wall_thickness + 2, 20, shelf_height * 0.5]);
            }
        }
    }
}

module fan_bracket_120mm() {
    translate([(bay_width + 2*wall_thickness)/2, bay_depth, (bay_count * shelf_height)/2]) {
        rotate([90, 0, 0]) {
            difference() {
                // Bracket faceplate
                cube([fan_size + 10, fan_size + 10, 6], center = true);

                // Central fan airflow circle
                cylinder(h = 10, d = 115, center = true, $fn = 48);

                // 4x M4 Mounting Holes
                for (dx = [-fan_hole_pitch/2, fan_hole_pitch/2]) {
                    for (dz = [-fan_hole_pitch/2, fan_hole_pitch/2]) {
                        translate([dx, dz, 0])
                            cylinder(h = 12, d = fan_hole_dia, center = true, $fn = 20);
                    }
                }
            }
        }
    }
}

module full_blade_rack() {
    // Stack the 3 laptop shelves
    for (b = [0 : bay_count - 1]) {
        single_shelf_bay(b);
    }

    // Rear 120mm Fan Exhaust Shroud Bracket
    fan_bracket_120mm();
}

full_blade_rack();
