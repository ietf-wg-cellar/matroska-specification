---
title: Cues
---

# Cues

The `Cues Element` provides an index of certain `Cluster Elements` to allow for optimized seeking to absolute timestamps within the `Segment`. The `Cues Element` contains one or many `CuePoint Elements` which each MUST reference an absolute timestamp (via the `CueTime Element`), a `Track` (via the `CueTrack Element`), and a `Segment Position` (via the `CueClusterPosition Element`). Additional non-mandated Elements are part of the `CuePoint Element` such as `CueDuration`, `CueRelativePosition`, `CueCodecState` and others which provide any `Matroska Reader` with additional information to use in the optimization of seeking performance.

## Recommendations

The following recommendations are provided to optimize Matroska performance.

- Unless Matroska is used as a live stream, it SHOULD contain a `Cues Element`.
- For each video track, each keyframe SHOULD be referenced by a `CuePoint Element`.
- It is RECOMMENDED to not reference non-keyframes of video tracks in `Cues` unless it references a `Cluster Element` which contains a `CodecState Element` but no keyframes.
- For each subtitle track present, each subtitle frame SHOULD be referenced by a `CuePoint Element` with a `CueDuration Element`.
- References to audio tracks MAY be skipped in `CuePoint Elements` if a video track is present. When included the `CuePoint Elements` SHOULD reference audio keyframes at most once every 500 milliseconds.
- If the referenced frame is not stored within the first `SimpleBlock` or first `BlockGroup` within its `Cluster Element`, then the `CueRelativePosition Element` SHOULD be written to reference where in the `Cluster` the reference frame is stored.
- If a `CuePoint Element` references `Cluster Element` that includes a `CodecState Element`, then that `CuePoint Element` MUST use a `CueCodecState Element`.
- `CuePoint Elements` SHOULD be numerically sorted in storage order by the value of the `CueTime Element`.
