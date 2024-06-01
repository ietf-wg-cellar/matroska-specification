## Data Layout

A Matroska file **MUST** be composed of at least one `EBML Document` using the `Matroska Document Type`.
Each `EBML Document` **MUST** start with an `EBML Header` and **MUST** be followed by the `EBML Root Element`,
defined as `Segment` in Matroska. Matroska defines several `Top-Level Elements`
that may occur within the `Segment`.

As an example, a simple Matroska file consisting of a single `EBML Document` could be represented like this:

- `EBML Header`
- `Segment`

A more complex Matroska file consisting of an `EBML Stream` (consisting of two `EBML Documents`) could be represented like this:

- `EBML Header`
- `Segment`
- `EBML Header`
- `Segment`

The following diagram represents a simple Matroska file, comprised of an `EBML Document`
with an `EBML Header`, a `Segment` element (the `Root Element`), and all eight Matroska
`Top-Level Elements`. In the diagrams in this section, horizontal spacing expresses
a parent-child relationship between Matroska elements (e.g., the `Info` element is contained within
the `Segment` element), whereas vertical alignment represents the storage order within the file.

```
+-------------+
| EBML Header |
+---------------------------+
| Segment     | SeekHead    |
|             |-------------|
|             | Info        |
|             |-------------|
|             | Tracks      |
|             |-------------|
|             | Chapters    |
|             |-------------|
|             | Cluster     |
|             |-------------|
|             | Cues        |
|             |-------------|
|             | Attachments |
|             |-------------|
|             | Tags        |
+---------------------------+
```
Figure: Basic Layout of a Matroska File

The Matroska `EBML Schema` defines eight `Top-Level Elements`:

