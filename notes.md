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


# Default Values

The default value of an `Element` is assumed when not present in the data stream.
It is assumed only in the scope of its `Parent Element`. For example, the `Language Element`
is in the scope of the `Track Element`. If the `Parent Element` is not present or assumed,
then the `Child Element` cannot be assumed.

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

## Lacing

Lacing is a mechanism to save space when storing data. It is typically used for small blocks
of data (referred to as frames in Matroska). There are 3 types of lacing:

1. Xiph, inspired by what is found in the Ogg container
2. EBML, which is the same with sizes coded differently
3. fixed-size, where the size is not coded

For example, a user wants to store 3 frames of the same track. The first frame is 800 octets long,
the second is 500 octets long and the third is 1000 octets long. As these data are small,
they can be stored in a lace to save space. They will then be stored in the same block as follows:

### Xiph lacing

*   Block head (with lacing bits set to 01)
*   Lacing head: Number of frames in the lace -1 -- i.e. 2 (the 800 and 500 octets one)
*   Lacing sizes: only the 2 first ones will be coded, 800 gives 255;255;255;35, 500 gives
    255;245\. The size of the last frame is deduced from the total size of the Block.
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3

A frame with a size multiple of 255 is coded with a 0 at the end of the size -- for example, 765 is coded 255;255;255;0.

### EBML lacing

In this case, the size is not coded as blocks of 255 bytes, but as a difference with the previous size
and this size is coded as in EBML. The first size in the lace is unsigned as in EBML.
The others use a range shifting to get a sign on each value:

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

*   Block head (with lacing bits set to 11)
*   Lacing head: Number of frames in the lace -1 -- i.e. 2 (the 800 and 500 octets one)
*   Lacing sizes: only the 2 first ones will be coded, 800 gives 0x320 0x4000 = 0x4320,
    500 is coded as -300 : - 0x12C + 0x1FFF + 0x4000 = 0x5ED3\.
    The size of the last frame is deduced from the total size of the Block.
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3

### Fixed-size lacing

In this case, only the number of frames in the lace is saved, the size of each frame is deduced
from the total size of the Block. For example, for 3 frames of 800 octets each:

*   Block head (with lacing bits set to 10)
*   Lacing head: Number of frames in the lace -1 -- i.e. 2
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3


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

### Laced Data

When lacing bit is set.

