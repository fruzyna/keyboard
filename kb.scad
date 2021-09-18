// pcb dimensions
pcb_width     = 110.5;
pcb_height    =  91.5;
pcb_depth     =   1.6;
pcb_margin    =   0.625;

// layer dimensions
layer_depth   =   2.5;
border_width  =  10.0;

// switch plate dimensions
columns       =   6.0;
rows          =   5.0;
switch_width  =  14.0;
switch_depth  =   5.0;
switch_gap    =   5.05;

grid_width = columns * (switch_width + switch_gap) - switch_gap;
grid_height = rows * (switch_width + switch_gap) - switch_gap;
    
// elevations
pcb_elevation   = 5.0;
plate_elevation = pcb_elevation + pcb_depth + switch_depth - layer_depth;

module pcb() {
    translate([border_width - pcb_margin, border_width - pcb_margin, pcb_elevation])
        color("green")
        cube([pcb_width, pcb_height, pcb_depth]);
}

module base_plate() {
    color("silver")
        cube([pcb_width + border_width * 2, pcb_height + border_width * 2, layer_depth]);
}

module key_switch(x, y) {
    x_trans = border_width + x * (switch_width + switch_gap);
    y_trans = border_width + y * (switch_width + switch_gap);
    // base
    translate([x_trans, y_trans, pcb_elevation + pcb_depth])
        color("white")
        cube([switch_width, switch_width, switch_depth]);
    // top
    translate([x_trans - 0.8, y_trans - 0.8, pcb_elevation + pcb_depth + switch_depth])
        color("lightgray")
        cube([15.6, 15.6, 6.6]);
    // plunger
    translate([x_trans + 5.2, y_trans + 5.2, pcb_elevation + pcb_depth + switch_depth + 6.6])
        color("brown")
        cube([3.6, 3.6, 3.6]);
}

module key_plate() {
    grid_width = columns * (switch_width + switch_gap) - switch_gap;
    grid_height = rows * (switch_width + switch_gap) - switch_gap;
    beam_width = grid_width + border_width * 2;
    beam_height = grid_height;
    // south border
    translate([0, 0, plate_elevation])
        color("gray")
        cube([beam_width, border_width, layer_depth]);
    // north border
    translate([0, border_width + beam_height, plate_elevation])
        color("gray")
        cube([beam_width, border_width, layer_depth]);
    // east border
    translate([0, border_width, plate_elevation])
        color("gray")
        cube([border_width, beam_height, layer_depth]);
    // west border
    translate([beam_width - border_width, border_width, plate_elevation])
        color("gray")
        cube([border_width, beam_height, layer_depth]);

    // columns
    for (column=[1:1:columns-1]) {
        translate([column * (switch_width + switch_gap) + border_width - switch_gap, border_width, plate_elevation])
            color("gray")
            cube([switch_gap, grid_height, layer_depth]);
    }

    // rows
    for (row=[1:1:rows-1]) {
        translate([border_width, row * (switch_width + switch_gap) + border_width - switch_gap, plate_elevation])
            color("gray")
            cube([grid_width, switch_gap, layer_depth]);
    }
}

base_plate();
pcb();
key_plate();

for (column=[0:1:columns-1]) {
    for (row=[0:1:rows-1]) {
        key_switch(column, row);
    }
}