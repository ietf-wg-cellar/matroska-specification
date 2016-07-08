# Matroska Schema

This specification includes an `EBML Schema` which defines the Elements and structure of Matroska as an EBML Document Type. The EBML Schema defines every valid Matroska element in a manner defined by the EBML specification.

For convenience the section of the EBML specification that defines EBML Schema Element Attributes is restated here:

## EBML Schema Element Attributes

Within an EBML Schema the `<EBMLSchema>` uses the following attributes to define the EBML Schema:

| attribute name | required | definition |
|:---------------|:---------|:-----------|
| docType        | Yes      | The `docType` lists the official name of the EBML Document Type that is defined by the EBML Schema; for example, `<EBMLSchema docType="matroska">`. |
| version        | Yes      | The `version` lists an incremental non-negative integer that specifies the version of the docType documented by the EBML Schema. Unlike XML Schemas, an EBML Schema documents all versions of a docType's definition rather than using separate EBML Schemas for each version of a docType. Elements may be introduced and deprecated by using the `minver` and `maxver` attributes of <element>. |

Within an EBML Schema the `<element>` uses the following attributes to define an EBML Element.

| attribute name | required | definition |
|:---------------|:---------|:-----------|
| name           | Yes      | The official human-readable name of the EBML Element. The value of the name MUST be in the form of an NCName as defined by the [XML Schema specification](http://www.w3.org/TR/1999/REC-xml-names-19990114/#ns-decl). |
| level          | Yes      | The level notes at what hierarchical depth the EBML Element may occur within an EBML Document. The Root Element of an EBML Document is at level 0 and the Elements that it may contain are at level 1. The level MUST be expressed as an integer. Note that Elements defined as `global` and `recursive` MAY occur at a level greater than or equal to the defined `level`.|
| global         | No       | A boolean to express if an EBML Element MUST occur at its defined level or may occur within any Parent EBML Element. If the `global` attribute is not expressed for that Element then that element is to be considered not global. |
| id             | Yes      | The Element ID expressed in hexadecimal notation prefixed by a '0x'. To reduce the risk of false positives while parsing EBML Streams, the IDs of the Root Element and Top-Level Elements SHOULD be at least 4 octets in length. Element IDs defined for use at Level 0 or Level 1 MAY use shorter octet lengths to facilitate padding and optimize edits to EBML Documents; for instance, the EBML Void Element uses an Element ID with a one octet length to allow its usage in more writing and editing scenarios. |
| minOccurs      | No       | An integer to express the minimal number of occurrences that the EBML Element MUST occur within its Parent Element if its Parent Element is used. If the Element has no Parent Level (as is the case with Elements at Level 0), then minOccurs refers to constaints on the Element's occurrence within the EBML Document. If the minOccurs attribute is not expressed for that Element then that Element shall be considered to have a minOccurs value of 0. This value of minOccurs MUST be a positive integer. The semantic meaning of minOccurs within an EBML Schema is considered analogous to the meaning of minOccurs within an [XML Schema](https://www.w3.org/TR/xmlschema-0/#ref6). Note that Elements with minOccurs set to "1" that also have a default value declared are not required to be stored but are required to be interpretted, see the `Note on the Use of default attributes to define Mandatory EBML Elements`. |
| maxOccurs       | No       | A value to express the maximum number of occurrences that the EBML Element MAY occur within its Parent Element if its Parent Element is used. If the Element has no Parent Level (as is the case with Elements at Level 0), then maxOccurs refers to constaints on the Element's occurrence within the EBML Document. This value may be either a positive integer or the term `unbounded` to indicate there is no maximum number of occurrences or the term `identical` to indicate that the Element is an `Identically Recurring Element`. If the maxOccurs attribute is not expressed for that Element then that Element shall be considered to have a maxOccurs value of 1. The semantic meaning of maxOccurs within an EBML Schema is considered analogous to the meaning of minOccurs within an [XML Schema](https://www.w3.org/TR/xmlschema-0/#ref6), with EBML Schema adding the concept of Identically Recurring Elements. |
| range          | No       | For Elements which are of numerical types (Unsigned Integer, Signed Integer, Float, and Date) a numerical range may be specified. If specified that the value of the EBML Element MUST be within the defined range inclusively. See the `section of Expressions of range` for rules applied to expression of range values. |
| default        | No       | A default value may be provided. If an Element is mandatory but not written within its Parent EBML Element, then the parser of the EBML Document MUST insert the defined default value of the Element. EBML Elements that are Master-elements MUST NOT declare a default value. |
| type           | Yes      | As defined within the `section on EBML Element Types`, the type MUST be set to one of the following values: 'integer' (signed integer), 'uinteger' (unsigned integer), 'float', 'string', 'date', 'utf-8', 'master', or 'binary'. |
| unknownsizeallowed | No       | A boolean to express if an EBML Element MAY be used as an `Unknown-Sized Element` (having all VINT\_DATA bits of Element Data Size set to 1). The `unknownsizeallowed` attribute only applies to Master-elements. If the `unknownsizeallowed` attribute is not used it is assumed that the element is not allowed to use an unknown Element Data Size. |
| recursive | No       | A boolean to express if an EBML Element MAY be stored recursively. In this case the Element MAY be stored at levels greater that defined in the `level` attribute if the Element is a Child Element of a Parent Element with the same Element ID. The `recursive` attribute only applies to Master-elements. If the `recursive` attribute is not used it is assumed that the element is not allowed to be used recursively.|
| minver         | No       | The `minver` (minimum version) attribute stores a non-negative integer that represents the first version of the docType to support the element. If the `minver` attribute is not used it is assumed that the element has a minimum version of "1". |
| maxver         | No       | The `maxver` (maximum version) attribute stores a non-negative integer that represents the last or most recent version of the docType to support the element. If the `maxver` attribute is not used it is assumed that the element has a maximum version equal to the value stored in the `version` attribute of <EBMLSchema>. |

The `<element>` nodes shall contain a description of the meaning and use of the EBML Element stored within one or many `<documentation>` sub-elements. The `<documentation>` sub-element may use a `lang` attribute which may be set to the RFC 5646 value of the language of the element's documentation. The `<documentation>` sub-element may use a `type` attribute to distinguish the meaning of the documentation. Recommended values for the `<documentation>` sub-element's `type` attribute include: `definition`, `rationale`, `usage notes`, and `references`.

The `<element>` nodes MUST be arranged hierarchically according to the permitted structure of the EBML Document Type. An `<element>` node that defines an EBML Element which is a Child Element of another Parent Element MUST be stored as an immediate sub-element of the `<element>` node that defines the Parent Element. `<element>` nodes that define Level 0 Elements and Global Elements should be sub-elements of `<EBMLSchema>`.

## Matroska Additions to Schema Element Attributes

In addition to the EBML Schema definition provided by the EBML Specification, Matroska adds the following additional attributes:

| attribute name | required | definition |
|:---------------|:---------|:-----------|
| webm           | No       | A boolean to express if the Matroska Element is also supported within version 2 of the `webm` specification. Please consider the [webm specification](http://www.webmproject.org/docs/container/) as the authoritative on `webm`. |

## Matroska Schema

Here the definition of each Matroska Element is provided.

% concatenate with Matroska EBML Schema converted to markdown %
