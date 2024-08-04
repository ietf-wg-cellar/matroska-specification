


## Chapter Codec IDs Registry

IANA has created a new registry called the "Matroska Chapter Codec IDs" registry.
The values correspond to the unsigned integer `ChapProcessCodecID` value described in (#chapprocesscodecid-element).

To register a new Chapter Codec ID in this registry, one needs
a Chapter Codec ID, description,
a Change Controller (IETF or email of registrant), and
an optional Reference to a document describing the Chapter Codec ID.

The Chapter Codec IDs are to be allocated according to the "Specification Required" policy [@!RFC8126].

(#chapter-codec-registry-table) shows the initial contents of the "Chapter Codec IDs" registry.
Note that the Change Controller for all entries in (#chapter-codec-registry-table) is "IETF".

Chapter Codec ID | Description            | Reference
----------:|:------------------------|:-------------------------------------------
0 | Matroska Script | RFC 9559, (#chapprocesscodecid-element)
1 | DVD-Menu | RFC 9559, (#chapprocesscodecid-element)
Table: Initial Contents of "Chapter Codec IDs" Registry{#chapter-codec-registry-table}

## Media Types

Matroska files and streams are found in three main forms: audio-video, audio-only, and (occasionally) stereoscopic video.

Historically, Matroska files and streams have used the following media types with an "x-" prefix.
For better compatibility, a system **SHOULD** be able to handle both formats.
Newer systems **SHOULD NOT** use the historic format and use the format that follows the format in [@!RFC6838] instead.

IANA has registered three media types per the templates (see [@!RFC6838]) in the following subsections.

### For Files Containing Video Tracks

Type name:
: video

Subtype name:
: matroska

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: As per RFCs 9559 and 8794

Security considerations:
: See (#security-considerations) of RFC 9559.

Interoperability considerations:
: Due to the extensibility of Matroska, it is possible to encounter files with unknown but valid EBML Elements. Readers should be ready to handle this case. The fixed byte order, octet boundaries, and UTF-8 usage allow for broad interoperability.

Published specification:
: RFC 9559

Applications that use this media type:
: FFmpeg, VLC, etc.

Fragment identifier considerations:
: N/A

Additional information:

  Deprecated alias names for this type:
: video/x-matroska

  Magic number(s):
: N/A

  File extension(s):
: mkv

  Macintosh file type code(s):
: N/A

Person & email address to contact for further information:
: IETF CELLAR WG (cellar@ietf.org)

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IETF

### For Files Containing Audio Tracks with No Video Tracks

Type name:
: audio

Subtype name:
: matroska

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: As per RFCs 9559 and 8794

Security considerations:
: See (#security-considerations) of RFC 9559.

Interoperability considerations:
: Due to the extensibility of Matroska, it is possible to encounter files with unknown but valid EBML Elements. Readers should be ready to handle this case. The fixed byte order, octet boundaries, and UTF-8 usage allow for broad interoperability.

Published specification:
: RFC 9559

Applications that use this media type:
: FFmpeg, VLC, etc.

Fragment identifier considerations:
: N/A

Additional information:

  Deprecated alias names for this type:
: audio/x-matroska

  Magic number(s):
: N/A

  File extension(s):
: mka

  Macintosh file type code(s):
: N/A

Person & email address to contact for further information:
: IETF CELLAR WG (cellar@ietf.org)

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IETF


### For Files Containing a Stereoscopic Video Track

Type name:
: video

Subtype name:
: matroska-3d

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: As per RFCs 9559 and 8794

Security considerations:
: See (#security-considerations) of RFC 9559.

Interoperability considerations:
: Due to the extensibility of Matroska, it is possible to encounter files with unknown but valid EBML Elements. Readers should be ready to handle this case. The fixed byte order, octet boundaries, and UTF-8 usage allow for broad interoperability.

Published specification:
: RFC 9559

Applications that use this media type:
: FFmpeg, VLC, etc.

Fragment identifier considerations:
: N/A

Additional information:

  Deprecated alias names for this type:
: video/x-matroska-3d

  Magic number(s):
: N/A

  File extension(s):
: mk3d

  Macintosh file type code(s):
: N/A

Person & email address to contact for further information:
: IETF CELLAR WG (cellar@ietf.org)

Intended usage:
: COMMON

Restrictions on usage:
: None

Author:
: IETF CELLAR WG

Change controller:
: IETF

