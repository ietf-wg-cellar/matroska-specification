# Codec Mappings

A `Codec Mapping` is a set of attributes to identify, name, and contextualize the format
and characteristics of encoded data that can be contained within Matroska Clusters.

Each `TrackEntry` used within Matroska **MUST** reference a defined `Codec Mapping` using the
`CodecID` to identify and describe the format of the encoded data in its associated Clusters.
This `CodecID` is a unique registered identifier that represents the encoding stored within
the `Track`. Certain encodings **MAY** also require some form of codec initialization
to provide its decoder with context and technical metadata.

The intention behind this list is not to list all existing audio and video codecs,
but rather to list those codecs that are currently supported in Matroska and therefore
need a well defined `CodecID` so that all developers supporting Matroska will use the
same `CodecID`. If you feel we missed support for a very important codec, please tell
us on our development mailing list (cellar at ietf.org).

## Defining Matroska Codec Support

Support for a codec is defined in Matroska with the following values.

### Codec ID

Each codec supported for storage in Matroska **MUST** have a unique `CodecID`.
Each `CodecID` **MUST** be prefixed with the string from the following table according to
the associated type of the codec. All characters of a `Codec ID Prefix` **MUST** be
capital letters (A-Z) except for the last character of a `Codec ID Prefix` which **MUST** be
an underscore ("_").

