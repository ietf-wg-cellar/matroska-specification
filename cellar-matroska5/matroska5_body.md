# minver Value

All the new elements added in (#new-elements) have a `minver` attribute of "5".
If they are present in a Matroska file the EBML Header **MUST** have a `DocTypeVersion` of "5" or more, see [@!RFC8794, section 11.2.7]

# Zstandard Compression

This document adds value "4" to the `ContentCompAlgo` element ([@RFC9559, section 5.1.4.1.31.6]).
It corresponds to the Zstandard (zstd) compression algorithm [@!RFC8878].

A compressed chunk of data in Matroska, based on the `ContentEncodingScope` ([@RFC9559, section 5.1.4.1.31.3]),
consists of a Zstandard Frame, as defined in [@!RFC8878, section 3.1.1] without the 4 bytes `Magic_Number` 0xFD2FB528.

When the Zstandard compression algorithm is used, the `ContentCompSettings` element ([@RFC9559, section 5.1.4.1.31.7])
**MAY** optionally contain a dictionary to improve compression efficiency.
The dictionary Format correspond to the Dictionary Format described in [@!RFC8878, section 5] without the 4 bytes `Magic_Number` 0xEC30A437.

# New Elements

