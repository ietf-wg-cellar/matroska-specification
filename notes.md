---
layout: default
---

#### If you intend to implement a Matroska player, make sure you can handle all the files in [our test suite](http://www.matroska.org/downloads/test_w1.html), or at least the features presented there, not necessarily the same codecs.

### Beginning of File
An EBML file always starts with 0x1A. The 0x1A makes the DOS command "type"
  ends display. That way you can include ASCII text before the EBML data and it
  can be displayed. The EBML parser is safe from false-alarm with these ASCII
  only codes. 
Next the EBML header is stored. This allows the the parser to know what type
  of EBML file it is parsing.


### Block Timecodes

The Block's timecode is signed interger that represents the Raw Timecode
  relative to the <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a>,
  multiplied by the TimecodeScale. (see the <a href="notes.html#TimecodeScale">TimecodeScale
  notes</a>)
The Block's timecode is represented by a 16bit signed interger (sint16). This
  means that the Blocks timecode has a range of -32768 to +32767 units.. When
  using the default value of TimecodeScale, each integer represents 1ms. So, the
  maximum time span of Blocks in a Cluster using the default TimecodeScale of
  1ms is 65536ms. 
The quick eye will notice that if a <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a> is set to zero, it is
  possible to have Blocks with a negative Raw Timecode. Blocks with a negative
  Raw Timecode are not valid.


### Default decoded field duration

This element can signal the displaying application how often fields
of a video sequence will be available for displaying. It can be used
for both interlaced and progressive content.

If the video sequence is signaled as interlaced, the period between
 two successive fields at the output of the decoding process equals
 DefaultDecodedFieldDuration.

For video sequences signaled as progressive it is twice the value
 of DefaultDecodedFieldDuration.

These values are valid at the end of the decoding process before
 post-processing like deinterlacing or inverse telecine is applied.

Examples:

<ol><li>Blu-ray movie: 1000000000ns/(48/1.001) = 20854167ns</li>
 <li>PAL broadcast/DVD: 1000000000ns/(50/1.000) = 20000000ns</li>
 <li>N/ATSC broadcast: 1000000000ns/(60/1.001) = 16683333ns</li>
 <li>hard-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns (60
  encoded interlaced fields per second)</li>
 <li>soft-telecined DVD: 1000000000ns/(60/1.001) = 16683333ns   (48
  encoded interlaced fields per second, with "repeat_first_field = 1")</li>
</ol>

### Default Values

The default value of an element is assumed when not present in the data stream.
  It is assumed only in the scope of its upper-element (for example Language in
  the scope of the Track element). If the upper element is not present or assumed,
  then the element cannot be assumed.


### DRM
Digital Rights Management. See <a href="#Encryption">Encryption</a>.


### EBML Class
A larger EBML class typically means the element has a lower probability/importance.
  A larger Class-ID can be used as a synch word in case the file is damaged. Elements
  that are used frequently, but do not need to act as a synch word, should have
  a small Class-ID.
For example, the Cluster has a 4 octect ID and can be used as a synch word
  if the file is damaged. However, the every common element in the BlockGroup
  has a single octet ID to conserve space because of how frequently it is used.


### Encryption
Encryption in Matroska is designed in a very generic style that allows people
  to implement whatever form of encryption is best for them. It is easily possible
  to use the encryption framework in Matroska as a type of DRM.
Because the encryption occurs within the Block, it is possible to manipulate
  encrypted streams without decrypting them. The streams could potentially be
  copied, deleted, cut, appended, or any number of other possible editing techniques
  without ever decrypting them. This means that the data is more useful, without
  having to expose it, or go through the intensive process of decrypting.
Encryption can also be layered within Matroska. This means that two completely
  different types of encryption can be used, requiring two seperate keys to be
  able to decrypt a stream. 
Encryption information is stored in the ContentEncodings section under the
  ContentEncryption element.


### Image cropping
Thanks to the PixelCropXXX elements, it's possible to crop the image before being resized. That means the image size follows this path :
PixelXXX (size of the coded image) -&gt; PixelCropXXX (size of the image to keep) -&gt; DisplayXXX (resized cropped image)


