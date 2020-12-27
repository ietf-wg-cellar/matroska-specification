---
title: Codec Mappings
---

# Codec Mappings

A `Codec Mapping` is a set of attributes to identify, name, and contextualize the format
and characteristics of encoded data that can be contained within Matroska Clusters.

Each TrackEntry used within Matroska **MUST** reference a defined `Codec Mapping` using the
`Codec ID` to identify and describe the format of the encoded data in its associated Clusters.
This `Codec ID` is a unique registered identifier that represents the encoding stored within
the Track. Certain encodings **MAY** also require some form of codec initialization
in order to provide its decoder with context and technical metadata.

The intention behind this list is not to list all existing audio and video codecs,
but rather to list those codecs that are currently supported in Matroska and therefore
need a well defined `Codec ID` so that all developers supporting Matroska will use the
same `Codec ID`. If you feel we missed support for a very important codec, please tell
us on our development mailing list (cellar at ietf.org).

## Defining Matroska Codec Support

Support for a codec is defined in Matroska with the following values.

### Codec ID

Each codec supported for storage in Matroska **MUST** have a unique `Codec ID`.
Each `Codec ID` **MUST** be prefixed with the string from the following table according to
the associated type of the codec. All characters of a `Codec ID Prefix` **MUST** be
capital letters (A-Z) except for the last character of a `Codec ID Prefix` which **MUST** be
an underscore ("_").

Codec Type | Codec ID Prefix
-----------|----------------
Video      | "V_"
Audio      | "A_"
Subtitle   | "S_"
Button     | "B_"

Each `Codec ID` **MUST** include a `Major Codec ID` immediately following the `Codec ID Prefix`.
A `Major Codec ID` **MAY** be followed by an **OPTIONAL** `Codec ID Suffix` to communicate a refinement
of the `Major Codec ID`. If a `Codec ID Suffix` is used, then the `Codec ID` **MUST** include a
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

### Codec Name

Each encoding supported for storage in Matroska **MUST** have a `Codec Name`.
The `Codec Name` provides a readable label for the encoding.

### Description

An optional description for the encoding. This value is only intended for human consumption.

### Initialization

Each encoding supported for storage in Matroska **MUST** have a defined Initialization. 
The Initialization **MUST** describe the storage of data necessary to initialize the decoder,
which **MUST** be stored within the `CodecPrivate Element`. When the Initialization is updated
within a track, then that updated Initialization data **MUST** be written into the `CodecState Element`
of the first `Cluster` to require it. If the encoding does not require any form of Initialization,
then `none` **MUST** be used to define the Initialization and the `CodecPrivate Element`
**SHOULD NOT** be written and **MUST** be ignored. If the encoding does require any form of Initialization,
then `CodecPrivate Element` **MUST** be written and **MUST** be provided to the decoder.
The Initialization data to be stored in the `CodecPrivate Element` is referred to as `Private Data`.

### Codec BlockAdditions

Additional data that contextualizes or supplements a `Block` can be stored within
the `BlockAdditional Element` of a `BlockMore Element`. This `BlockAdditional` data **MAY**
be passed to the associated decoder along with the content of the `Block Element`.
Each `BlockAdditional` is coupled with a `BlockAddID` that identifies the kind of data
it contains. The following table defines the meanings of `BlockAddID` values.

BlockAddID Value | Definition
-----------------|:---------------
0                | Invalid.
1                | Indicates that the context of the `BlockAdditional` data is defined by the corresponding `Codec Mapping`.
2 or greater     | `BlockAddID` values of 2 and greater are mapped to the `BlockAddIDValue` of the `BlockAdditionMapping` of the associated Track.

