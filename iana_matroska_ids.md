# IANA Considerations

## Matroska Element IDs Registry

This document creates a new IANA registry called the "Matroska Element IDs"
registry.

To register a new Element ID in this registry, one needs an Element ID,
a Change Controller (IESG or email of registrant) and
an optional Reference to a document describing the Element ID.

Element IDs are described in Section 5 of [@!RFC8794].  Element IDs are encoded
using the VINT mechanism described in Section 4 of [@!RFC8794] and can be between
one and five octets long. Five-octet-long Element IDs are possible
only if declared in the EBML header.

One-octet Matroska Element IDs are to be allocated according to the "RFC Required" policy [@!RFC8126].

Two-octet Matroska Element IDs are to be allocated according to the "Specification Required" policy [@!RFC8126].

Three-octet and four-octet Matroska Element IDs are to be allocated according to the "First Come First Served" policy [@!RFC8126].

The allowed values in the Elements IDs registry are similar to the ones found
in the EBML Element IDs registry defined in Section 17.1 of [@!RFC8794].

EBML IDs defined for the EBML Header -- as defined in Section 17.1 of [@!RFC8794] --
**MUST NOT** be used as Matroska Element IDs.

Given the scarcity of the One-octet Element IDs, they should only be created to save space for elements found many times in a file.
For example within a BlockGroup or Chapters. The Four-octet Element IDs are mostly for synchronization of large elements.
They should only be used for such high level elements.
Elements that are not expected to be used often should use Three-octet Element IDs.

Elements found in (#annex-a-historic-deprecated-elements) have an assigned Matroska Element ID for historical reasons.
These elements are not in use and **SHOULD NOT** be reused unless there is no other IDs available with the desired size.
Such IDs are considered as `returned` to the IANA registry as they could be used for other things in the future.

Matroska Element IDs Values found in this document are assigned as initial values as follows:

