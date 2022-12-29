# Matroska Chapter Codecs

Chapter codecs are a way to add more complex playback features than the usual linear playback.

Some `ChapProcess` elements hold commands to execute when entering/leaving a chapter.

When chapter codecs are used the `EditionFlagOrdered` of the edition they belong to **MUST** be set.

## Segment Linking

Chapter Codecs can reference another `Segment` and jump to that `Segment`.

The Chapter Codecs **MAY** store the Segment information in their own format, possibly not using the `SegmentUUID` format.
The `ChapterTranslate` element and its child elements **SHOULD** be used
to link the internal chapter codec representation, the chapter codec number and the actual Segment it represents.

For example if a chapter codec of type "1" in SegmentA needs to link to SegmentB,
it can store that information as "SegB" in its internal data.

The translation `ChapterTranslate` in SegmentB would use the following elements:
* `ChapterTranslate\ChapterTranslateCodec` = 1
* `ChapterTranslate\ChapterTranslateID` = "SegB"

The `Matroska Player` **MUST** use the `SegmentFamily` to find all Segments that need translation
between the chapter codec values and the actual segment it targets.

# Matroska Chapter Codecs and Nested Chapters

When `Nested Chapters` contain chapters codecs -- via the `ChapProcess` Element --
the enter/leave commands -- ChapProcessTime Element -- **MUST** be executed in a specific order,
if the Matroska Player supports the chapter codecs included in the chapters.

When starting playback, the `Matroska Player` **MUST** start at the `ChapterTimeStart` of the first chapter of the ordered chapter.
The enter commands of that chapter **MUST** be executed.
If that chapter contains `Nested Chapters`, the enter commands of the `Nested Chapter` with the same `ChapterTimeStart` **MUST** be executed.
If that chapter contains `Nested Chapters`, the enter commands of the `Nested Chapter` with the same `ChapterTimeStart` **MUST** be executed,
and so on until there is no `Nested Chapter` with the same `ChapterTimeStart`.

When switching from a chapter to another:

* the leave commands (`ChapProcessTime`=2) of the
chapter **MUST** be executed, then the leave commands of its parent chapter, etc. until the
common `Parent Chapter` or `Edition` element. The leave command of that `Parent Chapter` or `Edition` element
**MUST NOT** be executed.
* the enter commands (`ChapProcessTime`=1) of the `Nested Chapter` of the common `Parent Chapter` or `Edition` element,
to reach the chapter we switch to, **MUST** be executed, then the enter commands of its `Nested Chapter`
to reach the chapter we switch to **MUST** be executed, until that chapter is the chapter we switch to.
The enter commands of that chapter **MUST** be executed as well.

When the last Chapter finished playing -- i.e. its `ChapterTimeEnd` has been reached --
the `Matroska Player` **MUST** execute its leaved commands, then the leave commands of it's `Parent Chapter`,
until the parent of the chapter is the Edition.


## Matroska Script (0)

This is the case when `ChapProcessCodecID` = 0\. This is a script language build for
Matroska purposes. The inspiration comes from ActionScript, javascript and other similar
scripting languages. The commands are stored as text commands, in UTF-8\. The syntax is C like,
with commands spanned on many lines, each terminating with a ";". You can also include comments
at the end of lines with "//" or comment many lines using "/* \*/". The scripts are stored
in ChapProcessData. For the moment ChapProcessPrivate is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the
same suggests, it means that, when this command is encountered, the `Matroska Player`
**SHOULD** jump to the `Chapter` specified by the UID and play it.

## DVD menu (1)

This is the case when `ChapProcessCodecID` = 1\. Each level of a chapter corresponds
to a logical level in the DVD system [@?DVD-Video] that is stored in the first octet of the ChapProcessPrivate.
This DVD hierarchy is as follows:

| ChapProcessPrivate | DVD Name | Hierarchy                                           | Commands Possible | Comment                                   |
|--------------------|----------|-----------------------------------------------------|-------------------|-------------------------------------------|
| 0x30               | SS       | DVD domain                                          | -                 | First Play, Video Manager, Video Title    |
| 0x2A               | LU       | Language Unit                                       | -                 | Contains only PGCs                        |
| 0x28               | TT       | Title                                               | -                 | Contains only PGCs                        |
| 0x20               | PGC      | Program Group Chain (PGC)                           | *                 |                                           |
| 0x18               | PG       | Program 1 / Program 2 / Program 3                   | -                 |                                           |
| 0x10               | PTT      | Part Of Title 1 / Part Of Title 2                   | -                 | Equivalent to the chapters on the sleeve. |
| 0x08               | CN       | Cell 1 / Cell 2 / Cell 3 / Cell 4 / Cell 5 / Cell 6 | -                 |                                           |

You can also recover wether a Segment is a Video Manager (VMG), Video Title Set (VTS)
or Video Title Set Menu (VTSM) from the ChapterTranslateID element found in the Segment Info.
This field uses 2 octets as follows:

1.  Domain Type: 0 for VMG, the domain number for VTS and VTSM
2.  Domain Value: 0 for VMG and VTSM, 1 for the VTS source.

For instance, the menu part from VTS_01_0.VOB would be coded [1,0] and the content
part from VTS_02_3.VOB would be [2,1]. The VMG is always [0,0]

The following octets of ChapProcessPrivate are as follows:

| Octet 1 | DVD Name | Following Octets                                                                             |
|---------|----------|----------------------------------------------------------------------------------------------|
| 0x30    | SS       | Domain name code (1: 0x00= First play, 0xC0= VMG, 0x40= VTSM, 0x80= VTS) + VTS(M) number (2) |
| 0x2A    | LU       | Language code (2) + Language extension (1)                                                   |
| 0x28    | TT       | global Title number (2) + corresponding TTN of the VTS (1)                                   |
| 0x20    | PGC      | PGC number (2) + Playback Type (1) + Disabled User Operations (4)                            |
| 0x18    | PG       | Program number (2)                                                                           |
| 0x10    | PTT      | PTT-chapter number (1)                                                                       |
| 0x08    | CN       | Cell number [VOB ID(2)][Cell ID(1)][Angle Num(1)]                                            |

If the level specified in ChapProcessPrivate is a PGC (0x20), there is an octet
called the Playback Type, specifying the kind of PGC defined:

*   0x00: entry only/basic PGC
*   0x82: Title+Entry Menu (only found in the Video Manager domain)
*   0x83: Root Menu (only found in the VTSM domain)
*   0x84: Subpicture Menu (only found in the VTSM domain)
*   0x85: Audio Menu (only found in the VTSM domain)
*   0x86: Angle Menu (only found in the VTSM domain)
*   0x87: Chapter Menu (only found in the VTSM domain)

The next 4 following octets correspond to the `User Operation flags`
in the standard PGC. When a bit is set, the command **SHOULD** be disabled.

ChapProcessData contains the pre/post/cell commands in binary format as there are stored on a DVD.
There is just an octet preceding these data to specify the number of commands in the element.
As follows: [# of commands(1)][command 1 (8)][command 2 (8)][command 3 (8)].

More information on the DVD commands and format on DVD
from the [@?DVD-Info] project.

