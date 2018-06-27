# AOM AV1 codec mapping in Matroska/WebM

This document specifies the storage format for [AV1] bitstreams in [Matroska] tracks. Everytime [Matroska] is mentioned it applies equally to [WebM].

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
The Matroska element that contains interleaved audio, video, subtitles as well as track descriptions, chapters, tags, etc. Usually a Matroska file is made of one Segment.

## Temporal Unit
All the OBUs that are associated with a time instant. It consists of a `Temporal Delimiter OBU`, and all the OBUs that follow, up to but not including the next temporal delimiter.


# Segment restrictions

Matroska doesn't allow dynamic changes within a codec for the whole `Segment`. The parameters that should not change for a video `Track` are the dimensions and the `CodecPrivate`. AV1 can contain a single stream/track with multiple `coded video sequence` with varying `Sequence Header OBU`. Therefore some parameters MAY change within a `Segment`. But some fields in the `Sequence Header OBUs` MUST not change for the whole duration of the `Segment`: [seq_profile], [high_bitdepth], the first [seq_level_idx] and [color_range].


# TrackEntry elements

## CodecID 
The `CodecID` should be the ASCII string `"V_AV1"`.

## CodecPrivate
The `CodecPrivate` consists of one of more OBUs appended together. The first OBU MUST the first `Sequence Header OBU` and be the only OBU of type `OBU_SEQUENCE_HEADER` in the `CodecPrivate`. Other types of OBUs found in the `CodecPrivate` MAY be of type `OBU_METADATA`.

OBUs in the `CodecPrivate` SHOULD have the [obu_has_size_field] set to 1, indicating that the size of the OBU payload follows the header, and that it is coded using [LEB128].

The [timing_info_present_flag] of the `Sequence Header OBU` SHOULD be 0. Even when it is 1 the presentation time of the `Frame Header OBUs` in `Blocks` should be discarded. In other words, only the timestamps given by the Matroska container SHOULD be used.

## Video\PixelWidth
The `PixelWidth` MUST be the [max_frame_width_minus_1] + 1.

## Video\PixelHeight
The `PixelHeight` MUST be the [max_frame_height_minus_1] + 1.

## Video\DisplayWidth
The `DisplayWidth` MUST be the [render_width_minus_1] + 1 if [render_and_frame_size_different] is 1 and [max_frame_width_minus_1] + 1 otherwise.

If [render_and_frame_size_different] is 0 the `DisplayWidth` MAY not be stored in Matroska as its implied by the format.

## Video\DisplayHeight
The `DisplayHeight` MUST be the [render_height_minus_1] + 1 if [render_and_frame_size_different] is 1 and [max_frame_height_minus_1] + 1 otherwise.

If [render_and_frame_size_different] is 0 the `DisplayHeight` MAY not be stored in Matroska as its implied by the format.


# Block Data
Each `Block` contain one `Temporal Unit` containing one or more OBUs. There MUST be at least one `Frame Header OBU`. Each OBU stored in the Block MUST contain its header and its payload.

The `Temporal Delimiter OBU` MUST be omitted.

The `Padding OBUs` SHOULD be omitted if encryption is not used.

`Redundant Frame Header OBUs` SHOULD not be used.

The OBUs in the `Block` SHOULD follow [Low Overhead Bitstream Format syntax]. They SHOULD have the [obu_has_size_field] set to 1 except for the last OBU in the sample, for which [obu_has_size_field] MAY be set to 0, in which case it is assumed to fill the remaining of the sample.

OBU trailing bits SHOULD be limited to byte alignment and SHOULD not be used for padding.

`Sequence Header OBUs` MAY be found within `Blocks` if some values differ during the whole sequence of frames. They MUST have the [same seq_profile], [high_bitdepth], first [seq_level_idx] and [color_range] as the `Sequence Header OBU` found in the `CodecPrivate`. They SHOULD be ommitted if all of them are exacly the same as the one found in `CodecPrivate`.

