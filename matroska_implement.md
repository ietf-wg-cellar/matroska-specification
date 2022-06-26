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
