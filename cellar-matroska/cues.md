# Cues

The `Cues` element provides an index of certain `Cluster`
elements to allow for optimized seeking to absolute timestamps within the
`Segment`. The `Cues` element contains one or many
`CuePoint` elements, each of which **MUST** reference an
absolute timestamp (via the `CueTime` element), a `Track` (via
the `CueTrack` element), and a `Segment Position` (via the
`CueClusterPosition` element). Additional non-mandated elements are
part of the `CuePoint` element, such as `CueDuration`,
`CueRelativePosition`, `CueCodecState`, and others that provide
any `Matroska Reader` with additional information to use in the
optimization of seeking performance.

## Recommendations

The following recommendations are provided to optimize Matroska performance.

- Unless Matroska is used as a live stream, it **SHOULD** contain a `Cues` element.

- For each video track, each keyframe **SHOULD** be referenced by a `CuePoint` element.

- It is **RECOMMENDED** to not reference non-keyframes of video tracks in `Cues` unless
  it references a `Cluster` element that contains a `CodecState` element but no keyframes.

- For each subtitle track present, each subtitle frame **SHOULD** be referenced by a
  `CuePoint` element with a `CueDuration` element.

- References to audio tracks **MAY** be skipped in `CuePoint` elements if a video track
  is present. When included, the `CuePoint` elements **SHOULD** reference audio keyframes
  once every 500 milliseconds at most.

- If the referenced frame is not stored within the first `SimpleBlock` or first
  `BlockGroup` within its `Cluster` element, then the `CueRelativePosition` element
   **SHOULD** be written to reference where in the `Cluster` the reference frame is stored.

- If a `CuePoint` element references a `Cluster` element that includes a `CodecState` element,
  then that `CuePoint` element **MUST** use a `CueCodecState` element.

- `CuePoint` elements **SHOULD** be numerically sorted in storage order by the value of the `CueTime` element.

