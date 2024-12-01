---
---

# Audio Codecs

## WavPack

WavPack is an audio codec primarily designed for lossless audio, but it can also be used as a lossy codec.

[@!WAVPACK] stores each data in variable length frames. That means each frame can have a different number of samples.

Each WavPack block starts with a `WavpackHeader` header as defined in [@!WAVPACK], stored in little-endian.

To save space and avoid redundant information in Matroska some data from the `WavpackHeader` header are removed, when saved in Matroska.
All the data from the `WavpackHeader` are kept in little-endian.

The `CodecPrivate` contains the `version` 16-bit integer from the `WavpackHeader` of [@!WAVPACK] stored in little-endian.

Depending on the number of audio channels and whether the hybrid mode is kept or not, the storage of WavPack blocks in Matroska differ.

### Lossless And Lossy Storage

For multichannel files (more than 2 channels, like for 5.1), a frame consists of multiple WavPack blocks.
The first one having the `INITIAL_BLOCK` (bit 11) flag set and the last one the `FINAL_BLOCK` (bit 12) flag set.
For a mono or stereo file, both flags are set in each WavPack block.

#### Mono/Stereo

A `Block` or `SimpleBlock` frame contains the following header with the some fields taken from the `WavpackHeader`
of a single WavPack block followed by the data of that WavPack block.

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
}
[ block data ]
```

#### Multichannel

For multichannel files, a WavPack file uses multiple WavPack block to store all channels of a frame.
The WavPack blocks for each channels of a frame are stored consecutively into a Matroska `Block` or `SimpleBlock`.

Each WavPack block is preceded by a header.
The header for the first WavPack block is similar to the mono/stereo one ((#mono-stereo))
with the addition of a "blocksize" field, which is the size of the first WavPack block minus the `WavpackHeader` size.
The header for the following WavPack blocks use the "flags" and "crc" of the `WavpackHeader` of each respective WavPack block,
followed with the size of each respective WavPack block minus the `WavpackHeader` size.

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ block data # 1 ]
{
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ block data # 2 ]
{
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ block data # 3 ]
...
```

### Hybrid Storage

WavPack has a hybrid mode that splits the audio frames between lossy and correction packets.
Adding both gives a lossless version of the original audio.
It is possible to only store the lossy part in Matroska or both together.
Storing only the lossy part is equivalent to the format described in (#lossless-and-lossy-storage).
This section explains how to store all hybrid data in Matroska.

Hybrid WavPack is encoded in 2 files.
The first one has a lossy part and the second file has the correction part to reconstruct the original audio losslessly.

Each WavPack block in the correction file corresponds to a WavPack block in the lossy file with the same number of samples, that's also true for a multichannel file.
This means that if a frame is made of 4 WavPack blocks, the correction file will have 4 WavPack blocks in the corresponding frame.
The header of the correction WavPack block is exactly the same as in the lossy WavPack block, except for the CRC.

In Matroska, the correction part is stored as an additional data available to the `Block` (see (#block-additional-mapping)).
This way a file could be remuxed and not keep the Block Additional data and still be usable as a lossy WavPack file.
The `Block` data of the lossy file are stored exactly the same as for lossy storage defined in (#lossless-and-lossy-storage).

A `BlockAdditionMapping` **MUST** be used for hybrid WavPack `TrackEntry`'.

The `BlockAddIDType` of that `BlockAdditionMapping` **MUST** be set to 1 for hybrid WavPack, corresponding to Opaque data; see (#opaque-data).

Each WavPack frame is stored in a `BlockGroup` that **MUST** have at least a `BlockMore` to hold the correction data.

The `BlockAddID` of that `BlockMore` **MUST** be 1, i.e., the default value.

#### Mono/Stereo

The `BlockAdditional` element of the correction data `BlockMore` contains the following header with the "crc" field from the `WavpackHeader` of the WavPack block of the correction file
matching the WavPack block of the lossy frame used to fill the `Block` data, followed by the data of that correction file WavPack block.

```c
{
  uint32_t crc;           // crc for actual decoded data
}
[ correction block data ]
```

#### Multichannel

The `BlockAdditional` element of the correction data `BlockMore` contains the following header with the data from the each `WavpackHeader` of the WavPack block of the correction file
matching the WavPack block in the lossy file used to fill the `Block` data, followed by the data of the correction file WavPack block.

```c
{
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ correction block data # 1 ]
{
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ correction block data # 2 ]
{
  uint32_t crc;           // crc for actual decoded data
  uint32_t blocksize;     // size of the data to follow
}
[ correction block data # 3 ]
...
```

