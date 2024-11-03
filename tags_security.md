# Security Considerations

This document inherits security considerations from the EBML [@!RFC8794] and Matroska [@!RFC9559] documents.

Tag values can be either `TagString` or `TagBinary` blobs. In both cases issues can happen if the parsing of the data fails.

Most of the time strings are kept as-is and don't pose a security issue, apart from invalid UTF-8 values.

String tags that are parsed like "REPLAYGAIN_GAIN" or "REPLAYGAIN_PEAK" defined in (#technical-information)
or string tags following the rules from (#tagstring-formatting) or string tags following other strict formats like URLs
may cause issues when the string is bogus or in an unexpected format.

Binary tags that need to be parsed like "MCDI" defined in (#identifiers) may cause issues when the data is bogus or incomplete.

Due to the nature of nested `SimpleTag`, it is possible to exhaust the memory of the host app by using very deep nesting.
An host app **MAY** add some limits to the amount of nesting possible to avoid such issues.

