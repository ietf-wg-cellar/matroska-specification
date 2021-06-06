%%%
title = "Matroska Media Container Format Specifications"
abbrev = "Matroska Format"
ipr= "trust200902"
area = "art"
submissiontype = "IETF"
workgroup = "cellar"
date = @BUILD_DATE@
keyword = ["binary","storage","matroska","ebml","webm"]

[seriesInfo]
name = "Internet-Draft"
stream = "IETF"
status = "standard"
value = "@BUILD_VERSION@"

[[author]]
initials="S."
surname="Lhomme"
fullname="Steve Lhomme"
  [author.address]
  email="slhomme@matroska.org"

[[author]]
initials="M."
surname="Bunkus"
fullname="Moritz Bunkus"
  [author.address]
  email="moritz@bunkus.org"

[[author]]
initials="D."
surname="Rice"
fullname="Dave Rice"
  [author.address]
  email="dave@dericed.com"
%%%

.# Abstract

This document defines the Matroska audiovisual container, including definitions of its structural elements,
as well as its terminology, vocabulary, and application.

{mainmatter}

# Introduction

Matroska aims to become THE standard of multimedia container formats. It was derived from a project called [@?MCF],
but differentiates from it significantly because it is based on EBML (Extensible Binary Meta Language) [@!RFC8794],
a binary derivative of XML. EBML enables significant advantages in terms of future format extensibility,
without breaking file support in old parsers.

First, it is essential to clarify exactly "What an Audio/Video container is", to avoid any misunderstandings:

- It is NOT a video or audio compression format (codec)
- It is an envelope for which there can be many audio, video, and subtitles streams,
  allowing the user to store a complete movie or CD in a single file.

Matroska is designed with the future in mind. It incorporates features like:

- Fast seeking in the file
- Chapter entries
- Full metadata (tags) support
- Selectable subtitle/audio/video streams
- Modularly expandable
- Error resilience (can recover playback even when the stream is damaged)
- Streamable over the internet and local networks (HTTP, CIFS, FTP, etc)
- Menus (like DVDs have)

Matroska is an open standards project. This means for personal use it is absolutely free to use
and that the technical specifications describing the bitstream are open to everybody,
even to companies that would like to support it in their products.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of
the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/).
But since it's quite complete it is used as a reference for the development of libmatroska.

Note that versions 1, 2, and 3 have been finalized. Version 4 is currently work in progress.
There **MAY** be further additions to v4.

# Security Considerations

Matroska inherits security considerations from EBML.

Attacks on a `Matroska Reader` could include:

- Storage of a arbitrary and potentially executable data within an `Attachment Element`.
  `Matroska Readers` that extract or use data from Matroska Attachments **SHOULD**
  check that the data adheres to expectations.
- A `Matroska Attachment` with an inaccurate mime-type.

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in BCP 14 [@!RFC2119] [@!RFC8174]
when, and only when, they appear in all capitals, as shown here.

This document defines specific terms in order to define the format and application of `Matroska`.
Specific terms are defined below:

`Matroska`:
: A multimedia container format based on EBML (Extensible Binary Meta Language).

`Matroska Reader`:
: A data parser that interprets the semantics of a Matroska document and creates a way for programs to use `Matroska`.

`Matroska Player`:
: A `Matroska Reader` with a primary purpose of playing audiovisual files, including `Matroska` documents.

# Basis in EBML

Matroska is a Document Type of EBML (Extensible Binary Meta Language).
This specification is dependent on the EBML Specification [@!RFC8794].
For an understanding of Matroska's EBML Schema, see in particular the sections of the EBML Specification covering
EBML Element Types (Section 7),
EBML Schema (Section 11.1),
and EBML Structure (Section 3).

## Added Constraints on EBML

As an EBML Document Type, Matroska adds the following constraints to the EBML specification.

- The `docType` of the `EBML Header` **MUST** be "matroska".
- The `EBMLMaxIDLength` of the `EBML Header` **MUST** be "4".
- The `EBMLMaxSizeLength` of the `EBML Header` **MUST** be between "1" and "8" inclusive.

## Matroska Design

The Root Element and all Top-Levels Elements use 4 octets for their EBML Element ID -- i.e. Segment and direct children of Segment.

Matroska writers **MUST NOT** use  EBML Empty Elements, elements present in the file but with a length of zero,
if the element has a default value is not 0 for integers/dates and 0x0p+0 for floats.
This is to preserve compatibility with existing parsers that didn't interpret this EBML feature properly.
Therefore any element that is not mandatory **SHOULD NOT** have a default value.

A default value of 0 for integers/dates and 0x0p+0 for floats are tolerated as a zero length is correctly handled by legacy parsers.
In this case an Empty Element is both interpreted as the default value or 0 for numbers.

# Language Codes

Matroska from version 1 through 3 uses language codes that can be either the 3 letters
bibliographic ISO-639-2 form [@!ISO639-2] (like "fre" for french),
or such a language code followed by a dash and a country code for specialities in languages (like "fre-ca" for Canadian French).
The `ISO 639-2 Language Elements` are "Language Element", "TagLanguage Element", and "ChapLanguage Element".

Starting in Matroska version 4, either [@!ISO639-2] or [@!BCP47] **MAY** be used,
although `BCP 47` is **RECOMMENDED**. The `BCP 47 Language Elements` are "LanguageIETF Element",
"TagLanguageIETF Element", and "ChapLanguageIETF Element". If a `BCP 47 Language Element` and an `ISO 639-2 Language Element`
are used within the same `Parent Element`, then the `ISO 639-2 Language Element` **MUST** be ignored and precedence given to the `BCP 47 Language Element`.

Country codes are the same 2 octets country-codes as in Internet domains [@!IANADomains] based on [@!ISO3166-1] alpha-2 codes.

