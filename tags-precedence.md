---
title: Tags Precedence
---

# Tags Precedence

Tags allow tagging all kinds of Matroska parts with very detailed metadata in multiple languages.

Some Matroska elements also contain their own string value like the Track Name ((#name-element)) or the Chapter String ((#chapstring-element)).

The following Matroska elements can also be defined with tags:

* The Track Name Element ((#name-element)) corresponds to a tag with the TagTrackUID ((#tagtrackuid-element)) set to the given track, a TagName of `TITLE` ((#tagname-element)) and a TagLanguage ((#taglanguage-element)) or TagLanguageBCP47 ((#taglanguagebcp47-element)) of "und".
* The Chapter String Element ((#chapstring-element)) corresponds to a tag with the TagChapterUID ((#tagchapteruid-element)) set to the same chapter UID, a TagName of `TITLE` ((#tagname-element)) and a TagLanguage ((#taglanguage-element)) or TagLanguageBCP47 ((#taglanguagebcp47-element)) matching the ChapLanguage ((#chaplanguage-element)) or ChapLanguageBCP47 ((#chaplanguagebcp47-element)) respectively.
* The FileDescription Element ((#filedescription-element)) of an attachment corresponds to a tag with the TagAttachmentUID ((#tagattachmentuid-element)) set to the given attachment, a TagName of `TITLE` ((#tagname-element)) and a TagLanguage ((#taglanguage-element)) or TagLanguageBCP47 ((#taglanguagebcp47-element)) of "und".

When both values exist in the file, the value found in Tags takes precedence over the value found in original location of the element.
For example if you have a `TrackEntry\Name` element and Tag `TITLE` for that track in a Matroska Segment, the Tag string **SHOULD** be used and not the `TrackEntry\Name` string to identify the track.

As the Tag element is optional, a lot of `Matroska Readers` do not handle it and will not use the tags value when it's found.
So for maximum compatibility, it's usually better to put the strings in the `TrackEntry`, `ChapterAtom` and `Attachment`
and keep the tags matching these values if tags are also used.

See [@?MatroskaTags] for more details on how to use tags.

