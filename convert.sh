mkdir -p {intermediates,output}
echo 'Converting PNG files into MP4. Takes about a minute, so some patience.'
convert data/bbc-*.png -extent 1024x4000 intermediates/crop-%02d.png
# -qscale:v 0 is the best quality we can get
# it's not lossless like PNG is, and the quality isn't perfect, 
# but it's reasonable and text is legible
ffmpeg -framerate 1 -i intermediates/crop-%02d.png -c:v libx264 -qscale:v 0 output/bbc.mp4
# generate jpg and webp, and show file size of each
convert intermediates/crop-00.png output/still.webp
convert intermediates/crop-00.png -quality 100% output/still-q100.jpg
convert intermediates/crop-00.png -quality 80% output/still-q80.jpg
convert intermediates/crop-00.png -quality 60% output/still-q60.jpg
du -skh output/*
du -k output/bbc.mp4 | cut -f1 | xargs -I {} expr {} / 24 | xargs -I {} echo "{}K    size per image in output/bbc.mp4"
# show example
jade show.jade -O output
coffee -co output show.coffee
open output/show.html