# Security Considerations

Matroska inherits security considerations from EBML.

Attacks on a `Matroska Reader` could include:

- Storage of a arbitrary and potentially executable data within an `Attachment Element`.
  `Matroska Readers` that extract or use data from Matroska Attachments **SHOULD**
  check that the data adheres to expectations.
- A `Matroska Attachment` with an inaccurate mime-type.

