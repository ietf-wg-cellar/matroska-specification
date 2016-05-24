# Overhead

One of the way to compare containers is to analyze the overhead produced for the same raw data. The overhead is the amount of data added to these raw data, due to the internal structure of the format.

This document is only giving the overhead introduced by matroska. It is intended for the matroska team to better tune the format for efficiency. And also specify where matroska is best suited.

## Example 1 - low bitrate audio

Low bitrate audio (like speex or vorbis) is usually using very small packets of data, all independent ones (no reference to previous or future frames). The bitrate can be as low as 8kbps (to 64kbps). For 8kbps you have 1kBps. If you cut that into 20ms parts, that makes approximately 100 bytes (to 1000 bytes) per part (packet). Low bitrate codec are usually tuned for real-time conferencing on limited bandwidth lines, so the VBR aspect is usually limited. That's why we will consider that bitrate to be constant, ie the size of packets.

| bitrate | pkt size | No lacing | 2 in lace | 3 in lace | 4 in lace | 5 in lace | 6 in lace | 7 in lace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 8kbps | 100 | 1+1+4+0+100 (6%) | 1+2+4+2+200 (4.5%) | 1+2+4+3+300 (3.3%) | 1+2+4+4+400 (2.8%) | 1+2+4+5+500 (2.4%) | 1+2+4+6+600 (2.2%) | 1+2+4+7+700 (2%) |
| 16kbps | 200 | 1+2+4+0+200 (3.5%) | 1+2+4+2+400 (2.3%) | 1+2+4+3+600 (1.7%) | 1+2+4+4+800 (1.4%) | 1+2+4+5+1000 (1.2%) | 1+2+4+6+1200 (1.1%) | 1+2+4+7+1400 (1%) |
| 24kbps | 300 | 1+2+4+0+300 (2%) | 1+2+4+3+600 (1.8%) | 1+2+4+5+900 (1.3%) | 1+2+4+7+1200 (1.2%) | 1+2+4+9+1500 (1.1%) | 1+2+4+11+1800 (1%) | 1+2+4+13+2100 (0.95%) |
| 32kbps | 400 | 1+2+4+0+400 (1.8%) | 1+2+4+3+800 (1.3%) | 1+2+4+5+1200 (1%) | 1+2+4+7+1600 (0.88%) | 1+2+4+9+2000 (0.8%) | 1+2+4+11+2400 (0.67%) | 1+2+4+13+2800 (0.71%) |
| 48kbps | 600 | 1+2+4+0+600 (1%) | 1+2+4+4+1200 (0.92%) | 1+2+4+7+1800 (0.78%) | 1+2+4+10+2400 (0.71%) | 1+2+4+13+3000 (0.75%) | 1+2+4+16+3600 (0.64%) | 1+2+4+19+4200 (0.62%) |
| 64kbps | 800 | 1+2+4+0+800 (0.88%) | 1+2+4+5+1600 (0.75%) | 1+2+4+9+2400 (0.67%) | 1+2+4+13+3200 (0.63%) | 1+2+4+17+4000 (0.60%) | 1+2+4+21+4800 (0.58%) | 1+2+4+26+5600 (0.59%) |

**explanations :** This is the overhead introduced by the Block level. There is more overhead in a matroska file, ie the Cluster head (that contains many Blocks) and the file header (containing various meta information).

the first number is the number is the size of the total Block+Data, ie element ID (1), size (1 to 8), Block head (4), lacing (0 to infinite), data

the second number is the pourcentage of overhead for each packet

In matroska, synchronisation and error recovery is done with a Cluster. A cluster contains 1 to many Blocks. So let's see the effect of having 1 Block per Cluster, 2 Blocks per Cluster and 3 Blocks per Cluster. These are the worst cases where synchronisation is required often, ie every 20, 40 and 60ms (with 1 block only). A value of 1s is a pretty agressive case and is the minimum supported here (just to save me from a few calculus).

