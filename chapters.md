---
title: Chapters
---

# Chapters

## Edition and Chapter Flags

### Chapter Flags

Two `Chapter Flags` are defined to describe the behavior of the `ChapterAtom Element`: `ChapterFlagHidden` and `ChapterFlagEnabled`.

If a `ChapterAtom Element` is the `Child Element` of another `ChapterAtom Element` with a `Chapter Flag` set to `true`, then the `Child ChapterAtom Element` MUST be interpreted as having its same `Chapter Flag` set to `true`. If a `ChapterAtom Element` is the `Child Element` of another `ChapterAtom Element` with a `Chapter Flag` set to `false` or if the `ChapterAtom Element` does not have a `ChapterAtom Element` as its `Parent Element`, then it MUST be interpreted according to its own `Chapter Flag`.

As an example, consider a `Parent ChapterAtom Element` that has its `ChapterFlagHidden` set to `true` and also contains two child `ChapterAtoms`, the first with `ChapterFlagHidden` set to `true` and the second with `ChapterFlagHidden` either set to `false` or not present at all (in which case the default value of the Element applies, which is `false`). Since the parent `ChapterAtom` has its `ChapterFlagHidden` set to `true` then all of its children `ChapterAtoms` MUST also be interpreted as if their `ChapterFlagHidden` is also set to `true`. However, if a `Control Track` toggles the parent's `ChapterFlagHidden` flag to `false`, then only the parent `ChapterAtom` and its second child `ChapterAtom` MUST be interpreted as if `ChapterFlagHidden` is set to `false`. The first child `ChapterAtom` which has the `ChapterFlagHidden` flag set to `true` retains its value until its value is toggled to `false` by a `Control Track`.

### Edition Flags

Three `Edition Flags` are defined to describe the behavior of the `EditionEntry Element`: `EditionFlagHidden`, `EditionFlagDefault` and `EditionFlagOrdered`.


#### EditionFlagHidden

The `EditionFlagHidden Flag` behaves similarly to the `ChapterFlagHidden Flag`: if `EditionFlagHidden` is set to `true`, its `Child ChapterAtoms Elements` MUST also be interpreted as if their `ChapterFlagHidden` is also set to `true`, regardless of their own `ChapterFlagHidden Flags`. If `EditionFlagHidden` is toggled by a `Control Track` to `false`, the `ChapterFlagHidden Flags` of the `Child ChapterAtoms Elements` SHALL determine whether the `ChapterAtom` is hidden or not.


#### EditionFlagDefault

It is RECOMMENDED that no more than one `Edition` have an `EditionFlagDefault Flag` set to `true`. The first `Edition` with both the `EditionFlagDefault Flag` set to `true` and the `EditionFlagHidden Flag` set to `false` is the Default Edition. When all `EditionFlagDefault Flags` are set to `false`, then the first `Edition` with the `EditionFlagHidden Flag` set to `false` is the Default Edition. The Default Edition is the edition that should be used for playback by default.

#### EditionFlagOrdered

The `EditionFlagOrdered Flag` is a significant feature as it enables an `Edition` of `Ordered Chapters` which defines and arranges a virtual timeline rather than simply labeling points within the timeline. For example, with `Editions` of `Ordered Chapters` a single `Matroska file` can present multiple edits of a film without duplicating content. Alternatively if a videotape is digitized in full, one `Ordered Edition` could present the full content (including colorbars, countdown, slate, a feature presentation, and black frames), while another `Edition` of `Ordered Chapters` can use `Chapters` that only mark the intended presentation with the colorbars and other ancillary visual information excluded. If an `Edition` of `Ordered Chapters` is enabled then the `Matroska Player` MUST play those Chapters in their stored order from the timestamp marked in the `ChapterTimeStart Element` to the timestamp marked in to `ChapterTimeEnd Element`.

If the `EditionFlagOrdered Flag` is set to `false`, `Simple Chapters` are used and only the `ChapterTimeStart` of a `Chapter` is used as chapter mark to jump to the predefined point in the timeline. With `Simple Chapters`, a `Matroska Player` MUST ignore certain `Chapter Elements`. All these elements are now informational only.

The following list shows the different usage of `Chapter Elements` between an ordered and non-ordered `Edition`.

