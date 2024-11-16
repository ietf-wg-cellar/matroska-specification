# Tagging

When a `SimpleTag` is nested within another `SimpleTag`, the nested `SimpleTag` becomes an attribute of its parent `SimpleTag`.
For instance, if you wanted to store the dates that a singer started being the lead performer,
then your `SimpleTag` tree would look something like this:

* Targets

  * TagTrackUID = {track UID of tagged content}.

* ARTIST = "Pet Shop Boys"

  * LEAD_PERFORMER = "Neil Tennant"

    * DATE_STARTED = "1981-08"

This corresponds to this layout of EBML elements:
```xml
<Tags>
  <Tag>
    <Targets>
      <TagTrackUID>{track UID of tagged content}</TagTrackUID>
    </Targets>

    <SimpleTag>
      <TagName>ARTIST</TagName>
      <TagString>Pet Shop Boys</TagString>

      <SimpleTag>
        <TagName>LEAD_PERFORMER</TagName>
        <TagString>Neil Tennant</TagString>

        <SimpleTag>
          <TagName>DATE_STARTED</TagName>
          <TagString>1981-08</TagString>
        </SimpleTag>

      </SimpleTag>

    </SimpleTag>
  </Tag>
</Tags>
```

In this way, it becomes possible to store any `SimpleTag` as attributes of another `SimpleTag`.

Multiple items **SHOULD** never be stored as a list in a single `TagString`. If there is more
than one tag value with the same name to be stored, then more than one `SimpleTag` **SHOULD** be used.

## Why Official Tags Matter

There is a debate between people who think all tags **SHOULD** be free and those who think
all tags **SHOULD** be strict. Our recommendations are in between.

