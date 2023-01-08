


## Chapter Codec IDs Registry

This document creates a new IANA registry called the "Matroska Chapter Codec IDs" registry.
The values correspond to the `ChapProcessCodecID` value described in (#chapprocesscodecid-element).

`ChapProcessCodecID` values of "0" and "1" are RESERVED to the IETF for future use.

## Media Types

Matroska files and streams are found in three main forms: audio-video files, audio-only and occasionally with stereoscopic video tracks.

Historically Matroska files and streams have used the following media types with a "x-" prefix.
For better compatibility a system **SHOULD** be able to handle both formats.
Newer systems **SHOULD NOT** use the historic format and use the format that follows the [@!RFC6838] format instead.

Please register three media types, the [@!RFC6838] templates are below:

### For files containing video tracks

Type name:
: video

Subtype name:
: matroska

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See (#security-considerations).

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: FFmpeg, vlc, ...

Fragment identifier considerations:
: N/A

Additional information:

  - Deprecated alias names for this type: video/x-matroska

  - Magic number(s): N/A

  - File extension(s): mkv

  - Macintosh file type code(s): N/A

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: No

### For files containing audio tracks with no video tracks

Type name:
: audio

Subtype name:
: matroska

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See (#security-considerations).

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: FFmpeg, vlc, ...

Fragment identifier considerations:
: N/A

Additional information:

  - Deprecated alias names for this type: audio/x-matroska

  - Magic number(s): N/A

  - File extension(s): mka

  - Macintosh file type code(s): N/A

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: No

### For files containing a stereoscopic video track

Type name:
: video

Subtype name:
: matroska-3d

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See (#security-considerations).

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: FFmpeg, vlc, ...

Fragment identifier considerations:
: N/A

Additional information:

  - Deprecated alias names for this type: video/x-matroska-3d

  - Magic number(s): N/A

  - File extension(s): mk3d

  - Macintosh file type code(s): N/A

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: No

# Annex A: Historic Deprecated Elements

As Matroska evolved since 2002 many parts that were considered for use in the format were never
used and often incorrectly designed. Many of the elements that were then defined are not
found in any known files but were part of public specs. DivX also had a few custom elements that
were designed for custom features.

We list these elements that have a known ID that **SHOULD NOT** be reused to avoid colliding
with existing files. A short description of what each ID was used for is included, but the text
is not normative.

