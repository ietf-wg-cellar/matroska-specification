# Security Considerations

Matroska inherits security considerations from EBML.

Attacks on a `Matroska Reader` could include:

* Storage of a arbitrary and potentially executable data within an `Attachment Element`.
  `Matroska Readers` that extract or use data from Matroska Attachments **SHOULD**
  check that the data adheres to expectations or not use the attachement.

* A `Matroska Attachment` with an inaccurate media type.

* Damage to the Encryption and Compression fields ((#encryption)) that would result in bogus binary data
  interpreted by the decoder.

* Chapter Codecs running unwanted commands on the host system.

`Matroska Reader` implementations need to be robust against malicious payloads. 
Those related to denial of service are outlined in Section 2.1 of [RFC4732].  
Although rarer, the same may apply to a `Matroska Writer`.  Malicious stream data
must not cause the Writer to misbehave, as this might allow an attacker access
to transcoding gateways.

As an audio and visual container format, a Matroska file or stream will
potentially encapsulate numerous byte streams created with a variety of
codecs.  Implementers will need to consider the security considerations of
these encapsulated formats.