A `SimpleBlock` SHOULD be marked as a Keyframe if the first `Frame Header OBU` in the `Block` has a [frame_type] of `KEY_FRAME`.

`ReferenceBlocks` inside a `BlockGroup` SHOULD reference frames according to the [ref_frame_idx] values of frame that is neither a `KEYFRAME` nor an `INTRA_ONLY_FRAME`.

`Blocks` marked as keyframe or with no `ReferenceBlock` SHOULD start with a `Sequence Header OBU` before any other OBU.

The Invisible bit of the `Block` corresponds to the [showable_frame] value of an AV1 frame.

The timing information contained in `Frame header OBUs` SHOULD be discarded, fields like [frame_presentation_delay] and [buffer_removal_delay].

The `Block` timestamp is translated from the [PresentationTime].


# Encryption

[Common Encryption] should be used to encrypt AV1 tracks. `cenc` and `cbcs` scheme types are permitted.

The OBUs found in the `CodecPrivate` SHOULD not be encrypted.

The OBUs found in the `Block` SHOULD only encrypt the OBU payload. The payload of `Sequence Header OBUs` and `Metadata OBUs` SHOULD not be encrypted.

Tile Group OBUs, Frame OBUs and Tile List OBUs SHOULD be encrypted using Subsample Encryption.


# More TrackEntry mappings

The elements described in the main `TrackEntry` section are vital for correct playback. Here we present a list of elements found in a `TrackEntry` that SHOULD also be mapped from the data found in the main `Sequence Header OBU` and the `Metadata OBUs`, all found in the `CodecPrivate`.

## Video\Colour\Range
The `Range` corresponds to the [color_range].
* 0 (Studio) in AV1 corresponds to 1 in Matroska
* 1 (Full) in AV1 corresponds to 2 in Matroska

## Video\FrameRate
The `FrameRate` MAY be used. It corresponds to {num_ticks_per_picture_minus_1}.

## Video\Colour\BitsPerChannel
The `BitsPerChannel` corresponds to the [BitDepth] of the Sequence Header OBU found in the `CodecPrivate`.

## Video\Colour\MatrixCoefficients
The `MatrixCoefficients` corresponds to the [matrix_coefficients] of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## Video\Colour\ChromaSitingHorz
`ChromaSitingHorz` is deduced from [chroma_sample_position]:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 1 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## Video\Colour\ChromaSitingVert
`ChromaSitingVert` is deduced from [chroma_sample_position]:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 2 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## Video\Colour\TransferCharacteristics
The `TransferCharacteristics` corresponds to the [transfer_characteristics] of the Sequence Header OBU found in the `CodecPrivate`.

## Video\Colour\Primaries
The `Primaries` corresponds to the [color_primaries] of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## Video\Colour\MaxCLL
The `MaxCLL` corresponds to [max_cll] of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## Video\Colour\MaxFALL
The `MaxFALL` corresponds to [max_fall] of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryRChromaticityX
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_x[0]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryRChromaticityY
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_y[0]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryGChromaticityX
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_x[1]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryGChromaticityY
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_y[1]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryBChromaticityX
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_x[2]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryBChromaticityY
The `PrimaryRChromaticityX` corresponds to [primary_chromaticity_y[2]] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\WhitePointChromaticityX
The `WhitePointChromaticityX` corresponds to [white_point_chromaticity_x] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\WhitePointChromaticityY
The `WhitePointChromaticityY` corresponds to [white_point_chromaticity_y] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\LuminanceMin
The `LuminanceMin` corresponds to [luminance_min] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\LuminanceMax
The `LuminanceMin` corresponds to [luminance_max] of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## ContentEncodings\ContentEncoding\ContentCompression\ContentCompSettings
It MAY be convenient to put the first OBUs that starts each Temporal Unit, exclusing the `Temporal Delimiter OBU`, in the `ContentCompSettings` to save space. These will be added before each `Block` data when feeding the decoder and thus MUST have the same binary value for each `Block`.

