# Block Additional Mapping

Extra data or metadata can be added to each `Block` using `BlockAdditional` data.
Each `BlockAdditional` contains a `BlockAddID` that identifies the kind of data it contains.
When the `BlockAddID` is set to "1" the contents of the `BlockAdditional` element
are define by the Codec Mappings defines; see (#codec-blockadditions).
When the `BlockAddID` is set a value greater than "1", then the contents of the
`BlockAdditional` element are defined by the `BlockAdditionalMapping` element, within
the associated `Track` element, where the `BlockAddID` element of `BlockAdditional` element
equals the `BlockAddIDValue` of the associated `Track`'s `BlockAdditionalMapping` element.
That `BlockAdditionalMapping` element identifies a particular `Block Additional Mapping` by the `BlockAddIDType`.

The following XML depicts a use of a `Block Additional Mapping` to associate a timecode value with a `Block`:

```xml
&lt;Segment&gt;
  &lt;!--Mandatory elements omitted for readability--&gt;
  &lt;Tracks&gt;
    &lt;TrackEntry&gt;
      &lt;TrackNumber&gt;1&lt;/TrackNumber&gt;
      &lt;TrackUID&gt;568001708&lt;/TrackUID&gt;
      &lt;TrackType&gt;1&lt;/TrackType&gt;
      &lt;BlockAdditionalMapping&gt;
        &lt;BlockAddIDValue&gt;2&lt;/BlockAddIDValue&gt;&lt;!--arbitrary value
          used in BlockAddID--&gt;
        &lt;BlockAddIDName&gt;timecode&lt;/BlockAddIDName&gt;
        &lt;BlockAddIDType&gt;12&lt;/BlockAddIDType&gt;
      &lt;/BlockAdditionalMapping&gt;
      &lt;CodecID&gt;V_FFV1&lt;/CodecID&gt;
      &lt;Video&gt;
        &lt;PixelWidth&gt;1920&lt;/PixelWidth&gt;
        &lt;PixelHeight&gt;1080&lt;/PixelHeight&gt;
      &lt;/Video&gt;
    &lt;/TrackEntry&gt;
  &lt;/Tracks&gt;
  &lt;Cluster&gt;
    &lt;Timestamp&gt;3000&lt;/Timestamp&gt;
    &lt;BlockGroup&gt;
      &lt;Block&gt;{binary video frame}&lt;/Block&gt;
      &lt;BlockAdditions&gt;
        &lt;BlockMore&gt;
          &lt;BlockAddID&gt;2&lt;/BlockAddID&gt;&lt;!--arbitrary value from
            BlockAdditionalMapping--&gt;
          &lt;BlockAdditional&gt;01:00:00:00&lt;/BlockAdditional&gt;
        &lt;/BlockMore&gt;
      &lt;/BlockAdditions&gt;
    &lt;/BlockGroup&gt;
  &lt;/Cluster&gt;
&lt;/Segment&gt;
```

`Block Additional Mappings` detail how additional data **MAY** be stored in the `BlockMore` element
with a `BlockAdditionMapping` element, within the `Track` element, which identifies the `BlockAdditional` content.
`Block Additional Mappings` define the `BlockAddIDType` value reserved to identify that
type of data as well as providing an optional label stored within the `BlockAddIDName` element.
When the `Block Additional Mapping` is dependent on additional contextual information,
then the Mapping **SHOULD** describe how such additional contextual information is stored within the `BlockAddIDExtraData` element.

The following `Block Additional Mappings` are defined.

## Summary of Assigned BlockAddIDType Values

For convenience, the following table shows the assigned BlockAddIDType values along with the BlockAddIDName and Citation.

| BlockAddIDType | BlockAddIDName                                               | Citation                             |
|:---------------|:-------------------------------------------------------------|:-------------------------------------|
| 121            | SMPTE ST 12-1 timecode                                       | (#smpte-st-12-1-timecode)            |

