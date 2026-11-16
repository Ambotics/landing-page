#!/bin/zsh
# The hero's pictures, from the zoom views of the robot's render script. See "The hero" in README.md.
#   scripts/hero.sh <prefix>    reads <prefix>_zoom.json and <prefix>_zoom_<name>.png, as shade.py wrote them
# Each picture fades out over its last 6 % on every side: a closer one into the wider one under it, the
# widest into the page, where its floor shadow would otherwise end on a line, the head's into the robot.
# The mark's tile takes the page's accent. The render cannot give that blue (its tone curve pales it), so
# the tile comes in the nearest blue the render has, and is moved the rest of the way here.
# The head's looks (look_<row>_<col>) become one picture a row. The whole robot and the looks come twice,
# the second time twice as sharp (robot_2x, look_2x_<row>_<col>), for a screen that needs them.
# The looks' reliefs (<prefix>_zoom_relief_<row>_<col>.ppm) become one picture, laid out as the looks are.
set -e
zmodload zsh/mathfunc
prefix=$1
site=${0:A:h:h}
out=$site/src/assets/hero
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT
rm -rf $out/*.webp $out/head $out/look $out/look_2x
mkdir -p $out/head $out/look $out/look_2x
cp ${prefix}_zoom.json $out/zoom.json
mark=$(jq .mark $out/zoom.json)
accent=$(sed -n 's/.*--color-accent: *#\([0-9a-f]*\);.*/\1/p' $site/src/styles/global.css)
accent=($(( 16#${accent[1,2]} / 2.55 )) $(( 16#${accent[3,4]} / 2.55 )) $(( 16#${accent[5,6]} / 2.55 )))   # r g b, percent
for in in ${prefix}_zoom_*.png; do
  name=${${in#${prefix}_zoom_}%.png}
  size=($(magick identify -format '%w %h' $in))
  to=$out/${name/head_/head/}.webp   # the head's frames go in a directory of their own
  if [[ $name == look_* ]]; then
    to=$tmp/$name.png
  elif [[ $name != head* ]]; then
    # the tile's box in this picture, 2 px out for its soft edge
    field=($(jq -r --arg name ${name%_2x} '.levels[] | select(.name == $name) | "\(.x) \(.y) \(.w) \(.h)"' $out/zoom.json))
    px=$(( size[1] / field[3] ))   # per mm
    side=$(( int(mark * px) + 4 ))
    at=+$(( int((-mark / 2 - field[1]) * px) - 2 ))+$(( int((-mark / 2 - field[2]) * px) - 2 ))
    magick $in -crop ${side}x${side}$at +repage $tmp/tile.png
    # its blue as rendered, from inside its top left corner, and the red of the cover that shows through the A
    spot=$(( int(side / 8) ))
    blue=($(magick $tmp/tile.png -crop ${spot}x${spot}+${spot}+${spot} +repage -resize '1x1!' -format '%[fx:100*u.r] %[fx:100*u.g] %[fx:100*u.b]' info:))
    cover=$(magick $tmp/tile.png -crop $(( spot / 2 ))x$(( spot / 2 ))+$(( int(side * 0.66) ))+$(( int(side * 0.64) )) +repage -resize '1x1!' -format '%[fx:100*u.r]' info:)   # in the A's long stroke
    # as much of the move as a pixel is tile: all of it on the blue, none on the A, part on the edge between
    magick $tmp/tile.png -channel R -separate +channel -level ${blue[1]}%,${cover}% -negate $tmp/much.png
    magick $tmp/tile.png -channel R -evaluate add $(( accent[1] - blue[1] ))% -channel G -evaluate add $(( accent[2] - blue[2] ))% \
      -channel B -evaluate add $(( accent[3] - blue[3] ))% +channel $tmp/moved.png
    magick $in \( $tmp/tile.png $tmp/moved.png $tmp/much.png -composite \) -geometry $at -composite $tmp/in.png
    in=$tmp/in.png
  fi
  fade=$(( (size[1] > size[2] ? size[1] : size[2]) * 6 / 100 ))
  # the picture's own transparency times a white box, blurred, that stops half the fade short of the edges
  magick $in \
    \( +clone -alpha extract \) \
    \( -size ${size[1]}x${size[2]} xc:black -fill white \
       -draw "rectangle $((fade / 2)),$((fade / 2)) $((size[1] - 1 - fade / 2)),$((size[2] - 1 - fade / 2))" -blur 0x$((fade / 6)) \) \
    \( -clone 1,2 -compose Multiply -composite \) -delete 1,2 \
    -alpha off -compose CopyOpacity -composite \
    -quality 90 -define webp:method=6 $to
done
# A row's looks side by side. There are many, each small on the screen and passing by, so they are packed
# harder: at quality 82 with 14 levels of transparency a look shows no difference at four times its size.
for first in $tmp/look_[0-9][0-9]_00.png(N) $tmp/look_2x_[0-9][0-9]_00.png(N); do
  kind=${${first:t}%_??_00.png}   # look or look_2x
  row=${${${first:t}%_00.png}##*_}
  magick $tmp/${kind}_${row}_*.png +append -quality 82 -define webp:method=6 -define webp:alpha-quality=60 $out/$kind/$row.webp
done
# The reliefs are numbers, not a picture: kept to the bit.
for first in ${prefix}_zoom_relief_[0-9][0-9]_00.ppm; do
  magick ${first%_00.ppm}_*.ppm +append $tmp/relief_${${first%_00.ppm}##*_}.png
done
magick $tmp/relief_*.png -append -define webp:lossless=true -define webp:method=6 -quality 100 $out/relief.webp
du -ch $out/*.webp $out/head $out/look $out/look_2x | tail -5
