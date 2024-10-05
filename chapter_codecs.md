# Matroska Chapter Codecs

Chapter codecs are a way to add more complex playback features than the usual linear playback.

Some `ChapProcess` elements hold commands to execute when entering/leaving a chapter.

When chapter codecs are used the `EditionFlagOrdered` of the edition they belong to **MUST** be set.

Each `ChapProcessCodecID` value in an edition **SHOULD** have a single interpreter for the whole `EditionEntry`,
if that `ChapProcessCodecID` value is supported by the `Matroska Player`.
This is necessary to be able to read/write global variables that can be used between chapters.

## Segment Linking

Chapter Codecs can reference another `Segment` and jump to that `Segment`.

The Chapter Codecs **MAY** store the Segment information in their own format, possibly not using the `SegmentUUID` format.
The `ChapterTranslate` element and its child elements **SHOULD** be used
to link the internal chapter codec representation, the chapter codec number and the actual Segment it represents.

For example, if a chapter codec of type "1" in SegmentA needs to link to SegmentB,
it can store that information as "SegB" in its internal data.

The translation `ChapterTranslate` in SegmentB would use the following elements:

* `ChapterTranslate\ChapterTranslateCodec` = 1

* `ChapterTranslate\ChapterTranslateID` = "SegB"

The `Matroska Player` **MUST** use the `SegmentFamily` to find all Segments that need translation
between the chapter codec values and the actual segment it targets.

# Matroska Chapter Codecs and Nested Chapters

When `Nested Chapters` contain chapters codecs -- via the `ChapProcess` element --
the enter/leave commands -- `ChapProcessTime` element -- **MUST** be executed in a specific order,
if the Matroska Player supports the chapter codecs included in the chapters.

When starting playback, the `Matroska Player` **MUST** start at the `ChapterTimeStart` of the first chapter of the ordered chapter.
The enter commands of that chapter **MUST** be executed.
If that chapter contains `Nested Chapters`, the enter commands of the `Nested Chapter` with the same `ChapterTimeStart` **MUST** be executed.
If that chapter contains `Nested Chapters`, the enter commands of the `Nested Chapter` with the same `ChapterTimeStart` **MUST** be executed,
and so on until there is no `Nested Chapter` with the same `ChapterTimeStart`.

When switching from a chapter to another:

* the leave commands (`ChapProcessTime`=2) of the
chapter **MUST** be executed, then the leave commands of its parent chapter, etc., until the
common `Parent Chapter` or `Edition` element. The leave command of that `Parent Chapter` or `Edition` element
**MUST NOT** be executed.

* the enter commands (`ChapProcessTime`=1) of the `Nested Chapter` of the common `Parent Chapter` or `Edition` element,
to reach the chapter we switch to, **MUST** be executed, then the enter commands of its `Nested Chapter`
to reach the chapter we switch to **MUST** be executed, until that chapter is the chapter we switch to.
The enter commands of that chapter **MUST** be executed as well.

When the last Chapter finished playing, i.e., its `ChapterTimeEnd` has been reached,
the `Matroska Player` **MUST** execute its leaved commands, then the leave commands of it's `Parent Chapter`,
until the parent of the chapter is the Edition.


## Matroska Script

This is the case when `ChapProcessCodecID` = 0. This is a script language build for
Matroska purposes. The inspiration comes from [@?ActionScript], [@?ECMAScript] and other similar
scripting languages. The commands are stored as text commands, in UTF-8. The syntax is C like,
with commands spanned on many lines, each terminating with a semicolon ";". You can also include comments
at the end of lines with "//" or comment many lines using "/* \*/". The scripts are stored
in `ChapProcessData`. For the moment `ChapProcessPrivate` is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the
same suggests, it means that, when this command is encountered, the `Matroska Player`
**SHOULD** jump to the `Chapter` specified by the UID and play it, as long as this `Chapter` exists.

## MatroskaJS

This is the case when `ChapProcessCodecID` = 2. This is a script language build for
Matroska purposes. It uses the [@!ECMAScript] 6th Edition (ES6) syntax. The commands are stored as text commands, in UTF-8.
The syntax is C like, with commands spanned on many lines, each terminating with a semicolon ";". You can also include comments
at the end of lines with "//" or comment many lines using "/* \*/". The scripts are stored
in `ChapProcessData`. For the moment `ChapProcessPrivate` is not used.

The Matroska Script contains the following commands.

### GotoAndPlay

The command is called with `GotoAndPlay( "<ChapterUID>" );`.

As the same suggests, it means that, when this command is encountered, the `Matroska Player`
**SHOULD** jump to the `Chapter` specified by the `ChapterUID` string and play it, as long as this `Chapter` exists.

