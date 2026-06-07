# Block Addition Mappings

This section describes the various types of `BlockAdditionMapping` that can be stored in Matroska.
These help the player interpret the multiple `BlockAdditions` that can be added to each Matroska `BlockGroup`.
More details can be found in section (#block-additional-mapping).

## Defining Block Addition Mappings

Support for a Block Addition mapping is defined in Matroska with the following values.

### Block Type Identifier

Each `BlockAdditionMapping` supported in Matroska **MUST** have a unique `BlockAddIDType`.
It **MUST** be defined for each Block Addition Mapping.
The unsigned integers are expressed in hexadecimal as large values can be used.

### Block Type Name

Each `BlockAdditionMapping` supported in Matroska **MAY** have a `BlockAddIDName`.
The `BlockAddIDName` provides a readable label for the encoding.

### Description

An optional description for the encoding. This value is only intended for human consumption.

## Initial Block Addition Mappings

### Use BlockAddIDValue

Block type identifier: 0x00

Block type name: "BlockAddIDValue"

Description: This value indicates that the actual type is stored in `BlockAddIDValue` instead.
This value is used when it is important to have a strong compatibility
with players or derived formats not supporting `BlockAdditionMapping` but using `BlockAdditions`
with an unknown `BlockAddIDValue`, and **SHOULD NOT** be used if it is possible to use another value.

### Opaque Data

Block type identifier: 0x01

Block type name: "Opaque data"

Description: the `BlockAdditional` data is interpreted as opaque additional data passed to the codec
with the Block data.
The usage of these `BlockAdditional` data is defined in the "Codec BlockAdditions" section of the codec; see (#codec-blockadditions).

### ITU T.35 Metadata

Block type identifier: 0x04

Block type name: "ITU T.35 metadata"

Description: the `BlockAdditional` data is interpreted as ITU T.35 metadata, as defined by [@?ITU-T.35]
terminal codes. `BlockAddIDValue` **MUST** be 4.

HDR10+ dynamic metadata can be stored as ITU T.35 terminal codes as defined in Table 8 of [@?CTA.861-4].

### SMPTE ST 12-1 Timecode

Block type identifier: 0x79

Block type name: "SMPTE ST 12-1 timecode"

Description: the `BlockAdditional` data is defined in more details in (#smpte-st-12-1-timecode-description).

### avcE

Block type identifier: 0x61766345

Block type name: Dolby Vision enhancement-layer AVC configuration

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer AVC
configuration box as described in [@!DolbyVision-ISOBMFF]. This extension **MUST NOT**
be used if `CodecID` is not `V_MPEG4/ISO/AVC`.

### hvcE

Block type identifier: 0x68766345

Block type name: "Dolby Vision enhancement-layer HEVC configuration"

Description: the `BlockAddIDExtraData` data is interpreted as the Dolby Vision enhancement-layer HEVC configuration as described in [@!DolbyVision-ISOBMFF].
This extension **MUST NOT** be used if `CodecID` is not `V_MPEGH/ISO/HEVC`.

### dvcC

Block type identifier: 0x64766343

Block type name: "Dolby Vision configuration dvcC"

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 0 to 7 inclusive.

### dvvC

Block type identifier: 0x64767643

Block type name: "Dolby Vision configuration dvvC"

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 8 to 10 inclusive and 20.

### dvwC

Block type identifier: 0x64767743

Block type name: "Dolby Vision configuration dvwC"

Description: the `BlockAddIDExtraData` data is interpreted as `DOVIDecoderConfigurationRecord` structure, as defined in [@!DolbyVision-ISOBMFF],
for Dolby Vision profiles 11 to 19 inclusive.

### mvcC

Block type identifier: 0x6D766343

Block type name: "MVC configuration"

Description: the `BlockAddIDExtraData` data is interpreted as `MVCDecoderConfigurationRecord` structure, as defined in [@!ISO.14496-15].
This extension **MUST NOT** be used if `CodecID` is not `V_MPEG4/ISO/AVC`.

# Block Additional Mapping

Extra data or metadata can be added to each `Block` using `BlockAdditional` data.
Each `BlockAdditional` contains a `BlockAddID` that identifies the kind of data it contains.
When the `BlockAddID` is set to "1" the contents of the `BlockAdditional` element
are defined by the "Codec BlockAdditions" section of the codec; see (#codec-blockadditions).

The following XML depicts the nested elements of a `BlockGroup` element with an example of `BlockAdditions` with a `BlockAddID` of "1":

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

When the `BlockAddID` is set a value greater than "1", then the contents of the
`BlockAdditional` element are defined by the `BlockAdditionMapping` element, within
the associated `TrackEntry` element, where the `BlockAddID` element of `BlockAdditional` element
equals the `BlockAddIDValue` of the associated `TrackEntry`'s `BlockAdditionMapping` element.
That `BlockAdditionMapping` element identifies a particular `Block Additional Mapping` by the `BlockAddIDType`.

The values of `BlockAddID` that are 2 or greater have no semantic meaning, but simply
associate the `BlockMore` element with a `BlockAdditionMapping` of the associated `Track`.
See (#block-additional-mapping) on `Block Additional Mappings` for more information.

It is **RECOMMENDED** to not use a value of 4 for `BlockAddID` and `BlockAddIDValue` when `BlockAddIDType` is not 4 -- i.e., ITU T.35 metadata (#itu-t-35-metadata),
as some WebM-oriented demuxers consider a block with `BlockAddID` of 4 as ITU T.35 metadata
without checking the `BlockAddIDType` element.

The following XML depicts a use of a `Block Additional Mapping` to associate a timecode value with a `Block`:

```xml
<Segment>
  <!--Mandatory elements omitted for readability-->
  <Tracks>
    <TrackEntry>
      <TrackNumber>1</TrackNumber>
      <TrackUID>568001708</TrackUID>
      <TrackType>1</TrackType>
      <BlockAdditionMapping>
        <BlockAddIDValue>2</BlockAddIDValue><!--arbitrary value
          used in BlockAddID-->
        <BlockAddIDName>timecode</BlockAddIDName>
        <BlockAddIDType>0x79</BlockAddIDType>
      </BlockAdditionMapping>
      <CodecID>V_FFV1</CodecID>
      <Video>
        <PixelWidth>1920</PixelWidth>
        <PixelHeight>1080</PixelHeight>
      </Video>
    </TrackEntry>
  </Tracks>
  <Cluster>
    <Timestamp>3000</Timestamp>
    <BlockGroup>
      <Block>{binary video frame}</Block>
      <BlockAdditions>
        <BlockMore>
          <BlockAddID>2</BlockAddID><!--arbitrary value from
            BlockAdditionMapping-->
          <BlockAdditional>01:00:00:00</BlockAdditional><!--presented
           as a string for readability but should use binary encoding
           defined in the associated mapping -->
        </BlockMore>
      </BlockAdditions>
    </BlockGroup>
  </Cluster>
</Segment>
```

`Block Additional Mappings` detail how additional data is stored in the `BlockMore` element
with a `BlockAdditionMapping` element, within the `Track` element, which identifies the `BlockAdditional` content.
`Block Additional Mappings` define the `BlockAddIDType` value reserved to identify that
type of data as well as providing an optional label stored within the `BlockAddIDName` element.
When the `Block Additional Mapping` is dependent on additional contextual information,
then the Mapping **SHOULD** describe how such additional contextual information is stored within the `BlockAddIDExtraData` element.
