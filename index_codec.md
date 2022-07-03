%%%
title = "Matroska Media Container Codec Specifications"
abbrev = "Matroska Codec"
ipr= "trust200902"
area = "art"
submissiontype = "IETF"
workgroup = "cellar"
date = @BUILD_DATE@
keyword = ["binary","storage","matroska","ebml","webm","codec"]

[seriesInfo]
name = "Internet Draft"
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

This document defines the Matroska codec mappings, including the codec ID, layout of data
in a `Block Element` and in an optional `CodecPrivate Element`.

{mainmatter}

# Introduction

Matroska is a multimedia container format.
It stores interleaved and timestamped audio/video/subtitle data using various codecs.
To interpret the codec data, a mapping between the way the data is stored in Matroska and
how it is understood by such a codec is necessary.

This document intends to define this mapping for many commonly used codecs in Matroska.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part
of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/).
It uses basic elements and concept already defined in the Matroska specifications defined by this workgroup [@!Matroska].

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in BCP 14 [@!RFC2119] [@!RFC8174]
when, and only when, they appear in all capitals, as shown here.

