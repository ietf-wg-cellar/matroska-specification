## SMPTE ST 12-1 Timecode

### Timecode Description

SMPTE ST 12-1 timecode values can be stored in the `BlockMore Element` to associate
the content of a Matroska Block with a particular timecode value.
If the Block uses Lacing, the timecode value is associated with the first frame of the Lace.

The Block Additional Mapping contains a full binary representation of a 64 bit SMPTE timecode
value stored in big-endian format and expressed exactly as defined in Section 8 and 9
of SMPTE 12M [@!ST12]. For convenience, here are the bit assignments for a
SMPTE ST 12-1 binary representation as described in [@?RFC5484, section 6.2]:

| Bit Positions | Label                  |
|:-------------:|:-----------------------|
| 0--3          | Units of frames        |
| 4--7          | First binary group     |
| 8--9          | Tens of frames         |
| 10            | Drop frame flag        |
| 11            | Color frame flag       |
| 12--15        | Second binary group    |
| 16--19        | Units of seconds       |
| 20--23        | Third binary group     |
| 24--26        | Tens of seconds        |
| 27            | Polarity correction    |
| 28--31        | Fourth binary group    |
| 32--35        | Units of minutes       |
| 36--39        | Fifth binary group     |
| 40--42        | Tens of minutes        |
| 43            | Binary group flag BGF0 |
| 44--47        | Sixth binary group     |
| 48--51        | Units of hours         |
| 52--55        | Seventh binary group   |
| 56--57        | Tens of hours          |
| 58            | Binary group flag BGF1 |
| 59            | Binary group flag BGF2 |
| 60--63        | Eighth binary group    |

For example, a timecode value of "07:32:54;18" can be expressed as a 64 bit SMPTE 12M value as:

```
10000000 01100000 01100000 01010000
00100000 00110000 01110000 00000000
```

### BlockAddIDType

The BlockAddIDType value reserved for timecode is "121".

### BlockAddIDName

The BlockAddIDName value reserved for timecode is "SMPTE ST 12-1 timecode".

### BlockAddIDExtraData

BlockAddIDExtraData is a sequence of EBML elements.

#### Start Timecode

id / type:
    0x???? / binary

path:
    \\

maxOccurs:
    1

definition:
    If present, indicates that Block Additional Mapping is not present and that the stored bytes represent the start timcode.
    Other timecodes are computed from start timecode value converted to a count of frames
    + round(timestamp of the associated block / Frame Rate Denominator \* Frame Rate Numerator),
    converted back to a timecode value.  
    Division and multiplication are done based on float numbers. Rounding is needed because Matroska timestamps are not necessarily based on the timecode frame rate.

stream copy: True

#### Frame Rate Numerator

id / type / default:
    0x???? / uinteger / 30000

range:
    > 0

path:
    \\

minOccurs / maxOccurs:
    1

definition:
    Numerator of the count of frames per second of the corresponding stream. Not relevant and ignored if Start Timecode is not present.

stream copy: True 

#### Frame Rate Denominator

id / type / default:
    0x???? / uinteger / 1001

range:
    > 0

path:
    \\

minOccurs / maxOccurs:
    1

definition:
    Denominator of the count of frames per second of the corresponding stream. Not relevant and ignored if Start Timecode is not present.

stream copy: True 
