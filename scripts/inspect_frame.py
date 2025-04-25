import numpy as np

w, h = 1600, 1300
total_pixels = w * h
y_size = total_pixels

try:
    frame = np.fromfile("frame_gray.raw", dtype=np.uint8).reshape((h, w))
    print("GRAY8")
    print("Min:", frame.min())
    print("Max:", frame.max())
    print("Mean:", frame.mean())
except FileNotFoundError:
    print("frame_gray.raw not found")

try:
    frame = np.fromfile("frame_gray16le.raw", dtype=np.uint16).reshape((h, w))
    print("GRAY16LE")
    print("Min:", frame.min())
    print("Max:", frame.max())
    print("Mean:", frame.mean())
except FileNotFoundError:
    print("frame_gray16le.raw not found")

try:
    # Y is the first w*h samples
    # is the 10bit luma

    raw = np.fromfile("frame_yuv420p10le.raw", dtype=np.uint16)
    frame = raw[:y_size].reshape((h, w))
    print("yuv420p10le")
    print("Min:", frame.min())
    print("Max:", frame.max())
    print("Mean:", frame.mean())
except FileNotFoundError:
    print("frame_yuv420p10le.raw not found")


try:
    # Y is the first w*h samples
    # is the 12bit luma

    raw = np.fromfile("frame_yuv420p12le.raw", dtype=np.uint16)
    frame = raw[:y_size].reshape((h, w))
    print("yuv420p12le")
    print("Min:", frame.min())
    print("Max:", frame.max())
    print("Mean:", frame.mean())
except FileNotFoundError:
    print("frame_yuv420p12le.raw not found")