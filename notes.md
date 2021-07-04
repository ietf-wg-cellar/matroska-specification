---
title: Specification Notes
---

# Unknown elements

Matroska is based upon the principle that a reading application does not have to support
100% of the specifications in order to be able to play the file. A Matroska file therefore
contains version indicators that tell a reading application what to expect.

It is possible and valid to have the version fields indicate that the file contains
Matroska `Elements` from a higher specification version number while signaling that a
reading application **MUST** only support a lower version number properly in order to play
it back (possibly with a reduced feature set). For example, a reading application
supporting at least Matroska version `V` reading a file whose `DocTypeReadVersion`
field is equal to or lower than `V` **MUST** skip Matroska/EBML `Elements` it encounters
but does not know about if that unknown element fits into the size constraints set
by the current `Parent Element`.


# DefaultDecodedFieldDuration

The `DefaultDecodedFieldDuration Element` can signal to the displaying application how
often fields of a video sequence will be available for displaying. It can be used for both
interlaced and progressive content. If the video sequence is signaled as interlaced,
then the period between two successive fields at the output of the decoding process
equals `DefaultDecodedFieldDuration`.

For video sequences signaled as progressive, it is twice the value of `DefaultDecodedFieldDuration`.

These values are valid at the end of the decoding process before post-processing
(such as deinterlacing or inverse telecine) is applied.

Examples:

* Blu-ray movie: 1000000000ns/(48/1.001) = 20854167ns
* PAL broadcast/DVD: 1000000000ns/(50/1.000) = 20000000ns
* N/ATSC broadcast: 1000000000ns/(60/1.001) = 16683333ns
* hard-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns (60 encoded interlaced fields per second)
* soft-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns (48 encoded interlaced fields per second, with "repeat_first_field = 1")

# Block Structure

Bit 0 is the most significant bit.

Frames using references **SHOULD** be stored in "coding order". That means the references first, and then
the frames referencing them. A consequence is that timestamps might not be consecutive.
But a frame with a past timestamp **MUST** reference a frame already known, otherwise it's considered bad/void.

## Block Header

