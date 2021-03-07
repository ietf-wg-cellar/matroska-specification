---
title: Control Tracks
---
# Edition Flags

## EditionFlagHidden

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

## EditionFlagDefault

It is **RECOMMENDED** that no more than one `Edition` have an `EditionFlagDefault Flag`
set to `true`. The first `Edition` with both the `EditionFlagDefault Flag` set to `true`
and the `EditionFlagHidden Flag` set to `false` is the Default Edition. When all
`EditionFlagDefault Flags` are set to `false`, then the first `Edition` with the
`EditionFlagHidden Flag` set to `false` is the Default Edition. The Default Edition
is the edition that should be used for playback by default.


## Default Edition

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

# Chapter Flags

If a `Control Track` toggles the parent's `ChapterFlagHidden`
flag to `false`, then only the parent `ChapterAtom` and its second child `ChapterAtom`
**MUST** be interpreted as if `ChapterFlagHidden` is set to `false`. The first child
`ChapterAtom`, which has the `ChapterFlagHidden` flag set to `true`, retains its value
until its value is toggled to `false` by a `Control Track`.

The `ChapterFlagEnabled` value can be toggled by control tracks.

## ChapterFlagEnabled

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


# Matroska Schema

Extra elements used to handle Control Tracks and advanced selection features:

## Segment
### Chapters
#### EditionEntry
