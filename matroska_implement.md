---
title: Matroska Implementation Recommentations
---

# Implementation Recommendations

## SeekHead

It is **RECOMMENDED** that the first `SeekHead Element` be followed by a `Void Element` to
allow for the `SeekHead Element` to be expanded to cover new `Top-Level Elements`
that could be added to the Matroska file, such as `Tags`, `Chapters`, and `Attachments` Elements.
