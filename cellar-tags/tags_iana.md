# IANA Considerations

## Matroska Tags Names Registry

IANA has created a new registry called the "Matroska Tag Names"
registry.

To register a new Tag Name in this registry, one needs
a Name, a Type,
a Change Controller, and
an optional Reference to a document describing the Element ID.

The Name corresponds to the value stored in the `TagName` element.
A Tag Name **MUST** only be found once in the IANA registry.
Two Tag Names **MUST NOT** have the same semantic meaning.
The Name is written in all UTF-8 capital letters, numbers and the underscore character '_'
as defined in (#tag-formatting). The Name **MUST NOT** start with the underscore character '_'.

The Type corresponds to which element will be stored the tag value.
There can be 3 values for the Type:

* `UTF-8`: the value of the Tag is stored in `TagString`,

Matroska Tag Names for UTF-8 data are to be allocated according to the "First Come First Served" policy [@!RFC8126].

* `binary`: the value of the Tag is stored in `TagBinary`,

Matroska Tag Names for binary data are to be allocated according to the "Specification Required" policy [@!RFC8126].
The content of the binary data **MUST NOT** be a single UTF-8 string, in which case the type should be `UTF-8`.
It is **RECOMMENDED** to not include the size of the binary data at the start of the data as the size is already handled by the element itself.

* `nested`: the tag doesn't contain a value, i.e., neither a `TagBinary` nor a `TagString` child element, only `SimpleTag` child elements inside.

Matroska Tag Names for nested tags are to be allocated according to the "Specification Required" policy [@!RFC8126].

Matroska Tag Names Values found in this document are assigned as initial values as follows:

