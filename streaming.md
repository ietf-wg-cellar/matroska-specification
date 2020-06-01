---
title: Matroska Streaming
---

# Matroska Streaming

In Matroska, there are two kinds of streaming: file access and livestreaming.

## File Access

File access can simply be reading a file located on your computer, but also includes accessing a file from an HTTP (web) server or CIFS (Windows share) server. These protocols are usually safe from reading errors and seeking in the stream is possible. However, when a file is stored far away or on a slow server, seeking can be an expensive operation and SHOULD be avoided. The following guidelines, when followed, help reduce the number of seeking operations for regular playback and also have the playback start quickly without a lot of data needed to read first (like a `Cues Element`, `Attachment Element` or `SeekHead Element`).

Matroska, having a small overhead, is well suited for storing music/videos on file servers without a big impact on the bandwidth used. Matroska does not require the index to be loaded before playing, which allows playback to start very quickly. The index can be loaded only when seeking is requested the first time.

## Livestreaming

Livestreaming is the equivalent of television broadcasting on the internet. There are 2 families of servers for livestreaming: RTP/RTSP and HTTP. Matroska is not meant to be used over RTP. RTP already has timing and channel mechanisms that would be wasted if doubled in Matroska. Additionally, having the same information at the RTP and Matroska level would be a source of confusion if they do not match. Livestreaming of Matroska over HTTP (or any other plain protocol based on TCP) is possible.

A live Matroska stream is different from a file because it usually has no known end (only ending when the client disconnects). For this, all bits of the "size" portion of the `Segment Element` MUST be set to 1. Another option is to concatenate `Segment Elements` with known sizes, one after the other. This solution allows a change of codec/resolution between each segment. For example, this allows for a switch between 4:3 and 16:9 in a television program.

When `Segment Elements` are continuous, certain `Elements`, like `MetaSeek`, `Cues`, `Chapters`, and `Attachments`, MUST NOT be used.

It is possible for a `Matroska Player` to detect that a stream is not seekable. If the stream has neither a `MetaSeek` list or a `Cues` list at the beginning of the stream, it SHOULD be considered non-seekable. Even though it is possible to seek blindly forward in the stream, it is NOT RECOMMENDED.

In the context of live radio or web TV, it is possible to "tag" the content while it is playing. The `Tags Element` can be placed between `Clusters` each time it is necessary. In that case, the new `Tags Element` MUST reset the previously encountered `Tags Elements` and use the new values instead.
