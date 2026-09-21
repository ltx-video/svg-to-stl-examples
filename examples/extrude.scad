// Extrude an SVG into a solid with OpenSCAD.
//
// svg2stl.com describes its pipeline as SVG -> EPS -> DXF -> SCAD -> STL.
// This file is the SCAD step done by hand so you can run it locally.
//
// Render from the command line:
//   openscad -o logo.stl -D 'file="logo.svg"' -D height=3 extrude.scad

file = "input.svg";   // path to the SVG, relative to this file
height = 3;           // extrusion height in mm
base = 0;             // backing plate thickness in mm (0 = no plate)
base_margin = 2;      // how far the plate extends past the artwork

// OpenSCAD does not expose the imported shape's bounding box,
// so the plate size is set explicitly. Illustrative values in mm.
plate_w = 60 + 2 * base_margin;
plate_h = 40 + 2 * base_margin;

module artwork() {
    linear_extrude(height = height)
        import(file, center = true);
}

module plate() {
    translate([-plate_w / 2, -plate_h / 2, -base])
        cube([plate_w, plate_h, base]);
}

union() {
    artwork();
    if (base > 0) plate();
}