| 1 Block per Cluster |
| --- |
| bitrate | pkt size | No lacing | 2 in lace | 3 in lace | 4 in lace | 5 in lace (1s) | 6 in lace (1.2s) | 7 in lace (1.4s) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 8kbps | 100 | 4+2+1+2+4+5+500 (3.6%) | 4+2+1+2+4+6+600 (3.2%) | 4+2+1+2+4+7+700 (2.9%) |
| 16kbps | 200 | 4+2+1+2+4+5+1000 (1.8%) | 4+2+1+2+4+6+1200 (1.6%) | 4+2+1+2+4+7+1400 (1.4%) |
| 24kbps | 300 | 4+2+1+2+4+9+1500 (1.5%) | 4+2+1+2+4+11+1800 (1.3%) | 4+2+1+2+4+13+2100 (1.2%) |
| 32kbps | 400 | 4+2+1+2+4+9+2000 (1.1%) | 4+2+1+2+4+11+2400 (1%) | 4+2+1+2+4+13+2800 (0.93%) |
| 48kbps | 600 | 4+2+1+2+4+13+3000 (0.87%) | 4+2+1+2+4+16+3600 (0.81%) | 4+2+1+2+4+19+4200 (0.76%) |
| 64kbps | 800 | 4+2+1+2+4+17+4000 (0.75%) | 4+2+1+2+4+21+4800 (0.71%) | 4+2+1+2+4+26+5600 (0.70%) |

| 2 Blocks per Cluster |
| --- |
| bitrate | pkt size | No lacing | 2 in lace (0.8s) | 3 in lace (1.2s) | 4 in lace (1.6s) | 5 in lace (2s) | 6 in lace (2.4s) | 7 in lace (2.8s) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 8kbps | 100 | 4+2+2*(1+2+4+2+200) (6%) | 4+2+2*(1+2+4+3+300) (4.3%) | 4+2+2*(1+2+4+4+400) (3.5%) | 4+2+2*(1+2+4+5+500) (3%) | 4+2+2*(1+2+4+6+600) (2.7%) | 4+2+2*(1+2+4+7+700) (2.4%) |
| 16kbps | 200 | 4+2+2*(1+2+4+2+400) (3%) | 4+2+2*(1+2+4+3+600) (2.2%) | 4+2+2*(1+2+4+4+800) (1.8%) | 4+2+2*(1+2+4+5+1000) (1.5%) | 4+2+2*(1+2+4+6+1200) (1.1%) | 4+2+2*(1+2+4+7+1400) (1%) |
| 24kbps | 300 | 4+2+2*(1+2+4+3+600) (2.2%) | 4+2+2*(1+2+4+5+900) (1.7%) | 4+2+2*(1+2+4+7+1200) (1.4%) | 4+2+2*(1+2+4+9+1500) (1.3%) | 4+2+2*(1+2+4+11+1800) (1.2%) | 4+2+2*(1+2+4+13+2100) (1.1%) |
| 32kbps | 400 | 4+2+2*(1+2+4+3+800) (1.6%) | 4+2+2*(1+2+4+5+1200) (1.3%) | 4+2+2*(1+2+4+7+1600) (1.1%) | 4+2+2*(1+2+4+9+2000) (0.95%) | 4+2+2*(1+2+4+11+2400) (0.88%) | 4+2+2*(1+2+4+13+2800) (0.82%) |
| 48kbps | 600 | 4+2+2*(1+2+4+4+1200) (1.2%) | 4+2+2*(1+2+4+7+1800) (0.94%) | 4+2+2*(1+2+4+10+2400) (0.83%) | 4+2+2*(1+2+4+13+3000) (0.77%) | 4+2+2*(1+2+4+16+3600) (0.72%) | 4+2+2*(1+2+4+19+4200) (0.69%) |
| 64kbps | 800 | 4+2+2*(1+2+4+5+1600) (0.94%) | 4+2+2*(1+2+4+9+2400) (0.79%) | 4+2+2*(1+2+4+13+3200) (0.72%) | 4+2+2*(1+2+4+17+4000) (0.68%) | 4+2+2*(1+2+4+21+4800) (0.65%) | 4+2+2*(1+2+4+26+5600) (0.64%) |

