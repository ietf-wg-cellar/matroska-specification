%%%
title = "Matroska Media Container Tag Specifications"
abbrev = "Matroska Tags"
ipr= "trust200902"
area = "art"
workgroup = "cellar"
keyword = [""]

[seriesInfo]
name = "Internet-Draft"
stream = "IETF"
status = "informational"
value = "draft-ietf-cellar-tags-04"

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

This document defines the Matroska tags, namely the tag names and their respective semantic meaning.

{mainmatter}

# Introduction

Matroska aims to become THE standard of multimedia container formats. It can store timestamped multimedia data but also chapters and tags. The `Tag Elements` add important metadata to identify and classify the information found in a `Matroska Segment`. It can tag a whole `Segment`, separate `Track Elements`, individual `Chapter Elements` or `Attachment Elements`.

While the Matroska tagging framework allows anyone to create their own custom tags, it's important to have a common set of values for interoperability. This document intends to define a set of common tag names used in Matroska.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/). It uses basic elements and concepts already defined in the Matroska specifications defined by this workgroup.

# Security Considerations

`Tag` values can be either strings or binary blobs. This document inherits security considerations from the EBML and Matroska documents.

# IANA Considerations

To be determined.

# Notations and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [@!RFC2119] [@!RFC8174] when, and only when, they appear in all capitals, as shown here.

