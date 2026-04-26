%%%
title = "Matroska Media Container v4 Additions"
abbrev = "Matroska Tags"
ipr= "trust200902"
area = "art"
submissiontype = "IETF"
workgroup = "cellar"
date = @BUILD_DATE@
keyword = ["binary","storage","matroska","ebml"]

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

This document defines additions to to the Matroska multimedia container version 4.

{mainmatter}

# Introduction

Matroska is a multimedia container format. It can store timestamped multimedia data
but also chapters and tags.
[@!RFC9559] define the parts of Matroska that have existed for a decade or more.
This document defines new elements, codec mapping that were not defined so far.
All EBML elements added are backward compatible with version 4 of Matroska file. 
So the `minver` attribute for these EBML elements is "4".

# Status of This Document

This document only covers new additions to version 4 of the Matroska elements and features.
Matroska versions 1 to 4 are covered in [@!RFC9559].

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in BCP 14 [@!RFC2119] [@!RFC8174]
when, and only when, they appear in all capitals, as shown here.