| 3 Blocks per Cluster |
| --- |
| bitrate | pkt size | No lacing | 2 in lace (1.2s) | 3 in lace (1.8s) | 4 in lace (2.4s) | 5 in lace (3s) | 6 in lace (3.6s) | 7 in lace (4.2s) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 8kbps | 100 | 4+2+3*(1+2+4+2+200) (5.5%) | 4+2+3*(1+2+4+3+300) (4%) | 4+2+3*(1+2+4+4+400) (3.3%) | 4+2+3*(1+2+4+5+500) (2.8%) | 4+2+3*(1+2+4+6+600) (2.5%) | 4+2+3*(1+2+4+7+700) (2.3%) |
| 16kbps | 200 | 4+2+3*(1+2+4+2+400) (2.8%) | 4+2+3*(1+2+4+3+600) (2%) | 4+2+3*(1+2+4+4+800) (1.6%) | 4+2+3*(1+2+4+5+1000) (1.4%) | 4+2+3*(1+2+4+6+1200) (1.3%) | 4+2+3*(1+2+4+7+1400) (1.1%) |
| 24kbps | 300 | 4+2+3*(1+2+4+3+600) (1.8%) | 4+2+3*(1+2+4+5+900) (1.3%) | 4+2+3*(1+2+4+7+1200) (1.2%) | 4+2+3*(1+2+4+9+1500) (1.1%) | 4+2+3*(1+2+4+11+1800) (1%) | 4+2+3*(1+2+4+13+2100) (0.95%) |
| 32kbps | 400 | 4+2+3*(1+2+4+3+800) (1.5%) | 4+2+3*(1+2+4+5+1200) (1.2%) | 4+2+3*(1+2+4+7+1600) (1%) | 4+2+3*(1+2+4+9+2000) (0.9%) | 4+2+3*(1+2+4+11+2400) (0.83%) | 4+2+3*(1+2+4+13+2800) (0.79%) |
| 48kbps | 600 | 4+2+3*(1+2+4+4+1200) (0.92%) | 4+2+3*(1+2+4+7+1800) (0.78%) | 4+2+3*(1+2+4+10+2400) (0.71%) | 4+2+3*(1+2+4+13+3000) (0.75%) | 4+2+3*(1+2+4+16+3600) (0.64%) | 4+2+3*(1+2+4+19+4200) (0.62%) |
| 64kbps | 800 | 4+2+3*(1+2+4+5+1600) (0.88%) | 4+2+3*(1+2+4+9+2400) (0.75%) | 4+2+3*(1+2+4+13+3200) (0.69%) | 4+2+3*(1+2+4+17+4000) (0.65%) | 4+2+3*(1+2+4+21+4800) (0.63%) | 4+2+3*(1+2+4+26+5600) (0.63%) |

**explanations :** the third number is the max time between 2 error recoveries (re-sync) in milliseconds. This is based on the example of all frames have a 20ms granularity.

### Conclusions

*   For the same error-recovery (1.2s, 2.4s) we clearly see that it's better to put as much data in one Block and use lacing. In this case there will be 1 Block per Cluster. One of the drawback is that only the first packet of data has a timecode (one timecode every second).
*   If we agree that 2% overhead is OK for low bitrates (the same as for MP3), the minimum bitrate acceptable is between 8kbps and 16kbps (probably closer to 16 kbps). Actually this value depend on the block size and not really the bitrate.
*   For bitrates higher than 48kbps (or a fixed packet rate of 600 bytes) the overhead is very good even with one frame per packet.

## Example 2 - medium bitrate audio

## Example 3 - high bitrate audio

## Example 4 - low bitrate video

Low bitrate video is, like low bitrate audio, the worst case for overhead. The range we will use here is 64 kbps to 256kbps. I think these are reasonable values for what can be considered as low video bitrate.

One of the major difference in video is that the number of frame per second is fixed (10 to 30 for low bitrates).

Another difference is that the frames usually depend on others to save some compression bits. One of the effect is that all frames don't have the same size. You have key frames (I) that don't depend on other frames, (P) frames that depend on an older frame and (B) frames that rely on an older and a future frame.

It is mandatory that all I frames have an actual timecode coming from the container, because the P and B frames will rely on that timecode for reference.

### First example - all I frames (CBR)

With all I frames, the average data is easy to compute. For 64kbps=8kBps we have a frame=1/20s. That means each frame is 400 bytes big. So the results are similar to 32kbps audio.

