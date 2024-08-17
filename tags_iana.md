# IANA Considerations

## Matroska Tags Names Registry

IANA has created a new registry called the "Matroska Tag Names"
registry.

To register a new Tag Name in this registry, one needs
a Name, a Type,
a Change Controller, and
an optional Reference to a document describing the Element ID.

The Name corresponds to the value stored in the `TagName` element.
The Name **SHOULD** always be written in all capital letters and contain no space
as defined in (#tag-formatting),

The Type corresponds to which element will be stored the tag value.
There can be 3 values for the Type:

* `UTF-8`: the value of the Tag is stored in `TagString`,
* `binary`: the value of the Tag is stored in `TagBinary`,
* `nested`: the tag doesn't contain a value, only nested tags inside.

Matroska Tag Names Values found in this document are assigned as initial values as follows:

