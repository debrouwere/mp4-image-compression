mkdir -p {intermediates,output}
echo 'Converting PNG files into MP4. Takes about a minute, so some patience.'
convert data/bbc-*.png -extent 1024x4000 intermediates/crop-%02d.png
# generate jpg and webp, and show file size of each
convert intermediates/crop-00.png output/still.webp
convert intermediates/crop-00.png -quality 100% output/still-q100.jpg
convert intermediates/crop-00.png -quality 80% output/still-q80.jpg
convert intermediates/crop-00.png -quality 60% output/still-q60.jpg
pngquant --ext -quant.png intermediates/crop-00.png
mv intermediates/crop-00-quant.png output/still-quant.png

for quality in 1 10 20 30 40
do
    ffmpeg \
        -framerate 1 \
        -i intermediates/crop-%02d.png \
        -c:v libx264 \
        -crf $quality \
        -preset slow \
        output/bbc-q$quality.mp4
done

du -skh output/*

for quality in 1 10 20 30 40
do
    du -k output/bbc-q$quality.mp4 | 
    cut -f1 | 
    xargs -I {} expr {} / 24 | 
    xargs -I {} echo "{}K    size per image in output/bbc-$quality.mp4"
done

# show example
jade show.jade -O output
coffee -co output show.coffee
open output/show.html