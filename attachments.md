---
layout: default
---

Matroska supports attachments and they can be used for cover arts. This document defines a set of guidelines to add cover arts correctly in Matroska files.

The pictures SHOULD only use the JPEG and PNG picture formats.

There can be 2 different cover for a movie/album. A portrait one (like a DVD case) and a landscape one (like a banner ad for example, looking better on a wide screen).

There can be 2 versions of the same cover, the normal one and the small one. The dimension of the normal one SHOULD be 600 on the smallest side (eg 960x600 for landscape and 600x800 for portrait, 600x600 for square). The dimension of the small one SHOULD be 120 (192x120 or 120x160).

The way to differentiate between all these versions is by the filename. The default filename is cover.(png/jpg) for backward compatibility reasons. That is the "big" version of the file (600) in square or portrait mode. It SHOULD also be the first file in the attachments. The smaller resolution SHOULD be prefixed with "small_", ie small_cover.(jpg/png). The landscape variant SHOULD be suffixed with "_land", ie cover_land.jpg. The filenames are case sensitive and SHOULD all be lower case.

*   cover.jpg (portrait/square 600)
*   small_cover.png (portrait/square 120)
*   cover_land.png (landscape 600)
*   small_cover_land.jpg (landscape 120)

There is a [sample file](https://sourceforge.net/projects/matroska/files/test_files/cover_art.mkv/download) available to test player compatibility or to demonstrate the use of cover art in Matroska files.