Lacing should not be used for better seeking in the file. But it is still possible for use in this particular case.

| 1 I frame/Block per Cluster (5ms) |
| --- |
| bitrate | pkt size | No lacing | 2 in lace | 3 in lace |
| --- | --- | --- | --- | --- |
| 64kbps | 400 | 4+2+1+2+4+400 (3.3%) | 4+2+1+2+4+3+800 (2%) | 4+2+1+2+4+5+1200 (1.5%) |
| 128kbps | 800 | 4+2+1+2+4+800 (1.63%) | 4+2+1+2+4+5+1600 (1.1%) | 4+2+1+2+4+9+2400 (0.92%) |
| 256kbps | 1200 | 4+2+1+2+4+1200 (1.08%) | 4+2+1+2+4+6+2400 (0.79%) | 4+2+1+2+4+11+3600 (0.67%) |

| 2 I frame/Block per Cluster (10ms) |
| --- |
| bitrate | pkt size | No lacing | 2 in lace | 3 in lace |
| --- | --- | --- | --- | --- |
| 64kbps | 400 | 4+2+2*(1+2+4+400) (2.5%) | 4+2+2*(1+2+4+3+800) (1.6%) | 4+2+2*(1+2+4+5+1200) (1.3%) |
| 128kbps | 800 | 4+2+2*(1+2+4+800) (1.3%) | 4+2+2*(1+2+4+5+1600) (0.94%) | 4+2+2*(1+2+4+9+2400) (0.7%) |
| 256kbps | 1200 | 4+2+2*(1+2+4+1200) (0.83%) | 4+2+2*(1+2+4+6+2400) (0.67%) | 4+2+2*(1+2+4+11+3600) (0.58%) |

| 4 I frame/Block per Cluster (20ms) |
| --- |
| bitrate | pkt size | No lacing | 2 in lace | 3 in lace |
| --- | --- | --- | --- | --- |
| 64kbps | 400 | 4+2+4*(1+2+4+400) (2.1%) | 4+2+4*(1+2+4+3+800) (1.4%) | 4+2+4*(1+2+4+5+1200) (1.1%) |
| 128kbps | 800 | 4+2+4*(1+2+4+800) (1.06%) | 4+2+4*(1+2+4+5+1600) (0.84%) | 4+2+4*(1+2+4+9+2400) (0.73%) |
| 256kbps | 1200 | 4+2+4*(1+2+4+1200) (0.71%) | 4+2+4*(1+2+4+6+2400) (0.60%) | 4+2+4*(1+2+4+11+3600) (0.54%) |

| 8 I frame/Block per Cluster (40ms) |
| --- |
| bitrate | pkt size | No lacing | 2 in lace | 3 in lace |
| --- | --- | --- | --- | --- |
| 64kbps | 400 | 4+2+8*(1+2+4+400) (1.9%) | 4+2+8*(1+2+4+3+800) (1.3%) | 4+2+8*(1+2+4+5+1200) (1.06%) |
| 128kbps | 800 | 4+2+8*(1+2+4+800) (0.97%) | 4+2+8*(1+2+4+5+1600) (0.80%) | 4+2+8*(1+2+4+9+2400) (0.73%) |
| 256kbps | 1200 | 4+2+8*(1+2+4+1200) (0.65%) | 4+2+8*(1+2+4+6+2400) (0.57%) | 4+2+8*(1+2+4+11+3600) (0.52%) |

We clearly see that there is another more interresting table (lacing use is dropped) :

| bitrate | pkt size | 1 Block/C (50ms) | 2 Blocks/C (100ms) | 4 Blocks/C (200ms) | 8 Blocks/C (400ms) | 16 Blocks/C (800ms) | 20 Blocks/C (1s) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 64kbps | 400 | 4+2+1*(1+2+4+400) (3.3%) | 4+2+2*(1+2+4+400) (2.5%) | 4+2+4*(1+2+4+400) (2.1%) | 4+2+8*(1+2+4+400) (1.9%) | 4+2+16*(1+2+4+400) (1.8%) | 4+2+20*(1+2+4+400) (1.8%) |
| 128kbps | 800 | 4+2+1*(1+2+4+800) (1.63%) | 4+2+2*(1+2+4+800) (1.3%) | 4+2+4*(1+2+4+800) (1.06%) | 4+2+8*(1+2+4+800) (0.97%) | 4+2+16*(1+2+4+800) (0.92%) | 4+2+20*(1+2+4+800) (0.91%) |
| 256kbps | 1200 | 4+2+1*(1+2+4+1200) (1.08%) | 4+2+2*(1+2+4+1200) (0.83%) | 4+2+4*(1+2+4+1200) (1.06%) | 4+2+8*(1+2+4+1200) (0.65%) | 4+2+16*(1+2+4+1200) (0.61%) | 4+2+20*(1+2+4+1200) (0.61%) |

