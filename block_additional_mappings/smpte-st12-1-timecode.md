## SMPTE ST 12-1 Timecode Description

SMPTE ST 12-1 timecode values can be stored in the `BlockMore` element to associate
the content of a Matroska Block with a particular timecode value.
If the Block uses Lacing, the timecode value is associated with the first frame of the Lace.

The `Block Additional Mapping` contains a full binary representation of a 64-bit SMPTE timecode
value stored in big-endian format and expressed exactly as defined in Section 8 and 9
of SMPTE 12M [@!SMPTE.ST12-1], without the 16-bit synchronization word.
For convenience, here are the time address bit assignments as described in [@?RFC5484, section 6.2]:

| Bit Positions | Label                  |
|:-------------:|:-----------------------|
| 0--3          | Units of frames        |
| 8--9          | Tens of frames         |
| 16--19        | Units of seconds       |
| 24--26        | Tens of seconds        |
| 32--35        | Units of minutes       |
| 40--42        | Tens of minutes        |
| 48--51        | Units of hours         |
| 56--57        | Tens of hours          |
Table: SMPTE ST 12-1 Time Address Bit Positions{#ST12Bits}

For example, a timecode value of "07:32:54;18" can be expressed as a 64-bit SMPTE 12M value as:

```
10000000 01100000 01100000 01010000
00100000 00110000 01110000 00000000
```
