---
title: Matroska Element Ordering
---

# Matroska Element Ordering

Except for the `EBML Header` and the `CRC-32 Element`, the EBML specification does not require any particular storage order for `Elements`. The Matroska specification however defines mandates and recommendations for ordering certain `Elements` in order to facilitate better playback, seeking, and editing efficiency. This section describes and offers rationale for ordering requirements and recommendations for Matroska.

## Top-Level Elements

The `Info Element` is the only REQUIRED `Top-Level Element` in a Matroska file. To be playable, Matroska MUST also contain at least one `Tracks Element` and `Cluster Element`. The first `Info Element` and the first `Tracks Element` MUST either be stored before the first `Cluster Element` or both SHALL be referenced by a `SeekHead Element` occurring before the first `Cluster Element`.

It is possible to edit a Matroska file after it has been created. For example, chapters, tags or attachments can be added. When new `Top-Level Elements` are added to a Matroska file, the `SeekHead` Element(s) MUST be updated so that the `SeekHead` Element(s) itemize the identity and position of all `Top-Level Elements`. Editing, removing, or adding `Elements` to a Matroska file often requires that some existing `Elements` be voided or extended; therefore, it is RECOMMENDED to use `Void Elements` as padding in between `Top-Level Elements`.

## CRC-32

As noted by the EBML specification, if a `CRC-32 Element` is used then the `CRC-32 Element` MUST be the first ordered `Element` within its `Parent Element`. The Matroska specification recommends that `CRC-32 Elements` SHOULD NOT be used as an immediate `Child Element` of the `Segment Element`; however all `Top-Level Elements` of an `EBML Document` SHOULD include a `CRC-32 Element` as a `Child Element`.

## SeekHead

If used, the first `SeekHead Element` SHOULD be the first non-`CRC-32 Child Element` of the `Segment Element`. If a second `SeekHead Element` is used, then the first `SeekHead Element` MUST reference the identity and position of the second `SeekHead`. Additionally, the second `SeekHead Element` MUST only reference `Cluster` Elements and not any other `Top-Level Element` already contained within the first `SeekHead Element`. The second `SeekHead Element` MAY be stored in any order relative to the other `Top-Level Elements.` Whether one or two `SeekHead Element(s)` are used, the `SeekHead Element(s)` MUST collectively reference the identity and position of all `Top-Level Elements` except for the first `SeekHead Element`.

It is RECOMMENDED that the first `SeekHead Element` be followed by a `Void Element` to allow for the `SeekHead Element` to be expanded to cover new `Top-Level Elements` that could be added to the Matroska file, such as `Tags`, `Chapters` and `Attachments Elements`.

## Cues (index)

The `Cues Element` is RECOMMENDED to optimize seeking access in Matroska. It is programmatically simpler to add the `Cues Element` after all `Cluster Elements` have been written because this does not require a prediction of how much space to reserve before writing the `Cluster Elements`. However, storing the `Cues Element` before the `Cluster Elements` can provide some seeking advantages. If the `Cues Element` is present, then it SHOULD either be stored before the first `Cluster Element` or be referenced by a `SeekHead Element`.

## Info

The first `Info Element` SHOULD occur before the first `Tracks Element` and first `Cluster Element` except when referenced by a `SeekHead Element`.

## Chapters Element

The `Chapters Element` SHOULD be placed before the `Cluster Element(s)`. The `Chapters Element` can be used during playback even if the user does not need to seek. It immediately gives the user information about what section is being read and what other sections are available. In the case of Ordered Chapters it RECOMMENDED to evaluate the logical linking even before playing. The `Chapters Element` SHOULD be placed before the first `Tracks Element` and after the first `Info Element`.

## Attachments

The `Attachments Element` is not intended to be used by default when playing the file, but could contain information relevant to the content, such as cover art or fonts. Cover art is useful even before the file is played and fonts could be needed before playback starts for initialization of subtitles. The `Attachments Element` MAY be placed before the first `Cluster Element`; however if the `Attachments Element` is likely to be edited, then it SHOULD be placed after the last `Cluster Element`.

## Tags

The `Tags Element` is most subject to changes after the file was originally created. For easier editing, the `Tags Element` SHOULD be placed at the end of the `Segment Element`, even after the `Attachments Element`. On the other hand, it is inconvenient to have to seek in the `Segment` for tags, especially for network streams. So it's better if the `Tags Element` is found early in the stream. When editing the `Tags Element`, the original `Tags Element` at the beginning can be overwritten with a `Void Element` and a new `Tags Element` written at the end of the `Segment Element`. The file size will only marginally change.

## Optimum layout from a muxer

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Tags
* Clusters
* Cues

## Optimum layout after editing tags

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Void
* Clusters
* Cues
* Tags

## Optimum layout with Cues at the front

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Tags
* Cues
* Clusters

## Cluster Timestamp

The `Timestamp Element` MUST occur as in storage order before any `SimpleBlock`, `BlockGroup`, or `EncryptedBlock` within the `Cluster Element`.