Advanced-users application might let you put any tag in your file. But for the rest of
the applications, they usually give you a basic list of tags you can use. Both have their
needs. But it's usually a bad idea to use custom/exotic tags because you will probably
be the only person to use this information even though everyone else could benefit from it.
So hopefully, when someone wants to put information in one's file, they will find an
official one that fits their need and hopefully use it. If it's not in the list, this person
can try get a new tag in the Matroska Tags Names registry ((#matroska-tags-names-registry)).
This registry is not meant to have every possible information in a file.
Matroska files are not meant the become a whole database of people who made
costumes for a film. A website would be better for that. It's hard to define what should
be in and what doesn't make sense in a file; thus, each demand needs to balance if it
makes sense to be carried over in a file for storage and/or sharing or if it doesn't belong there.

We also need an official list simply for developers to be able to display relevant information
in their own design, if they choose to support a list of meta-information they should know
which tag has the wanted meaning so that other apps could understand the same meaning.

## Tag Formatting

### TagName Formatting

Official `TagName` values **MUST** consist of UTF-8 capital letters, numbers and the underscore character '_'.

Official `TagName` values **MUST NOT** contain any space.

Official `TagName` values **MUST NOT** start with the underscore character '_'; see (#why-official-tags-matter).

### TagString Formatting

Although tags are metadata mostly used for reading, there are cases where the string value could
be used for sorting, categorization, etc. For this reason, when possible, strict formatting
of the value should be used so everyone can agree on how to use the value.

Due to preexisting files where these formatting rules were not explicit, they are usually
presented as rules that **SHOULD** be applied when possible, rather than **MUST** be applied
at all times. It is **RECOMMENDED** to use strict formatting when writing new tag values.

#### Date Tags Formatting

`TagString` fields with dates **SHOULD** have the following format: "YYYY-MM-DD hh:mm:ss.mss".
This is similar to the ISO8601 date and time format defined in [@RFC3339, appendix A] of [@RFC9559]
without the "T" separator, without the time offset and with the addition of the milliseconds "mss".
The date and times represented are in Coordinated Universal Time (UTC).

Date and times are usually not precise to a particular millisecond.
To store less accurate dates, parts of the date string are removed starting from the right.
For instance, to store only the year, one would use "2004".
To store a specific day such as May 1st, 2003, one would use "2003-05-01".

#### Number Tags Formatting

`TagString` fields that require a Float **SHOULD** use the "." mark instead of the "," mark.
Only ASCII numbers "0" to "9" and the "." character **SHOULD** be used.
The "." separator represent the boundary between the integer value and the decimal parts.
If the string doesn't contain the "." separator, the value is an integer value.
Thousandths separators **SHOULD NOT** be used.

To display it differently for another local, applications **SHOULD** support auto
replacement on display.

#### Country Code Tags Formatting

`TagString` fields that use a Country Code **SHOULD** use the Matroska countries form defined in [@!RFC9559, section 13],
i.e. [@!RFC5646] two-letter region subtags, without the UK exception

## Target Types

The `TargetTypeValue` element allows tagging of different parts that are inside or outside a
given file. For example, in an audio file with one song you could have information about
the album it comes from and even the CD set even if it's not found in the file.

For applications to know the kind of information (like "TITLE") relates to a certain level
(CD title or track title), we also need a set of official `TargetTypeValue` values and `TargetType` names.
That also means the same tag name can
have different meanings depending on where it is, otherwise we would end up with 7 "TITLE_" tag names.

For human readability a `TargetType` string can be added next to the corresponding `TargetTypeValue`.
Audio and video have different `TargetType` values.
The following table summarizes the `TargetType` values found in [@!RFC9559, section 5.1.8.1.1.2]:

TargetTypeValue | Audio TargetType                | Video TargetType          | Comment
----------------|:--------------------------------|:--------------------------|:-------
70              | COLLECTION                      | COLLECTION                | the high hierarchy consisting of many different lower items
60              | EDITION / ISSUE / VOLUME / OPUS | SEASON / SEQUEL / VOLUME  | a list of lower levels grouped together
50              | ALBUM / OPERA / CONCERT         | MOVIE / EPISODE / CONCERT | the most common grouping level of music and video (e.g., an episode for TV series)
40              | PART / SESSION                  | PART / SESSION            | when an album or episode has different logical parts
30              | TRACK / SONG                    | CHAPTER                   | the common parts of an album or a movie
20              | SUBTRACK / PART / MOVEMENT      | SCENE                     | corresponds to parts of a track for audio (like a movement)
10              | -                               | SHOT                      | the lowest hierarchy found in music or movies
Table: TargetTypeValue Values Semantic Description

Tags from a `TargetTypeValue` apply to the all lower `TargetTypeValues`. This means that if a CD has the same
artist for all tracks, you just need to set the "ARTIST" tag at `TargetTypeValue` 50 (ALBUM) and not
to each `TargetTypeValue` 30 (TRACK), but you can also repeat the value for each track.
If some tracks of that CD have no known
"ARTIST", the value **MUST** be set to nothing, a void string "" as detailed in [@!RFC9559, section 24.2],
so that the album "ARTIST" doesn't apply.

If a tag with a given `TagName` is found at a `TargetTypeValue`,
only values of that `TagName` are valid at that `TargetTypeValue` level.
In other words, the `TagName` values from upper `TargetTypeValue` levels don't apply at that level.

Multiple `SimpleTag` with the same `TagName` can be used at a given `TargetTypeValue` level when each `SimpleTag` contain a `TagString`.
For example this can be useful to find a single "ARTIST" even when they are found in a collaboration.
The concatenation of each `TagString` represents the value for the `TagName` at this level.
The presentation, for instance with a separator, is up to the application.

### Target Types Parts

There are three organizational tags defined in (#organization-information):

- TOTAL_PARTS

- PART_NUMBER

- PART_OFFSET

These tags allow specifying the ordering of some tags within a another group of tags.

For example if you have an album with 10 tracks and you want to tag the second track from it.
You set "TOTAL_PARTS" to "10" at `TargetTypeValue` 50 (ALBUM). It means the "ALBUM" contains 10 lower parts.
The lower part in question is the first lower `TargetTypeValue` that is specified in the file.
So, if it's `TargetTypeValue` = 30 (TRACK), then that means the album contains 10 tracks.
If `TargetTypeValue` is 20 (MOVEMENT), that means the album contains 10 movements, etc.
And since it's the second track within the album, the "PART_NUMBER" at `TargetTypeValue` 30 (TRACK) is set to "2".

If the parts are split into multiple logical entities, you can also use "PART_OFFSET".
For example you are tagging the third track of the second CD of a double CD album with a total of 10 tracks
-- like The Orb's Adventures Beyond The Ultraworld [@?OrbUltraworld] --
the "TOTAL_PARTS" at `TargetTypeValue` 50 (ALBUM) is "10",
the "PART_NUMBER" at `TargetTypeValue` 30 (TRACK) is "3",
and the the "PART_OFFSET" at `TargetTypeValue` 30 (TRACK) is "5", which is the number of tracks on the first CD.

When a `TargetTypeValue` level doesn't exist it **MUST NOT** be specified in the files, so that the "TOTAL_PARTS"
and "PART_NUMBER" elements match the same levels.

Here is an example of an audio record with 2 tracks in a single file.
There is one `Tag` element for the record, and one `Tag` element per track on the record.
Each track being identified by a chapter.

The `Tag` for the record:

* Targets

  * TargetTypeValue = 50

* ARTIST = "Daft Punk"

* TITLE = "Da Funk"

* TOTAL_PARTS = "2"

The `Tag` for the first track:

* Targets

  * TargetTypeValue = 30

  * TagChapterUID = 12345

* TITLE = "Da Funk"

* PART_NUMBER = "1"

The `Tag` for the second track:

* Targets

  * TargetTypeValue = 30

  * TagChapterUID = 67890

* TITLE = "Rollin' &amp; Scratchin'"

* PART_NUMBER = "2"

This corresponds to this layout of EBML elements:
```xml
<Tags>
  <!-- description of the whole file/record -->
  <Tag>
    <Targets>
      <TargetTypeValue>50</TargetTypeValue>
    </Targets>

    <SimpleTag>
      <TagName>ARTIST</TagName>
      <TagString>Daft Punk</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>TITLE</TagName>
      <TagString>Da Funk</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>TOTAL_PARTS</TagName>
      <TagString>2</TagString>
    </SimpleTag>
  </Tag>

  <!-- description of the first track/chapter -->
  <Tag>
    <Targets>
      <TargetTypeValue>30</TargetTypeValue>
      <TagChapterUID>12345</TagChapterUID>
    </Targets>

    <SimpleTag>
      <TagName>TITLE</TagName>
      <TagString>Da Funk</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>PART_NUMBER</TagName>
      <TagString>1</TagString>
    </SimpleTag>
  </Tag>

  <!-- description of the second track/chapter -->
  <Tag>
    <Targets>
      <TargetTypeValue>30</TargetTypeValue>
      <TagChapterUID>67890</TagChapterUID>
    </Targets>

    <SimpleTag>
      <TagName>TITLE</TagName>
      <TagString>Rollin' & Scratchin'</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>PART_NUMBER</TagName>
      <TagString>2</TagString>
    </SimpleTag>
  </Tag>
</Tags>
```


# Official Tags

The following is a complete list of the supported Matroska Tags. While it is possible
to use Tag names that are not listed below, this is **NOT RECOMMENDED** as compatibility will
be compromised. If you find that there is a Tag missing that you would like to use,
then please contact the persons mentioned in the IANA Matroska Tags Registry for its inclusion; see (#matroska-tags-names-registry).

