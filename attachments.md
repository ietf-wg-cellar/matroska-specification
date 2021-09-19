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

To associate a font file with a subtitle track, the font file **MUST** be stored as an Attachment
within the same Segment.

The font names in subtitle codec, such as SubStation Alpha (SSA/ASS), are usually the name of the
font once it's installed on the system.
But since loading fonts temporarily can take a while, a Matroska Player usually
installs all the fonts found in attachments so they are ready to be used during playback.
If a selected subtitle track has some `AttachmentLink` elements, the player **MAY** install only these fonts.

A font found in the attachments **SHOULD** have priority over a system font with the same name,
when the system allows it.

If the subtitle encoding requires fonts that use names of fonts not contained in the attachments,
then the Matroska Reader **SHOULD**
attempt to find a system font to use with the subtitle track.
Failure to use the font attachment might result in incorrect rendering of the subtitles.

MIME types stored in `FileMimeType` that **MUST** be interpreted as fonts are:

* MIME types with the "font" top-level media type, i.e. starting with "font/" [@!RFC8081]
* `application/x-truetype-font`
* `application/x-font-ttf`