### Matroska version indicators (DocTypeVersion and DocTypeReadVersion)
The EBML header each Matroska file starts with contains two version number fields that inform a reading application about what to expect. These are DocTypeVersion and DocTypeReadVersion.

<em>DocTypeVersion</em> must contain the highest Matroska version number of any element present in the Matroska file. For example, a file using the SimpleBlock element must have a DocTypeVersion of at least 2 while a file containing CueRelativePosition elements must have a DocTypeVersion of at least 4.

The <em>DocTypeReadVersion</em> must contain the minimum version number a reading application must at least suppost properly in order to play the file back (optionally with a reduced feature set). For example, if a file contains only v2 items safe for CueRelativePosition (which is a v4 item) then DocTypeReadVersion should still be set to 2 and not 4 because evaluating CueRelativePosition is not required for standard playback -- it only makes seeking more precise if used.

DocTypeVersion must always be equal to or greater than DocTypeReadVersion.

A reading application supporting Matroska version <code>V</code> must not refuse to read an application with DocReadTypeVersion equal to or lower than <code>V</code> even if DocTypeVersion is greater than <code>V</code>. See also the note about <a href="#unknown-elements">unknown elements</a>.


### Mime Types
There is no IETF endorsed MIME type for Matroska files. But you can use the ones we have defined on our web server :
<ul><li>.mka : Matroska audio <code>audio/x-matroska</code></li>
<li>.mkv : Matroska video <code>video/x-matroska</code></li>
<li>.mk3d : Matroska 3D video <code>video/x-matroska-3d</code></li>
</ul>

### Octet
An Octet refers to a byte made of 8 bits.


### Overlay Track
Overlay tracks should be rendered in the same 'channel' as the track it's linked to. When content is found in such a track it is play on the rendering channel instead of the original track.


### Position References
The position in some elements refers to the position, in octets, from the beginning
  of an element. The reference is the beginning of the first Segment element (= its position + the size of its ID and size fields).
  0 = first possible position of a level 1 element in the segment. When data is spanned over mutiple
  "linked Segments" (in the same file or in different files), the position
  represents the accumulated offset of each Segment. For example to reference
  a position in the third segment, the position will be: the first segment total
  size + second segment total size + offset of the element in the third segment.



### Raw Timecode
The exact time of an object represented in nanoseconds. To find out a Block's
  Raw Timecode, you need the Block's timecode, the <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a>, and
  the TimecodeScale. For calculation, please see the see the <a href="notes.html#TimecodeScale">TimecodeScale
  notes.</a>


### Segment linking

#### Hard linking
This linking can also be called splitting. It's the operation of cutting one segment in several parts. The resulting parts should play as if it was just one part (the original segment). That means the timecode of each part follows the ones from the previous parts. The track numbers are the same. The chapters only match the current segment (unless the edition is ordered, where all parts should be in each segment). And most important, the NextUID and PrevUID points the respective segment UIDs.

#### Soft linking
Soft linking is used by codec chapters. They can reference another segment and jump on that Segment. The way the segments are described are internal to the chapter codec and unknown to the matroska level. But there are elements in the Segment Information (ChapterTranslate) that can translate a value representing a segment in the chapter codec and to the current Segment UID. All segments that could be used in a file/segment this way should be marked as members of the same family (SegmentFamily), so that the player can quickly switch from one to the other.