| Offset      | Player | Description |
|:------------|:-------|:------------|
| 0x00        | **MUST** | Number of frames in the lace-1 (uint8) |
| 0x01 / 0xXX | **MUST**  | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |
Table: Lace sizes coded in the Block{#blockLacedSize}

For (possibly) Laced Data

| Offset      | Player | Description |
|:------------|:-------|:------------|
| 0x00        | **MUST** | Consecutive laced frames |
Table: Lace data after lace sizes{#blockLacedData}

# Timestamps

Historically timestamps in Matroska were mistakenly called timecodes. The `Timestamp Element`
was called Timecode, the `TimestampScale Element` was called TimecodeScale, the
`TrackTimestampScale Element` was called TrackTimecodeScale and the
`ReferenceTimestamp Element` was called ReferenceTimeCode.

## Timestamp Types

* Absolute Timestamp = Block+Cluster
* Relative Timestamp = Block
* Scaled Timestamp = Block+Cluster
* Raw Timestamp = (Block+Cluster)\*TimestampScale\*TrackTimestampScale

## Block Timestamps

The `Block Element`'s timestamp **MUST** be a signed integer that represents the
`Raw Timestamp` relative to the `Cluster`'s `Timestamp Element`, multiplied by the
`TimestampScale Element`. See (#timestampscale) for more information.

The `Block Element`'s timestamp **MUST** be represented by a 16bit signed integer (sint16).
The `Block`'s timestamp has a range of -32768 to +32767 units. When using the default value
of the `TimestampScale Element`, each integer represents 1ms. The maximum time span of
`Block Elements` in a `Cluster` using the default `TimestampScale Element` of 1ms is 65536ms.

If a `Cluster`'s `Timestamp Element` is set to zero, it is possible to have `Block Elements`
with a negative `Raw Timestamp`. `Block Elements` with a negative `Raw Timestamp` are not valid.

## Raw Timestamp

The exact time of an object **SHOULD** be represented in nanoseconds. To find out a `Block`'s
`Raw Timestamp`, you need the `Block`'s `Timestamp Element`, the `Cluster`'s `Timestamp Element`,
and the `TimestampScale Element`.

## TimestampScale

The `TimestampScale Element` is used to calculate the `Raw Timestamp` of a `Block`.
The timestamp is obtained by adding the `Block`'s timestamp to the `Cluster`'s `Timestamp Element`,
and then multiplying that result by the `TimestampScale`. The result will be the `Block`'s `Raw Timestamp`
in nanoseconds. The formula for this would look like:

    (a + b) * c

    a = `Block`'s Timestamp
    b = `Cluster`'s Timestamp
    c = `TimestampScale`

For example, assume a `Cluster`'s `Timestamp` has a value of 564264, the `Block` has a `Timestamp`
of 1233, and the `TimestampScale Element` is the default of 1000000.

    (1233 + 564264) * 1000000 = 565497000000

So, the `Block` in this example has a specific time of 565497000000 in nanoseconds.
In milliseconds this would be 565497ms.

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

The `TrackTimestampScale Element` was originally designed to allow adjusting the Track tick
amount in nanosecond without having to remux the whole file.
This was an odd an unused feature because the further you get in the file,
the further the audio and video tracks would drift away.
In the end the matching audio and video Blocks would be in different Clusters.
This is why the `TrackTimestampScale Element` is rarely used and often not handled
at all in `Matroska Readers`.

It **MAY** however be used to have more accurate timestamps in the Blocks.

For example an audio track at 44100 Hz. Each sample lasts

    1,000,000,000 / 44100 = 22675.73696145125 ns

This is not an integer number that can be stored in Blocks.
But it is possible to get a better approximation than when `TrackTimestampScale` is "1.0".

For example with `TimestampScale` of "1", we could set `TrackTimestampScale` to "22675.73696145125".
The timestamp in a Block is then transformed into nanoseconds using this formula:

    signed timestamp * TimestampScale * TrackTimestampScale
    signed timestamp * 22675.73696145125

The range of a Block is from "-32768" to "+32767" Track Ticks.
Which is "-743038548.7528346" to "743015873.0158731" nanoseconds or "-0.743" to "0.743" seconds.
This is not enough for most use cases or too many Clusters would be necessary.
But fortunately audio samples are usually grouped together.
For example in [@?Vorbis] they are grouped by 64 to 8192 samples.
Giving at least a maximum range in a Cluster of

    (0.743 + 0.743) * 64 = 95.1 seconds

The `TrackTimestampScale` would be 22675.73696145125 * 64 = 1451247.16553288.

Even with a high sampling frequency of 352800 Hz with a codec that packs 40 samples per frames (Dolby TrueHD),
we still get a large maximum range in each Cluster:

    65535 * (1,000,000,000 / 352,800) * 40 = 7,43 s

The `TimestampScale` can still be the default value of "1,000,000",
as long as the `TrackTimestampScale` matches the duration of one or more samples:

    TimestampScale * TrackTimestampScale = 1,000,000,000 / 44100 ns
    TrackTimestampScale = 1,000,000,000 / 44100 / TimestampScale ns
    TrackTimestampScale = 1,000,000,000 / 44100 / 1,000,000
    TrackTimestampScale = 1,000 / 44100
    TrackTimestampScale = 0.02267573696145125

Storing the timestamp of audio sample number 152340 is slightly different that in (#timestampscale-rounding).

The real timestamp of that sample in nanoseconds is

    152340 * 1,000,000,000 / 44100 = 3454421768.707483 ns

We can store 152340. The `Matroska Reader` will then apply the formula:

    signed timestamp * TimestampScale * TrackTimestampScale
    152340 * 1,000,000 * 0.02267573696145125 ns
    3,454,421,768.707483 ns

Which is exactly the proper timestamp for that sample.
There is however a rounding involved as we can't store 152340 in a Block/SimpleBlock which has a range of 65535 Track Ticks.
The `Cluster\Timestamp` needs to be involved.

With a `TimestampScale` of "1,000,000" we could set the `Cluster\Timestamp` to "3454". Which is 3,454,000,000 ns.
The Block/SimpleBlock has to store the equivalent of "421,768.707483" ns. With a Track Tick of "22,675.73696145125" ns,
that represents "18.6" ticks. Which is either stored as "18" or "19" in the Block/SimpleBlock.

The `Matroska Reader` will then read the timestamp as

    3454 * 1,000,000 + 19 * 1,000,000 * 0.02267573696145125
    3,454,430,839.0023 ns

That's a difference of 9070.294817 ns, which is less than half the duration of a sample: 22675.73696145125 ns.
So any rounding will still end up on the proper sample.

The worst case scenario for rounding margin is if the Block/SimpleBlock that should be stored is exactly between two integers,
for example "18.5". The worst cast rounding error is "0.5" Track Ticks:

    0.5 * 1,000,000 * 0.02267573696145125
    0.5 * 1,000,000 * (1,000,000,000 / 44100 / 1,000,000)
    0.5 * (1,000,000,000 / 44100)
    0.5 sample duration in nanoseconds

To avoid this interdeminate state, the value stored in a Block/Simple should be the nearest integer
and 0.5 **MUST** use the lowest near integer.


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

# MIME Types

There is no IETF endorsed MIME type for Matroska files. These definitions can be used:

* .mka : Matroska audio `audio/x-matroska`
* .mkv : Matroska video `video/x-matroska`
* .mk3d : Matroska 3D video `video/x-matroska-3d`

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

Matroska provides several methods to link two or many `Segment Elements` together to create
a `Linked Segment`. A `Linked Segment` is a set of multiple `Segments` related together into
a single presentation by using Hard Linking, Medium Linking, or Soft Linking. All `Segments`
within a `Linked Segment` **MUST** utilize the same track numbers and timescale. All `Segments`
within a `Linked Segment` **MUST** be stored within the same directory. All `Segments`
within a `Linked Segment` **MUST** store a `SegmentUID`.

## Hard Linking

Hard Linking (also called splitting) is the process of creating a `Linked Segment`
by relating multiple `Segment Elements` using the `NextUID` and `PrevUID` Elements.
Within a `Linked Segment`, the timestamps of each `Segment` **MUST** follow consecutively
in linking order.
With Hard Linking, the chapters of any `Segment` within the `Linked Segment` **MUST**
only reference the current `Segment`. With Hard Linking, the `NextUID` and `PrevUID` **MUST**
reference the respective `SegmentUID` values of the next and previous `Segments`.
The first `Segment` of a `Linked Segment` **SHOULD** have a `NextUID Element` and **MUST NOT**
have a `PrevUID Element`.
The last `Segment` of a `Linked Segment` **SHOULD** have a `PrevUID Element` and **MUST NOT**
have a `NextUID Element`.
The middle `Segments` of a `Linked Segment` **SHOULD** have both a `NextUID Element`
and a `PrevUID Element`.

In a chain of `Linked Segments` the `NextUID` always takes precedence over the `PrevUID`.
So if SegmentA has a NextUID to SegmentB and SegmentB has a PrevUID to SegmentC,
the link to use is SegmentA to SegmentB.
If SegmentB has a PrevUID to SegmentA but SegmentA has no NextUID, then the Matroska Player
**MAY** consider these two Segments linked as SegmentA followed by SegmentB.

As an example, three `Segments` can be Hard Linked as a `Linked Segment` through
cross-referencing each other with `SegmentUID`, `PrevUID`, and `NextUID`, as in this table.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | n/a
Table: Usual Hard Linking UIDs{#hardLinkingUIDs}

An other example where only the `NextUID` Element is used.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | n/a                               | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | n/a
Table: Hard Linking without PrevUID{#hardLinkingWoPrevUID}

A next example where only the `PrevUID` Element is used.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | n/a
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | n/a
Table: Hard Linking without NextUID{#hardLinkingWoNextUID}

In this example only the `middle.mkv` is using the `PrevUID` and `NextUID` Elements.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | n/a
Table: Hard Linking with mixed UID links{#hardLinkingMixedUIDs}

## Medium Linking

Medium Linking creates relationships between `Segments` using Ordered Chapters and the
`ChapterSegmentUID Element`. A `Segment Edition` with Ordered Chapters **MAY** contain
Chapter elements that reference timestamp ranges from other `Segments`. The `Segment`
referenced by the Ordered Chapter via the `ChapterSegmentUID Element` **SHOULD** be played as
part of a Linked Segment. The timestamps of Segment content referenced by Ordered Chapters
**MUST** be adjusted according to the cumulative duration of the the previous Ordered Chapters.

As an example a file named `intro.mkv` could have a `SegmentUID` of "0xb16a58609fc7e60653a60c984fc11ead".
Another file called `program.mkv` could use a Chapter Edition that contains two Ordered Chapters.
The first chapter references the `Segment` of `intro.mkv` with the use of a `ChapterSegmentUID`,
`ChapterSegmentEditionUID`, `ChapterTimeStart`, and optionally a `ChapterTimeEnd` element.
The second chapter references content within the `Segment` of `program.mkv`. A `Matroska Player`
**SHOULD** recognize the `Linked Segment` created by the use of `ChapterSegmentUID` in an enabled
`Edition` and present the reference content of the two `Segments` together.

The `ChapterSegmentUID` is a binary value and the base element to set up a
`Linked Chapter` in 2 variations: the Linked-Duration linking and the Linked-Edition
linking. For both variations, the following 3 conditions **MUST** be met:

 1. The `EditionFlagOrdered Flag` **MUST** be true.
 2. The `ChapterSegmentUID` **MUST NOT** be the `SegmentUID` of its own `Segment`.
 3. The linked Segments **MUST** BE in the same folder.

### Variation 1: Linked-Duration

Two more conditions **MUST** be met:

 1. `ChapterTimeStart` and `ChapterTimeEnd` timestamps **MUST** be in the range of the
    linked Segment duration.
 2. `ChapterSegmentEditionUID` **MUST NOT** be set.

A `Matroska Player` **MUST** play the content of the linked Segment from the
`ChapterTimeStart` until `ChapterTimeEnd` timestamp.

### Variation 2: Linked-Edition

When the `ChapterSegmentEditionUID` is set to a valid `EditionUID` from the linked
Segment. A `Matroska Player` **MUST** play these linked `Edition`.

## Soft Linking

Soft Linking is used by codec chapters. They can reference another `Segment` and jump to
that `Segment`. The way the `Segments` are described are internal to the chapter codec and
unknown to the Matroska level. But there are `Elements` within the `Info Element`
(such as `ChapterTranslate`) that can translate a value representing a `Segment` in the
chapter codec and to the current `SegmentUID`. All `Segments` that could be used in a `Linked Segment`
in this way **SHOULD** be marked as members of the same family via the `SegmentFamily Element`,
so that the `Matroska Player` can quickly switch from one to the other.

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
Old stereo 3D were displayed using anaglyph (cyan and red colours separated).
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

