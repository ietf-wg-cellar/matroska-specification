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

### Signaling the source of the timecode

Source of the timecode SHOULD be signaled by the `TITLE` tag, with `TagLanguage` element set to `und`, associated to the Block Additional (using `TagTrackUID` and `TagBlockAddIDValue`).

The following vocabulary is RECOMMENDED for known sources:

- "9PIN" for data in the Sony 9-Pin RS-422 interface [@!Sony.9PIN], exact source unknown
- "9PIN_TIMER1" for timer-1 data in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_TIMER2" for timer-2 data in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_LTC" for Linear Time Code in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_VITC" for Vertical Interval Time Code in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_VITCUSER" for Vertical Interval Time Code user bits in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_GENTIME" for time code generator in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "9PIN_GENUSER" for time code generator user bits in the Sony 9-Pin RS-422 interface [@!Sony.9PIN]
- "ATC_LTC" for a Linear Time Code as defined in SMPTE ST 12-2 [@!SMPTE.ST12-2] (formerly SMPTE RP 188)
- "ATC_VITC" for a Vertical Interval Time Code, progressive frame or first field of an interlaced content, as defined in SMPTE ST 12-2 [@!SMPTE.ST12-2] (formerly SMPTE RP 188)
- "ATC_VITC2" for a Vertical Interval Time Code, second field of an interlaced content, as defined in SMPTE ST 12-2 [@!SMPTE.ST12-2] (formerly SMPTE RP 188)
- "BITC" for a burnt-in timecode i.e. originally burnt into the video image so that humans can easily read the time code
- "CTL" for a timecode originally embedded in the control track of a videotape, as found in JVC CTL [@!JVC.CTL]
- "DAT_ABSOLUTE" for a timecode originally embedded in the metadata of a content which indicates the time code from the beginning of a tape, as found in Sony DAT [@!Sony.DAT]
- "DAT_PROGRAM" for a timecode originally embedded in the metadata of a content which indicates the time code from the beginning of a program, as found in Sony DAT [@!Sony.DAT]
- "DAT_RUNNING" for a timecode originally embedded in the metadata of a content which indicates the time code from an unspecified start, as found in Sony DAT [@!Sony.DAT]
- "LTC" for a Linear Time Code as defined in SMPTE ST 12-1 [@!SMPTE.ST12-1]
- "SDTI" for a time code originally embedded in a Serial Data Transport Interface, as defined in SMPTE ST 305 [@!SMPTE.ST305]
- "SYSTEMSCHEME1" for a time code originally embedded in a System Scheme 1 application, as defined in SMPTE ST 405 [@!SMPTE.ST405]
- "VITC" for a Vertical Interval Time Code, as defined in SMPTE ST 12-1 [@!SMPTE.ST12-1], progressive frame or first field of an interlaced content
- "VITC2" for a Vertical Interval Time Code, as defined in SMPTE ST 12-1 [@!SMPTE.ST12-1], second field of an interlaced content

Space character SHOULD NOT be used for the vocabulary of the source of time code.

A Space character and any character after it SHOULD be considered as not part of the vocabulary of the source of the timecode.
