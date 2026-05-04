read -p "File name to convert: " file_name
echo "CONVERTING: $file_name"
sleep 1
ffmpeg -i $file_name.mp4 -q:v 6 -q:a 6 -g:v 64 $file_name.ogv
echo "Conversion Done!"
sleep 2
clear
