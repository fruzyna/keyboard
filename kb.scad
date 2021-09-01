// pcb dimensions
pcb_width    = 110.5;
pcb_height   =  91.5;
pcb_depth    =   1.6;

// layer dimensions
layer_depth  =   2.5;
border_width =  10.0;
column_width =   2.0;
layers       =   5.0;
columns      =   6.0;
rows         =   5.0;

// pcb
translate([0, 0, layer_depth * (layers - 1.5) - pcb_depth / 2])
    color("green")
    cube([pcb_width, pcb_height, pcb_depth], center=true);

// baseplate
color("silver")
    cube([pcb_width + border_width * 2, pcb_height + border_width * 2, layer_depth], center=true);

// stacked layers
trans = 0.2;
for (layer=[1:1:layers]) {
    color = 0.675 - 0.05 * layer;
    translate([0, (pcb_height + border_width) / 2, layer * layer_depth])
        color([color, color, color], trans)
        cube([pcb_width + border_width * 2, border_width, layer_depth], center=true);
    translate([0, -(pcb_height + border_width) / 2, layer * layer_depth])
        color([color, color, color], trans)
        cube([pcb_width + border_width * 2, border_width, layer_depth], center=true);
    translate([(pcb_width + border_width * 1) / 2, 0, layer * layer_depth])
        color([color, color, color], trans)
        cube([border_width, pcb_height, layer_depth], center=true);
    translate([-(pcb_width + border_width * 1) / 2, 0, layer * layer_depth])
        color([color, color, color], trans)
        cube([border_width, pcb_height, layer_depth], center=true);
}

// key columns
color = 0.675 - 0.05 * layers;
for (column=[1:1:columns-1]) {
    translate([-pcb_width / 2 + (column * pcb_width) / columns, 0, layers * layer_depth])
        color([color, color, color], trans)
        cube([column_width, pcb_height, layer_depth], center=true);
}

// key rows
for (row=[1:1:rows-1]) {
    translate([0, -pcb_height / 2 + (row * pcb_height) / rows, layers * layer_depth])
        color([color, color, color], trans)
        cube([pcb_width, column_width, layer_depth], center=true);
}