---
title: Specification Notes
---

# Unknown elements

Matroska is based upon the principle that a reading application does not have to support 100% of the specifications in order to be able to play the file. A Matroska file therefore contains version indicators that tell a reading application what to expect.

It is possible and valid to have the version fields indicate that the file contains Matroska `Elements` from a higher specification version number while signaling that a reading application MUST only support a lower version number properly in order to play it back (possibly with a reduced feature set). For example, a reading application supporting at least Matroska version `V` reading a file whose `DocTypeReadVersion` field is equal to or lower than `V` MUST skip Matroska/EBML `Elements` it encounters but does not know about if that unknown element fits into the size constraints set by the current `Parent Element`.


# Default Values

The default value of an `Element` is assumed when not present in the data stream. It is assumed only in the scope of its `Parent Element`. For example, the `Language Element` is in the scope of the `Track Element`. If the `Parent Element` is not present or assumed, then the `Child Element` cannot be assumed.

# DefaultDecodedFieldDuration

The `DefaultDecodedFieldDuration Element` can signal to the displaying application how often fields of a video sequence will be available for displaying. It can be used for both interlaced and progressive content. If the video sequence is signaled as interlaced, then the period between two successive fields at the output of the decoding process equals `DefaultDecodedFieldDuration`.

For video sequences signaled as progressive, it is twice the value of `DefaultDecodedFieldDuration`.

These values are valid at the end of the decoding process before post-processing (such as deinterlacing or inverse telecine) is applied.

Examples:

* Blu-ray movie: 1000000000ns/(48/1.001) = 20854167ns
* PAL broadcast/DVD: 1000000000ns/(50/1.000) = 20000000ns
* N/ATSC broadcast: 1000000000ns/(60/1.001) = 16683333ns
* hard-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns (60 encoded interlaced fields per second)
* soft-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns (48 encoded interlaced fields per second, with "repeat_first_field = 1")

# Encryption

Encryption in Matroska is designed in a very generic style to allow people to implement whatever form of encryption is best for them. It is possible to use the encryption framework in Matroska as a type of DRM (Digital Rights Management).

Because encryption occurs within the `Block Element`, it is possible to manipulate encrypted streams without decrypting them. The streams could potentially be copied, deleted, cut, appended, or any number of other possible editing techniques without decryption. The data can be used without having to expose it or go through the decrypting process.

Encryption can also be layered within Matroska. This means that two completely different types of encryption can be used, requiring two separate keys to be able to decrypt a stream.

Encryption information is stored in the `ContentEncodings Element` under the `ContentEncryption Element`.

# Image Presentation

## Cropping

The `PixelCrop Elements` (`PixelCropTop`, `PixelCropBottom`, `PixelCropRight` and `PixelCropLeft`) indicate when and by how much encoded videos frames SHOULD be cropped for display. These Elements allow edges of the frame that are not intended for display, such as the sprockets of a full-frame film scan or the VANC area of a digitized analog videotape, to be stored but hidden. `PixelCropTop` and `PixelCropBottom` store an integer of how many rows of pixels SHOULD be cropped from the top and bottom of the image (respectively). `PixelCropLeft` and `PixelCropRight` store an integer of how many columns of pixels SHOULD be cropped from the left and right of the image (respectively). For example, a pillar-boxed video that stores a 1440x1080 visual image within the center of a padded 1920x1080 encoded image MAY set both `PixelCropLeft` and `PixelCropRight` to `240`, so that a `Matroska Player` SHOULD crop off 240 columns of pixels from the left and right of the encoded image to present the image with the pillar-boxes hidden.

## Rotation

