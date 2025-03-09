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

For example, a timecode value of "07:12:26;18" can be expressed as a 64-bit SMPTE 12M value as:

```
10000000 01100000 01100000 01010000
00100000 00110000 01110000 00000000
```

Or with the irrelevant bits marked with an "x" which gives 26 usable bits:

```
1000xxxx 01xxxxxx 0110xxxx 010xxxxx
0010xxxx 001xxxxx 0111xxxx 00xxxxxx
```

This is interpreted in hexadecimal:

- 0x8 units of frames
- 0x1 tens of frames
- 0x6 units of seconds
- 0x2 tens of seconds
- 0x2 units of minutes
- 0x1 tens of minutes
- 0x7 units of hours
- 0x0 tens of hours

Given no value is above 9, the BCD coding correspond to the actual values:

- 8 units of frames
- 1 tens of frames
- 6 units of seconds
- 2 tens of seconds
- 2 units of minutes
- 1 tens of minutes
- 7 units of hours
- 0 tens of hours

Or:

- 18 frames
- 26 seconds
- 12 minutes
- 07 hours

