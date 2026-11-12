// ===================================================================
// UNIVERSAL UNDER-DESK & WALL CLUSTER MOUNT BRACKETS
// Model 3: Space-Saving Modular Brackets (Print 3 pairs)
// Fits all standard 3D printer beds (100 x 60 x 50 mm)
// ===================================================================

laptop_thickness_max = 24.0;  // mm (thickness of laptop when closed)
bracket_depth = 50.0;         // mm
wall_thick = 5.0;             // mm (rigid structural perimeters)
lip_height = 20.0;            // mm retention lip to prevent slipping
screw_hole_dia = 4.5;         // M4 wood screw / drywall anchor
countersink_dia = 9.0;

module screw_hole() {
    cylinder(h = wall_thick + 2, d = screw_hole_dia, $fn = 20);
    translate([0, 0, wall_thick - 2])
        cylinder(h = 2.5, d1 = screw_hole_dia, d2 = countersink_dia, $fn = 20);
}

module laptop_bracket() {
    difference() {
        // Outer L-bracket profile
        linear_extrude(height = bracket_depth) {
            polygon(points = [
                [0, 0],
                [laptop_thickness_max + 2*wall_thick + 5, 0],
                [laptop_thickness_max + 2*wall_thick + 5, wall_thick + lip_height],
                [laptop_thickness_max + wall_thick + 5, wall_thick + lip_height],
                [laptop_thickness_max + wall_thick + 5, wall_thick],
                [wall_thick, wall_thick],
                [wall_thick, 55],
                [0, 55]
            ]);
        }

        // Mounting Screw Holes on top flange
        translate([wall_thick / 2, 40, bracket_depth * 0.25])
            rotate([0, 90, 0]) screw_hole();

        translate([wall_thick / 2, 40, bracket_depth * 0.75])
            rotate([0, 90, 0]) screw_hole();

        // Ventilation Cutouts in bottom ledge
        translate([wall_thick + 8, -1, bracket_depth/2])
            cube([laptop_thickness_max * 0.6, wall_thick + 2, bracket_depth * 0.6], center = true);

        // Cable drop notch
        translate([wall_thick + 4, wall_thick/2, -1])
            cylinder(h = bracket_depth + 2, d = 6, $fn = 16);
    }
}

// Single bracket preview (print 2 per laptop, 6 total for 3 laptops)
laptop_bracket();
