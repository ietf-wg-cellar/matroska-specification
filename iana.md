


## Chapter Codec IDs Registry

This document creates a new IANA registry called the "Matroska Chapter Codec IDs" registry.
The values correspond to the `ChapProcessCodecID` value described in (#chapprocesscodecid-element).

`ChapProcessCodecID` values of "0" and "1" are RESERVED to the IETF for future use.

## MIME Types

Matroska files and streams are found in three main forms: audio-video files, audio-only and occasionally with stereoscopic video tracks.

The MIME types to use for each type is:

* "video/matroska" for streams containing video tracks
* "audio/matroska" for streams containing audio tracks with no video tracks
* "video/matroska-3d" for streams containing at least a stereoscopic video track

Historically Matroska files and streams have used the following MIME types with a "x-" prefix:

* "video/x-matroska" for streams containing video tracks
* "audio/x-matroska" for streams containing audio tracks with no video tracks
* "video/x-matroska-3d" for streams containing at least a stereoscopic video track

For better compatibility a system **SHOULD** be able to handle both formats.
Newer systems **SHOULD NOT** use the historic format and use the format that follows the [@!RFC6838] format instead.


## Historic Deprecated Element IDs Registry

As Matroska evolved since 2002 many parts that were considered for use in the format were never
used and often incorrectly designed. Many of the elements that were then defined are not
found in any known files but were part of public specs. DivX also had a few custom elements that
were designed for custom features.

We list these elements that have a known ID that **SHOULD NOT** be reused to avoid colliding
with existing files.
