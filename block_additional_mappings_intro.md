---
title: Block Additional Mapping
---
# Block Additional Mapping

Extra data or metadata can be added to each `Block` using `BlockAdditional` data.
Each `BlockAdditional` contains a `BlockAddID` that identifies the kind of data it contains.
When the `BlockAddID` is set to "1" the contents of the `BlockAdditional Element`
are define by the Codec Mappings defines; see (#codec-blockadditions).
When the `BlockAddID` is set a value greater than "1", then the contents of the
`BlockAdditional Element` are defined by the `BlockAdditionalMapping Element`, within
the associated `Track Element`, where the `BlockAddID Element` of `BlockAdditional Element`
equals the `BlockAddIDValue` of the associated Track's `BlockAdditionalMapping Element`.
That `BlockAdditionalMapping Element` identifies a particular Block Additional Mapping by the `BlockAddIDType`.

The following XML depicts a use of a Block Additional Mapping to associate a timecode value with a `Block`:

```xml
<Segment>
  <!--Mandatory elements ommitted for readability-->
  <Tracks>
    <TrackEntry>
      <TrackNumber>1</TrackNumber>
      <TrackUID>568001708</TrackUID>
      <TrackType>1</TrackType>
      <BlockAdditionalMapping>
        <BlockAddIDValue>2</BlockAddIDValue><!--arbitrary value
          used in BlockAddID-->
        <BlockAddIDName>timecode</BlockAddIDName>
        <BlockAddIDType>12</BlockAddIDType>
      </BlockAdditionalMapping>
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
            BlockAdditionalMapping-->
          <BlockAdditional>01:00:00:00</BlockAdditional>
        </BlockMore>
      </BlockAdditions>
    </BlockGroup>
  </Cluster>
</Segment>
```

Block Additional Mappings detail how additional data **MAY** be stored in the `BlockMore Element`
with a `BlockAdditionMapping Element`, within the `Track Element`, which identifies the `BlockAdditional` content.
Block Additional Mappings define the `BlockAddIDType` value reserved to identify that
type of data as well as providing an optional label stored within the `BlockAddIDName Element`.
When the Block Additional Mapping is dependent on additional contextual information,
then the Mapping **SHOULD** describe how such additional contextual information is stored within the `BlockAddIDExtraData Element`.

The following Block Additional Mappings are defined.

## Summary of Assigned BlockAddIDType Values

For convenience, the following table shows the assigned BlockAddIDType values along with the BlockAddIDName and Citation.

| BlockAddIDType | BlockAddIDName                                               | Citation                             |
|:---------------|:-------------------------------------------------------------|:-------------------------------------|
| 121            | SMPTE ST 12-1 timecode                                       | (#smpte-st-12-1-timecode)            |
| 107            | Key Value Pair                                               | (#key-value-pair)                    |

