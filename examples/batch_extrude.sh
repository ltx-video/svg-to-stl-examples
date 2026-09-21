#!/usr/bin/env bash
# Convert every SVG in a folder to STL with OpenSCAD and extrude.scad.
#
# Usage: bash examples/batch_extrude.sh INPUT_DIR OUTPUT_DIR [HEIGHT_MM]
#
# Requires the openscad binary on PATH. Nothing is uploaded anywhere.
set -euo pipefail

in_dir="${1:?input dir}"
out_dir="${2:?output dir}"
height="${3:-3}"
scad="$(dirname "$0")/extrude.scad"

mkdir -p "$out_dir"

count=0
for svg in "$in_dir"/*.svg; do
  if [ ! -e "$svg" ]; then
    echo "no .svg files in $in_dir" >&2
    exit 1
  fi
  name="$(basename "${svg%.svg}")"
  echo "extruding $name.svg -> $name.stl (height ${height} mm)"
  openscad -o "$out_dir/$name.stl" -D "file=\"$svg\"" -D "height=$height" "$scad"
  count=$((count + 1))
done

echo "done: $count STL file(s) written to $out_dir"
