


## Chapter Codec IDs Registry

This document creates a new IANA registry called the "Matroska Chapter Codec IDs" registry.
The values correspond to the `ChapProcessCodecID` value described in (#chapprocesscodecid-element).

`ChapProcessCodecID` values of "0" and "1" are RESERVED to the IETF for future use.

## MIME Types

Matroska files and streams are found in three main forms: audio-video files, audio-only and occasionally with stereoscopic video tracks.

Historically Matroska files and streams have used the following MIME types with a "x-" prefix.
For better compatibility a system **SHOULD** be able to handle both formats.
Newer systems **SHOULD NOT** use the historic format and use the format that follows the [@!RFC6838] format instead.

Please register three media types, the [@!RFC6838] templates are below:

### For files containing video tracks

Type name:
: video

Subtype name:
: matroska

Required parameters:
: none

Optional parameters:
: none

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See Section 25.

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: ffmpeg, vlc, ...

Fragment identifier considerations:
: none

Additional information:

  - Deprecated alias names for this type: video/x-matroska

  - Magic number(s): not sure

  - File extension(s): mkv

  - Macintosh file type code(s): none

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: N/A

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: NO

### For files containing audio tracks with no video tracks

Type name:
: audio

Subtype name:
: matroska

Required parameters:
: none

Optional parameters:
: none

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See Section 25.

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: ffmpeg, vlc, ...

Fragment identifier considerations:
: none

Additional information:

  - Deprecated alias names for this type: audio/x-matroska

  - Magic number(s): not sure

  - File extension(s): mka

  - Macintosh file type code(s): none

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: N/A

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: NO

### For files containing audio tracks with no video tracks

Type name:
: video

Subtype name:
: matroska-3d

Required parameters:
: none

Optional parameters:
: none

Encoding considerations:
: as per this document and RFC8794

Security considerations:
: See Section 25.

Interoperability considerations:
: The format is designed to be broadly interoperable.

Published specification:
: THISRFC

Applications that use this media type:
: ffmpeg, vlc, ...

Fragment identifier considerations:
: none

Additional information:

  - Deprecated alias names for this type: video/matroska-3d

  - Magic number(s): not sure

  - File extension(s): mk3d

  - Macintosh file type code(s): none

Person & email address to contact for further information:
: IETF CELLAR WG

Intended usage:
: COMMON

Restrictions on usage:
: N/A

Author:
: IETF CELLAR WG

Change controller:
: IESG

Provisional registration? (standards tree only):
: NO

# Annex A: Historic Deprecated Elements

As Matroska evolved since 2002 many parts that were considered for use in the format were never
used and often incorrectly designed. Many of the elements that were then defined are not
found in any known files but were part of public specs. DivX also had a few custom elements that
were designed for custom features.

We list these elements that have a known ID that **SHOULD NOT** be reused to avoid colliding
with existing files.

