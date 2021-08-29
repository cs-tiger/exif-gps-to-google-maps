#!/bin/bash

#Input: Output of exif -x  (exif data from picture in XML format)
#Output: Coordinates in google maps format and google maps link

North_or_South_Latitude=""
Latitude=""
East_or_West_Longitude=""
Longitude=""

while read line
do
	if echo "$line" | grep -q "North_or_South_Latitude"; then
		# extract N or S from <North_or_South_Latitude>N</North_or_South_Latitude> (yeah, xml extraction with grep, I know...)
		North_or_South_Latitude=$(echo "$line" | grep -oPm1 "(?<=<North_or_South_Latitude>)[^<]+")
	fi
	if echo "$line" | grep -q "East_or_West_Longitude"; then
		# extract E or W from <East_or_West_Longitude>N</East_or_West_Longitude> (yeah, xml extraction with grep, I know...)
		East_or_West_Longitude=$(echo "$line" | grep -oPm1 "(?<=<East_or_West_Longitude>)[^<]+")
	fi
	if echo "$line" | grep -q "<Latitude>"; then
		# extract latitude from <Latitude>61,  0, 31.095360</Latitude>
		lat_temp=$(echo "$line" | grep -oPm1 "(?<=<Latitude>)[^<]+" | tr -d ' ')
		# lets iterate over the values (degree in °, minutes in ', seconds in ") seperated by comma , and concatenate them with ° ' and "
		Latitude=$(echo "$lat_temp" | awk -F, '{ for(i=0; i<=NF; ++i) ; print $1"°"$2"X",$3"Y" }' | tr "X" "'" | tr 'Y' '"' | tr -d " ")
	fi
	if echo "$line" | grep -q "<Longitude>"; then
		# extract Longitude from <Longitude> 7, 19, 55.197479</Longitude>
		lon_temp=$(echo "$line" | grep -oPm1 "(?<=<Longitude>)[^<]+" | tr -d ' ')
		# lets iterate over the values (degree in °, minutes in ', seconds in ") seperated by comma , and concatenate them with ° ' and "
		Longitude=$(echo "$lon_temp" | awk -F, '{ for(i=0; i<=NF; ++i) ; print $1"°"$2"X",$3"Y" }' | tr "X" "'" | tr 'Y' '"' | tr -d " ")
	fi
done < "${1:-/dev/stdin}"

echo "$Latitude$North_or_South_Latitude $Longitude$East_or_West_Longitude"
# create link as https://www.google.de/maps/place/60°55'09.6"N+7°17'26.5"E
echo "https://www.google.de/maps/place/$Latitude$North_or_South_Latitude$Longitude$East_or_West_Longitude"
