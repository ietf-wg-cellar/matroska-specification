# Tags

## Tags Precedence

Tags allow tagging all kinds of Matroska parts with very detailed metadata in multiple languages.

Some Matroska elements also contain their own string value, like the track `Name` element ((#name-element)) or the `ChapString` element ((#chapstring-element)).

The following Matroska elements can also be defined with tags:

* The track `Name` element ((#name-element)) corresponds to a tag with the `TagTrackUID` ((#tagtrackuid-element)) set to the given track, a `TagName` of `TITLE` ((#tagname-element)), and a `TagLanguage` ((#taglanguage-element)) or `TagLanguageBCP47` ((#taglanguagebcp47-element)) of "und".

* The `ChapString` element ((#chapstring-element)) corresponds to a tag with the `TagChapterUID` ((#tagchapteruid-element)) set to the same chapter UID, a `TagName` of `TITLE` ((#tagname-element)), and a `TagLanguage` ((#taglanguage-element)) or `TagLanguageBCP47` ((#taglanguagebcp47-element)) matching the `ChapLanguage` ((#chaplanguage-element)) or `ChapLanguageBCP47` ((#chaplanguagebcp47-element)), respectively.

* The `FileDescription` element ((#filedescription-element)) of an attachment corresponds to a tag with the `TagAttachmentUID` ((#tagattachmentuid-element)) set to the given attachment, a `TagName` of `TITLE` ((#tagname-element)), and a `TagLanguage` ((#taglanguage-element)) or `TagLanguageBCP47` ((#taglanguagebcp47-element)) of "und".

When both values exist in the file, the value found in Tags takes precedence over the value found in the original location of the element.
For example, if you have a `TrackEntry\Name` element and a tag value `TITLE` for that track in a Matroska `Segment`, the tag value string **SHOULD** be used instead of the `TrackEntry\Name` string to identify the track.

As the Tag element is optional, a lot of `Matroska Readers` do not
handle it and will not use the tags value when it's found.  Thus, for maximum
compatibility, it's usually better to put the strings in the
`TrackEntry`, `ChapterAtom`, and `Attachments` elements
and keep the tags matching these values if tags are also used.

## Tag Levels

Tag elements allow tagging information on multiple levels, with each level having a `TargetTypeValue` ((#targettypevalue-element)).
An element for a given `TargetTypeValue` also applies to the lower levels denoted by smaller `TargetTypeValue` values. If an upper value
doesn't apply to a level but the actual value to use is not known,
an empty `TagString` ((#tagstring-element)) or an empty `TagBinary` ((#tagbinary-element)) **MUST** be used as the tag value for this level.

See [@?I-D.ietf-cellar-tags] for more details on common tag names, types, and descriptions.

