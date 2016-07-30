---
layout: default
---

<table border="5" align="center" id="simple"><tr><td> <table width="150" border="0"><tr><td bgcolor="#FFCCFF">Header</td> 
        </tr><tr><td bgcolor="#FFCC99">Meta Seek Information</td> 
        </tr><tr><td bgcolor="#FFFFCC">Segment Information</td> 
        </tr><tr><td bgcolor="#00FFFF">Track</td> 
        </tr><tr><td bgcolor="#FF6666">Chapters</td> 
        </tr><tr><td height="73" bgcolor="#66FF99">Clusters</td> 
        </tr><tr><td bgcolor="#FFCC00">Cueing Data</td> 
        </tr><tr><td bgcolor="#66FF00">Attachment</td> 
        </tr><tr><td height="31" bgcolor="#CC99FF">Tagging</td> 
        </tr></table></td> 
  </tr></table>

<div align="center">Figure 1 </div> 

The first thing you must realize is that none of these pictures are to scale. Next you have to know that these pictures are a vague representation of the layout of a Matroska file as a full representation would be just as complex as the [specs]({{site.baseurl}}/index.html) themselves.

The first picture is a simple representation of a Matroska file.

The [Header]({{site.baseurl}}/index.html#EBMLHeader) contains information saying what EBML version this files was created with, and what type of EBML file this is. In our case it is a Matroska file.

The [MetaSeek]({{site.baseurl}}/index.html#MetaSeekInformation) section contains an index of where all of the other groups are located in the file, such as the Track information, Chapters, Tags, Cues, Attachments, and so on. This element isn't technicaly REQUIRED, but you would have to search the entire file to find all of the other Level 1 elements if you did not have it. This is because any of the items can occur in any order. For instance you could have the chapters section in the middle of the Clusters. This is part of the flexibility of EBML and Matroska.

The [SegmentInformation]({{site.baseurl}}/index.html#SegmentInformation) section contains basic information relating to the whole file. This includes the title for the file, a unique ID so that the file can be identified around the world, and if it is part of a series of files, the ID of the next file.

The [Track]({{site.baseurl}}/index.html#Track) section has basic information about each of the tracks. For instance, is it a video, audio or subtitle track? What resolution is the video? What sample rate is the audio? The Track section also says what codec to use to view the track, and has the codec's private data for the track.

The [Chapters]({{site.baseurl}}/index.html#Chapters) section lists all of the Chapters. Chapters are a way to set predefined points to jump to in video or audio.

The [Cluster]({{site.baseurl}}/index.html#Cluster) section has all of the Clusters. These contain all of the video frames and audio for each track.

The [Cueing Data]({{site.baseurl}}/index.html#CueingData) section contains all of the cues. Cues are the index for each of the tracks. It is a lot like the MetaSeek, but this is used for seeking to a specific time when playing back the file. Without this it is possible to seek, but it is much more difficult because the player has to 'hunt and peck' through the file looking for the correct timecode.

The [Attachment]({{site.baseurl}}/index.html#Attachment)  section is for attaching any type of file you want to a Matroska file. You could attach anything, pictures, webpages, programs, even the codec needed to play back the file. What you attach is up to you. (Someone might even want to attach an Ogg, or maybe another Matroska file some day?!?) In the future we want to come up with a standard way to label things like an album cover of a CD.

The [Tagging]({{site.baseurl}}/index.html#Tagging)  section contains all of the [Tags]({{site.baseurl}}/tagging.html)  that relate to the the file and each of the tracks. These tags are just like the ID3 tags found in MP3's. It has information such as the singer or writer of a song, ctors that were in the video, or who made the video.

# Order

While EBML allows elements of the same level to be in no particular order, for better use in streaming contexts (and with no drawback for local playback) we have introduced a few [guidelines on the order of certain elements]({{site.baseurl}}/order.html).

# Detailed Diagram

<div align="center">
<table border="5" align="center" id="detailed"><tr><td> <table width="600" border="0"><tr><td><table width="100%" border="0"><tr bgcolor="#FFCC66"><td width="65" height="54" bgcolor="#FFFF00">Level 0</td> 
                <td><table width="100%" border="0"><tr><td width="150" bgcolor="#FFFF00">Grouping</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#FFFF00">Level 1</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#FFFF00">Level 2</td> 
                                  <td bgcolor="#FFFF00">Level 3</td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr><tr><td> <table width="100%" border="0"><tr bgcolor="#FF99FF"><td width="65" bgcolor="#FF99FF">EBML</td> 
                <td><table width="100%" border="0"><tr><td width="150" bgcolor="#FFCCFF">Header</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#FFCCFF">EBMLVersion</td> 
                            <td><table width="100%" border="0"><tr><td width="90"> </td> 
                                  <td> </td> 
                                </tr></table></td> 
                          </tr><tr><td width="90" bgcolor="#FFCCFF">DocType</td> 
                            <td><table width="100%" border="0"><tr><td width="90"> </td> 
                                  <td> </td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr><tr><td><table width="100%" border="0"><tr bgcolor="#999999"><td width="65" bgcolor="#999999">Segment</td> 
                <td><table width="100%" border="0"><tr><td width="150" bgcolor="#FFCC99">Meta Seek Information</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#FFCC99">SeekHead</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#FFCC99">Seek</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#FFCC99">SeekID</td> 
                                      </tr><tr><td bgcolor="#FFCC99">SeekPosition</td> 
                                      </tr></table></td> 
                                </tr><tr><td bgcolor="#FFCC99">Seek</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#FFCC99">SeekID</td> 
                                      </tr><tr><td bgcolor="#FFCC99">SeekPosition</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#FFFFCC">Segment Information</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#FFFFCC">Info</td> 
                            <td><table width="100%" border="0"><tr><td bgcolor="#FFFFCC">Title</td> 
                                  <td> </td> 
                                </tr><tr><td width="90" bgcolor="#FFFFCC">SegmentUID</td> 
                                  <td> </td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#00FFFF">Track</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#00FFFF">Tracks</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#00FFFF">TrackEntry</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#00FFFF">Name</td> 
                                      </tr><tr><td bgcolor="#00FFFF">TrackNumber</td> 
                                      </tr><tr><td bgcolor="#00FFFF">TrackType</td> 
                                      </tr></table></td> 
                                </tr><tr><td bgcolor="#00FFFF">TrackEntry</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#00FFFF">Name</td> 
                                      </tr><tr><td bgcolor="#00FFFF">TrackNumber</td> 
                                      </tr><tr><td bgcolor="#00FFFF">TrackType</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#FF6666">Chapters</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#FF6666">Chapters</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#FF6666">Edition Entry</td> 
                                  <td> </td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#66FF99">Clusters</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#66FF99">Cluster</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#66FF99">Timecode</td> 
                                  <td> </td> 
                                </tr><tr><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td bgcolor="#66FF99">Block</td> 
                                </tr><tr><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#66FF99">Block</td> 
                                      </tr><tr><td bgcolor="#66FF99">ReferenceBlock</td> 
                                      </tr></table></td> 
                                </tr><tr bgcolor="#66FF99"><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td>Block</td> 
                                </tr></table></td> 
                          </tr><tr><td bgcolor="#66FF99">Cluster</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#66FF99">Timecode</td> 
                                  <td> </td> 
                                </tr><tr bgcolor="#66FF99"><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td>Block</td> 
                                </tr><tr bgcolor="#66FF99"><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td>Block</td> 
                                </tr><tr bgcolor="#66FF99"><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td>Block</td> 
                                </tr><tr><td bgcolor="#66FF99">BlockGroup</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#66FF99">Block</td> 
                                      </tr><tr><td bgcolor="#66FF99">BlockDuration</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#FFCC00">Cueing Data</td> 
                      <td><table width="100%" border="0"><tr><td width="95" height="128" bgcolor="#FFCC00">Cues</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#FFCC33">CuePoint</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#FFCC00">CueTime</td> 
                                      </tr><tr><td bgcolor="#FFCC00">CuePosition</td> 
                                      </tr></table></td> 
                                </tr><tr><td bgcolor="#FFCC33">CuePoint</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#FFCC00">CueTime</td> 
                                      </tr><tr><td bgcolor="#FFCC00">CuePosition</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td bgcolor="#66FF00">Attachment</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#66FF00">Attachments</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#66FF00">AttachedFile</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#66FF00">FileName</td> 
                                      </tr><tr><td bgcolor="#66FF00">FileData</td> 
                                      </tr></table></td> 
                                </tr><tr><td bgcolor="#66FF00">AttachedFile</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#66FF00">FileName</td> 
                                      </tr><tr><td bgcolor="#66FF00">FileData</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr><tr><td height="31" bgcolor="#CC99FF">Tagging</td> 
                      <td><table width="100%" border="0"><tr><td width="95" bgcolor="#CC99FF">Tags</td> 
                            <td><table width="100%" border="0"><tr><td width="90" bgcolor="#CC99FF">Tag</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#CC99FF">MultiTitle</td> 
                                      </tr><tr><td bgcolor="#CC99FF">Language</td> 
                                      </tr></table></td> 
                                </tr><tr><td bgcolor="#CC99FF">Tag</td> 
                                  <td><table width="100%" border="0"><tr><td bgcolor="#CC99FF">MultiTitle</td> 
                                      </tr><tr><td bgcolor="#CC99FF">Language</td> 
                                      </tr></table></td> 
                                </tr></table></td> 
                          </tr></table></td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr></table></td> 
  </tr></table>
<div align="center">Figure 2 </div> 

Here is a more complex representation of a Matroska file. This one lists some of the elements as examples. Each of these elements are described in the [specs]({{site.baseurl}}/index.html).

The [Header]({{site.baseurl}}/index.html#EBMLHeader) MUST occur at the beginning of the file. This is how the library knows whether or not it can read the file. The design of EBML is pretty straightforward and is its own project on [SourceForge](http://ebml.sourceforge.net/). EBML is not just for Matroska, there are many different potential applications for it. As such, there is the possibility of there being new versions, such as a 2.0 design. The [EBMLVersion]({{site.baseurl}}/index.html#EBMLVersion) element would let the parser know first if it can read this file at all. If the EBMLVersion is set to 2.0, and the library is only able to read up to 1.2, then it knows it SHOULD NOT even attempt to read this file. 

The [DocType]({{site.baseurl}}/index.html#DocType) tells us that this is a Matroska file. If the DocType says that this is a "Bob's Container Format", then any parser designed for Matrsoka will know right away that even if it can parse the EBML, its not going to know what to do with the data inside of this file.

The [MetaSeek]({{site.baseurl}}/index.html#MetaSeekInformation) section is to let the parser know where the other major parts of the file are. The design is pretty simple. Normally there is just one [SeekHead]({{site.baseurl}}/index.html#SeekHead) in a file. You then have a couple of [Seek]({{site.baseurl}}/index.html#Seek) entries. One for each seek point. The [SeekID]({{site.baseurl}}/index.html#SeekID) contains the "Class-ID" of a level 1 element. For example, the [Tracks]({{site.baseurl}}/index.html#Tracks) element has a Class-ID of "[16][54][AE][6B]". You would put that in the SeekID, and then the byte position of that particular element in [SeekPosition]({{site.baseurl}}/index.html#SeekPosition). The Meta Seek section is usually just used when the file is opened so that it can get information about the file. Any seeking that happens when playing back the file uses the Cues.

The [Segment Information]({{site.baseurl}}/index.html#SegmentInformation) portion gives us information that is vital to identifying the file. This includes the [Title]({{site.baseurl}}/index.html#Title)  of the file and a [SegmentUID]({{site.baseurl}}/index.html#SegmentUID)  that is used to identify the file. The ID is a randomly generated number. It also has the ID of any other Segment that is linked with it.

The [Track]({{site.baseurl}}/index.html#Track) portion tells us the technical side of what is in each track. The name of the track goes in [Name]({{site.baseurl}}/index.html#Name). The tracks number goes into the [TrackNumber]({{site.baseurl}}/index.html#TrackNumber) element. And the [TrackType]({{site.baseurl}}/index.html#TrackType) tells us what the track contains, such as audio, video, subtitles, etc. There are also settings to tell us what [language]({{site.baseurl}}/index.html#language) it is in, and what [codec]({{site.baseurl}}/index.html#CodecID) to use for playback of the track. Each Track has a unique ID called [TrackUID]({{site.baseurl}}/index.html#TrackUID), much like the ID for the whole file. This can be used when you are editing files and have several different versions, it makes it easy to see what files have that specific track. The TrackUID is also used in the [Tagging]({{site.baseurl}}/index.html#Tagging) system.

I am, unfortunately, unable to give a more detailed description of [Chapters]({{site.baseurl}}/index.html#Chapters) at this time. I will describe these better when possible. Look at the specs for more information.

In a given Matroska file, there are usually many [Clusters]({{site.baseurl}}/index.html#Cluster). The Clusters help to break up the [Blocks]({{site.baseurl}}/index.html#Block) some and help with seeking and with error protection. There is no set limit to how much data a Cluster can contain, or how much time they can span, but so far developers seem to like to place the limit at 5 seconds or 5 megabytes. At the beginning of every Cluster is a timecode. This timecode is usually the timecode that the first Block in the Cluster SHOULD be played back, but it doesn't have to be. Then there are one or more (usually many more) [BlockGroups]({{site.baseurl}}/index.html#BlockGroup) in each Cluster. A BlockGroup can contain a Block of data, and any information relating directly to that Block. For a more detailed description of the Block stucture, see picture 3.

The [ReferenceBlock]({{site.baseurl}}/index.html#ReferenceBlock) shown above, in the BlockGroup, is what we use instead of the basic "P-frame"/"B-frame" description. Instead of simply saying that this Block depends on the Block directly before, or directly afterwards, we put the timecode of the needed Block. And because you can have as many ReferenceBlock elements as you want for a Block, it allows for some extremely complex referencing.

The [Cues]({{site.baseurl}}/index.html#Cues) are what is used to seek when playing back a file. They form what is commonly known as an 'index'. In a single [CuePoint]({{site.baseurl}}/index.html#CuePoint), you have the timecode store in [CueTime]({{site.baseurl}}/index.html#CueTime), and then a listing for the exact position in the file for each of the tracks for that timecode. The Cues are pretty flexible for what exactly you want to index. For instance, you can index every single timecode of every Block, in every track if you liked, but you don't really need to. If you have a video file, you really just need to index the keyframes of the video track. 

The Attachments is a pretty simple design. You have an [AttachedFile]({{site.baseurl}}/index.html#AttachedFile) element. Inside of this you have the files name stored in [FileName]({{site.baseurl}}/index.html#FileName), and the file itself is stored in [FileData]({{site.baseurl}}/index.html#FileData). You can also list a more [readable name]({{site.baseurl}}/index.html#FileDescription) and the [MIME-type]({{site.baseurl}}/index.html#FileMimeType).

And the [Tags]({{site.baseurl}}/tagging.html). These are possibly the most complex part of Matroska. Under the Tags element, you can have many Tag elements. Each Tag element contains all of the information pertaining to specific Track(s) and/or Chapter(s). Each Track or Chapter that those tags applies to has its UID listed in the tags. The Tags contain all extra information about the file, script writer, singer, actors, directors, titles, edition, price, dates, genre, comments, etc. And it allows you to enter many of these (title, edition, comments, ect) in different languages.

<div align="center">
<table border="5" align="center"><tr><td> <table width="335"><tr><td><table bgcolor="#FFCC00" width="100%" border="0"><tr><td width="110" bgcolor="#FFFF00">Portion of Block</td> 
                <td><table width="100%" border="0"><tr><td width="100" bgcolor="#FFFF00">Data Type</td> 
                      <td><table width="100%" border="0"><tr><td bgcolor="#FFFF00">Bit Flag</td> 
                          </tr></table></td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr><tr><td><table bgcolor="#CCCCFF" width="100%" border="0"><tr><td width="110" bgcolor="#CCFFFF">Header </td> 
                <td><table width="100%" border="0"><tr><td width="100" bgcolor="#CCFFFF">TrackNumber</td> 
                      <td> </td> 
                    </tr><tr><td bgcolor="#CCFFFF">Timecode</td> 
                      <td> </td> 
                    </tr><tr><td bgcolor="#CCFFFF">Flags</td> 
                      <td><table width="100%" border="0"><tr><td bgcolor="#CCFFFF">Gap</td> 
                          </tr><tr><td bgcolor="#CCFFFF">Lacing</td> 
                          </tr><tr><td bgcolor="#CCFFFF">Reserved</td> 
                          </tr></table></td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr><tr><td><table bgcolor="#FF9999" width="100%" border="0"><tr><td width="110" bgcolor="#FFCC99">Optional</td> 
                <td><table width="100%" border="0"><tr><td width="100" bgcolor="#FFCC99">LaceNumber</td> 
                      <td bgcolor="#FF9999"> </td> 
                    </tr><tr><td bgcolor="#FFCC99">FrameSize</td> 
                      <td> </td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr><tr><td><table bgcolor="#9999FF" width="100%" border="0"><tr><td width="110" bgcolor="#99CCFF">Data</td> 
                <td><table width="100%" border="0"><tr><td width="100" bgcolor="#99CCFF">Frame</td> 
                      <td> </td> 
                    </tr></table></td> 
              </tr></table></td> 
        </tr></table></td> 
  </tr></table></div>
<div align="center">Figure 3 </div> 

Here is a representation of the Block structure. There is an in-depth discussion of it in the specs. I will add some descriptions here when I have time.

One thing that I do want to mention however, to avoid confusion, is the Timecode. The quick eye will notice that there is one Timecode shown per Cluster, and then another within the Block structure itself. The way this works is that the Timecode in the Cluster is relative to the whole file. It is usually the Timecode that the first Block in the Cluster needs to be played at. The Timecode in the Block itself is relative to the Timecode in the Cluster. For example, let's say that the Timecode in the Cluster is set to 10 seconds, and you have a Block in that Cluster that is supposed to be played 12 seconds into the clip. This means that the Timecode in the Block would be set to 2 seconds.
 
