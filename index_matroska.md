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
- Menus (like DVDs have [@?DVD-Video])

Matroska is an open standards project published as an IETF Standard Track RFC.
As per the terms of BCP 78 [@?RFC5378], the technical specifications describing the bitstream are open to everybody.
This specification falls under the terms of BCP 79 [@?RFC8179] with respect to IPR claims.
 While there are patent claims associated with some codecs that can be contained within
a Matroska container, the container itself is free of all such claims.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of
the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/).
But since it's quite complete it is used as a reference for the development of libmatroska.

This document covers Matroska versions 1, 2, 3 and 4. Matroska v4 is the current version.
Matroska 1 to 3 are no longer maintained. No new elements are expected in files with version numbers 1, 2, or 3.

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

# Matroska Overview

## Principles

Matroska is a Document Type of EBML (Extensible Binary Meta Language).
This specification is dependent on the EBML Specification [@!RFC8794].
For an understanding of Matroska's EBML Schema, see in particular the sections of the EBML Specification covering
EBML Element Types (Section 7),
EBML Schema (Section 11.1),
and EBML Structure (Section 3).

## Added EBML Constraints

As an EBML Document Type, Matroska adds the following constraints to the EBML specification.

- The `docType` of the `EBML Header` **MUST** be "matroska".
- The `EBMLMaxIDLength` of the `EBML Header` **MUST** be "4".
- The `EBMLMaxSizeLength` of the `EBML Header` **MUST** be between "1" and "8" inclusive.

## Design Rules

The Root Element and all Top-Levels Elements use 4 octets for their EBML Element ID -- i.e. Segment and direct children of Segment.

Legacy EBML/Matroska parsers did not handle Empty Elements properly, elements present in the file but with a length of zero.
They always assumed the value was 0 for integers/dates and 0x0p+0 for floats, no matter the default value of the element which should have been used instead.
Therefore Matroska writers **MUST NOT** use EBML Empty Elements, if the element has a default value that is not 0 for integers/dates and 0x0p+0 for floats.

When adding new elements to Matroska, these rules **MUST** be followed:

* A non-mandatory integer/date Element **MUST NOT** have a default value other than 0.
* A non-mandatory float Element **MUST NOT** have a default value other than 0x0p+0.
* A non-mandatory string Element  **MUST NOT** have a default value, as empty string cannot be defined in the XML Schema.

