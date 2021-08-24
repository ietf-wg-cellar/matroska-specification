# IANA Considerations

## Matroska Element IDs Registry

## Chapter Codec IDs Registry

This document creates a new IANA registry called the "Matroska Chapter Codec IDs" registry.
The values correspond to the `ChapProcessCodecID` value described in (#chapprocesscodecid-element).

`ChapProcessCodecID` values of "0" and "1" are RESERVED to the IETF for future use.

## Historic Deprecated Element IDs Registry

As Matroska evolved since 2002 many parts that were considered for use in the format were never
used and often incorrectly designed. Many of the elements that were then defined are not
found in any known files but were part of public specs. DivX also had a few custom elements that
were designed for custom features.

We list these elements that have a known ID that **SHOULD NOT** be reused to avoid colliding
with existing files.