### LogMsg

The command is called with `LogMsg( "A String" );`.

The `Matroska Player` **SHOULD** send the provided message to the user debugging console, if there is one.
In this example it would send "A String", without the double quotes, to the debugging console.

### AddChoice

The command is called with `AddChoice( "<ChoiceUID>", group = Null );`.

The `Matroska Player` **MUST** keep the choice with the given UID in memory until the Chapter it belongs to
has ended. The string may be any length and should be a valid ECMAScript string literal.

If a group string is supplied, the choice **MUST** only be evaluated within the group of the given string.
Otherwise the choice **MUST** be evaluated with the other choices with no group, called the Default Group.

It is possible to add a single choice for a group to let the user select it or not, for example with a checkbox.

### SetChoiceText

The command is called with `SetChoiceText( "<ChoiceUID>", "Some text", "<lang>" );`.

Set the string to use for the choice with the given UID if the given language is selected.
The language string is the same form defined in [@!RFC5646] as for the `ChapLanguageBCP47` element.

When the `Matroska Player` collects the strings to use for all available choices, the same language
rules apply as of [@!Matroska, section 19] for track selection. In addition if a string is missing for a language
the whole language is considered to be not available, unless there is no other language option available.

<!-- TODO: allow attaching a choice to a tag, we will need a special tag target for that -->

### SetChoiceDefault

The command is called with `SetChoiceDefault( "<ChoiceUID>", group = Null );`.

Tell the `Matroska Player` that the choice with the given UID is the default one to use.
If this function is not called, no choice is considered the default one.

If a group string is supplied, the default state only applies within the group of the given string.
Otherwise the default state only applies among the choices of the Default Group.

### CommitChoices

The command is called with `CommitChoices( );`.

Tell the `Matroska Player` that all previously added choices with AddChoice ((#addchoice)) should be used.
This **SHOULD** generate some visually visible choice, with the default choice selected, if there is one.

### GetChoice

The command is called with `GetChoice( group = Null );`.

The function returns the UID string corresponding to the choice selected by the user.
If the user did not make a selection and there is no default one, this function returns the ECMAScript `Undefined`.

If a group string is supplied, the selected UID string returned is the selection within the choices of the given group string.
Otherwise selected UID string returned is the selection within the choices of the Default Group.



## DVD Menu

This is the case when `ChapProcessCodecID` = 1. Each level of a chapter corresponds
to a logical level in the DVD system [@?DVD-Video] that is stored in the first octet of the `ChapProcessPrivate`.
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

The following octets of `ChapProcessPrivate` are as follows:

| Octet 1 | DVD Name | Following Octets                                                                             |
|---------|----------|----------------------------------------------------------------------------------------------|
| 0x30    | SS       | Domain name code (1: 0x00= First play, 0xC0= VMG, 0x40= VTSM, 0x80= VTS) + VTS(M) number (2) |
| 0x2A    | LU       | Language code (2) + Language extension (1)                                                   |
| 0x28    | TT       | global Title number (2) + corresponding TTN of the VTS (1)                                   |
| 0x20    | PGC      | PGC number (2) + Playback Type (1) + Disabled User Operations (4)                            |
| 0x18    | PG       | Program number (2)                                                                           |
| 0x10    | PTT      | PTT-chapter number (1)                                                                       |
| 0x08    | CN       | Cell number [VOB ID(2)][Cell ID(1)][Angle Num(1)]                                            |

If the level specified in `ChapProcessPrivate` is a PGC (0x20), there is an octet
called the Playback Type, specifying the kind of PGC defined:

*   `0x00`: entry only/basic PGC

*   `0x82`: Title+Entry Menu (only found in the Video Manager domain)

*   `0x83`: Root Menu (only found in the VTSM domain)

*   `0x84`: Subpicture Menu (only found in the VTSM domain)

*   `0x85`: Audio Menu (only found in the VTSM domain)

*   `0x86`: Angle Menu (only found in the VTSM domain)

*   `0x87`: Chapter Menu (only found in the VTSM domain)

The next 4 following octets correspond to the `User Operation flags`
in the standard PGC. When a bit is set, the command **SHOULD** be disabled.

`ChapProcessData` contains the pre/post/cell commands in binary format as there are stored on a DVD.
There is just an octet preceding these data to specify the number of commands in the element.
As follows: [# of commands(1)][command 1 (8)][command 2 (8)][command 3 (8)].

More information on the DVD commands and format on DVD
from the [@?DVD-Info] project and [@?Inside-DVD-Video].

