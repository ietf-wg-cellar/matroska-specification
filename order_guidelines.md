---
layout: default
---
# Matroska Element Ordering Guidelines

Except for the EBML Header and the CRC-32 Element, the EBML specification does not require any particular storage order for Elements. The Matroska specification however defines mandates and recommendations for ordering certain Elements in order to facilitate better playback, seeking, and editing efficiency. This section describes and offers rationale for ordering requirements and recommendations for Matroska.

## Top-Level Elements

A valid Matroska file requires only one Top-Level Element, the `Info` Element; however, to be playable Matroska MUST also contain at least one `Tracks` and `Cluster` Element. The first `Info` Element and the first `Tracks` Element MUST either be stored before the first `Cluster` Element or both be referenced by a `SeekHead` Element which occurs before the first `Cluster` Element.

After a Matroska file has been created it could still be edited. For example chapters, tags or attachments can be added. When new Top-Level Elements are added to a Matroska file the `SeekHead` Element(s) MUST be updated so that the `SeekHead` Element(s) itemize the identity and position of all Top-Level Elements. Editing, removing, or adding Elements to a Matroska file often requires that some existing Elements be voided or extended; therefore, it is RECOMMENDED to use Void Elements as padding in between Top-Level Elements.

## CRC-32

As noted by the EBML specification, if a `CRC-32` Element is used then the `CRC-32` Element MUST be the first ordered Element within its Parent Element. The Matroska specification recommends that `CRC-32` Elements SHOULD NOT be used as an immediate Child Element of the `Segment` Element; however all Top-Level Elements of an EBML Document SHOULD include a CRC-32 Element as a Child Element.

## SeekHead

If used, the first `SeekHead` Element SHOULD be the first non-`CRC-32` Child Element of the `Segment` Element. If a second `SeekHead` Element is used then the first `SeekHead` MUST reference the identity and position of the second `SeekHead`, the second `SeekHead` MUST only reference `Cluster` Elements and not any other Top-Level Element already contained within the first `SeekHead`, and the second `SeekHead` MAY be stored in any order relative to the other Top-Level Elements. Whether one or two `SeekHead` Element(s) are used, the `SeekHead` Element(s) MUST collectively reference the identity and position of all Top-Level Elements except for the first `SeekHead` itself.

It is RECOMMENDED that the first `SeekHead` Element be followed by some padding (a `Void` Element) to allow for the `SeekHead` Element to be expanded to cover new Top-Level Elements that could be added to the Matroska file, such as `Tags`, `Chapters` and `Attachments` Elements.

## Cues (index)

The `Cues` Element is RECOMMENDED to optimize seeking access in Matroska. It is programmatically simpler to add the `Cues` Element after all of the `Cluster` Elements are written because this does not require a prediction of how much space to reserve before writing the `Cluster` Elements. On the other hand, storing the `Cues` Element before the `Clusters` can provide some seeking advantages.

## Info

The first `Info` Element SHOULD occur before the first `Tracks` and first `Cluster` Element.

## Chapters

The `Chapters` Element SHOULD be placed before the `Cluster` Element(s). The `Chapters` Element can be used during playback even if the user doesn't need to seek. It immediately gives the user information of what section is being read and what other sections are available. In the case of Ordered Chapters it RECOMMENDED to evaluate the logical linking even before starting playing anything. The `Chapters` Element SHOULD be placed before the first `Tracks` Element and after the first `Info` Element.

## Attachments

The `Attachments` Element is not meant to use by default when playing the file, but could contain the cover art and/or fonts. Cover art is useful even before the file is played and fonts could be needed before playback starts for initialization of subtitles that could use them. The `Attachments` Element MAY be placed before the first `Cluster` Element; however if the `Attachments` Element is likely to be edited, then it SHOULD be placed after the last `Cluster` Element.

## Tags

The `Tags` Element is the one that is most subject to changes after the file was originally created. So for easier editing the `Tags` Element SHOULD be placed at the end of the `Segment` Element, even after the `Attachments` Element. On the other hand, it is inconvenient to have to seek in the `Segment` for tags especially for network streams. So it's better if the `Tags` Element(s) are found early in the stream. When editing the `Tags` Element(s), the original `Tags` Element at the beginning can be [voided]({{site.baseurl}}/index.html#Void) and a new one [written right at the end]({{site.baseurl}}/order_guidelines.html#tags-end) of the `Segment` Element. The file size will only marginally change.

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

## Cluster Timecode

As each `BlockGroup` and `SimpleBlock` of a `Cluster` Element needs the Cluster `Timecode`, the `Timecode` Element MUST occur as the first Child Element within the `Cluster` Element.
