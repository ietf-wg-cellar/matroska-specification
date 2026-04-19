%%%
title = "Matroska Media Container Version 4 Update 1"
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

This document defines additions to the Matroska multimedia container version 4.

{mainmatter}

# Introduction

Matroska is a multimedia container format. It can store timestamped multimedia data
but also chapters and tags.

# Status of This Document

This document is an update to [@!RFC9559].
It only covers the Matroska elements and features with a `minver` attribute value of "4"
combined with an `update` attribute value of "1". These new EBML Schema attributes are defined in [@?I-D.ietf-cellar-ebml-update1].
Matroska versions 1 to 4 without an `update` attribute set are covered in [@!RFC9559].

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in BCP 14 [@!RFC2119] [@!RFC8174]
when, and only when, they appear in all capitals, as shown here.