The values of `BlockAddID` that are 2 of greater have no semantic meaning, but simply
associate the `BlockMore Element` with a `BlockAdditionMapping` of the associated Track.
See (#block-additional-mapping) on Block Additional Mappings for more information.

The following XML depicts the nested Elements of a `BlockGroup Element` with an example of BlockAdditions:

```xml
<BlockGroup>
  <Block>{Binary data of a VP9 video frame in YUV}</Block>
  <BlockAdditions>
    <BlockMore>
      <BlockAddID>1</BlockAddID>
      <BlockAdditional>
        {alpha channel encoding to supplement the VP9 frame}
      </BlockAdditional>
    </BlockMore>
  </BlockAdditions>
</BlockGroup>
```

### Citation

Documentation of the associated normative and informative references for the codec is **RECOMMENDED**.

### Deprecation Date

A timestamp, expressed in [@!RFC3339] that notes when support for the `Codec Mapping`
within Matroska was deprecated. If a `Codec Mapping` is defined with a `Deprecation Date`,
then it is **RECOMMENDED** that Matroska writers **SHOULD NOT** use the `Codec Mapping` after the `Deprecation Date`.

### Superseded By

A `Codec Mapping` **MAY** only be defined with a `Superseded By` value, if it has an
expressed `Deprecation Date`. If used, the `Superseded By` value **MUST** store
the `Codec ID` of another `Codec Mapping` that has superseded the `Codec Mapping`.

## Recommendations for the Creation of New Codec Mappings

Creators of new `Codec Mappings` to be used in the context of Matroska:

- **SHOULD** assume that all `Codec Mappings` they create might become standardized, public,
  commonly deployed, or usable across multiple implementations.

- **SHOULD** employ meaningful values for `Codec ID` and `Codec Name` that they have reason
  to believe are currently unused.

- **SHOULD NOT** prefix their `Codec ID` with "X_" or similar constructs.

These recommendations are based upon Section 3 of [@!RFC6648].

## Video Codec Mappings

### V_MS/VFW/FOURCC

Codec ID: `V_MS/VFW/FOURCC`

Codec Name: Microsoft (TM) Video Codec Manager (VCM)

Description: The private data contains the VCM structure BITMAPINFOHEADER including
the extra private bytes, as [defined by Microsoft](https://msdn.microsoft.com/en-us/library/windows/desktop/dd318229(v=vs.85).aspx).
The data are stored in little-endian format (like on IA32 machines). Where is the Huffman table stored
in HuffYUV, not AVISTREAMINFO ??? And the FourCC, not in AVISTREAMINFO.fccHandler ???

Initialization: `Private Data` contains the VCM structure BITMAPINFOHEADER including the extra private bytes,
as defined by Microsoft in https://msdn.microsoft.com/en-us/library/windows/desktop/dd183376(v=vs.85).aspx.

Citation: https://msdn.microsoft.com/en-us/library/windows/desktop/dd183376(v=vs.85).aspx

### V_UNCOMPRESSED

Codec ID: V_UNCOMPRESSED

Codec Name: Video, raw uncompressed video frames

Description: All details about the used color specs and bit depth are to be put/read from the KaxCodecColourSpace elements.

Initialization: none

### V_MPEG4/ISO/SP

Codec ID: V_MPEG4/ISO/SP

Codec Name: MPEG4 ISO simple profile (DivX4)

Description: Stream was created via improved codec API (UCI) or even transmuxed from AVI (no b-frames in Simple Profile), frame order is coding order.

Initialization: none

### V_MPEG4/ISO/ASP

Codec ID: V_MPEG4/ISO/ASP

Codec Name: MPEG4 ISO advanced simple profile (DivX5, XviD, FFMPEG)

Description: Stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI.
Note there are differences how b-frames are handled in these native streams,
when being compared to a VfW created stream, as here there are `no` dummy frames inserted,
the frame order is exactly the same as the coding order, same as in MP4 streams.

Initialization: none

### V_MPEG4/ISO/AP

Codec ID: V_MPEG4/ISO/AP

Codec Name: MPEG4 ISO advanced profile

Description: Stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI.
Note there are differences how b-frames are handled in these native streams,
when being compared to a VfW created stream, as here there are `no` dummy frames inserted,
the frame order is exactly the same as the coding order, same as in MP4 streams.

Initialization: none

### V_MPEG4/MS/V3

Codec ID: V_MPEG4/MS/V3

Codec Name: Microsoft (TM) MPEG4 V3

Description: Microsoft (TM) MPEG4 V3 and derivates, means DivX3, Angelpotion, SMR, etc.; stream was created using
VfW codec or transmuxed from AVI; note that V1/V2 are covered in VfW compatibility mode.

Initialization: none

### V_MPEG1

Codec ID: V_MPEG1

Codec Name: MPEG 1

Description: The Matroska video stream will contain a demuxed Elementary Stream (ES), where block boundaries are still to be defined.
Its **RECOMMENDED** to use MPEG2MKV.exe for creating those files, and to compare
the results with self-made implementations

Initialization: none

### V_MPEG2

Codec ID: V_MPEG2

Codec Name: MPEG 2

Description: The Matroska video stream will contain a demuxed Elementary Stream (ES), where block boundaries are still to be defined.
Its **RECOMMENDED** to use MPEG2MKV.exe for creating those files, and to compare
the results with self-made implementations

Initialization: none

### V_MPEG4/ISO/AVC

Codec ID: V_MPEG4/ISO/AVC

Codec Name: AVC/H.264

Description: Individual pictures (which could be a frame, a field, or 2 fields having the same timestamp) of AVC/H.264 stored as described in [@!ISO.14496-15].

Initialization: The `Private Data` contains a `AVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].
For legacy reasons, because Block Addition Mappings are preferred, see (#block-addition-mappings),
the `AVCDecoderConfigurationRecord` structure **MAY** be followed by an extension block beginning
with a 4-byte extension block size field in big-endian byte order which is the size of the extension block
minus 4 (excluding the size of the extension block size field) and a 4-byte field corresponding
to a `BlockAddIDType` of "mvcC" followed by a content corresponding to the content of `BlockAddIDExtraData` for `mvcC`; see (#mvcc).

### V_MPEGH/ISO/HEVC

Codec ID: V_MPEGH/ISO/HEVC

Codec Name: HEVC/H.265

Description: Individual pictures (which could be a frame, a field, or 2 fields having the same timestamp) of HEVC/H.265 stored as described in [@!ISO.14496-15].

Initialization: The `Private Data` contains a `HEVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].

### V_AVS2

Codec ID: V_AVS2

Codec Name: AVS2-P2/IEEE.1857.4

Description: Individual pictures of AVS2-P2 stored as described in the second part of [@!IEEE.1857-4].

Initialization: none.

### V_REAL/RV10

Codec ID: V_REAL/RV10

Codec Name: RealVideo 1.0 aka RealVideo 5

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `Private Data` contains a `real_video_props_t` structure in big-endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### V_REAL/RV20

Codec ID: V_REAL/RV20

Codec Name: RealVideo G2 and RealVideo G2+SVT

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `Private Data` contains a `real_video_props_t` structure in big-endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### V_REAL/RV30

Codec ID: V_REAL/RV30

Codec Name: RealVideo 8

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `Private Data` contains a `real_video_props_t` structure in big-endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### V_REAL/RV40

Codec ID: V_REAL/RV40

Codec Name: rv40 : RealVideo 9

Description: Individual slices from the Real container are combined into a single frame.

Initialization: The `Private Data` contains a `real_video_props_t` structure in big-endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### V_QUICKTIME

Codec ID: V_QUICKTIME

Codec Name: Video taken from QuickTime(TM) files

Description: Several codecs as stored in QuickTime, e.g., Sorenson or Cinepak.

Initialization: The `Private Data` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory video descriptor structure
(starting with the size and FourCC fields). For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

### V_THEORA

Codec ID: V_THEORA

Codec Name: Theora

Initialization: The `Private Data` contains the first three Theora packets in order. The lengths of the packets precedes them. The actual layout is:

* Byte 1: number of distinct packets `#p` minus one inside the `Private Data`. This **MUST** be "2" for current (as of 2016-07-08) Theora headers.
* Bytes 2..n: lengths of the first `#p` packets, coded in Xiph-style lacing. The length of the last packet is the length of the `Private Data` minus the lengths coded in these bytes minus one.
* Bytes n+1..: The Theora identification header, followed by the commend header followed by the codec setup header. Those are described in the [Theora specs](http://www.theora.org/doc/Theora.pdf).

### V_PRORES

Codec ID: V_PRORES

Codec Name: Apple ProRes

Initialization: The `Private Data` contains the FourCC as found in MP4 movies:

*   ap4x: ProRes 4444 XQ
*   ap4h: ProRes 4444
*   apch: ProRes 422 High Quality
*   apcn: ProRes 422 Standard Definition
*   apcs: ProRes 422 LT
*   apco: ProRes 422 Proxy
*   aprh: ProRes RAW High Quality
*   aprn: ProRes RAW Standard Definition

[this page for more technical details on ProRes](http://wiki.multimedia.cx/index.php?title=Apple_ProRes#Frame_layout)

### V_VP8

Codec ID: V_VP8

Codec Name: VP8 Codec format

Description: VP8 is an open and royalty free video compression format developed by Google and created by On2 Technologies as a successor to VP7. [@!RFC6386]

Codec BlockAdditions: A single-channel encoding of an alpha channel **MAY** be stored in `BlockAdditions`. The `BlockAddId` of the `BlockMore` containing these data **MUST** be 1.

Initialization: none

### V_VP9

Codec ID: V_VP9

Codec Name: VP9 Codec format

Description: VP9 is an open and royalty free video compression format developed by Google as a successor to VP8. [Draft VP9 Bitstream and Decoding Process Specification](https://www.webmproject.org/vp9/)

Codec BlockAdditions: A single-channel encoding of an alpha channel **MAY** be stored in `BlockAdditions`. The `BlockAddId` of the `BlockMore` containing these data **MUST** be 1.

Initialization: none

### V_FFV1

Codec ID: V_FFV1

Codec Name: FF Video Codec 1

Description: FFV1 is a lossless intra-frame video encoding format designed to efficiently compress video data in a variety of pixel formats.
Compared to uncompressed video, FFV1 offers storage compression, frame fixity, and self-description,
which makes FFV1 useful as a preservation or intermediate video format. [Draft FFV1 Specification](https://datatracker.ietf.org/doc/draft-ietf-cellar-ffv1/)

Initialization: For FFV1 versions 0 or 1, none. For FFV1 version 3 or greater, the `Private Data` contains the FFV1 Configuration Record structure, as defined in https://tools.ietf.org/html/draft-ietf-cellar-ffv1-04#section-4.2, and no other data.

## Audio Codec Mappings

### A_MPEG/L3

Codec ID: A_MPEG/L3

Codec Name: MPEG Audio 1, 2, 2.5 Layer III

Description: The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0055

Initialization: none

### A_MPEG/L2

Codec ID: A_MPEG/L2

Codec Name: MPEG Audio 1, 2 Layer II

Description: The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0050

Initialization: none

### A_MPEG/L1

Codec ID: A_MPEG/L1

Codec Name: MPEG Audio 1, 2 Layer I

Description: The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0050

Initialization: none

### A_PCM/INT/BIG

Codec ID: A_PCM/INT/BIG

Codec Name: PCM Integer Big Endian

Description: The audio bit depth **MUST** be read and set from the `BitDepth Element`. Audio samples **MUST** be considered as signed values,
except if the audio bit depth is 8 which **MUST** be interpreted as unsigned values. Corresponding ACM wFormatTag : ???

Initialization: none

### A_PCM/INT/LIT

Codec ID: A_PCM/INT/LIT

Codec Name: PCM Integer Little Endian

Description: The audio bit depth **MUST** be read and set from the `BitDepth Element`. Audio samples **MUST** be considered as signed values,
except if the audio bit depth is 8 which **MUST** be interpreted as unsigned values. Corresponding ACM wFormatTag : 0x0001

Initialization: none

### A_PCM/FLOAT/IEEE

Codec ID: A_PCM/FLOAT/IEEE

Codec Name: Floating Point, IEEE compatible

Description: The audio bit depth **MUST** be read and set from the `BitDepth Element` (32 bit in most cases).
The floats are stored as defined in [@!IEEE.754] and in little-endian order. Corresponding ACM wFormatTag : 0x0003

Initialization: none

### A_MPC

Codec ID: A_MPC

Codec Name: MPC (musepack) SV8

Description: The main developer for musepack has requested that we wait until the SV8 framing has been fully defined
for musepack before defining how to store it in Matroska.

### A_AC3

Codec ID: A_AC3

Codec Name: (Dolby™) AC3

Description: For BSID <= 8. Corresponding ACM wFormatTag : 0x2000 ; channel number have
to be read from the corresponding audio element

Initialization: none

### A_AC3/BSID9

Codec ID: A_AC3/BSID9

Codec Name: (Dolby™) AC3

Description: The ac3 frame header has, similar to the mpeg-audio header a version field. Normal ac3 is defined as bitstream id 8 (5 Bits, numbers are 0-15).
Everything below 8 is still compatible with all decoders that handle 8 correctly.
Everything higher are additions that break decoder compatibility.
For the samplerates 24kHz (00); 22,05kHz (01) and 16kHz (10) the BSID is 9
For the samplerates 12kHz (00); 11,025kHz (01) and 8kHz (10) the BSID is 10

Initialization: none

### A_AC3/BSID10

Codec ID: A_AC3/BSID10

Codec Name: (Dolby™) AC3

Description: The ac3 frame header has, similar to the mpeg-audio header a version field. Normal ac3 is defined as bitstream id 8 (5 Bits, numbers are 0-15).
Everything below 8 is still compatible with all decoders that handle 8 correctly.
Everything higher are additions that break decoder compatibility.
For the samplerates 24kHz (00); 22,05kHz (01) and 16kHz (10) the BSID is 9
For the samplerates 12kHz (00); 11,025kHz (01) and 8kHz (10) the BSID is 10

Initialization: none

### A_ALAC

Codec ID: A_ALAC

Codec Name: ALAC (Apple Lossless Audio Codec)

Initialization: The `Private Data` contains ALAC's magic cookie (both the codec specific configuration as well as the optional channel layout information).
Its format is described in [ALAC's official source code](http://alac.macosforge.org/trac/browser/trunk/ALACMagicCookieDescription.txt).

### A_DTS

Codec ID: A_DTS

Codec Name: Digital Theatre System

Description: Supports DTS, DTS-ES, DTS-96/26, DTS-HD High Resolution Audio and DTS-HD Master Audio.
The private data is void. Corresponding ACM wFormatTag : 0x2001

Initialization: none

### A_DTS/EXPRESS

Codec ID: A_DTS/EXPRESS

Codec Name: Digital Theatre System Express

Description: DTS Express (a.k.a. LBR) audio streams. The private data is void. Corresponding ACM wFormatTag : 0x2001

Initialization: none

### A_DTS/LOSSLESS

Codec ID: A_DTS/LOSSLESS

Codec Name: Digital Theatre System Lossless

Description: DTS Lossless audio that does not have a core substream. The private data is void. Corresponding ACM wFormatTag : 0x2001

Initialization: none

### A_VORBIS

Codec ID: A_VORBIS

Codec Name: Vorbis

Initialization: The `Private Data` contains the first three Vorbis packet in order. The lengths of the packets precedes them. The actual layout is:
- Byte 1: number of distinct packets `#p` minus one inside the `Private Data`.
  This **MUST** be "2" for current (as of 2016-07-08) Vorbis headers.
- Bytes 2..n: lengths of the first `#p` packets, coded in Xiph-style lacing.
  The length of the last packet is the length of the `Private Data` minus the lengths coded in these bytes minus one.
- Bytes n+1..: The [Vorbis identification header](https://xiph.org/vorbis/doc/Vorbis_I_spec.html),
  followed by the [Vorbis comment header](https://xiph.org/vorbis/doc/v-comment.html)
  followed by the [codec setup header](https://xiph.org/vorbis/doc/Vorbis_I_spec.html).

### A_FLAC

Codec ID: A_FLAC

Codec Name: [FLAC (Free Lossless Audio Codec)](http://flac.sourceforge.net/)

Initialization: The `Private Data` contains all the header/metadata packets before the first data packet.
These include the first header packet containing only the word `fLaC` as well as all metadata packets.

### A_REAL/14_4

Codec ID: A_REAL/14_4

Codec Name: Real Audio 1

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_REAL/28_8

Codec ID: A_REAL/28_8

Codec Name: Real Audio 2

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_REAL/COOK

Codec ID: A_REAL/COOK

Codec Name: Real Audio Cook Codec (codename: Gecko)

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_REAL/SIPR

Codec ID: A_REAL/SIPR

Codec Name: Sipro Voice Codec

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_REAL/RALF

Codec ID: A_REAL/RALF

Codec Name: Real Audio Lossless Format

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_REAL/ATRC

Codec ID: A_REAL/ATRC

Codec Name: Sony Atrac3 Codec

Initialization: The `Private Data` contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure
(differentiated by their "version" field; big-endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

### A_MS/ACM

Codec ID: A_MS/ACM

Codec Name: Microsoft(TM) Audio Codec Manager (ACM)

Description: The data are stored in little-endian format (like on IA32 machines).

Initialization: The `Private Data` contains the ACM structure WAVEFORMATEX including the extra private bytes,
as [defined by Microsoft](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/multimed/mmstr_625u.asp).

### A_AAC/MPEG2/MAIN

Codec ID: A_AAC/MPEG2/MAIN

Codec Name: MPEG2 Main Profile

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG2/LC

Codec ID: A_AAC/MPEG2/LC

Codec Name: Low Complexity

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG2/LC/SBR

Codec ID: A_AAC/MPEG2/LC/SBR

Codec Name: Low Complexity with Spectral Band Replication

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG2/SSR

Codec ID: A_AAC/MPEG2/SSR

Codec Name: Scalable Sampling Rate

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG4/MAIN

Codec ID: A_AAC/MPEG4/MAIN

Codec Name: MPEG4 Main Profile

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG4/LC

Codec ID: A_AAC/MPEG4/LC

Codec Name: Low Complexity

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG4/LC/SBR

Codec ID: A_AAC/MPEG4/LC/SBR

Codec Name: Low Complexity with Spectral Band Replication

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG4/SSR

Codec ID: A_AAC/MPEG4/SSR

Codec Name: Scalable Sampling Rate

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_AAC/MPEG4/LTP

Codec ID: A_AAC/MPEG4/LTP

Codec Name: Long Term Prediction

Description: Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped
from ADTS headers and normal Matroska frame based muxing scheme is applied.
AAC audio always uses wFormatTag 0xFF.

Initialization: none

### A_QUICKTIME

Codec ID: A_QUICKTIME

Codec Name: Audio taken from QuickTime(TM) files

Description: Several codecs as stored in QuickTime, e.g., QDesign Music v1 or v2.

Initialization: The `Private Data` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

### A_QUICKTIME/QDMC

Codec ID: A_QUICKTIME/QDMC

Codec Name: QDesign Music

Description:

Initialization: The `Private Data` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

Superseded By: A_QUICKTIME

### A_QUICKTIME/QDM2

Codec ID: A_QUICKTIME/QDM2

Codec Name: QDesign Music v2

Description:

Initialization: The `Private Data` contains all additional data that is stored in the 'stsd' (sample description) atom
in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields).
For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

Superseded By: A_QUICKTIME

### A_TTA1

Codec ID: A_TTA1

Codec Name: [The True Audio](http://tausoft.org/) lossless audio compressor

Description: [TTA format description](http://tausoft.org/wiki/True_Audio_Codec_Format)
Each frame is kept intact, including the CRC32. The header and seektable are dropped. SamplingFrequency, Channels and BitDepth are used in the TrackEntry. wFormatTag = 0x77A1

Initialization: none

### A_WAVPACK4

Codec ID: A_WAVPACK4

Codec Name: [WavPack](http://www.wavpack.com/) lossless audio compressor

Description: The Wavpack packets consist of a stripped header followed by the frame data. For multi-track (> 2 tracks) a frame consists
of many packets. For more details, check the [WavPack muxing description](wavpack.html).

Codec BlockAdditions: For hybrid `A_WAVPACK4` encodings (that include a lossy encoding with a supplemental correction
to produce a lossless encoding), the correction part is stored in BlockAdditional.
The `BlockAddId` of the `BlockMore` containing these data **MUST** be 1.

Initialization: none

## Subtitle Codec Mappings

### S_TEXT/UTF8

Codec ID: S_TEXT/UTF8

Codec Name: UTF-8 Plain Text

Description: Basic text subtitles. For more information, see (#subtitles) on Subtitles.

Initialization: none

### S_TEXT/SSA

Codec ID: S_TEXT/SSA

Codec Name: Subtitles Format

Description: Each event is stored in its own Block.
For more information, see (#ssa-ass-subtitles) on SSA/ASS.

Initialization: The `Private Data` contains the [Script Info] and [V4 Styles] sections.

### S_TEXT/ASS

Codec ID: S_TEXT/ASS

Codec Name: Advanced Subtitles Format

Description: Each event is stored in its own Block.
For more information, see (#ssa-ass-subtitles) on SSA/ASS.

Initialization: The `Private Data` contains the [Script Info] and [V4+ Styles] sections.

### S_TEXT/WEBVTT

Codec ID: S_TEXT/WEBVTT

Codec Name: Web Video Text Tracks Format (WebVTT)

Description: Advanced text subtitles. For more information, see (#webvtt) on WebVTT.

Initialization: none

### S_IMAGE/BMP

Codec ID: S_IMAGE/BMP

Codec Name: Bitmap

Description: Basic image based subtitle format; The subtitles are stored as images, like in the DVD.
The timestamp in the block header of Matroska indicates the start display time,
the duration is set with the Duration element. The full data for the subtitle bitmap
is stored in the Block's data section.

Initialization: none

### S_DVBSUB

Codec ID: S_DVBSUB

Codec Name: Digital Video Broadcasting (DVB) subtitles

Description: This is the graphical subtitle format used in the Digital Video Broadcasting standard.
For more information, see (#digital-video-broadcasting-dvb-subtitles) on  Digital Video Broadcasting (DVB).

Initialization: none

### S_VOBSUB

Codec ID: S_VOBSUB

Codec Name: VobSub subtitles

Description: The same subtitle format used on DVDs. Supported is only format version 7 and newer.
VobSubs consist of two files, the .idx containing information, and the .sub, containing the actual data.

For each line containing the timestamp and file position data is read from the appropriate
position in the .sub file. This data consists of a MPEG program stream which in turn
contains SPU packets. The MPEG program stream data is discarded, and each SPU packet
is put into one Matroska frame.

Initialization: The .idx file is stripped of all empty lines, of all comments and of lines beginning with `alt:` or `langidx:`.
The line beginning with `id:` **SHOULD** be transformed into the appropriate Matroska track language element
and is discarded. The `Private Data` contains all remaining lines but the ones containing timestamps and file positions.

### S_HDMV/PGS

Codec ID: S_HDMV/PGS

Codec Name: HDMV presentation graphics subtitles (PGS)

Description: This is the graphical subtitle format used on Blu-rays. For more information,
see (#hdmv-text-subtitles) on HDMV text presentation.

Initialization: none

### S_HDMV/TEXTST

Codec ID: S_HDMV/TEXTST

Codec Name: HDMV text subtitles

Description: This is the textual subtitle format used on Blu-rays. For more information,
see (#hdmv-presentation-graphics-subtitles) on HDMV graphics presentation.

Initialization: none

### S_KATE

Codec ID: S_KATE

Codec Name: Karaoke And Text Encapsulation

Description: A subtitle format developed for ogg. The mapping for Matroska is described
on the [Xiph wiki](http://wiki.xiph.org/index.php/OggKate#Matroska_mapping).
As for Theora and Vorbis, Kate headers are stored in the private data as xiph-laced packets.

Initialization: none

## Button Codec Mappings

### B_VOBBTN

Codec ID: B_VOBBTN

Codec Name: VobBtn Buttons

Description: Based on [MPEG/VOB PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html).
The file contains a header consisting of the string "butonDVD" followed by the width and height
in pixels (16 bits integer each) and 4 reserved bytes. The rest is full [PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html).

Initialization: none

## Block Addition Mappings

Registered `BlockAddIDType` are:

### Use BlockAddIDValue

Block type identifier: 0

Block type name: Use BlockAddIDValue

Description: This value indicates that the actual type is stored in `BlockAddIDValue` instead.
This value is expected to be used when it is important to have a strong compatibility
with players or derived formats not supporting `BlockAdditionMapping` but using `BlockAdditions`
with an unknown `BlockAddIDValue`, and **SHOULD NOT** be used if it is possible to use another value.

### Opaque data

Block type identifier: 1

Block type name: Opaque data

Description: the `BlockAdditional` data is interpreted as opaque additional data passed to the codec
with the Block data. `BlockAddIDValue` **MUST** be 1.

### ITU T.35 metadata

Block type identifier: 4

Block type name: ITU T.35 metadata

Description: the `BlockAdditional` data is interpreted as ITU T.35 metadata, as defined by ITU-T T.35
terminal codes. `BlockAddIDValue` **MUST** be 4.

### avcE

Block type identifier: 0x61766345

Block type name: Dolby Vision enhancement-layer AVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer AVC
configuration box as described in [@!DolbyVisionWithinIso]. This extension **MUST NOT**
be used if `Codec ID` is not `V_MPEG4/ISO/AVC`.

### dvcC

Block type identifier: 0x64766343

Block type name: Dolby Vision configuration

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVisionWithinIso],
for Dolby Vision profiles less than and equal to 7.

### dvvC

Block type identifier: 0x664767643

Block type name: Dolby Vision configuration

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVisionWithinIso],
for Dolby Vision profiles greater than 7.

### hvcE

Block type identifier: 0x68766345

Block type name: Dolby Vision enhancement-layer HEVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer HEVC configuration as described in [@!DolbyVisionWithinIso].
This extension **MUST NOT** be used if `Codec ID` is not `V_MPEGH/ISO/HEVC`.

### mvcC

Block type identifier: 0x6D766343

Block type name: MVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as `MVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].
This extension **MUST NOT** be used if `Codec ID` is not `V_MPEG4/ISO/AVC`.