| Chapter elements / ordered Edition | False | True |
|:-----------------------------------|:-----:|:----:|
| ChapterUID                         |   X   |  X   |
| ChapterStringUID                   |   X   |  X   |
| ChapterTimeStart                   |   X   |  X   |
| ChapterTimeEnd                     |   -   |  X   |
| ChapterFlagHidden                  |   X   |  X   |
| ChapterFlagEnabled                 |   X   |  X   |
| ChapterSegmentUID                  |   -   |  X   |
| ChapterSegmentEditionUID           |   -   |  X   |
| ChapterPhysicalEquiv               |   X   |  X   |
| ChapterTrack                       |   -   |  X   |
| ChapterDisplay                     |   X   |  X   |
| ChapProcess                        |   -   |  X   |

Furthermore there are other EBML `Elements` which could be used if the `EditionFlagOrdered Flag` is set to `true`.

| Other elements / ordered Edition   | False | True |
|:-----------------------------------|:-----:|:----:|
| Info/SegmentFamily                 |   -   |  X   |
| Info/ChapterTranslate              |   -   |  X   |
| Track/TrackTranslate               |   -   |  X   |

These other `Elements` belong to the Matroska DVD menu system and are only used when the `ChapProcessCodecID Element` is set to 1.

##### Ordered-Edition and Matroska Segment-Linking

- Hard Linking: `Ordered-Chapters` supersedes the `Hard Linking`.
- Soft Linking: In this complex system `Ordered Chapters` are REQUIRED and a `Chapter CODEC` MUST interpret the `ChapProcess` of all chapters.
- Medium Linking: `Ordered Chapters` are used in a normal way and can be combined with the `ChapterSegmentUID` element which establishes a link to another Matroska file/Segment.

