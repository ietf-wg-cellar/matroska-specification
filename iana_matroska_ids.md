# IANA Considerations

## Matroska Element IDs Registry

IANA has created a new registry called the "Matroska Element IDs"
registry.

To register a new Element ID in this registry, one needs
an Element ID, an Element Name,
a Change Controller (IETF or email of registrant), and
an optional Reference to a document describing the Element ID.

Element IDs are encoded
using the VINT mechanism described in [@!RFC8794, section 4] and can be between
one and five octets long. Five-octet Element IDs are possible
only if declared in the EBML Header.

Element IDs are described in [@!RFC8794, section 5], with the changes in [@Err7189] and [@Err7191].

One-octet Matroska Element IDs (range 0x80-0xFE) are to be allocated according to the "RFC Required" policy [@!RFC8126].

Two-octet Matroska Element IDs (range 0x407F-0x7FFE) are to be allocated according to the "Specification Required" policy [@!RFC8126].

Two-octet Matroska Element IDs between 0x0100 and 0x407E are not valid for use as an Element ID.

Three-octet (range 0x203FFF-0x3FFFFE) and four-octet Matroska Element IDs (range 0x101FFFFF-0x1FFFFFFE) are to be allocated according to the "First Come First Served" policy [@!RFC8126].

Three-octet Matroska Element IDs between 0x010000 and 0x203FFE are not valid for use as an Element ID.

Four-octet Matroska Element IDs between 0x01000000 and 0x101FFFFE are not valid for use as an Element ID.

The allowed values in the "Matroska Element IDs" registry are similar to the ones found
in the "EBML Element IDs" registry defined in [@!RFC8794, section 17.1].

EBML Element IDs defined for the EBML Header -- as defined in [@!RFC8794, section 17.1] --
**MUST NOT** be used as Matroska Element IDs.

Given the scarcity of one-octet Element IDs, they should only be created to save space for elements found many times in a file
(for example, `BlockGroup` or `Chapters`). The four-octet Element IDs are mostly for synchronization of large elements.
They should only be used for such high-level elements.
Elements that are not expected to be used often should use three-octet Element IDs.

Elements found in (#historic-deprecated-elements) have an assigned Matroska Element ID for historical reasons.
These elements are not in use and **SHOULD NOT** be reused unless there are no other IDs available with the desired size.
Such IDs are marked as "Reclaimed" in the "Matroska Element IDs" registry, as they could be used for other things in the future.

(#iana-table) shows the initial contents of the "Matroska Element IDs" registry.
The Change Controller for the initial entries is the IETF.

