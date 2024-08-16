# Matroska Versioning

Matroska is based on the principle that a reading application does not have to support
100% of the specifications in order to be able to play the file. Therefore, a Matroska file
contains version indicators that tell a reading application what to expect.

It is possible and valid to have the version fields indicate that the file contains
Matroska elements from a higher specification version number while signaling that a
reading application **MUST** only support a lower version number properly in order to play
it back (possibly with a reduced feature set).

The `EBML Header` of each Matroska document informs the reading application on what
version of Matroska to expect. The elements within the `EBML Header` with jurisdiction
over this information are `DocTypeVersion` and `DocTypeReadVersion`.

`DocTypeVersion` **MUST** be equal to or greater than the highest Matroska version number of
any element present in the Matroska file. For example, a file using the `SimpleBlock` element ((#simpleblock-element))
**MUST** have a `DocTypeVersion` equal to or greater than 2. A file containing `CueRelativePosition`
elements  ((#cuerelativeposition-element)) **MUST** have a `DocTypeVersion` equal to or greater than 4.

The `DocTypeReadVersion` **MUST** contain the minimum version number that a reading application
can minimally support in order to play the file back -- optionally with a reduced feature
set. For example, if a file contains only elements of version 2 or lower except for
`CueRelativePosition` (which is a version 4 Matroska element), then `DocTypeReadVersion`
**SHOULD** still be set to 2 and not 4 because evaluating `CueRelativePosition` is not
necessary for standard playback -- it makes seeking more precise if used.

A reading application supporting Matroska version `V` **MUST NOT** refuse to read a
file with `DocReadTypeVersion` equal to or lower than `V`, even if `DocTypeVersion`
is greater than `V`.

A reading application
supporting at least Matroska version `V` and reading a file whose `DocTypeReadVersion`
field is equal to or lower than `V` **MUST** skip Matroska/EBML elements it encounters
but does not know about if that unknown element fits into the size constraints set
by the current `Parent Element`.

# Stream Copy

It is sometimes necessary to create a Matroska file from another Matroska file, for example, to add subtitles in a language
or to edit out a portion of the content.
Some values from the original Matroska file need to be kept the same in the destination file.
For example, the SamplingFrequency of an audio track wouldn't change between the two files.
Some other values may change between the two files, for example, the TrackNumber of an audio track when another track has been added.

An element is marked with a property "`stream copy: True`" when the values of that element need to be kept identical between the source and destination files.
If that property is not set, elements may or may not keep the same value between the source and destination files.

# DefaultDecodedFieldDuration

The `DefaultDecodedFieldDuration` element can signal to the displaying application how
often fields of a video sequence will be available for displaying. It can be used for both
interlaced and progressive content.

If the video sequence is signaled as interlaced ((#flaginterlaced-element)), then `DefaultDecodedFieldDuration` equals
the period between two successive fields at the output of the decoding process.
For video sequences signaled as progressive, `DefaultDecodedFieldDuration` is half of
the period between two successive frames at the output of the decoding process.

These values are valid at the end of the decoding process before post-processing
(such as deinterlacing or inverse telecine) is applied.

Examples:

* Blu-ray movie:      1000000000 ns/(48/1.001) = 20854167 ns

* PAL broadcast/DVD:  1000000000 ns/(50/1.000) = 20000000 ns

* N/ATSC broadcast:   1000000000 ns/(60/1.001) = 16683333 ns

* Hard-telecined DVD: 1000000000 ns/(60/1.001) = 16683333 ns (60 encoded interlaced fields per second)

* Soft-telecined DVD: 1000000000 ns/(60/1.001) = 16683333 ns (48 encoded interlaced fields per second, with "repeat_first_field = 1")

# Cluster Blocks

Frames using references **SHOULD** be stored in "coding order" (i.e., the references first and then
the frames referencing them). A consequence is that timestamps might not be consecutive.
However, a frame with a past timestamp **MUST** reference a frame already known; otherwise, it is considered bad/void.

Matroska has two similar ways to store frames in a block:

* in a `Block` that is contained inside a `BlockGroup`

* in a `SimpleBlock` that is directly in the `Cluster`

The `SimpleBlock` is usually preferred unless some extra elements of the `BlockGroup` need to be used.
A `Matroska Reader` **MUST** support both types of blocks.

Each block contains the same parts in the following order:

* a variable-length header

* the lacing information (optional)

* the consecutive frame(s)

The block header starts with the number of the `Track` it corresponds to.
The value **MUST** correspond to the `TrackNumber` ((#tracknumber-element)) of a `TrackEntry` of the `Segment`.

The `TrackNumber` is coded using the Variable-Size Integer (VINT) mechanism described in [@!RFC8794, section 4].
To save space, the shortest VINT form **SHOULD** be used. The value can be coded using up to 8 octets.
This is the only element with a variable size in the block header.

The timestamp is expressed in Track Ticks; see (#timestamp-ticks).
The value is stored as a signed value on 16 bits.

## Block Structure

This section describes the binary data contained in the `Block` element ((#block-element)). Bit 0 is the most significant bit.

As the `TrackNumber` size can vary between 1 and 8 octets, there are 8 different sizes for the `Block` header.
The definitions for `TrackNumber` sizes of 1 and 2 are provided;
the other variants can be deduced by extending the size of the `TrackNumber` by multiples of 8 bits.

```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |               |                               |       |I|LAC|U|
 |  Track Number |         Timestamp             | Rsvrd |N|ING|N|
 |               |                               |       |V|   |U|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Figure: Block Header with 1-Octet TrackNumber

```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          Track Number         |         Timestamp             |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |       |I|LAC|U|
 | Rsvrd |N|ING|N|                     ...
 |       |V|   |U|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Figure: Block Header with 2-Octet TrackNumber

where:

{newline="false" spacing="normal"}
Track Number:
: 8, 16, 24, 32, 40, 48, or 56 bits. An EBML VINT-coded track number.

Timestamp:
: 16 bits. Signed timestamp in Track Ticks.

Rsvrd:
: 4 bits. Reserved bits **MUST** be set to 0.

INV:
: 1 bit. Invisible, The codec **SHOULD** decode this frame but not display it.

LACING:
: 2 bits. Uses lacing mode.
  00b:
  : no lacing ((#no-lacing))

  01b:
  : Xiph lacing ((#xiph-lacing))

  11b:
  : EBML lacing ((#ebml-lacing))

  10b:
  : fixed-size lacing ((#fixed-size-lacing))

UNU:
: 1 bit. Unused bit.

The remaining data in the `Block` corresponds to the lacing data and frames usage as described in each respective lacing mode (see (#block-lacing)).

## SimpleBlock Structure

This section describes the binary data contained in the `SimpleBlock` element ((#simpleblock-element)). Bit 0 is the most significant bit.

The `SimpleBlock` structure is inspired by the `Block` structure; see (#block-structure).
The main differences are the added Keyframe flag and Discardable flag. Otherwise, everything is the same.

As the `TrackNumber` size can vary between 1 and 8 octets, there are 8 different sizes for the `SimpleBlock` header.
The definitions for `TrackNumber` sizes of 1 and 2 are provided;
the other variants can be deduced by extending the size of the `TrackNumber` by multiples of 8 bits.

```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |               |                               |K|     |I|LAC|D|
 |  Track Number |         Timestamp             |E|Rsvrd|N|ING|I|
 |               |                               |Y|     |V|   |S|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Figure: SimpleBlock Header with 1-Octet TrackNumber

```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          Track Number         |         Timestamp             |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |K|     |I|LAC|D|
 |E|Rsvrd|N|ING|I|                     ...
 |Y|     |V|   |S|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Figure: SimpleBlock Header with 2-Octet TrackNumber

where:

{newline="false" spacing="normal"}
Track Number:
: 8, 16, 24, 32, 40, 48, or 56 bits. An EBML VINT-coded track number.

Timestamp:
: 16 bits. Signed timestamp in Track Ticks.

KEY:
: 1 bit. Keyframe. Set when the `Block` contains only keyframes.

Rsvrd:
: 3 bits. Reserved bits **MUST** be set to 0.

INV:
: 1 bit. Invisible, the codec **SHOULD** decode this frame but not display it.

LACING:
: 2 bits. Uses lacing mode.
  00b:
  : no lacing ((#no-lacing))

  01b:
  : Xiph lacing ((#xiph-lacing))

  11b:
  : EBML lacing ((#ebml-lacing))

  10b:
  : fixed-size lacing ((#fixed-size-lacing))

DIS:
: 1 bit. Discardable. The frames of the `Block` can be discarded during playing if needed.

The remaining data in the `SimpleBlock` corresponds to the lacing data and frames usage as described in each respective lacing mode (see (#block-lacing)).

## Block Lacing

Lacing is a mechanism to save space when storing data. It is typically used for small blocks
of data (referred to as frames in Matroska). It packs multiple frames into a single `Block` or `SimpleBlock`.

Lacing **MUST NOT** be used to store a single frame in a `Block` or `SimpleBlock`.

There are three types of lacing:

* Xiph, which is inspired by what is found in the Ogg container [@?RFC3533]

* EBML, which is the same with sizes coded differently

* Fixed-size, where the size is not coded

When lacing is not used, i.e., to store a single frame, the lacing bits (bits 5 and 6) of the `Block` or `SimpleBlock` **MUST** be set to zero.

For example, a user wants to store three frames of the same track. The first frame is 800 octets long,
the second is 500 octets long, and the third is 1000 octets long.
Because these frames are small,
they can be stored in a lace to save space.

It is possible to not use lacing at all and just store a single frame without any extra data.
When the `FlagLacing` ((#flaglacing-element)) is set to 0, all blocks of that track **MUST NOT** use lacing.

### No Lacing

When no lacing is used, the number of frames in the lace is omitted, and only one frame can be stored in the `Block`.
The LACING bits of the `Block` Header flags are set to `00b`.

The `Block` for an 800-octet frame is as follows:

| Block Octet  | Value   | Description             |
|:-------------|:--------|:------------------------|
| 4-803        | <frame> | Single frame data       |
Table: No Lacing{#blockNoLacing}

When a `Block` contains a single frame, it **MUST** use this "no lacing" mode.


### Xiph Lacing

The Xiph lacing uses the same coding of size as found in the Ogg container [@?RFC3533].
The LACING bits of the `Block` Header flags are set to `01b`.

The `Block` data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.

* Lacing size of each frame except the last one.

* Binary data of each frame consecutively.

The lacing size is split into 255 values, stored as unsigned octets -- for example, 500 is coded 255;245 or [0xFF 0xF5].
A frame with a size multiple of 255 is coded with a 0 at the end of the size -- for example, 765 is coded 255;255;255;0 or [0xFF 0xFF 0xFF 0x00].

The size of the last frame is deduced from the size remaining in the `Block` after the other frames.

Because large sizes result in large coding of the sizes, it is **RECOMMENDED** to use Xiph lacing only with small frames.

In our example, the 800-, 500-, and 1000-octet frames are stored with Xiph lacing in a `Block` as follows:

| Block Octets| Value | Description             |
|:------------|:------|:------------------------|
| 4           | 0x02  | Number of frames minus 1|
| 5-8         | 0xFF 0xFF 0xFF 0x23  | Size of the first frame (255;255;255;35)|
| 9-10        | 0xFF 0xF5  | Size of the second frame (255;245)|
| 11-810      |       | First frame data  |
| 811-1310    |       | Second frame data |
| 1311-2310   |       | Third frame data  |
Table: Xiph Lacing Example{#blockXiphLacing}

The `Block` is 2311 octets, and the last frame starts at 1311, so we can deduce that the size of the last frame is 2311 - 1311 = 1000.


### EBML Lacing

The EBML lacing encodes the frame size with an EBML-like encoding [@!RFC8794].
The LACING bits of the `Block` Header flags are set to `11b`.

The `Block` data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.

* Lacing size of each frame except the last one.

* Binary data of each frame consecutively.

The first frame size is encoded as an EBML VINT value.
The remaining frame sizes are encoded as signed values using the difference between the frame size and the previous frame size.
These signed values are encoded as VINT, with a mapping from signed to unsigned numbers.
Decoding the unsigned number stored in the VINT to a signed number is done by subtracting 2^((7*n)-1)^-1, where `n` is the octet size of the VINT.


Bit Representation of Signed VINT                       | Possible Value Range
:-------------------------------------------------------|:-------------------------------------
1xxx xxxx                                               | 2^7 values from -(2^6^-1) to 2^6^
01xx xxxx  xxxx xxxx                                    | 2^14 values from -(2^13^-1) to 2^13^
001x xxxx  xxxx xxxx  xxxx xxxx                         | 2^21 values from -(2^20^-1) to 2^20^
0001 xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx              | 2^28 values from -(2^27^-1) to 2^27^
0000 1xxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx   | 2^35 values from -(2^34^-1) to 2^34^
Table: EBML Lacing Signed VINT Bits Usage{#ebmlLacingBits}

In our example, the 800-, 500-, and 1000-octet frames are stored with EBML lacing in a `Block` as follows:

| Block Octets | Value | Description             |
|:-------------|:------|:------------------------|
| 4            | 0x02  | Number of frames minus 1|
| 5-6          | 0x43 0x20 | Size of the first frame (800 = 0x320 + 0x4000)|
| 7-8          | 0x5E 0xD3 | Size of the second frame (500 - 800 = -300 = - 0x12C + 0x1FFF + 0x4000)|
| 8-807        | <frame1>  | First frame data  |
| 808-1307     | <frame2>  | Second frame data |
| 1308-2307    | <frame3>  | Third frame data  |
Table: EBML Lacing Example{#blockEbmlLacing}

The `Block` is 2308 octets, and the last frame starts at 1308, so we can deduce that the size of the last frame is 2308 - 1308 = 1000.


### Fixed-size Lacing

Fixed-size lacing doesn't store the frame size; rather, it only stores the number of frames in the lace.
Each frame **MUST** have the same size. The frame size of each frame is deduced from the total size of the `Block`.
The LACING bits of the `Block` Header flags are set to `10b`.

The `Block` data with laced frames is stored as follows:

* Lacing Head on 1 Octet: Number of frames in the lace minus 1.

* Binary data of each frame consecutively.

For example, for three frames that are 800 octets each:

| Block Octets | Value    | Description             |
|:-------------|:---------|:------------------------|
| 4            | 0x02     | Number of frames minus 1|
| 5-804        | <frame1> | First frame data  |
| 805-1604     | <frame2> | Second frame data |
| 1605-2404    | <frame3> | Third frame data  |
Table: Fixed-Size Lacing Example{#blockFixedSizeLacing}

This gives a `Block` of 2405 octets. When reading the `Block`, we find that there are three frames (Octet 4).
The data start at Octet 5, so the size of each frame is (2405 - 5) / 3 = 800.


### Laced Frames Timestamp

A `Block` only contains a single timestamp value. But when lacing is used, it contains more than one frame.
Each frame originally has its own timestamp, or Presentation Timestamp (PTS). That timestamp applies to
the first frame in the lace.

In the lace, each frame after the first one has an underdetermined timestamp.
However, each of these frames **MUST** be contiguous -- i.e., the decoded data **MUST NOT** contain any gap
between them. If there is a gap in the stream, the frames around the gap **MUST NOT** be in the same `Block`.

Lacing is only useful for small contiguous data to save space. This is usually the case for audio tracks
and not the case for video (which use a lot of data) or subtitle tracks (which have long gaps).
For audio, there is usually a fixed output sampling frequency for the whole track,
so the decoder should be able to recover the timestamp of each sample, knowing each
output sample is contiguous with a fixed frequency.
For subtitles, this is usually not the case, so lacing **SHOULD NOT** be used.



## Random Access Points

Random Access Points (RAPs) are positions where the parser can seek to and start playback without decoding
what was before. In Matroska, `BlockGroups` and `SimpleBlocks` can be RAPs.
To seek to these elements, it is still necessary to seek to the `Cluster` containing them,
read the `Cluster` Timestamp,
and start playback from the `BlockGroup` or `SimpleBlock` that is a RAP.

Because a Matroska File is usually composed of multiple tracks playing at the same time
-- video, audio, and subtitles -- to seek properly to a RAP, each selected track must be
taken into account. Usually, all audio and subtitle `BlockGroups` or `SimpleBlocks` are RAPs.
They are independent of each other and can be played randomly.

On the other hand, video tracks often use references to previous and future frames for better
coding efficiency. Frames with such references **MUST** either contain one or more
`ReferenceBlock` elements in their `BlockGroup` or **MUST** be marked
as non-keyframe in a `SimpleBlock`; see (#simpleblock-structure).

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- References a Block 40 Track Ticks before this one --&gt;
    &lt;ReferenceBlock&gt;-40&lt;/ReferenceBlock&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: BlockGroup with a Frame That References Another Frame, with the EBML Tree Shown as XML

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;SimpleBlock/&gt; (octet 3 bit 0 not set)
  ...
&lt;/Cluster&gt;
```
Figure: SimpleBlock with a Frame That References Another Frame, with the EBML Tree Shown as XML

Frames that are RAPs (i.e., frames that don't depend on other frames) **MUST** set the keyframe
flag if they are in a `SimpleBlock` or their parent `BlockGroup` **MUST NOT** contain
a `ReferenceBlock`.

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- No ReferenceBlock allowed in this BlockGroup --&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: BlockGroup with a Frame That References No Other Frame, with the EBML Tree Shown as XML

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;SimpleBlock/&gt; (octet 3 bit 0 set)
  ...
&lt;/Cluster&gt;
```
Figure: SimpleBlock with a Frame That References No Other Frame, with the EBML Tree Shown as XML


There may be cases where the use of `BlockGroup` is necessary, as the frame may need a
`BlockDuration`, `BlockAdditions`, `CodecState`, or `DiscardPadding` element.
For those cases, a `SimpleBlock` **MUST NOT** be used;
the reference information **SHOULD** be recovered for non-RAP frames.

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;SimpleBlock/&gt; (octet 3 bit 0 not set)
  ...
&lt;/Cluster&gt;
```
Figure: SimpleBlock with a Frame That References Another Frame, with the EBML Tree Shown as XML

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- ReferenceBlock value recovered based on the codec --&gt;
    &lt;ReferenceBlock&gt;-40&lt;/ReferenceBlock&gt;
    &lt;BlockDuration&gt;20&lt;/BlockDuration&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: Same Frame That References Another Frame Put inside a `BlockGroup` to Add `BlockDuration`, with the EBML Tree Shown as XML

When a frame in a `BlockGroup` is not a RAP, the `BlockGroup` **MUST** contain at least a `ReferenceBlock`.
The `ReferenceBlock`s **MUST** be used in one of the following ways:

* each reference frame listed as a `ReferenceBlock`,

* some referenced frames listed as a `ReferenceBlock`, even if the timestamp value is accurate, or

* one `ReferenceBlock` with the timestamp value "0" corresponding to a self or unknown reference.

The lack of `ReferenceBlock` would mean such a frame is a RAP, and seeking on that
frame that actually depends on other frames may create a bogus output or even crash.

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- ReferenceBlock value not recovered from the codec --&gt;
    &lt;ReferenceBlock&gt;0&lt;/ReferenceBlock&gt;
    &lt;BlockDuration&gt;20&lt;/BlockDuration&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: Same Frame That References Another Frame Put inside a `BlockGroup`, but the Reference Could Not Be Recovered, with the EBML Tree Shown as XML

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- References a Block 80 Track Ticks before this one --&gt;
    &lt;ReferenceBlock&gt;-80&lt;/ReferenceBlock&gt;
    &lt;!-- References a Block 40 Track Ticks after this one --&gt;
    &lt;ReferenceBlock&gt;40&lt;/ReferenceBlock&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: `BlockGroup` with a Frame That References Two Other Frames, with the EBML Tree Shown as XML

Intra-only video frames, such as the ones found in AV1 or VP9, can be decoded without any other
frame, but they don't reset the codec state. Thus, seeking to these frames is not possible,
as the next frames may need frames that are not known from this seeking point.
Such intra-only frames **MUST NOT** be considered as keyframes, so the keyframe flag
**MUST NOT** be set in the `SimpleBlock` or a `ReferenceBlock` **MUST** be used
to signify the frame is not a RAP. The timestamp value of the `ReferenceBlock` **MUST**
be "0", meaning it's referencing itself.

```xml
&lt;Cluster&gt;
  &lt;Timestamp&gt;123456&lt;/Timestamp&gt;
  &lt;BlockGroup&gt;
    &lt;!-- References itself to mark it should not be used as RAP --&gt;
    &lt;ReferenceBlock&gt;0&lt;/ReferenceBlock&gt;
    &lt;Block/&gt;
  &lt;/BlockGroup&gt;
  ...
&lt;/Cluster&gt;
```
Figure: Intra-Only Frame (Not a RAP), with the EBML Tree Shown as XML

Because a video `SimpleBlock` has less information on references than a video `BlockGroup`,
it is possible to remux a video track using `BlockGroup` into a `SimpleBlock`,
as long as it doesn't use any other `BlockGroup` features than `ReferenceBlock`.


# Timestamps

Historically, timestamps in Matroska were mistakenly called timecodes. The `Timestamp` element
was called Timecode, the `TimestampScale` element was called TimecodeScale, the
`TrackTimestampScale` element was called TrackTimecodeScale, and the
`ReferenceTimestamp` element was called ReferenceTimeCode.

## Timestamp Ticks

All timestamp values in Matroska are expressed in multiples of a tick.
They are usually stored as integers.
There are three types of ticks possible: Matroska Ticks, Segment Ticks, and Track Ticks.

### Matroska Ticks

The timestamp value is stored directly in nanoseconds.

The elements storing values in Matroska Ticks/nanoseconds are:

* `TrackEntry\DefaultDuration`; defined in (#defaultduration-element)

* `TrackEntry\DefaultDecodedFieldDuration`; defined in (#defaultdecodedfieldduration-element)

* `TrackEntry\SeekPreRoll`; defined in (#seekpreroll-element)

* `TrackEntry\CodecDelay`; defined in (#codecdelay-element)

* `BlockGroup\DiscardPadding`; defined in (#discardpadding-element)

* `ChapterAtom\ChapterTimeStart`; defined in (#chaptertimestart-element)

* `ChapterAtom\ChapterTimeEnd`; defined in (#chaptertimeend-element)

### Segment Ticks

Elements in Segment Ticks involve the use of the `TimestampScale` element of the `Segment` to get the timestamp
in nanoseconds of the element, with the following formula:

    timestamp in nanosecond = element value * TimestampScale

This allows for storage of smaller integer values in the elements.

When using the default value of "1,000,000" for `TimestampScale`, one Segment Tick represents one millisecond.

The elements storing values in Segment Ticks are:

* `Cluster\Timestamp`; defined in (#timestamp-element)

* `Info\Duration` is stored as a floating-point, but the same formula applies; defined in (#duration-element)

* `CuePoint\CueTime`; defined in (#cuetime-element)

* `CuePoint\CueTrackPositions\CueDuration`; defined in (#cueduration-element)

* `CueReference\CueRefTime`; defined in (#cuetime-element)

### Track Ticks

Elements in Track Ticks involve the use of the `TimestampScale` element of the `Segment` and the `TrackTimestampScale` element of the `Track`
to get the timestamp in nanoseconds of the element, with the following formula:

    timestamp in nanoseconds =
        element value * TrackTimestampScale * TimestampScale

This allows for storage of smaller integer values in the elements.
The resulting floating-point values of the timestamps are still expressed in nanoseconds.

When using the default values of "1,000,000" for `TimestampScale` and "1.0" for `TrackTimestampScale`, one Track Tick represents one millisecond.

The elements storing values in Track Ticks are:

* `Cluster\BlockGroup\Block` and `Cluster\SimpleBlock` timestamps; detailed in (#block-timestamps)

* `Cluster\BlockGroup\BlockDuration`; defined in (#blockduration-element)

* `Cluster\BlockGroup\ReferenceBlock`; defined in (#referenceblock-element)

When the `TrackTimestampScale` is interpreted as "1.0", Track Ticks are equivalent to Segment Ticks
and give an integer value in nanoseconds. This is the most common case as `TrackTimestampScale` is usually omitted.

A value of `TrackTimestampScale` other than "1.0" **MAY** be used
to scale the timestamps more in tune with each `Track` sampling frequency.
For historical reasons, a lot of `Matroska Readers` don't take the `TrackTimestampScale` value into account.
Thus, using a value other than "1.0" might not work in many places.

## Block Timestamps

A `Block` element and `SimpleBlock` element timestamp is the time when the decoded data of the first
frame in the `Block`/`SimpleBlock` **MUST** be presented if the track of that `Block`/`SimpleBlock` is selected for playback.
This is also known as the Presentation Timestamp (PTS).

The `Block` element and `SimpleBlock` element store their timestamps as signed integers, relative
to the `Cluster\Timestamp` value of the `Cluster` they are stored in.
To get the timestamp of a `Block` or `SimpleBlock` in nanoseconds, the following formula is used:

    ( Cluster\Timestamp + ( block timestamp * TrackTimestampScale ) ) *
    TimestampScale

The `Block` element and `SimpleBlock` element store their timestamps as 16-bit signed integers,
allowing a range from "-32768" to "+32767" Track Ticks.
Although these values can be negative, when added to the `Cluster\Timestamp`, the resulting frame timestamp **SHOULD NOT** be negative.

When a `CodecDelay` element is set, its value **MUST** be substracted from each `Block` timestamp of that track.
To get the timestamp in nanoseconds of the first frame in a `Block` or `SimpleBlock`, the formula becomes:

    ( ( Cluster\Timestamp + ( block timestamp * TrackTimestampScale ) ) *
      TimestampScale ) - CodecDelay

The resulting frame timestamp **SHOULD NOT** be negative.

During playback, when a frame has a negative timestamp, the content **MUST** be decoded by the decoder but not played to the user.

## TimestampScale Rounding

The default Track Tick duration is one millisecond.

The `TimestampScale` is a floating-point value that is usually "1.0". But when it's not, the multiplied
`Block` Timestamp is a floating-point value in nanoseconds.
The `Matroska Reader` **SHOULD** use the nearest rounding value in nanoseconds to get
the proper nanosecond timestamp of a `Block`. This allows some clever `TimestampScale` values
to have a more refined timestamp precision per frame.

# Language Codes

Matroska versions 1 through 3 use language codes that can be either the three-letter
bibliographic ISO 639-2 form [@!ISO639-2] (like "fre" for French)
or such a language code followed by a dash and a country code for specialities in languages (like "fre-ca" for Canadian French).
The `ISO 639-2 Language` elements are `Language` element, `TagLanguage` element, and `ChapLanguage` element.

Starting in Matroska version 4, the forms defined in either [@!ISO639-2] or [@!RFC5646] **MAY** be used,
although the form in [@!RFC5646] is **RECOMMENDED**. The `Language` elements in the [@!RFC5646] form are `LanguageBCP47` element,
`TagLanguageBCP47` element, and `ChapLanguageBCP47` element. If both an [@!ISO639-2] Language element and an [@!RFC5646] Language element
are used within the same `Parent Element`, then the `Language` element in the [@!ISO639-2] form **MUST** be ignored and precedence given to the `Language` element in the [@!RFC5646] form.

In this document, "BCP47" in element names refers specifically to
[@!RFC5646], which is part of BCP 47.

# Country Codes

Country codes are the [@!RFC5646] two-letter region subtags, without the UK exception.


# Encryption

This Matroska specification provides no interoperable solution for securing the
data container with any assurances of confidentiality, integrity, authenticity,
or authorization. The `ContentEncryption` element ((#contentencryption-element))
and associated sub-fields ((#contentencalgo-element) to (#aessettingsciphermode-element)) are defined
only for the benefit of implementers to construct their own proprietary solution
or as the basis for further standardization activities.  How to use these
fields to secure a Matroska data container is out of scope, as are any related
issues such as key management and distribution.

A `Matroska Reader` who encounters containers that use the fields defined in this
section **MUST** rely on out-of-scope guidance to decode the associated content.

Because encryption occurs within the `Block` element, it is possible to manipulate
encrypted streams without decrypting them. The streams could potentially be copied,
deleted, cut, appended, or any number of other possible editing techniques without
decryption. The data can be used without having to expose it or go through the decrypting process.

Encryption can also be layered within Matroska. This means that two completely different
types of encryption can be used, requiring two separate keys to be able to decrypt a stream.

Encryption information is stored in the `ContentEncodings` element under the `ContentEncryption` element.

For encryption systems sharing public/private keys, the creation of the keys and the exchange of keys
are not covered by this document. They have to be handled by the system using Matroska.

The algorithms described in (#ContentEncAlgoValues) support
different modes of operations and key sizes.  The specification of these
parameters is required for a complete solution but is out of scope of this
document and left to the proprietary implementations using them or subsequent
profiles of this document.

The `ContentEncodingScope` element gives an idea of which part of the track is encrypted,
but each `ContentEncAlgo` element and its sub-elements (like `AESSettingsCipherMode`)
define exactly how the encrypted track should be interpreted.

An example of an extension that builds upon these security-related fields in this specification is [@?WebM-Enc].
It uses AES-CTR, `ContentEncAlgo` = 5 ((#contentencalgo-element)), and `AESSettingsCipherMode` = 1 ((#aessettingsciphermode-element)).

A `Matroska Writer` **MUST NOT** use insecure cryptographic algorithms to create new
archives or streams, but a `Matroska Reader` **MAY** support these algorithms to read
previously made archives or streams.

# Image Presentation

## Cropping

The `PixelCrop` elements (`PixelCropTop`, `PixelCropBottom`, `PixelCropRight`, and `PixelCropLeft`)
indicate when, and by how much, encoded video frames **SHOULD** be cropped for display.
These elements allow edges of the frame that are not intended for display (such as the
sprockets of a full-frame film scan or the Video ANCillary (VANC) area of a digitized analog videotape) to be stored but hidden. `PixelCropTop` and `PixelCropBottom` store an integer of how many
rows of pixels **SHOULD** be cropped from the top and bottom of the image, respectively.
 `PixelCropLeft` and `PixelCropRight` store an integer of how many columns of pixels
 **SHOULD** be cropped from the left and right of the image, respectively.

 For example,
 a pillar-boxed video that stores a 1440x1080 visual image within the center of a padded
 1920x1080 encoded image may set both `PixelCropLeft` and `PixelCropRight` to "240",
 so a `Matroska Player` should crop off 240 columns of pixels from the left and
 right of the encoded image to present the image with the pillar-boxes hidden.

Cropping has to be performed before resizing and the display dimensions given by
 `DisplayWidth`, `DisplayHeight`, and `DisplayUnit` apply to the already-cropped image.

## Rotation

The `ProjectionPoseRoll` element ((#projectionposeroll-element)) can be used to indicate
that the image from the associated video track **SHOULD** be rotated for presentation.
For instance, the following example of the `Projection` element ((#projection-element))
and the `ProjectionPoseRoll` element represents a video track where the image **SHOULD** be
presented with a 90-degree counter-clockwise rotation, with the EBML tree shown as XML:

```xml
&lt;Projection&gt;
  &lt;ProjectionPoseRoll&gt;90&lt;/ProjectionPoseRoll&gt;
&lt;/Projection&gt;
```
Figure: Rotation Example

# Segment Position

The `Segment Position` of an element refers to the position of the first octet of the
`Element ID` of that element, measured in octets, from the beginning of the `Element Data`
section of the containing `Segment` element. In other words, the `Segment Position` of an
element is the distance in octets from the beginning of its containing `Segment` element
minus the size of the `Element ID` and `Element Data Size` of that `Segment` element.
The `Segment Position` of the first `Child Element` of the `Segment` element is 0.
An element that is not stored within a `Segment` element, such as the elements of
the `EBML Header`, do not have a `Segment Position`.

## Segment Position Exception

Elements that are defined to store a `Segment Position` **MAY** define reserved values to
indicate a special meaning.

## Example of Segment Position

This table presents an example of `Segment Position` by showing a hexadecimal representation
of a very small Matroska file with labels to show the offsets in octets. The file contains
a `Segment` element with an `Element ID` of "0x18538067" and a `MuxingApp` element with an `Element ID` of "0x4D80".

         0                             1                             2
         0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
       0 |1A|45|DF|A3|8B|42|82|88|6D|61|74|72|6F|73|6B|61|
         ^ EBML Header
       0 |                                               |18|53|80|67|
                                                         ^ Segment ID
      20 |93|
         ^ Segment Data Size
      20 |  |15|49|A9|66|8E|4D|80|84|69|65|74|66|57|41|84|69|65|74|66|
            ^ Start of Segment data
      20 |                 |4D|80|84|69|65|74|66|57|41|84|69|65|74|66|
                           ^ MuxingApp start

In the above example, the `Element ID` of the `Segment` element is stored at offset 16,
the `Element Data Size` of the `Segment` element is stored at offset 20, and the
`Element Data` of the `Segment` element is stored at offset 21.

The `MuxingApp` element is stored at offset 26. Since the `Segment Position` of
an element is calculated by subtracting the position of the `Element Data` of
the containing `Segment` element from the position of that element, the `Segment Position`
of the `MuxingApp` element in the above example is "26 - 21" or "5".



# Linked Segments

Matroska provides several methods to link two or more `Segment` elements together to create
a `Linked Segment`. A `Linked Segment` is a set of multiple `Segments` linked together into
a single presentation by using Hard Linking or Medium Linking.

All `Segments` within a `Linked Segment` **MUST** have a `SegmentUUID`.

All `Segments` within a `Linked Segment` **SHOULD** be stored within the same directory
or be quickly accessible based on their `SegmentUUID`
in order to have a seamless transition between segments.

All `Segments` within a `Linked Segment` **MAY** set a `SegmentFamily` with a common value to make
it easier for a `Matroska Player` to know which `Segments` are meant to be played together.

The `SegmentFilename`, `PrevFilename`, and `NextFilename` elements **MAY** also give hints on
the original filenames that were used when the `Segment` links were created, in case some `SegmentUUIDs` are damaged.

## Hard Linking

Hard Linking, also called "splitting", is the process of creating a `Linked Segment`
by linking multiple `Segment` elements using the `NextUUID` and `PrevUUID` elements.

All `Segments` within a `Hard Linked Segment` **MUST** use the same `Tracks` list and `TimestampScale`.

Within a `Linked Segment`, the timestamps of `Block` and `SimpleBlock` **MUST** consecutively follow
the timestamps of `Block` and `SimpleBlock` from the previous `Segment` in linking order.

With Hard Linking, the chapters of any `Segment` within the `Linked Segment` **MUST** only reference the current `Segment`.
The `NextUUID` and `PrevUUID` reference the respective `SegmentUUID` values of the next and previous `Segments`.

The first `Segment` of a `Linked Segment` **MUST NOT** have a `PrevUUID` element.
The last `Segment` of a `Linked Segment` **MUST NOT** have a `NextUUID` element.

For each node of the chain of `Segments` of a `Linked Segment`, at least one `Segment` **MUST** reference the other `Segment` within the chain.

In a chain of `Segments` of a `Linked Segment`, the `NextUUID` always takes precedence over the `PrevUUID`.
Thus, if SegmentA has a `NextUUID` to SegmentB and SegmentB has a `PrevUUID` to SegmentC,
the link to use is `NextUUID` between SegmentA and SegmentB, and SegmentC is not part of the `Linked Segment`.

If SegmentB has a `PrevUUID` to SegmentA, but SegmentA has no `NextUUID`, then the `Matroska Player`
**MAY** consider these two `Segments` linked as SegmentA followed by SegmentB.

As an example, three `Segments` can be Hard Linked as a `Linked Segment` through
cross-referencing each other with `SegmentUUID`, `PrevUUID`, and `NextUUID` as shown in this table:

file name   | `SegmentUUID`                     | `PrevUUID`                        | `NextUUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | Invalid
Table: Usual Hard Linking UIDs{#hardLinkingUIDs}

An example where only the `NextUUID` element is used:

file name   | `SegmentUUID`                     | `PrevUUID`                        | `NextUUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | n/a                               | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | Invalid
Table: Hard Linking without PrevUUID{#hardLinkingWoPrevUUID}

An example where only the `PrevUUID` element is used:

file name   | `SegmentUUID`                     | `PrevUUID`                        | `NextUUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | n/a
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | Invalid
Table: Hard Linking without NextUUID{#hardLinkingWoNextUUID}

An example where only the `middle.mkv` is using the `PrevUUID` and `NextUUID` elements:

file name   | `SegmentUUID`                     | `PrevUUID`                        | `NextUUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | Invalid                           | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | Invalid
Table: Hard Linking with Mixed UID Links{#hardLinkingMixedUIDs}

## Medium Linking

Medium Linking creates relationships between `Segments` using `Ordered Chapters` ((#editionflagordered)) and the
`ChapterSegmentUUID` element. A `Chapter Edition` with `Ordered Chapters` **MAY** contain
`Chapters` elements that reference timestamp ranges from other `Segments`. The `Segment`
referenced by the `Ordered Chapter` via the `ChapterSegmentUUID` element **SHOULD** be played as
part of a `Linked Segment`.

The timestamps of `Segment` content referenced by `Ordered Chapters`
**MUST** be adjusted according to the cumulative duration of the previous `Ordered Chapters`.

As an example, a file named `intro.mkv` could have a `SegmentUUID` of "0xb16a58609fc7e60653a60c984fc11ead".
Another file called `program.mkv` could use a `Chapter Edition` that contains two `Ordered Chapters`.
The first chapter references the `Segment` of `intro.mkv` with the use of a `ChapterSegmentUUID`,
`ChapterSegmentEditionUID`, `ChapterTimeStart`, and an optional `ChapterTimeEnd` element.
The second chapter references content within the `Segment` of `program.mkv`. A `Matroska Player`
**SHOULD** recognize the `Linked Segment` created by the use of `ChapterSegmentUUID` in an enabled
`Edition` and present the reference content of the two `Segments` as a single presentation.

The `ChapterSegmentUUID` represents the `Segment` that holds the content to play in place of the `Linked Chapter`.
The `ChapterSegmentUUID` **MUST NOT** be the `SegmentUUID` of its own `Segment`.

There are two ways to use a chapter link:

* Linked-Duration linking

* Linked-Edition linking

### Linked-Duration

A `Matroska Player` **MUST** play the content of the `Linked Segment`
from the `ChapterTimeStart` until the `ChapterTimeEnd` timestamp in place of the `Linked Chapter`.

`ChapterTimeStart` and `ChapterTimeEnd` represent timestamps in the `Linked Segment` matching the value of `ChapterSegmentUUID`.
Their values **MUST** be in the range of the `Linked Segment` duration.

The `ChapterTimeEnd` value **MUST** be set when using Linked-Duration chapter linking.
`ChapterSegmentEditionUID` **MUST NOT** be set.

### Linked-Edition

A `Matroska Player` **MUST** play the whole `Linked Edition` of the `Linked Segment` in place of the `Linked Chapter`.

`ChapterSegmentEditionUID` represents a valid `Edition` from the `Linked Segment` matching the value of `ChapterSegmentUUID`.

When using Linked-Edition chapter linking, `ChapterTimeEnd` is **OPTIONAL**.



# Track Flags

## Default Flag

The Default flag is a hint for a `Matroska Player` indicating that a given track
**SHOULD** be eligible to be automatically selected as the default track for a given
language. If no tracks in a given language have the Default flag set, then all tracks
in that language are eligible for automatic selection. This can be used to indicate that
a track provides "regular service" that is suitable for users with default settings, as opposed to
specialized services, such as commentary, captions for users with hearing impairments, or descriptive audio.

The `Matroska Player` **MAY** override the Default flag for any reason, including
user preferences to prefer tracks providing accessibility services.

## Forced Flag

The Forced flag tells the `Matroska Player` that it **SHOULD** display this subtitle track,
even if user preferences usually would not call for any subtitles to be displayed alongside
the audio track that is currently selected. This can be used to indicate that a track contains translations
of on-screen text or dialogue spoken in a different language than the track's primary language.

## Hearing-Impaired Flag

The Hearing-Impaired flag tells the `Matroska Player` that it **SHOULD** prefer this track
when selecting a default track for a user with a hearing impairment and that it **MAY** prefer to select
a different track when selecting a default track for a user that is not hearing impaired.

## Visual-Impaired Flag

The Visual-Impaired flag tells the `Matroska Player` that it **SHOULD** prefer this track
when selecting a default track for a user with a visual impairment and that it **MAY** prefer to select
a different track when selecting a default track for a user that is not visually impaired.

## Descriptions Flag

The Descriptions flag tells the `Matroska Player` that this track is suitable to play via
a text-to-speech system for a user with a visual impairment and that it **SHOULD NOT** automatically
select this track when selecting a default track for a user that is not visually impaired.

## Original Flag

The Original flag tells the `Matroska Player` that this track is in the original language
and that it **SHOULD** prefer this track if configured to prefer original-language tracks of this
track's type.

## Commentary Flag

The Commentary flag tells the `Matroska Player` that this track contains commentary on
the content.

## Track Operation

`TrackOperation` allows for the combination of multiple tracks to make a virtual one. It uses
two separate system to combine tracks. One to create a 3D "composition" (left/right/background planes)
and one to simplify join two tracks together to make a single track.

A track created with `TrackOperation` is a proper track with a UID and all its flags.
However, the codec ID is meaningless because each "sub" track needs to be decoded by its
own decoder before the "operation" is applied. The `Cues` elements corresponding to such
a virtual track **SHOULD** be the union of the `Cues` elements for each of the tracks it's composed of (when the `Cues` are defined per track).

In the case of `TrackJoinBlocks`, the `Block` elements (from `BlockGroup` and `SimpleBlock`)
of all the tracks **SHOULD** be used as if they were defined for this new virtual `Track`.
When two `Block` elements have overlapping start or end timestamps, it's up to the underlying
system to either drop some of these frames or render them the way they overlap.
This situation **SHOULD** be avoided when creating such tracks, as you can never be sure
of the end result on different platforms.

## Overlay Track

An overlay track **SHOULD** be rendered in the same channel as the track it's linked to.
When content is found in such a track, it **SHOULD** be played on the rendering channel
instead of the original track.

## Multi-planar and 3D Videos

There are two different ways to compress 3D videos: have each eye track in a separate track
and have one track have both eyes combined inside (which is more efficient compression-wise).
Matroska supports both ways.

For the single-track variant, there is the `StereoMode` element, which defines how planes are
assembled in the track (mono or left-right combined). Odd values of `StereoMode` means the left
plane comes first for more convenient reading. The pixel count of the track (`PixelWidth`/`PixelHeight`)
is the raw number of pixels (for example, 3840x1080 for full HD side by side), and the
`DisplayWidth`/`DisplayHeight`
in pixels is the number of pixels for one plane (1920x1080 for that full HD stream).
Old stereo 3D movies were displayed using anaglyph (cyan and red colors separated).
For compatibility with such movies, there is a value of the `StereoMode` that corresponds to anaglyph.

There is also a "packed" mode (values 13 and 14) that consists of packing two frames together
in a `Block` that uses lacing. The first frame is the left eye and the other frame is the right eye
(or vice versa). The frames **SHOULD** be decoded in that order and are possibly dependent
on each other (P and B frames).

For separate tracks, Matroska needs to define exactly which track does what.
`TrackOperation` with `TrackCombinePlanes` does that. For more details, see
(#track-operation) on how `TrackOperation` works.

The 3D support is still in infancy and may evolve to support more features.

The `StereoMode` used to be part of Matroska v2, but it didn't meet the requirement
for multiple tracks. There was also a bug in [@?libmatroska] prior to 0.9.0 that would save/read
it as `0x53B9` instead of `0x53B8`; see `OldStereoMode` ((#oldstereomode-element)). `Matroska Readers` **MAY** support these legacy files by checking
Matroska v2 or `0x53B9`.
The older values of `StereoMode` were 0 (mono), 1 (right eye), 2 (left eye), and 3 (both eyes); these are the only values that can be found in `OldStereoMode`.
They are not compatible with the `StereoMode` values found in Matroska v3 and above.


# Default Track Selection

This section provides some example sets of `Tracks` and hypothetical user settings, along with
indications of which ones a similarly configured `Matroska Player` **SHOULD** automatically
select for playback by default in such a situation. A player **MAY** provide additional settings
with more detailed controls for more nuanced scenarios. These examples are provided as guidelines
to illustrate the intended usages of the various supported `Track` flags and their expected behaviors.

`Track` names are shown in English for illustrative purposes; actual files may have titles
in the language of each track or provide titles in multiple languages.

## Audio Selection

Example track set:

| No. | Type  | Lang | Layout | Original | Default | Other Flags     | Name                  |
| --- | ----- | ---- | ------ | -------- | ------- | --------------- | --------------------- |
| 1   | Video | und  | N/A    | N/A      | N/A     | None            |                       |
| 2   | Audio | eng  | 5.1    | 1        | 1       | None            |                       |
| 3   | Audio | eng  | 2.0    | 1        | 1       | None            |                       |
| 4   | Audio | eng  | 2.0    | 1        | 0       | Visual-Impaired | Descriptive audio     |
| 5   | Audio | esp  | 5.1    | 0        | 1       | None            |                       |
| 6   | Audio | esp  | 2.0    | 0        | 0       | Visual-Impaired | Descriptive audio     |
| 7   | Audio | eng  | 2.0    | 1        | 0       | Commentary      | Director's Commentary |
| 8   | Audio | eng  | 2.0    | 1        | 0       | None            | Karaoke               |
Table: Audio Tracks for Default Selection{#audioTrackSelection}

The table above shows a file with seven audio tracks -- five in English and two in Spanish.

The English tracks all have the Original flag, indicating that English is the original content language.

Generally, the player will first consider the track languages. If the player has an option to prefer
original-language audio and the user has enabled it, then it should prefer one of the tracks with the Original flag.
If the user has configured to specifically prefer audio tracks in English or Spanish, the player should select one of
the tracks in the corresponding language. The player may also wish to prefer a track with the Original flag
if no tracks matching any of the user's explicitly preferred languages are available.

Two of the tracks have the Visual-Impaired flag. If the player has been configured to prefer such tracks,
it should select one; otherwise, it should avoid them if possible.

If selecting an English track, when other settings have left multiple possible options,
it may be useful to exclude the tracks that lack the Default flag. Here, one provides descriptive service for
individuals with visual impairments (which has its own flag and may be automatically selected by user configuration
but is unsuitable for users with default-configured players), one is a commentary track
(which has its own flag and the player may or may not have specialized handling for),
and the last contains karaoke versions of the music that plays during the film (which is an unusual
specialized audio service that Matroska has no built-in support for indicating, so it's indicated
in the track name instead). By not setting the Default flag on these specialized tracks, the file's author
hints that they should not be automatically selected by a default-configured player.

Having narrowed its choices down, the example player now may have to select between tracks 2 and 3.
The only difference between these tracks is their channel layouts: 2 is 5.1 surround, while 3 is stereo.
If the player is aware that the output device is a pair of headphones or stereo speakers, it may wish
to prefer the stereo mix automatically. On the other hand, if it knows that the device is a surround system,
it may wish to prefer the surround mix.

If the player finishes analyzing all of the available audio tracks and finds that more than one seem equally
and maximally preferable, it **SHOULD** default to the first of the group.

## Subtitle Selection

Example track set:

| No. | Type      | Lang  | Original | Default | Forced | Other Flags      | Name                               |
| --- | --------- | ----  | -------- | ------- | ------ | ---------------- | ---------------------------------- |
| 1   | Video     | und   | N/A      | N/A     | N/A    | None             |                                    |
| 2   | Audio     | fra   | 1        | 1       | N/A    | None             |                                    |
| 3   | Audio     | por   | 0        | 1       | N/A    | None             |                                    |
| 4   | Subtitles | fra   | 1        | 1       | 0      | None             |                                    |
| 5   | Subtitles | fra   | 1        | 0       | 0      | Hearing-Impaired | Captions for users with hearing impairments  |
| 6   | Subtitles | por   | 0        | 1       | 0      | None             |                                    |
| 7   | Subtitles | por   | 0        | 0       | 1      | None             | Signs                              |
| 8   | Subtitles | por   | 0        | 0       | 0      | Hearing-Impaired | SDH                                |
Table: Subtitle Tracks for Default Selection{#subtitleTrackSelection}

The table above shows two audio tracks and five subtitle tracks. As we can see, French is the original language.

We'll start by discussing the case where the user prefers French (or original-language)
audio (or has explicitly selected the French audio track) and also prefers French subtitles.

In this case, if the player isn't configured to display captions when the audio matches their
preferred subtitle languages, the player doesn't need to select a subtitle track at all.

If the user _has_ indicated that they want captions to be displayed, the selection simply
comes down to whether hearing-impaired subtitles are preferred.

The situation for a user who prefers Portuguese subtitles starts out somewhat analogous.
If they select the original French audio (either by explicit audio language preference,
preference for original-language tracks, or explicitly selecting that track), then the
selection once again comes down to the hearing-impaired preference.

However, the case where the Portuguese audio track is selected has an important catch:
a Forced track in Portuguese is present. This may contain translations of on-screen text
from the video track or of portions of the audio that are not translated (music, for instance).
This means that even if the user's preferences wouldn't normally call for captions here,
the Forced track should be selected nonetheless, rather than selecting no track at all.
On the other hand, if the user's preferences _do_ call for captions, the non-Forced tracks
should be preferred, as the Forced track will not contain captioning for the dialogue.

