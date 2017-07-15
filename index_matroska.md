---
---

# Introduction

Matroska aims to become THE standard of multimedia container formats. It was derived from a project called [MCF](http://mukoli.free.fr/mcf/mcf.html), but differentiates from it significantly because it is based on [EBML](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown) (Extensible Binary Meta Language), a binary derivative of XML. EBML enables significant advantages in terms of future format extensibility, without breaking file support in old parsers.

First, it is essential to clarify exactly "What an Audio/Video container is", to avoid any misunderstandings:

- It is NOT a video or audio compression format (codec)
- It is an envelope for which there can be many audio, video and subtitles streams, allowing the user to store a complete movie or CD in a single file.

Matroska is designed with the future in mind. It incorporates features like:

- Fast seeking in the file
- Chapter entries
- Full metadata (tags) support
- Selectable subtitle/audio/video streams
- Modularly expandable
- Error resilience (can recover playback even when the stream is damaged)
- Streamable over the internet and local networks (HTTP, CIFS, FTP, etc)
- Menus (like DVDs have)

Matroska is an open standards project. This means for personal use it is absolutely free to use and that the technical specifications describing the bitstream are open to everybody, even to companies that would like to support it in their products.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/). But since it's quite complete it is used as a reference for the development of libmatroska. Legacy versions of the specification can be found [here](https://matroska.org/files/matroska.pdf) (PDF doc by Alexander Noé -- outdated).

For a simplified diagram of the layout of a Matroska file, see the [Diagram page](diagram.md).

A more refined and detailed version of the EBML specifications is being [worked on here](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown).

