%%%
title = "Matroska Media Container Chapter Codecs Specifications"
abbrev = "Matroska Chapter Codecs"
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

This document defines common Matroska multimedia container Chapter Codecs, the basic Matroska Script and the DVD inspired DVD menu [@?DVD-Video].

{mainmatter}

# Introduction

The [@!RFC9559] container can be expanded with Matroska Chapter Codecs. They define a set of instructions
that the `Matroska Player` should execute when entering, leaving or during playback of a Chapter.
This allows extra features not provided by the classical linear playback of files.

The Matroska Chapter Codecs codec is extensible. So any new codec can be created
and support added in players.

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are
to be interpreted as described in BCP 14 [@!RFC2119]
[@!RFC8174] when, and only when, they appear in all capitals,
as shown here.

