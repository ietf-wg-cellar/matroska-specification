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
name = "RFC"
value = "9559"
stream = "IETF"
status = "standard"

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

This document defines the Matroska audiovisual data container structure, including definitions of its structural elements,
terminology, vocabulary, and application.

This document updates RFC 8794 to permit the use of a previously reserved Extensible Binary Meta Language (EBML) Element ID.

{mainmatter}

# Introduction

Matroska is an audiovisual data container format. It was derived from a project called [@?MCF]
but diverges from it significantly because it is based on EBML (Extensible Binary Meta Language) [@!RFC8794],
a binary derivative of XML. EBML provides significant advantages in terms of future format extensibility,
without breaking file support in parsers reading the previous versions.

To avoid any misunderstandings, it is essential to clarify exactly what an audio/video container is:

- It is NOT a video or audio compression format (codec).

- It is an envelope in which there can be many audio, video, and subtitles streams,
  allowing the user to store a complete movie or CD in a single file.

Matroska is designed with the future in mind. It incorporates features such as:

- Fast seeking in the file

- Chapter entries

- Full metadata (tags) support

- Selectable subtitle/audio/video streams

- Modularly expandable

- Error resilience (can recover playback even when the stream is damaged)

- Streamable over the Internet and local networks (HTTP [@?RFC9110], FTP [@?RFC0959], SMB [@?SMB-CIFS], etc.)

- Menus (like DVDs have [@?DVD-Video])

# Status of This Document

This document covers Matroska versions 1, 2, 3, and 4. Matroska version 4 is the current version.
Matroska versions 1 to 3 are no longer maintained. No new elements are expected in files with version numbers 1, 2, or 3.

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

: A `Matroska Reader` with the primary purpose of playing audiovisual files, including `Matroska` documents.

`Matroska Writer`:

: A data writer that creates `Matroska` documents.

# Matroska Overview

## Principles

Matroska is a Document Type of EBML.
This specification is dependent on the EBML specification [@!RFC8794].
For an understanding of Matroska's EBML Schema, see in particular the sections of the EBML specification that cover
EBML Element Types ([@RFC8794, 7]),
EBML Schema ([@RFC8794, 11.1]),
and EBML Structure ([@RFC8794, 3]).

## Updates to RFC 8794

Because of an oversight, [@!RFC8794] reserved EBML ID 0x80, which is used by deployed Matroska implementations.
For this reason, this specification updates [@!RFC8794] to make 0x80 a legal EBML ID.
Specifically, the following are changed in [@!RFC8794, section 17.1] (per Erratum ID #7189 [@Err7189])

OLD:

>   One-octet Element IDs **MUST** be between 0x81 and 0xFE.  These items are
>   valuable because they are short, and they need to be used for
>   commonly repeated elements.  Element IDs are to be allocated within
>   this range according to the "RFC Required" policy [@!RFC8126].
>
>   The following one-octet Element IDs are RESERVED: 0xFF and 0x80.

NEW:

>   One-octet Element IDs **MUST** be between 0x80 and 0xFE.  These items are
>   valuable because they are short, and they need to be used for
>   commonly repeated elements.  Element IDs are to be allocated within
>   this range according to the "RFC Required" policy [@!RFC8126].
>
>   The following one-octet Element ID is RESERVED: 0xFF.

* [@!RFC8794, section 5] (per Erratum ID #7191 [@Err7191])

OLD:

      +=========================+================+=================+
      | Element ID Octet Length | Range of Valid | Number of Valid |
      |                         |  Element IDs   |     Element IDs |
      +=========================+================+=================+
      |            1            |  0x81 - 0xFE   |             126 |
      +-------------------------+----------------+-----------------+

NEW:

      +=========================+================+=================+
      | Element ID Octet Length | Range of Valid | Number of Valid |
      |                         |  Element IDs   |     Element IDs |
      +=========================+================+=================+
      |            1            |  0x80 - 0xFE   |             127 |
      +-------------------------+----------------+-----------------+

## Added EBML Constraints

As an EBML Document Type, Matroska adds the following constraints to the EBML specification [@!RFC8794]:

- The `docType` of the `EBML Header` **MUST** be "matroska".

- The `EBMLMaxIDLength` of the `EBML Header` **MUST** be 4.

- The `EBMLMaxSizeLength` of the `EBML Header` **MUST** be between 1 and 8, inclusive.

## Design Rules

The Root Element and all Top-Level Elements **MUST** use 4 octets for their EBML Element ID -- i.e., Segment and direct children of Segment.

Legacy EBML/Matroska parsers did not handle Empty Elements properly, elements present in the file but with a length of zero.
They always assumed the value was 0 for integers/dates or 0x0p+0, the textual expression of floats using the format in [@!ISO9899], no matter the default value of the element that should have been used instead.
Therefore, Matroska Writers **MUST NOT** use EBML Empty Elements if the element has a default value that is not 0 for integers/dates and 0x0p+0 for floats.

When adding new elements to Matroska, these rules apply:

* A non-mandatory integer/date Element **MUST NOT** have a default value other than 0.

* A non-mandatory float Element **MUST NOT** have a default value other than 0x0p+0.

* A non-mandatory string Element  **MUST NOT** have a default value, as empty string cannot be defined in the XML Schema.

