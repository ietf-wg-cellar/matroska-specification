# Tagging

When a `SimpleTag` is nested within another `SimpleTag`, the nested `SimpleTag` becomes an attribute of its parent `SimpleTag`.
For instance, if you wanted to store the dates that a singer started being the lead performer,
then your `SimpleTag` tree would look something like this:

* Targets

  * TagTrackUID = {track UID of tagged content}.

* ARTIST = "Band Name"

  * LEAD_PERFORMER = "John Doe"

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
      <TagString>Band Name</TagString>

      <!-- sub tag(s) about the ARTIST -->
      <SimpleTag>
        <TagName>LEAD_PERFORMER</TagName>
        <TagString>John Doe</TagString>

        <!-- sub tag(s) about the LEAD_PERFORMER -->
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

## Why Assigned Tags Matter

There is a debate between people who think all tags should be free-form and those who think
all tags should be limited to a set of names. Our recommendations are in between.

An application intended for advanced users might permit the insertion of any
tag in a file. While this provides maximum flexibility, custom or exotic tags
generally limit interoperable use. Well-known tags improve the ability of
others to read and reuse them; most applications will therefore use a small
list of useful tags.

So hopefully, when someone wants to put information in one's file, they will find an
assigned one, i.e., found in the IANA Matroska Tags Names registry (#matroska-tags-names-registry), that fits their need and hopefully use it. If it is not in the list, this person
can try to add a new tag in the registry.
This registry is not meant to have every possible information in a file.
Matroska files are not meant to become a whole database of people who made
costumes for a film. A website would be better for that. It's hard to define what should
be in and what ought not be in a file because it doesn't make sense; thus, each request needs to be evaluated to determine if it
makes sense to be carried over in a file for storage and/or sharing or if it doesn't belong there.

We also need an assigned list simply for developers to be able to display relevant information
in their own design, if they choose to support a list of meta-information they should know
which tag has the wanted meaning so that other apps could understand the same meaning.

## Tag Formatting

### TagName Formatting

Assigned `TagName` values **MUST** consist of UTF-8 capital letters, numbers and the underscore character '_'.

Assigned `TagName` values **MUST NOT** contain any space.

Assigned `TagName` values **MUST NOT** start with the underscore character '_'; see (#why-assigned-tags-matter).

It is **RECOMMENDED** that tag names start with the underscore character '_' for unassigned tags that are not meant to be added to the list of assigned tags.

### TagString Formatting

Although tags are metadata mostly used for reading, there are cases where the string value could
be used for sorting, categorization, etc. For this reason, when possible, strict formatting
of the value should be used to improve interoperability.

Multiple items **SHOULD NOT** be stored as a list in a single `TagString`. If there is more
than one tag value with the same name to be stored,
it is **RECOMMENDED** to use separate `SimpleTag`s with that name for each value.

Preexisting files may have used multiple values in the same `TagString` but given there is no
defined delimiters they cannot be easily split into multiple elements.
`INSTRUMENTS` ((#nested-information)) and `KEYWORDS` ((#search-and-classification)) tags allow using a comma as a separator.
However, it is **RECOMMENDED** to use separate `SimpleTag`s with each containing a single instrument or keyword value, respectively.

Due to the varied nature of tag sources it may also not always possible to know programmatically
whether a value is a list that must be split or not.

#### Date Tags Formatting

`TagString` fields defined in this document with dates **MUST** have the following format: "YYYY-MM-DD hh:mm:ss.mss" or a reduced version.
The format is similar to the [@?ISO8601] date and time format defined in [@RFC3339, section A]
without the "T" separator, without the time offset and with the addition of the milliseconds "mss".
The date and times represented are in Coordinated Universal Time (UTC).

Date and times are usually not precise to a particular millisecond.
To store less accurate dates, parts of the date string are removed starting from the right.
For instance, to store only the year, one would use "2004".
To store a specific day such as May 1st, 2003, one would use "2003-05-01".

The syntax of this `tags-date-time` is defined using this Augmented Backus-Naur Form
(ABNF) [@!RFC5234]:

```abnf
   time-hour         = 2DIGIT ; 00-24
   time-minute       = 2DIGIT ; 00-59
   time-second       = 2DIGIT ; 00-58, 00-59, 00-60 based on
                              ; leap-second rules
   time-millisecond  = 3DIGIT ; 000-999

   timespec-hour     = time-hour
   timespec-minute   = timespec-hour ":" time-minute
   timespec-second   = timespec-minute ":" time-second
   timespec-milli    = timespec-second "." time-millisecond

   time              = timespec-hour / timespec-minute
                       / timespec-second / timespec-milli

   date-fullyear   = 4DIGIT  ; 0000-9999
   date-month      = 2DIGIT  ; 01-12
   date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
                             ; month/year

   datespec-year     = date-fullyear
   datespec-month    = datespec-year "-" date-month
   datespec-full     = datespec-month "-" date-mday
   datespec-time     = datespec-full " " time

   tags-date-time    = datespec-time / datespec-full
                       / datespec-month / datespec-year
```

#### Number Tags Formatting

`TagString` fields that require a floating-point number **MUST** use the "." mark instead of the "," mark.
Only ASCII numbers "0" to "9" and the "." character **MUST** be used.
The "." separator represents the boundary between the integer value and the decimal parts.
If the string doesn't contain the "." separator, the value is an integer value.
Digit grouping delimiters **MUST NOT** be used.

To display it differently for another locale, it is **RECOMMENDED** that applications support auto
replacement on display. The thousand separator **MAY** be inserted for display purposes. The decimal
separator "." **MAY** be replaced to match the user locale for display purposes.

In legacy media containers, it is possible that the "," character might have been used as a separator
or that digit grouping delimiters might have been used. A `Matroska Reader` **SHOULD** consider the following
character handling to parse such legacy formats:

* if multiple instances of the same non-number character are found, they are be ignored,
* if only one "." character is found and no other non-number character is found, the "." is the integer-decimal separator,
* if only one "," character is found and no other non-number character is found, the "," is a digit grouping delimiter,
* any other non-number character is ignored.

#### Country Code Tags Formatting

`TagString` fields that use a Country Code **MUST** use the Matroska countries form defined in [@!RFC9559, section 13],
i.e., [@!RFC5646] two-letter region subtags, without the UK exception.

## Target Types

The `TargetTypeValue` element allows tagging of different parts that are within or outside a
given file. For example, in an audio file with one song you could have information about
the CD set album it comes from, even if the whole CD set is not found in the file.

For applications to know the kind of information (e.g., "TITLE") relates to a certain level
(CD title or track title), we also need a set of official `TargetTypeValue` values and `TargetType` names.
That also means the same tag name can
have different meanings depending on its `TargetTypeValue`, otherwise we would end up with 7 "TITLE_" tag names.

For human readability a `TargetType` string can be added next to the corresponding `TargetTypeValue`.
Audio and video have different `TargetType` values.
The following table summarizes the `TargetType` values found in [@!RFC9559, section 5.1.8.1.1.2]
for audio and video content:

TargetTypeValue | Audio TargetType                | Comment
----------------|:--------------------------------|:----
70              | COLLECTION                      | the high hierarchy consisting of many different lower items
60              | EDITION / ISSUE / VOLUME / OPUS | a list of lower levels grouped together
50              | ALBUM / OPERA / CONCERT         | the most common grouping level of music (e.g., an album)
40              | PART / SESSION                  | when an album has different logical parts
30              | TRACK / SONG                    | the common parts of an album
20              | SUBTRACK / PART / MOVEMENT      | corresponds to parts of a track for audio (e.g., a movement)
10              | -                               | the lowest hierarchy found in music
Table: TargetTypeValue Values Audio Semantic Description

TargetTypeValue | Video TargetType          | Comment
----------------|:--------------------------|:-------
70              | COLLECTION                | the high hierarchy consisting of many different lower items
60              | SEASON / SEQUEL / VOLUME  | a list of lower levels grouped together
50              | MOVIE / EPISODE / CONCERT | the most common grouping level of video (e.g., an episode for TV series)
40              | PART / SESSION            | when an episode has different logical parts
30              | CHAPTER                   | the common parts of a movie or episode
20              | SCENE                     | a sequence of continuous action in a film or video
10              | SHOT                      | the lowest hierarchy found in movies
Table: TargetTypeValue Values Video Semantic Description

A tag defined for a given `TargetTypeValue` also applies to all Targets with
numerically smaller `TargetTypeValue`s in the same hierarchy, that is, from
higher-level groups to lower-level entities. This means that if a CD has the same
artist for all tracks, you just need to set the "ARTIST" tag at `TargetTypeValue` 50 (ALBUM) and not
to each `TargetTypeValue` 30 (TRACK), but you can also repeat the value for each track.
If some tracks of that CD have no known
"ARTIST", the value **MUST** be set to an empty string ("") as detailed in [@!RFC9559, section 24.2],
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

These tags allow specifying the ordering of some tags within another group of tags.

For example if you have an album with 10 tracks and you want to tag the second track from it.
You set "TOTAL_PARTS" to "10" at `TargetTypeValue` 50 (ALBUM). It means the "ALBUM" contains 10 lower parts.
The lower part in question is the first lower `TargetTypeValue` that is specified in the file.
So, if it's `TargetTypeValue` = 30 (TRACK), then that means the album contains 10 tracks.
If `TargetTypeValue` is 20 (MOVEMENT), that means the album contains 10 movements, etc.
And since it's the second track within the album, the "PART_NUMBER" at `TargetTypeValue` 30 (TRACK) is set to "2".

If the parts are split into multiple logical entities, you can also use "PART_OFFSET".
For example you are tagging the third track of the second CD of a double CD album with a total of 10 tracks
the "TOTAL_PARTS" at `TargetTypeValue` 50 (ALBUM) is "10",
the "PART_NUMBER" at `TargetTypeValue` 30 (TRACK) is "3",
and the the "PART_OFFSET" at `TargetTypeValue` 30 (TRACK) is "5", which is the number of tracks on the first CD.

When a `TargetTypeValue` level doesn't exist it **MUST NOT** be specified in the files, so that the "TOTAL_PARTS"
and "PART_NUMBER" elements match the same levels.

Here is an example of an audio record with 2 tracks in a single file. The name of the record is also the name of the first track "Main Title".
There is one `Tag` element for the record, and one `Tag` element per track on the record.
Each track is identified by a chapter.

The `Tag` for the record:

* Targets

  * TargetTypeValue = 50

* ARTIST = "Dummy Artist Name"

* TITLE = "Main Title"

* TOTAL_PARTS = "2"

The `Tag` for the first track:

* Targets

  * TargetTypeValue = 30

  * TagChapterUID = 12345

* TITLE = "Main Title"

* PART_NUMBER = "1"

The `Tag` for the second track:

* Targets

  * TargetTypeValue = 30

  * TagChapterUID = 67890

* TITLE = "B-side Track Name"

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
      <TagString>Dummy Artist Name</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>TITLE</TagName>
      <TagString>Main Title</TagString>
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
      <TagString>Main Title</TagString>
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
      <TagString>B-side Track Name</TagString>
    </SimpleTag>

    <SimpleTag>
      <TagName>PART_NUMBER</TagName>
      <TagString>2</TagString>
    </SimpleTag>
  </Tag>
</Tags>
```

Here is an example using the "PART_OFFSET" tag. It corresponds to a file that contains
the third track on the second CD of the 2-CD album:

The `Tag` for the album:

* Targets

  * TargetTypeValue = 50

* ARTIST = "The Album Artist"

  * SORT_WITH = "Album Artist, The"

* TITLE = "Album Title"

* TOTAL_PARTS = "10"

The `Tag` for the third track of the second CD:

* Targets

  * TargetTypeValue = 30

* TITLE = "Some Track Title"

* PART_NUMBER = "3"

* PART_OFFSET = "5"


This corresponds to this layout of EBML elements:
```xml
<Tags>
 <!-- description of the whole album -->
 <Tag>
  <Targets>
   <TargetTypeValue>50</TargetTypeValue>
  </Targets>

  <SimpleTag>
   <TagName>ARTIST</TagName>
   <TagString>The Album Artist</TagString>

   <SimpleTag>
    <TagName>SORT_WITH</TagName>
    <TagString>Album Artist, The</TagString>
   </SimpleTag>
  </SimpleTag>

  <SimpleTag>
   <TagName>TITLE</TagName>
   <TagString>Album Title</TagString>
  </SimpleTag>

  <!-- the number of sub elements in this album (10 tracks) -->
  <SimpleTag>
   <TagName>TOTAL_PARTS</TagName>
   <TagString>10</TagString>
  </SimpleTag>
 </Tag>

 <!-- description of the third track of the second CD -->
 <Tag>
  <Targets>
   <TargetTypeValue>30</TargetTypeValue>
  </Targets>

  <SimpleTag>
   <TagName>TITLE</TagName>
   <TagString>Some Track Title</TagString>
  </SimpleTag>

  <!-- This is the third track of the second CD -->
  <SimpleTag>
   <TagName>PART_NUMBER</TagName>
   <TagString>3</TagString>
  </SimpleTag>

  <!-- The first CD contains 5 tracks -->
  <SimpleTag>
   <TagName>PART_OFFSET</TagName>
   <TagString>5</TagString>
  </SimpleTag>
 </Tag>
</Tags>
```

## Multiple Targets UID

A `Tag` element has a single `Targets` element with a single `TargetTypeValue` element.
However, the `Targets` element can contain various `TagTrackUID`, `TagEditionUID`, `TagChapterUID` and `TagAttachmentUID` elements.

When multiple values are found using the same Tag UID element (e.g., `TagTrackUID`)
a logical OR is applied on these elements.
In other words the tags apply to each entity defined by a UID.
This is the list of UIDs the tags apply to (e.g., list of `TagTrackUID`).
Such a list may contain a single UID element.

When different lists of Tag UID elements are found (e.g., a list of `TagTrackUID` and a list of `TagChapterUID`)
a logical AND is applied between those lists.
In other words the tags apply only to the entities matching a UID in each list of Tag UID elements.

These operations allow factorizing tags that would otherwise need to be repeated multiple times.

Here is an example of a `Tag` applying to 2 chapters, using the same example as in (#target-types-parts):

* Targets

  * TargetTypeValue = 30

  * TagChapterUID = 12345

  * TagChapterUID = 67890

* WRITTEN_BY = "John Doe"

* WRITTEN_BY = "Jane Smith"

* PRODUCER = "John Doe"

* PRODUCER = "Jane Smith"


This corresponds to this layout of EBML elements:
```xml
<Tags>
  <Tag>
    <Targets>
      <TargetTypeValue>30</TargetTypeValue>

      <!-- chapter with Main Title -->
      <TagChapterUID>12345</TagChapterUID>

      <!-- chapter with B-side Track Name -->
      <TagChapterUID>67890</TagChapterUID>
    </Targets>

    <!-- first writer of Main Title and B-side Track Name -->
    <SimpleTag>
      <TagName>WRITTEN_BY</TagName>
      <TagString>John Doe</TagString>
    </SimpleTag>

    <!-- second writer of Main Title and B-side Track Name -->
    <SimpleTag>
      <TagName>WRITTEN_BY</TagName>
      <TagString>Jane Smith</TagString>
    </SimpleTag>

    <!-- first producer of Main Title and B-side Track Name -->
    <SimpleTag>
      <TagName>PRODUCER</TagName>
      <TagString>John Doe</TagString>
    </SimpleTag>

    <!-- second producer of Main Title and B-side Track Name -->
    <SimpleTag>
      <TagName>PRODUCER</TagName>
      <TagString>Jane Smith</TagString>
    </SimpleTag>
  </Tag>
</Tags>
```

Some combinations of different Tag UID elements are not possible.

A `TagChapterUID` and `TagAttachmentUID` can't be mixed because there is no overlap
with a Chapter and an Attachment that would make sense.
An attachment applies to the whole segment and can be tied to tracks,
via `\Segment\Tracks\TrackEntry\AttachmentLink` as defined in [@!RFC9559, section 5.1.4.1.24], but not chapters.

Mixing `TagEditionUID` and `TagChapterUID` elements is also not useful because each Chapter UID
would need to be in one of the Chapter Edition UID.
That would be the same as not using the list of `TagEditionUID` at all.

The following table shows the allowed combinations between lists of Tag UID elements:

UID elements | Track | Edition | Chapter | Attachment
:----------|:------------|:--------------|:--------------|:---------------
Track      | YES | YES | YES | with matching AttachmentLink
Edition    | YES | YES | NO  | YES
Chapter    | YES | NO  | YES | NO
Attachment | with matching AttachmentLink | YES | NO  | YES
Table: Tag UID elements allowed combinations{#taguid-combinations}

Here is an example of a `Tag` applying to a single track and a single chapter.
It represents the composer of the music in a part of a movie.
The file may contain a second audio track with audio commentary not including that music,
so we only tag the track with the music.

* Targets

  * TargetTypeValue = 30

  * TagTrackUID = 123

  * TagChapterUID = 987654321

* COMPOSER = "Jane Smith"

This corresponds to this layout of EBML elements:
```xml
<Tags>
  <Tag>
    <Targets>
      <TargetTypeValue>30</TargetTypeValue>

      <!-- chapter with the music -->
      <TagTrackUID>123</TagTrackUID>

      <!-- track with the music -->
      <TagChapterUID>67890</TagChapterUID>
    </Targets>

    <!-- composer of the music in that chapter for that track -->
    <SimpleTag>
      <TagName>COMPOSER</TagName>
      <TagString>Jane Smith</TagString>
    </SimpleTag>

  </Tag>
</Tags>
```


# Assigned Tags

The following is the initial list of assigned Matroska Tags.
As stated in (#why-assigned-tags-matter) it is better to use assigned tags as much as possible,
otherwise compatibility will
be compromised. If you find that there is a Tag missing that you would like to use,
then please contact the persons mentioned in the IANA Matroska Tags Registry for its inclusion; see (#matroska-tags-names-registry).

