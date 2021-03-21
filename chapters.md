---
title: Chapters
---

# Chapters

The Matroska Chapters system can have multiple `Editions` and each `Edition` can consist of
`Simple Chapters` where a chapter start time is used as marker in the timeline only. An
`Edition` can be more complex with `Ordered Chapters` where a chapter end time stamp is additionally
used or much more complex with `Linked Chapters`. The Matroska Chapters system can also have a menu
structure, borrowed from the DVD menu system, or have it's own Native Matroska menu structure.

## EditionEntry

The `EditionEntry` is also called an `Edition`.
An `Edition` contains a set of `Edition` flags and **MUST** contain at least one `ChapterAtom Element`.
Chapters are always inside an `Edition` (or a Chapter itself part of an `Edition`).
Multiple Editions are allowed. Some of these Editions **MAY** be ordered and others not.

### EditionFlagHidden

When the `EditionFlagHidden` flag is set to `false` it means the `Edition` is visible and selectable
in a `Matroska Player`.
All `ChapterAtoms Elements` **MUST** be interpreted with their own `ChapterFlagHidden` flags.

ChapterFlagHidden | False | True | visible
:-----------------|:------|:-----|:-------
Chapter 1         |   X   |      | yes
Chapter 2         |       | X    | no
Table: ChapterAtom visibility to the user{#chapterVisibility}

When the `EditionFlagHidden` flag is set to `true` the `Edition` is hidden and **SHOULD NOT** be
selectable in a `Matroska Player`.
If all `Editions` `EditionFlagHidden` flags are set to `true`, there is no visible `Edition`.
In this case all `ChapterAtoms Elements` **MUST** also be interpreted as if their `ChapterFlagHidden`
flag is also set to `true`, regardless with their own `ChapterFlagHidden` flags.

ChapterFlagHidden | False | True | visible
:-----------------|:------|:-----|:-------
Chapter 1         |   X   |      | no
Chapter 2         |       | X    | no
Table: ChapterAtom visibility in hidden editions{#chapterVisibilityHidden}

### EditionFlagDefault

Only one `Edition` **SHOULD** have an `EditionFlagDefault` flag set to `true`.

### Default Edition

The `Default Edition` is the `Edition` that a `Matroska Player` **SHOULD** use for playback by default.

The first `Edition` with both the `EditionFlagDefault` flag set to `true` and the `EditionFlagHidden`
flag set to `false` is the `Default Edition`.
When all `EditionFlagDefault` flags are set to `false` and all `EditionFlagHidden` flag set to `true`,
then the first `Edition` is the `Default Edition`.
When all `EditionFlagHidden` flags are set to `true`, then the first `Edition` with the
`EditionFlagDefault` flag set to `true` is the `Default Edition`.
When all `EditionFlagDefault` flags are set to `false`, then the first `Edition` with the
`EditionFlagHidden` flag set to `false` is the `Default Edition`.
When there is no `Edition` with a `EditionFlagDefault` flag are set to `true` and a
`EditionFlagHidden` flags are set to `false`, then the first `Edition` with the `EditionFlagHidden`
flag set to `false` is the `Default Edition`.

In other words, in case the `Default Edition` is not obvious, the first `Edition` with a
`EditionFlagHidden` flag set to `false` **SHOULD** be preferred.

Edition   | FlagHidden | FlagDefault | Default Edition
:---------|:-----------|:------------|:---------------
Edition 1 | true       | true        |
Edition 2 | true       | true        |
Edition 3 | false      | true        | X
Table: Default edition, some visible, all default{#defaultEditionSomeVisibleAllDefault}

Edition   | FlagHidden | FlagDefault | Default Edition
:---------|:-----------|:------------|:---------------
Edition 1 | true       | false       | X
Edition 2 | true       | false       |
Edition 3 | true       | false       |
Table: Default edition, all hidden, no default{#defaultEditionAllHiddenNoDefault}

Edition   | FlagHidden | FlagDefault | Default Edition
:---------|:-----------|:------------|:---------------
Edition 1 | true       | false       |
Edition 2 | true       | true        | X
Edition 3 | true       | false       |
Table: Default edition, all hidden, with default{#defaultEditionAllHiddenWithDefault}

Edition   | FlagHidden | FlagDefault | Default Edition
:---------|:-----------|:------------|:---------------
Edition 1 | true       | false       |
Edition 2 | false      | false       | X
Edition 3 | false      | false       |
Table: Default edition, some visible, no default{#defaultEditionSomeVisibleNoDefault}

Edition   | FlagHidden | FlagDefault | Default Edition
:---------|:-----------|:------------|:---------------
Edition 1 | true       | false       |
Edition 2 | true       | true        |
Edition 3 | false      | false       | X
Table: Default edition, some visible, some default{#defaultEditionSomeVisibleSomeDefault}

### EditionFlagOrdered

The `EditionFlagOrdered Flag` is a significant feature as it enables an `Edition` of
`Ordered Chapters` which defines and arranges a virtual timeline rather than simply labeling points
within the timeline. For example, with `Editions` of `Ordered Chapters` a single `Matroska file`
can present multiple edits of a film without duplicating content. Alternatively, if a videotape is
digitized in full, one `Ordered Edition` could present the full content (including colorbars,
countdown, slate, a feature presentation, and black frames), while another `Edition` of
`Ordered Chapters` can use `Chapters` that only mark the intended presentation with the colorbars
and other ancillary visual information excluded. If an `Edition` of `Ordered Chapters` is enabled,
then the `Matroska Player` **MUST** play those Chapters in their stored order from the timestamp
marked in the `ChapterTimeStart Element` to the timestamp marked in to `ChapterTimeEnd Element`.

If the `EditionFlagOrdered Flag` is set to `false`, `Simple Chapters` are used and
only the `ChapterTimeStart` of a `Chapter` is used as chapter mark to jump to the
predefined point in the timeline. With `Simple Chapters`, a `Matroska Player` **MUST**
ignore certain `Chapter Elements`. All these elements are now informational only.

The following list shows the different Chapter elements only found in `Ordered Chapters`.

| Ordered Chapter elements              |
|:--------------------------------------|
| ChapterAtom/ChapterSegmentUID         |
| ChapterAtom/ChapterSegmentEditionUID  |
| ChapterAtom/ChapterTrack              |
| ChapterAtom/ChapProcess               |
| Info/SegmentFamily                    |
| Info/ChapterTranslate                 |
| TrackEntry/TrackTranslate             |
Table: elements only found in ordered chapters{#orderedOnly}

Furthermore there are other EBML `Elements` which could be used if the `EditionFlagOrdered`
flag is set to `true`.

#### Ordered-Edition and Matroska Segment-Linking

- Hard Linking: `Ordered-Chapters` supersedes the `Hard Linking`.
- Soft Linking: In this complex system `Ordered Chapters` are **REQUIRED** and a
`Chapter CODEC` **MUST** interpret the `ChapProcess` of all chapters.
- Medium Linking: `Ordered Chapters` are used in a normal way and can be combined
with the `ChapterSegmentUID` element which establishes a link to another Segment.

See (#linked-segments) on the Linked Segments for more information
about `Hard Linking`, `Soft Linking`, and `Medium Linking`.

- Hard Linking: `Ordered Chapters` supersedes the `Hard Linking`.
- Soft Linking: In this complex system `Ordered Chapters` are REQUIRED and a `Chapter CODEC`
  **MUST** interpret the `ChapProcess` of all chapters.
- Medium Linking: `Ordered Chapters` are used in a normal way and can be combined with the
 `ChapterSegmentUID` element which establishes a link to another Matroska file/Segment.

See [the section on the Linked Segments](#linked-segments) for more information about
`Hard Linking`, `Soft Linking` and `Medium Linking`.

## ChapterAtom
The `ChapterAtom` is also called a `Chapter`.
A `Chapter` element can be used recursively. Such a child `Chapter` is called `Nested Chapter`.

### ChapterTimeStart
A not scaled timestamp of the start of `Chapter` with nanosecond accuracy.
For `Simple Chapters` this is the position of the chapter markers in the timeline.

### ChapterTimeEnd
A not scaled timestamp of the end of `Chapter` with nanosecond accuracy.
The end timestamp is used when the `EditionFlagOrdered` flag of the `Edition` is set to `true`.
The timestamp defined by the `ChapterTimeEnd` is not part of the `Chapter`.
A `Matroska Player` calculates the duration of this `Chapter` using the difference between the
`ChapterTimeEnd` and `ChapterTimeStart`.
The end timestamp **MUST** be greater than the start timestamp otherwise the duration would be
negative which is illegal.
If the duration of a `Chapter` is 0, this `Chapter` **MUST** be ignored.

Chapter   | Start timestamp | End timestamp | Duration
:---------|:----------------|:--------------|:-----
Chapter 1 | 0               | 1000000000    | 1000000000
Chapter 2 | 1000000000      | 5000000000    | 4000000000
Chapter 3 | 6000000000      | 6000000000    | 0 (chapter not used)
Chapter 4 | 9000000000      | 8000000000    | -1000000000 (illegal)

### ChapterFlagHidden

The `ChapterFlagHidden` flag works differently from the `EditionFlagHidden` flag. Each Chapter
`ChapterFlagHidden` flag works independently from parent chapters.
A `Nested Chapter` with `ChapterFlagHidden` flag set to `false` remains visible even if the
`Parent Chapter` `ChapterFlagHidden` flag is set to `true`.

Chapter + Nested Chapter | ChapterFlagHidden | visible
:------------------------|:------------------|:-------
Chapter 1                | false             | yes
 Nested Chapter 1.1      | false             | yes
 Nested Chapter 1.2      | true              | no
Chapter 2                | true              | no
 Nested Chapter 2.1      | false             | yes
 Nested Chapter 2.2      | true              | no

### ChapterFlagEnabled

If the `ChapterFlagEnabled` flag is set to `false` a `Matroska Player` **MUST NOT** use this
`Chapter` and all his `Nested Chapters`.
For `Simple Chapters`, a `Matroska Player` **MAY** display this enabled `Chapter` with a marker in
the timeline.
For `Ordered Chapters` a `Matroska Player` **MUST** use the duration of this enabled `Chapter`.

Chapter + Nested Chapter | ChapterFlagEnabled | used
:------------------------|:-------------------|:----
Chapter 1                | true               | yes
+Nested Chapter 1.1      | true               | yes
+Nested Chapter 1.2      | false              | no
++Nested Chapter 1.2.1   | true               | no
++Nested Chapter 1.2.2   | false              | no
Chapter 2                | false              | no
+Nested Chapter 2.1      | true               | no
+Nested Chapter 2.2      | true               | no

## Menu features

The menu features are handled like a _chapter codec_. That means each codec has a type,
some private data and some data in the chapters.

The type of the menu system is defined by the `ChapProcessCodecID` parameter. For now,
only 2 values are supported : 0 matroska script, 1 menu borrowed from the DVD.
he private data depend on the type of menu system (stored in ChapProcessPrivate),
idem for the data in the chapters (stored in ChapProcessData).

### Matroska Script (0)

This is the case when `ChapProcessCodecID` = 0\. This is a script language build for
Matroska purposes. The inspiration comes from ActionScript, javascript and other similar
scripting languages. The commands are stored as text commands, in UTF-8\. The syntax is C like,
with commands spanned on many lines, each terminating with a ";". You can also include comments
at the end of lines with "//" or comment many lines using "/* \*/". The scripts are stored
in ChapProcessData. For the moment ChapProcessPrivate is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the
same suggests, it means that, when this command is encountered, the `Matroska Player`
**SHOULD** jump to the `Chapter` specified by the UID and play it.

### DVD menu (1)

This is the case when `ChapProcessCodecID` = 1\. Each level of a chapter corresponds
to a logical level in the DVD system that is stored in the first octet of the ChapProcessPrivate.
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

## Example 1 : basic chaptering

In this example a movie is split in different chapters. It could also just be an
audio file (album) on which each track corresponds to a chapter.

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

In this example an (existing) album is split into different chapters, and one
of them contain another splitting.

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
