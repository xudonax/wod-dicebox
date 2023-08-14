#!/usr/bin/env bash

filename="${1%.*}"

if [ -f "$filename.bmp" ]; then
    echo "Tracing \"$filename.bmp\" to SVG..."
    potrace -s --opaque --flat "$filename.bmp"
    echo "Converting traced file to DXF..."
    python3 /usr/share/inkscape/extensions/dxf12_outlines.py --output="$filename.dxf" "$filename.svg"
    echo "DXF is available at \"$filename.dxf\""
    exit
else
    echo "Could not find a BMP file at \"$filename.bmp\""
    exit -1
fi