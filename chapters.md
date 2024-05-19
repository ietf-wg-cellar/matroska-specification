# Chapters

The Matroska `Chapters` system can have multiple `Editions`, and each `Edition` can consist of
`Simple Chapters` where a chapter start time is used as a marker in the timeline only. An
`Edition` can be more complex with `Ordered Chapters` where a chapter end timestamp is additionally
used or much more complex with `Linked Chapters`. The Matroska `Chapters` system can also have a menu
structure borrowed from the DVD-menu system [@?DVD-Video] or have its own built-in Matroska menu structure.

## EditionEntry

The `EditionEntry` is also called an `Edition`.
An `Edition` contains a set of `Edition` flags and **MUST** contain at least one `ChapterAtom Element`.
`Chapters` are always inside an `Edition` (or a `Chapter` itself is part of an `Edition`).
Multiple `Editions` are allowed. Some of these `Editions` **MAY** be ordered and others not.

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
Table: Default Edition, All Default{#defaultEditionAllDefault}

Edition   | FlagDefault | Default Edition
:---------|:------------|:---------------
Edition 1 | false       | X
Edition 2 | false       |
Edition 3 | false       |
Table: Default Edition, No Default{#defaultEditionNoDefault}

Edition   | FlagDefault | Default Edition
:---------|:------------|:---------------
Edition 1 | false       |
Edition 2 | true        | X
Edition 3 | false       |
Table: Default Edition, With Default{#defaultEditionWithDefault}

### EditionFlagOrdered

The `EditionFlagOrdered` flag is a significant feature, as it enables an `Edition`
of `Ordered Chapters` that defines and arranges a virtual timeline rather than simply
labeling points within the timeline. For example, with `Editions` of `Ordered Chapters`,
a single `Matroska file` can present multiple edits of a film without duplicating content.
Alternatively, if a videotape is digitized in full, one `Ordered Edition` could present
the full content (including colorbars, countdown, slate, a feature presentation, and
black frames), while another `Edition` of `Ordered Chapters` can use `Chapters` that only
mark the intended presentation with the colorbars and other ancillary visual information
excluded. If an `Edition` of `Ordered Chapters` is enabled, then the `Matroska Player` **MUST**
play those `Chapters` in their stored order from the timestamp marked in the
`ChapterTimeStart Element` to the timestamp marked in to `ChapterTimeEnd Element`.

If the `EditionFlagOrdered` flag evaluates to "0", `Simple Chapters` are used and
only the `ChapterTimeStart` of a `Chapter` is used as a chapter mark to jump to the
predefined point in the timeline. With `Simple Chapters`, a `Matroska Player` **MUST**
ignore certain `Chapters Elements`. In that case, these elements are informational only.

The following list shows the different `Chapters` elements only found in `Ordered Chapters`.

* `ChapterAtom\ChapterSegmentUUID`

* `ChapterAtom\ChapterSegmentEditionUID`

* `ChapterAtom\ChapterTrack`

* `ChapterAtom\ChapProcess`

* `Info\ChapterTranslate`

* `TrackEntry\TrackTranslate`

Furthermore, there are other EBML `Elements` that could be used if the `EditionFlagOrdered`
evaluates to "1".

#### Ordered-Edition and Matroska Segment Linking

Hard Linking:

: `Ordered Chapters` supersede the `Hard Linking`.

Medium Linking:

: `Ordered Chapters` are used in a normal way and can be combined
with the `ChapterSegmentUUID` element, which establishes a link to another `Segment`.

See (#linked-segments) on `Linked Segment`s for more information
about `Hard Linking` and `Medium Linking`.

## ChapterAtom
The `ChapterAtom` is also called a `Chapter`.

### ChapterTimeStart
`ChapterTimeStart` is the timestamp of the start of `Chapter` with nanosecond accuracy and is not scaled by `TimestampScale`.
For `Simple Chapters`, this is the position of the chapter markers in the timeline.

### ChapterTimeEnd
`ChapterTimeEnd` is the timestamp of the end of `Chapter` with nanosecond accuracy and is not scaled by `TimestampScale`.
The timestamp defined by the `ChapterTimeEnd` is not part of the `Chapter`.
A `Matroska Player` calculates the duration of this `Chapter` using the difference between the
`ChapterTimeEnd` and `ChapterTimeStart`.
The end timestamp **MUST** be greater than or equal to the start timestamp.

When the `ChapterTimeEnd` timestamp is equal to the `ChapterTimeStart` timestamp,
the timestamp is included in the `Chapter`. It can be useful to put markers in
a file or add chapter commands with ordered chapter commands without having to play anything;
see (#chapprocess-element).

Chapter   | Start timestamp | End timestamp | Duration
:---------|:----------------|:--------------|:-----
Chapter 1 | 0               | 1000000000    | 1000000000
Chapter 2 | 1000000000      | 5000000000    | 4000000000
Chapter 3 | 6000000000      | 6000000000    | 0
Chapter 4 | 9000000000      | 8000000000    | Invalid (-1000000000)
Table: ChapterTimeEnd Usage Possibilities{#ChapterTimeEndUsage}

### Nested Chapters

A `ChapterAtom` element can contain other `ChapterAtom` elements.
That element is a `Parent Chapter`, and the `ChapterAtom` elements it contains are `Nested Chapters`.

`Nested Chapters` can be useful to tag small parts of a `Segment` that already have tags or
add Chapter Codec commands on smaller parts of a `Segment` that already have Chapter Codec commands.

The `ChapterTimeStart` of a `Nested Chapter` **MUST** be greater than or equal to the `ChapterTimeStart` of its `Parent Chapter`.

If the `Parent Chapter` of a `Nested Chapter` has a `ChapterTimeEnd`, the `ChapterTimeStart` of that `Nested Chapter`
**MUST** be smaller than or equal to the `ChapterTimeEnd` of the `Parent Chapter`.

### Nested Chapters in Ordered Chapters

The `ChapterTimeEnd` of the lowest level of `Nested Chapters` **MUST** be set for `Ordered Chapters`.

When used with `Ordered Chapters`, the `ChapterTimeEnd` value of a `Parent Chapter` is useless for playback,
as the proper playback sections are described in its `Nested Chapters`.
The `ChapterTimeEnd` **SHOULD NOT** be set in `Parent Chapters` and **MUST** be ignored for playback.

### ChapterFlagHidden

Each `Chapter`'s
`ChapterFlagHidden` flag works independently of `Parent Chapters`.
A `Nested Chapter` with a `ChapterFlagHidden` flag that evaluates to "0" remains visible in the user interface even if the
`Parent Chapter`'s `ChapterFlagHidden` flag is set to "1".

Chapter + Nested Chapter | ChapterFlagHidden | visible
:------------------------|:------------------|:-------
Chapter 1                | 0                 | yes
 Nested Chapter 1.1      | 0                 | yes
 Nested Chapter 1.2      | 1                 | no
Chapter 2                | 1                 | no
 Nested Chapter 2.1      | 0                 | yes
 Nested Chapter 2.2      | 1                 | no
Table: ChapterFlagHidden Nested Visibility{#ChapterFlagHiddenNested}

## Menu Features

The menu features are handled like a `chapter codec`. That means each codec has a type,
some private data, and some data in the chapters.

The type of the menu system is defined by the `ChapProcessCodecID` parameter. For now,
only two values are supported: 0 (Matroska Script) and 1 (menu borrowed from the DVD [@?DVD-Video]).
The private data depend on the type of menu system (stored in `ChapProcessPrivate`),
idem for the data in the chapters (stored in `ChapProcessData`).

The menu system, as well as Chapter Codecs in general, can perform actions on the `Matroska Player`,
such as jumping to another `Chapter` or `Edition`, selecting different tracks, and possibly more.
The scope of all the possibilities of Chapter Codecs is not covered in this document, as it
depends on the Chapter Codec features and its integration in a `Matroska Player`.

## Physical Types

Each level can have different meanings for audio and video. The `ORIGINAL_MEDIA_TYPE` tag [@?I-D.ietf-cellar-tags] can be used to
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
Table: ChapterPhysicalEquiv Meaning per Track Type{#ChapterPhysicalEquivMeaning}

## Chapter Examples

### Example 1: Basic Chaptering

In this example, a movie is split in different chapters. It could also just be an
audio file (album) in which each track corresponds to a chapter.

*   00000 ms - 05000 ms: Intro
*   05000 ms - 25000 ms: Before the crime
*   25000 ms - 27500 ms: The crime
*   27500 ms - 38000 ms: After the crime
*   38000 ms - 43000 ms: Credits

This would translate in the following Matroska form, with the EBML tree shown as XML:

```xml
&lt;Chapters&gt;
  &lt;EditionEntry&gt;
    &lt;EditionUID&gt;16603393396715046047&lt;/EditionUID&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;1193046&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;0&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;5000000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Intro&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;2311527&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;5000000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;25000000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Before the crime&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Avant le crime&lt;/ChapString&gt;
        &lt;ChapLanguage&gt;fra&lt;/ChapLanguage&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;3430008&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;25000000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;27500000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;The crime&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Le crime&lt;/ChapString&gt;
        &lt;ChapLanguage&gt;fra&lt;/ChapLanguage&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;4548489&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;27500000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;38000000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;After the crime&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Apres le crime&lt;/ChapString&gt;
        &lt;ChapLanguage&gt;fra&lt;/ChapLanguage&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;5666960&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;38000000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;43000000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Credits&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Generique&lt;/ChapString&gt;
        &lt;ChapLanguage&gt;fra&lt;/ChapLanguage&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
  &lt;/EditionEntry&gt;
&lt;/Chapters&gt;
```
Figure: Basic Chapters Example

### Example 2: Nested Chapters

In this example, an (existing) album is split into different chapters, and one
of them contains another splitting.

#### The Micronauts "Bleep To Bleep"

*   00:00 - 12:28: Baby wants to Bleep/Rock
    *   00:00 - 04:38: Baby wants to bleep (pt.1)
    *   04:38 - 07:12: Baby wants to rock
    *   07:12 - 10:33: Baby wants to bleep (pt.2)
    *   10:33 - 12:28: Baby wants to bleep (pt.3)
*   12:30 - 19:38: Bleeper_O+2
*   19:40 - 22:20: Baby wants to bleep (pt.4)
*   22:22 - 25:18: Bleep to bleep
*   25:20 - 33:35: Baby wants to bleep (k)
*   33:37 - 44:28: Bleeper

This would translate in the following Matroska form, with the EBML tree shown as XML:

```xml
&lt;Chapters&gt;
  &lt;EditionEntry&gt;
    &lt;EditionUID&gt;1281690858003401414&lt;/EditionUID&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;1&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;0&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;748000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Baby wants to Bleep/Rock&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
      &lt;ChapterAtom&gt;
        &lt;ChapterUID&gt;2&lt;/ChapterUID&gt;
        &lt;ChapterTimeStart&gt;0&lt;/ChapterTimeStart&gt;
        &lt;ChapterTimeEnd&gt;278000000&lt;/ChapterTimeEnd&gt;
        &lt;ChapterDisplay&gt;
          &lt;ChapString&gt;Baby wants to bleep (pt.1)&lt;/ChapString&gt;
        &lt;/ChapterDisplay&gt;
      &lt;/ChapterAtom&gt;
      &lt;ChapterAtom&gt;
        &lt;ChapterUID&gt;3&lt;/ChapterUID&gt;
        &lt;ChapterTimeStart&gt;278000000&lt;/ChapterTimeStart&gt;
        &lt;ChapterTimeEnd&gt;432000000&lt;/ChapterTimeEnd&gt;
        &lt;ChapterDisplay&gt;
          &lt;ChapString&gt;Baby wants to rock&lt;/ChapString&gt;
        &lt;/ChapterDisplay&gt;
      &lt;/ChapterAtom&gt;
      &lt;ChapterAtom&gt;
        &lt;ChapterUID&gt;4&lt;/ChapterUID&gt;
        &lt;ChapterTimeStart&gt;432000000&lt;/ChapterTimeStart&gt;
        &lt;ChapterTimeEnd&gt;633000000&lt;/ChapterTimeEnd&gt;
        &lt;ChapterDisplay&gt;
          &lt;ChapString&gt;Baby wants to bleep (pt.2)&lt;/ChapString&gt;
        &lt;/ChapterDisplay&gt;
      &lt;/ChapterAtom&gt;
      &lt;ChapterAtom&gt;
        &lt;ChapterUID&gt;5&lt;/ChapterUID&gt;
        &lt;ChapterTimeStart&gt;633000000&lt;/ChapterTimeStart&gt;
        &lt;ChapterTimeEnd&gt;748000000&lt;/ChapterTimeEnd&gt;
        &lt;ChapterDisplay&gt;
          &lt;ChapString&gt;Baby wants to bleep (pt.3)&lt;/ChapString&gt;
        &lt;/ChapterDisplay&gt;
      &lt;/ChapterAtom&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;6&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;750000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;1178500000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Bleeper_O+2&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;7&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;1180500000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;1340000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Baby wants to bleep (pt.4)&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;8&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;1342000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;1518000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Bleep to bleep&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;9&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;1520000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;2015000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Baby wants to bleep (k)&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
    &lt;ChapterAtom&gt;
      &lt;ChapterUID&gt;10&lt;/ChapterUID&gt;
      &lt;ChapterTimeStart&gt;2017000000&lt;/ChapterTimeStart&gt;
      &lt;ChapterTimeEnd&gt;2668000000&lt;/ChapterTimeEnd&gt;
      &lt;ChapterDisplay&gt;
        &lt;ChapString&gt;Bleeper&lt;/ChapString&gt;
      &lt;/ChapterDisplay&gt;
    &lt;/ChapterAtom&gt;
  &lt;/EditionEntry&gt;
&lt;/Chapters&gt;
```
Figure: Nested Chapters Example

