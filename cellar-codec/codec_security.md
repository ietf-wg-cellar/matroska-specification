# Security Considerations

This document inherits security considerations from the EBML [@!RFC8794] and Matroska [@!RFC9559] documents.

Codec handling may be one of the more error-prone aspect of using Matroska.
The parsing and interpretation of binary data can lead to many types of security issues.
Although these issues don't come from Matroska itself, it's worth noting some issues that need to be considered.

The `CodecPrivate` may be missing from the `TrackEntry` description. The `TrackEntry` **MAY** be discarded in that case.

An existing `CodecPrivate` data may be corrupted or incomplete or too big. The `TrackEntry` **MAY** be discarded in that case.

A lot of codec have internal fields to hold values that are already found in the `TrackEntry`
like the video dimensions or the audio sampling frequency.
If these values differ that can lead to playback issues and even crashes.
