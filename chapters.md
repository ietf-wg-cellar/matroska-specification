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

### EditionFlagDefault

Only one `Edition` **SHOULD** have an `EditionFlagDefault` flag set to `true`.

### Default Edition

The `Default Edition` is the `Edition` that a `Matroska Player` **SHOULD** use for playback by default.

The first `Edition` with the `EditionFlagDefault` flag set to `true` is the `Default Edition`.

When all `EditionFlagDefault` flags are set to `false`, then the first `Edition`
is the `Default Edition`.

Edition   | FlagDefault | Default Edition
:---------|:------------|:---------------
Edition 1 | true        | X
Edition 2 | true        |
Edition 3 | true        |
Table: Default edition, all default{#defaultEditionAllDefault}

Edition   | FlagDefault | Default Edition
:---------|:------------|:---------------
Edition 1 | false       | X
Edition 2 | false       |
Edition 3 | false       |
Table: Default edition, no default{#defaultEditionNoDefault}

Edition   | FlagDefault | Default Edition
:---------|:------------|:---------------
Edition 1 | false       |
Edition 2 | true        | X
Edition 3 | false       |
Table: Default edition, with default{#defaultEditionWithDefault}

### EditionFlagOrdered

The `EditionFlagOrdered Flag` is a significant feature as it enables an `Edition`
of `Ordered Chapters` which defines and arranges a virtual timeline rather than simply
labeling points within the timeline. For example, with `Editions` of `Ordered Chapters`
a single `Matroska file` can present multiple edits of a film without duplicating content.
Alternatively, if a videotape is digitized in full, one `Ordered Edition` could present
the full content (including colorbars, countdown, slate, a feature presentation, and
black frames), while another `Edition` of `Ordered Chapters` can use `Chapters` that only
mark the intended presentation with the colorbars and other ancillary visual information
excluded. If an `Edition` of `Ordered Chapters` is enabled, then the `Matroska Player` **MUST**
play those Chapters in their stored order from the timestamp marked in the
`ChapterTimeStart Element` to the timestamp marked in to `ChapterTimeEnd Element`.

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

### ChapterSegmentUID

The `ChapterSegmentUID` is a binary value and the base element to set up a
`Linked Chapter` in 2 variations: the Linked-Duration linking and the Linked-Edition
linking. For both variations, the following 3 conditions **MUST** be met:

 1. The `EditionFlagOrdered Flag` **MUST** be true.
 2. The `ChapterSegmentUID` **MUST NOT** be the `SegmentUID` of its own `Segment`.
 3. The linked Segments **MUST** BE in the same folder.

#### Variation 1: Linked-Duration

Two more conditions **MUST** be met:

 1. `ChapterTimeStart` and `ChapterTimeEnd` timestamps **MUST** be in the range of the
    linked Segment duration.
 2. `ChapterSegmentEditionUID` **MUST** be not set.

A `Matroska Player` **MUST** play the content of the linked Segment from the
`ChapterTimeStart` until `ChapterTimeEnd` timestamp.

#### Variation 2: Linked-Edition

When the `ChapterSegmentEditionUID` is set to a valid `EditionUID` from the linked
Segment. A `Matroska Player` **MUST** play these linked `Edition`.

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
Table: ChapterTimeEnd usage possibilities{#ChapterTimeEndUsage}

### ChapterFlagHidden

Each Chapter
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
Table: ChapterFlagHidden nested visibility{#ChapterFlagHiddenNested}

## Menu features

The menu features are handled like a `chapter codec`. That means each codec has a type,
some private data and some data in the chapters.

The type of the menu system is defined by the `ChapProcessCodecID` parameter. For now,
only 2 values are supported : 0 matroska script, 1 menu borrowed from the DVD.
The private data depend on the type of menu system (stored in `ChapProcessPrivate`),
idem for the data in the chapters (stored in `ChapProcessData`).

The menu system, as well a Chapter Codecs in general, can do actions on the `Matroska Player`
like jumping to another Chapter or Edition, selecting different tracks and possibly more.
The scope of all the possibilities of Chapter Codecs is not covered in this document as it
depends on the Chapter Codec features and its integration in a `Matroska Player`.

## Chapter Examples

### Example 1 : basic chaptering

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
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
  </EditionEntry>
</Chapters>
```
Figure: Basic Chapters Example.

### Example 2 : nested chapters

In this example an (existing) album is split into different chapters, and one
of them contain another splitting.

#### The Micronauts "Bleep To Bleep"

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
      </ChapterAtom>
      <ChapterFlagHidden>0</ChapterFlagHidden>
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
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
  </EditionEntry>
</Chapters>
```
Figure: Nested Chapters Example.
