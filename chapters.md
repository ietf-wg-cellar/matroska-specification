---
layout: default
---

# Elements semantic

*   Element Name - The full name of the described element.
*   L - Level - The level within an EBML tree that the element may occur at. + is for a recursive level (can be its own child). g: global element (can be found at any level)
*   EBML ID - The Element ID displayed as octets.
*   Ma - Mandatory - This element is mandatory in the file (abbreviated as »mand.«).
*   Mu - Multiple - The element may appear multiple times within its parent element (abbreviated as »mult.«).
*   Rng - Range - Valid range of values to store in the element.
*   Default - The default value of the element.
*   T - Element Type - The form of data the element contains. m: Master, u: unsigned int, i: signed integer, s: string, 8: UTF-8 string, b: binary, f: float, d: date
*   1 - The element is contained in Matroska version 1.
*   2 - The element is contained in Matroska version 2.
*   3 - The element is contained in Matroska version 3.
*   4 - The element is contained in Matroska version 4 (v4 is still work in progress; further additions are possible).
*   W - All elements available for use in WebM.
*   Description - A short description of the element's purpose.

| Element Name | <abbr title="Level">L</abbr> | EBML ID | <abbr title="Mandatory">Ma</abbr> | <abbr title="Multiple">Mu</abbr> | <abbr title="Range">Rng</abbr> | Default | <abbr title="Element Type">T</abbr> | <abbr title="Version 1">1</abbr> | <abbr title="Version 2">2</abbr> | <abbr title="Version 3">3</abbr> | <abbr title="Version 4">4</abbr> | <abbr title="WebM">W</abbr> | Description |
| Chapters |
| Chapters | 1 | [10][43][A7][70] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | A system to define basic menus and partition data. For more detailed information, look at the [Chapters Explanation]({{site.baseurl}}/chapters.html). |
| EditionEntry | 2 | [45][B9] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains all information about a segment edition. |
| EditionUID | 3 | [45][BC] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | A unique ID to identify the edition. It's useful for tagging an edition. |
| EditionFlagHidden | 3 | [45][BD] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If an edition is hidden (1), it should not be available to the user interface (but still to Control Tracks; see [flag notes]({{site.baseurl}}/chapters.html#edition-and-chapter-flags)). (1 bit) |
| EditionFlagDefault | 3 | [45][DB] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If a flag is set (1) the edition should be used as the default one. (1 bit) |
| EditionFlagOrdered | 3 | [45][DD] | - | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify if the chapters can be defined multiple times and the order to play them is enforced. (1 bit) |
| ChapterAtom | 3+ | [B6] | mand. | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains the atom information to use as the chapter atom (apply to all tracks). |
| ChapterUID | 4 | [73][C4] | mand. | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | A unique ID to identify the Chapter. |
| ChapterStringUID | 4 | [56][54] | - | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | A unique string ID to identify the Chapter. Use for [WebVTT cue identifier storage](http://dev.w3.org/html5/webvtt/#webvtt-cue-identifier). |
| ChapterTimeStart | 4 | [91] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | * | Timestamp of the start of Chapter (not scaled). |
| ChapterTimeEnd | 4 | [92] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Timestamp of the end of Chapter (timestamp excluded, not scaled). |
| ChapterFlagHidden | 4 | [98] | mand. | - | 0-1 | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | If a chapter is hidden (1), it should not be available to the user interface (but still to Control Tracks; see [flag notes]({{site.baseurl}}/chapters.html#edition-and-chapter-flags)). (1 bit) |
| ChapterFlagEnabled | 4 | [45][98] | mand. | - | 0-1 | 1 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify wether the chapter is enabled. It can be enabled/disabled by a Control Track. When disabled, the movie should skip all the content between the TimeStart and TimeEnd of this chapter (see [flag notes]({{site.baseurl}}/chapters.html#edition-and-chapter-flags)). (1 bit) |
| ChapterSegmentUID | 4 | [6E][67] | - | - | >0 | - | <abbr title="Binary">b</abbr> | * | * | * | * | A segment to play in place of this chapter. Edition ChapterSegmentEditionUID should be used for this segment, otherwise no edition is used. |
| ChapterSegmentEditionUID | 4 | [6E][BC] | - | - | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | The EditionUID to play from the segment linked in ChapterSegmentUID. |
| ChapterPhysicalEquiv | 4 | [63][C3] | - | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Specify the physical equivalent of this ChapterAtom like "DVD" (60) or "SIDE" (50), see [complete list of values]({{site.baseurl}}/chapters.html#physical-types). |
| ChapterTrack | 4 | [8F] | - | - | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | List of tracks on which the chapter applies. If this element is not present, all tracks apply |
| ChapterTrackNumber | 5 | [89] | mand. | mult. | not 0 | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | UID of the Track to apply this chapter too. In the absense of a control track, choosing this chapter will select the listed Tracks and deselect unlisted tracks. Absense of this element indicates that the Chapter should be applied to any currently used Tracks. |
| ChapterDisplay | 4 | [80] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | * | Contains all possible strings to use for the chapter display. |
| ChapString | 5 | [85] | mand. | - | - | - | <abbr title="UTF-8">8</abbr> | * | * | * | * | * | Contains the string to use as the chapter atom. |
| ChapLanguage | 5 | [43][7C] | mand. | mult. | - | eng | <abbr title="String">s</abbr> | * | * | * | * | * | The languages corresponding to the string, in the [bibliographic ISO-639-2 form](http://www.loc.gov/standards/iso639-2/php/English_list.php). |
| ChapCountry | 5 | [43][7E] | - | mult. | - | - | <abbr title="String">s</abbr> | * | * | * | * | The countries corresponding to the string, same 2 octets as in [Internet domains](http://www.iana.org/cctld/cctld-whois.htm). |
| ChapProcess | 4 | [69][44] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contains all the commands associated to the Atom. |
| ChapProcessCodecID | 5 | [69][55] | mand. | - | - | 0 | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Contains the type of the codec used for the processing. A value of 0 means native Matroska processing (to be defined), a value of 1 means the [DVD]({{site.baseurl}}/chapters.html#dvd-menu-1) command set is used. More codec IDs can be added later. |
| ChapProcessPrivate | 5 | [45][0D] | - | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Some optional data attached to the ChapProcessCodecID information. [For ChapProcessCodecID = 1]({{site.baseurl}}/chapters.html#dvd-menu-1), it is the "DVD level" equivalent. |
| ChapProcessCommand | 5 | [69][11] | - | mult. | - | - | <abbr title="Master Elements">m</abbr> | * | * | * | * | Contains all the commands associated to the Atom. |
| ChapProcessTime | 6 | [69][22] | mand. | - | - | - | <abbr title="Unsigned Integer">u</abbr> | * | * | * | * | Defines when the process command should be handled (0: during the whole chapter, 1: before starting playback, 2: after playback of the chapter). |
| ChapProcessData | 6 | [69][33] | mand. | - | - | - | <abbr title="Binary">b</abbr> | * | * | * | * | Contains the command information. The data should be interpreted depending on the ChapProcessCodecID value. [For ChapProcessCodecID = 1]({{site.baseurl}}/chapters.html#dvd-menu-1), the data correspond to the binary DVD cell pre/post commands. |


## Example 1 : basic chaptering

In this example a movie is split in different chapters. It could also just be an audio file (album) on which each track corresponds to a chapter.

*   00000ms - 05000ms : Intro
*   05000ms - 25000ms : Before the crime
*   25000ms - 27500ms : The crime
*   27500ms - 38000ms : The killer arrested
*   38000ms - 43000ms : Credits

This would translate in the following matroska form :

| Chapters |
 EditionEntry |
 ChapterAtom |
 ChapterUID | 0x123456 |
 ChapterTimeStart | 0 ns |
 ChapterTimeEnd | 5,000,000 ns |
 ChapterDisplay |
 ChapterString | Intro |
 ChapterLanguage | eng |
 ChapterAtom |
 ChapterUID | 0x234567 |
 ChapterTimeStart | 5,000,000 ns |
 ChapterTimeEnd | 25,000,000 ns |
 ChapterDisplay |
 ChapterString | Before the crime |
 ChapterLanguage | eng |
 ChapterDisplay |
 ChapterString | Avant le crime |
 ChapterLanguage | fra |
 ChapterAtom |
 ChapterUID | 0x345678 |
 ChapterTimeStart | 25,000,000 ns |
 ChapterTimeEnd | 27,500,000 ns |
 ChapterDisplay |
 ChapterString | The crime |
 ChapterLanguage | eng |
 ChapterDisplay |
 ChapterString | Le crime |
 ChapterLanguage | fra |
 ChapterAtom |
 ChapterUID | 0x456789 |
 ChapterTimeStart | 27,500,000 ns |
 ChapterTimeEnd | 38,000,000 ns |
 ChapterDisplay |
 ChapterString | After the crime |
 ChapterLanguage | eng |
 ChapterDisplay |
 ChapterString | Après le crime |
 ChapterLanguage | fra |
 ChapterAtom |
 ChapterUID | 0x456789 |
 ChapterTimeStart | 38,000,000 ns |
 ChapterTimeEnd | 43,000,000 ns |
 ChapterDisplay |
 ChapterString | Credits |
 ChapterLanguage | eng |
 ChapterDisplay |
 ChapterString | Générique |
 ChapterLanguage | fra |

## Example 2 : nested chapters

In this example an (existing) album is split into different chapters, and one of them contain another splitting.

### The Micronauts "Bleep To Bleep"

*   00:00 - 12:28 : Baby Wants To Bleep/Rock
    *   00:00 - 04:38 : Baby wants to bleep (pt.1)
    *   04:38 - 07:12 : Baby wants to rock
    *   07:12 - 10:33 : Baby wants to bleep (pt.2)
    *   10:33 - 12:28 : Baby wants to bleep (pt.3)
*   12:30 - 19:38 : Bleeper_O+2
*   19:40 - 22:20 : Baby wants to bleep (pt.4)
*   22:22 - 25:18 : Bleep to bleep
*   25:20 - 33:35 : Baby wants to bleep (k)
*   33:37 - 44:28 : Bleeper

| Chapters |
 EditionEntry |
 ChapterAtom |
 ChapterUID | 0x654321 |
 ChapterTimeStart | 0 ns |
 ChapterTimeEnd | 748,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep/rock |
 ChapterAtom |
 ChapterUID | 0x123456 |
 ChapterTimeStart | 0 ns |
 ChapterTimeEnd | 278,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep (pt.1) |
 ChapterAtom |
 ChapterUID | 0x234567 |
 ChapterTimeStart | 278,000,000 ns |
 ChapterTimeEnd | 432,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to rock |
 ChapterAtom |
 ChapterUID | 0x345678 |
 ChapterTimeStart | 432,000,000 ns |
 ChapterTimeEnd | 633,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep (pt.2) |
 ChapterAtom |
 ChapterUID | 0x456789 |
 ChapterTimeStart | 633,000,000 ns |
 ChapterTimeEnd | 748,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep (pt.3) |
 ChapterAtom |
 ChapterUID | 0x567890 |
 ChapterTimeStart | 750,000,000 ns |
 ChapterTimeEnd | 1,178,500,000 ns |
 ChapterDisplay |
 ChapterString | Bleeper_O+2 |
 ChapterAtom |
 ChapterUID | 0x678901 |
 ChapterTimeStart | 1,180,500,000 ns |
 ChapterTimeEnd | 1,340,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep (pt.4) |
 ChapterAtom |
 ChapterUID | 0x789012 |
 ChapterTimeStart | 1,342,000,000 ns |
 ChapterTimeEnd | 1,518,000,000 ns |
 ChapterDisplay |
 ChapterString | Bleep to bleep |
 ChapterAtom |
 ChapterUID | 0x890123 |
 ChapterTimeStart | 1,520,000,000 ns |
 ChapterTimeEnd | 2,015,000,000 ns |
 ChapterDisplay |
 ChapterString | Baby wants to bleep (k) |
 ChapterAtom |
 ChapterUID | 0x901234 |
 ChapterTimeStart | 2,017,000,000 ns |
 ChapterTimeEnd | 2,668,000,000 ns |
 ChapterDisplay |
 ChapterString | Bleeper |

## Edition and chapter flags

### Chapter flags

There are two important flags that apply to chapter atoms: _enabled_ and _hidden_. The effect of those flags always applies to child atoms of an atom affected by that flag.

For example: Let's assume a parent atom with flag _hidden_ set to _true_; that parent contains two child atom, the first with _hidden_ set to _true_ as well and the second child with the flag either set to _false_ or not present at all (in which case the default value applies, and that again is _false_).

As the parent is hidden all of its children are initially hidden as well. However, when a control track toggles the parent's _hidden_ flag to _false_ then only the the parent and its second child will be visible. The first child's explicitely set flag retains its value until its value is toggled to _false_ by a control track.

Corresponding behavior applies to the _enabled_ flag.

### Edition flags

The edition's _hidden_ flag behaves much the same as the chapter's _hidden_ flag: if an edition is hidden then none of its children shall be visible, no matter their own _hidden_ flags. If the edition is toggled to being visible then the chapter atom's _hidden_ flags decide whether or not the chapter is visible.

## Menu features

The menu features are handled like a _chapter codec_. That means each codec has a type, some private data and some data in the chapters.

The type of the menu system is defined by the ChapProcessCodecID parameter. For now only 2 values are supported : 0 matroska script, 1 menu borrowed from the DVD. The private data depend on the type of menu system (stored in ChapProcessPrivate), idem for the data in the chapters (stored in ChapProcessData).

### Matroska Script (0)

This is the case when [ChapProcessCodecID]({{site.baseurl}}/index.html#ChapProcessCodecID) = 0\. This is a script language build for Matroska purposes. The inspiration comes from ActionScript, javascript and other similar scripting languages. The commands are stored as text commands, in UTF-8\. The syntax is C like, with commands spanned on many lines, each terminating with a ";". You can also include comments at the end of lines with "//" or comment many lines using "/* */". The scripts are stored in ChapProcessData. For the moment ChapProcessPrivate is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the same suggests, it means that when this command is encountered, the playback should jump to the Chapter specified by the UID and play it.

### DVD menu (1)

This is the case when [ChapProcessCodecID]({{site.baseurl}}/index.html#ChapProcessCodecID) = 1\. Each level of a chapter corresponds to a logical level in the DVD system that is stored in the first octet of the ChapProcessPrivate. This DVD hierarchy is as follows:


| ChapProcessPrivate | DVD Name | Hierarchy | Commands Possible | Comment |
| 0x30 | SS | DVD domain | - | First Play, Video Manager, Video Title |
| 0x2A | LU | Language Unit | - | Contains only PGCs |
| 0x28 | TT | Title | - | Contains only PGCs |
| 0x20 | PGC | Program Group Chain (PGC) | * |
| 0x18 | PG | Program 1 | Program 2 | Program 3 | - |
| 0x10 | PTT | Part Of Title 1 | Part Of Title 2 | - | Equivalent to the chapters on the sleeve. |
| 0x08 | CN | Cell 1 | Cell 2 | Cell 3 | Cell 4 | Cell 5 | Cell 6 | - |


You can also recover wether a Segment is a Video Manager (VMG), Video Title Set (VTS) or Video Title Set Menu (VTSM) from the [ChapterTranslateID]({{site.baseurl}}/index.html#ChapterTranslateID) element found in the Segment Info. This field uses 2 octets as follows:

1.  Domain Type: 0 for VMG, the domain number for VTS and VTSM
2.  Domain Value: 0 for VMG and VTSM, 1 for the VTS source.

For instance, the menu part from VTS_01_0.VOB would be coded [1,0] and the content part from VTS_02_3.VOB would be [2,1]. The VMG is always [0,0]

The following octets of ChapProcessPrivate are as follows:


| Octet 1 | DVD Name | Following Octets |
| 0x30 | SS | Domain name code (1: 0x00= First play, 0xC0= VMG, 0x40= VTSM, 0x80= VTS) + VTS(M) number (2) |
| 0x2A | LU | Language code (2) + Language extension (1) |
| 0x28 | TT | global Title number (2) + corresponding TTN of the VTS (1) |
| 0x20 | PGC | PGC number (2) + Playback Type (1) + Disabled User Operations (4) |
| 0x18 | PG | Program number (2) |
| 0x10 | PTT | PTT-chapter number (1) |
| 0x08 | CN | Cell number [VOB ID(2)][Cell ID(1)][Angle Num(1)] |


If the level specified in ChapProcessPrivate is a PGC (0x20), there is an octet called the Playback Type, specifying the kind of PGC defined:

*   0x00: entry only/basic PGC
*   0x82: Title+Entry Menu (only found in the Video Manager domain)
*   0x83: Root Menu (only found in the VTSM domain)
*   0x84: Subpicture Menu (only found in the VTSM domain)
*   0x85: Audio Menu (only found in the VTSM domain)
*   0x86: Angle Menu (only found in the VTSM domain)
*   0x87: Chapter Menu (only found in the VTSM domain)

The next 4 following octets correspond to the [User Operation flags](http://dvd.sourceforge.net/dvdinfo/uops.html) in the standard PGC. When a bit is set, the command should be disabled.

ChapProcessData contains the pre/post/cell commands in binary format as there are stored on a DVD. There is just an octet preceeding these data to specify the number of commands in the element. As follows: [# of commands(1)][command 1 (8)][command 2 (8)][command 3 (8)].

More information on the DVD commands and format on [DVD-replica](http://www.dvd-replica.com/DVD/), where we got most of the info about it. You can also get information on DVD from [the DVDinfo project](http://dvd.sourceforge.net/dvdinfo/).