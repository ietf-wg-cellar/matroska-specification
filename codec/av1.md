# AOM AV1 codec mapping in Matroska/WebM

This document specifies the storage format for [AV1](#av1-specifications) bitstreams in [Matroska](#matroska-specifications) tracks. Everytime [Matroska](#referenced-documents) is mentioned it applies equally to [WebM](#webm-container).

Elements in this document inside square brackets __[]__ refer to elements as defined in the [AV1 Specifiations](#av1-specifications).


# Terms

## Block
A Matroska element to store a Frame. Can also be a `SimpleBlock` when not inside a `BlockGroup`. Using `Block` in this document will mean both forms of Block.

## CodecID
The name used to describe a codec in Matroska.

## CVS
A Coded Video Sequence is a sequence of video frames where the contents of __[sequence_header_obu]__ must be bit-identical for all the `Sequence Header OBUs` found in the original bitstream except for the contents of __[operating_parameters_info]__.

## CodecPrivate
Extra data passed to the decoder before decoding starts. It can also be used to store the profiles and other data to better identify the codec.

## OBU
Open Bitstream Unit is the basic unit of data in AV1. It contains a header and a payload.

## Segment
The Matroska element that contains interleaved audio, video, subtitles as well as track descriptions, chapters, tags, etc. Usually a Matroska file is made of one Segment.

## Temporal Unit
All the OBUs that are associated with a time instant. It consists of a `Temporal Delimiter OBU`, and all the OBUs that follow, up to but not including the next temporal delimiter.


# TrackEntry elements

## CodecID 
The `CodecID` should be the ASCII string `V_AV1`.

## CodecPrivate
The `CodecPrivate` consists of one of more OBUs appended together. The first OBU MUST the first `Sequence Header OBU` and be the only OBU of type `OBU_SEQUENCE_HEADER` in the `CodecPrivate`. Other types of OBUs found in the `CodecPrivate` MAY be of type `OBU_METADATA`.

OBUs in the `CodecPrivate` SHOULD have the __[obu_has_size_field]__ set to 1, indicating that the size of the OBU payload follows the header, and that it is coded using __[LEB128]__.

The __[timing_info_present_flag]__ of the `Sequence Header OBU` SHOULD be 0. Even when it is 1 the presentation time of the `Frame Header OBUs` in `Blocks` should be discarded. In other words, only the timestamps given by the Matroska container MUST be used.

## Video\PixelWidth
The `PixelWidth` MUST be the __[max_frame_width_minus_1]__+1.

## Video\PixelHeight
The `PixelHeight` MUST be the __[max_frame_height_minus_1]__+1.

## Video\DisplayWidth
The `DisplayWidth` MAY be the __[render_width_minus_1]__+1 if __[render_and_frame_size_different]__ is 1 and __[max_frame_width_minus_1]__+1 otherwise.

If __[render_and_frame_size_different]__ is 0 the `DisplayWidth` MAY not be stored in Matroska as its implied by the format.

## Video\DisplayHeight
The `DisplayHeight` MAY be the __[render_height_minus_1]__+1 if __[render_and_frame_size_different]__ is 1 and __[max_frame_height_minus_1]__+1 otherwise.

If __[render_and_frame_size_different]__ is 0 the `DisplayHeight` MAY not be stored in Matroska as its implied by the format.


# Block Data
Each `Block` contain one `Temporal Unit` containing one or more OBUs. Each OBU stored in the Block MUST contain its header and its payload. They SHOULD have the __[obu_has_size_field]__ set to 1 except for the last OBU in the sample, for which __[obu_has_size_field]__ MAY be set to 0, in which case it is assumed to fill the remaining of the sample. The order of OBUs should follow the order defined in the [AV1 Specifiations](#av1-specifications).

There MUST be at least one `Frame Header OBU` per `Block`.

The OBUs in the `Block` SHOULD follow the __[Low Overhead Bitstream Format syntax]__.

The `Temporal Delimiter OBU` MUST be omitted.

The `Padding OBUs` SHOULD be omitted if encryption is not used.

`Redundant Frame Header OBUs` SHOULD not be used.

OBU trailing bits SHOULD be limited to byte alignment and SHOULD not be used for padding.

`Sequence Header OBUs` SHOULD be omitted when they are bit-identical to the one found in `CodecPrivate` and __[decoder_model_info_present_flag]__ is 0. They can be kept when encryption constraints require it.

A `SimpleBlock` MUST only be marked as a Keyframe if the first `Frame Header OBU` in the `Block` has a __[frame_type]__ of `KEY_FRAME` and the `SimpleBlock` contains a `Sequence Header OBU` or the `Sequence Header OBU` is correctly omitted.

A `Block` inside a `BlockGroup` MUST use `ReferenceBlock` elements if the first `Frame Header OBU` in the `Block` has a __[frame_type]__ other than `KEY_FRAME` or the `Block` doesn't contain a `Sequence Header OBU` when it should not be omitted.

A `Block` with `Frame Header OBUs` where the __[frame_type]__  is `INTRA_ONLY_FRAME` MUST use a `ReferenceBlock` with a value of 0 to reference itself. This way it cannot be mistaken for a random access point in Matroska.

`ReferenceBlocks` inside a `BlockGroup` MUST reference frames according to the __[ref_frame_idx]__ values of frame that is neither a `KEYFRAME` nor an `INTRA_ONLY_FRAME`.

The timing information contained in `Frame header OBUs` SHOULD be discarded, fields like __[frame_presentation_delay]__ and __[buffer_removal_delay]__.

The `Block` timestamp is translated from the __[PresentationTime]__.


# Segment restrictions

Matroska doesn't allow dynamic changes within a codec for the whole `Segment`. The parameters that should not change for a video `Track` are the dimensions and the `CodecPrivate`. 

The first `Sequence Header OBU` of a `CVS` is stored in the `CodecPrivate` so the `Segment` with AV1 tracks has the same requirements as the `CVS`. If the __[decoder_model_info_present_flag]__ is set to 1 in this `Sequence Header OBU` then each keyframe `Block` MUST contain a `Sequence Header OBU` before the `Frame Header OBUs`.


# Encryption

[Common Encryption] should be used to encrypt AV1 tracks. `cenc` and `cbcs` scheme types are permitted.

The OBUs found in the `CodecPrivate` SHOULD not be encrypted.

The OBUs found in the `Block` SHOULD only encrypt the OBU payload. The payload of `Sequence Header OBUs` and `Metadata OBUs` SHOULD not be encrypted.

Tile Group OBUs, Frame OBUs and Tile List OBUs SHOULD be encrypted using Subsample Encryption.


# More TrackEntry mappings

The elements described in the main `TrackEntry` section are vital for correct playback. Here we present a list of elements found in a `TrackEntry` that SHOULD also be mapped from the data found in the main `Sequence Header OBU` and the `Metadata OBUs`, all found in the `CodecPrivate`.

## DefaultDuration
The `DefaultDuration` MAY be used if __[timing_info_present_flag]__ and __[equal_picture_interval]__ are set to 1.

## Video\Colour\Range
The `Range` corresponds to the __[color_range]__.
* 0 (Studio) in AV1 corresponds to 1 in Matroska
* 1 (Full) in AV1 corresponds to 2 in Matroska

## Video\Colour\BitsPerChannel
The `BitsPerChannel` corresponds to the __[BitDepth]__ of the Sequence Header OBU found in the `CodecPrivate`.

## Video\Colour\MatrixCoefficients
The `MatrixCoefficients` corresponds to the __[matrix_coefficients]__ of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## Video\Colour\ChromaSitingHorz
`ChromaSitingHorz` is deduced from __[chroma_sample_position]__:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 1 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## Video\Colour\ChromaSitingVert
`ChromaSitingVert` is deduced from __[chroma_sample_position]__:
* 0 in AV1 corresponds to 0 in Matroska
* 1 in AV1 corresponds to 2 in Matroska
* 2 in AV1 corresponds to 1 in Matroska
* 3 in AV1 corresponds to 0 in Matroska

## Video\Colour\TransferCharacteristics
The `TransferCharacteristics` corresponds to the __[transfer_characteristics]__ of the Sequence Header OBU found in the `CodecPrivate`.

## Video\Colour\Primaries
The `Primaries` corresponds to the __[color_primaries]__ of the Sequence Header OBU found in the `CodecPrivate`. Some values MAY not map correctly to values found in Matroska.

## Video\Colour\MaxCLL
The `MaxCLL` corresponds to __[max_cll]__ of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## Video\Colour\MaxFALL
The `MaxFALL` corresponds to __[max_fall]__ of the Metadata OBU of type METADATA_TYPE_HDR_CLL that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryRChromaticityX
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[0]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryRChromaticityY
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[0]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryGChromaticityX
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[1]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryGChromaticityY
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[1]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryBChromaticityX
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_x[2]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\PrimaryBChromaticityY
The `PrimaryRChromaticityX` corresponds to __[primary_chromaticity_y[2]]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\WhitePointChromaticityX
The `WhitePointChromaticityX` corresponds to __[white_point_chromaticity_x]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\WhitePointChromaticityY
The `WhitePointChromaticityY` corresponds to __[white_point_chromaticity_y]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\LuminanceMin
The `LuminanceMin` corresponds to __[luminance_min]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## Video\Colour\MasteringMetadata\LuminanceMax
The `LuminanceMin` corresponds to __[luminance_max]__ of the Metadata OBU of type METADATA_TYPE_HDR_MDCV that MAY be found in the `CodecPrivate`.

## ContentEncodings\ContentEncoding\ContentCompression\ContentCompSettings
It MAY be convenient to put the first OBUs that starts each Temporal Unit, exclusing the `Temporal Delimiter OBU`, in the `ContentCompSettings` to save space. These will be added before each `Block` data when feeding the decoder and thus MUST have the same binary value for each `Block`.


# Referenced documents

## AV1 Specifications
Official PDF: https://aomediacodec.github.io/av1-spec/av1-spec.pdf


## Matroska Specifications
IETF draft: https://datatracker.ietf.org/doc/draft-lhomme-cellar-matroska/

Original Speficiations: https://matroska.org/technical/specs/index.html


## WebM Container
Official Specification based on the Matroska specifications: https://www.webmproject.org/docs/container/