| Offset | Player | Description |
|:-------|:-------|:------------|
| 0x00+  | **MUST** | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+  | **MUST** | Timestamp (relative to Cluster timestamp, signed int16) |
Table: Block Header base parts{#blockHeaderBase}

## Block Header Flags

| Offset | Bit | Player | Description |
|:-------|:----|:-------|:------------|
| 0x03+  | 0-3 | -      | Reserved, set to 0 |
| 0x03+  | 4   | -      | Invisible, the codec **SHOULD** decode this frame but not display it |
| 0x03+  | 5-6 | **MUST** | Lacing |
|        |     |        | *   00 : no lacing |
|        |     |        | *   01 : Xiph lacing |
|        |     |        | *   11 : EBML lacing |
|        |     |        | *   10 : fixed-size lacing |
| 0x03+  | 7   | -      | not used |
Table: Block Header flags part{#blockHeaderFlags}

## SimpleBlock Structure

The `SimpleBlock` is inspired by the Block structure; see (#block-structure).
The main differences are the added Keyframe flag and Discardable flag. Otherwise everything is the same.

Bit 0 is the most significant bit.

Frames using references **SHOULD** be stored in "coding order". That means the references first, and then
the frames referencing them. A consequence is that timestamps might not be consecutive.
But a frame with a past timestamp **MUST** reference a frame already known, otherwise it's considered bad/void.

### SimpleBlock Header

| Offset | Player | Description |
|:-------|:-------|:------------|
| 0x00+  | **MUST** | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+  | **MUST** | Timestamp (relative to Cluster timestamp, signed int16) |
Table: SimpleBlock Header base parts{#simpleblockHeaderBase}

### SimpleBlock Header Flags

| Offset | Bit | Player | Description |
|:-------|:----|:-------|:------------|
| 0x03+  | 0   | -      | Keyframe, set when the Block contains only keyframes |
| 0x03+  | 1-3 | -      | Reserved, set to 0 |
| 0x03+  | 4   | -      | Invisible, the codec **SHOULD** decode this frame but not display it |
| 0x03+  | 5-6 | **MUST** | Lacing |
|        |     |        | *   00 : no lacing |
|        |     |        | *   01 : Xiph lacing |
|        |     |        | *   11 : EBML lacing |
|        |     |        | *   10 : fixed-size lacing |
| 0x03+  | 7   | -      | Discardable, the frames of the Block can be discarded during playing if needed |
Table: SimpleBlock Header flags part{#simpleblockHeaderFlags}

## Block Lacing

Lacing is a mechanism to save space when storing data. It is typically used for small blocks
of data (referred to as frames in Matroska). It packs multiple frames into a single `Block` or `SimpleBlock`.

Lacing **MUST NOT** be used to store a single frame in a `Block` or `SimpleBlock`.

There are 3 types of lacing:

1. Xiph, inspired by what is found in the Ogg container [@?RFC3533]
2. EBML, which is the same with sizes coded differently
3. fixed-size, where the size is not coded

When lacing is not used, i.e. to store a single frame, the lacing bits 5 and 6 of the `Block` or `SimpleBlock` **MUST** be set to zero.

For example, a user wants to store 3 frames of the same track. The first frame is 800 octets long,
the second is 500 octets long and the third is 1000 octets long. As these data are small,
they can be stored in a lace to save space.

It is possible not to use lacing at all and just store a single frame without any extra data.
When the FlagLacing -- (#flaglacing-element) -- is set to "0" all blocks of that track **MUST NOT** use lacing.

### No lacing

When no lacing is used, the number of frames in the lace is ommitted and only one frame can be stored in the Block.
The bits 5-6 of the Block Header flags are set to `00`.

The Block for a 800 octets frame is as follows:

| Block Octets | Value   | Description             |
|:-------------|:--------|:------------------------|
| 4-803        | <frame> | Single frame data       |
Table: No lacing{#blockNoLacing}

When a Block contains a single frame, it **MUST** use this No lacing mode.


### Xiph lacing

The Xiph lacing uses the same coding of size as found in the Ogg container [@?RFC3533].
The bits 5-6 of the Block Header flags are set to `01`.

The Block data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.
* Lacing size of each frame except the last one.
* Binary data of each frame consecutively.

The lacing size is split into 255 values, stored as unsigned octets -- for example, 500 is coded 255;245 or [0xFF 0xF5].
A frame with a size multiple of 255 is coded with a 0 at the end of the size -- for example, 765 is coded 255;255;255;0 or [0xFF 0xFF 0xFF 0x00].

The size of the last frame is deduced from the size remaining in the Block after the other frames.

Because large sizes result in large coding of the sizes, it is **RECOMMENDED** to use Xiph lacing only with small frames.

In our example, the 800, 500 and 1000 frames are stored with Xiph lacing in a Block as follows:

| Block Octet | Value | Description             |
|:------------|:------|:------------------------|
| 4           | 0x02  | Number of frames minus 1|
| 5-8         | 0xFF 0xFF 0xFF 0x23  | Size of the first frame (255;255;255;35)|
| 9-10        | 0xFF 0xF5  | Size of the second frame (255;245)|
| 11-810      |       | First frame data  |
| 811-1310    |       | Second frame data |
| 1311-2310   |       | Third frame data  |
Table: Xiph lacing example{#blockXiphLacing}

The Block is 2311 octets large and the last frame starts at 1311, so we can deduce the size of the last frame is 2311 - 1311 = 1000.


### EBML lacing

The EBML lacing encodes the frame size with an EBML-like encoding [@!RFC8794].
The bits 5-6 of the Block Header flags are set to `11`.

The Block data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.
* Lacing size of each frame except the last one.
* Binary data of each frame consecutively.

The first frame size is encoded as an EBML Unsigned Integer Element value.
The other frame sizes are encoded as a difference with the previous frame size as EBML Signed Integer Element values.
That corresponds to an EBML Data Size Values with two's complement notation with the leftmost bit being the sign bit as found in [@!RFC8794],
giving this range of values:

Bit Representation                                                          | Value
:---------------------------------------------------------------------------|:-------
1xxx xxxx                                                                   | value -(2^6^-1) to 2^6^-1 (ie 0 to 2^7^-2 minus 2^6^-1, half of the range)
01xx xxxx  xxxx xxxx                                                        | value -(2^13^-1) to 2^13^-1
001x xxxx  xxxx xxxx  xxxx xxxx                                             | value -(2^20^-1) to 2^20^-1
0001 xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                                  | value -(2^27^-1) to 2^27^-1
0000 1xxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                       | value -(2^34^-1) to 2^34^-1
0000 01xx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx            | value -(2^41^-1) to 2^41^-1
0000 001x  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx | value -(2^48^-1) to 2^48^-1
Table: EBML Lacing bits usage{#ebmlLacingBits}

In our example, the 800, 500 and 1000 frames are stored with EBML lacing in a Block as follows:

| Block Octets | Value | Description             |
|:-------------|:------|:------------------------|
| 4            | 0x02  | Number of frames minus 1|
| 5-6          | 0x43 0x20 | Size of the first frame (800 = 0x320 + 0x4000)|
| 7-8          | 0x5E 0xD3 | Size of the second frame (500 - 800 = -300 = - 0x12C + 0x1FFF + 0x4000)|
| 8-807        | <frame1>  | First frame data  |
| 808-1307     | <frame2>  | Second frame data |
| 1308-2307    | <frame3>  | Third frame data  |
Table: EBML lacing example{#blockEbmlLacing}

The Block is 2308 octets large and the last frame starts at 1308, so we can deduce the size of the last frame is 2308 - 1308 = 1000.


### Fixed-size lacing

The Fixed-size lacing doesn't store the frame size, only the number of frames in the lace.
Each frame **MUST** have the same size. The frame size of each frame is deduced from the total size of the Block.
The bits 5-6 of the Block Header flags are set to `10`.

The Block data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.
* Binary data of each frame consecutively.

For example, for 3 frames of 800 octets each:

| Block Octets | Value    | Description             |
|:-------------|:---------|:------------------------|
| 4            | 0x02     | Number of frames minus 1|
| 5-804        | <frame1> | First frame data  |
| 805-1604     | <frame2> | Second frame data |
| 1605-2404    | <frame3> | Third frame data  |
Table: Fixed-size lacing example{#blockFixedSizeLacing}

This gives a Block of 2405 octets. When reading the Block we find that there are 3 frames (Octet 4).
The data start at Octet 5, so the size of each frame is (2405 - 5) / 3 = 800.


### Laced Frames Timestamp

A Block only contains a single timestamp value. But when lacing is used, it contains more than one frame.
Each frame originally has its own timestamp, or Presentation Timestamp (PTS). That timestamp applies to
the first frame in the lace.

In the lace, each frame after the first one has an undertermined timestamp.
But each of these frames **MUST** be contiguous -- i.e. the decoded data **MUST NOT** contain any gap
between them. If there is a gap in the stream, the frames around the gap **MUST NOT** be in the same Block.

Lacing is only useful for small contiguous data to save space. This is usually the case for audio tracks
and not the case for video -- which use a lot of data -- or subtitle tracks -- which have long gaps.
For audio, there is usually a fixed output sampling frequency for the whole track.
So the decoder should be able to recover the timestamp of each sample, knowing each
output sample is contiguous with a fixed frequency.
For subtitles this is usually not the case so lacing **SHOULD NOT** be used.


# Timestamps

Historically timestamps in Matroska were mistakenly called timecodes. The `Timestamp Element`
was called Timecode, the `TimestampScale Element` was called TimecodeScale, the
`TrackTimestampScale Element` was called TrackTimecodeScale and the
`ReferenceTimestamp Element` was called ReferenceTimeCode.

## Timestamp Ticks

All timestamp values in Matroska are expressed in multiples of a tick, stored as integers.
There are three types of ticks possible:

### Matroska Ticks

For such elements, the timestamp value is stored directly in nanoseconds.

The elements storing values in Matroska Ticks/nanoseconds are:

* `TrackEntry\DefaultDuration`; defined in (#defaultduration-element)
* `TrackEntry\DefaultDecodedFieldDuration`; defined in (#defaultdecodedfieldduration-element)
* `ChapterAtom\ChapterTimeStart`; defined in (#chaptertimestart-element)
* `ChapterAtom\ChapterTimeEnd`; defined in (#chaptertimeend-element)
* `TrackEntry\CodecDelay`; defined in (#codecdelay-element)
* `CuePoint\CueTime`; defined in (#cuetime-element)
* `CueReference\CueRefTime`; defined in (#cuetime-element)

### Segment Ticks

Elements in Segment Ticks involve the use of the `TimestampScale Element` of the Segment to get the timestamp
in nanoseconds of the element, with the following formula:

    timestamp in nanosecond = element value * TimestampScale

This allows storing smaller integer values in the elements.

When using the default value of `TimestampScale` of "1,000,000", one Segment Tick represents one millisecond.

The elements storing values in Segment Ticks are:

* `Cluster\Timestamp`; defined in (#timestamp-element)
* `Info\Duration`; defined in (#duration-element)

### Track Ticks

Elements in Segment Ticks involve the use of the `TimestampScale Element` of the Segment and the `TrackTimestampScale Element` of the Track
to get the timestamp in nanoseconds of the element, with the following formula:

    timestamp in nanosecond = element value * TimestampScale * TrackTimestampScale

This allows storing smaller integer values in the elements.
The resulting floating point values of the timestamps are still expressed in nanoseconds.

When using the default values for `TimestampScale` and `TrackTimestampScale` of "1,000,000" and of "1.0" respectively, one Track Tick represents one millisecond.

The elements storing values in Track Ticks are:

* `Cluster\BlockGroup\Block` and `Cluster\SimpleBlock` timestamps; detailed in (#block-timestamps)
* `Cluster\BlockGroup\BlockDuration`; defined in (#blockduration-element)
* `Cluster\BlockGroup\ReferenceBlock`; defined in (#referenceblock-element)

When the `TrackTimestampScale` is interpreted as "1.0", Track Ticks are equivalent to Segment Ticks
and give an integer value in nanoseconds. This is the most common case as `TrackTimestampScale` is usually omitted.

A value of `TrackTimestampScale` other than "1.0" **MAY** be used
to scale the timestamps more in tune with each Track sampling frequency.
For historical reasons, a lot of Matroska readers don't take the `TrackTimestampScale` value in account.
So using a value other than "1.0" **MAY** not work in many places.

## Block Timestamps

A `Block Element` and `SimpleBlock Element` timestamp is the time when the decoded data of the first
frame in the Block/SimpleBlock **MUST** be presented, if the track of that Block/SimpleBlock is selected for playback.
This is also known as the Presentation Timestamp (PTS).

The `Block Element` and `SimpleBlock Element` store their timestamps as signed integers, relative
to the `Cluster\Timestamp` value of the `Cluster` they are stored in.
To get the timestamp of a `Block` or `SimpleBlock` in nanoseconds you have to use the following formula:

    Cluster\Timestamp + (signed timestamp * TimestampScale * TrackTimestampScale)

The `Block Element` and `SimpleBlock Element` store their timestamps as 16bit signed integers,
allowing a range from "-32768" to "+32767" Track Ticks.
Although these values can be negative, when added to the `Cluster\Timestamp`, the resulting timestamp **MUST NOT** be negative.


## TimestampScale Rounding

Because the default value of `TimestampScale` is 1000000, which makes each integer in the
`Cluster` and `Block` `Timestamp Elements` equal 1ms, this is the most commonly used.
When dealing with audio, this causes inaccuracy when seeking. When the audio is combined with video,
this is not an issue. For most cases, the the synch of audio to video does not need to be more than
1ms accurate. This becomes obvious when one considers that sound will take 2-3ms to travel a single meter,
so distance from your speakers will have a greater effect on audio/visual synch than this.

However, when dealing with audio-only files, seeking accuracy can become critical.
For instance, when storing a whole CD in a single track, a user will want to be able to seek
to the exact sample that a song begins at. If seeking a few sample ahead or behind, a crack
or pop may result as a few odd samples are rendered. Also, when performing precise editing,
it may be very useful to have the audio accuracy down to a single sample.

When storing timestamps for an audio stream, the `TimestampScale Element` **SHOULD** have an accuracy
of at least that of the audio sample rate, otherwise there are rounding errors that prevent users
from knowing the precise location of a sample. Here's how a program has to round each timestamp
in order to be able to recreate the sample number accurately.

Let's assume that the application has an audio track with a sample rate of 44100. As written
above the `TimestampScale` **MUST** have at least the accuracy of the sample rate itself: 1000000000 / 44100 = 22675.7369614512.
This value **MUST** always be truncated. Otherwise the accuracy will not suffice.
So in this example the application will use 22675 for the `TimestampScale`.
The application could even use some lower value like 22674, which would allow it to be a
little bit imprecise about the original timestamps. But more about that in a minute.

Next the application wants to write sample number 52340 and calculates the timestamp. This is easy.
In order to calculate the `Raw Timestamp` in ns all it has to do is calculate
`Raw Timestamp = round(1000000000 * sample_number / sample_rate)`. Rounding at this stage
is very important! The application might skip it if it choses a slightly smaller value for
the `TimestampScale` factor instead of the truncated one like shown above.
Otherwise it has to round or the results won't be reversible.
For our example we get `Raw Timestamp = round(1000000000 * 52340 / 44100) = round(1186848072.56236) = 1186848073`.

The next step is to calculate the `Absolute Timestamp` - that is the timestamp that
will be stored in the Matroska file. Here the application has to divide the `Raw Timestamp`
from the previous paragraph by the `TimestampScale` factor and round the result:
`Absolute Timestamp = round(Raw Timestamp / TimestampScale_factor)`, which will result in the
following for our example: `Absolute Timestamp = round(1186848073 / 22675) = round(52341.7011245866) = 52342`.
This number is the one the application has to write to the file.

Now our file is complete, and we want to play it back with another application.
Its task is to find out which sample the first application wrote into the file.
So it starts reading the Matroska file and finds the `TimestampScale` factor 22675 and
the audio sample rate 44100. Later it finds a data block with the `Absolute Timestamp` of 52342.
But how does it get the sample number from these numbers?

First it has to calculate the `Raw Timestamp` of the block it has just read. Here's no
rounding involved, just an integer multiplication: `Raw Timestamp = Absolute Timestamp * TimestampScale_factor`.
In our example: `Raw Timestamp = 52342 * 22675 = 1186854850`.

The conversion from the `Raw Timestamp` to the sample number again requires rounding:
`sample_number = round(Raw Timestamp * sample_rate / 1000000000)`.
In our example: `sample_number = round(1186854850 * 44100 / 1000000000) = round(52340.298885) = 52340`.
This is exactly the sample number that the previous program started with.

Some general notes for a program:

1. Always calculate the timestamps / sample numbers with floating point numbers of at least
   64bit precision (called 'double' in most modern programming languages).
   If you're calculating with integers, then make sure they're 64bit long, too.
2. Always round if you divide. Always! If you don't you'll end up with situations in which
   you have a timestamp in the Matroska file that does not correspond to the sample number
   that it started with. Using a slightly lower timestamp scale factor can help here in
   that it removes the need for proper rounding in the conversion from sample number to `Raw Timestamp`.

## TrackTimestampScale

The `TrackTimestampScale Element` is used align tracks that would otherwise be played at
different speeds. An example of this would be if you have a film that was originally recorded
at 24fps video. When playing this back through a PAL broadcasting system, it is standard to
speed up the film to 25fps to match the 25fps display speed of the PAL broadcasting standard.
However, when broadcasting the video through NTSC, it is typical to leave the film at its
original speed. If you wanted to make a single file where there was one video stream,
and an audio stream used from the PAL broadcast, as well as an audio stream used from the NTSC
broadcast, you would have the problem that the PAL audio stream would be 1/24th faster than
the NTSC audio stream, quickly leading to problems. It is possible to stretch out the PAL
audio track and re-encode it at a slower speed, however when dealing with lossy audio codecs,
this often results in a loss of audio quality and/or larger file sizes.

This is the type of problem that `TrackTimestampScale` was designed to fix. Using it,
the video can be played back at a speed that will synch with either the NTSC or the PAL
audio stream, depending on which is being used for playback.
To continue the above example:

    Track 1: Video
    Track 2: NTSC Audio
    Track 3: PAL Audio

Because the NTSC track is at the original speed, it will used as the default value of 1.0 for
its `TrackTimestampScale`. The video will also be aligned to the NTSC track with the default value of 1.0.

The `TrackTimestampScale` value to use for the PAL track would be calculated by
determining how much faster the PAL track is than the NTSC track. In this case,
because we know the video for the NTSC audio is being played back at 24fps and the video
for the PAL audio is being played back at 25fps, the calculation would be:

25/24 is almost 1.04166666666666666667

When writing a file that uses a non-default `TrackTimestampScale`, the values of the `Block`'s
timestamp are whatever they would be when normally storing the track with a default value for
the `TrackTimestampScale`. However, the data is interleaved a little differently.
Data **SHOULD** be interleaved by its Raw Timestamp, see (#raw-timestamp), in the order handed back
from the encoder. The `Raw Timestamp` of a `Block` from a track using `TrackTimestampScale`
is calculated using:

`(Block's Timestamp + Cluster's Timestamp) * TimestampScale * TrackTimestampScale `

So, a Block from the PAL track above that had a Scaled Timestamp, see (#timestampscale), of 100
seconds would have a `Raw Timestamp` of 104.66666667 seconds, and so would be stored in that
part of the file.

When playing back a track using the `TrackTimestampScale`, if the track is being played by itself,
there is no need to scale it. From the above example, when playing the Video with the NTSC Audio,
neither are scaled. However, when playing back the Video with the PAL Audio, the timestamps
from the PAL Audio track are scaled using the `TrackTimestampScale`, resulting in the video
playing back in synch with the audio.

It would be possible for a `Matroska Player` to also adjust the audio's samplerate at the
same time as adjusting the timestamps if you wanted to play the two audio streams synchronously.
It would also be possible to adjust the video to match the audio's speed. However,
for playback, the selected track(s) timestamps **SHOULD** be adjusted if they need to be scaled.

While the above example deals specifically with audio tracks, this element can be used
to align video, audio, subtitles, or any other type of track contained in a Matroska file.

# Encryption

Encryption in Matroska is designed in a very generic style to allow people to
implement whatever form of encryption is best for them. It is possible to use the
encryption framework in Matroska as a type of DRM (Digital Rights Management).

Because encryption occurs within the `Block Element`, it is possible to manipulate
encrypted streams without decrypting them. The streams could potentially be copied,
deleted, cut, appended, or any number of other possible editing techniques without
decryption. The data can be used without having to expose it or go through the decrypting process.

Encryption can also be layered within Matroska. This means that two completely different
types of encryption can be used, requiring two separate keys to be able to decrypt a stream.

Encryption information is stored in the `ContentEncodings Element` under the `ContentEncryption Element`.

# Image Presentation

## Cropping

The `PixelCrop Elements` (`PixelCropTop`, `PixelCropBottom`, `PixelCropRight`, and `PixelCropLeft`)
indicate when, and by how much, encoded videos frames **SHOULD** be cropped for display.
These Elements allow edges of the frame that are not intended for display, such as the
sprockets of a full-frame film scan or the VANC area of a digitized analog videotape,
to be stored but hidden. `PixelCropTop` and `PixelCropBottom` store an integer of how many
rows of pixels **SHOULD** be cropped from the top and bottom of the image (respectively).
 `PixelCropLeft` and `PixelCropRight` store an integer of how many columns of pixels
 **SHOULD** be cropped from the left and right of the image (respectively). For example,
 a pillar-boxed video that stores a 1440x1080 visual image within the center of a padded
 1920x1080 encoded image **MAY** set both `PixelCropLeft` and `PixelCropRight` to "240",
 so that a `Matroska Player` **SHOULD** crop off 240 columns of pixels from the left and
 right of the encoded image to present the image with the pillar-boxes hidden.

## Rotation

The ProjectionPoseRoll Element (see (#projectionposeroll-element)) can be used to indicate
that the image from the associated video track **SHOULD** be rotated for presentation.
For instance, the following representation of the Projection Element (#projection-element))
and the ProjectionPoseRoll Element represents a video track where the image **SHOULD** be
presentation with a 90 degree counter-clockwise rotation.

```xml
<Projection>
  <ProjectionPoseRoll>90</ProjectionPoseRoll>
</Projection>
```
Figure: Rotation example.

# Matroska versioning

The `EBML Header` of each Matroska document informs the reading application on what
version of Matroska to expect. The `Elements` within `EBML Header` with jurisdiction
over this information are `DocTypeVersion` and `DocTypeReadVersion`.

`DocTypeVersion` **MUST** be equal to or greater than the highest Matroska version number of
any `Element` present in the Matroska file. For example, a file using the `SimpleBlock Element`
**MUST** have a `DocTypeVersion` equal to or greater than 2. A file containing `CueRelativePosition`
Elements **MUST** have a `DocTypeVersion` equal to or greater than 4.

The `DocTypeReadVersion` **MUST** contain the minimum version number that a reading application
can minimally support in order to play the file back -- optionally with a reduced feature
set. For example, if a file contains only `Elements` of version 2 or lower except for
`CueRelativePosition` (which is a version 4 Matroska `Element`), then `DocTypeReadVersion`
**SHOULD** still be set to 2 and not 4 because evaluating `CueRelativePosition` is not
necessary for standard playback -- it makes seeking more precise if used.

`DocTypeVersion` **MUST** always be equal to or greater than `DocTypeReadVersion`.

A reading application supporting Matroska version `V` **MUST NOT** refuse to read an
application with `DocReadTypeVersion` equal to or lower than `V` even if `DocTypeVersion`
is greater than `V`. See also the note about Unknown Elements in (#unknown-elements).

# File Extensions

The file extensions for Matroska files are usually as follows:

* ".mkv" for files containing video tracks
* ".mka" for files containing audio tracks with no video tracks
* ".mk3d" for files containing some stereoscopic video tracks

# Segment Position

The `Segment Position` of an `Element` refers to the position of the first octet of the
`Element ID` of that `Element`, measured in octets, from the beginning of the `Element Data`
section of the containing `Segment Element`. In other words, the `Segment Position` of an
`Element` is the distance in octets from the beginning of its containing `Segment Element`
minus the size of the `Element ID` and `Element Data Size` of that `Segment Element`.
The `Segment Position` of the first `Child Element` of the `Segment Element` is 0.
An `Element` which is not stored within a `Segment Element`, such as the `Elements` of
the `EBML Header`, do not have a `Segment Position`.

## Segment Position Exception

`Elements` that are defined to store a `Segment Position` **MAY** define reserved values to
indicate a special meaning.

## Example of Segment Position

This table presents an example of `Segment Position` by showing a hexadecimal representation
of a very small Matroska file with labels to show the offsets in octets. The file contains
a `Segment Element` with an `Element ID` of "0x18538067" and a `MuxingApp Element` with an `Element ID` of "0x4D80".

         0                             1                             2
         0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
       0 |1A|45|DF|A3|8B|42|82|88|6D|61|74|72|6F|73|6B|61|18|53|80|67|
      20 |93|15|49|A9|66|8E|4D|80|84|69|65|74|66|57|41|84|69|65|74|66|

In the above example, the `Element ID` of the `Segment Element` is stored at offset 16,
the `Element Data Size` of the `Segment Element` is stored at offset 20, and the
`Element Data` of the `Segment Element` is stored at offset 21.

The `MuxingApp Element` is stored at offset 26. Since the `Segment Position` of
an `Element` is calculated by subtracting the position of the `Element Data` of
the containing `Segment Element` from the position of that `Element`, the `Segment Position`
of `MuxingApp Element` in the above example is '26 - 21' or '5'.



# Linked Segments

Matroska provides several methods to link two or more `Segment Elements` together to create
a `Linked Segment`. A `Linked Segment` is a set of multiple `Segments` linked together into
a single presentation by using Hard Linking or Medium Linking.

All `Segments` within a `Linked Segment` **MUST** have a `SegmentUID`.

All `Segments` within a `Linked Segment` **SHOULD** be stored within the same directory
or be accessible quickly based on their `SegmentUID`
in order to have seamless transition between segments.

All `Segments` within a `Linked Segment` **MAY** set a `SegmentFamily` with a common value to make
it easier for a `Matroska Player` to know which `Segments` are meant to be played together.

The `SegmentFilename`, `PrevFilename` and `NextFilename` elements **MAY** also give hints on
the original filenames that were used when the Segment links were created, in case some `SegmentUID` are damaged.

## Hard Linking

Hard Linking, also called splitting, is the process of creating a `Linked Segment`
by linking multiple `Segment Elements` using the `NextUID` and `PrevUID` Elements.

All `Segments` within a `Hard Linked Segment` **MUST** use the same `Tracks` list and `TimestampScale`.

Within a `Linked Segment`, the timestamps of `Block` and `SimpleBlock` **MUST** follow consecutively
the timestamps of `Block` and `SimpleBlock` from the previous `Segment` in linking order.

With Hard Linking, the chapters of any `Segment` within the `Linked Segment` **MUST** only reference the current `Segment`.
The `NextUID` and `PrevUID` reference the respective `SegmentUID` values of the next and previous `Segments`.

The first `Segment` of a `Linked Segment` **MUST NOT** have a `PrevUID Element`.
The last `Segment` of a `Linked Segment` **MUST NOT** have a `NextUID Element`.

For each node of the chain of `Segments` of a `Linked Segment` at least one `Segment` **MUST** reference the other `Segment` of the node.

In a chain of `Segments` of a `Linked Segment` the `NextUID` always takes precedence over the `PrevUID`.
So if SegmentA has a `NextUID` to SegmentB and SegmentB has a `PrevUID` to SegmentC,
the link to use is `NextUID` between SegmentA and SegmentB, SegmentC is not part of the Linked Segment.

If SegmentB has a `PrevUID` to SegmentA but SegmentA has no `NextUID`, then the Matroska Player
**MAY** consider these two Segments linked as SegmentA followed by SegmentB.

As an example, three `Segments` can be Hard Linked as a `Linked Segment` through
cross-referencing each other with `SegmentUID`, `PrevUID`, and `NextUID`, as in this table:

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | Invalid
Table: Usual Hard Linking UIDs{#hardLinkingUIDs}

An other example where only the `NextUID` Element is used:

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | n/a                               | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | Invalid
Table: Hard Linking without PrevUID{#hardLinkingWoPrevUID}

An example where only the `PrevUID` Element is used:

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | n/a
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | Invalid
Table: Hard Linking without NextUID{#hardLinkingWoNextUID}

In this example only the `middle.mkv` is using the `PrevUID` and `NextUID` Elements:

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | Invalid
Table: Hard Linking with mixed UID links{#hardLinkingMixedUIDs}

## Medium Linking

Medium Linking creates relationships between `Segments` using Ordered Chapters ((#editionflagordered)) and the
`ChapterSegmentUID Element`. A `Chapter Edition` with Ordered Chapters **MAY** contain
Chapter elements that reference timestamp ranges from other `Segments`. The `Segment`
referenced by the Ordered Chapter via the `ChapterSegmentUID Element` **SHOULD** be played as
part of a Linked Segment.

The timestamps of Segment content referenced by Ordered Chapters
**MUST** be adjusted according to the cumulative duration of the the previous Ordered Chapters.

As an example a file named `intro.mkv` could have a `SegmentUID` of "0xb16a58609fc7e60653a60c984fc11ead".
Another file called `program.mkv` could use a Chapter Edition that contains two Ordered Chapters.
The first chapter references the `Segment` of `intro.mkv` with the use of a `ChapterSegmentUID`,
`ChapterSegmentEditionUID`, `ChapterTimeStart`, and optionally a `ChapterTimeEnd` element.
The second chapter references content within the `Segment` of `program.mkv`. A `Matroska Player`
**SHOULD** recognize the `Linked Segment` created by the use of `ChapterSegmentUID` in an enabled
`Edition` and present the reference content of the two `Segments` as a single presentation.

The `ChapterSegmentUID` represents the Segment that holds the content to play in place of the `Linked Chapter`.
The `ChapterSegmentUID` **MUST NOT** be the `SegmentUID` of its own `Segment`.

There are 2 ways to use a chapter link:
* Linked-Duration linking,
* Linked-Edition linking

### Linked-Duration

A `Matroska Player` **MUST** play the content of the linked Segment
from the `ChapterTimeStart` until `ChapterTimeEnd` timestamp in place of the `Linked Chapter`.

`ChapterTimeStart` and `ChapterTimeEnd` represent timestamps in the Linked Segment matching the value of `ChapterSegmentUID`.
Their values **MUST** be in the range of the linked Segment duration.

The `ChapterTimeEnd` value **MUST** be set when using linked-duration chapter linking.
`ChapterSegmentEditionUID` **MUST NOT** be set.

### Linked-Edition

A `Matroska Player` **MUST** play the whole linked `Edition` of the linked Segment in place of the `Linked Chapter`.

`ChapterSegmentEditionUID` represents a valid Edition from the Linked Segment matching the value of `ChapterSegmentUID`.

When using linked-edition chapter linking. `ChapterTimeEnd` **MUST NOT** be set.



# Track Flags

## Default flag

The "default track" flag is a hint for a `Matroska Player` indicating that a given track
**SHOULD** be eligible to be automatically selected as the default track for a given
language. If no tracks in a given language have the default track flag set, then all tracks
in that language are eligible for automatic selection. This can be used to indicate that
a track provides "regular service" suitable for users with default settings, as opposed to
specialized services, such as commentary, hearing-impaired captions, or descriptive audio.

The `Matroska Player` **MAY** override the "default track" flag for any reason, including
user preferences to prefer tracks providing accessibility services.

## Forced flag

The "forced" flag tells the `Matroska Player` that it **SHOULD** display this subtitle track,
even if user preferences usually would not call for any subtitles to be displayed alongside
the current selected audio track. This can be used to indicate that a track contains translations
of onscreen text, or of dialogue spoken in a different language than the track's primary one.

## Hearing-impaired flag

The "hearing impaired" flag tells the `Matroska Player` that it **SHOULD** prefer this track
when selecting a default track for a hearing-impaired user, and that it **MAY** prefer to select
a different track when selecting a default track for a non-hearing-impaired user.

## Visual-impaired flag

The "visual impaired" flag tells the `Matroska Player` that it **SHOULD** prefer this track
when selecting a default track for a visually-impaired user, and that it **MAY** prefer to select
a different track when selecting a default track for a non-visually-impaired user.

## Descriptions flag

The "descriptions" flag tells the `Matroska Player` that this track is suitable to play via
a text-to-speech system for a visually-impaired user, and that it **SHOULD NOT** automatically
select this track when selecting a default track for a non-visually-impaired user.

## Original flag

The "original" flag tells the `Matroska Player` that this track is in the original language,
and that it **SHOULD** prefer it if configured to prefer original-language tracks of this
track's type.

## Commentary flag

The "commentary" flag tells the `Matroska Player` that this track contains commentary on
the content.

## Track Operation

`TrackOperation` allows combining multiple tracks to make a virtual one. It uses
two separate system to combine tracks. One to create a 3D "composition" (left/right/background planes)
and one to simplify join two tracks together to make a single track.

A track created with `TrackOperation` is a proper track with a UID and all its flags.
However the codec ID is meaningless because each "sub" track needs to be decoded by its
own decoder before the "operation" is applied. The `Cues Elements` corresponding to such
a virtual track **SHOULD** be the sum of the `Cues Elements` for each of the tracks it's composed of (when the `Cues` are defined per track).

In the case of `TrackJoinBlocks`, the `Block Elements` (from `BlockGroup` and `SimpleBlock`)
of all the tracks **SHOULD** be used as if they were defined for this new virtual `Track`.
When two `Block Elements` have overlapping start or end timestamps, it's up to the underlying
system to either drop some of these frames or render them the way they overlap.
This situation **SHOULD** be avoided when creating such tracks as you can never be sure
of the end result on different platforms.

## Overlay Track

Overlay tracks **SHOULD** be rendered in the same channel as the track its linked to.
When content is found in such a track, it **SHOULD** be played on the rendering channel
instead of the original track.

## Multi-planar and 3D videos

There are two different ways to compress 3D videos: have each eye track in a separate track
and have one track have both eyes combined inside (which is more efficient, compression-wise).
Matroska supports both ways.

For the single track variant, there is the `StereoMode Element`, which defines how planes are
assembled in the track (mono or left-right combined). Odd values of StereoMode means the left
plane comes first for more convenient reading. The pixel count of the track (`PixelWidth`/`PixelHeight`)
is the raw amount of pixels, for example 3840x1080 for full HD side by side, and the `DisplayWidth`/`DisplayHeight`
in pixels is the amount of pixels for one plane (1920x1080 for that full HD stream).
Old stereo 3D were displayed using anaglyph (cyan and red colors separated).
For compatibility with such movies, there is a value of the StereoMode that corresponds to AnaGlyph.

There is also a "packed" mode (values 13 and 14) which consists of packing two frames together
in a `Block` using lacing. The first frame is the left eye and the other frame is the right eye
(or vice versa). The frames **SHOULD** be decoded in that order and are possibly dependent
on each other (P and B frames).

For separate tracks, Matroska needs to define exactly which track does what.
`TrackOperation` with `TrackCombinePlanes` do that. For more details look at
(#track-operation) on how TrackOperation works.

The 3D support is still in infancy and may evolve to support more features.

The StereoMode used to be part of Matroska v2 but it didn't meet the requirement
for multiple tracks. There was also a bug in libmatroska prior to 0.9.0 that would save/read
it as 0x53B9 instead of 0x53B8. `Matroska Readers` may support these legacy files by checking
Matroska v2 or 0x53B9. The older values were 0: mono, 1: right eye, 2: left eye, 3: both eyes.


# Default track selection

This section provides some example sets of Tracks and hypothetical user settings, along with
indications of which ones a similarly-configured `Matroska Player` **SHOULD** automatically
select for playback by default in such a situation. A player **MAY** provide additional settings
with more detailed controls for more nuanced scenarios. These examples are provided as guidelines
to illustrate the intended usages of the various supported Track flags, and their expected behaviors.

Track names are shown in English for illustrative purposes; actual files may have titles
in the language of each track, or provide titles in multiple languages.

## Audio Selection

Example track set:

| No. | Type  | Lang | Layout | Original | Default | Other flags     | Name                  |
| --- | ----- | ---- | ------ | -------- | ------- | --------------- | --------------------- |
| 1   | Video | und  | N/A    | N/A      | N/A     | None            |                       |
| 2   | Audio | eng  | 5.1    | 1        | 1       | None            |                       |
| 3   | Audio | eng  | 2.0    | 1        | 1       | None            |                       |
| 4   | Audio | eng  | 2.0    | 1        | 0       | Visual-impaired | Descriptive audio     |
| 5   | Audio | esp  | 5.1    | 0        | 1       | None            |                       |
| 6   | Audio | esp  | 2.0    | 0        | 0       | Visual-impaired | Descriptive audio     |
| 7   | Audio | eng  | 2.0    | 1        | 0       | Commentary      | Director's Commentary |
| 8   | Audio | eng  | 2.0    | 1        | 0       | None            | Karaoke               |
Table: Audio Tracks for default selection{#audioTrackSelection}

Here we have a file with 7 audio tracks, of which 5 are in English and 2 are in Spanish.

The English tracks all have the Original flag, indicating that English is the original content language.

Generally the player will first consider the track languages: if the player has an option to prefer
original-language audio and the user has enabled it, then it should prefer one of the Original-flagged tracks.
If configured to specifically prefer audio tracks in English or Spanish, the player should select one of
the tracks in the corresponding language. The player may also wish to prefer an Original-flagged track
if no tracks matching any of the user's explicitly-preferred languages are available.

Two of the tracks have the Visual-impaired flag. If the player has been configured to prefer such tracks,
it should select one; otherwise, it should avoid them if possible.

If selecting an English track, when other settings have left multiple possible options,
it may be useful to exclude the tracks that lack the Default flag: here, one provides descriptive service for
the visually impaired (which has its own flag and may be automatically selected by user configuration,
but is unsuitable for users with default-configured players), one is a commentary track
(which has its own flag, which the player may or may not have specialized handling for),
and the last contains karaoke versions of the music that plays during the film, which is an unusual
specialized audio service that Matroska has no built-in support for indicating, so it's indicated
in the track name instead. By not setting the Default flag on these specialized tracks, the file's author
hints that they should not be automatically selected by a default-configured player.

Having narrowed its choices down, our example player now may have to select between tracks 2 and 3.
The only difference between these tracks is their channel layouts: 2 is 5.1 surround, while 3 is stereo.
If the player is aware that the output device is a pair of headphones or stereo speakers, it may wish
to prefer the stereo mix automatically. On the other hand, if it knows that the device is a surround system,
it may wish to prefer the surround mix.

If the player finishes analyzing all of the available audio tracks and finds that multiple seem equally
and maximally preferable, it **SHOULD** default to the first of the group.

## Subtitle selection

Example track set:

| No. | Type      | Lang  | Original | Default | Forced | Other flags      | Name                               |
| --- | --------- | ----  | -------- | ------- | ------ | ---------------- | ---------------------------------- |
| 1   | Video     | und   | N/A      | N/A     | N/A    | None             |                                    |
| 2   | Audio     | fra   | 1        | 1       | N/A    | None             |                                    |
| 3   | Audio     | por   | 0        | 1       | N/A    | None             |                                    |
| 4   | Subtitles | fra   | 1        | 1       | 0      | None             |                                    |
| 5   | Subtitles | fra   | 1        | 0       | 0      | Hearing-impaired | Captions for the hearing-impaired  |
| 6   | Subtitles | por   | 0        | 1       | 0      | None             |                                    |
| 7   | Subtitles | por   | 0        | 0       | 1      | None             | Signs                              |
| 8   | Subtitles | por   | 0        | 0       | 0      | Hearing-impaired | SDH                                |
Table: Subtitle Tracks for default selection{#subtitleTrackSelection}

Here we have 2 audio tracks and 5 subtitle tracks. As we can see, French is the original language.

We'll start by discussing the case where the user prefers French (or Original-language)
audio (or has explicitly selected the French audio track), and also prefers French subtitles.

In this case, if the player isn't configured to display captions when the audio matches their
preferred subtitle languages, the player doesn't need to select a subtitle track at all.

If the user _has_ indicated that they want captions to be displayed, the selection simply
comes down to whether Hearing-impaired subtitles are preferred.

The situation for a user who prefers Portuguese subtitles starts out somewhat analogous.
If they select the original French audio (either by explicit audio language preference,
preference for Original-language tracks, or by explicitly selecting that track), then the
selection once again comes down to the hearing-impaired preference.

However, the case where the Portuguese audio track is selected has an important catch:
a Forced track in Portuguese is present. This may contain translations of onscreen text
from the video track, or of portions of the audio that are not translated (music, for instance).
This means that even if the user's preferences wouldn't normally call for captions here,
the Forced track should be selected nonetheless, rather than selecting no track at all.
On the other hand, if the user's preferences _do_ call for captions, the non-Forced tracks
should be preferred, as the Forced track will not contain captioning for the dialogue.

