## Data Layout

A Matroska file **MUST** be composed of at least one `EBML Document` using the `Matroska Document Type`.
Each `EBML Document` **MUST** start with an `EBML Header` and **MUST** be followed by the `EBML Root Element`,
defined as `Segment` in Matroska. Matroska defines several `Top-Level Elements`
which may occur within the `Segment`.

As an example, a simple Matroska file consisting of a single `EBML Document` could be represented like this:

- `EBML Header`
- `Segment`

A more complex Matroska file consisting of an `EBML Stream` (consisting of two `EBML Documents`) could be represented like this:

- `EBML Header`
- `Segment`
- `EBML Header`
- `Segment`

The following diagram represents a simple Matroska file, comprised of an `EBML Document`
with an `EBML Header`, a `Segment Element` (the `Root Element`), and all eight Matroska
`Top-Level Elements`. In the following diagrams of this section, horizontal spacing expresses
a parent-child relationship between Matroska Elements (e.g., the `Info Element` is contained within
the `Segment Element`) whereas vertical alignment represents the storage order within the file.

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
Figure: Basic layout of a Matroska file.

The Matroska `EBML Schema` defines eight `Top-Level Elements`:

- `SeekHead` ((#seekhead)),
- `Info` ((#info)),
- `Tracks` ((#track-flags)),
- `Chapters` ((#chapters)),
- `Cluster` ((#cluster-blocks)),
- `Cues` ((#cues)),
- `Attachments` ((#attachments-1)),
- and `Tags` ((#tags)).

The `SeekHead Element` (also known as `MetaSeek`) contains an index of `Top-Level Elements`
locations within the `Segment`. Use of the `SeekHead Element` is **RECOMMENDED**. Without a `SeekHead Element`,
a Matroska parser would have to search the entire file to find all of the other `Top-Level Elements`.
This is due to Matroska's flexible ordering requirements; for instance, it is acceptable for
the `Chapters Element` to be stored after the `Cluster Elements`.

```
+--------------------------------+
| SeekHead | Seek | SeekID       |
|          |      |--------------|
|          |      | SeekPosition |
+--------------------------------+
```
Figure: Representation of a `SeekHead Element`.

The `Info Element` contains vital information for identifying the whole `Segment`.
This includes the title for the `Segment`, a randomly generated unique identifier (UID),
and the UID(s) of any linked `Segment Elements`.

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
Figure: Representation of an `Info Element` and Its `Child Elements`.

The `Tracks Element` defines the technical details for each track and can store the name,
number, UID, language, and type (audio, video, subtitles, etc.) of each track.
For example, the `Tracks Element` **MAY** store information about the resolution of a video track
or sample rate of an audio track.

The `Tracks Element` **MUST** identify all the data needed by the codec to decode the data of the
specified track. However, the data required is contingent on the codec used for the track.
For example, a `Track Element` for uncompressed audio only requires the audio bit rate to be present.
A codec such as AC-3 would require that the `CodecID Element` be present for all tracks,
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
|        |            |              | Color             |
|        |            |----------------------------------|
|        |            | Audio        | SamplingFrequency |
|        |            |              |-------------------|
|        |            |              | Channels          |
|        |            |              |-------------------|
|        |            |              | BitDepth          |
|--------------------------------------------------------|

```
Figure: Representation of the `Tracks Element` and a Selection of Its `Descendant Elements`.

The `Chapters Element` lists all of the chapters. Chapters are a way to set predefined
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
Figure: Representation of the `Chapters Element` and a Selection of Its `Descendant Elements`.

`Cluster Elements` contain the content for each track, e.g., video frames. A Matroska file
**SHOULD** contain at least one `Cluster Element`.
In the rare case it doesn't, there should be a form of Segment linking with other Segments, possibly using Chapters, see (#linked-segments).

The `Cluster Element` helps to break up
`SimpleBlock` or `BlockGroup Elements` and helps with seeking and error protection.
Every `Cluster Element` **MUST** contain a `Timestamp Element`.
This **SHOULD** be the `Timestamp Element` used to play the first `Block` in the `Cluster Element`,
unless a different value is needed to accommodate for more Blocks, see (#block-timestamps).

`Cluster Elements` contain one or more block element, such as `BlockGroup` or `SimpleBlock` elements.
In some situations, a `Cluster Element` **MAY** contain no block element, for example in a live recording
when no data has been collected.

 A `BlockGroup Element` **MAY** contain a `Block` of data and any information relating directly to that `Block`.

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
Figure: Representation of a `Cluster Element` and Its Immediate `Child Elements`.

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
Figure: Representation of the `Block Element` Structure.

Each `Cluster` **MUST** contain exactly one `Timestamp Element`. The `Timestamp Element` value **MUST**
be stored once per `Cluster`. The `Timestamp Element` in the `Cluster` is relative to the entire `Segment`.
The `Timestamp Element` **SHOULD** be the first `Element` in the `Cluster` it belongs to,
or the second `Element` if that Cluster contains a CRC-32 element ((#crc-32))

Additionally, the `Block` contains an offset that, when added to the `Cluster`'s `Timestamp Element` value,
yields the `Block`'s effective timestamp. Therefore, timestamp in the `Block` itself is relative to
the `Timestamp Element` in the `Cluster`. For example, if the `Timestamp Element` in the `Cluster`
is set to 10 seconds and a `Block` in that `Cluster` is supposed to be played 12 seconds into the clip,
the timestamp in the `Block` would be set to 2 seconds.

The `ReferenceBlock` in the `BlockGroup` is used instead of the basic "P-frame"/"B-frame" description.
Instead of simply saying that this `Block` depends on the `Block` directly before, or directly afterwards,
the `Timestamp` of the necessary `Block` is used. Because there can be as many `ReferenceBlock Elements`
as necessary for a `Block`, it allows for some extremely complex referencing.

The `Cues Element` is used to seek when playing back a file by providing a temporal index
for some of the `Tracks`. It is similar to the `SeekHead Element`, but used for seeking to
a specific time when playing back the file. It is possible to seek without this element,
but it is much more difficult because a `Matroska Reader` would have to 'hunt and peck'
through the file looking for the correct timestamp.

The `Cues Element` **SHOULD** contain at least one `CuePoint Element`. Each `CuePoint Element`
stores the position of the `Cluster` that contains the `BlockGroup` or `SimpleBlock Element`.
The timestamp is stored in the `CueTime Element` and location is stored in the `CueTrackPositions Element`.

The `Cues Element` is flexible. For instance, `Cues Element` can be used to index every
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
Figure: Representation of a `Cues Element` and Two Levels of Its `Descendant Elements`.

The `Attachments Element` is for attaching files to a Matroska file such as pictures,
fonts, webpages, etc.

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
|             |              |-------------------|
|             |              | FileName          |
|             |              |-------------------|
|             |              | FileReferral      |
|             |              |-------------------|
|             |              | FileUsedStartTime |
|             |              |-------------------|
|             |              | FileUsedEndTime   |
+------------------------------------------------+
```
Figure: Representation of an `Attachments Element`.

The `Tags Element` contains metadata that describes the `Segment` and potentially
its `Tracks`, `Chapters`, and `Attachments`. Each `Track` or `Chapter` that those tags
applies to has its UID listed in the `Tags`. The `Tags` contain all extra information about
the file: scriptwriter, singer, actors, directors, titles, edition, price, dates, genre, comments,
etc. Tags can contain their values in multiple languages. For example, a movie's "title" `Tag`
might contain both the original English title as well as the title it was released as in Germany.

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
Figure: Representation of a `Tags Element` and Three Levels of Its `Children Elements`.

