%%%
title = "Matroska Media Container Tag Specifications"
abbrev = "Matroska Tags"
ipr= "trust200902"
area = "art"
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

This document defines the Matroska tags, namely the tag names and their respective semantic meaning.

{mainmatter}

# Introduction

Matroska is a multimedia container format defined in [@!RFC9559]. It can store timestamped multimedia data
but also chapters and tags. The `Tag` elements add important metadata to identify and classify the information found
in a Matroska `Segment`. It can tag a whole `Segment`, separate `Tracks` elements, individual `Chapter` elements or `Attachments` elements.

Some details about tagging are already present in [@!RFC9559, section 24].

While the Matroska tagging framework allows anyone to create their own custom tags, it is important to have a common
set of values for interoperability. This document defines a set of common tag names used in Matroska.

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are
to be interpreted as described in BCP 14 [@!RFC2119]
[@!RFC8174] when, and only when, they appear in all capitals,
as shown here.

