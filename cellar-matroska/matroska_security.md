# Security Considerations

Matroska inherits security considerations from EBML [@!RFC8794].

Attacks on a `Matroska Reader` could include:

* Storage of an arbitrary and potentially executable data within an `Attachments` element.
  `Matroska Readers` that extract or use data from `Matroska Attachments` **SHOULD**
  check that the data adheres to expectations or not use the attachment.

* A `Matroska Attachment` with an inaccurate media type.

* Damage to the Encryption and Compression fields ((#encryption)) that would result in bogus binary data
  interpreted by the decoder.

* Chapter Codecs running unwanted commands on the host system.

The same error handling done for EBML applies to Matroska files.
Particular error handling is not covered in this specification, as this is
depends on the goal of the `Matroska Readers`.
`Matroska Readers` decide how to handle the errors whether or not they are
recoverable in their code.
For example, if the checksum of the `\Segment\Tracks` is invalid, some
could decide to try to read the data anyway, some will just reject the file,
and most will not even check it.

`Matroska Reader` implementations need to be robust against malicious payloads. Those related to denial of service are outlined in [@RFC4732, section 2.1].

Although rarer, the same may apply to a `Matroska Writer`.  Malicious stream data
must not cause the `Matroska Writer` to misbehave, as this might allow an attacker access
to transcoding gateways.

As an audio/video container format, a Matroska file or stream will
potentially encapsulate numerous byte streams created with a variety of
codecs.  Implementers will need to consider the security considerations of
these encapsulated formats.

## Security Considerations for Content Credentials

A `Matroska Player` **MUST NOT** treat the presence of a C2PA Manifest attachment as proof of authenticity, see (Section 21.3). Provenance information **SHOULD** be validated according to the rules defined in the C2PA Specification [?C2PASpec] before it is used to influence any user interface or security decisions.

Attachments **MUST NOT** be executed or interpreted as code. If a manifest references external resources, such as remote manifests or certificates, a `Matroska Player` **SHOULD** avoid automatically fetching these resources without explicit user consent or a trusted policy framework, to prevent potential leakage of information or tracking.
