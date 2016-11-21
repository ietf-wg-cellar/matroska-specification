---
layout: default
---

# Attachments

## Introduction

Matroska supports storage of related files and data in the Attachments Top-Level Element. Attachments can be used to store related cover art, font files, transcripts, reports, error recovery files, picture or text-based annotations, copies of specifications, or other ancilliary files related to the Segment.

## Cover Art

This section defines a set of guidelines for the storage of cover art in Matroska files. A `Matroska Reader` MAY use embedded cover art to display a representation still-image depiction of the multimedia contents of the Matroska file.

Cover art SHOULD only use the JPEG and PNG picture formats.

There can be 2 different covers for a movie/album. A portrait one (like a DVD case) and a landscape one (like a banner ad for example, looking better on a wide screen).

There can be 2 versions of the same cover, the `normal cover` and the `small cover`. The dimension of the `normal cover` SHOULD be 600 on the smallest side (for example, 960x600 for landscape, 600x800 for portrait, or 600x600 for square). The dimension of the `small cover` SHOULD be 120 on the smallest side (for example, 192x120 or 120x160).

Versions of cover art can be differentiated by the filename, which is stored in the `FileName Element`. The default filename of the `normal cover` in square or portrait mode is `cover.(jpg|png)`. When stored, the `normal cover` SHOULD be the first Attachment in storage order. The `small cover` SHOULD be prefixed with "small_", such as `small_cover.(jpg|png)`. The landscape variant SHOULD be suffixed with "_land", such as `cover_land.(jpg|png)`. The filenames are case sensitive and SHOULD all be lower case.

The following table provides examples of file names for cover art in Attachments.

FileName             | Image Orientation  | Pixel Length of Smallest Side
---------------------|--------------------|------------------------------
cover.jpg            | Portrait or square | 600
small_cover.png      | Portrait or square | 120
cover_land.png       | Landscape          | 600
small_cover_land.jpg | Landscape          | 120

## Font files

