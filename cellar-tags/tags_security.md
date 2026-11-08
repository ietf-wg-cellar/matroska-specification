# Security Considerations

This document inherits security considerations from the EBML [@!RFC8794] and Matroska [@!RFC9559] documents.

Tag values can be either `TagString` or `TagBinary` blobs. In both cases, issues can happen if the parsing of the data fails.

Most of the time, strings are kept as is and do not pose a security issue, apart from invalid UTF-8 values.
Implementations **MUST** validate `TagString` inputs for UTF-8 correctness and
a reasonable length before use, in accordance with the security considerations in [@!RFC3629, section 10] and [@!RFC9839, section 7].

String tags that are parsed (such as "REPLAYGAIN_GAIN" or "REPLAYGAIN_PEAK" defined in (#technical-information)),
string tags that follow the `TagString` formatting rules ((#tagstring-formatting)), or string tags that follow other strict formats such as URLs
may cause issues when the string is bogus or in an unexpected format.

Binary tags that need to be parsed (such as the "MCDI" defined in (#external-identifiers)) may cause issues when the data is bogus or incomplete.

Some tags, such as "URL" ((#nested-information)) and "PURCHASE_ITEM" ((#commercial)) contain a URL.
Bogus or altered URLs may direct the user to unwanted places.

Due to the nature of nested `SimpleTag` elements, it is possible to exhaust the memory of the host application by using very deep nesting.
A host application **MAY** add some limits to the amount of nesting possible to avoid such issues.

Some elements found in Sections (#nested-information, use counter) and (#user-information, use counter) may contain physical addresses, emails, etc. about a person. Care should be taken
not to provide such files to people who ought not have this information when it is not
public knowledge. This can be achieved by either removing personal information or controlling the diffusion of files
containing these pieces of information.

