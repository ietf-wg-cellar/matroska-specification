---
layout: default
---

# Matroska Structure

A Matroska file is composed of one or many `EBML Documents` that use the `Matroska Document Type`. Each `EBML Document` MUST start with an `EBML Header` and then the `Root Element`, which is called `Segment` in Matroska. Matroska defines several `Top Level Elements` which MAY occur within the `Segment`.

As an example, a simple Matroska file consisting of a single `EBML Document` could be represented like this:

- EBML Header
- Segment

A more complex Matroska file consisting of an `EBML Stream`  (consisting of two `EBML Documents`) could be represented like this:

- EBML Header
- Segment
- EBML Header
- Segment

The following diagram represents a simple Matroska file, comprised of an `EBML Document` with an `EBML Header`, a `Segment Element` (the `Root Element`), and all eight Matroska `Top Level Elements`. In the following diagrams of this section, horizontal spacing expresses a parent-child relationship between Matroska Elements (e.g. the `Info Element` is contained within the `Segment Element`) whereas vertical alignment represents the storage order within the file.

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

## Matroska Top Level Elements

The Matroska `EBML Schema` defines eight `Top Level Elements`: `SeekHead`, `Info`, `Tracks`, `Chapters`, `Cluster`, `Cues`, `Attachments`, and `Tags`.

The `SeekHead Element` (also known as `MetaSeek`) contains an index of where other `Top Level Elements` of the `Segment` are located in order to let the parser know where the other major parts of the file are. This element isn't technicaly REQUIRED, but without a `SeekHead Element` a `Matroska Parser` would have to search the entire file to find all of the other `Top Level Elements`. This is because Matroska has flexible ordering requirements; for instance, the `Chapters Element` could be stored after the `Cluster Elements`.

```
+--------------------------------+
| SeekHead | Seek | SeekID       |
|          |      |--------------|
|          |      | SeekPosition |
+--------------------------------+
```
Figure: Representation of a `SeekHead Element`.

The `Info Element` contains vital information for identifying the whole `Segment`. This includes the title for the `Segment`, a randomly generated unique identifier so that the file can be identified around the world, and if it is part of a series of `Segments`, the unique identifier(s) of any linked `Segments`.