The ProjectionPoseRoll Element (see (#projectionposeroll-element)) can be used to indicate that the image from the associated video track SHOULD be rotated for presentation. For instance, the following representation of the Projection Element (#projection-element)) and the ProjectionPoseRoll Element represents a video track where the image SHOULD be presentation with a 90 degree counter-clockwise rotation.

```xml
<Projection>
  <ProjectionPoseRoll>90</ProjectionPoseRoll>
</Projection>
```

# Matroska versioning

The `EBML Header` of each Matroska document informs the reading application on what version of Matroska to expect. The `Elements` within `EBML Header` with jurisdiction over this information are `DocTypeVersion` and `DocTypeReadVersion`.

`DocTypeVersion` MUST be equal to or greater than the highest Matroska version number of any `Element` present in the Matroska file. For example, a file using the `SimpleBlock Element` MUST have a `DocTypeVersion` equal to or greater than 2. A file containing `CueRelativePosition` Elements MUST have a `DocTypeVersion` equal to or greater than 4.

The `DocTypeReadVersion` MUST contain the minimum version number that a reading application can minimally support in order to play the file back -- optionally with a reduced feature set. For example, if a file contains only `Elements` of version 2 or lower except for `CueRelativePosition` (which is a version 4 Matroska `Element`), then `DocTypeReadVersion` SHOULD still be set to 2 and not 4 because evaluating `CueRelativePosition` is not necessary for standard playback -- it makes seeking more precise if used.

`DocTypeVersion` MUST always be equal to or greater than `DocTypeReadVersion`.

A reading application supporting Matroska version `V` MUST NOT refuse to read an application with `DocReadTypeVersion` equal to or lower than `V` even if `DocTypeVersion` is greater than `V`. See also the note about [Unknown Elements](#unknown-elements).

# MIME Types

There is no IETF endorsed MIME type for Matroska files. These definitions can be used:

* .mka : Matroska audio `audio/x-matroska`
* .mkv : Matroska video `video/x-matroska`
* .mk3d : Matroska 3D video `video/x-matroska-3d`

# Segment Position

The `Segment Position` of an `Element` refers to the position of the first octet of the `Element ID` of that `Element`, measured in octets, from the beginning of the `Element Data` section of the containing `Segment Element`. In other words, the `Segment Position` of an `Element` is the distance in octets from the beginning of its containing `Segment Element` minus the size of the `Element ID` and `Element Data Size` of that `Segment Element`. The `Segment Position` of the first `Child Element` of the `Segment Element` is 0. An `Element` which is not stored within a `Segment Element`, such as the `Elements` of the `EBML Header`, do not have a `Segment Position`.

## Segment Position Exception

`Elements` that are defined to store a `Segment Position` MAY define reserved values to indicate a special meaning.

## Example of Segment Position

This table presents an example of `Segment Position` by showing a hexadecimal representation of a very small Matroska file with labels to show the offsets in octets. The file contains a `Segment Element` with an `Element ID` of `0x18538067` and a `MuxingApp Element` with an `Element ID` of `0x4D80`.

         0                             1                             2
         0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
       0 |1A|45|DF|A3|8B|42|82|88|6D|61|74|72|6F|73|6B|61|18|53|80|67|
      20 |93|15|49|A9|66|8E|4D|80|84|69|65|74|66|57|41|84|69|65|74|66|

In the above example, the `Element ID` of the `Segment Element` is stored at offset 16, the `Element Data Size` of the `Segment Element` is stored at offset 20, and the `Element Data` of the `Segment Element` is stored at offset 21.

The `MuxingApp Element` is stored at offset 26. Since the `Segment Position` of an `Element` is calculated by subtracting the position of the `Element Data` of the containing `Segment Element` from the position of that `Element`, the `Segment Position` of `MuxingApp Element` in the above example is `26 - 21` or `5`.

# Linked Segments

Matroska provides several methods to link two or many `Segment Elements` together to create a `Linked Segment`. A `Linked Segment` is a set of multiple `Segments` related together into a single presentation by using Hard Linking, Medium Linking, or Soft Linking. All `Segments` within a `Linked Segment` MUST utilize the same track numbers and timescale. All `Segments` within a `Linked Segment` MUST be stored within the same directory. All `Segments` within a `Linked Segment` MUST store a `SegmentUID`.

## Hard Linking

Hard Linking (also called splitting) is the process of creating a `Linked Segment` by relating multiple `Segment Elements` using the `NextUID` and `PrevUID` Elements.
Within a `Linked Segment`, the timestamps of each `Segment` MUST follow consecutively in linking order.
With Hard Linking, the chapters of any `Segment` within the `Linked Segment` MUST only reference the current `Segment`. With Hard Linking, the `NextUID` and `PrevUID` MUST reference the respective `SegmentUID` values of the next and previous `Segments`.
The first `Segment` of a `Linked Segment` SHOULD have a `NextUID Element` and MUST NOT have a `PrevUID Element`.
The last `Segment` of a `Linked Segment` SHOULD have a `PrevUID Element` and MUST NOT have a `NextUID Element`.
The middle `Segments` of a `Linked Segment` SHOULD have both a `NextUID Element` and a `PrevUID Element`.

In a chain of `Linked Segments` the `NextUID` always takes precedence over the `PrevUID`.
So if SegmentA has a NextUID to SegmentB and SegmentB has a PrevUID to SegmentC, the link to use is SegmentA to SegmentB.
If SegmentB has a PrevUID to SegmentA but SegmentA has no NextUID, then the Matroska Player MAY consider these two Segments linked as SegmentA followed by SegmentB.

As an example, three `Segments` can be Hard Linked as a `Linked Segment` through cross-referencing each other with `SegmentUID`, `PrevUID`, and `NextUID`, as in this table.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | n/a

An other example where only the `NextUID` Element is used.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | a77b3598941cb803 eac0fcdafe44fac9
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | n/a                               | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | n/a

A next example where only the `PrevUID` Element is used.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | n/a
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | a77b3598941cb803 eac0fcdafe44fac9 | n/a

In this example only the `middle.mkv` is using the `PrevUID` and `NextUID` Elements.

file name   | `SegmentUID`                      | `PrevUID`                         | `NextUID`
:-----------|:----------------------------------|:----------------------------------|:---------
`start.mkv` | 71000c23cd310998 53fbc94dd984a5dd | n/a                               | n/a
`middle.mkv`| a77b3598941cb803 eac0fcdafe44fac9 | 71000c23cd310998 53fbc94dd984a5dd | 6c92285fa6d3e827 b198d120ea3ac674
`end.mkv`   | 6c92285fa6d3e827 b198d120ea3ac674 | n/a                               | n/a

## Medium Linking

Medium Linking creates relationships between `Segments` using Ordered Chapters and the `ChapterSegmentUID Element`. A `Segment Edition` with Ordered Chapters MAY contain `Chapter Elements` that reference timestamp ranges from other `Segments`. The `Segment` referenced by the Ordered Chapter via the `ChapterSegmentUID Element` SHOULD be played as part of a Linked Segment. The timestamps of Segment content referenced by Ordered Chapters MUST be adjusted according to the cumulative duration of the the previous Ordered Chapters.

As an example a file named `intro.mkv` could have a `SegmentUID` of `0xb16a58609fc7e60653a60c984fc11ead`. Another file called `program.mkv` could use a Chapter Edition that contains two Ordered Chapters. The first chapter references the `Segment` of `intro.mkv` with the use of a `ChapterSegmentUID`, `ChapterSegmentEditionUID`, `ChapterTimeStart` and optionally a `ChapterTimeEnd` element. The second chapter references content within the `Segment` of `program.mkv`. A `Matroska Player` SHOULD recognize the `Linked Segment` created by the use of `ChapterSegmentUID` in an enabled `Edition` and present the reference content of the two `Segments` together.

## Soft Linking

Soft Linking is used by codec chapters. They can reference another `Segment` and jump to that `Segment`. The way the `Segments` are described are internal to the chapter codec and unknown to the Matroska level. But there are `Elements` within the `Info Element` (such as `ChapterTranslate`) that can translate a value representing a `Segment` in the chapter codec and to the current `SegmentUID`. All `Segments` that could be used in a `Linked Segment` in this way SHOULD be marked as members of the same family via the `SegmentFamily Element`, so that the `Matroska Player` can quickly switch from one to the other.

# Track Flags

## Default flag

The "default track" flag is a hint for a `Matroska Player` and SHOULD always be changeable by the user. If the user wants to see or hear a track of a certain kind (audio, video, subtitles) and hasn't chosen a specific track, the `Matroska Player` SHOULD use the first track of that kind whose "default track" flag is set to "1". If no such track is found then the first track of this kind SHOULD be chosen.

Only one track of a kind MAY have its "default track" flag set in a segment. If a track entry does not contain the "default track" flag element then its default value "1" is to be used.

## Forced flag

The "forced" flag tells the `Matroska Player` that it MUST display/play this track or another track of the same kind that also has its "forced" flag set. When there are multiple "forced" tracks, the `Matroska Player` SHOULD determine the track based upon the language of the forced flag or use the default flag if no track matches the use languages. Another track of the same kind without the "forced" flag may be use simultaneously with the "forced" track (like DVD subtitles for example).

## Track Operation

`TrackOperation` allows combining multiple tracks to make a virtual one. It uses two separate system to combine tracks. One to create a 3D "composition" (left/right/background planes) and one to simplify join two tracks together to make a single track.

A track created with `TrackOperation` is a proper track with a UID and all its flags. However the codec ID is meaningless because each "sub" track needs to be decoded by its own decoder before the "operation" is applied. The `Cues Elements` corresponding to such a virtual track SHOULD be the sum of the `Cues Elements` for each of the tracks it's composed of (when the `Cues` are defined per track).

In the case of `TrackJoinBlocks`, the `Block Elements` (from `BlockGroup` and `SimpleBlock`) of all the tracks SHOULD be used as if they were defined for this new virtual `Track`. When two `Block Elements` have overlapping start or end timestamps, it's up to the underlying system to either drop some of these frames or render them the way they overlap. This situation SHOULD be avoided when creating such tracks as you can never be sure of the end result on different platforms.

## Overlay Track

Overlay tracks SHOULD be rendered in the same 'channel' as the track its linked to. When content is found in such a track, it SHOULD be played on the rendering channel instead of the original track.

## Multi-planar and 3D videos

There are two different ways to compress 3D videos: have each 'eye' track in a separate track and have one track have both 'eyes' combined inside (which is more efficient, compression-wise). Matroska supports both ways.

For the single track variant, there is the `StereoMode Element` which defines how planes are assembled in the track (mono or left-right combined). Odd values of StereoMode means the left plane comes first for more convenient reading. The pixel count of the track (`PixelWidth`/`PixelHeight`) is the raw amount of pixels (for example 3840x1080 for full HD side by side) and the `DisplayWidth`/`DisplayHeight` in pixels is the amount of pixels for one plane (1920x1080 for that full HD stream). Old stereo 3D were displayed using anaglyph (cyan and red colours separated). For compatibility with such movies, there is a value of the StereoMode that corresponds to AnaGlyph.

There is also a "packed" mode (values 13 and 14) which consists of packing two frames together in a `Block` using lacing. The first frame is the left eye and the other frame is the right eye (or vice versa). The frames SHOULD be decoded in that order and are possibly dependent on each other (P and B frames).

For separate tracks, Matroska needs to define exactly which track does what. `TrackOperation` with `TrackCombinePlanes` do that. For more details look at [how TrackOperation works](#track-operation).

The 3D support is still in infancy and may evolve to support more features.

The StereoMode used to be part of Matroska v2 but it didn't meet the requirement for multiple tracks. There was also a bug in libmatroska prior to 0.9.0 that would save/read it as 0x53B9 instead of 0x53B8. `Matroska Readers` may support these legacy files by checking Matroska v2 or 0x53B9. The older values were 0: mono, 1: right eye, 2: left eye, 3: both eyes.


# Timestamps

Historically timestamps in Matroska were mistakenly called timecodes. The `Timestamp Element` was called Timecode, the `TimestampScale Element` was called TimecodeScale, the `TrackTimestampScale Element` was called TrackTimecodeScale and the `ReferenceTimestamp Element` was called ReferenceTimeCode.

## Timestamp Types

* Absolute Timestamp = Block+Cluster
* Relative Timestamp = Block
* Scaled Timestamp = Block+Cluster
* Raw Timestamp = (Block+Cluster)\*TimestampScale\*TrackTimestampScale

## Block Timestamps

The `Block Element`'s timestamp MUST be a signed integer that represents the `Raw Timestamp` relative to the `Cluster`'s `Timestamp Element`, multiplied by the `TimestampScale Element`. See [TimestampScale](#timestampscale) for more information.

The `Block Element`'s timestamp MUST be represented by a 16bit signed integer (sint16). The `Block`'s timestamp has a range of -32768 to +32767 units. When using the default value of the `TimestampScale Element`, each integer represents 1ms. The maximum time span of `Block Elements` in a `Cluster` using the default `TimestampScale Element` of 1ms is 65536ms.

If a `Cluster`'s `Timestamp Element` is set to zero, it is possible to have `Block Elements` with a negative `Raw Timestamp`. `Block Elements` with a negative `Raw Timestamp` are not valid.

## Raw Timestamp

The exact time of an object SHOULD be represented in nanoseconds. To find out a `Block`'s `Raw Timestamp`, you need the `Block`'s `Timestamp Element`, the `Cluster`'s `Timestamp Element`, and the `TimestampScale Element`.

## TimestampScale

The `TimestampScale Element` is used to calculate the `Raw Timestamp` of a `Block`. The timestamp is obtained by adding the `Block`'s timestamp to the `Cluster`'s `Timestamp Element`, and then multiplying that result by the `TimestampScale`. The result will be the `Block`'s `Raw Timestamp` in nanoseconds. The formula for this would look like:

    (a + b) * c

    a = `Block`'s Timestamp
    b = `Cluster`'s Timestamp
    c = `TimestampScale`

For example, assume a `Cluster`'s `Timestamp` has a value of 564264, the `Block` has a `Timestamp` of 1233, and the `TimestampScale Element` is the default of 1000000.

    (1233 + 564264) * 1000000 = 565497000000

So, the `Block` in this example has a specific time of 565497000000 in nanoseconds. In milliseconds this would be 565497ms.

## TimestampScale Rounding

Because the default value of `TimestampScale` is 1000000, which makes each integer in the `Cluster` and `Block` `Timestamp Elements` equal 1ms, this is the most commonly used. When dealing with audio, this causes inaccuracy when seeking. When the audio is combined with video, this is not an issue. For most cases, the the synch of audio to video does not need to be more than 1ms accurate. This becomes obvious when one considers that sound will take 2-3ms to travel a single meter, so distance from your speakers will have a greater effect on audio/visual synch than this.

However, when dealing with audio-only files, seeking accuracy can become critical. For instance, when storing a whole CD in a single track, a user will want to be able to seek to the exact sample that a song begins at. If seeking a few sample ahead or behind, a 'crack' or 'pop' may result as a few odd samples are rendered. Also, when performing precise editing, it may be very useful to have the audio accuracy down to a single sample.

When storing timestamps for an audio stream, the `TimestampScale Element` SHOULD have an accuracy of at least that of the audio sample rate, otherwise there are rounding errors that prevent users from knowing the precise location of a sample. Here's how a program has to round each timestamp in order to be able to recreate the sample number accurately.

Let's assume that the application has an audio track with a sample rate of 44100. As written above the `TimestampScale` MUST have at least the accuracy of the sample rate itself: 1000000000 / 44100 = 22675.7369614512. This value MUST always be truncated. Otherwise the accuracy will not suffice. So in this example the application will use 22675 for the `TimestampScale`. The application could even use some lower value like 22674 which would allow it to be a little bit imprecise about the original timestamps. But more about that in a minute.

Next the application wants to write sample number 52340 and calculates the timestamp. This is easy. In order to calculate the `Raw Timestamp` in ns all it has to do is calculate `Raw Timestamp = round(1000000000 * sample_number / sample_rate)`. Rounding at this stage is very important! The application might skip it if it choses a slightly smaller value for the `TimestampScale` factor instead of the truncated one like shown above. Otherwise it has to round or the results won't be reversible.  For our example we get `Raw Timestamp = round(1000000000 * 52340 / 44100) = round(1186848072.56236) = 1186848073`.

The next step is to calculate the `Absolute Timestamp` - that is the timestamp that will be stored in the Matroska file. Here the application has to divide the `Raw Timestamp` from the previous paragraph by the `TimestampScale` factor and round the result: `Absolute Timestamp = round(Raw Timestamp / TimestampScale_factor)` which will result in the following for our example: `Absolute Timestamp = round(1186848073 / 22675) = round(52341.7011245866) = 52342`. This number is the one the application has to write to the file.

Now our file is complete, and we want to play it back with another application. Its task is to find out which sample the first application wrote into the file. So it starts reading the Matroska file and finds the `TimestampScale` factor 22675 and the audio sample rate 44100. Later it finds a data block with the `Absolute Timestamp` of 52342. But how does it get the sample number from these numbers?

First it has to calculate the `Raw Timestamp` of the block it has just read. Here's no rounding involved, just an integer multiplication: `Raw Timestamp = Absolute Timestamp * TimestampScale_factor`. In our example: `Raw Timestamp = 52342 * 22675 = 1186854850`.

The conversion from the `Raw Timestamp` to the sample number again requires rounding: `sample_number = round(Raw Timestamp * sample_rate / 1000000000)`. In our example: `sample_number = round(1186854850 * 44100 / 1000000000) = round(52340.298885) = 52340`. This is exactly the sample number that the previous program started with.

Some general notes for a program:

1. Always calculate the timestamps / sample numbers with floating point numbers of at least 64bit precision (called 'double' in most modern programming languages). If you're calculating with integers then make sure they're 64bit long, too.
2. Always round if you divide. Always! If you don't you'll end up with situations in which you have a timestamp in the Matroska file that does not correspond to the sample number that it started with. Using a slightly lower timestamp scale factor can help here in that it removes the need for proper rounding in the conversion from sample number to `Raw Timestamp`.

## TrackTimestampScale

The `TrackTimestampScale Element` is used align tracks that would otherwise be played at different speeds. An example of this would be if you have a film that was originally recorded at 24fps video. When playing this back through a PAL broadcasting system, it is standard to speed up the film to 25fps to match the 25fps display speed of the PAL broadcasting standard. However, when broadcasting the video through NTSC, it is typical to leave the film at its original speed. If you wanted to make a single file where there was one video stream, and an audio stream used from the PAL broadcast, as well as an audio stream used from the NTSC broadcast, you would have the problem that the PAL audio stream would be 1/24th faster than the NTSC audio stream, quickly leading to problems. It is possible to stretch out the PAL audio track and re-encode it at a slower speed, however when dealing with lossy audio codecs, this often results in a loss of audio quality and/or larger file sizes.

This is the type of problem that `TrackTimestampScale` was designed to fix. Using it, the video can be played back at a speed that will synch with either the NTSC or the PAL audio stream, depending on which is being used for playback.
To continue the above example:

    Track 1: Video
    Track 2: NTSC Audio
    Track 3: PAL Audio

Because the NTSC track is at the original speed, it will used as the default value of 1.0 for its `TrackTimestampScale`. The video will also be aligned to the NTSC track with the default value of 1.0.

The `TrackTimestampScale` value to use for the PAL track would be calculated by determining how much faster the PAL track is than the NTSC track. In this case, because we know the video for the NTSC audio is being played back at 24fps and the video for the PAL audio is being played back at 25fps, the calculation would be:

25/24 is almost 1.04166666666666666667

When writing a file that uses a non-default `TrackTimestampScale`, the values of the `Block`'s timestamp are whatever they would be when normally storing the track with a default value for the `TrackTimestampScale`. However, the data is interleaved a little differently. Data SHOULD be interleaved by its [Raw Timestamp](#raw-timestamp) in the order handed back from the encoder. The `Raw Timestamp` of a `Block` from a track using `TrackTimestampScale` is calculated using:

`(Block's Timestamp + Cluster's Timestamp) * TimestampScale * TrackTimestampScale `

So, a Block from the PAL track above that had a [Scaled Timestamp](#timestamp-types) of 100 seconds would have a `Raw Timestamp` of 104.66666667 seconds, and so would be stored in that part of the file.

When playing back a track using the `TrackTimestampScale`, if the track is being played by itself, there is no need to scale it. From the above example, when playing the Video with the NTSC Audio, neither are scaled. However, when playing back the Video with the PAL Audio, the timestamps from the PAL Audio track are scaled using the `TrackTimestampScale`, resulting in the video playing back in synch with the audio.

It would be possible for a `Matroska Player` to also adjust the audio's samplerate at the same time as adjusting the timestamps if you wanted to play the two audio streams synchronously. It would also be possible to adjust the video to match the audio's speed. However, for playback, the selected track(s) timestamps SHOULD be adjusted if they need to be scaled.

While the above example deals specifically with audio tracks, this element can be used to align video, audio, subtitles, or any other type of track contained in a Matroska file.