#### Medium linking
This kind of linking is a mix between hard and soft linking. Each segment linked is independant from the other (standalone, unlike hard linked ones). But it should be treated as a hard-link by the player. Medium linking is done through chapters using the ChapterSegmentUID element and only makes sense for ordered editions. The Segment matching the UID should be played as if it was part of the original segment (segment it's linked from) and then resume playback in the original segment. That means the timecodes of the following content should be shifted by the duration of the linked segment. As for hard-linking, the resulting segment edition should be played and considered as one.
 

### SegmentUID
The 128 bits UIDs must be as unique as possible. It is suggested to compute the MD5 sum of some data parts of the file (the checksum of the Cluster level if you use one). 


### Table Columns
The columns from the specifications table have these meanings.
<ol><li>Element Name
<ul><li>
The full name of the described element.
</li><li>
These are the variable names used within the official EBML and Matroska software libraries.
</li></ul></li>
<li>Level
<ul><li>
The level within an EBML tree that the element may occur at.
</li><li>
A "+" after the number indicates that the element may occur at any level at or after the number mentioned.  A level of "3+" indicates the element may occur at levels 3, 4, 5, 6, and beyond.
</li><li>
With the exception of Global Elements, an element may only occur within the nearest element preceding it in level.  An element at level 3 may only have the parent that is the nearest preceding element of level 2.
</li></ul></li>

<li>EBML ID
<ul><li>
The Element ID displayed as octets.
</li><li>
The bounding with [] brackets are for aesthetic purposes to make reading easier.
</li></ul></li>

<li>Mandatory
<ul><li>
This element is mandatory in the file.
</li><li>
Mandatory elements with a default value may be left out of the file.  In the absence of a mandatory element, the element's default value is used.
</li><li>
A mandatory element is not written if its parent is not in the file.
</li></ul></li>

<li>Multiple
<ul><li>
The element may appear multiple times within its parent element
</li><li>
A non-multiple element may appear once in each instance of its parent.
</li></ul></li>

<li>Range
<ul><li>
Valid range of values to store in the element.
</li><li>
Two hyphenated numbers indicates a value between the two numbers inclusive.
</li><li>
Numeric values are expressed in decimal.
</li><li>
"not 0" or "&gt;0" indicates any value allowed by the element type other than zero.
</li></ul></li>

<li>Default
<ul><li>
The default value of the element.
</li><li>
When the element's parent is present and the element is not, the presence of the element is assumed virtually with the default value.  When the element's parent is not present, the element's default value is ignored.
</li><li>
Numeric value are expressed in decimal.
</li></ul></li>

<li>Element Type
<ul><li>
The form of data the element contains.
</li><li>
The types are the 8 basic EBML types: Signed Integer, Unsigned Integer, Float, String, UTF-8, Date, Sub elements, and Binary. No other types are allowed.
</li></ul></li>

<li>v1
<ul><li>
The element is contained in Matroska version 1.
</li></ul></li>

<li>v2
<ul><li>
The element is contained in Matroska version 2.
</li></ul></li>

<li>v3
<ul><li>
The element is contained in Matroska version 3.</li>
<li>
All currently active elements are included in Matroska version 2.
</li>
</ul></li>

<li>v4
<ul><li>
The element is contained in Matroska version 4.</li>
<li>
v4 is the currently developed version has not been finalized yet. There may be further additions.
</li>
</ul></li>

<li>W
<ul><li>
All elements in WebM (version 2).
</li><li>
Version 1 of WebM is officially deprecated as the only difference was the absence of SimpleBlock.
</li></ul></li>

<li>Description
<ul><li>
A short description of the element's purpose.
</li></ul></li>
</ol>


### Timecode Types
Absolute Timecode = Block+Cluster<br />
  Relative Timecode = Block<br />
  Scaled Timecode = Block+Cluster<br />
  Raw Timecode = (Block+Cluster)*TimecodeScale*TrackTimecodeScale

### TimecodeScale
The <a href="{{site.baseurl}}/specification.html#TimecodeScale">TimecodeScale</a> is used to calculate
  the Raw Timecode of a Block. The timecode is obtained by adding the Block's
  timecode to the <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a>,
  and then multiplying that result by the TimecodeScale. The result will be the
  Block's Raw Timecode in nanoseconds. The formula for this would look like:
(a + b) * c
a = <a href="{{site.baseurl}}/specification.html#Block_Timecode">Block's Timecode</a><br />
  b = <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a><br />
  c = <a href="{{site.baseurl}}/specification.html#TimecodeScale">TimecodeScale</a>
An example of this is, assume a <a href="{{site.baseurl}}/specification.html#Cluster">Cluster's</a> <a href="{{site.baseurl}}/specification.html#Timecode">Timecode</a> has a value of 564264, the
  Block has a Timecode of 1233, and the timecodescale is the default of 1000000.

(1233 + 564264) * 1000000 = 565497000000
So, the Block in this example has a specific time of 565497000000 in nanoseconds.
  In milliseconds this would be 565497ms. 
 


### TimecodeScale Rounding

Because the default value of TimecodeScale is 1000000, which makes each
  integer in the Cluster and Block timecodes equal 1ms, this is the most commonly
  used. When dealing with audio, this causes innaccuracy with where you are seeking
  to. When the audio is combined with video, this is not an issue. For most cases
  the the synch of audio to video does not need to be more than 1ms accurate.
  This becomes obvious when one considers that sound will take 2-3ms to travel
  a single meter, so distance from your speakers will have a greater effect on
  audio/visual synch than this.
However, when dealing with audio only files, seeking accuracy can become critical.
  For instance, when storing a whole CD in a single track, you want to be able
  to seek to the exact sample that a song begins at. If you seek a few sample
  ahead or behind then a 'crack' or 'pop' may result as a few odd samples are
  rendered. Also, when performing precise editing, it may be very useful to have
  the audio accuracy down to a single sample. 
It is usually true that when storing timecodes for an audio stream, the TimecodeScale
  must have an accuracy of at least that of the audio samplerate, otherwise
  there are rounding errors that prevent you from knowing the precise location
  of a sample. Here's how a program has to round each timecode in order to be
  able to recreate the sample number accurately.
Let's assume that the application has an audio track with a sample rate of
  44100. Which TimecodeScale should it use? As written above the TimecodeScale
  must have at least the accuracy of the sample rate itself: 1000000000 /
  44100 = 22675.7369614512. This value must <b>always</b> be truncated.
  Otherwise the accuracy will not suffice. So in this example the
  application wil use 22675 for the TimecodeScale. The application could even
  use some lower value like 22674 which would allow it to be a little bit
  imprecise about the original timecodes. But more about that in a minute.
Next the application wants to write sample number 52340 and calculates the
  timecode. This is easy. In order to calculate the Raw Timecode in ns all it
  has to do is calculate <code>RawTimecode = round(1000000000 *
  sample_number / sample_rate)</code>. Rounding at this stage is very
  important! The application might skip it if it choses a slightly smaller
  value for the TimecodeScale factor instead of the truncated one like shown
  above. Otherwise it has to round or the results won't be reversible.  For
  our example we get <code>RawTimecode = round(1000000000 * 52340 / 44100) =
  round(1186848072.56236) = 1186848073</code>.
The next step is to calculate the Absolute Timecode - that is the timecode
  that will be stored in the Matroska file. Here the application has to divide
  the Raw Timecode from the previous paragraph by the TimecodeScale factor and
  round the result: <code>AbsoluteTimecode = round(RawTimecode /
  TimecodeScale_facotr)</code> which will result in the following for our
  example: <code>AbsoluteTimecode = round(1186848073 / 22675) =
    round(52341.7011245866) = 52342</code>. This number is the one the
  application has to write to the file.
Now our file is complete, and we want to play it back with another
  application. Its task is to find out which sample the first application
  wrote into the file. So it starts reading the Matroska file and finds the
  TimecodeScale factor 22675 and the audio sample rate 44100. Later it finds
  a data block with the Absolute Timecode of 52342. But how does it get the
  sample number from these numbers?
First it has to calculate the Raw Timecode of the block it has just
  read. Here's no rounding involved, just an integer multiplication:
  <code>RawTimecode = AbsoluteTimecode * TimecodeScale_factor</code>. In our
  example: <code>RawTimecode = 52342 * 22675 = 1186854850</code>.
The conversion from the RawTimecode to the sample number again requires
  rounding: <code>sample_number = round(RawTimecode * sample_rate /
  1000000000)</code>. In our example: <code>sample_number = round(1186854850 *
  44100 / 1000000000) = round(52340.298885) = 52340</code>. This is exactly
  the sample number that the previous program started with.
Some general notes for a program:
  <ol><li>Always calculate the timestamps / sample numbers with floating point
      numbers of at least 64bit precision (called 'double' in most modern
      programming languages). If you're calculating with integers then make
      sure they're 64bit long, too.</li>
    <li>Always round if you divide. Always! If you don't you'll end up with
      situations in which you have a timecode in the Matroska file that does
      not correspond to the sample number that it started with. Using a
      slightly lower timecode scale factor can help here in that it removes
      the need for proper rounding in the conversion from sample number to Raw
      Timecode.</li>
  </ol>If you want some sample code for all these calculations you can have a look
  at <a href="matroska-tcscale.c">this small C program</a>. For a given sample
  rate it will iterate over each sample, calculate the AbsoluteTimestamp and
  then re-calculate the sample number.


### Track Flags
#### Default flag
The "default track" flag is a hint for the playback application and SHOULD always be changeable by the user. If the user wants to see or hear a track of a certain kind (audio, video, subtitles) and she hasn't chosen a specific track then the player SHOULD use the first track of that kind whose "default track" flag is set to "1". If no such track is found then the first track of this kind SHOULD be chosen.
Only one track of a kind MAY have its "default track" flag set in a segment. If a track entry does not contain the "default track" flag element then its default value "1" is to be used.

#### Forced flag
The "forced" flag tells the playback application that it MUST display/play this track or another track of the same kind that also has its "forced" flag set. When there are multiple "forced" tracks, the player should decide on the language of the forced flag or use the default flag if no track matches the use languages. Another track of the same kind without the "forced" flag may be use simultaneously with the "forced" track (like DVD subtitles for example).


### TrackTimecodeScale
The <a href="{{site.baseurl}}/specification.html#TrackTimeCodeScale">TrackTimecodeScale</a> is used align tracks that would otherwise be played at different speeds. An example of this would be if you have a film that was originally recorded at 24fps video. When playing this back through a PAL broadcasting system, it is standard to speed up the film to 25fps to match the 25fps display speed of the PAL broadcasting standard. However, when broadcasting the video through NTSC, it is typical to leave the film at its original speed. If you wanted to make a single file where there was one video stream, and an audio stream used from the PAL broadcast, as well as an audio stream used from the NTSC broadcast, you would have the problem that the PAL audio stream would be 1/24th faster than the NTSC audio stream, quickly leading to problems. It is possible to stretch out the PAL audio track and reencode it at a slower speed, however when dealing with lossy audio codecs, this often results in a loss of audio quality and/or larger file sizes. 
This is the type of problem that TrackTimecodeScale was designed to fix. Using it, the video can be played back at a speed that will synch with either the NTSC or the PAL audio stream, depending on which is being used for playback.
To continue the above example: 
Track 1: Video<br />
Track 2: NTSC Audio<br />
Track 3: PAL Audio
Because the NTSC track is at the original speed, it will used as the default value of 1.0 for its TrackTimecodeScale. The video will also be aligned to the NTSC track with the default value of 1.0. 
The TrackTimecodeScale value to use for the PAL track would be calculated by determining how much faster the PAL track is than the NTSC track. In this case, because we know the video for the NTSC audio is being played back at 24fps and the video for the PAL audio is being played back at 25fps, the calculation would be:
(25 / 24) = <br />
~ 1.





 04166666666666666667
When writing a file that uses a non-default TrackTimecodeScale, the values of the Block's timecode are whatever they would be when normally storing the track with a default value for the TrackTimecodeScale. However, the data is interleaved a little differently. Data should be interleaved by its <a href="#Raw_Timecode">Raw Timecode</a> in the order handed back from the encoder. The Raw Timecode of a Block from a track using TrackTimecodeScale is calculated using:
(Block's Timecode + Cluster's Timecode) * TimecodeScale * TrackTimecodeScale 
So, a Block from the PAL track above that had a <a href="#Timecode_Types">Scaled Timecode</a> of 100 seconds would have a Raw Timecode of 104.66666667 seconds, and so would be stored in that part of the file. 
When playing back a track using the TrackTimecodeScale, if the track is being played by itself, there is no need to scale it. From the above example, when playing the Video with the NTSC Audio, neither are scaled. However, when playing back the Video with the PAL Audio, the timecodes from the PAL Audio track are scaled using the TrackTimecodeScale, resulting in the video playing back in synch with the audio. 
It would be possible for a player to also adjust the audio's samplerate at the same time as adjusting the timecodes if you wanted to play the two audio streams synchronously. It would also be possible to adjust the video to match the audio's speed. However, for playback, the only thing that should be counted on is the selected track(s) timecodes being adjusted if they need to be scaled.
While the above example deals specifically with audio tracks, this element can be used to align video, audio, subtitles, or any other type of track contained in a Matroska file. 


### Unknown elements

Matroska is based upon the principal that a reading application does not have to support 100% of the specifications in order to be able to play the file. A Matroska file therefore contains <a href="#version-indicators">version indicators</a> that tell a reading application what to expect.

It is possible and valid to have the version fields indicate that the file contains Matroska elements from a higher specification version number while signalling that a reading application must only support a lower version number properly in order to play it back (possibly with a reduced feature set). This implies that a reading application supporting at least Matroska version <code>V</code> reading a file whose DocTypeReadVersion field is equal to or lower than <code>V</code> must skip Matroska/EBML elements it encounters but which it does not know about if that unknown element fits into the size constraints set by the current parent element.


### 3D and multi-planar videos
There are 2 different ways to compress 3D videos: have each 'eye' track in a separate track and have one track have both 'eyes' combined inside (which is more efficient, compression-wise). Matroska supports both ways.

For the single track variant, there is the <a href="{{site.baseurl}}/specification.html#StereoMode">StereoMode</a> element which defines how planes are assembled in the track (mono or left-right combined). Odd values of StereoMode means the left plane comes first for more convenient reading. The pixel count of the track (PixelWidth/PixelHeight) should be the raw amount of pixels (for example 3840x1080 for full HD side by side) and the DisplayWidth/Height in pixels should be the amount of pixels for one plane (1920x1080 for that full HD stream). Old stereo 3D were displayed using anaglyph (cyan and red colours separated). For compatibility with such movies, there is a value of the StereoMode that corresponds to AnaGlyph.
There is also a "packed" mode (values 13 and 14) which consists of packing 2 frames together in a Block using lacing. The first frame is the left eye and the other frame is the right eye (or vice versa). The frames should be decoded in that order and are possibly dependent on each other (P and B frames).

For separate tracks, Matroska needs to define exactly which track does what. <a href="{{site.baseurl}}/specification.html#TrackOperation">TrackOperation</a> with <a href="{{site.baseurl}}/specification.html#TrackCombinePlanes">TrackCombinePlanes</a> do that. For more details look at <a href="#TrackOperation">how TrackOperation works</a>.

<em>The 3D support is still in infancy and may evolve to support more features.</em>

<em>The <a href="{{site.baseurl}}/specification.html#StereoMode">StereoMode element</a> used to be part of Matroska v2 but it didn't meet the requirement for multiple tracks. There was also a bug in libmatroska prior to 0.9.0 that would save/read it as 0x53B9 instead of 0x53B8. Readers may support these legacy files by checking Matroska v2 or 0x53B9. The <a href="http://www.matroska.org/node/1/revisions/74/view#StereoMode">olders values</a> were 0: mono, 1: right eye, 2: left eye, 3: both eyes</em>


### Track Operation
<a href="{{site.baseurl}}/specification.html#TrackOperation">TrackOperation</a> allows combining multiple tracks to make a virtual one. It uses 2 separate system to combine tracks. One to create a 3D "composition" (left/right/background planes) and one to simplify join 2 tracks together to make a single track.
A track created with TrackOperation is a proper track with a UID and all its flags. However the codec ID is meaningless because each "sub" track needs to be decoded by its own decoder before the "operation" is applied. The Cues corresponding to such a virtual track should be the sum of the Cues elements for each of the tracks it's composed of (when the Cues are defined per track).
In the case of TrackJoinBlocks, the Blocks (from BlockGroup and SimpleBlock) of all the tracks should be used as if they were defined for this new virtual Track. When 2 Blocks have overlapping start or end timecodes, it's up to the underlying system to either drop some of these frames or render them the way they overlap. In the end this situation should be avoided when creating such tracks as you can never be sure of the end result on different platforms.