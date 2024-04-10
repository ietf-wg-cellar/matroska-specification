## c608 Captions

### c608 Captions Description

CEA-608 captions can be stored in `BlockMore Element` to associate the content of a Matroska Block (typically a video frame) with closed captioning data. Storing CEA-608 caption data requires that the corresponding Block SHALL NOT use Lacing.

The `BlockAdditional Element` stores the c608 data as a array of one or more octet pairs from one data channel of a CEA-608 data stream with each octet pair corresponding to a video frame. For more information about the content see [@!ANSI-CTA-608-E-S-2019].

### BlockAddIDType

The BlockAddIDType value reserved for CEA-608 captions is "608".

### BlockAddIDName

The BlockAddIDName value reserved for CEA-608 captions is "CEA-608 captions".

### BlockAddIDExtraData

BlockAddIDExtraData MAY contain a value as defined by Section 6.4.3.3 of [!@DASH-IF-IOP] that describes the caption services and language. An ABNF from [!@DASH-IF-IOP] for this value is restated here for convenience:

```
@value = (channel *3 [";" channel]) / (language *3[";" language])
2 channel = channel-number "=" language
3 channel-number = CC1 | CC2 | CC3 | CC4
4 language = 3ALPHA ; language code per ISO 639.2/B
```
