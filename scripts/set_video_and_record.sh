export VIDEO_SRC=/dev/video8
export VIDEO_WIDTH=1600
export VIDEO_HEIGHT=1300
export VIDEO_FPS=40
export VIDEO_SIZE="${VIDEO_WIDTH}x${VIDEO_HEIGHT}"

# Options are "ffv1" or "libx264"
# export VIDEO_ENCODER=ffv1
export VIDEO_ENCODER=libx264

# Options are "GREY" or "Y16 " (note the space at the end)
# PIXEL_FORMAT="GREY"
PIXEL_FORMAT="Y16 "


if [ $PIXEL_FORMAT == "GREY" ]; then
    PIX_FMT="gray"
else
    PIX_FMT="gray16le"
fi

 echo "USING PIX FORMAT: $PIX_FMT"

v4l2-ctl --device=$VIDEO_SRC --list-formats-ext
v4l2-ctl --device=$VIDEO_SRC --set-fmt-video=width=$VIDEO_WIDTH,height=$VIDEO_HEIGHT,pixelformat="$PIXEL_FORMAT"
v4l2-ctl --device=$VIDEO_SRC --set-ctrl=brightness=10
v4l2-ctl --device=$VIDEO_SRC --all
v4l2-ctl --device=$VIDEO_SRC --get-fmt-video

# The incoming -pixel_format must be "gray" not "gray16le" to get full 16-bit.
if [ $VIDEO_ENCODER == "ffv1" ]; then

        ffmpeg \
        -hide_banner \
        -f v4l2 \
        -video_size $VIDEO_SIZE \
        -pixel_format gray \
        -framerate $VIDEO_FPS \
        -i $VIDEO_SRC \
        -frames:v 50 \
        -filter:v fps=10 \
        -pix_fmt $PIX_FMT \
        -c:v ffv1 \
        -level 3 \
        -g 1 \
        -y "output_${PIX_FMT}.mkv"
else
        PIX_FMT="yuv420p10le"

        ffmpeg \
        -hide_banner \
        -f v4l2 \
        -video_size $VIDEO_SIZE \
        -pixel_format gray \
        -framerate $VIDEO_FPS \
        -i $VIDEO_SRC \
        -frames:v 50 \
        -filter:v fps=10 \
        -pix_fmt $PIX_FMT \
        -c:v libx264 \
        -profile:v high10 \
        -preset veryfast \
        -crf 20 \
        -g 10 \
        -y "output_${PIX_FMT}.mkv"
fi

ffmpeg -hide_banner -ss 2 -i "output_${PIX_FMT}.mkv" -frames:v 1 -pix_fmt $PIX_FMT -y -f rawvideo "frame_${PIX_FMT}.raw"

ls -lh "output_${PIX_FMT}.mkv"
ls -lh "frame_${PIX_FMT}.raw"

python3 ./scripts/inspect_frame.py








: '
Driver Info:
        Driver name      : uvcvideo
        Card type        : See3CAM_20CUG
        Bus info         : usb-xhci-hcd.0-1
        Driver version   : 6.6.74
        Capabilities     : 0x84a00001
                Video Capture
                Metadata Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps      : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format
Media Driver Info:
        Driver name      : uvcvideo
        Model            : See3CAM_20CUG
        Serial           : 2D31CD08
        Bus info         : usb-xhci-hcd.0-1
        Media version    : 6.6.74
        Hardware revision: 0x00000000 (0)
        Driver version   : 6.6.74
Interface Info:
        ID               : 0x03000002
        Type             : V4L Video
Entity Info:
        ID               : 0x00000001 (1)
        Name             : See3CAM_20CUG
        Function         : V4L2 I/O
        Flags            : default
        Pad 0x01000007   : 0: Sink
          Link 0x02000010: from remote pad 0x100000a of entity 'Extension 3' (Video Pixel Formatter): Data, Enabled, Immutable
Priority: 2
Video input : 0 (Camera 1: ok)
Format Video Capture:
        Width/Height      : 1600/1300
        Pixel Format      : 'Y16 ' (16-bit Greyscale)
        Field             : None
        Bytes per Line    : 3200
        Size Image        : 4160000
        Colorspace        : sRGB
        Transfer Function : Default (maps to sRGB)
        YCbCr/HSV Encoding: Default (maps to ITU-R 601)
        Quantization      : Default (maps to Full Range)
        Flags             : 
Crop Capability Video Capture:
        Bounds      : Left 0, Top 0, Width 1600, Height 1300
        Default     : Left 0, Top 0, Width 1600, Height 1300
        Pixel Aspect: 1/1
Selection Video Capture: crop_default, Left 0, Top 0, Width 1600, Height 1300, Flags: 
Selection Video Capture: crop_bounds, Left 0, Top 0, Width 1600, Height 1300, Flags: 
Streaming Parameters Video Capture:
        Capabilities     : timeperframe
        Frames per second: 40.000 (40/1)
        Read buffers     : 0

User Controls

                     brightness 0x00980900 (int)    : min=1 max=240 step=1 default=10 value=10

Camera Controls

         exposure_time_absolute 0x009a0902 (int)    : min=1 max=1000 step=1 default=156 value=156

'