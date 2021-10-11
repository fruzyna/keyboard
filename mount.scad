// pcb dimensions
pcb_width     = 110.5;
pcb_height    =  91.5;
pcb_depth     =   1.6;
pcb_margin    =   0.625;

// layer dimensions
layer_depth   =   2.5;
border_width  =   5.0;
layers        =   3.0;

post_extra     =  1.5;
vpillar_width  =  6.5;
vpillar_height = 63;
hpillar_width  = pcb_width - pcb_margin * 2;
hpillar_height =  5.5;

// elevations
back_height    = 10;
front_height   = 3;
pcb_elevation  = back_height + layer_depth;


plate    = false;
pcb      = false;

$fs = 0.5;

module screw_holes(depth, radius, elevation) {
    translate([border_width - pcb_margin + 17.14, border_width - pcb_margin + 19.82, elevation])
        cylinder(h=depth, r=radius);
    translate([border_width - pcb_margin + 17.14, border_width - pcb_margin + pcb_height - 24.33, elevation])
        cylinder(h=depth, r=radius);
    translate([border_width - pcb_margin + pcb_width - 17.14, border_width - pcb_margin + 19.82, elevation])
        cylinder(h=depth, r=radius);
    translate([border_width - pcb_margin + pcb_width - 17.14, border_width - pcb_margin + pcb_height - 24.33, elevation])
        cylinder(h=depth, r=radius);
}

module pcb() {
    difference() {
        // pcb
        translate([border_width - pcb_margin, border_width - pcb_margin, pcb_elevation])
            color("green")
            cube([pcb_width, pcb_height, pcb_depth]);
        
        // holes
        screw_holes(pcb_depth, 7.05/2, pcb_elevation);
    }
}

module base_plate() {
    difference() {
        color("silver")
            cube([pcb_width + (border_width - pcb_margin) * 2, pcb_height + (border_width - pcb_margin) * 2, layer_depth]);
        
        screw_holes(layer_depth, 2, 0);
    }
}

module mount() {
    screw_holes(back_height + pcb_depth + post_extra, 7.05/2, layer_depth);

    translate([border_width - pcb_margin + 14, 
        border_width - pcb_margin + 14, layer_depth])
        cube([vpillar_width, vpillar_height, back_height]);

    translate([border_width - pcb_margin + 90.2, 
        border_width - pcb_margin + 14, layer_depth])
        cube([vpillar_width, vpillar_height, back_height]);

    translate([border_width, 
        border_width - pcb_margin + 19, layer_depth])
        cube([hpillar_width, hpillar_height, back_height]);

    translate([border_width, 
        border_width - pcb_margin + 38, layer_depth])
        cube([hpillar_width, hpillar_height, back_height]);
}

module wedge() {
    translate([hpillar_width + border_width, vpillar_height + border_width - pcb_margin + 14, layer_depth])
    rotate([0, 0, 180])
    polyhedron(
           points=[[0,0,0], [hpillar_width,0,0], [hpillar_width,vpillar_height,0], [0,vpillar_height,0], [0,vpillar_height, back_height-front_height], [hpillar_width,vpillar_height, back_height-front_height]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

difference() {
    mount();
    wedge();
}


if (plate) {
    base_plate();
}
if (pcb) {
    pcb();
}
