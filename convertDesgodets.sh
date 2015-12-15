#!/bin/bash

# script to transform desgodets.net's images

#create directory for thumbs, medium, full
mkdir full

# large images are in .
for i in $(ls *.jpg)
do
	# rotation des images 90 droite
	img=`basename $i`
	# 270 is 90 clockwise 
	`convert -rotate 270 $i full/$img`
	echo "rotate $img"
	# scale all images
	# new_name=`echo $img | sed s/_large/_thumb/`
	# `convert -scale 40x120 thumbs/$img thumbs/$new_name`
	# `convert -scale 50 thumbs/$img thumbs/$img`
	# `convert -scale 293 medium/$img medium/$img`
	# `convert -scale 3328 full/$img full/$img`

done

mkdir medium
mkdir thumbs
echo "create directories medium and thumbs"

for i in $(ls full/*.jpg)
do
	img=`basename $i`
	`convert -scale 50 full/$img thumbs/$img`
	echo "convert $img to thumbs"
	`convert -scale 290 full/$img medium/$img`
	echo "converte $img to medium"

done

# to resize and rotate
# convert *.jpg -resize 400x400 -rotate 180 *.jpg
