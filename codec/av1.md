# AOM AV1 codec mapping in Matroska/WebM

This document specifies the storage format for [AV1](#av1-specifications) bitstreams in [Matroska](#matroska-specifications) tracks. Everytime [Matroska](#referenced-documents) is mentioned it applies equally to [WebM](#webm-container).

Elements in this document inside square brackets __[]__ refer to elements as defined in the [AV1 Specifiations](#av1-specifications).


# Terms

## Block
A Matroska element to store a Frame. Can also be a `SimpleBlock` when not inside a `BlockGroup`. Using `Block` in this document will mean both forms of Block.

## CodecID
The name used to describe a codec in Matroska.

## CodecPrivate
Extra data passed to the decoder before decoding starts. It can also be used to store the profiles and other data to better identify the codec.

## OBU
Open Bitstream Unit is the basic unit of data in AV1. It contains a header and a payload.

## Segment
The top Matroska element that contains interleaved audio, video, subtitles as well as track descriptions, chapters, tags, etc. Usually a Matroska file is made of one Segment.

## Temporal Unit
All the OBUs that are associated with a time instant. It consists of a `Temporal Delimiter OBU`, and all the OBUs that follow, up to but not including the next `Temporal Delimiter OBU`.

## CVS
A Coded Video Sequence is a sequence of `Temporal Units` where the contents of all `Sequence Header OBUs` in the bitstream before Matroska encapsulation must be bit-identical except for the contents of __[operating_parameters_info]__.


# TrackEntry elements

## CodecID 
EBML Path: `\Segment\Tracks\TrackEntry\CodecID` | Mandatory: Yes

The `CodecID` MUST be the ASCII string `V_AV1`.

## CodecPrivate
EBML Path: `\Segment\Tracks\TrackEntry\CodecPrivate` | Mandatory: Yes

The `CodecPrivate` consists of one of more OBUs appended together. The first OBU MUST be the first `Sequence Header OBU` and be the only OBU of type `OBU_SEQUENCE_HEADER` in the `CodecPrivate`. OBUs of type `OBU_TEMPORAL_DELIMITER`, `OBU_FRAME_HEADER`, `OBU_TILE_GROUP`, `OBU_FRAME`, `OBU_REDUNDANT_FRAME_HEADER`, `OBU_TILE_LIST` and `OBU_PADDING` MUST not be found in the `CodecPrivate`. In other words as of version 1.0.0 of the AV1 specifications, only OBUs of type `OBU_SEQUENCE_HEADER` and `OBU_METADATA` are allowed in the `CodecPrivate`.

OBUs in the `CodecPrivate` SHOULD have the __[obu_has_size_field]__ set to 1, indicating that the size of the OBU payload follows the header, and that it is coded using __[LEB128]__, except for the last OBU in the `CodecPrivate`, for which __[obu_has_size_field]__ MAY be set to 0, in which case it is assumed to fill the remaining of the `CodecPrivate`.

The __[timing_info_present_flag]__ of the `Sequence Header OBU` SHOULD be 0. Even when it is 1 the presentation time of the `Frame Header OBUs` in `Blocks` should be discarded. In other words, only the timestamps given by the Matroska container MUST be used.

## PixelWidth
EBML Path: `\Segment\Tracks\TrackEntry\Video\PixelWidth` | Mandatory: Yes

The `PixelWidth` MUST be __[max_frame_width_minus_1]__+1.

## PixelHeight
EBML Path: `\Segment\Tracks\TrackEntry\Video\PixelHeight` | Mandatory: Yes

The `PixelHeight` MUST be __[max_frame_height_minus_1]__+1.

## DisplayWidth
EBML Path: `\Segment\Tracks\TrackEntry\Video\DisplayWidth` | Mandatory: No

If custom aspect ratio, crop values are not needed and the `DisplayUnit` is in pixels, the `DisplayWidth` SHOULD be __[render_width_minus_1]__+1 if __[render_and_frame_size_different]__ is 1 and __[max_frame_width_minus_1]__+1 otherwise.

*Note: in Matroska the `DisplayWidth` doesn't have to be written if it's the same value as the `PixelWidth`*

## DisplayHeight
EBML Path: `\Segment\Tracks\TrackEntry\Video\DisplayHeight` | Mandatory: No

If custom aspect ratio, crop values are not needed and the `DisplayUnit` is in pixels, the `DisplayHeight` SHOULD be __[render_height_minus_1]__+1 if __[render_and_frame_size_different]__ is 1 and __[max_frame_height_minus_1]__+1 otherwise.

*Note: in Matroska the `DisplayHeight` doesn't have to be written if it's the same value as the `PixelHeight`*


# Block Data
Each `Block` contains one `Temporal Unit` containing one or more OBUs. Each OBU stored in the Block MUST contain its header and its payload. 

The OBUs in the `Block` follow the __[Low Overhead Bitstream Format syntax]__. They SHOULD have the __[obu_has_size_field]__ set to 1 except for the last OBU in the sample, for which __[obu_has_size_field]__ MAY be set to 0, in which case it is assumed to fill the remaining of the sample.

The order of OBUs should follow the order defined in the section 7.5 of the [AV1 Specifiations](#av1-specifications).

There MUST be at least one `Frame Header OBU` per `Block`.

The `Temporal Delimiter OBU` MUST be omitted.

The `Padding OBUs` SHOULD be omitted if encryption is not used.

The `Redundant Frame Header OBUs` SHOULD not be used.

OBU trailing bits SHOULD be limited to byte alignment and SHOULD not be used for padding.

A `SimpleBlock` MUST NOT be marked as a Keyframe if it doesn't contain a `Frame OBU`. A `SimpleBlock` MUST NOT be marked as a Keyframe if the first `Frame OBU` doesn't have a __[frame_type]__ of `KEY_FRAME`.

A `Block` inside a `BlockGroup` MUST use `ReferenceBlock` elements if the first `Frame OBU` in the `Block` has a __[frame_type]__ other than `KEY_FRAME`.

A `Block` with __[frame_header_obu]__ where the __[frame_type]__  is `INTRA_ONLY_FRAME` MUST use a `ReferenceBlock` with a value of 0 to reference itself. This way it cannot be mistaken for a random access point.

`ReferenceBlocks` inside a `BlockGroup` MUST reference frames according to the __[ref_frame_idx]__ values of frame that is neither a `KEYFRAME` nor an `INTRA_ONLY_FRAME`.

*Note: `SimpleBlock` and `BlockGroup` can be used for each type of frame. `SimpleBlock` is usually preferred if features of the `BlockGroup` (`BlockDuration`, `BlockAdditions`, etc) are not needed.*

The __[temporal_point_info]__ contained in  `Frame OBUs` or `Frame Header OBUs` SHOULD be discarded.

The `Block` timestamp is translated from the __[PresentationTime]__ without the __[InitialPresentationDelay]__.


# Segment Restrictions

AV1 stored in Matroska restricts the allowed variations among the `Sequence Header OBUs` contained in the `CodecPrivate` and also in-band in the `Blocks`. The changes are restricted to the changes that are allowed for the `Sequence Header OBUs` of a `CVS`, i.e. the contents of the `Sequence Header OBUs` MUST be bit-identical each time a `Sequence Header OBU` appears except for the contents of __[operating_parameters_info]__. Furthermore the dimensions of all output frames MUST be equal.


# Seeking and Sequence Header Requirements

`SimpleBlocks` with the `Keyframe` flag set and `Blocks` inside `BlockGroups` that do not contain any `ReferenceBlock` elements constitute the Random Access Points (RAP) of a Matroska `Track`.

Upon random access to a RAP or upon starting playback from the beginning the player/demuxer MUST prepend the `Sequence Header OBU` contained in the `CodecPrivate` to the data of the `Block` where decoding starts after having reverted any potentially applying `ContentCompression`. Afterwards playback proceeds normally including consumption of any `Sequence Header OBUs` that are found in the bitstream.

Seeking to a non-RAP is undefined and discouraged.

A muxer MUST make sure that when using a conformant demuxer/player the correct `Sequence Header OBU` is active both during linear access and also after random access to a RAP. In particular, if a `Sequence Header OBU` whose contents differ from the contents of the `Sequence Header OBU` in the `CodecPrivate` is active during consumption of the first `Frame Header OBU` of a RAP when performing linear access from the beginning, then said `Block` MUST contain said `Sequence Header OBU` in front of the first `Frame Header OBU` so that it is also active when performing random access to said RAP.

A muxer MAY omit (strip away and discard) `Sequence Header OBUs` provided the above criteria are still fulfilled afterwards.

*Notes: a) The contents of two `Sequence Header OBUs` of an AV1 bitstream compliant with the requirements for AV1 tracks in Matroska can only differ if __[decoder_model_present_for_this_op]__ is 1 for some operating point for one (hence every) `Sequence Header OBU`. In particular, if __[timing_info_present]__ is set to 0 for any (hence every) `Sequence Header OBU`, all `Sequence Header OBUs` can be omitted from the bitstream.*

*b) A `Sequence Header OBU` that fulfills any of these criteria can be omitted without changing compliance to the above criteria:*

*If, after potentially stripping away all `Temporal Delimiter OBUs`, there are more than one `Sequence Header OBUs` immediately after one another, then all but the last of these `Sequence Header OBUs` can be omitted.*

*A `Sequence Header OBU` whose contents differ from the contents of the `Sequence Header OBU` in the `CodecPrivate` can be omitted if there was a preceding `Sequence Header OBU` in the bitstream, if the contents of the the preceding `Sequence Header OBU` were bit-identical to the contents of the current `Sequence Header OBU` and if the current `Sequence Header OBU` is not the first OBU after a `Temporal Delimiter OBU` that starts a temporal unit whose corresponding `Block` is a RAP.*

*A `Sequence Header OBU` whose contents are bit-identical to the contents of the `Sequence Header OBU` in the `CodecPrivate` can be omitted if there was no preceding `Sequence Header OBU` or if there was a preceding `Sequence Header OBU` and the contents of the preceding `Sequence Header OBU` were bit-identical to the contents of the current `Sequence Header OBU`.*

# Encryption

[Common Encryption] should be used to encrypt AV1 tracks. `cenc` and `cbcs` scheme types are permitted.

The OBUs found in the `CodecPrivate` SHOULD not be encrypted.

The OBUs found in the `Block` SHOULD only encrypt the OBU payload. The payload of `Sequence Header OBUs` and `Metadata OBUs` SHOULD not be encrypted.

Tile Group OBUs, Frame OBUs and Tile List OBUs SHOULD be encrypted using Subsample Encryption.


# More TrackEntry mappings

The elements described in the main `TrackEntry` section are vital for correct playback. Here we present a list of elements found in a `TrackEntry` that SHOULD also be mapped from the data found in the main `Sequence Header OBU` and the `Metadata OBUs`, all found in the `CodecPrivate`.

## DefaultDuration
EBML Path: `\Segment\Tracks\TrackEntry\DefaultDuration` | Mandatory: No

The `DefaultDuration` MAY be used if __[timing_info_present_flag]__ and __[equal_picture_interval]__ are set to 1.

## Colour Range
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\Range` | Mandatory: No

The `Range` corresponds to the __[color_range]__.
* 0 (Studio) in AV1 corresponds to 1 in Matroska
* 1 (Full) in AV1 corresponds to 2 in Matroska

## BitsPerChannel
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\BitsPerChannel` | Mandatory: No

The `BitsPerChannel` corresponds to the __[BitDepth]__ of the Sequence Header OBU found in the `CodecPrivate`.

## MatrixCoefficients
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MatrixCoefficients` | Mandatory: No

The `MatrixCoefficients` corresponds to the __[matrix_coefficients]__ of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## ChromaSitingHorz
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\ChromaSitingHorz` | Mandatory: No

`ChromaSitingHorz` is deduced from __[chroma_sample_position]__:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 1 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## ChromaSitingVert
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\ChromaSitingVert` | Mandatory: No

`ChromaSitingVert` is deduced from __[chroma_sample_position]__:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 2 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## TransferCharacteristics
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\TransferCharacteristics` | Mandatory: No

The `TransferCharacteristics` corresponds to the __[transfer_characteristics]__ of the Sequence Header OBU found in the `CodecPrivate`.

## Primaries
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\Primaries` | Mandatory: No

The `Primaries` corresponds to the __[color_primaries]__ of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## MaxCLL
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MaxCLL` | Mandatory: No

The `MaxCLL` corresponds to __[max_cll]__ of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## MaxFALL
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MaxFALL` | Mandatory: No

The `MaxFALL` corresponds to __[max_fall]__ of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## PrimaryRChromaticityX
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryRChromaticityX` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[0]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## PrimaryRChromaticityY
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryRChromaticityY` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[0]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## PrimaryGChromaticityX
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryGChromaticityX` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[1]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## PrimaryGChromaticityY
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryGChromaticityY` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[1]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## PrimaryBChromaticityX
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryBChromaticityX` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[2]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## PrimaryBChromaticityY
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\PrimaryBChromaticityY` | Mandatory: No

The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[2]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## WhitePointChromaticityX
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\WhitePointChromaticityX` | Mandatory: No

The `WhitePointChromaticityX` corresponds to __[white_point_chromaticity_x]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## WhitePointChromaticityY
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\WhitePointChromaticityY` | Mandatory: No

The `WhitePointChromaticityY` corresponds to __[white_point_chromaticity_y]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## LuminanceMin
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\LuminanceMin` | Mandatory: No

The `LuminanceMin` corresponds to __[luminance_min]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## LuminanceMax
EBML Path: `\Segment\Tracks\TrackEntry\Video\Colour\MasteringMetadata\LuminanceMax` | Mandatory: No

The `LuminanceMin` corresponds to __[luminance_max]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## ContentCompSettings
EBML Path: `\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentCompression\ContentCompSettings` | Mandatory: No

It MAY be convenient to put the first OBUs that starts each `Temporal Unit`, excluding the `Temporal Delimiter OBU`, in the `ContentCompSettings` to save space. These will be added before each `Block` data when feeding the decoder and thus MUST have the same binary value for each `Block`.


# Referenced documents

## AV1 Specifications
Official PDF: https://aomediacodec.github.io/av1-spec/av1-spec.pdf


## Matroska Specifications
IETF draft: https://datatracker.ietf.org/doc/draft-lhomme-cellar-matroska/

Original Specifications: https://matroska.org/technical/specs/index.html


## WebM Container
Official Specification based on the Matroska specifications: https://www.webmproject.org/docs/container/


# Document version

This is version 1 of this document.