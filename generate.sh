set -x
make_clip() {
  name=$1
  time=$2
  out_vid=clip/$name.mp4
  mkdir -p clip
  ffmpeg -loop 1 -n -i src/$name.png -c:v libx264 -t $time -pix_fmt yuv420p clip/$name.mp4 >/dev/null 2>/dev/null
}

combine_clips() {
    ffmpeg -i clip/house.mp4 \
           -i clip/dad.mp4 \
           -i clip/mom.mp4 \
           -i clip/daughter.mp4 \
           -i clip/son.mp4 \
           -i clip/doggo.mp4 \
           -i clip/butler.mp4 \
           -i clip/baby.mp4 \
           -filter_complex "[0:v] [1:v] [2:v] [3:v] [4:v] [5:v] [6:v] [7:v] concat=n=8:v=1 [v]" -map "[v]" video_square.mp4
    # So it won't appear as a Youtube short
    ffmpeg -i video_square.mp4 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1" video_only.mp4
    ffmpeg -i video_only.mp4 -i src/pintsized.mp3 -map 0:v -map 1:a -c:v copy -shortest output.mkv
}

make_clip house 3
make_clip dad 2.5
make_clip mom 2.5
make_clip daughter 2.5
make_clip son 2.5
make_clip doggo 2
make_clip butler 2
make_clip baby 3

combine_clips
