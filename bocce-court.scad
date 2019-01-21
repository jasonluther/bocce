/* by Jason Luther */

FOOT = 304.8;
INCH = 25.4;
CUBIC_YARD = 764554858;
BOARD_FOOT = FOOT * FOOT * INCH;

width = 12 * FOOT;
length = 56 * FOOT;

primary_surface_depth = 4 * INCH;
oyster_shell_depth = 1/2 * INCH; 
leveling_layer_depth = 0 * INCH;
weed_barrier_depth = 1/8 * INCH;
drainage_layer_depth = 4 * INCH;
drainage_layer_border =  12 * INCH;

drainage_layer_above = 0;
weed_barrier_above = drainage_layer_depth + drainage_layer_above;
leveling_layer_above = weed_barrier_depth + weed_barrier_above;
oyster_shell_above = leveling_layer_depth + leveling_layer_above;
primary_surface_above = oyster_shell_depth + oyster_shell_above;

module court_cube(depth, height, name) {
  echo(
    name, width / FOOT, "ft x ", length / FOOT, "ft x ",
    depth / INCH, "in = ", width * length * depth / CUBIC_YARD, "cu. yd."
  );

  translate([0, 0, height])
    cube([width, length, depth]);
}

module primary_surface() {
  color("WhiteSmoke")
    court_cube(primary_surface_depth, primary_surface_above, "Primary Surface");
}

module oyster_shell() {
  color("Gainsboro")
    court_cube(oyster_shell_depth, oyster_shell_above, "Oyster Shell");
}

module leveling_layer() {
  color("Tan")
    court_cube(leveling_layer_depth, leveling_layer_above, "Leveling Layer");
}

module weed_barrier() {
  color("Black")
    court_cube(weed_barrier_depth, weed_barrier_above, "Weed Barrier");
}

module drainage_layer() {
  drainage_layer_width = width + 2 * drainage_layer_border;
  drainage_layer_length = length + 2 * drainage_layer_border;
  drainage_layer_volume = drainage_layer_length * drainage_layer_width * drainage_layer_depth;
  echo(
  	"Drainage layer: ", drainage_layer_width / FOOT, "ft x ", drainage_layer_length / FOOT, "ft x ",
    drainage_layer_depth / INCH, "in = ", drainage_layer_volume / CUBIC_YARD, "cu. yd."
  );

  color("SlateGray")
    translate([-drainage_layer_border, -drainage_layer_border, drainage_layer_above])
      cube([width + 2 * drainage_layer_border, length + 2 * drainage_layer_border, drainage_layer_depth]);
}

module court_layers() {
primary_surface();
oyster_shell();
leveling_layer();
weed_barrier();
drainage_layer();
}

module cross_section() {
  translate([-1 * width, -2 * FOOT - 1, -1 * FOOT])
      cube([1.2 * width, 6 * FOOT, 4 * FOOT]);

}
difference() {
  union() {
    court_layers();
    border();
  };
  //cross_section();
}

module board(w, h, l, name) {
  echo(
    name, w / INCH, "in x ", h / INCH, "in x ",
    l / INCH, "in = ", (w * h * l) / BOARD_FOOT, "board feet"
  );

  color("Peru")
    cube([w, l, h]);
}

border_width = 5.5 * INCH;
border_height = 11 * INCH;
border_grade = 1 * INCH;

module border() {
translate([-border_width - 2, -border_width, border_grade])
  board(border_width, border_height, length + 2 * border_width, "Side Frame");
translate([width + 2, -border_width,  border_grade])
  board(border_width, border_height, length + 2 * border_width, "Side Frame");
translate([0, -border_width,  border_grade])
  board(width, border_height, border_width, "End Frame");
translate([0, length,  border_grade])
  board(width, border_height, border_width, "End Frame");

bf_sides = 2 * (length + 2 * border_width) * border_height * border_width / BOARD_FOOT;
bf_ends = 2 * (width) * border_height * border_width / BOARD_FOOT;
bf_total = bf_sides + bf_ends;
echo("Border board feet: ", bf_total, "board feet");
linear = 4 * (length + 2 * border_width) + 4 * (width);
lf = linear / FOOT;
echo("Linear feet with 2 courses: ", lf, "linear feet");
}