```
+-------------------------+
| Info | SegmentUID       |
|      |------------------|
|      | SegmentFilename  |
|      |------------------|
|      | PrevUID          |
|      |------------------|
|      | PrevFilename     |
|      |------------------|
|      | NextUID          |
|      |------------------|
|      | NextFilename     |
|      |------------------|
|      | SegmentFamily    |
|      |------------------|
|      | ChapterTranslate |
|      |------------------|
|      | TimecodeScale    |
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
Figure: Representation of a `Info Element` and its `Child Elements`.

The `Tracks Elements` tells us the technical details of what is in each track. For instance, is it a video, audio or subtitle track? What resolution is the video? What sample rate is the audio? The `Tracks Elements` can store the name, number, unique identifier, language, and type (audio, video, subtitles, etc) of each track. The `Tracks Element` also identifies what codec to use to decode the track and has the codec's private data for the track.

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
Figure: Representation of the `Tracks Element` and a selection of its `Descendant Elements`.

The `Chapters Element` section lists all of the Chapters. Chapters are a way to set predefined points to jump to in video or audio.

```
+----------------------------------------------+
| Chapters | EditionEntry | EditionUID         |
|          |              |--------------------|
|          |              | EditionFlagHidden  |
|          |              |--------------------|
|          |              | EditionFlagDefault |
|          |              |--------------------|
|          |              | EditionFlagOrdered |
|          |              |----------------------------------------+
|          |              | ChapterAtom        | ChapterUID        |
|          |              |                    |-------------------|
|          |              |                    | ChapterStringUID  |
|          |              |                    |-------------------|
|          |              |                    | ChapterTimeStart  |
|          |              |                    |-------------------|
|          |              |                    | ChapterTimeEnd    |
|          |              |                    |-------------------|
|          |              |                    | ChapterFlagHidden |
|          |              |                    |----------------------------------+
|          |              |                    | ChapterDisplay    | ChapString   |
|          |              |                    |                   |--------------|
|          |              |                    |                   | ChapLanguage |
+---------------------------------------------------------------------------------+
```
Figure: Representation of the `Chapters Element` and a selection of its `Descendant Elements`.

The `Cluster Elements` contain all of the video frames and audio for each track. In a given Matroska file, there are usually many `Cluster Elements`. The Clusters help to break up the `SimpleBlock` or `BlockGroup Elements` and help with seeking and error protection. It is RECOMMENDED the size of each individual `Cluster Element` be limited to store no more than 5 seconds or 5 megabytes. Every Cluster contains a timecode, usually the timecode that the first Block in the Cluster SHOULD be played back, but it doesn't have to be. Then there are one or more (usually many more) `BlockGroups` or `SimpleBlocks` in each Cluster. A BlockGroup can contain a Block of data, and any information relating directly to that Block.

```
+--------------------------+
| Cluster | Timecode       |
|         |----------------|
|         | SilentTracks   |
|         |----------------|
|         | Position       |
|         |----------------|
|         | PrevSize       |
|         |----------------|
|         | SimpleBlock    |
|         |----------------|
|         | BlockGroup     |
|         |----------------|
|         | EncryptedBlock |
+--------------------------+
```
Figure: Representation of a `Cluster Element` and its immediate `Child Elements`.

Below is a representation of the Block structure.

* Portion of Block
  * Data Type
     * Bit Flag
* Header
  * TrackNumber
  * Timecode
  * Flags
    * Gap
    * Lacing
    * Reserved
* Optional
  * FrameSize
* Data
  * Frame

Although the Timecode value is stored once per Cluster, another timecode is stored within the Block structure itself. The way this works is that the Timecode in the Cluster is relative to the entire `Segment`. It is usually the Timecode that the first Block in the Cluster needs to be played at. The Timecode in the Block itself is relative to the Timecode in the Cluster. For example, let's say that the Timecode in the Cluster is set to 10 seconds, and you have a Block in that Cluster that is supposed to be played 12 seconds into the clip; this means that the Timecode in the Block would be set to 2 seconds.

The `ReferenceBlock` in the BlockGroup, is used instead of the basic "P-frame"/"B-frame" description. Instead of simply saying that this Block depends on the Block directly before, or directly afterwards, we put the timecode of the needed Block. And because you can have as many `ReferenceBlock Elements` as you want for a Block, it allows for some extremely complex referencing.

The `Cues Element` is used to seek when playing back a file by providing a temporal index for each of the tracks. It is similar to the `SeekHead Element`, but this is used for seeking to a specific time when playing back the file. Without this it is possible to seek, but it is much more difficult because the player has to 'hunt and peck' through the file looking for the correct timecode. `Cues` contains `CuePoint Elements` which store the timecode (`CueTime`) and then a listing for the exact position in the file for each of the tracks for that timecode. The `Cues` are pretty flexible for what exactly you want to index. For instance, you can index every single timecode of every `Block` or index selectively. If you have a video file, it is RECOMMENDED to index at least the keyframes of the video track.

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
Figure: Representation of a `Cues Element` and two levels of its `Descendant Elements`.

The `Attachments Element` is for attaching files to a Matroska file such as pictures, webpages, programs, or even the codec needed to play back the file.

```
+------------------------------------------------+
| Attachments | AttachedFile | FileDescription   |
|             |              |-------------------|
|             |              | FileName          |
|             |              |-------------------|
|             |              | FileMimeType      |
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
Figure: Representation of a `Attachments Element`.

The `Tags Element` contains metadata that describes the `Segment` and potentially its `Tracks`, `Chapters`, and `Attachments`. Each Track or Chapter that those tags applies to has its UID listed in the tags. The Tags contain all extra information about the file, script writer, singer, actors, directors, titles, edition, price, dates, genre, comments, etc. And it allows you to enter many of these (title, edition, comments, etc.) in different languages.

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
Figure: Representation of a `Tags Element` and three levels of its `Children Elements`.
