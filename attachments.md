---
title: Attachments
---

# Attachments

Matroska supports storage of related files and data in the `Attachments Element`
(a `Top-Level Element`). `Attachment Elements` can be used to store related cover art,
font files, transcripts, reports, error recovery files, picture, or text-based annotations,
copies of specifications, or other ancillary files related to the `Segment`.

`Matroska Readers` **MUST NOT** execute files stored as `Attachment Elements`.

## Cover Art

This section defines a set of guidelines for the storage of cover art in Matroska files.
A `Matroska Reader` **MAY** use embedded cover art to display a representational
still-image depiction of the multimedia contents of the Matroska file.

Only JPEG and PNG image formats **SHOULD** be used for cover art pictures.

There can be two different covers for a movie/album: a portrait style (e.g., a DVD case)
and a landscape style (e.g., a wide banner ad).

There can be two versions of the same cover, the `normal cover` and the `small cover`.
The dimension of the `normal cover` **SHOULD** be 600 pixels on the smallest side -- for example,
960x600 for landscape, 600x800 for portrait, or 600x600 for square. The dimension of
the `small cover` **SHOULD** be 120 pixels on the smallest side -- for example, 192x120 or 120x160.

Versions of cover art can be differentiated by the filename, which is stored in the
`FileName Element`. The default filename of the `normal cover` in square or portrait mode
is `cover.(jpg|png)`. When stored, the `normal cover` **SHOULD** be the first Attachment in
storage order. The `small cover` **SHOULD** be prefixed with "small_", such as
`small_cover.(jpg|png)`. The landscape variant **SHOULD** be suffixed with "\_land",
such as `cover_land.(jpg|png)`. The filenames are case sensitive.

The following table provides examples of file names for cover art in Attachments.

| FileName             | Image Orientation  | Pixel Length of Smallest Side |
|----------------------|--------------------|-------------------------------|
| cover.jpg            | Portrait or square | 600                           |
| small_cover.png      | Portrait or square | 120                           |
| cover_land.png       | Landscape          | 600                           |
| small_cover_land.jpg | Landscape          | 120                           |
Table: Cover Art Filenames{#coverartFilenames}

## Font files

Font files **MAY** be added to a Matroska file as Attachments so that the font file may be used
to display an associated subtitle track. This allows the presentation of a Matroska file to be
consistent in various environments where the needed fonts might not be available on the local system.

Depending on the font format in question, each font file can contain multiple font variants.
Each font variant has a name which will be referred to as Font Name from now on.
This Font Name can be different than the Attachment's `FileName`, even when disregarding the extension.
In order to select a font for display, a Matroska player **SHOULD** consider both the Font Name
and the base name of the Attachment's FileName, preferring the former when there are multiple matches.

Subtitle codecs, such as SubStation Alpha (SSA/ASS), usually refer to a font by its Font Name, not
by its filename.
If none of the Attachments are a match for the Font Name, the Matroska player **SHOULD**
attempt to find a system font whose Font Name matches the one used in the subtitle track.

Since loading fonts temporarily can take a while, a Matroska player usually
loads or installs all the fonts found in attachments so they are ready to be used during playback.
Failure to use the font attachment might result in incorrect rendering of the subtitles.

If a selected subtitle track has some `AttachmentLink` elements, the player **MAY** use only these fonts.

A Matroska player **SHOULD** handle the official font MIME types from [@!RFC8081] when the system can handle the type:
* `font/sfnt`: Generic SFNT Font Type,
* `font/ttf`: TTF Font Type,
* `font/otf`: OpenType Layout (OTF) Font Type,
* `font/collection`: Collection Font Type,
* `font/woff`: WOFF 1.0,
* `font/woff2`: WOFF 2.0.

Fonts in Matroska existed long before [@!RFC8081]. A few unofficial MIME types for fonts were used in existing files.
Therefore it is **RECOMMENDED** for a Matroska player to support the following legacy MIME types for font attachments:

* `application/x-truetype-font`: Truetype fonts, equivalent to `font/ttf` and sometimes `font/otf`,
* `application/x-font-ttf`: TTF fonts, equivalent to `font/ttf`,
* `application/vnd.ms-opentype`: OpenType Layout fonts, equivalent to `font/otf`
* `application/font-sfnt`: Generic SFNT Font Type, equivalent to `font/sfnt`
* `application/font-woff`: WOFF 1.0, equivalent to `font/woff`


There may also be some font attachments with the `application/octet-stream` MIME type.
In that case the Matroska player **MAY** try to guess the font type by checking the file extension of the `AttachedFile\FileName` string.
Common file extensions for fonts are:
* `.ttf` for Truetype fonts, equivalent to `font/ttf`,
* `.otf` for OpenType Layout fonts, equivalent to `font/otf`,
* `.ttc` for Collection fonts, equivalent to `font/collection`
The file extension check **MUST** be case insensitive.

Matroska writers **SHOULD** use a valid font MIME type from [@!RFC8081] in the `AttachedFile\FileMediaType` of the font attachment.
They **MAY** use the MIME types found in older files when compatibility with older players is necessary.

