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

If the `EditionFlagOrdered Flag` evaluates to "0", `Simple Chapters` are used and
only the `ChapterTimeStart` of a `Chapter` is used as chapter mark to jump to the
predefined point in the timeline. With `Simple Chapters`, a `Matroska Player` **MUST**
ignore certain `Chapter Elements`. In that case these elements are informational only.

The following list shows the different Chapter elements only found in `Ordered Chapters`.

| Ordered Chapter elements              |
|:--------------------------------------|
| ChapterAtom/ChapterSegmentUID         |
| ChapterAtom/ChapterSegmentEditionUID  |
| ChapterAtom/ChapterTrack              |
| ChapterAtom/ChapProcess               |
| Info/ChapterTranslate                 |
| TrackEntry/TrackTranslate             |
Table: elements only found in ordered chapters{#orderedOnly}

Furthermore there are other EBML `Elements` which could be used if the `EditionFlagOrdered`
evaluates to "1".

#### Ordered-Edition and Matroska Segment-Linking

- Hard Linking: `Ordered-Chapters` supersedes the `Hard Linking`.
- Medium Linking: `Ordered Chapters` are used in a normal way and can be combined
with the `ChapterSegmentUID` element which establishes a link to another Segment.

See (#linked-segments) on the Linked Segments for more information
about `Hard Linking` and `Medium Linking`.

## ChapterAtom
The `ChapterAtom` is also called a `Chapter`.

### ChapterTimeStart
The timestamp of the start of `Chapter` with nanosecond accuracy, not scaled by TimestampScale.
For `Simple Chapters` this is the position of the chapter markers in the timeline.

### ChapterTimeEnd
The timestamp of the end of `Chapter` with nanosecond accuracy, not scaled by TimestampScale.
The timestamp defined by the `ChapterTimeEnd` is not part of the `Chapter`.
A `Matroska Player` calculates the duration of this `Chapter` using the difference between the
`ChapterTimeEnd` and `ChapterTimeStart`.
The end timestamp **MUST** be greater than or equal to the start timestamp.

When the `ChapterTimeEnd` timestamp is equal to the `ChapterTimeStart` timestamp,
the timestamps is included in the `Chapter`. It can be useful to put markers in
a file or add chapter commands with ordered chapter commands without having to play anything;
see (#chapprocess-element).

Chapter   | Start timestamp | End timestamp | Duration
:---------|:----------------|:--------------|:-----
Chapter 1 | 0               | 1000000000    | 1000000000
Chapter 2 | 1000000000      | 5000000000    | 4000000000
Chapter 3 | 6000000000      | 6000000000    | 0
Chapter 4 | 9000000000      | 8000000000    | Invalid (-1000000000)
Table: ChapterTimeEnd usage possibilities{#ChapterTimeEndUsage}

### Nested Chapters

A `ChapterAtom` element can contain other `ChapterAtom` elements.
That element is a `Parent Chapter` and the `ChapterAtom` elements it contains are `Nested Chapters`.

Nested Chapters can be useful to tag small parts of a Segment that already have tags or
add Chapter Codec commands on smaller parts of a Segment that already have Chapter Codec commands.

The `ChapterTimeStart` of a `Nested Chapter` **MUST** be greater than or equal to the `ChapterTimeStart` its `Parent Chapter`.

If the `Parent Chapter` of a `Nested Chapter` has a `ChapterTimeEnd`, the `ChapterTimeStart` of that `Nested Chapter`
**MUST** be smaller than or equal to the `ChapterTimeEnd` of the `Parent Chapter`.

### Nested Chapters in Ordered Chapters

When used with Ordered Chapters, `Parent Chapters` **MUST** use the highest `ChapterTimeEnd` value of its direct `Nested Chapters`.

For example, some chapters in a Order Chapter edition:

* Chapter 1: start 10s
    * Chapter 1.1: start 10s
         * Chapter 1.1.1: start 10s / end 30s
         * Chapter 1.1.2: start 30s / end 50s
    * Chapter 1.2: start 20s / end 25s

A `Matroska Player` should play the content from 10s to 30s (1.1.1), then 30s to 50s (1.1.2),
then 20s to 25s (1.2).

The `ChapterTimeEnd` value for chapter 1.1.1, 1.1.2 and 1.2 are required to properly define the playback order.
Chapter 1.1 and 1 don't have a `ChapterTimeEnd` value set, but `ChapterTimeEnd` is required, as they are in an ordered edition.
They must have the highest `ChapterTimeEnd` value of their children.
So Chapter 1.1 would get the highest between "30s" and "50s", so "50s".
Chapter 1 would get the highest between "50s" and "25s", so "50s".
But it doesn't correspond to the actual duration of Chapter 1 which is playing 10-30s, 30-50s, 20-25s.
This layout of nested ordered chapters is not valid. It should be split as follows:

* Chapter 1: start 10s / end 50s
    * Chapter 1.1: start 10s / end 50s
         * Chapter 1.1.1: start 10s / end 30s
         * Chapter 1.1.2: start 30s / end 50s
* Chapter 2: start 20s / end 25s
    * Chapter 2.1: start 20s / end 25s

In order to be able to set a valid `ChapterTimeEnd` on a `Parent Chapter` elements,
all direct `Nested Chapters` of that `Parent Chapter` **MUST** have consecutive timestamps.
In other words, the following `ChapterTimeStart` of a direct `Nested Chapter` **MUST** be the same
as the `ChapterTimeEnd` of the previous direct `Nested Chapter`, unless it is the first `Nested Chapter` at that level.

For example, consider this slightly different playback sequence which plays a part of a gap after the main content:

* Chapter 1: start 10s
    * Chapter 1.1: start 10s
         * Chapter 1.1.1: start 10s / end 30s
         * Chapter 1.1.2: start 40s / end 50s
    * Chapter 1.2: start 35s / end 40s

The `ChapterTimeEnd` and `ChapterTimeStart` of chapters 1.1.1 and 1.1.2 are not consecutive.
The `ChapterTimeEnd` of chapter 1.1 cannot be set to "50s" otherwise the `Matroska Player`
might interpret it as playing from "10s" to "50s" and compute the duration using that.
Chapter 1 would also use "10s" to "50s" which is not correct as it would include "30s" to "35s"
which is not used. It is not possible to set `ChapterTimeEnd` of Chapter 1 appropriately unless it's not
used by the `Matroska Player`. If it's ignored by the player there is no real use of setting it.

### ChapterFlagHidden

Each Chapter
`ChapterFlagHidden` flag works independently from parent chapters.
A `Nested Chapter` with a `ChapterFlagHidden` that evaluates to "0" remains visible in the user interface even if the
`Parent Chapter` `ChapterFlagHidden` flag is set to "1".

Chapter + Nested Chapter | ChapterFlagHidden | visible
:------------------------|:------------------|:-------
Chapter 1                | 0                 | yes
 Nested Chapter 1.1      | 0                 | yes
 Nested Chapter 1.2      | 1                 | no
Chapter 2                | 1                 | no
 Nested Chapter 2.1      | 0                 | yes
 Nested Chapter 2.2      | 1                 | no
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

## Physical Types

Each level can have different meanings for audio and video. The ORIGINAL_MEDIUM tag can be used to
specify a string for ChapterPhysicalEquiv = 60\. Here is the list of possible levels for both audio and video:

| Value | Audio | Video | Comment |
|:---------------------|:------|:------|:--------|
| 70 | SET / PACKAGE | SET / PACKAGE | the collection of different media |
| 60 | CD / 12" / 10" / 7" / TAPE / MINIDISC / DAT | DVD / VHS / LASERDISC | the physical medium like a CD or a DVD |
| 50 | SIDE | SIDE | when the original medium (LP/DVD) has different sides |
| 40 | - | LAYER | another physical level on DVDs |
| 30 | SESSION | SESSION | as found on CDs and DVDs |
| 20 | TRACK | - | as found on audio CDs |
| 10 | INDEX | - | the first logical level of the side/medium |
Table: ChapterPhysicalEquiv meaning per track type{#ChapterPhysicalEquivMeaning}

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
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>2311527</ChapterUID>
      <ChapterTimeStart>5000000000</ChapterTimeStart>
      <ChapterTimeEnd>25000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Before the crime</ChapString>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Avant le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>3430008</ChapterUID>
      <ChapterTimeStart>25000000000</ChapterTimeStart>
      <ChapterTimeEnd>27500000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>The crime</ChapString>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>4548489</ChapterUID>
      <ChapterTimeStart>27500000000</ChapterTimeStart>
      <ChapterTimeEnd>38000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>After the crime</ChapString>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Après le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>5666960</ChapterUID>
      <ChapterTimeStart>38000000000</ChapterTimeStart>
      <ChapterTimeEnd>43000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Credits</ChapString>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Générique</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
    </ChapterAtom>
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
      </ChapterDisplay>
      <ChapterAtom>
        <ChapterUID>2</ChapterUID>
        <ChapterTimeStart>0</ChapterTimeStart>
        <ChapterTimeEnd>278000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.1)</ChapString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>3</ChapterUID>
        <ChapterTimeStart>278000000</ChapterTimeStart>
        <ChapterTimeEnd>432000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to rock</ChapString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>4</ChapterUID>
        <ChapterTimeStart>432000000</ChapterTimeStart>
        <ChapterTimeEnd>633000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.2)</ChapString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>5</ChapterUID>
        <ChapterTimeStart>633000000</ChapterTimeStart>
        <ChapterTimeEnd>748000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.3)</ChapString>
        </ChapterDisplay>
      </ChapterAtom>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>6</ChapterUID>
      <ChapterTimeStart>750000000</ChapterTimeStart>
      <ChapterTimeEnd>1178500000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper_O+2</ChapString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>7</ChapterUID>
      <ChapterTimeStart>1180500000</ChapterTimeStart>
      <ChapterTimeEnd>1340000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (pt.4)</ChapString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>8</ChapterUID>
      <ChapterTimeStart>1342000000</ChapterTimeStart>
      <ChapterTimeEnd>1518000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleep to bleep</ChapString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>9</ChapterUID>
      <ChapterTimeStart>1520000000</ChapterTimeStart>
      <ChapterTimeEnd>2015000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (k)</ChapString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>10</ChapterUID>
      <ChapterTimeStart>2017000000</ChapterTimeStart>
      <ChapterTimeEnd>2668000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper</ChapString>
      </ChapterDisplay>
    </ChapterAtom>
  </EditionEntry>
</Chapters>
```
Figure: Nested Chapters Example.