The table found below is now generated from the "source" of the Matroska specification. This [XML file](https://github.com/Matroska-Org/foundation-source/blob/master/spectool/specdata.xml) is also used to generate the semantic data used in libmatroska and libmatroska2\. We encourage anyone to use and monitor its changes so your code is spec-proof and always up to date.

Note that versions 1, 2 and 3 have been finalized. Version 4 is currently work in progress. There MAY be further additions to v4.

# Security Considerations

Matroska inherits security considerations from EBML.

Attacks on a `Matroska Reader` could include:

- Storage of a arbitrary and potentially executable data within an `Attachment Element`. `Matroska Readers` that extract or use data from Matroska Attachments SHOULD check that the data adheres to expectations.
- A `Matroska Attachment` with an inaccurate mime-type.

# IANA Considerations

To be determined.

# Notations and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

# Basis in EBML

Matroska is a Document Type of EBML (Extensible Binary Meta Language). This specification is dependent on the [EBML Specification](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown). For an understanding of Matroska's EBML Schema, see in particular the sections of the EBML Specification covering [EBML Element Types](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#ebml-element-types), [EBML Schema](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#ebml-schema), and [EBML Structure](https://github.com/Matroska-Org/ebml-specification/blob/master/specification.markdown#structure).

## Added Constraints on EBML

As an EBML Document Type, Matroska adds the following constraints to the EBML specification.

- The `docType` of the `EBML Header` MUST be 'matroska'.
- The `EBMLMaxIDLength` of the `EBML Header` MUST be `4`.
- The `EBMLMaxSizeLength` of the `EBML Header` MUST be between `1` and `8` inclusive.

## Matroska Design

All top-levels elements (Segment and direct sub-elements) are coded on 4 octets, i.e. class D elements.

### Language Codes

Matroska from version 1 through 3 uses language codes that can be either the 3 letters [bibliographic ISO-639-2](https://www.loc.gov/standards/iso639-2/php/English_list.php) form (like "fre" for french), or such a language code followed by a dash and a country code for specialities in languages (like "fre-ca" for Canadian French). The `ISO 639-2 Language Elements` are "Language Element", "TagLanguage Element", and "ChapLanguage Element".

Starting in Matroska version 4, either `ISO 639-2` or [BCP 47](https://tools.ietf.org/html/bcp47) MAY be used, although `BCP 47` is RECOMMENDED. The `BCP 47 Language Elements` are "LanguageIETF Element", "TagLanguageIETF Element", and "ChapLanguageIETF Element". If a `BCP 47 Language Element` and an `ISO 639-2 Language Element` are used within the same `Parent Element`, then the `ISO 639-2 Lanaguage Element` MUST be ignored and precedence given to the `BCP 47 Language Element`.

Country codes are the same as used for [internet domains](https://www.iana.org/domains/root/db).

### Physical Types

Each level can have different meanings for audio and video. The ORIGINAL_MEDIUM tag can be used to specify a string for ChapterPhysicalEquiv = 60\. Here is the list of possible levels for both audio and video :

| ChapterPhysicalEquiv | Audio | Video | Comment |
|:---------------------|:------|:------|:--------|
| 70 | SET / PACKAGE | SET / PACKAGE | the collection of different media |
| 60 | CD / 12" / 10" / 7" / TAPE / MINIDISC / DAT | DVD / VHS / LASERDISC | the physical medium like a CD or a DVD |
| 50 | SIDE | SIDE | when the original medium (LP/DVD) has different sides |
| 40 | - | LAYER | another physical level on DVDs |
| 30 | SESSION | SESSION | as found on CDs and DVDs |
| 20 | TRACK | - | as found on audio CDs |
| 10 | INDEX | - | the first logical level of the side/medium |


### Block Structure

Size = 1 + (1-8) + 4 + (4 + (4)) octets. So from 6 to 21 octets.

Bit 0 is the most significant bit.

Frames using references SHOULD be stored in "coding order". That means the references first and then the frames referencing them. A consequence is that timecodes MAY NOT be consecutive. But a frame with a past timecode MUST reference a frame already known, otherwise it's considered bad/void.

There can be many Blocks in a BlockGroup provided they all have the same timecode. It is used with different parts of a frame with different priorities.

#### Block Header

| Offset | Player | Description |
|:-------|:-------|:------------|
| 0x00+  | MUST   | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+  | MUST   | Timecode (relative to Cluster timecode, signed int16) |

#### Block Header Flags

| Offset | Bit | Player | Description |
|:-------|:----|:-------|:------------|
| 0x03+  | 0-3 | -      | Reserved, set to 0 |
| 0x03+  | 4   | -      | Invisible, the codec SHOULD decode this frame but not display it |
| 0x03+  | 5-6 | MUST   | Lacing |
|        |     |        | *   00 : no lacing |
|        |     |        | *   01 : Xiph lacing |
|        |     |        | *   11 : EBML lacing |
|        |     |        | *   10 : fixed-size lacing |
| 0x03+  | 7   | -      | not used |

#### Laced Data

When lacing bit is set.

| Offset      | Player | Description |
|:------------|:-------|:------------|
| 0x00        | MUST   | Number of frames in the lace-1 (uint8) |
| 0x01 / 0xXX | MUST*  | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |

For (possibly) Laced Data

| Offset | Player | Description |
|:-------|:-------|:------------|
| 0x00   | MUST   | Consecutive laced frames |

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

Bit Representation                                                          | Value
:---------------------------------------------------------------------------|:-------
1xxx xxxx                                                                   | value -(2^6-1) to 2^6-1 (ie 0 to 2^7-2 minus 2^6-1, half of the range)
01xx xxxx  xxxx xxxx                                                        | value -(2^13-1) to 2^13-1
001x xxxx  xxxx xxxx  xxxx xxxx                                             | value -(2^20-1) to 2^20-1
0001 xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                                  | value -(2^27-1) to 2^27-1
0000 1xxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx                       | value -(2^34-1) to 2^34-1
0000 01xx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx            | value -(2^41-1) to 2^41-1
0000 001x  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx  xxxx xxxx | value -(2^48-1) to 2^48-1

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

Frames using references SHOULD be stored in "coding order". That means the references first and then the frames referencing them. A consequence is that timecodes MAY NOT be consecutive. But a frame with a past timecode MUST reference a frame already known, otherwise it's considered bad/void.

There can be many Blocks in a BlockGroup provided they all have the same timecode. It is used with different parts of a frame with different priorities.

##### SimpleBlock Header

| Offset | Player | Description |
|:-------|:-------|:------------|
| 0x00+  | MUST   | Track Number (Track Entry). It is coded in EBML like form (1 octet if the value is < 0x80, 2 if < 0x4000, etc) (most significant bits set to increase the range). |
| 0x01+  | MUST   | Timecode (relative to Cluster timecode, signed int16) |

##### SimpleBlock Header Flags

| Offset | Bit | Player | Description |
|:-------|:----|:-------|:------------|
| 0x03+  | 0   | -      | Keyframe, set when the Block contains only keyframes |
| 0x03+  | 1-3 | -      | Reserved, set to 0 |
| 0x03+  | 4   | -      | Invisible, the codec SHOULD decode this frame but not display it |
| 0x03+  | 5-6 | MUST   | Lacing |
|        |     |        | *   00 : no lacing |
|        |     |        | *   01 : Xiph lacing |
|        |     |        | *   11 : EBML lacing |
|        |     |        | *   10 : fixed-size lacing |
| 0x03+  | 7   | -      | Discardable, the frames of the Block can be discarded during playing if needed |

#### Laced Data

When lacing bit is set.

| Offset      | Player | Description |
|:------------|:-------|:------------|
| 0x00        | MUST   | Number of frames in the lace-1 (uint8) |
| 0x01 / 0xXX | MUST*  | Lace-coded size of each frame of the lace, except for the last one (multiple uint8). *This is not used with Fixed-size lacing as it is calculated automatically from (total size of lace) / (number of frames in lace). |

For (possibly) Laced Data

| Offset      | Player | Description |
|:------------|:-------|:------------|
| 0x00        | MUST   | Consecutive laced frames |
