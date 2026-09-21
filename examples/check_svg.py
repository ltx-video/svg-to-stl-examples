#!/usr/bin/env python3
"""List what an SVG contains before sending it to an svg to stl converter.

Extrusion needs filled regions. Live text, embedded raster images and
stroke-only paths are the usual reasons a converted STL comes back empty
or missing pieces, so this script flags them.

Usage: python3 examples/check_svg.py logo.svg
"""
import sys
import xml.etree.ElementTree as ET
from collections import Counter


def local(tag):
    # strip the XML namespace so counts read as plain element names
    return tag.split("}", 1)[1] if "}" in tag else tag


def main(path):
    root = ET.parse(path).getroot()
    elements = list(root.iter())
    tags = Counter(local(el.tag) for el in elements)

    print(f"{path}: {len(elements)} elements")
    for tag, n in sorted(tags.items()):
        print(f"  {tag:12} {n}")

    warnings = []
    if tags.get("text"):
        warnings.append("live text elements: convert text to outlines before converting")
    if tags.get("image"):
        warnings.append("embedded raster images: extrusion ignores them")

    stroke_only = 0
    for el in elements:
        if local(el.tag) in ("path", "polygon", "circle", "rect", "ellipse"):
            fill = el.get("fill", "")
            style = el.get("style", "")
            if fill == "none" or "fill:none" in style.replace(" ", ""):
                stroke_only += 1
    if stroke_only:
        warnings.append(f"{stroke_only} shape(s) with fill=none: no area to extrude")

    if not (root.get("viewBox") or (root.get("width") and root.get("height"))):
        warnings.append("no viewBox or width/height: check the scale in your slicer")

    print("warnings:" if warnings else "warnings: none")
    for w in warnings:
        print(f"  - {w}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("usage: check_svg.py FILE.svg")
    main(sys.argv[1])
