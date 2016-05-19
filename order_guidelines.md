---
layout: default
---
While in EBML there is no particular order for Elements, in Matroska it is necessary to make sure some elements are placed in a certain order for better playback, seeking and editing efficiency. So far there was no guideline on the order of elements, and some existing programs may not feed these, but by following these guidelines your Matroska files should be optimum for playback in various conditions.

# Top-Level Elements

Matroska requires only a few Top-Level Elements to be playable: `Info`, `Tracks`, and `Cluster`. These Elements have to be present in a Matroska file. The `Info` Element and `Tracks` Element <em>must</em> always be found before the `Cluster` Element(s) (either because they're located before the first `Cluster` or they can be found via `SeekHead` Elements; see below). All the other Elements can be omitted although the `Cues` Element (an index) can improve the playback experience greatly.

After a Matroska file has been created it may still be edited. For example chapters, tags or cover art attachments can be added. To do that the `SeekHead` Element(s) need to be updated and also some elements may be voided or extended. Therefore it's a good idea to use some padding after these Elements. It is better to put that padding at the Level 1 so that they can easily be reshuffled without having to move them at the end.

## SeekHead

When one `SeekHead` Element is present, it should be the first Element in a `Segment` as it should reference the other Top-Level Elements in that `Segment` (except maybe the long list of Clusters). There is also the possibility that in some cases there are two `SeekHead` Elements like for files produced with mkvpropedit. In that case the first `SeekHead` Element is also placed first with only the position of the Top-Level Elements except the `Cluster` Elements. The second `SeekHead` Element is placed at the end and contains a lengthy list of all `Cluster` Elements (and not the other Top-Level Elements). Placing the first `SeekHead` Element in a position other than the first position of the `Segment` would make it a lot less useful So it <em>must</em> be the first Element of a `Cluster`.

It is possible to put the first `Cluster` of the `Segment` in the `SeekHead` Element to make it easier to find the actual content of the file.
The `SeekHead` Element should also contain some padding (preferably outside and just after the `SeekHead` Element) for a link to `Tags`, `Chapters` and `Attachments` Elements, when they are not already found in the `Segment` Element. More padding may also be a good idea to add links in the future for other sections that may be appended in the Matroska file.

## Cues (index)

It is much easier to put the `Cues` Element at the "end" of the `Segment`, once all the `Cluster` Elements have been written, otherwise it's hard to predict beforehand the place to reserve at the beginning of the `Segment` Element. It is also not a big deal if `Cues` are at the end of the `Segment` Element, given when the user wants to seek in a Matroska stream, it is going to jump somewhere, so it can seek to the `Cues` entry, read it and then seek to the best position according to the entries of the `Cues` Element. So the `Cues` Element <em>should</em> always be written after the `Cluster` Element. However the <a href="#cues_front">`Cues` could also appear at the front</a>. In this case the size of the `Cues` is usually very small compared to the video+audio bitrate of the stream. Even on small bitrate for a full length movie, the whole `Cues` Element size represents only 0.01 to 0.1 second of download. Which is smaller than the time needed to seek on the network.

## Chapters

The `Chapters` Element on the other hand could be used during playback even if the user doesn't need to seek. It immediately gives the user the information of what section he's reading and/or the other available sections. So the `Chapters` Element <em>should</em> be placed before the `Cluster` Element(s). In the case of ordered chapters it's also better to find out the "logical" linking even before starting playing anything. So ideally the `Chapters` Element should be placed before the `Tracks` Element (but after the `Info` Element).

## Attachments

The `Attachments` Element is not meant to use by default when playing the file. But they may also contain the cover art bitmaps or fonts. Cover arts are useful even before the file is being played and fonts are needed before playback starts for initialization. So the `Attachments` Element <em>may</em> be placed at the front of the `Segment` Element. If the `Attachments` Element is meant to be edited, they <em>should</em> rather be at the end.

## Tags

Finally the `Tags` Element is the one that is most subject to changes after the file was originally created. So for easier editing it should be placed at the very end of the `Segment` Element, even after the `Attachments` Element. But on the other hand, it is inconvenient to have to seek in the `Segment`/stream when a bot is crawling Matroska files for tags (to populate a database), especially for network streams. So it's better if the `Tags` Element(s) are found early in the stream. When editing tags in such a files, the original `Tags` Element at the beginning can be <a href="/technical/specs/index.html#void">voided</a> and the new ones <a href="#tags_end">written right at the end</a> of the `Segment` Element. The file size will only marginally change.

## Optimum layout from a muxer

  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr></table></td></tr></table><h2 id="tags_end">Optimum layout after editing tags</h2>
  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#808080">void</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr></table></td></tr></table><h2 id="cues_front">Optimum layout with Cues at the front</h2>
  <table border="5" align="center"><tr><td><table width="150" border="0"><tr><td bgcolor="#FFCC99">Meta Seek</td></tr><tr><td bgcolor="#FFFFCC">Segment Info</td></tr><tr><td bgcolor="#00FFFF">Tracks Info</td></tr><tr><td bgcolor="#FF6666">Chapters</td></tr><tr><td bgcolor="#66FF00">Attachments</td></tr><tr><td bgcolor="#CC99FF">Tags</td></tr><tr><td bgcolor="#FFCC00">Cues</td></tr><tr><td bgcolor="#66FF99">Clusters</td></tr></table></td></tr></table>

# Cluster Timecode

As each Block+BlockGroup/SimpleBlock in a `Cluster` Element needs the Cluster `Timecode`, the Cluster `Timecode` <em>must</em> be the first Element within the `Cluster` Element.

# CRC-32

The EBML <a href="/technical/specs/index.html#CRC-32">`CRC-32` Element</a> value applies to all the data enclosed in its Parent Element (except for the `CRC-32` Element itself). So the `CRC-32` Element <em>must</em> be the first Element so that the reader can know a CRC is applied and that all coming data with the Parent Element has to feed that CRC checker.
