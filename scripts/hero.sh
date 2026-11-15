#!/bin/zsh
# The hero's pictures, from the zoom views of the robot's render script. See "The hero" in README.md.
#   scripts/hero.sh <prefix>    reads <prefix>_zoom.json and <prefix>_zoom_<name>.png, as shade.py wrote them
# Each picture fades out over its last 6 % on every side: a closer one into the wider one under it, the
# widest into the page, where its floor shadow would otherwise end on a line.
set -e
prefix=$1
out=${0:A:h:h}/src/assets/hero
cp ${prefix}_zoom.json $out/zoom.json
for name in $(sed -n 's/.*"name": *"\([a-z]*\)".*/\1/p' $out/zoom.json); do
  in=${prefix}_zoom_$name.png
  size=($(magick identify -format '%w %h' $in))
  fade=$(( (size[1] > size[2] ? size[1] : size[2]) * 6 / 100 ))
  # the picture's own transparency times a white box, blurred, that stops half the fade short of the edges
  magick $in \
    \( +clone -alpha extract \) \
    \( -size ${size[1]}x${size[2]} xc:black -fill white \
       -draw "rectangle $((fade / 2)),$((fade / 2)) $((size[1] - 1 - fade / 2)),$((size[2] - 1 - fade / 2))" -blur 0x$((fade / 6)) \) \
    \( -clone 1,2 -compose Multiply -composite \) -delete 1,2 \
    -alpha off -compose CopyOpacity -composite \
    -quality 90 -define webp:method=6 $out/$name.webp
done
ls -l $out
