# Security Considerations

This document inherits security considerations from the EBML [@!RFC8794] and Matroska [@!RFC9559] documents.

Tag values can be either `TagString` or `TagBinary` blobs. In both cases issues can happen if the parsing of the data fails.

Most of the time strings are kept as-is and don't pose a security issue, apart from invalid UTF-8 values.
Implementations **MUST** validate `TagString` inputs for UTF-8 correctness and
reasonable length before use, in accordance with the security considerations in [@!RFC3629, section 10].

String tags that are parsed like "REPLAYGAIN_GAIN" or "REPLAYGAIN_PEAK" defined in (#technical-information)
or string tags following the rules from (#tagstring-formatting) or string tags following other strict formats like URLs
may cause issues when the string is bogus or in an unexpected format.

Binary tags that need to be parsed like "MCDI" defined in (#external-identifiers) may cause issues when the data is bogus or incomplete.

Some tags like "URL" ((#nested-information)) and "PURCHASE_URL" ((#commercial)) contain a URL.
Bogus or altered URLs may direct the user to unwanted places.

Due to the nature of nested `SimpleTag`, it is possible to exhaust the memory of the host app by using very deep nesting.
A host app **MAY** add some limits to the amount of nesting possible to avoid such issues.

Some elements found in (#nested-information) and (#user-information) may contain physical addresses, email, etc. about a person. Care should be taken
to ensure not to provide such files to people that ought not have this information when it's not
public knowledge. This can be achieved by either removing personal information or by controlling the diffusion of files
containing these pieces of information.

