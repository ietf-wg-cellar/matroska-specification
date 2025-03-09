# Implementation Recommendations

## Cluster

It is **RECOMMENDED** that each individual `Cluster` element contain no more than
five seconds or five megabytes of content.

## SeekHead

It is **RECOMMENDED** that the first `SeekHead` element be followed by a `Void` element to
allow for the `SeekHead` element to be expanded to cover new `Top-Level Elements`
that could be added to the Matroska file, such as `Tags`, `Chapters`, and `Attachments` elements.

The size of this `Void` element should be adjusted depending on the `Tags`,
`Chapters`, and `Attachments` elements in the Matroska file.

## Optimum Layouts

While there can be `Top-Level Elements` in any order, some orderings of elements are better than others.
The following subsections detail optimum layouts for different use cases.

### Optimum Layout for a Muxer

This is the basic layout muxers should be using for an efficient playback experience:

* `SeekHead`
* `Info`
* `Tracks`
* `Chapters`
* `Attachments`
* `Tags`
* `Clusters`
* `Cues`

### Optimum Layout after Editing Tags

When tags from the previous layout need to be extended, they are moved to the end with the extra information.
The location where the old tags were located is voided.

* `SeekHead`
* `Info`
* `Tracks`
* `Chapters`
* `Attachments`
* `Void`
* `Clusters`
* `Cues`
* `Tags`

### Optimum Layout with Cues at the Front

`Cues` are usually a big chunk of data referencing a lot of locations in the file.
Players that want to seek in the file need to seek to the end of the file
to access these locations. It is often better if they are placed early in the file.
On the other hand, that means players that don't intend to seek will have to read/skip
these data no matter what.

Because the `Cues` reference locations further in the file, it's often complicated to
allocate the proper space for that element before all the locations are known.
Therefore, this layout is rarely used:

* `SeekHead`
* `Info`
* `Tracks`
* `Chapters`
* `Attachments`
* `Tags`
* `Cues`
* `Clusters`

### Optimum Layout for Livestreaming

In livestreaming ((#livestreaming)), only a few elements make sense. For example, `SeekHead` and `Cues` are useless.
All elements other than the `Clusters` **MUST** be placed before the `Clusters`.

* `Info`
* `Tracks`
* `Attachments` (rare)
* `Tags`
* `Clusters`

