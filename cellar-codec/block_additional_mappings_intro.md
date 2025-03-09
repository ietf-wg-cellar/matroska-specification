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

The values of `BlockAddID` that are 2 of greater have no semantic meaning, but simply
associate the `BlockMore` element with a `BlockAdditionMapping` of the associated `Track`.
See (#block-additional-mapping) on `Block Additional Mappings` for more information.

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
        <BlockAddIDType>12</BlockAddIDType>
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
          <BlockAdditional>01:00:00:00</BlockAdditional>
        </BlockMore>
      </BlockAdditions>
    </BlockGroup>
  </Cluster>
</Segment>
```

`Block Additional Mappings` detail how additional data **MAY** be stored in the `BlockMore` element
with a `BlockAdditionMapping` element, within the `Track` element, which identifies the `BlockAdditional` content.
`Block Additional Mappings` define the `BlockAddIDType` value reserved to identify that
type of data as well as providing an optional label stored within the `BlockAddIDName` element.
When the `Block Additional Mapping` is dependent on additional contextual information,
then the Mapping **SHOULD** describe how such additional contextual information is stored within the `BlockAddIDExtraData` element.
