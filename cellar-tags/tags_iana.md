# IANA Considerations

## Matroska Tag Names Registry

IANA has created a new registry called the "Matroska Tag Names"
registry.

To register a new tag name in this registry, one needs
a Tag Name, a Tag Type,
a Change Controller, and
an optional Reference to a document describing the Element ID.

The Name corresponds to the value stored in the `TagName` element.
The Name is limited to Latin capital letters, numbers, and the underscore character '\_'
as defined in (#tag-formatting). The Name must not start with the underscore character '\_'.

The Type corresponds to which element will be stored the tag value.
There can be 3 values for the Type:

* `UTF-8`: The value of the Tag is stored in `TagString`.

Matroska Tag Names for UTF-8 data are to be allocated according to the First Come First Served policy [@!RFC8126].

* `binary`: The value of the Tag is stored in `TagBinary`.

Matroska Tag Names for binary data are to be allocated according to the Specification Required policy [@!RFC8126].

* `nested`: The tag does not contain a value, i.e., it has neither a `TagBinary` nor a `TagString` child element; it contains only `SimpleTag` child elements.

Matroska Tag Names for nested tags are to be allocated according to the Specification Required policy [@!RFC8126].

Matroska Tag Names values found in this document have been assigned as follows:

