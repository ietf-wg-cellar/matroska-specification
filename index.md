---
layout: default
---

# Introduction

Matroska aims to become THE standard of multimedia container formats. It was derived from a project called MCF, but differentiates from it significantly because it is based on EBML (Extensible Binary Meta Language), a binary derivative of XML. EBML enables significant advantages in terms of future format extensibility, without breaking file support in old parsers.

First, it is essential to clarify exactly "What an Audio/Video container is", to avoid any misunderstandings:

    It is NOT a video or audio compression format (video codec)
    It is an envelope for which there can be many audio, video and subtitles streams, allowing the user to store a complete movie or CD in a single file.

Matroska is designed with the future in mind. It incorporates features like:

    Fast seeking in the file
    Chapter entries
    Full metadata (tags) support
    Selectable subtitle/audio/video streams
    Modularly expandable
    Error resilience (can recover playback even when the stream is damaged)
    Streamable over the internet and local networks (HTTP, CIFS, FTP, etc)
    Menus (like DVDs have)

Matroska is an open standards project. This means for personal use it is absolutely free to use and that the technical specifications describing the bitstream are open to everybody, even to companies that would like to support it in their products.

### Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/). But since it's quite complete it is used as a reference for the development of libmatroska. Legacy versions of the specification can be found [here](https://matroska.org/files/matroska.pdf) (PDF doc by Alexander Noé -- outdated).

For a simplified diagram of the layout of a Matroska file, see the [Diagram page]({{site.baseurl}}/diagram.html).

A more refined and detailed version of the EBML specifications is being [worked on here](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown).

The table found below is now generated from the "source" of the Matroska specification. This [XML file](https://github.com/Matroska-Org/foundation-source/blob/master/spectool/specdata.xml) is also used to generate the semantic data used in libmatroska and libmatroska2\. We encourage anyone to use and monitor its changes so your code is spec-proof and always up to date.

Note that versions 1, 2 and 3 have been finalized. Version 4 is currently work in progress. There may be further additions to v4.


### Basis in EBML

Matroska is a Document Type of EBML (Extensible Binary Meta Language). This specification is dependent on the [EBML Specification](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown). For an understanding of Matroska's EBML Schema, see in particular the sections of the EBML Specification covering [EBML Element Types](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#ebml-element-types), [EBML Schema](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#ebml-schema), and [EBML Structure](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#structure).

## Elements semantic

A more detailed description of the column headers can be found in the [Specification Notes]({{site.baseurl}}/notes.html#table-columns).

If you are interrested in WebM you can have a look at this page that describes what [parts of Matroska it kept](http://www.webmproject.org/code/specs/container/).

*   Element Name - The full name of the described element.
*   L - Level - The level within an EBML tree that the element may occur at. + is for a recursive level (can be its own child). g: global element (can be found at any level)
*   EBML ID - The Element ID displayed as octets.
*   Ma - Mandatory - This element is mandatory in the file (abbreviated as »mand.«).
*   Mu - Multiple - The element may appear multiple times within its parent element (abbreviated as »mult.«).
*   Rng - Range - Valid range of values to store in the element.
*   Default - The default value of the element.
*   T - Element Type - The form of data the element contains. m: Master, u: unsigned int, i: signed integer, s: string, 8: UTF-8 string, b: binary, f: float, d: date
*   1 - The element is contained in Matroska version 1.
*   2 - The element is contained in Matroska version 2.
*   3 - The element is contained in Matroska version 3.
*   4 - The element is contained in Matroska version 4 (v4 is still work in progress; further additions are possible).
*   W - All elements available for use in WebM.
*   Description - A short description of the element's purpose.



| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> |                Description           |
| <a name="EBMLHeader"></a>EBML Header |
| <a name="EBML"></a> EBML | 0 | [1A][45][DF][A3] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Set the EBML characteristics of the data to follow. Each EBML document has to start with this. |
| <a name="EBMLVersion"></a> EBMLVersion | 1 | [42][86] | mand. | - | - | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The version of EBML parser used to create the file. |
| <a name="EBMLReadVersion"></a> EBMLReadVersion | 1 | [42][F7] | mand. | - | - | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The minimum EBML version a parser has to support to read this file. |
| <a name="EBMLMaxIDLength"></a> EBMLMaxIDLength | 1 | [42][F2] | mand. | - | - | 4 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The maximum length of the IDs you'll find in this file (4 or less in Matroska). |
| <a name="EBMLMaxSizeLength"></a> EBMLMaxSizeLength | 1 | [42][F3] | mand. | - | - | 8 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The maximum length of the sizes you'll find in this file (8 or less in Matroska). This does not override the element size indicated at the beginning of an element. Elements that have an indicated size which is larger than what is allowed by EBMLMaxSizeLength shall be considered invalid. |
| <a name="DocType"></a>DocType | 1 | [42][82] | mand. | - | - | matroska | <abbr title="String">s</abbr> | * | * | * | * | * | A string that describes the type of document that follows this EBML header. 'matroska' in our case or 'webm' for webm files. |
| <a name="DocTypeVersion"></a>DocTypeVersion | 1 | [42][87] | mand. | - | - | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The version of DocType interpreter used to create the file. |
| <a name="DocTypeReadVersion"></a>DocTypeReadVersion | 1 | [42][85] | mand. | - | - | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The minimum DocType version an interpreter has to support to read this file. |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| Global elements (used everywhere in the format) |
| <a name="Void"></a>Void | g | [EC] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | * | Used to void damaged data, to avoid unexpected behaviors when using damaged data. The content is discarded. Also used to reserve space in a sub-element for later use. |
| <a name="CRC-32"></a>CRC-32 | g | [BF] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | The CRC is computed on all the data of the Master element it's in. The CRC element should be the first in it's parent master for easier reading. All level 1 elements should include a CRC-32\. The CRC in use is the IEEE CRC32 Little Endian |
| <a name="SignatureSlot"></a>SignatureSlot | g | [1B][53][86][67] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | Contain signature of some (coming) elements in the stream. |
| <a name="SignatureAlgo"></a>SignatureAlgo | 1 | [7E][8A] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | Signature algorithm used (1=RSA, 2=elliptic). |
| <a name="SignatureHash"></a>SignatureHash | 1 | [7E][9A] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | Hash algorithm used (1=SHA1-160, 2=MD5). |
| <a name="SignaturePublicKey"></a>SignaturePublicKey | 1 | [7E][A5] | - | - | - | - | <abbr title="Binary">b</abbr> | The public key to use with the algorithm (in the case of a PKI-based signature). |
| <a name="Signature"></a>Signature | 1 | [7E][B5] | - | - | - | - | <abbr title="Binary">b</abbr> | The signature of the data (until a new. |
| <a name="SignatureElements"></a>SignatureElements | 1 | [7E][5B] | - | - | - | - | <abbr title="Master Elements">m</abbr> | Contains elements that will be used to compute the signature. |
| <a name="SignatureElementList"></a>SignatureElementList | 2 | [7E][7B] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | A list consists of a number of consecutive elements that represent one case where data is used in signature. Ex: _Cluster|Block|BlockAdditional_ means that the BlockAdditional of all Blocks in all Clusters is used for encryption. |
| <a name="SignedElement"></a>SignedElement | 3 | [65][32] | - | mult. | - | - | <abbr title="Binary">b</abbr> | An element ID whose data will be used to compute the signature. |

The default values defined for the EBML header correspond to the values for a Matroska stream/file. When parsing the EBML header the default values are different, irrespective of the DocType defined.

*   EBMLMaxIDLength is 4: IDs in the EBML header cannot be longer than 4 octets.
*   EBMLMaxSizeLength is 4: Length of IDs in the EBML header cannot be longer than 4 octets.



| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="Segment"></a>Segment |
| Segment | 0 | [18][53][80][67] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | This element contains all other top-level (level 1) elements. Typically a Matroska file is composed of 1 segment. |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="MetaSeekInformation"></a>Meta Seek Information |
| <a name="SeekHead"></a>SeekHead | 1 | [11][4D][9B][74] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains the [position]({{site.baseurl}}/notes.html#position-references) of other level 1 elements. |
| <a name="Seek"></a>Seek | 2 | [4D][BB] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains a single seek entry to an EBML element. |
| <a name="SeekID"></a>SeekID | 3 | [53][AB] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | * | The binary ID corresponding to the element name. |
| <a name="SeekPosition"></a>SeekPosition | 3 | [53][AC] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The [position]({{site.baseurl}}/notes.html#position-references) of the element in the segment in octets (0 = first level 1 element). |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="SegmentInformation"></a>Segment Information |
| Info | 1 | [15][49][A9][66] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains miscellaneous general information and statistics on the file. |
| <a name="SegmentUID"></a>SegmentUID | 2 | [73][A4] | - | - | not 0 | - | <abbr title="Binary">b</abbr> | * | * | * | * | A randomly generated unique ID to identify the current segment between many others (128 bits). |
| <a name="SegmentFilename"></a>SegmentFilename | 2 | [73][84] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | A filename corresponding to this segment. |
| <a name="PrevUID"></a> PrevUID | 2 | [3C][B9][23] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | A unique ID to identify the previous chained segment (128 bits). |
| <a name="PrevFilename"></a> PrevFilename | 2 | [3C][83][AB] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | An escaped filename corresponding to the previous segment. |
| <a name="NextUID"></a> NextUID | 2 | [3E][B9][23] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | A unique ID to identify the next chained segment (128 bits). |
| <a name="NextFilename"></a> NextFilename | 2 | [3E][83][BB] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | An escaped filename corresponding to the next segment. |
| <a name="SegmentFamily"></a>SegmentFamily | 2 | [44][44] | - | mult. | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | A randomly generated unique ID that all segments related to each other must use (128 bits). |
| <a name="ChapterTranslate"></a>ChapterTranslate | 2 | [69][24] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | A tuple of corresponding ID used by chapter codecs to represent this segment. |
| <a name="ChapterTranslateEditionUID"></a>ChapterTranslateEditionUID | 3 | [69][FC] | - | mult. | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify an edition UID on which this correspondance applies. When not specified, it means for all editions found in the segment. |
| <a name="ChapterTranslateCodec"></a>ChapterTranslateCodec | 3 | [69][BF] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The [chapter codec]({{site.baseurl}}/index.html#ChapProcessCodecID) using this ID (0: Matroska Script, 1: DVD-menu). |
| <a name="ChapterTranslateID"></a> ChapterTranslateID | 3 | [69][A5] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | The binary value used to represent this segment in the chapter codec data. The format depends on the [ChapProcessCodecID]({{site.baseurl}}/chapters/index.html#ChapProcessCodecID) used. |
| <a name="TimecodeScale"></a>TimecodeScale | 2 | [2A][D7][B1] | mand. | - | - | 1000000 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Timestamp scale in nanoseconds (1.000.000 means all timestamps in the segment are expressed in milliseconds). |
| <a name="Duration"></a>Duration | 2 | [44][89] | - | - | > 0 | - | <abbr title="Float">f</abbr> | * | * | * | * | * | Duration of the segment (based on TimecodeScale). |
| <a name="DateUTC"></a>DateUTC | 2 | [44][61] | - | - | - | - | <abbr title="Date">d</abbr> | * | * | * | * | * | Date of the origin of timestamp (value 0), i.e. production date. |
| <a name="Title"></a>Title | 2 | [7B][A9] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | General name of the segment. |
| <a name="MuxingApp"></a>MuxingApp | 2 | [4D][80] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | Muxing application or library ("libmatroska-0.4.3"). |
| <a name="WritingApp"></a>WritingApp | 2 | [57][41] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | Writing application ("mkvmerge-0.3.3"). |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="Cluster"></a>Cluster |
| Cluster | 1 | [1F][43][B6][75] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | The lower level element containing the (monolithic) Block structure. |
| <a name="Timecode"></a>Timecode | 2 | [E7] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Absolute timestamp of the cluster (based on TimecodeScale). |
| <a name="SilentTracks"></a> SilentTracks | 2 | [58][54] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | The list of tracks that are not used in that part of the stream. It is useful when using overlay tracks on seeking. Then you should decide what track to use. |
| <a name="SilentTrackNumber"></a>SilentTrackNumber | 3 | [58][D7] | - | mult. | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | One of the track number that are not used from now on in the stream. It could change later if not specified as silent in a further Cluster. |
| <a name="Position"></a>Position | 2 | [A7] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The [Position]({{site.baseurl}}/notes.html#position-references) of the Cluster in the segment (0 in live broadcast streams). It might help to resynchronise offset on damaged streams. |
| <a name="PrevSize"></a>PrevSize | 2 | [AB] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Size of the previous Cluster, in octets. Can be useful for backward playing. |
| <a name="SimpleBlock"></a>SimpleBlock | 2 | [A3] | - | mult. | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Similar to [Block]({{site.baseurl}}/index.html#block) but without all the extra information, mostly used to reduced overhead when no extra feature is needed. (see [SimpleBlock Structure]({{site.baseurl}}/index.html#simpleblock-structure)) |
| <a name="BlockGroup"></a>BlockGroup | 2 | [A0] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Basic container of information containing a single Block or BlockVirtual, and information specific to that Block/VirtualBlock. |
| <a name="Block"></a>Block | 3 | [A1] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | * | Block containing the actual data to be rendered and a timestamp relative to the Cluster Timecode. (see [Block Structure]({{site.baseurl}}/index.html#block-structure)) |
| <a name="BlockVirtual"></a>BlockVirtual | 3 | [A2] | - | - | - | - | <abbr title="Binary">b</abbr> | A Block with no data. It must be stored in the stream at the place the real Block should be in display order. (see [Block Virtual]({{site.baseurl}}/index.html#virtual-block)) |
| <a name="BlockAdditions"></a> BlockAdditions | 3 | [75][A1] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contain additional blocks to complete the main one. An EBML parser that has no knowledge of the Block structure could still see and use/skip these data. |
| <a name="BlockMore"></a>BlockMore | 4 | [A6] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contain the BlockAdditional and some parameters. |
| <a name="BlockAddID"></a> BlockAddID | 5 | [EE] | mand. | - | not 0 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | An ID to identify the BlockAdditional level. |
| <a name="BlockAdditional"></a>BlockAdditional | 5 | [A5] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Interpreted by the codec as it wishes (using the BlockAddID). |
| <a name="BlockDuration"></a>BlockDuration | 3 | [9B] | - | - | - | DefaultDuration | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The duration of the Block (based on TimecodeScale). This element is mandatory when DefaultDuration is set for the track (but can be omitted as other default values). When not written and with no DefaultDuration, the value is assumed to be the difference between the timestamp of this Block and the timestamp of the next Block in "display" order (not coding order). This element can be useful at the end of a Track (as there is not other Block available), or when there is a break in a track like for subtitle tracks. When set to 0 that means the frame is not a keyframe. |
| <a name="ReferencePriority"></a>ReferencePriority | 3 | [FA] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | This frame is referenced and has the specified cache priority. In cache only a frame of the same or higher priority can replace this frame. A value of 0 means the frame is not referenced. |
| <a name="ReferenceBlock"></a>ReferenceBlock | 3 | [FB] | - | mult. | - | - | <abbr title="Signed Integer">i</abbr> | * | * | * | * | * | Timestamp of another frame used as a reference (ie: B or P frame). The timestamp is relative to the block it's attached to. |
| <a name="ReferenceVirtual"></a>ReferenceVirtual | 3 | [FD] | - | - | - | - | <abbr title="Signed Integer">i</abbr> | Relative [position]({{site.baseurl}}/notes.html#position-references) of the data that should be in position of the virtual block. |
| <a name="CodecState"></a>CodecState | 3 | [A4] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | The new codec state to use. Data interpretation is private to the codec. This information should always be referenced by a seek entry. |
| <a name="DiscardPadding"></a>DiscardPadding | 3 | [75][A2] | - | - | - | - | <abbr title="Signed Integer">i</abbr> | * | * | Duration in nanoseconds of the silent data added to the Block (padding at the end of the Block for positive value, at the beginning of the Block for negative value). The duration of DiscardPadding is not calculated in the duration of the TrackEntry and should be discarded during playback. |
| <a name="Slices"></a>Slices | 3 | [8E] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains slices description. |
| <a name="TimeSlice"></a>TimeSlice | 4 | [E8] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains extra time information about the data contained in the Block. While there are a few files in the wild with this element, it is no longer in use and has been deprecated. Being able to interpret this element is not required for playback. |
| <a name="LaceNumber"></a>LaceNumber | 5 | [CC] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The reverse number of the frame in the lace (0 is the last frame, 1 is the next to last, etc). While there are a few files in the wild with this element, it is no longer in use and has been deprecated. Being able to interpret this element is not required for playback. |
| <a name="FrameNumber"></a>FrameNumber | 5 | [CD] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | The number of the frame to generate from this lace with this delay (allow you to generate many frames from the same Block/Frame). |
| <a name="BlockAdditionID"></a>BlockAdditionID | 5 | [CB] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | The ID of the BlockAdditional element (0 is the main Block). |
| <a name="Delay"></a>Delay | 5 | [CE] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | The (scaled) delay to apply to the element. |
| <a name="SliceDuration"></a>SliceDuration | 5 | [CF] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | The (scaled) duration to apply to the element. |
| <a name="ReferenceFrame"></a>ReferenceFrame | 3 | [C8] | - | - | - | - | <abbr title="Master Elements">m</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="ReferenceOffset"></a>ReferenceOffset | 4 | [C9] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="ReferenceTimeCode"></a>ReferenceTimeCode | 4 | [CA] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="EncryptedBlock"></a>EncryptedBlock | 2 | [AF] | - | mult. | - | - | <abbr title="Binary">b</abbr> | Similar to [SimpleBlock]({{site.baseurl}}/index.html#simpleblock-structure) but the data inside the Block are Transformed (encrypt and/or signed). (see [EncryptedBlock Structure]({{site.baseurl}}/index.html#encryptedblock-structure)) |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |


| <a name="Track"></a>Track |
| <a name="Tracks"></a>Tracks | 1 | [16][54][AE][6B] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | A top-level block of information with many tracks described. |
| <a name="TrackEntry"></a>TrackEntry | 2 | [AE] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Describes a track with all elements. |
| <a name="TrackNumber"></a>TrackNumber | 3 | [D7] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The track number as used in the Block Header (using more than 127 tracks is not encouraged, though the design allows an unlimited number). |
| <a name="TrackUID"></a>TrackUID | 3 | [73][C5] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | A unique ID to identify the Track. This should be kept the same when making a direct stream copy of the Track to another file. |
| <a name="TrackType"></a>TrackType | 3 | [83] | mand. | - | 1-254 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | A set of track types coded on 8 bits (1: video, 2: audio, 3: complex, 0x10: logo, 0x11: subtitle, 0x12: buttons, 0x20: control). |
| <a name="FlagEnabled"></a>FlagEnabled | 3 | [B9] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Set if the track is usable. (1 bit) |
| <a name="FlagDefault"></a>FlagDefault | 3 | [88] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Set if that track (audio, video or subs) SHOULD be active if no language found matches the user preference. (1 bit) |
| <a name="FlagForced"></a>FlagForced | 3 | [55][AA] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Set if that track MUST be active during playback. There can be many forced track for a kind (audio, video or subs), the player should select the one which language matches the user preference or the default + forced track. Overlay MAY happen between a forced and non-forced track of the same kind. (1 bit) |
| <a name="FlagLacing"></a>FlagLacing | 3 | [9C] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Set if the track may contain blocks using lacing. (1 bit) |
| <a name="MinCache"></a>MinCache | 3 | [6D][E7] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The minimum number of frames a player should be able to cache during playback. If set to 0, the reference pseudo-cache system is not used. |
| <a name="MaxCache"></a>MaxCache | 3 | [6D][F8] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The maximum cache size required to store referenced frames in and the current frame. 0 means no cache is needed. |
| <a name="DefaultDuration"></a>DefaultDuration | 3 | [23][E3][83] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Number of nanoseconds (not scaled via TimecodeScale) per frame ('frame' in the Matroska sense -- one element put into a (Simple)Block). |
| <a name="DefaultDecodedFieldDuration"></a>DefaultDecodedFieldDuration | 3 | [23][4E][7A] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | The period in nanoseconds (not scaled by TimcodeScale) between two successive fields at the output of the decoding process (see [the notes]({{site.baseurl}}/notes.html#default-decoded-field-duration)) |
| <a name="TrackTimecodeScale"></a>TrackTimecodeScale | 3 | [23][31][4F] | mand. | - | > 0 | 1.0 | <abbr title="Float">f</abbr> | * | * | * | DEPRECATED, DO NOT USE. The scale to apply on this track to work at normal speed in relation with other tracks (mostly used to adjust video speed when the audio length differs). |
| <a name="TrackOffset"></a>TrackOffset | 3 | [53][7F] | - | - | - | 0 | <abbr title="Signed Integer">i</abbr> | A value to add to the Block's Timestamp. This can be used to adjust the playback offset of a track. |
| <a name="MaxBlockAdditionID"></a>MaxBlockAdditionID | 3 | [55][EE] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The maximum value of [BlockAddID]({{site.baseurl}}/index.html#BlockAddID). A value 0 means there is no [BlockAdditions]({{site.baseurl}}/index.html#BlockAdditions) for this track. |
| <a name="Name"></a>Name | 3 | [53][6E] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | A human-readable track name. |
| <a name="Language"></a>Language | 3 | [22][B5][9C] | - | - | - | eng | <abbr title="String">s</abbr> | * | * | * | * | * | Specifies the language of the track in the [Matroska languages form]({{site.baseurl}}/index.html#language-codes). |
| <a name="CodecID"></a>CodecID | 3 | [86] | mand. | - | - | - | <abbr title="String">s</abbr> | * | * | * | * | * | An ID corresponding to the codec, see the [codec page]({{site.baseurl}}/codec_specs.html) for more info. |
| <a name="CodecPrivate"></a>CodecPrivate | 3 | [63][A2] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | * | Private data only known to the codec. |
| <a name="CodecName"></a>CodecName | 3 | [25][86][88] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | A human-readable string specifying the codec. |
| <a name="AttachmentLink"></a>AttachmentLink | 3 | [74][46] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The UID of an attachment that is used by this codec. |
| <a name="CodecSettings"></a>CodecSettings | 3 | [3A][96][97] | - | - | - | - | <abbr title="UTF-8">8</abbr> | A string describing the encoding setting used. |
| <a name="CodecInfoURL"></a>CodecInfoURL | 3 | [3B][40][40] | - | mult. | - | - | <abbr title="String">s</abbr> | A URL to find information about the codec used. |
| <a name="CodecDownloadURL"></a>CodecDownloadURL | 3 | [26][B2][40] | - | mult. | - | - | <abbr title="String">s</abbr> | A URL to download about the codec used. |
| <a name="CodecDecodeAll"></a>CodecDecodeAll | 3 | [AA] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | The codec can decode potentially damaged data (1 bit). |
| <a name="TrackOverlay"></a>TrackOverlay | 3 | [6F][AB] | - | mult. | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify that this track is an overlay track for the Track specified (in the u-integer). That means when this track has a gap (see [SilentTracks]({{site.baseurl}}/index.html#SilentTracks)) the overlay track should be used instead. The order of multiple TrackOverlay matters, the first one is the one that should be used. If not found it should be the second, etc. |
| <a name="CodecDelay"></a>CodecDelay | 3 | [56][AA] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | CodecDelay is The codec-built-in delay in nanoseconds. This value must be subtracted from each block timestamp in order to get the actual timestamp. The value should be small so the muxing of tracks with the same actual timestamp are in the same Cluster. |
| <a name="SeekPreRoll"></a>SeekPreRoll | 3 | [56][BB] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | After a discontinuity, SeekPreRoll is the duration in nanoseconds of the data the decoder must decode before the decoded data is valid. |
| <a name="TrackTranslate"></a>TrackTranslate | 3 | [66][24] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | The track identification for the given Chapter Codec. |
| <a name="TrackTranslateEditionUID"></a>TrackTranslateEditionUID | 4 | [66][FC] | - | mult. | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify an edition UID on which this translation applies. When not specified, it means for all editions found in the segment. |
| <a name="TrackTranslateCodec"></a>TrackTranslateCodec | 4 | [66][BF] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The [chapter codec]({{site.baseurl}}/index.html#ChapProcessCodecID) using this ID (0: Matroska Script, 1: DVD-menu). |
| <a name="TrackTranslateTrackID"></a>TrackTranslateTrackID | 4 | [66][A5] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | The binary value used to represent this track in the chapter codec data. The format depends on the [ChapProcessCodecID]({{site.baseurl}}/index.html#ChapProcessCodecID) used. |
| <a name="Video"></a>Video | 3 | [E0] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Video settings. |
| <a name="FlagInterlaced"></a>FlagInterlaced | 4 | [9A] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Set if the video is interlaced. (1 bit) |
| <a name="StereoMode"></a>StereoMode | 4 | [53][B8] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | Stereo-3D video mode (0: mono, 1: side by side (left eye is first), 2: top-bottom (right eye is first), 3: top-bottom (left eye is first), 4: checkboard (right is first), 5: checkboard (left is first), 6: row interleaved (right is first), 7: row interleaved (left is first), 8: column interleaved (right is first), 9: column interleaved (left is first), 10: anaglyph (cyan/red), 11: side by side (right eye is first), 12: anaglyph (green/magenta), 13 both eyes laced in one Block (left eye is first), 14 both eyes laced in one Block (right eye is first)) . There are some more details on [3D support in the Specification Notes]({{site.baseurl}}/notes.html#d-and-multi-planar-videos). |
| <a name="AlphaMode"></a>AlphaMode | 4 | [53][C0] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | Alpha Video Mode. Presence of this element indicates that the BlockAdditional element could contain Alpha data. |
| <a name="OldStereoMode"></a>OldStereoMode | 4 | [53][B9] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | DEPRECATED, DO NOT USE. Bogus StereoMode value used in old versions of libmatroska. (0: mono, 1: right eye, 2: left eye, 3: both eyes). |
| <a name="PixelWidth"></a>PixelWidth | 4 | [B0] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Width of the encoded video frames in pixels. |
| <a name="PixelHeight"></a>PixelHeight | 4 | [BA] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Height of the encoded video frames in pixels. |
| <a name="PixelCropBottom"></a>PixelCropBottom | 4 | [54][AA] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The number of video pixels to remove at the bottom of the image (for HDTV content). |
| <a name="PixelCropTop"></a>PixelCropTop | 4 | [54][BB] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The number of video pixels to remove at the top of the image. |
| <a name="PixelCropLeft"></a>PixelCropLeft | 4 | [54][CC] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The number of video pixels to remove on the left of the image. |
| <a name="PixelCropRight"></a>PixelCropRight | 4 | [54][DD] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The number of video pixels to remove on the right of the image. |
| <a name="DisplayWidth"></a>DisplayWidth | 4 | [54][B0] | - | - | not 0 | PixelWidth | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Width of the video frames to display. The default value is only valid when [DisplayUnit]({{site.baseurl}}/index.html#DisplayUnit) is 0. |
| <a name="DisplayHeight"></a>DisplayHeight | 4 | [54][BA] | - | - | not 0 | PixelHeight | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Height of the video frames to display. The default value is only valid when [DisplayUnit]({{site.baseurl}}/index.html#DisplayUnit) is 0. |
| <a name="DisplayUnit"></a>DisplayUnit | 4 | [54][B2] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | How DisplayWidth & DisplayHeight should be interpreted (0: pixels, 1: centimeters, 2: inches, 3: Display Aspect Ratio). |
| <a name="AspectRatioType"></a>AspectRatioType | 4 | [54][B3] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Specify the possible modifications to the aspect ratio (0: free resizing, 1: keep aspect ratio, 2: fixed). |
| <a name="ColourSpace"></a>ColourSpace | 4 | [2E][B5][24] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Same value as in AVI (32 bits). |
| <a name="GammaValue"></a>GammaValue | 4 | [2F][B5][23] | - | - | > 0 | - | <abbr title="Float">f</abbr> | Gamma Value. |
| <a name="FrameRate"></a>FrameRate | 4 | [23][83][E3] | - | - | > 0 | - | <abbr title="Float">f</abbr> | Number of frames per second. **Informational** only. |
| <a name="Audio"></a>Audio | 3 | [E1] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Audio settings. |
| <a name="SamplingFrequency"></a>SamplingFrequency | 4 | [B5] | mand. | - | > 0 | 8000.0 | <abbr title="Float">f</abbr> | * | * | * | * | * | Sampling frequency in Hz. |
| <a name="OutputSamplingFrequency"></a>OutputSamplingFrequency | 4 | [78][B5] | - | - | > 0 | SamplingFrequency | <abbr title="Float">f</abbr> | * | * | * | * | * | Real output sampling frequency in Hz (used for SBR techniques). |
| <a name="Channels"></a>Channels | 4 | [9F] | mand. | - | not 0 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Numbers of channels in the track. |
| <a name="ChannelPositions"></a>ChannelPositions | 4 | [7D][7B] | - | - | - | - | <abbr title="Binary">b</abbr> | Table of horizontal angles for each successive channel, see appendix. |
| <a name="BitDepth"></a>BitDepth | 4 | [62][64] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Bits per sample, mostly used for PCM. |
| <a name="TrackOperation"></a>TrackOperation | 3 | [E2] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | Operation that needs to be applied on tracks to create this virtual track. For more details [look at the Specification Notes]({{site.baseurl}}/notes.html#track-operation) on the subject. |
| <a name="TrackCombinePlanes"></a>TrackCombinePlanes | 4 | [E3] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | Contains the list of all video plane tracks that need to be combined to create this 3D track |
| <a name="TrackPlane"></a>TrackPlane | 5 | [E4] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | Contains a video plane track that need to be combined to create this 3D track |
| <a name="TrackPlaneUID"></a>TrackPlaneUID | 6 | [E5] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | The trackUID number of the track representing the plane. |
| <a name="TrackPlaneType"></a>TrackPlaneType | 6 | [E6] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | The kind of plane this track corresponds to (0: left eye, 1: right eye, 2: background). |
| <a name="TrackJoinBlocks"></a>TrackJoinBlocks | 4 | [E9] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | Contains the list of all tracks whose Blocks need to be combined to create this virtual track |
| <a name="TrackJoinUID"></a>TrackJoinUID | 5 | [ED] | mand. | mult. | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | The trackUID number of a track whose blocks are used to create this virtual track. |
| <a name="TrickTrackUID"></a>TrickTrackUID | 3 | [C0] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="TrickTrackSegmentUID"></a>TrickTrackSegmentUID | 3 | [C1] | - | - | - | - | <abbr title="Binary">b</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="TrickTrackFlag"></a>TrickTrackFlag | 3 | [C6] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="TrickMasterTrackUID"></a>TrickMasterTrackUID | 3 | [C7] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="TrickMasterTrackSegmentUID"></a>TrickMasterTrackSegmentUID | 3 | [C4] | - | - | - | - | <abbr title="Binary">b</abbr> | [DivX trick track extenstions](http://developer.divx.com/docs/divx_plus_hd/format_features/Smooth_FF_RW) |
| <a name="ContentEncodings"></a>ContentEncodings | 3 | [6D][80] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Settings for several content encoding mechanisms like compression or encryption. |
| <a name="ContentEncoding"></a>ContentEncoding | 4 | [62][40] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Settings for one content encoding like compression or encryption. |
| <a name="ContentEncodingOrder"></a>ContentEncodingOrder | 5 | [50][31] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Tells when this modification was used during encoding/muxing starting with 0 and counting upwards. The decoder/demuxer has to start with the highest order number it finds and work its way down. This value has to be unique over all ContentEncodingOrder elements in the segment. |
| <a name="ContentEncodingScope"></a>ContentEncodingScope | 5 | [50][32] | mand. | - | not 0 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A bit field that describes which elements have been modified in this way. Values (big endian) can be OR'ed. Possible values: 1 - all frame contents, 2 - the track's private data, 4 - the next ContentEncoding (next ContentEncodingOrder. Either the data inside ContentCompression and/or ContentEncryption) |
| <a name="ContentEncodingType"></a>ContentEncodingType | 5 | [50][33] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A value describing what kind of transformation has been done. Possible values: 0 - compression, 1 - encryption |
| <a name="ContentCompression"></a>ContentCompression | 5 | [50][34] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Settings describing the compression used. Must be present if the value of ContentEncodingType is 0 and absent otherwise. Each block must be decompressable even if no previous block is available in order not to prevent seeking. |
| <a name="ContentCompAlgo"></a>ContentCompAlgo | 6 | [42][54] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The compression algorithm used. Algorithms that have been specified so far are: 0 - zlib, ~~1 - bzlib,~~ ~~2 - lzo1x~~
3 - Header Stripping |
| <a name="ContentCompSettings"></a>ContentCompSettings | 6 | [42][55] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Settings that might be needed by the decompressor. For Header Stripping (ContentCompAlgo=3), the bytes that were removed from the beggining of each frames of the track. |
| <a name="ContentEncryption"></a>ContentEncryption | 5 | [50][35] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Settings describing the encryption used. Must be present if the value of ContentEncodingType is 1 and absent otherwise. |
| <a name="ContentEncAlgo"></a>ContentEncAlgo | 6 | [47][E1] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The encryption algorithm used. The value '0' means that the contents have not been encrypted but only signed. Predefined values: 1 - DES, 2 - 3DES, 3 - Twofish, 4 - Blowfish, 5 - AES |
| <a name="ContentEncKeyID"></a>ContentEncKeyID | 6 | [47][E2] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | For public key algorithms this is the ID of the public key the the data was encrypted with. |
| <a name="ContentSignature"></a>ContentSignature | 6 | [47][E3] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | A cryptographic signature of the contents. |
| <a name="ContentSigKeyID"></a>ContentSigKeyID | 6 | [47][E4] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | This is the ID of the private key the data was signed with. |
| <a name="ContentSigAlgo"></a>ContentSigAlgo | 6 | [47][E5] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The algorithm used for the signature. A value of '0' means that the contents have not been signed but only encrypted. Predefined values: 1 - RSA |
| <a name="ContentSigHashAlgo"></a>ContentSigHashAlgo | 6 | [47][E6] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The hash algorithm used for the signature. A value of '0' means that the contents have not been signed but only encrypted. Predefined values: 1 - SHA1-160 2 - MD5 |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="CueingData"></a>Cueing Data |
| <a name="Cues"></a>Cues | 1 | [1C][53][BB][6B] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | A top-level element to speed seeking access. All entries are local to the segment. Should be mandatory for non ["live" streams](http://www.matroska.org/technical/streaming/index.html). |
| <a name="CuePoint"></a>CuePoint | 2 | [BB] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains all information relative to a seek point in the segment. |
| <a name="CueTime"></a>CueTime | 3 | [B3] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Absolute timestamp according to the segment time base. |
| <a name="CueTrackPositions"></a>CueTrackPositions | 3 | [B7] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contain positions for different tracks corresponding to the timestamp. |
| <a name="CueTrack"></a>CueTrack | 4 | [F7] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The track for which a position is given. |
| <a name="CueClusterPosition"></a>CueClusterPosition | 4 | [F1] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | The [position]({{site.baseurl}}/notes.html#position-references) of the Cluster containing the required Block. |
| <a name="CueRelativePosition"></a>CueRelativePosition | 4 | [F0] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | The relative position of the referenced block inside the cluster with 0 being the first possible position for an element inside that cluster. |
| <a name="CueDuration"></a>CueDuration | 4 | [B2] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | The duration of the block according to the segment time base. If missing the track's DefaultDuration does not apply and no duration information is available in terms of the cues. |
| <a name="CueBlockNumber"></a>CueBlockNumber | 4 | [53][78] | - | - | not 0 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Number of the Block in the specified Cluster. |
| <a name="CueCodecState"></a>CueCodecState | 4 | [EA] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | The [position]({{site.baseurl}}/notes.html#position-references) of the Codec State corresponding to this Cue element. 0 means that the data is taken from the initial Track Entry. |
| <a name="CueReference"></a>CueReference | 4 | [DB] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | The Clusters containing the required referenced Blocks. |
| <a name="CueRefTime"></a>CueRefTime | 5 | [96] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | Timestamp of the referenced Block. |
| <a name="CueRefCluster"></a>CueRefCluster | 5 | [97] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | The [Position]({{site.baseurl}}/notes.html#position-references) of the Cluster containing the referenced Block. |
| <a name="CueRefNumber"></a>CueRefNumber | 5 | [53][5F] | - | - | not 0 | 1 | <abbr title="Unsigned Integer">u</abbr> | Number of the referenced Block of Track X in the specified Cluster. |
| <a name="CueRefCodecState"></a>CueRefCodecState | 5 | [EB] | - | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | The [position]({{site.baseurl}}/notes.html#position-references) of the Codec State corresponding to this referenced element. 0 means that the data is taken from the initial Track Entry. |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="Attachment"></a>Attachment |
| Attachments | 1 | [19][41][A4][69] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contain attached files. |
| <a name="AttachedFile"></a>AttachedFile | 2 | [61][A7] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | An attached file. |
| <a name="FileDescription"></a>FileDescription | 3 | [46][7E] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | A human-friendly name for the attached file. |
| <a name="FileName"></a>FileName | 3 | [46][6E] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | Filename of the attached file. |
| <a name="FileMimeType"></a>FileMimeType | 3 | [46][60] | mand. | - | - | - | <abbr title="String">s</abbr> | * | * | * | * | MIME type of the file. |
| <a name="FileData"></a>FileData | 3 | [46][5C] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | The data of the file. |
| <a name="FileUID"></a>FileUID | 3 | [46][AE] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Unique ID representing the file, as random as possible. |
| <a name="FileReferral"></a>FileReferral | 3 | [46][75] | - | - | - | - | <abbr title="Binary">b</abbr> | A binary value that a track/codec can refer to when the attachment is needed. |
| <a name="FileUsedStartTime"></a>FileUsedStartTime | 3 | [46][61] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX font extension](http://developer.divx.com/docs/divx_plus_hd/format_features/World_Fonts) |
| <a name="FileUsedEndTime"></a>FileUsedEndTime | 3 | [46][62] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | [DivX font extension](http://developer.divx.com/docs/divx_plus_hd/format_features/World_Fonts) |
| <a name="ElementName"></a>Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="Chapters"></a>Chapters |
| Chapters | 1 | [10][43][A7][70] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | A system to define basic menus and partition data. For more detailed information, look at the [Chapters Explanation]({{site.baseurl}}/chapters/index.html). |
| <a name="EditionEntry"></a>EditionEntry | 2 | [45][B9] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains all information about a segment edition. |
| <a name="EditionUID"></a>EditionUID | 3 | [45][BC] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the edition. It's useful for tagging an edition. |
| <a name="EditionFlagHidden"></a>EditionFlagHidden | 3 | [45][BD] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If an edition is hidden (1), it should not be available to the user interface (but still to Control Tracks; see [flag notes]({{site.baseurl}}/chapters/index.html#chapter-flags)). (1 bit) |
| <a name="EditionFlagDefault"></a>EditionFlagDefault | 3 | [45][DB] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If a flag is set (1) the edition should be used as the default one. (1 bit) |
| <a name="EditionFlagOrdered"></a>EditionFlagOrdered | 3 | [45][DD] | - | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify if the chapters can be defined multiple times and the order to play them is enforced. (1 bit) |
| <a name="ChapterAtom"></a>ChapterAtom | 3+ | [B6] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains the atom information to use as the chapter atom (apply to all tracks). |
| <a name="ChapterUID"></a>ChapterUID | 4 | [73][C4] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | A unique ID to identify the Chapter. |
| <a name="ChapterStringUID"></a>ChapterStringUID | 4 | [56][54] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | A unique string ID to identify the Chapter. Use for [WebVTT cue identifier storage](http://dev.w3.org/html5/webvtt/#webvtt-cue-identifier). |
| <a name="ChapterTimeStart"></a>ChapterTimeStart | 4 | [91] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Timestamp of the start of Chapter (not scaled). |
| <a name="ChapterTimeEnd"></a>ChapterTimeEnd | 4 | [92] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Timestamp of the end of Chapter (timestamp excluded, not scaled). |
| <a name="ChapterFlagHidden"></a>ChapterFlagHidden | 4 | [98] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If a chapter is hidden (1), it should not be available to the user interface (but still to Control Tracks; see [flag notes]({{site.baseurl}}/chapters/index.html#chapter-flags)). (1 bit) |
| <a name="ChapterFlagEnabled"></a>ChapterFlagEnabled | 4 | [45][98] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify wether the chapter is enabled. It can be enabled/disabled by a Control Track. When disabled, the movie should skip all the content between the TimeStart and TimeEnd of this chapter (see [flag notes]({{site.baseurl}}/chapters/index.html#chapter-flags)). (1 bit) |
| <a name="ChapterSegmentUID"></a>ChapterSegmentUID | 4 | [6E][67] | - | - | >0 | - | <abbr title="Binary">b</abbr> | * | * | * | * | A segment to play in place of this chapter. Edition ChapterSegmentEditionUID should be used for this segment, otherwise no edition is used. |
| <a name="ChapterSegmentEditionUID"></a>ChapterSegmentEditionUID | 4 | [6E][BC] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The EditionUID to play from the segment linked in ChapterSegmentUID. |
| <a name="ChapterPhysicalEquiv"></a>ChapterPhysicalEquiv | 4 | [63][C3] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify the physical equivalent of this ChapterAtom like "DVD" (60) or "SIDE" (50), see [complete list of values]({{site.baseurl}}/index.html#physical-types). |
| <a name="ChapterTrack"></a>ChapterTrack | 4 | [8F] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | List of tracks on which the chapter applies. If this element is not present, all tracks apply |
| <a name="ChapterTrackNumber"></a>ChapterTrackNumber | 5 | [89] | mand. | mult. | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | UID of the Track to apply this chapter too. In the absense of a control track, choosing this chapter will select the listed Tracks and deselect unlisted tracks. Absense of this element indicates that the Chapter should be applied to any currently used Tracks. |
| <a name="ChapterDisplay"></a>ChapterDisplay | 4 | [80] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains all possible strings to use for the chapter display. |
| <a name="ChapString"></a>ChapString | 5 | [85] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | Contains the string to use as the chapter atom. |
| <a name="ChapLanguage"></a>ChapLanguage | 5 | [43][7C] | mand. | mult. | - | eng | <abbr title="String">s</abbr> | * | * | * | * | * | The languages corresponding to the string, in the [bibliographic ISO-639-2 form](http://www.loc.gov/standards/iso639-2/php/English_list.php). |
| <a name="ChapCountry"></a>ChapCountry | 5 | [43][7E] | - | mult. | - | - | <abbr title="String">s</abbr> | * | * | * | * | The countries corresponding to the string, same 2 octets as in [Internet domains](http://www.iana.org/cctld/cctld-whois.htm). |
| <a name="ChapProcess"></a>ChapProcess | 4 | [69][44] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contains all the commands associated to the Atom. |
| <a name="ChapProcessCodecID"></a>ChapProcessCodecID | 5 | [69][55] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Contains the type of the codec used for the processing. A value of 0 means native Matroska processing (to be defined), a value of 1 means the [DVD]({{site.baseurl}}/chapters/index.html#dvd-menu-1) command set is used. More codec IDs can be added later. |
| <a name="ChapProcessPrivate"></a>ChapProcessPrivate | 5 | [45][0D] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Some optional data attached to the ChapProcessCodecID information. [For ChapProcessCodecID = 1]({{site.baseurl}}/chapters/index.html#dvd-menu-1), it is the "DVD level" equivalent. |
| <a name="ChapProcessCommand"></a>ChapProcessCommand | 5 | [69][11] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contains all the commands associated to the Atom. |
| <a name="ChapProcessTime"></a>ChapProcessTime | 6 | [69][22] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Defines when the process command should be handled (0: during the whole chapter, 1: before starting playback, 2: after playback of the chapter). |
| <a name="ChapProcessData"></a>ChapProcessData | 6 | [69][33] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Contains the command information. The data should be interpreted depending on the ChapProcessCodecID value. [For ChapProcessCodecID = 1]({{site.baseurl}}/chapters/index.html#dvd-menu-1), the data correspond to the binary DVD cell pre/post commands. |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| <a name="Tagging"></a>Tagging |
| <a name="Tags"></a>Tags | 1 | [12][54][C3][67] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Element containing elements specific to Tracks/Chapters. A list of valid tags can be found [here.]({{site.baseurl}}/tagging.html) |
| <a name="Tag"></a>Tag | 2 | [73][73] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Element containing elements specific to Tracks/Chapters. |
| <a name="Targets"></a>Targets | 3 | [63][C0] | mand. | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contain all UIDs where the specified meta data apply. It is empty to describe everything in the segment. |
| <a name="TargetTypeValue"></a>TargetTypeValue | 4 | [68][CA] | - | - | - | 50 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A number to indicate the logical level of the target (see [TargetType]({{site.baseurl}}/tagging.html#target-types)). |
| <a name="TargetType"></a>TargetType | 4 | [63][CA] | - | - | - | - | <abbr title="String">s</abbr> | * | * | * | * | An **informational** string that can be used to display the logical level of the target like "ALBUM", "TRACK", "MOVIE", "CHAPTER", etc (see [TargetType]({{site.baseurl}}/tagging.html#target-types)). |
| <a name="TagTrackUID"></a>TagTrackUID | 4 | [63][C5] | - | mult. | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the Track(s) the tags belong to. If the value is 0 at this level, the tags apply to all tracks in the Segment. |
| <a name="TagEditionUID"></a>TagEditionUID | 4 | [63][C9] | - | mult. | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the EditionEntry(s) the tags belong to. If the value is 0 at this level, the tags apply to all editions in the Segment. |
| <a name="TagChapterUID"></a>TagChapterUID | 4 | [63][C4] | - | mult. | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the Chapter(s) the tags belong to. If the value is 0 at this level, the tags apply to all chapters in the Segment. |
| <a name="TagAttachmentUID"></a>TagAttachmentUID | 4 | [63][C6] | - | mult. | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the Attachment(s) the tags belong to. If the value is 0 at this level, the tags apply to all the attachments in the Segment. |
| <a name="SimpleTag"></a>SimpleTag | 3+ | [67][C8] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contains general information about the target. |
| <a name="TagName"></a>TagName | 4 | [45][A3] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | The name of the Tag that is going to be stored. |
| <a name="TagLanguage"></a>TagLanguage | 4 | [44][7A] | mand. | - | - | und | <abbr title="String">s</abbr> | * | * | * | * | Specifies the language of the tag specified, in the [Matroska languages form]({{site.baseurl}}/index.html#language-codes). |
| <a name="TagDefault"></a>TagDefault | 4 | [44][84] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Indication to know if this is the default/original language to use for the given tag. (1 bit) |
| <a name="TagString"></a>TagString | 4 | [44][87] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | The value of the Tag. |
| <a name="TagBinary"></a>TagBinary | 4 | [44][85] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | The values of the Tag if it is binary. Note that this cannot be used in the same SimpleTag as TagString. |
| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |



**All top-levels elements (Segment and direct sub-elements) are coded on 4 octets, i.e. class D elements.**

### Appendix

#### Language Codes

Language codes can be either the 3 letters [bibliographic ISO-639-2](http://www.loc.gov/standards/iso639-2/php/English_list.php) form (like "fre" for french), or such a language code followed by a dash and a country code for specialities in languages (like "fre-ca" for Canadian French). Country codes are the same as used for [internet domains](http://www.iana.org/cctld/cctld-whois.htm).

#### Physical Types

Each level can have different meanings for audio and video. The ORIGINAL_MEDIUM tag can be used to specify a string for ChapterPhysicalEquiv = 60\. Here is the list of possible levels for both audio and video :

| ChapterPhysicalEquiv | Audio | Video | Comment |
| 70 | SET / PACKAGE | SET / PACKAGE | the collection of different media |
| 60 | CD / 12" / 10" / 7" / TAPE / MINIDISC / DAT | DVD / VHS / LASERDISC | the physical medium like a CD or a DVD |
| 50 | SIDE | SIDE | when the original medium (LP/DVD) has different sides |
| 40 | - | LAYER | another physical level on DVDs |
| 30 | SESSION | SESSION | as found on CDs and DVDs |
| 20 | TRACK | - | as found on audio CDs |
| 10 | INDEX | - | the first logical level of the side/medium |


#### Block Structure

Size = 1 + (1-8) + 4 + (4 + (4)) octets. So from 6 to 21 octets.

Bit 0 is the most significant bit.

Frames using references should be stored in "coding order". That means the references first and then the frames referencing them. A consequence is that timecodes may not be consecutive. But a frame with a past timecode must reference a frame already known, otherwise it's considered bad/void.

There can be many Blocks in a BlockGroup provided they all have the same timecode. It is used with different parts of a frame with different priorities.

| <a name="block-header"></a>Block Header |
| Offset | Player | Description |
| 0x00+ | must | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+ | must | Timecode (relative to Cluster timecode, signed int16) |
| 0x03+ | - | 

| Flags |
| Bit | Player | Description |
| 0-3 | - | Reserved, set to 0 |
| 4 | - | Invisible, the codec should decode this frame but not display it |
| 5-6 | must | Lacing

*   00 : no lacing
*   01 : Xiph lacing
*   11 : EBML lacing
*   10 : fixed-size lacing

 |
| 7 | - | not used |

 |
| Lace (when lacing bit is set) |
| 0x00 | must | Number of frames in the lace-1 (uint8) |
| 0x01 / 0xXX | must* | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |
| (possibly) Laced Data |
| 0x00 | must | Consecutive laced frames |


### Lacing

Lacing is a mechanism to save space when storing data. It is typically used for small blocks of data (refered to as frames in matroska). There are 3 types of lacing : the Xiph one inspired by what is found in the Ogg container, the EBML one which is the same with sizes coded differently and the fixed-size one where the size is not coded. As an example is better than words...

Let's say you want to store 3 frames of the same track. The first frame is 800 octets long, the second is 500 octets long and the third is 1000 octets long. As these data are small, you can store them in a lace to save space. They will then be solved in the same block as follows:

#### Xiph lacing

*   Block head (with lacing bits set to 01)
*   Lacing head: Number of frames in the lace -1, i.e. 2 (the 800 and 500 octets one)
*   Lacing sizes: only the 2 first ones will be coded, 800 gives 255;255;255;35, 500 gives 255;245\. The size of the last frame is deduced from the total size of the Block.
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3

A frame with a size multiple of 255 is coded with a 0 at the end of the size, for example 765 is coded 255;255;255;0.

#### EBML lacing

In this case the size is not coded as blocks of 255 bytes, but as a difference with the previous size and this size is coded as in EBML. The first size in the lace is unsigned as in EBML. The others use a range shifting to get a sign on each value :

<pre>1xxx xxxx                                                                              - value -(2^6-1) to  2^6-1

                                                                                        (ie 0 to 2^7-2 minus 2^6-1, half of the range)

01xx xxxx  xxxx xxxx                                                                   - value -(2^13-1) to 2^13-1

001x xxxx  xxxx xxxx  xxxx xxxx                                                        - value -(2^20-1) to 2^20-1

0001 xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                                             - value -(2^27-1) to 2^27-1

0000 1xxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                                  - value -(2^34-1) to 2^34-1

0000 01xx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                       - value -(2^41-1) to 2^41-1

0000 001x  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx            - value -(2^48-1) to 2^48-1

</pre>

*   Block head (with lacing bits set to 11)
*   Lacing head: Number of frames in the lace -1, i.e. 2 (the 800 and 400 octets one)
*   Lacing sizes: only the 2 first ones will be coded, 800 gives 0x320 0x4000 = 0x4320, 500 is coded as -300 : - 0x12C + 0x1FFF + 0x4000 = 0x5ED3\. The size of the last frame is deduced from the total size of the Block.
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3

#### Fixed-size lacing

In this case only the number of frames in the lace is saved, the size of each frame is deduced from the total size of the Block. For example, for 3 frames of 800 octets each :

*   Block head (with lacing bits set to 10)
*   Lacing head: Number of frames in the lace -1, i.e. 2
*   Data in frame 1
*   Data in frame 2
*   Data in frame 3


#### SimpleBlock Structure

The SimpleBlock is very inspired by the [Block structure](({{site.baseurl}}/index.html#block-structure). The main differences are the added Keyframe flag and Discardable flag. Otherwise everything is the same.

Size = 1 + (1-8) + 4 + (4 + (4)) octets. So from 6 to 21 octets.

Bit 0 is the most significant bit.

Frames using references should be stored in "coding order". That means the references first and then the frames referencing them. A consequence is that timecodes may not be consecutive. But a frame with a past timecode must reference a frame already known, otherwise it's considered bad/void.

There can be many Blocks in a BlockGroup provided they all have the same timecode. It is used with different parts of a frame with different priorities.



| SimpleBlock Header |
| Offset | Player | Description |
| 0x00+ | must | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+ | must | Timecode (relative to Cluster timecode, signed int16) |
| 0x03+ | - | 

| Flags |
| Bit | Player | Description |
| 0 | - | Keyframe, set when the Block contains only keyframes |
| 1-3 | - | Reserved, set to 0 |
| 4 | - | Invisible, the codec should decode this frame but not display it |
| 5-6 | must | Lacing

*   00 : no lacing
*   01 : Xiph lacing
*   11 : EBML lacing
*   10 : fixed-size lacing

 |
| 7 | - | Discardable, the frames of the Block can be discarded during playing if needed |

 |
| Lace (when lacing bit is set) |
| 0x00 | must | Number of frames in the lace-1 (uint8) |
| 0x01 / 0xXX | must* | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |
| (possibly) Laced Data |
| 0x00 | must | Consecutive laced frames |


#### EncryptedBlock Structure

The EncryptedBlock is very inspired by the [SimpleBlock structure](({{site.baseurl}}/index.html#simpleblock_structure). The main differences is that the raw data are Transformed. That means the data after the lacing definition (if present) have been processed before put into the Block. The laced sizes apply on the decoded (Inverse Transform) data. This size of the Transformed data may not match the size of the initial chunk of data.

The other difference is that the number of frames in the lace are not saved if "no lacing" is specified (bits 5 and 6 set to 0).

The Transformation is specified by a TransformID in the Block (must be the same for all frames within the EncryptedBlock).

Size = 1 + (1-8) + 4 + (4 + (4)) octets. So from 6 to 21 octets.

Bit 0 is the most significant bit.

Frames using references should be stored in "coding order". That means the references first and then the frames referencing them. A consequence is that timecodes may not be consecutive. But a frame with a past timecode must reference a frame already known, otherwise it's considered bad/void.

There can be many Blocks in a BlockGroup provided they all have the same timecode. It is used with different parts of a frame with different priorities.



| EncryptedBlock Header |
| Offset | Player | Description |
| 0x00+ | must | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+ | must | Timecode (relative to Cluster timecode, signed int16) |
| 0x03+ | - | 

| Flags |
| Bit | Player | Description |
| 0 | - | Keyframe, set when the Block contains only keyframes |
| 1-3 | - | Reserved, set to 0 |
| 4 | - | Invisible, the codec should decode this frame but not display it |
| 5-6 | must | Lacing

*   00 : no lacing
*   01 : Xiph lacing
*   11 : EBML lacing
*   10 : fixed-size lacing

 |
| 7 | - | Discardable, the frames of the Block can be discarded during playing if needed |

 |
| Lace (when lacing bit is set) |
| 0x00 | must* | Number of frames in the lace-1 (uint8) *Only available if bit 5 or bit 6 of the EncryptedBlock flag is set to one. |
| 0x01 / 0xXX | must* | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |
| (possibly) Laced Data |
| 0x00 | must | TransformID (EBML coded integer value). Value 0 = Null Transform |
| 0x01+ | must | Consecutive laced frames |


#### Virtual Block

The data in matroska is stored in coding order. But that means if you seek to a particular point and a frame has been referenced far away, you won't know while playing and you might miss this frame (true for independent frames and overlapping of dependent frames). So the idea is to have a placeholder for the original frame in the timecode (display) order.

The structure is a scaled down version of the normal [Block]({{site.baseurl}}/index.html#block).


| Virtual Block Header |
| Offset | Player | Description |
| 0x00+ | must | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+ | must | Timecode (relative to Cluster timecode, signed int16) |
| 0x03+ | - | 

| Flags |
| Bit | Player | Description |
| 7-0 | - | Reserved, set to 0 |

 |
