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
status = "informational"
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

This document defines common Matroska Chapter Codecs, the basic Matroska Script and the DVD inspired DVD menu.

{mainmatter}

# Introduction

*TODO*

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part
of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/).
It uses basic elements and concepts already defined in the Matroska specifications defined by this workgroup.

# Security Considerations

`Tag` values can be either strings or binary blobs. This document inherits security
considerations from the EBML and Matroska documents.

# IANA Considerations

To be determined.

# Notation and Conventions

The key words "**MUST**", "**MUST NOT**",
"**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**",
"**RECOMMENDED**", "**NOT RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in BCP 14 [@!RFC2119] [@!RFC8174]
when, and only when, they appear in all capitals, as shown here.

