---
---

% Title = "Matroska Codec"
% abbrev = "Matroska"
% category = "std"
% docName = "draft-lhomme-cellar-codec-01"
% ipr= "trust200902"
% area = "art"
% workgroup = "cellar"
% keyword = [""]
%
% [[author]]
% initials="S."
% surname="Lhomme"
% fullname="Steve Lhomme"
% [author.address]
% email="slhomme@matroska.org"
%
% [[author]]
% initials="M."
% surname="Bunkus"
% fullname="Moritz Bunkus"
% [author.address]
% email="moritz@bunkus.org"
%
% [[author]]
% initials="D."
% surname="Rice"
% fullname="Dave Rice"
% [author.address]
% email="dave@dericed.com"

.# Abstract

This document defines the Matroska codec mappings, including the codec ID, layout of data in a `Block` and in an optinal `CodecPrivate`.

{mainmatter}

# Introduction

Matroska aims to become THE standard of multimedia container formats. It stores interleaved and timestamped audio/video/subtitle data using various codec. To interpret the codec data, a mapping between the way the data are stored in Matroska and how they are understood by such codec is necessary.

This document intends to define this mapping for many commonly used codec in Matroska.

# Status of this document

This document is a work-in-progress specification defining the Matroska file format as part of the [IETF Cellar working group](https://datatracker.ietf.org/wg/cellar/charter/). It uses basic elements and concept already defined in the Matroska specifications defined by this workgroup.

# Security Considerations

Matroska Codecs inherits security considerations from EBML and Matroska.

# IANA Considerations

To be determined.

# Notations and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

