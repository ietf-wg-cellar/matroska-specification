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


One-octet Element IDs **MUST** be between 0x80 and
0xFE. These items are valuable because they are short, and they need
to be used for commonly repeated elements. Element IDs are to be
allocated within this range according to the "RFC Required"
policy [@!RFC8126].

The following one-octet Element ID is RESERVED: 0xFF.

Values in the one-octet range of 0x00 to 0x7F are not valid for use
as an Element ID.

Two-octet Element IDs **MUST** be between 0x407F and
0x7FFE. Element IDs are to be allocated within this range according to
the "Specification Required" policy
[@!RFC8126].

The following two-octet Element ID is RESERVED: 0x7FFF.

Values in the two-octet ranges of 0x0000 to 0x4000 and 0x8000 to 0xFFFF are
not valid for use as an Element ID.

Three-octet Element IDs **MUST** be between 0x203FFF and 0x3FFFFE.
Element IDs are to be allocated within this range according to the "First Come First Served" policy [@!RFC8126].

The following three-octet Element ID is RESERVED: 0x3FFFFF.

Values in the three-octet ranges of 0x000000 to 0x200000 and
0x400000 to 0xFFFFFF are not valid for use as an Element ID.

Four-octet Element IDs **MUST** be between 0x101FFFFF
and 0x1FFFFFFE. Four-octet Element IDs are somewhat special in that
they are useful for resynchronizing to major structures in the event
of data corruption or loss. As such, four-octet Element IDs are split
into two categories. Four-octet Element IDs whose lower three octets
(as encoded) would make printable 7-bit ASCII values (0x20 to 0x7E,
inclusive) **MUST** be allocated by the "Specification
Required" policy. Sequential allocation of values is not
required: specifications **SHOULD** include a specific
request and are encouraged to do early allocations.

To be clear about the above category: four-octet Element IDs always start
with hex 0x10 to 0x1F, and that octet may be chosen so that the entire VINT
has some desirable property, such as a specific CRC. The other three octets,
when ALL having values between 0x20 (32, ASCII Space) and 0x7E (126, ASCII
"~"), fall into this category.

Other four-octet Element IDs may be allocated by the "First Come First Served" policy.

The following four-octet Element ID is RESERVED:  0x1FFFFFFF.

Values in the four-octet ranges of 0x00000000 to 0x10000000 and 0x20000000
to 0xFFFFFFFF are not valid for use as an Element ID.

Five-octet Element IDs (values from 0x080FFFFFFF to 0x0FFFFFFFFE) are RESERVED according to the "Experimental Use" policy [@!RFC8126]: they may be used by anyone at any time, but there is no coordination.

EBML IDs defined for the EBML Header -- as defined in Section 17.1 of [@!RFC8794] --
**MUST NOT** be used as Matroska Element IDs.

Matroska Element IDs Values found in this document are assigned as initial values as follows:

