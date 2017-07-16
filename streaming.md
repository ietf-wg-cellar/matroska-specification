---
---

# Matroska Streaming

There exist multiple ways to stream content. The term streaming itself is very vague. It means reading a file stored on a server. But the server could be very distant or very close. The transport system and the protocol used for streaming makes the whole difference.

In the case of Matroska, there are mostly 2 different kinds of stream: file access and live streaming.

# File Access

File access can simply be reading a file located on your computer, but also accessing it from an HTTP (web) server or CIFS (windows share) server. All these protocols are usually safe from reading errors and seeking in the stream is possible. On other hand when the file is stored far away or on a slow server, seeking can be an expensive operation and SHOULD be avoided. That's why we set a few guidelines that, when followed, help reduce the number of seeking for regular playback and also have the playback start quickly without a lot of data needed to read first (like the Cues (index), Attachments or Meta Seek of all the Clusters).

Matroska having a small overhead, it is well suited for storing music/videos on file servers without having a big impact on the bandwidth used. It doesn't require to load the index before playing (the index can be loaded only when seeking is requested the first time), so playback can start very quickly too.

# Live Streaming

Live streaming is the equivalent of TV broadcasting on the internet. There are 2 families of servers for that. The RTP/RTSP ones and the HTTP servers. Matroska is not meant to be used over RTP. RTP already has timing and channel mechanisms that would wasted if doubled in Matroska. On the other hand live streaming of Matroska over HTTP (or any other plain protocol based on TCP) is very possible.

A live Matroska stream is different than a file, because it may have no known end (only when the client disconnects). For that the Segment MUST use the "unknown" size (all 1s in the size). The other option would be to concatenate Segments with known sizes one after the other. This solution allows a change of codec/resolution between each segment which can be useful in some cases (switch between 4:3 and 16:9 in some TV programs for example).

The Segment(s) being continuous, certain elements like Meta Seek, Cues, Chapters, Attachments MUST NOT be used in this context.

On the player side, it is possible to detect that a stream is not seekable. If the stream does not have a Meta Seek list or a Cues list at the beginning of the stream, it SHOULD be considered as non seekable. Even though it's still theoretically possible to seek blindly forward in the stream, if the server supports it.

In the context of a live radio or even web TV it is possible to "Tag" the content that is currently playing. The Tags level 1 element can be placed between Clusters each time necessary. In that case, the new Tags found MUST reset the previously encountered tags and use the new values instead (be they empty).
