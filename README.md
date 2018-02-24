# Wii Sports Resort Main Theme

## command for creating video

```bash
# create audio file (create score.wav)
timidity --output-24bit -Ow score.midi

# create images (refer to images/ folder)
# crop-images.sh to produce same image size outputs

# create trimmed audio
# note the time discrepancy with audacity
ffmpeg -i score.wav -ss 0 -t 1:40.73 score-trimmed.wav

# create video
ffmpeg -i score-trimmed.wav -f concat -i ffmpeg-image-info.txt -ss 0 -t 1:40.73 video.mp4
```
