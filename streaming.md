# Matroska Streaming

In Matroska, there are two kinds of streaming: file access and livestreaming.

## File Access

File access can simply be reading a file located on your computer, but it also includes
accessing a file from an HTTP (web) server or Common Internet File System (CIFS) (Windows share) server. These protocols
are usually safe from reading errors, and seeking in the stream is possible. However,
when a file is stored far away or on a slow server, seeking can be an expensive operation
and should be avoided.
When followed, the guidelines in (#implementation-recommendations) help reduce the number of
seeking operations for regular playback and also have the playback start
quickly without needing to read lot of data first (like a `Cues` element,
`Attachments` element, or `SeekHead` element).

Matroska, having a small overhead, is well suited for storing music/videos on file
servers without a big impact on the bandwidth used. Matroska does not require the index
to be loaded before playing, which allows playback to start very quickly. The index can
be loaded only when seeking is requested the first time.

## Livestreaming

Livestreaming is the equivalent of television broadcasting on the Internet. There are two
families of servers for livestreaming: RTP / Real-Time Streaming Protocol (RTSP) and HTTP. Matroska is not meant to be
used over RTP. RTP already has timing and channel mechanisms that would be wasted if doubled
in Matroska. Additionally, having the same information at the RTP and Matroska level would
be a source of confusion if they do not match.
Livestreaming of Matroska over file-like protocols like HTTP, QUIC, etc., is possible.

A live Matroska stream is different from a file because it usually has no
known end (only ending when the client disconnects). For this, all bits of the
"size" portion of the `Segment` element **MUST** be set to
1. Another option is to concatenate `Segment` elements with known
sizes, one after the other. This solution allows a change of codec/resolution
between each segment. For example, this allows for a switch between 4:3 and
16:9 in a television program.

When `Segment` elements are continuous, certain elements (like
`SeekHead`, `Cues`, `Chapters`, and `Attachments`)
**MUST NOT** be used.

It is possible for a `Matroska Player` to detect that a stream is
not seekable. If the stream has neither a `SeekHead` list nor a
`Cues` list at the beginning of the stream, it **SHOULD** be
considered non-seekable. Even though it is possible to seek forward in the
stream, it is **NOT RECOMMENDED**.

In the context of live radio or web TV, it is possible to "tag" the content while it is
playing. The `Tags` element can be placed between `Clusters` each time it is necessary.
In that case, the new `Tags` element **MUST** reset the previously encountered `Tags` elements
and use the new values instead.