See [the section on the Linked Segments](#linked-segments)) for more information about `Hard Linking`, `Soft Linking` and `Medium Linking`.

## Menu features

The menu features are handled like a _chapter codec_. That means each codec has a type, some private data and some data in the chapters.

The type of the menu system is defined by the `ChapProcessCodecID` parameter. For now only 2 values are supported : 0 matroska script, 1 menu borrowed from the DVD. The private data depend on the type of menu system (stored in ChapProcessPrivate), idem for the data in the chapters (stored in ChapProcessData).

### Matroska Script (0)

This is the case when `ChapProcessCodecID` = 0\. This is a script language build for Matroska purposes. The inspiration comes from ActionScript, javascript and other similar scripting languages. The commands are stored as text commands, in UTF-8\. The syntax is C like, with commands spanned on many lines, each terminating with a ";". You can also include comments at the end of lines with "//" or comment many lines using "/* \*/". The scripts are stored in ChapProcessData. For the moment ChapProcessPrivate is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the same suggests, it means that when this command is encountered, the `Matroska Player` SHOULD jump to the `Chapter` specified by the UID and play it.

### DVD menu (1)

This is the case when `ChapProcessCodecID` = 1\. Each level of a chapter corresponds to a logical level in the DVD system that is stored in the first octet of the ChapProcessPrivate. This DVD hierarchy is as follows:

| ChapProcessPrivate | DVD Name | Hierarchy                                           | Commands Possible | Comment                                   |
|--------------------|----------|-----------------------------------------------------|-------------------|-------------------------------------------|
| 0x30               | SS       | DVD domain                                          | -                 | First Play, Video Manager, Video Title    |
| 0x2A               | LU       | Language Unit                                       | -                 | Contains only PGCs                        |
| 0x28               | TT       | Title                                               | -                 | Contains only PGCs                        |
| 0x20               | PGC      | Program Group Chain (PGC)                           | *                 |                                           |
| 0x18               | PG       | Program 1 / Program 2 / Program 3                   | -                 |                                           |
| 0x10               | PTT      | Part Of Title 1 / Part Of Title 2                   | -                 | Equivalent to the chapters on the sleeve. |
| 0x08               | CN       | Cell 1 / Cell 2 / Cell 3 / Cell 4 / Cell 5 / Cell 6 | -                 |                                           |

You can also recover wether a Segment is a Video Manager (VMG), Video Title Set (VTS) or Video Title Set Menu (VTSM) from the ChapterTranslateID element found in the Segment Info. This field uses 2 octets as follows:

1.  Domain Type: 0 for VMG, the domain number for VTS and VTSM
2.  Domain Value: 0 for VMG and VTSM, 1 for the VTS source.

For instance, the menu part from VTS_01_0.VOB would be coded [1,0] and the content part from VTS_02_3.VOB would be [2,1]. The VMG is always [0,0]

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

If the level specified in ChapProcessPrivate is a PGC (0x20), there is an octet called the Playback Type, specifying the kind of PGC defined:

*   0x00: entry only/basic PGC
*   0x82: Title+Entry Menu (only found in the Video Manager domain)
*   0x83: Root Menu (only found in the VTSM domain)
*   0x84: Subpicture Menu (only found in the VTSM domain)
*   0x85: Audio Menu (only found in the VTSM domain)
*   0x86: Angle Menu (only found in the VTSM domain)
*   0x87: Chapter Menu (only found in the VTSM domain)

The next 4 following octets correspond to the [User Operation flags](http://dvd.sourceforge.net/dvdinfo/uops.html) in the standard PGC. When a bit is set, the command SHOULD be disabled.

ChapProcessData contains the pre/post/cell commands in binary format as there are stored on a DVD. There is just an octet preceding these data to specify the number of commands in the element. As follows: [# of commands(1)][command 1 (8)][command 2 (8)][command 3 (8)].

More information on the DVD commands and format on [DVD-replica](http://www.dvd-replica.com/DVD/), where we got most of the info about it. You can also get information on DVD from [the DVDinfo project](http://dvd.sourceforge.net/dvdinfo/).

## Example 1 : basic chaptering

In this example a movie is split in different chapters. It could also just be an audio file (album) on which each track corresponds to a chapter.

*   00000ms - 05000ms : Intro
*   05000ms - 25000ms : Before the crime
*   25000ms - 27500ms : The crime
*   27500ms - 38000ms : The killer arrested
*   38000ms - 43000ms : Credits

This would translate in the following matroska form :

```xml
<Chapters>
  <EditionEntry>
    <EditionUID>16603393396715046047</EditionUID>
    <ChapterAtom>
      <ChapterUID>1193046</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>5000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Intro</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>2311527</ChapterUID>
      <ChapterTimeStart>5000000000</ChapterTimeStart>
      <ChapterTimeEnd>25000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Before the crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Avant le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>3430008</ChapterUID>
      <ChapterTimeStart>25000000000</ChapterTimeStart>
      <ChapterTimeEnd>27500000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>The crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>4548489</ChapterUID>
      <ChapterTimeStart>27500000000</ChapterTimeStart>
      <ChapterTimeEnd>38000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>After the crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Après le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>5666960</ChapterUID>
      <ChapterTimeStart>38000000000</ChapterTimeStart>
      <ChapterTimeEnd>43000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Credits</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Générique</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
    <EditionFlagHidden>0</EditionFlagHidden>
  </EditionEntry>
</Chapters>
```

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

```xml
<Chapters>
  <EditionEntry>
    <EditionUID>1281690858003401414</EditionUID>
    <ChapterAtom>
      <ChapterUID>1</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>748000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to Bleep/Rock</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterAtom>
        <ChapterUID>2</ChapterUID>
        <ChapterTimeStart>0</ChapterTimeStart>
        <ChapterTimeEnd>278000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.1)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>3</ChapterUID>
        <ChapterTimeStart>278000000</ChapterTimeStart>
        <ChapterTimeEnd>432000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to rock</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>4</ChapterUID>
        <ChapterTimeStart>432000000</ChapterTimeStart>
        <ChapterTimeEnd>633000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.2)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>5</ChapterUID>
        <ChapterTimeStart>633000000</ChapterTimeStart>
        <ChapterTimeEnd>748000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.3)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>6</ChapterUID>
      <ChapterTimeStart>750000000</ChapterTimeStart>
      <ChapterTimeEnd>1178500000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper_O+2</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>7</ChapterUID>
      <ChapterTimeStart>1180500000</ChapterTimeStart>
      <ChapterTimeEnd>1340000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (pt.4)</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>8</ChapterUID>
      <ChapterTimeStart>1342000000</ChapterTimeStart>
      <ChapterTimeEnd>1518000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleep to bleep</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>9</ChapterUID>
      <ChapterTimeStart>1520000000</ChapterTimeStart>
      <ChapterTimeEnd>2015000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (k)</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>10</ChapterUID>
      <ChapterTimeStart>2017000000</ChapterTimeStart>
      <ChapterTimeEnd>2668000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
    <EditionFlagHidden>0</EditionFlagHidden>
  </EditionEntry>
</Chapters>
```
