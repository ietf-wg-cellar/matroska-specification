## SMPTE ST 12-1 Timecode Description

SMPTE ST 12-1 timecode values can be stored in the `BlockMore` element to associate
the content of a Matroska Block with a particular timecode value.
If the Block uses Lacing, the timecode value is associated with the first frame of the Lace.

The `Block Additional Mapping` contains a full binary representation of a 64-bit SMPTE timecode
value expressed exactly as defined in Section 8 and 9
of SMPTE 12M [@!SMPTE.ST12-1], without the 16-bit synchronization word.
This value is stored as a 64-bit unsigned integer in big-endian byte order.
The bits of this integer, from the least significant bit to the most significant bit,
are bits 0 to 63 of the Linear Time Code (LTC) codeword.
The first byte thus contains bits 63 to 56 and the last byte contains bits 7 to 0.
In each byte, the lowest numbered bit is the least significant bit.
The bit numbering used in this section is that of the LTC codeword in [@!SMPTE.ST12-1],
in which the lowest numbered bit of each binary-coded decimal (BCD) digit is its least significant bit,
and not that of [@!RFC9559, section 10.1], in which bit 0 is the most significant bit.
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

For example, a timecode value of "07:12:26;18", where the ";" denotes that the drop frame flag
is set to 1 (bit 10 in 30-frame systems, 0x04 in the seventh byte), is stored as the bytes
0x00 0x07 0x01 0x02 0x02 0x06 0x05 0x08 when the other bits outside the time address are set to 0.
In binary, from the first byte to the last byte, each byte with its most significant bit first:

```
00000000 00000111 00000001 00000010
00000010 00000110 00000101 00001000
```

Or with the bits outside the time address marked with an "x",
which leaves the 26 bits of the time address:

```
xxxxxx00 xxxx0111 xxxxx001 xxxx0010
xxxxx010 xxxx0110 xxxxxx01 xxxx1000
```

This is interpreted in hexadecimal, from the first byte to the last byte:

- 0x0 tens of hours
- 0x7 units of hours
- 0x1 tens of minutes
- 0x2 units of minutes
- 0x2 tens of seconds
- 0x6 units of seconds
- 0x1 tens of frames
- 0x8 units of frames

Given no value is above 9, the BCD coding correspond to the actual values:

- 0 tens of hours
- 7 units of hours
- 1 tens of minutes
- 2 units of minutes
- 2 tens of seconds
- 6 units of seconds
- 1 tens of frames
- 8 units of frames

Or:

- 07 hours
- 12 minutes
- 26 seconds
- 18 frames

