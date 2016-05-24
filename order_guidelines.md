---
layout: default
---
While in EBML there is no particular order for elements, in Matroska it is necessary to make sure some elements are placed in a certain order for better playback, seeking and editing efficiency. So far there was no guideline on the order of elements, and some existing programs may not feed these, but by following these guidelines your Matroska files should be optimum for playback in various conditions.

# Level 1 elements

Matroska only needs a few level 1 elements to be playable: Segment Info, Track Info, Clusters. These elements have to be present in a Matroska file. And the Segment Info and Track Info <em>must</em> always be found before the Clusters (either because they're located before the first Cluster or they can be found via Meta Seek elements; see below). All the other elements can be omitted although Cues (index) improve the playback experience greatly.

After a Matroska file has been created it may still be edited. For example chapters, tags or cover art attachments can be added. To do that the Meta Seek needs to be updated and also some elements may be voided or extended. Therefore it's a good idea to use some padding after theses Elements. It is better to put that padding at the Level 1 so that they can easily be reshuffled without having to move them at the end.

## Meta Seek

When 1 Meta Seek Head is present, it should be the first element in a Segment as it should reference the other level 1 elements in that segment (except maybe the long list of Clusters). There is also the possibility that in some cases there are two Meta Seek Head sections like for files produced with mkvpropedit. In that case the first one is also placed first with only the position of the level 1 elements except the Clusters. The second Meta Seek is placed at the end and contains a lengthy list of all Clusters (and not the other level 1 elements). Placing the first Meta Seek Head other than the first position of the Segment would make it a lot less useful So it <em>must</em> be the first element of a Cluster.

It is possible to put the first Cluster of the Segment in the Meta Seek to make it easier to find the actual content of the file.
Meta Seek should also contain some padding (preferably outside and just after the Meta Seek) for a link to Tags, Chapters and Attachments, when they are not already found in the Segment. More padding may also be a good idea to add links in the future for other sections that may be appended in the Matroska file.

## Cues (index)

It is much easier to put the Cues at the "end" of the segment, once all the Clusters have been written, otherwise it's hard to predict beforehand the place to reserve at the beginning of the segment. It is also not a big deal if Cues are at the end, given when the user wants to seek in a Matroska stream, it is going to jump somewhere, so it can seek to the Cues entry, read it and then seek to the best position according to the Cues entries. So the Cues <em>should</em> always be written after the Clusters. However the [Cues could also appear at the front](#cues_front). In this case the size of the Cues is usually very small compared to the video+audio bitrate of the stream. Even on small bitrate for a full length movie, the whole cue size represents only 0.01 to 0.1 second of download. Which is smaller than the time needed to seek on the network.

## Chapters

Chapters on the other hand could be used during playback even if the user doesn't need to seek. It immediately gives the user the information of what section he's reading and/or the other available sections. So Chapters <em>should</em> be placed before the Clusters. In the case of ordered chapters it's also better to find out the "logical" linking even before starting playing anything. So ideally Chapters should be placed before the Track Info (but after the Segment Info).

## Attachments

Attachments are not meant to use by default when playing the file. But they may also contain the cover art bitmaps or fonts. Cover arts are useful even before the file is being played and fonts are needed before playback starts for initialization. So attachment <em>may</em> be placed at the front of the segment. If attachments are meant to be edited, they <em>should</em> rather be at the end.

## Tags

Finally the Tags section is the one that is most subject to changes after the file was originally created. So for easier editing it should be placed at the very end of the Segment, even after Attachments. But on the other hand, it is inconvenient to have to seek in the Segment/stream when a bot is crawling Matroska files for tags (to populate a database), especially for network streams. So it's better if the tags are found early in the stream. When editing tags in such a files, the original tags are the beginning can be [voided](/technical/specs/index.html#void) and the new ones [written right at the end](#tags_end). The file size will only marginally change.

## Optimum layout from a muxer

  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr></table></td></tr></table><h2 id="tags_end">Optimum layout after editing tags</h2>
  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#808080">void</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr></table></td></tr></table><h2 id="cues_front">Optimum layout with Cues at the front</h2>
  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr></table></td></tr></table>

# Cluster Timecode

As each Block+BlockGroup/SimpleBlock in a Cluster needs the Cluster timecode, the Cluster Timecode <em>must</em> be the first element in the Cluster.

# CRC-32

The EBML [CRC-32 element](/technical/specs/index.html#CRC-32) value applies to all the data enclosed in its parent EBML element (except for the CRC-32 element itself). So it <em>must</em> be the first element so that the reader can know a CRC is applied and that all coming data have to feed that CRC checker.