**Conslusions :**

*   In most cases, the best result is when 8 Blocks are packed in a Cluster. Bigger values don't improve the overhead much. It also seems to be a good value to stop using lacing in the low audio bitrate example. **So both lacing and clustering will be limited to 8 elements in libmatroska** on writing.
*   In an agressive case like a 64kbps CBR video codec at 20 frames/sec can still achieve an overhead of less than 2% which is quite good.
*   Upper 128kbps an overhead of less than 1% can always be achieved.
*   Having 2 frames in a lace can improve substanctially the overhead. But as I frames should always have a proper timecode, it is not possible to use this solution.

### Second example - 1 I frame for 1 B frame

In this case, each frame has to be separated in a Block (no lacing possible). The reference timecode in matroska (of the previous frame) is written in a separate element ([BlockAddition][TimecodeReference]). So more overhead is introduced.

We will establish that the P frame is 3x smaller than the I frame (I hope this is a realistic case). That means that, at 20 frames per second, for 64 kbps the I frame is 600 bytes and the B frame is 200 bytes (2 frames are 2*400 bytes big).

| bitrate | pkt size | 2 Blocks/C (100ms) | 4 Blocks/C (200ms) | 8 Blocks/C (400ms) | 16 Blocks/C (800ms) | 20 Blocks/C (1s) |
| --- | --- | --- | --- | --- | --- | --- |
| 64kbps | 600/200 | 4+2+(1+2+4+600)+(1+2+4+200+1+1+2) (3%) | 4+2+2*((1+2+4+600)+(1+2+4+200+1+1+2)) (2.6%) | 4+2+4*((1+2+4+600)+(1+2+4+200+1+1+2)) (2.4%) | 4+2+8*((1+2+4+600)+(1+2+4+200+1+1+2)) (2.3%) | 4+2+10*((1+2+4+600)+(1+2+4+200+1+1+2)) (2.3%) |
| 128kbps | 1200/400 | 4+2+(1+2+4+1200)+(1+2+4+400+1+1+2) (1.5%) | 4+2+2*((1+2+4+1200)+(1+2+4+400+1+1+2)) (1.3%) | 4+2+4*((1+2+4+1200)+(1+2+4+400+1+1+2)) (1.2%) | 4+2+8*((1+2+4+1200)+(1+2+4+400+1+1+2)) (1.1%) | 4+2+10*((1+2+4+1200)+(1+2+4+400+1+1+2)) (1.1%) |
| 256kbps | 1800/600 | 4+2+(1+2+4+1800)+(1+2+4+600+1+1+2) (1.01%) | 4+2+2*((1+2+4+1800)+(1+2+4+600+1+1+2)) (0.88%) | 4+2+4*((1+2+4+1800)+(1+2+4+600+1+1+2)) (0.81%) | 4+2+8*((1+2+4+1800)+(1+2+4+600+1+1+2)) (0.78%) | 4+2+10*((1+2+4+1800)+(1+2+4+600+1+1+2)) (0.78%) |

**Conslusions :**

*   As for the previous case, 8 Blocks per Cluster seem to be the optimum value.
*   The use of B frame degrades the overhead by approximately 0.5%. It is due to the additional backward reference.
*   A bitrate of over 128 kbps still have a good overhead. But the 2.4% for 64kbps is still acceptable.

## Example 5 - medium bitrate video

## Example 6 - high bitrate video

## Example 7 - low bitrate video + low bitrate audio

## Example 8 - medium bitrate video + medium bitrate audio

## Example 9 - high bitrate video + high bitrate audio