Codec Type | Codec ID Prefix
-----------|----------------
Video      | "V_"
Audio      | "A_"
Subtitle   | "S_"
Button     | "B_"
Table: Codec ID Prefix by Codec Type{#CodecPrefix}

Each `CodecID` **MUST** include a `Major Codec ID` immediately following the `Codec ID Prefix`.
A `Major Codec ID` **MAY** be followed by an **OPTIONAL** `Codec ID Suffix` to communicate a refinement
of the `Major Codec ID`. If a `Codec ID Suffix` is used, then the `CodecID` **MUST** include a
forward slash ("/") as a separator between the `Major Codec ID` and the `Codec ID Suffix`.
The `Major Codec ID` **MUST** be composed of only capital letters (A-Z) and numbers (0-9).
The `Codec ID Suffix` **MUST** be composed of only capital letters (A-Z), numbers (0-9),
underscore ("_"), and forward slash ("/").

The following table provides examples of valid `Codec IDs` and their components:

Codec ID Prefix | Major Codec ID | Separator | Codec ID Suffix | Codec ID
----------------|:---------------|:----------|:----------------|:--------
A_              | AAC            | /         | MPEG2/LC/SBR    | A_AAC/MPEG2/LC/SBR
V_              | MPEG4          | /         | ISO/ASP         | V_MPEG4/ISO/ASP
V_              | MPEG1          |           |                 | V_MPEG1
Table: Codec ID Components{#CodecComponents}

### Codec Name

Each encoding supported for storage in Matroska **MUST** have a `Codec Name`.
The `Codec Name` provides a readable label for the encoding.

### Description

An optional description for the encoding. This value is only intended for human consumption.

### Initialization

Each encoding supported for storage in Matroska **MUST** have a defined Initialization.
The Initialization **MUST** describe the storage of data necessary to initialize the decoder,
which **MUST** be stored within the `CodecPrivate` element. When the Initialization is updated
within a track, then that updated Initialization data **MUST** be written into the `CodecState` element
of the first `Cluster` to require it. If the encoding does not require any form of Initialization,
then `none` **MUST** be used to define the Initialization and the `CodecPrivate` element
**SHOULD NOT** be written and **MUST** be ignored.

### Codec BlockAdditions

Additional data that contextualizes or supplements a `Block` can be stored within
the `BlockAdditional` element of a `BlockMore` element [@!RFC9559, section 5.1.3.5.2.1].
Each `BlockAdditional` is coupled with a `BlockAddID` that identifies the kind of data it contains.

A `BlockAddID` of 1 means the data in the `BlockAdditional` element are tied to the codec.
This `BlockAdditional` data with a `BlockAddID` of 1 **MAY** be passed to the associated decoder alongside the `Block` content .

A codec definition **MUST** contain a "Codec BlockAdditions" section if the codec can use `BlockAdditional` data with a `BlockAddID` of 1.

The `BlockAddID` values are defined in (#block-addition-mappings).

### Citation

Documentation of the associated normative and informative references for the codec is **RECOMMENDED**.

### Superseded By

When a `Superseded By` is set, the specified `CodecID` value **MUST** be used instead of the `CodecID` it's defined for.

Files **MAY** exist with the superseded `CodecID` and **MAY** be supported by Matroska Players.

## Recommendations for the Creation of New Codec Mappings

Creators of new `Codec Mappings` to be used in the context of Matroska:

- **SHOULD** assume that all `Codec Mappings` they create might become standardized, public,
  commonly deployed, or usable across multiple implementations.

- **SHOULD** employ meaningful values for `CodecID` and `Codec Name` that they have reason
  to believe are currently unused.

- **SHOULD NOT** prefix their `CodecID` with "X_" or similar constructs.

These recommendations are based on [@!RFC6648, section 3].

## Video Codec Mappings

All codecs described in this section **MUST** have a `TrackType` ([@!RFC9559, section 5.1.4.1.3]) value of "1" for video.
The track using these codecs **MUST** contain a `Video` element -- EBML Path `\Segment\Tracks\TrackEntry\Video`.

Most video codec contain meta information about the data they contain, like encoded width and height, chroma subsampling, etc.
Whenever possible these information inside the codec **SHOULD** be extracted and repeated at the Matroska level with
the appropriate element(s) inside the `\Segment\Tracks\TrackEntry\Video` and `\Segment\Tracks\TrackEntry` elements.
These values **MUST** be valid for the whole Segment.

### V_AV1

Codec ID: `V_AV1`

Codec Name: Alliance for Open Media AV1 Video codec

Description: Only one `Sequence Header OBU`, as defined in section 6.4 of [@!AV1], is supported per Matroska Segment.
Each `Block` contains one `Temporal Unit` containing one or more OBUs. Each OBU stored in the Block **MUST** contain its header and its payload.
The OBUs in the `Block` follow the `Low Overhead Bitstream Format syntax`.
They **MUST** have the `obu_has_size_field` set to 1 except for the last OBU in the frame, for which `obu_has_size_field` **MAY** be set to 0, in which case it is assumed to fill the remainder of the frame.
A `SimpleBlock` **MUST NOT** be marked as a Keyframe if it doesn't contain a `Frame OBU`.
A `SimpleBlock` **MUST NOT** be marked as a Keyframe if the first `Frame OBU` doesn't have a `frame_type` of `KEY_FRAME`.
A `SimpleBlock` **MUST NOT** be marked as a Keyframe if it doesn't contains a `Sequence Header OBU`.
A `Block` inside a `BlockGroup` **MUST** use `ReferenceBlock` elements if the first `Frame OBU` in the `Block` has a `frame_type` other than `KEY_FRAME`.
A `Block` inside a `BlockGroup` **MUST** use `ReferenceBlock` elements if the `Block` doesn't contain a `Sequence Header OBU`.
A `Block` with `frame_header_obu` where the `frame_type` is `INTRA_ONLY_FRAME` **MUST** use a `ReferenceBlock` with a value of 0 to reference itself.

Initialization: The `CodecPrivate` consists of the `AV1CodecConfigurationRecord` described in section 2.3 of [@!AV1-ISOBMFF].

PixelWidth:  **MUST** be `max_frame_width_minus_1`+1 of the `Sequence Header OBU`.

PixelHeight: **MUST** be `max_frame_height_minus_1`+1 of the `Sequence Header OBU`.

### V_AVS2

Codec ID: V_AVS2

Codec Name: AVS2-P2/IEEE.1857.4

Description: Individual pictures of AVS2-P2 stored as described in the second part of [@!IEEE.1857-4].

Initialization: none.

### V_AVS3

Codec ID: V_AVS3

Codec Name: AVS3-P2/IEEE.1857.10

Description: Individual pictures of AVS3-P2 stored as described in the second part of [@!IEEE.1857-10].

Initialization: none.

### V_CAVS

Codec ID: V_CAVS

Codec Name: AVS1-P2, JiZhun profile

Description: Individual pictures of AVS1-P2 stored as described in [@!IEEE.1857-3].

### V_DIRAC

Codec ID: V_DIRAC

Codec Name: BBC Dirac

Description: A video codec developed by the BBC [@Dirac]. The Intra-only version of Dirac, also known as Dirac Pro, resulted in SMPTE VC-2 [@SMPTE.ST2042-1].
Each Matroska frame corresponds to a Sequence as defined in [@!Dirac].

### V_FFV1

Codec ID: V_FFV1

Codec Name: FF Video Codec 1

Description: FFV1 is a lossless intra-frame video encoding format designed to efficiently compress video data in a variety of pixel formats.
Compared to uncompressed video, FFV1 offers storage compression, frame fixity, and self-description,
which makes FFV1 useful as a preservation or intermediate video format. [@!RFC9043]

Initialization: For FFV1 versions 0 or 1, `CodecPrivate` **SHOULD NOT** be written.
For FFV1 version 3 or greater, the `CodecPrivate` **MUST** contain the FFV1 Configuration Record structure, as defined in [@!RFC9043, section 4.3], and no other data.

### V_MJPEG

Codec ID: V_MJPEG

Codec Name: Motion JPEG

Description: Motion JPEG is a video compression format in which each video frame or interlaced field  is compressed separately as a [@!JPEG] image.

### V_MPEGH/ISO/HEVC

Codec ID: V_MPEGH/ISO/HEVC

Codec Name: HEVC/H.265

Description: Individual pictures (which could be a frame, a field, or 2 fields having the same timestamp) of HEVC/H.265 stored as described in [@!ISO.14496-15].

Initialization: The `CodecPrivate` contains a `HEVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].

### V_MPEGI/ISO/VVC

Codec ID: V_MPEGI/ISO/VVC

Codec Name: VVC/H.266

Description: Individual pictures (which could be a frame, a field, or 2 fields having the same timestamp) of VVC/H.266 stored as described in [@!ISO.14496-15].

Initialization: The `CodecPrivate` contains a `VVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].

### V_MPEG1

Codec ID: V_MPEG1

Codec Name: MPEG 1

Description: Frames correspond to a Video Sequence as defined in [@!ISO.11172-2].

Initialization: none

### V_MPEG2

Codec ID: V_MPEG2

Codec Name: MPEG 2

Description: Frames correspond to a Video Sequence as defined in [@!ISO.13818-2].

Initialization: none

### V_MPEG4/ISO/AVC

Codec ID: V_MPEG4/ISO/AVC

Codec Name: AVC/H.264

Description: Individual pictures (which could be a frame, a field, or 2 fields having the same timestamp) of AVC/H.264 stored as described in [@!ISO.14496-15].

Initialization: The `CodecPrivate` contains a `AVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].
For legacy reasons, because `Block Additional Mappings` are preferred; see (#block-addition-mappings),
the `AVCDecoderConfigurationRecord` structure **MAY** be followed by an extension block beginning
with a 4-byte extension block size field in big-endian byte order which is the size of the extension block
minus 4 (excluding the size of the extension block size field) and a 4-byte field corresponding
to a `BlockAddIDType` of "mvcC" followed by a content corresponding to the content of `BlockAddIDExtraData` for `mvcC`; see (#mvcc).

### V_MPEG4/ISO/AP

Codec ID: V_MPEG4/ISO/AP

Codec Name: MPEG4 ISO Advanced Profile

Description: Frames correspond to frames defined in [@!ISO.14496-2].
Stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI.
Note there are differences how b-frames are handled in these original streams,
when being compared to a VfW created stream, as here there are `no` dummy frames inserted,
same as in MP4 streams.

Initialization: none

### V_MPEG4/ISO/ASP

Codec ID: V_MPEG4/ISO/ASP

Codec Name: MPEG4 ISO Advanced Simple Profile (DivX5, XviD)

Description: Frames correspond to frames defined in [@!ISO.14496-2].
Stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI.
Note there are differences how b-frames are handled in these original streams,
when being compared to a VfW created stream, as here there are `no` dummy frames inserted,
same as in MP4 streams.

Initialization: none

### V_MPEG4/ISO/SP

Codec ID: V_MPEG4/ISO/SP

Codec Name: MPEG4 ISO Simple Profile (DivX4)

Description: Frames correspond to frames defined in [@!ISO.14496-2].
Stream was created via improved codec API (UCI) or even transmuxed from AVI (no b-frames in Simple Profile).

Initialization: none

### V_MPEG4/MS/V3

Codec ID: V_MPEG4/MS/V3

Codec Name: Microsoft MPEG4 V3

Description: Microsoft MPEG4 V3 and derivates, means DivX3, Angelpotion, SMR, etc.; stream was created using
VfW codec or transmuxed from AVI; note that V1/V2 are covered in VfW compatibility mode.

Initialization: none

### V_MS/VFW/FOURCC

Codec ID: `V_MS/VFW/FOURCC`

Codec Name: Microsoft Video Codec Manager (VCM)

Description: The `CodecPrivate` contains the VCM structure BITMAPINFOHEADER including
the extra private bytes, as defined in [@!BITMAPINFOHEADER].
The data are stored in little-endian format (like on IA32 machines). Where is the Huffman table stored
in HuffYUV, not AVISTREAMINFO ??? And the FourCC, not in AVISTREAMINFO.fccHandler ???

Initialization: `CodecPrivate` contains the VCM structure BITMAPINFOHEADER including the extra private bytes,
as defined by Microsoft in [@!BITMAPINFOHEADER].

### V_QUICKTIME

Codec ID: V_QUICKTIME

Codec Name: Video taken from QuickTime files

Description: Several codecs as stored in QuickTime (e.g., Sorenson or Cinepak).

Initialization: The `CodecPrivate` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory video descriptor structure
(starting with the size and FourCC fields). For an explanation of the QuickTime file format read [@!QTFF].

### V_PRORES

Codec ID: V_PRORES

Codec Name: Apple ProRes

Initialization: The `CodecPrivate` contains the FourCC as found in MP4 movies:

*   ap4x: ProRes 4444 XQ

*   ap4h: ProRes 4444

*   apch: ProRes 422 High Quality

*   apcn: ProRes 422 Standard Definition

*   apcs: ProRes 422 LT

*   apco: ProRes 422 Proxy

*   aprh: ProRes RAW High Quality

*   aprn: ProRes RAW Standard Definition

ProRes is defined as [@!SMPTE.RDD36].

### V_REAL/RV10

Codec ID: V_REAL/RV10

Codec Name: RealVideo 1.0 aka RealVideo 5

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `CodecPrivate` contains a `real_video_props_t` structure in big-endian byte order as found in [@!librmff].

### V_REAL/RV20

Codec ID: V_REAL/RV20

Codec Name: RealVideo G2 and RealVideo G2+SVT

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `CodecPrivate` contains a `real_video_props_t` structure in big-endian byte order as found in [@!librmff].

### V_REAL/RV30

Codec ID: V_REAL/RV30

Codec Name: RealVideo 8

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `CodecPrivate` contains a `real_video_props_t` structure in big-endian byte order as found in [@!librmff].

### V_REAL/RV40

Codec ID: V_REAL/RV40

Codec Name: rv40 : RealVideo 9

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `CodecPrivate` contains a `real_video_props_t` structure in big-endian byte order as found in [@!librmff].

### V_THEORA

Codec ID: V_THEORA

Codec Name: Theora

Description: Frames correspond to a Theora Frame as defined in [@!Theora].

Initialization: The `CodecPrivate` contains the first three Theora packets in order. The lengths of the packets precedes them. The actual layout is:

* Byte 1: number of distinct packets `#p` minus one inside the `CodecPrivate` block. This **MUST** be "2" for current (as of 2016-07-08) Theora headers.

* Bytes 2..n: lengths of the first `#p` packets, coded in Xiph-style lacing. The length of the last packet is the length of the `CodecPrivate` block minus the lengths coded in these bytes minus one.

* Bytes n+1..: The Theora identification header, followed by the commend header followed by the codec setup header. Those are described in the [@!Theora].

### V_UNCOMPRESSED

Codec ID: V_UNCOMPRESSED

Codec Name: Video, raw uncompressed video frames

Description: All details about the used color specs and bit depth are to be put/read from the `TrackEntry\Video\UncompressedFourCC` elements.

Initialization: none

### V_VP8

Codec ID: V_VP8

Codec Name: VP8 Codec format

Description: VP8 is an open and royalty free video compression format developed by Google and created by On2 Technologies as a successor to VP7. [@!RFC6386]

Codec BlockAdditions: A single-channel encoding of an alpha channel **MAY** be stored in `BlockAdditions`. The `BlockAddID` of the `BlockMore` containing these data **MUST** be 1.

Initialization: none

### V_VP9

Codec ID: V_VP9

Codec Name: VP9 Codec format

Description: VP9 is an open and royalty free video compression format developed by Google as a successor to VP8. [@!VP9]

Codec BlockAdditions: A single-channel encoding of an alpha channel **MAY** be stored in `BlockAdditions`. The `BlockAddID` of the `BlockMore` containing these data **MUST** be 1.

Initialization: The `CodecPrivate` **SHOULD** contain a list of specific VP9 codec features as described in the "VP9 Codec Feature Metadata" section of [@!WebMContainer].
This piece of data helps to select a decoder on playback, but as many muxers don't provide the `CodecPrivate` for "V_VP9" it's not a hard requirement.
It is possible for the decoder to reconstruct the "VP9 Codec Feature Metadata" from the first frame in case the `CodecPrivate` is not present.

Note that the format differs from the `VPCodecConfigurationRecord` structure, as defined in [@VP-ISOBMFF].

## Audio Codec Mappings

All codecs described in this section **MUST** have a `TrackType` ([@!RFC9559, section 5.1.4.1.3]) value of "2" for audio.
The track using these codecs **MUST** contain an `Audio` element -- EBML Path `\Segment\Tracks\TrackEntry\Audio`.

Most audio codec contain meta information about the data they contain, like encoded sampling frequency, channel count, etc.
Whenever possible these information inside the codec **SHOULD** be extracted and repeated at the Matroska level with
the appropriate element(s) inside the `\Segment\Tracks\TrackEntry\Audio` and `\Segment\Tracks\TrackEntry` elements.
These values **MUST** be valid for the whole Segment.

### A_AAC/MPEG2/LC

Codec ID: A_AAC/MPEG2/LC

Codec Name: Low Complexity

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG2/LC/SBR

Codec ID: A_AAC/MPEG2/LC/SBR

Codec Name: Low Complexity with Spectral Band Replication

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG2/MAIN

Codec ID: A_AAC/MPEG2/MAIN

Codec Name: MPEG2 Main Profile

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG2/SSR

Codec ID: A_AAC/MPEG2/SSR

Codec Name: Scalable Sampling Rate

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG4/LC

Codec ID: A_AAC/MPEG4/LC

Codec Name: Low Complexity

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG4/LC/SBR

Codec ID: A_AAC/MPEG4/LC/SBR

Codec Name: Low Complexity with Spectral Band Replication

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG4/LTP

Codec ID: A_AAC/MPEG4/LTP

Codec Name: Long Term Prediction

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG4/MAIN

Codec ID: A_AAC/MPEG4/MAIN

Codec Name: MPEG4 Main Profile

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AAC/MPEG4/SSR

Codec ID: A_AAC/MPEG4/SSR

Codec Name: Scalable Sampling Rate

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.

Initialization: none

### A_AC3

Codec ID: A_AC3

Codec Name: Dolby Digital / AC-3

Description: Individual frames of AC-3 `syncframe()` stored as described in [@!ATSC.A52] or [@!ETSI.TS102-366] when the value of the `bsid` field defined in Section 5.4.2.1 of [@!ATSC.A52] or Section 4.4.2.1 of [@!ETSI.TS102-366] is 10 or below.
Channel number have to be read from the corresponding audio element

### A_AC3/BSID9

Codec ID: A_AC3/BSID9

Codec Name: Dolby Digital / AC-3

Description: Individual frames of AC-3 `syncframe()` stored as described in [@!ATSC.A52] or [@!ETSI.TS102-366] when the value of the `bsid` field defined in Section 5.4.2.1 of [@!ATSC.A52] or Section 4.4.2.1 of [@!ETSI.TS102-366] is 9.
Note that the value 9 in the `bsid` field is not standard but it is defacto used for dividing the sampling rate defined in Section 5.4.1.3 of [@!ATSC.A52] or Section 4.4.2.1 of [@!ETSI.TS102-366] by 2.

Using this Codec ID is **NOT RECOMMENDED** as many Matroska Players don't support it. The generic `A_AC3` Codec ID should be used instead as it supports a `bsid` of 9 as well.

Initialization: none

### A_AC3/BSID10

Codec ID: A_AC3/BSID10

Codec Name: Dolby Digital / AC-3

Description: Individual frames of AC-3 `syncframe()` stored as described in [@!ATSC.A52] or [@!ETSI.TS102-366] when the value of the `bsid` field defined in Section 5.4.2.1 of [@!ATSC.A52] or Section 4.4.2.1 of [@!ETSI.TS102-366] is 10.
Note that the value 10 in the `bsid` field is not standard but it is defacto used for dividing the sampling rate defined in Section 5.4.1.3 of [@!ATSC.A52] or Section 4.4.2.1 of [@!ETSI.TS102-366] by 4.

Using this Codec ID is **NOT RECOMMENDED** as many Matroska Players don't support it. The generic `A_AC3` Codec ID should be used instead as it supports a `bsid` of 10 as well.

Initialization: none

### A_ALAC

Codec ID: A_ALAC

Codec Name: ALAC (Apple Lossless Audio Codec)

Initialization: The `CodecPrivate` contains ALAC's magic cookie (both the codec specific configuration as well as the optional channel layout information).
Its format is described in the "Magic Cookie" defined in [@!ALAC].

### A_ATRAC/AT1

Codec ID: A_ATRAC/AT1

Codec Name: Sony ATRAC1 Codec

Description: The original ATRAC codec by Sony, mainly used in MiniDisc platforms. The core technical details on ATRAC1 can be found in [@?AtracAES]. An example encoder/decoder can be found at [@?atracdenc].

Initialization: None

### A_DTS

Codec ID: A_DTS

Codec Name: Digital Theatre System

Description: Supports DTS, DTS-ES, DTS-96/26, DTS-HD High Resolution Audio and DTS-HD Master Audio. It corresponds to the base codec defined in [@!ETSI.TS102-114].

Initialization: none

### A_DTS/EXPRESS

Codec ID: A_DTS/EXPRESS

Codec Name: Digital Theatre System Express

Description: DTS Express (a.k.a. LBR) audio streams.  It corresponds to the LBR extension of the DTS codec defined in section 9 of [@!ETSI.TS102-114].

Initialization: none

### A_DTS/LOSSLESS

Codec ID: A_DTS/LOSSLESS

Codec Name: Digital Theatre System Lossless

Description: DTS Lossless audio that does not have a core substream. It corresponds to the Lossless extension (XLL) of the DTS codec defined in section 8 of [@!ETSI.TS102-114].

Initialization: none

### A_EAC3

Codec ID: A_EAC3

Codec Name: Dolby Digital Plus / E-AC-3

Description: Individual frames of E-AC-3 `syncframe()` stored as described in [@!ATSC.A52] or [@!ETSI.TS102-366] when the value of the `bsid` field defined in Annex E Section 2.1 of [@!ATSC.A52] or Section E.1.3.1.6 of [@!ETSI.TS102-366] is 11, 12, 13, 14, 15 or 16.

### A_FLAC

Codec ID: A_FLAC

Codec Name: FLAC (Free Lossless Audio Codec)

Initialization: The `CodecPrivate` contains all the header/metadata packets before the first data packet as defined in [@!I-D.ietf-cellar-flac].
These include the first header packet containing only the word `fLaC` as well as all metadata packets.

### A_MLP

Codec ID: A_MLP

Codec Name: Meridian Lossless Packing / MLP

Description: A lossless audio codec used in DVD-Audio discs. The format is similar to Dolby TrueHD ((#a-truehd)) but with less channels.

### A_MPC

Codec ID: A_MPC

Codec Name: MPC (musepack) SV8

Description: The main developer for musepack has requested that we wait until the SV8 framing has been fully defined
for musepack before defining how to store it in Matroska.

### A_MPEG/L1

Codec ID: A_MPEG/L1

Codec Name: MPEG Audio 1, 2 Layer I

Description: Frames correspond to Audio Frames of a Layer I bitstream as defined in [@!ISO.11172-3].

Initialization: none

### A_MPEG/L2

Codec ID: A_MPEG/L2

Codec Name: MPEG Audio 1, 2 Layer II

Description: Frames correspond to Audio Frames of a Layer II bitstream as defined in [@!ISO.11172-3].

Initialization: none

### A_MPEG/L3

Codec ID: A_MPEG/L3

Codec Name: MPEG Audio 1, 2, 2.5 Layer III

Description: Frames correspond to Audio Frames of a Layer III bitstream as defined in [@!ISO.11172-3].

Initialization: none

### A_MS/ACM

Codec ID: A_MS/ACM

Codec Name: Microsoft Audio Codec Manager (ACM)

Description: The data are stored in little-endian format (like on IA32 machines).

Initialization: The `CodecPrivate` contains the [@!WAVEFORMATEX] structure including the extra format information bytes.
The structure is stored without packing or padding bytes.
A `WORD` corresponds to a signed 2 octets integer, `DWORD` corresponds to a signed 4 octets integer.
The extra format information are appended after the WAVEFORMATEX octets.

### A_REAL/14_4

Codec ID: A_REAL/14_4

Codec Name: Real Audio 1

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_REAL/28_8

Codec ID: A_REAL/28_8

Codec Name: Real Audio 2

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_REAL/ATRC

Codec ID: A_REAL/ATRC

Codec Name: Sony Atrac3 Codec

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_REAL/COOK

Codec ID: A_REAL/COOK

Codec Name: Real Audio Cook Codec (codename: Gecko)

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_REAL/RALF

Codec ID: A_REAL/RALF

Codec Name: Real Audio Lossless Format

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_REAL/SIPR

Codec ID: A_REAL/SIPR

Codec Name: Sipro Voice Codec

Initialization: The `CodecPrivate` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff].

### A_OPUS

Codec ID: A_OPUS

Codec Name: Opus interactive speech and audio codec

Description: The OPUS audio codec defined by [@!RFC6716] using a similar encapsulation as the Ogg Encapsulation [@!RFC7845].

Initialization: The track `CodecPrivate` **MUST** be present and contain the `Identification Header` defined in [@!RFC7845, section 5.1].

Channels: The track `Channels` element value **MUST** be the "Output Channel Count" value of the `Identification Header`.

SamplingFrequency: The track `SamplingFrequency` element value **MUST** be the "Input Sample Rate" value of the `Identification Header`.

CodecDelay: The track `CodecDelay` element **MUST** be present and set to the "Pre-skip" value of the `Identification Header` translated to Matroska Ticks.
The "Pre-skip" value is in samples at 48,000 Hz. The formula to get the `CodecDelay` is:

    CodecDelay = pre-skip * 1,000,000,000 / 48,000.

SeekPreRoll: The track `SeekPreRoll` element **SHOULD** be present and set to 80,000,000 -- 80 ms in Matroska Ticks --
in order to ensure that the output audio is correct by the time it reaches the seek target.

### A_PCM/FLOAT/IEEE

Codec ID: A_PCM/FLOAT/IEEE

Codec Name: Floating-Point, IEEE compatible

Description: The audio bit depth **MUST** be read and set from the `BitDepth` element (32 bits in most cases).
The floats are stored as defined in [@!IEEE.754] and in little-endian order.

Initialization: none

### A_PCM/INT/BIG

Codec ID: A_PCM/INT/BIG

Codec Name: PCM Integer Big Endian

Description: The audio bit depth **MUST** be read and set from the `BitDepth` element. Audio samples **MUST** be considered as signed values,
except if the audio bit depth is 8 which **MUST** be interpreted as unsigned values.

Initialization: none

### A_PCM/INT/LIT

Codec ID: A_PCM/INT/LIT

Codec Name: PCM Integer Little Endian

Description: The audio bit depth **MUST** be read and set from the `BitDepth` element. Audio samples **MUST** be considered as signed values,
except if the audio bit depth is 8 which **MUST** be interpreted as unsigned values.

Initialization: none

### A_QUICKTIME

Codec ID: A_QUICKTIME

Codec Name: Audio taken from QuickTime files

Description: Several codecs as stored in QuickTime (e.g., QDesign Music v1 or v2).

Initialization: The `CodecPrivate` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [@!QTFF].

### A_QUICKTIME/QDMC

Codec ID: A_QUICKTIME/QDMC

Codec Name: QDesign Music

Description:

Initialization: The `CodecPrivate` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [@!QTFF].

Superseded By: `A_QUICKTIME` ((#a-quicktime))

### A_QUICKTIME/QDM2

Codec ID: A_QUICKTIME/QDM2

Codec Name: QDesign Music v2

Description:

Initialization: The `CodecPrivate` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [@!QTFF].

Superseded By: `A_QUICKTIME` ((#a-quicktime))

### A_TRUEHD

Codec ID: A_TRUEHD

Codec Name: Dolby TrueHD

Description: Lossless audio codec from Dolby. Each Matroska frame corresponds to a single Access Unit as defined in [@!TRUEHD].

### A_TTA1

Codec ID: A_TTA1

Codec Name: The True Audio lossless audio compressor

Description: The format is described in [@!TTA].
Each frame is kept intact, including the CRC32. The header and seektable are dropped. `SamplingFrequency`, `Channels` and `BitDepth` are used in the `TrackEntry`.

Initialization: The `CodecPrivate` contains the TTA Header Structure, as defined in [@!TTA].

### A_VORBIS

Codec ID: A_VORBIS

Codec Name: Vorbis

Initialization: The `CodecPrivate` contains the first three Vorbis packet in order. The lengths of the packets precedes them. The actual layout is:

- Byte 1: number of distinct packets `#p` minus one inside the `CodecPrivate` block.
  This **MUST** be "2" for current (as of 2016-07-08) Vorbis headers.

- Bytes 2..n: lengths of the first `#p` packets, coded in Xiph-style lacing.
  The length of the last packet is the length of the `CodecPrivate` block minus the lengths coded in these bytes minus one.

- Bytes n+1..: The "Identification Header" as defined in Section 4.2.2 of [@!VORBIS],
  followed by the "Comment Header" as defined in Section 5 of [@!VORBIS],
  followed by the "Setup Header" as defined in Section 4.2.4 of [@!VORBIS].

### A_WAVPACK4

Codec ID: A_WAVPACK4

Codec Name: WavPack lossless audio compressor

Description: The WavPack packets consist of a block defined in [@!WAVPACK] with a `WavpackHeader` header.
For multichannel (> 2 channels) a frame consists of many packets. For more details, check the WavPack muxing description (#wavpack).

Codec BlockAdditions: For hybrid `A_WAVPACK4` encodings (that include a lossy encoding with a supplemental correction
to produce a lossless encoding), the correction part is stored in `BlockAdditional`.
The `BlockAddID` of the `BlockMore` containing these data **MUST** be 1.

Initialization: The `CodecPrivate` contains the `version` 16-bit integer from the `WavpackHeader` of [@!WAVPACK] stored in little-endian.

## Subtitle Codec Mappings

All codecs described in this section **MUST** have a `TrackType` ([@!RFC9559, section 5.1.4.1.3]) value of "17" for subtitles.

Subtitle codec often contain meta information about the data they contain, like expected output dimension, language, etc.
Whenever possible these information inside the codec **SHOULD** be extracted and repeated at the Matroska level with
the appropriate element(s) inside the `\Segment\Tracks\TrackEntry\Video` and `\Segment\Tracks\TrackEntry` elements.
These values **MUST** be valid for the whole Segment.

### S_ARIBSUB

Codec ID: S_ARIBSUB

Codec Name: ARIB STD-B24 subtitles

Description: This is the textual subtitle format used in the ISDB/ARIB broadcasting standard.
For more information see (#arib-isdb-subtitles) on ARIB (ISDB) subtitles.

### S_DVBSUB

Codec ID: S_DVBSUB

Codec Name: Digital Video Broadcasting (DVB) subtitles

Description: This is the graphical subtitle format used in the Digital Video Broadcasting standard.
For more information see (#digital-video-broadcasting-dvb-subtitles) on  Digital Video Broadcasting (DVB).

### S_HDMV/PGS

Codec ID: S_HDMV/PGS

Codec Name: HDMV presentation graphics subtitles (PGS)

Description: This is the graphical subtitle format used on Blu-rays. For more information,
see (#hdmv-text-subtitles) on HDMV text presentation.

### S_HDMV/TEXTST

Codec ID: S_HDMV/TEXTST

Codec Name: HDMV text subtitles

Description: This is the textual subtitle format used on Blu-rays. For more information,
see (#hdmv-presentation-graphics-subtitles) on HDMV graphics presentation.

### S_KATE

Codec ID: S_KATE

Codec Name: Karaoke And Text Encapsulation

Description: A subtitle format developed for ogg. The mapping for Matroska is described
on the "Matroska mapping" section of [@!OggKate].
Kate headers are stored in the `CodecPrivate` as xiph-laced packets.
The length of the last packet isn't encoded, it is deduced from the sizes of the other packets and the total size of the `CodecPrivate`.

The codec **MAY** use embedded fonts from attachments, as defined in [@?RFC9559, section 21.2], in that case the `TrackEntry` **MUST** contain a `AttachmentLink` element.

### S_IMAGE/BMP

Codec ID: S_IMAGE/BMP

Codec Name: Bitmap

Description: Basic image based subtitle format; The subtitles are stored as images, like in the DVD [@?DVD-Video].
The timestamp in the block header of Matroska indicates the start display time,
the duration is set with the `BlockDuration` element. The full data for the subtitle bitmap
is stored in the Block's data section.

### S_TEXT/ASS

Codec ID: S_TEXT/ASS

Codec Name: Advanced SubStation Alpha Format

Description: Each event is stored in its own `Block`.
For more information see (#ssa-ass-subtitles) on SSA/ASS.

This codec ID **MUST** be used when "ScriptType: v4.00+" or "[V4+ Styles]" sections are found in the original SSA script.

The codec **MAY** use embedded fonts from attachments, as defined in [@?RFC9559, section 21.2], in that case the `TrackEntry` **MUST** contain a `AttachmentLink` element.

The codec **MAY** also be found with the Codec ID `S_ASS`, but using that value is **NOT RECOMMENDED**.

Initialization: The "[Script Info]" and "[V4 Styles]" sections are stored in the `CodecPrivate`.

### S_TEXT/ASCII

Codec ID: S_TEXT/ASCII

Codec Name: ASCII Plain Text

Description: Basic text subtitles with only ASCII characters allowed.

### S_TEXT/SSA

Codec ID: S_TEXT/SSA

Codec Name: SubStation Alpha Format

Description: Each event is stored in its own `Block`.
For more information see (#ssa-ass-subtitles) on SSA/ASS.

This codec ID **MUST NOT** be used when "ScriptType: v4.00+" or "[V4+ Styles]" sections are found in the original SSA script.

The codec **MAY** use embedded fonts from attachments, as defined in [@?RFC9559, section 21.2], in that case the `TrackEntry` **MUST** contain a `AttachmentLink` element.

The codec **MAY** also be found with the Codec ID `S_SSA`, but using that value is **NOT RECOMMENDED**.

Initialization: The "[Script Info]" and "[V4+ Styles]" sections are stored in the `CodecPrivate`.

### S_TEXT/USF

Codec ID: S_TEXT/USF

Codec Name: Universal Subtitle Format

Description: An XML based subtitle format.
Each `BlockGroup` contains XML data from a "subtitle" XML element as defined in section 3.4 of [@!USF],
without the "subtitle" element itself and with the start, stop duration mapped to the `BlockGroup` timestamp and `BlockDuration` element.
The "image" XML elements are turned into Matroska attachments and replaced in the stream with their attachment filename.

The codec **MAY** use embedded fonts from attachments, as defined in [@?RFC9559, section 21.2], in that case the `TrackEntry` **MUST** contain a `AttachmentLink` element.

Initialization: The `CodecPrivate` element **MAY** be present.
If present it **MAY** contains "metadata", "styles" and "effects" XML elements usable in the whole stream inside a parent "USFSubtitles" XML parent element,
similar to the "USFSubtitles" element of a standalone USF file but without the "subtitles" XML element.

### S_TEXT/UTF8

Codec ID: S_TEXT/UTF8

Codec Name: UTF-8 Plain Text

Description: Basic text subtitles. For more information see (#subtitles) on Subtitles.

### S_TEXT/WEBVTT

Codec ID: S_TEXT/WEBVTT

Codec Name: Web Video Text Tracks Format (WebVTT)

Description: Advanced text subtitles. For more information see (#webvtt) on WebVTT.

### S_VOBSUB

Codec ID: S_VOBSUB

Codec Name: VobSub subtitles

Description: The same subtitle format used on DVDs [@?DVD-Video]. Supported is only format version 7 and newer.
VobSubs consist of two files, the .idx containing information, and the .sub, containing the actual data.
The .idx file is stripped of all empty lines, of all comments and of lines beginning with `alt:` or `langidx:`.
The line beginning with `id:` **SHOULD** be transformed into the appropriate Matroska track language element
and is discarded. All remaining lines but the ones containing timestamps and file positions
are put into the `CodecPrivate` element.

For each line containing the timestamp and file position data is read from the appropriate
position in the .sub file. This data consists of a MPEG program stream which in turn
contains SPU packets. The MPEG program stream data is discarded, and each SPU packet
is put into one Matroska frame.

## Button Codec Mappings

All codecs described in this section **MUST** have a `TrackType` ([@!RFC9559, section 5.1.4.1.3]) value of "18" for buttons.

### B_VOBBTN

Codec ID: B_VOBBTN

Codec Name: VobBtn Buttons

Description: Based on MPEG/VOB PCI packets.
The frame contains a header consisting of the string "butonDVD" followed by the width and height
in pixels (16-bit unsigned integer each) and 4 reserved bytes. The rest is a full PCI packet described in [@!DVD-Info.PCI].

## Block Addition Mappings

Registered `BlockAddIDType` are:

### Use BlockAddIDValue

Block type identifier: 0

Block type name: Use BlockAddIDValue

Description: This value indicates that the actual type is stored in `BlockAddIDValue` instead.
This value is expected to be used when it is important to have a strong compatibility
with players or derived formats not supporting `BlockAdditionMapping` but using `BlockAdditions`
with an unknown `BlockAddIDValue`, and **SHOULD NOT** be used if it is possible to use another value.

### Opaque Data

Block type identifier: 1

Block type name: Opaque data

Description: the `BlockAdditional` data is interpreted as opaque additional data passed to the codec
with the Block data.
The usage of these `BlockAdditional` data is defined in the "Codec BlockAdditions" section of the codec; see (#codec-blockadditions).

### ITU T.35 Metadata

Block type identifier: 4

Block type name: ITU T.35 metadata

Description: the `BlockAdditional` data is interpreted as ITU T.35 metadata, as defined by [@?ITU-T.35]
terminal codes. `BlockAddIDValue` **MUST** be 4.

### avcE

Block type identifier: 0x61766345

Block type name: Dolby Vision enhancement-layer AVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer AVC
configuration box as described in [@!DolbyVision-ISOBMFF]. This extension **MUST NOT**
be used if `CodecID` is not `V_MPEG4/ISO/AVC`.

### hvcE

Block type identifier: 0x68766345

Block type name: Dolby Vision enhancement-layer HEVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer HEVC configuration as described in [@!DolbyVision-ISOBMFF].
This extension **MUST NOT** be used if `CodecID` is not `V_MPEGH/ISO/HEVC`.

### dvcC

Block type identifier: 0x64766343

Block type name: Dolby Vision configuration dvcC

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 0 to 7 included.

### dvvC

Block type identifier: 0x64767643

Block type name: Dolby Vision configuration dvvC

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 8 to 10 included and 20.

### dvwC

Block type identifier: 0x64767743

Block type name: Dolby Vision configuration dvwC

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 11 to 19 included.

### mvcC

Block type identifier: 0x6D766343

Block type name: MVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as `MVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].
This extension **MUST NOT** be used if `CodecID` is not `V_MPEG4/ISO/AVC`.

