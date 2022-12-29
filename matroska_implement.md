---
title: Matroska Implementation Recommentations
---

# Implementation Recommendations

## Cluster

It is **RECOMMENDED** that the size of each individual `Cluster Element` be limited to store
no more than 5 seconds or 5 megabytes.

## SeekHead

It is **RECOMMENDED** that the first `SeekHead Element` be followed by a `Void Element` to
allow for the `SeekHead Element` to be expanded to cover new `Top-Level Elements`
that could be added to the Matroska file, such as `Tags`, `Chapters`, and `Attachments` Elements.

The size of this `Void Element` should be adjusted depending whether the Matroska file already has
`Tags`, `Chapters`, and `Attachments` Elements.

## Optimum Layouts

While there can be `Top-Level Elements` in any order, some ordering of Elements are better than others.
Here are few optimum layouts for different use case:

### Optimum layout for a muxer

This is the basic layout muxers should be using for an efficient playback experience.

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Tags
* Clusters
* Cues

### Optimum layout after editing tags

When tags from the previous layout need to be extended, they are moved to the end with the extra information.
The location where the old tags were located is voided.

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Void
* Clusters
* Cues
* Tags

### Optimum layout with Cues at the front

Cues are usually a big chunk of data referencing a lot of locations in the file.
For a player that want to seek in the file they need to seek to the end of the file
to have these locations. It is often better if they are placed early in the file.
On the other hand that means players that don't intend to seek will have to read/skip
these data no matter what.

Because the Cues reference locations further in the file, it's often complicated to
allocate the proper space for that element before all the locations are known.
Therefore shis layout is rarely used.

* SeekHead
* Info
* Tracks
* Chapters
* Attachments
* Tags
* Cues
* Clusters

### Optimum layout for livestreaming

In Livestreaming ((#livestreaming)) only a few elements make sense. SeekHead and Cues are useless for example.
All elements other than the Clusters **MUST** be placed before the Clusters.

* Info
* Tracks
* Attachments (rare)
* Tags
* Clusters

