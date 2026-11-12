// ===================================================================
// TRIPLE LAPTOP VERTICAL SERVER STAND (PARAMETRIC OPENSCAD PROTOTYPE)
// Model 1: "Toaster" Style Desk Cluster Stand
// Optimized for FDM 3D Printing (PETG / PLA+ recommended)
// ===================================================================

/* [Laptop Dimensions] */
slot_count = 3;                  // Number of laptop bays
slot_width = 24;                 // Thickness of each laptop in mm (adjust for your models)
laptop_height_support = 70;      // Height of vertical support fins in mm
stand_depth = 180;               // Front-to-back depth of stand in mm

/* [Chassis Parameters] */
wall_thick = 4.0;                // Structural wall thickness in mm
air_gap = 25.0;                  // Cooling chimney gap between laptops in mm
base_height = 14.0;              // Base platform elevation for airflow & cables
fillet_r = 3.0;                  // Corner rounding

/* [Vents & Cable Routing] */
vent_slot_width = 6.0;           // Width of ventilation cutouts
cable_channel_h = 8.0;           // Height of bottom cable channels
cable_channel_w = 20.0;          // Width of bottom cable channels

// Calculated Dimensions
total_width = (slot_count * slot_width) + ((slot_count + 1) * air_gap) + (2 * wall_thick);

module rounded_rect(w, d, h, r) {
    linear_extrude(height = h) {
        offset(r = r) {
            square([w - 2*r, d - 2*r], center = true);
        }
    }
}

module vertical_stand() {
    difference() {
        union() {
            // Main solid base block
            translate([0, 0, base_height / 2])
                rounded_rect(total_width, stand_depth, base_height, fillet_r);

            // Vertical Support Fins / Dividers
            for (i = [0 : slot_count]) {
                offset_x = -total_width/2 + wall_thick + air_gap/2 + i * (slot_width + air_gap);
                translate([offset_x, 0, (laptop_height_support + base_height) / 2]) {
                    // Tapered fin for easy laptop insertion
                    hull() {
                        cube([wall_thick, stand_depth - 10, laptop_height_support], center = true);
                        translate([0, 0, laptop_height_support/2 - 5])
                            cube([wall_thick * 0.6, stand_depth - 30, 2], center = true);
                    }
                }
            }
        }

        // Subtractive Laptop Slots
        for (i = [0 : slot_count - 1]) {
            slot_center_x = -total_width/2 + wall_thick + air_gap + slot_width/2 + i * (slot_width + air_gap);

            // Laptop slot opening
            translate([slot_center_x, 0, base_height + laptop_height_support/2 + 0.1])
                cube([slot_width, stand_depth + 2, laptop_height_support + 1], center = true);

            // Chimney Air Vents at bottom of each slot
            for (v = [-stand_depth/2 + 25 : 20 : stand_depth/2 - 25]) {
                translate([slot_center_x, v, base_height / 2])
                    cube([slot_width * 0.7, vent_slot_width, base_height + 4], center = true);
            }
        }

        // Transverse Cable Routing Tunnels (Underneath)
        translate([0, 0, cable_channel_h / 2 - 0.1]) {
            translate([0, -stand_depth * 0.25, 0])
                cube([total_width + 4, cable_channel_w, cable_channel_h], center = true);
            translate([0, stand_depth * 0.25, 0])
                cube([total_width + 4, cable_channel_w, cable_channel_h], center = true);
        }

        // Zip-tie Anchor Holes
        for (i = [-1, 1]) {
            translate([total_width/2 - 8, i * 40, base_height/2])
                cube([4, 10, base_height + 2], center = true);
            translate([-total_width/2 + 8, i * 40, base_height/2])
                cube([4, 10, base_height + 2], center = true);
        }
    }
}

// Render the 3D model
vertical_stand();
