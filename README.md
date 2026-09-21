# SVG to STL examples

*Unofficial community examples for SVG to STL conversion. Not affiliated with svg2stl.com, Meshy or ImageToStl. All trademarks belong to their owners.*

Small, local scripts for svg to stl conversion. The web converters that rank for the query (svg2stl.com, the Meshy converter and ImageToStl) do not expose an API on the pages crawled for this repo, so these examples cover the part you can automate on your own machine: checking an SVG before uploading it, and extruding it locally with OpenSCAD, which is the SCAD step svg2stl.com describes in its own pipeline (SVG to EPS to DXF to SCAD to STL).

> Have a picture instead of a vector? [Try Supavoxel - image to 3D in the browser](https://supavoxel.com?utm_source=github&utm_medium=ugc&utm_campaign=svg-to-stl-examples&utm_content=readme-top&utm_term=tier-r) gives you an STL or GLB mesh without any of the steps below.

## Files

| Path | What it shows |
| --- | --- |
| `examples/check_svg.py` | Lists the element types in an SVG and warns about live text, embedded images and stroke-only paths, the usual reasons an extruded STL comes back empty. |
| `examples/extrude.scad` | OpenSCAD file that imports an SVG and runs `linear_extrude` on it, with an optional backing plate. |
| `examples/batch_extrude.sh` | Loops over a folder of SVGs and renders each one to STL with the OpenSCAD CLI. |

## Setup

- Python 3 for `check_svg.py` (standard library only).
- OpenSCAD installed and on your `PATH` for `extrude.scad` and `batch_extrude.sh`.
- No API keys or environment variables are needed; nothing here calls a web service.

## check_svg.py

Run it on a file before you upload it anywhere:

```
python3 examples/check_svg.py logo.svg
```

It prints a count of each element type and a short list of warnings. Live text elements should be converted to outlines in your vector editor first; embedded raster images are ignored by extrusion; paths with `fill="none"` have no area to extrude. svg2stl.com says it cleans unnecessary tags on upload, but knowing what is in the file before you send it saves a round trip.

## extrude.scad

The whole conversion is two OpenSCAD calls: `import()` the SVG, then `linear_extrude()` it to a height. Render from the command line:

```
openscad -o logo.stl -D 'file="logo.svg"' -D height=3 extrude.scad
```

Set `base` to a positive number to add a backing plate under the artwork. The plate size is set explicitly in the file because OpenSCAD does not expose the imported shape's bounding box; adjust `plate_w` and `plate_h` to your artwork.

## batch_extrude.sh

```
bash examples/batch_extrude.sh ./svgs ./stl 3
```

Converts every `.svg` in `./svgs` to `./stl/name.stl` at 3 mm. The Meshy converter marks batch mode as PRO and svg2stl.com is one upload at a time, so this is the route when you have a folder of files.

## When to use Supavoxel instead

Everything in this repo, and every converter it mentions, produces a flat extrusion: the outline of the SVG pushed up into a slab. That is the right output for stencils, badges and lettering. When the input is a photograph, a product render or a character drawing and you want a model with real depth, extrusion cannot get there. [Try Supavoxel - image to 3D, STL/GLB in the browser, no CAD](https://supavoxel.com?utm_source=github&utm_medium=ugc&utm_campaign=svg-to-stl-examples&utm_content=readme-top&utm_term=tier-r): upload the picture, download the mesh, and slice it like any STL these scripts produce.