- `SeekHead` ((#seekhead))

- `Info` ((#info))

- `Tracks` ((#track-flags))

- `Chapters` ((#chapters))

- `Cluster` ((#cluster-blocks))

- `Cues` ((#cues))

- `Attachments` ((#attachments-1))

- `Tags` ((#tags))

The `SeekHead` element (also known as `MetaSeek`) contains an index of `Top-Level Elements`
locations within the `Segment`. Use of the `SeekHead` element is **RECOMMENDED**. Without a `SeekHead` element,
a Matroska parser would have to search the entire file to find all of the other `Top-Level Elements`.
This is due to Matroska's flexible ordering requirements; for instance, it is acceptable for
the `Chapters` element to be stored after the `Cluster ` element(s).

```
+--------------------------------+
| SeekHead | Seek | SeekID       |
|          |      |--------------|
|          |      | SeekPosition |
+--------------------------------+
```
Figure: Representation of a `SeekHead` Element

The `Info` element contains vital information for identifying the whole `Segment`.
This includes the title for the `Segment`, a randomly generated unique identifier (UID),
and the UID(s) of any linked `Segment` elements.

```
+-------------------------+
| Info | SegmentUUID      |
|      |------------------|
|      | SegmentFilename  |
|      |------------------|
|      | PrevUUID         |
|      |------------------|
|      | PrevFilename     |
|      |------------------|
|      | NextUUID         |
|      |------------------|
|      | NextFilename     |
|      |------------------|
|      | SegmentFamily    |
|      |------------------|
|      | ChapterTranslate |
|      |------------------|
|      | TimestampScale   |
|      |------------------|
|      | Duration         |
|      |------------------|
|      | DateUTC          |
|      |------------------|
|      | Title            |
|      |------------------|
|      | MuxingApp        |
|      |------------------|
|      | WritingApp       |
|-------------------------|
```
Figure: Representation of an `Info` Element and Its `Child Elements`

The `Tracks` element defines the technical details for each track and can store the name,
number, UID, language, and type (audio, video, subtitles, etc.) of each track.
For example, the `Tracks` element **MAY** store information about the resolution of a video track
or sample rate of an audio track.

The `Tracks` element **MUST** identify all the data needed by the codec to decode the data of the
specified track. However, the data required is contingent on the codec used for the track.
For example, a `Track` element for uncompressed audio only requires the audio bit rate to be present.
A codec such as AC-3 would require that the `CodecID` element be present for all tracks,
as it is the primary way to identify which codec to use to decode the track.

```
+------------------------------------+
| Tracks | TrackEntry | TrackNumber  |
|        |            |--------------|
|        |            | TrackUID     |
|        |            |--------------|
|        |            | TrackType    |
|        |            |--------------|
|        |            | Name         |
|        |            |--------------|
|        |            | Language     |
|        |            |--------------|
|        |            | CodecID      |
|        |            |--------------|
|        |            | CodecPrivate |
|        |            |--------------|
|        |            | CodecName    |
|        |            |----------------------------------+
|        |            | Video        | FlagInterlaced    |
|        |            |              |-------------------|
|        |            |              | FieldOrder        |
|        |            |              |-------------------|
|        |            |              | StereoMode        |
|        |            |              |-------------------|
|        |            |              | AlphaMode         |
|        |            |              |-------------------|
|        |            |              | PixelWidth        |
|        |            |              |-------------------|
|        |            |              | PixelHeight       |
|        |            |              |-------------------|
|        |            |              | DisplayWidth      |
|        |            |              |-------------------|
|        |            |              | DisplayHeight     |
|        |            |              |-------------------|
|        |            |              | AspectRatioType   |
|        |            |              |-------------------|
|        |            |              | Colour            |
|        |            |----------------------------------|
|        |            | Audio        | SamplingFrequency |
|        |            |              |-------------------|
|        |            |              | Channels          |
|        |            |              |-------------------|
|        |            |              | BitDepth          |
|--------------------------------------------------------|

```
Figure: Representation of the `Tracks` Element and a Selection of Its `Descendant` Elements

The `Chapters` element lists all of the chapters. `Chapters` are a way to set predefined
points to jump to in video or audio.

```
+-----------------------------------------+
| Chapters | Edition | EditionUID         |
|          | Entry   |--------------------|
|          |         | EditionFlagDefault |
|          |         |--------------------|
|          |         | EditionFlagOrdered |
|          |         |---------------------------------+
|          |         | ChapterAtom | ChapterUID        |
|          |         |             |-------------------|
|          |         |             | ChapterStringUID  |
|          |         |             |-------------------|
|          |         |             | ChapterTimeStart  |
|          |         |             |-------------------|
|          |         |             | ChapterTimeEnd    |
|          |         |             |-------------------|
|          |         |             | ChapterFlagHidden |
|          |         |             |-------------------------------+
|          |         |             | ChapterDisplay | ChapString   |
|          |         |             |                |--------------|
|          |         |             |                | ChapLanguage |
+------------------------------------------------------------------+
```
Figure: Representation of the `Chapters` Element and a Selection of Its `Descendant` Elements

`Cluster` elements contain the content for each track, e.g., video frames. A Matroska file
**SHOULD** contain at least one `Cluster` element.
In the rare case it doesn't, there should be a method for `Segments` to link
together, possibly using `Chapters`; see (#linked-segments).

The `Cluster` element helps to break up
`SimpleBlock` or `BlockGroup` elements and helps with seeking and error protection.
Every `Cluster` element **MUST** contain a `Timestamp` element.
This **SHOULD** be the `Timestamp` element used to play the first `Block` in the `Cluster` element,
unless a different value is needed to accommodate for more `Blocks`; see (#block-timestamps).

`Cluster` elements contain one or more `Block` element, such as `BlockGroup` or `SimpleBlock` elements.
In some situations, a `Cluster` element **MAY** contain no `Block` element, for example, in a live recording
when no data has been collected.

 A `BlockGroup` element **MAY** contain a `Block` of data and any information relating directly to that `Block`.

```
+--------------------------+
| Cluster | Timestamp      |
|         |----------------|
|         | Position       |
|         |----------------|
|         | PrevSize       |
|         |----------------|
|         | SimpleBlock    |
|         |----------------|
|         | BlockGroup     |
+--------------------------+
```
Figure: Representation of a `Cluster` Element and Its Immediate `Child Elements`

```
+----------------------------------+
| Block | Portion of | Data Type   |
|       | a Block    |  - Bit Flag |
|       |--------------------------+
|       | Header     | TrackNumber |
|       |            |-------------|
|       |            | Timestamp   |
|       |            |-------------|
|       |            | Flags       |
|       |            |  - Gap      |
|       |            |  - Lacing   |
|       |            |  - Reserved |
|       |--------------------------|
|       | Optional   | FrameSize   |
|       |--------------------------|
|       | Data       | Frame       |
+----------------------------------+
```
Figure: Representation of the `Block` Element Structure

Each `Cluster` **MUST** contain exactly one `Timestamp` element. The `Timestamp` element value **MUST**
be stored once per `Cluster`. The `Timestamp` element in the `Cluster` is relative to the entire `Segment`.
The `Timestamp` element **SHOULD** be the first element in the `Cluster` it belongs to
or the second element if that `Cluster` contains a `CRC-32` element ((#crc-32)).

Additionally, the `Block` contains an offset that, when added to the `Cluster`'s `Timestamp` element value,
yields the `Block`'s effective timestamp. Therefore, the timestamp in the `Block` itself is relative to
the `Timestamp` element in the `Cluster`. For example, if the `Timestamp` element in the `Cluster`
is set to 10 seconds and a `Block` in that `Cluster` is supposed to be played 12 seconds into the clip,
the timestamp in the `Block` would be set to 2 seconds.

The `ReferenceBlock` in the `BlockGroup` is used instead of the basic "P-frame"/"B-frame" description.
Instead of simply saying that this `Block` depends on the `Block` directly before or directly after,
the `Timestamp` of the necessary `Block` is used. Because there can be as many `ReferenceBlock` elements
as necessary for a `Block`, it allows for some extremely complex referencing.

The `Cues` element is used to seek when playing back a file by providing a temporal index
for some of the `Tracks`. It is similar to the `SeekHead` element but is used for seeking to
a specific time when playing back the file. It is possible to seek without this element,
but it is much more difficult because a `Matroska Reader` would have to "hunt and peck"
through the file to look for the correct timestamp.

The `Cues` element **SHOULD** contain at least one `CuePoint` element. Each `CuePoint` element
stores the position of the `Cluster` that contains the `BlockGroup` or `SimpleBlock` element.
The timestamp is stored in the `CueTime` element, and the location is stored in the `CueTrackPositions` element.

The `Cues` element is flexible. For instance, the `Cues` element can be used to index every
single timestamp of every `Block` or they can be indexed selectively.

```
+-------------------------------------+
| Cues | CuePoint | CueTime           |
|      |          |-------------------|
|      |          | CueTrackPositions |
|      |------------------------------|
|      | CuePoint | CueTime           |
|      |          |-------------------|
|      |          | CueTrackPositions |
+-------------------------------------+
```
Figure: Representation of a `Cues` Element and Two Levels of Its `Descendant` Elements

The `Attachments` element is for attaching files to a Matroska file, such as pictures,
fonts, web pages, etc.

```
+------------------------------------------------+
| Attachments | AttachedFile | FileDescription   |
|             |              |-------------------|
|             |              | FileName          |
|             |              |-------------------|
|             |              | FileMediaType     |
|             |              |-------------------|
|             |              | FileData          |
|             |              |-------------------|
|             |              | FileUID           |
+------------------------------------------------+
```
Figure: Representation of an `Attachments` Element

The `Tags` element contains metadata that describes the `Segment` and potentially
its `Tracks`, `Chapters`, and `Attachments`. Each `Track` or `Chapter` that those tags
applies to has its UID listed in the `Tags`. The `Tags` contain all extra information about
the file: scriptwriters, singers, actors, directors, titles, edition, price, dates, genre, comments,
etc. `Tags` can contain their values in multiple languages. For example, a movie's "TITLE" tag value might contain both the original English title as well as the German title.

```
+-------------------------------------------+
| Tags | Tag | Targets   | TargetTypeValue  |
|      |     |           |------------------|
|      |     |           | TargetType       |
|      |     |           |------------------|
|      |     |           | TagTrackUID      |
|      |     |           |------------------|
|      |     |           | TagEditionUID    |
|      |     |           |------------------|
|      |     |           | TagChapterUID    |
|      |     |           |------------------|
|      |     |           | TagAttachmentUID |
|      |     |------------------------------|
|      |     | SimpleTag | TagName          |
|      |     |           |------------------|
|      |     |           | TagLanguage      |
|      |     |           |------------------|
|      |     |           | TagDefault       |
|      |     |           |------------------|
|      |     |           | TagString        |
|      |     |           |------------------|
|      |     |           | TagBinary        |
|      |     |           |------------------|
|      |     |           | SimpleTag        |
+-------------------------------------------+
```
Figure: Representation of a `Tags` Element and Three Levels of Its `Children Elements`

