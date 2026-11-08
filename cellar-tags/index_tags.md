%%%
title = "Matroska Media Container Tag Specifications"
abbrev = "Matroska Tags"
ipr= "trust200902"
area = "ART"
submissiontype = "IETF"
workgroup = "cellar"
date = @BUILD_DATE@
keyword = ["binary","storage","matroska","ebml","tags"]

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

Matroska is a multimedia container format. It can store timestamped multimedia data
as well as chapters and tags.

The `Tag` elements add important metadata to identify and classify the information found
in a Matroska `Segment`.

This document defines the Matroska multimedia container tags, namely the tag names and their respective semantic meanings.

{mainmatter}

# Introduction

Matroska is a multimedia container format that can store timestamped multimedia data as well as chapters and tags.

The `Tag` elements can tag a whole `Segment`, separate `Tracks` elements, individual `Chapters` elements, or `Attachments` elements.

Some details about tagging are presented in [@!RFC9559, section 24].
Readers of this document should be familiar with that section, the different high-level parts of Matroska as defined in [@!RFC9559, section 4.5],
and Extensible Binary Meta Language (EBML) Master Elements as defined in [@!RFC8794, section 7.7].

Matroska Tags consist of a name and a value.
Unlike EBML or Matroska elements, they are not dependent on the version of the file.
All tags defined in this document, and even others, can be used in all versions of Matroska.

While the Matroska tagging framework allows anyone to create their own custom tags, it is important to have a common
set of values for interoperability.

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are
to be interpreted as described in BCP 14 [@!RFC2119]
[@!RFC8174] when, and only when, they appear in all capitals,
as shown here.

