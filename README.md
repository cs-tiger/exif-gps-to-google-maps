# exif-gps-to-google-maps

this bash script will take the output of the "exif -x" command in Linux  (exif -x outputs the exif data in XML format) and use the gps coordidates
to create a string that you can paste into google maps search and a google maps links

Example use:

exif -x 12345.jpg | exif_gps_to_google.sh 
54°9'23.420879"N 12°6'5.885999"E
https://www.google.de/maps/place/54°9'23.420879"N12°6'5.885999"E

