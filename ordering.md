# Matroska Element Ordering

With the exceptions of the `EBML Header` and the `CRC-32` element, the EBML specification [@!RFC8794] does not
require any particular storage order for elements. However, this specification
defines mandates and recommendations for ordering certain elements to facilitate
better playback, seeking, and editing efficiency. This section describes and offers
rationale for ordering requirements and recommendations for Matroska.

## Top-Level Elements

The `Info` element is the only **REQUIRED** `Top-Level Element` in a Matroska file.
To be playable, Matroska **MUST** also contain at least one `Tracks` element and `Cluster` element.
The first `Info` element and the first `Tracks` element either **MUST** be stored before the first
`Cluster` element or **SHALL** both be referenced by a `SeekHead` element occurring before the first `Cluster` element.

All `Top-Level Elements` **MUST** use a 4-octet EBML Element ID.

When using Medium Linking, chapters are used to reference other `Segments` to play in a given order (see (#medium-linking)).
A `Segment` containing these `Linked Chapters` does not require a `Tracks` element or a `Cluster` element.

It is possible to edit a Matroska file after it has been created. For example, chapters,
tags, or attachments can be added. When new `Top-Level Elements` are added to a Matroska file,
the `SeekHead` element(s) **MUST** be updated so that the `SeekHead` element(s) itemizes
the identity and position of all `Top-Level Elements`.

Editing, removing, or adding
elements to a Matroska file often requires that some existing elements be voided
or extended.
Transforming the existing elements into `Void` elements as padding can be used
as a method to avoid moving large amounts of data around.

## CRC-32

As noted by the EBML specification [@!RFC8794], if a `CRC-32` element is used, then the `CRC-32` element
**MUST** be the first ordered element within its `Parent Element`.

In Matroska, all `Top-Level Elements` of an EBML Document **SHOULD** include a `CRC-32` element
as their first `Child Element`.
The `Segment` element, which is the `Root Element`, **SHOULD NOT** have a `CRC-32` element.

## SeekHead

If used, the first `SeekHead` element **MUST** be the first non-`CRC-32 Child` element
of the `Segment` element. If a second `SeekHead` element is used, then the first
`SeekHead` element **MUST** reference the identity and position of the second `SeekHead` element.

Additionally, the second `SeekHead` element **MUST** only reference `Cluster` elements
and not any other `Top-Level Element` already contained within the first `SeekHead` element.

The second `SeekHead` element **MAY** be stored in any order relative to the other `Top-Level Elements`.
Whether one or two `SeekHead` elements are used, the `SeekHead ` element(s) **MUST**
collectively reference the identity and position of all `Top-Level Elements` except
for the first `SeekHead` element.

## Cues (Index)

The `Cues` element is **RECOMMENDED** to optimize seeking access in Matroska. It is
programmatically simpler to add the `Cues` element after all `Cluster` elements
have been written because this does not require a prediction of how much space to
reserve before writing the `Cluster` elements. However, storing the `Cues` element
before the `Cluster` elements can provide some seeking advantages. If the `Cues` element
is present, then it **SHOULD** either be stored before the first `Cluster` element
or be referenced by a `SeekHead` element.

## Info

The first `Info` element **SHOULD** occur before the first `Tracks` element and first
`Cluster` element except when referenced by a `SeekHead` element.

## Chapters Element

The `Chapters` element **SHOULD** be placed before the `Cluster ` element(s). The
`Chapters` element can be used during playback even if the user does not need to seek.
It immediately gives the user information about what section is being read and what
other sections are available.

In the case of `Ordered Chapters`, it is **RECOMMENDED** to evaluate
the logical linking before playing. The `Chapters` element **SHOULD** be placed before
the first `Tracks` element and after the first `Info` element.

## Attachments

The `Attachments` element is not intended to be used by default when playing the file
but could contain information relevant to the content, such as cover art or fonts.
Cover art is useful even before the file is played, and fonts could be needed before playback
starts for the initialization of subtitles. The `Attachments` element **MAY** be placed before
the first `Cluster` element; however, if the `Attachments` element is likely to be edited,
then it **SHOULD** be placed after the last `Cluster` element.

## Tags

The `Tags` element is most subject to changes after the file was originally created.
For easier editing, the `Tags` element can be placed at the end of the `Segment` element,
even after the `Attachments` element. On the other hand, it is inconvenient to have to
seek in the `Segment` for tags, especially for network streams; thus, it's better if the
`Tags` element is found early in the stream. When editing the `Tags` element, the original
`Tags` element at the beginning can be overwritten with a `Void` element and a
new `Tags` element written at the end of the `Segment` element. The file and `Segment` sizes will only marginally change.

