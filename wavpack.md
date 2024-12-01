---
---

# Audio Codecs

## WavPack

[@!WAVPACK] stores each data in variable length frames. That means each frame can have a different number of samples.

Each WavPack block starts with a header saved in little-endian with the `WavpackHeader` format defined in [@!WAVPACK].

To save space and avoid redundant information in Matroska we remove data from the header, when saved in Matroska.
All the data are kept in little-endian.

The `CodecPrivate` contains the `version` 16-bit integer from the `WavpackHeader` of [@!WAVPACK] stored in little-endian.

### Lossless And Lossy Storage

For multichannel files (more than 2 channels, like for 5.1), a frame consists of many WavPack blocks.
The first one having the `INITIAL_BLOCK` (bit 11) flag set and the last one the `FINAL_BLOCK` (bit 12) flag set.
For a mono or stereo files, both flags are set in each WavPack block.

#### Mono/Stereo

A `Block` or `SimpleBlock` frame contains the following header with the data from the `WavpackHeader`
of a single WavPack stereo block followed by the data of that WavPack block.

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
}
[ block data ]
```

#### Multichannel

For multichannel files, a WavPack files uses multiple WavPack block to store all channels.
We store each channel WavPack block consecutively into a Matroska `Block`, with the size of each WavPack block after the common header data.

* Block

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

WavPack has a hybrid mode.
That means the data are encoded in 2 files.
The first one has a lossy part and the second file has the correction file that olds the missing data to reconstruct the original file losslessly.
Each WavPack block in the correction file corresponds to a WavPack block in the lossy file with the same number of samples, that's also true for a multichannel file.
This means that if a frame is made of 4 WavPack blocks, the correction file will have 4 WavPack blocks in the corresponding frame.
The header of the correction WavPack block is exactly the same as in the lossy WavPack block, except for the CRC.
In Matroska, we store the correction part as an additional data available to the `Block` (see (#block-additional-mapping)).

#### Mono/Stereo

* Block

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
}
[ block data ]
```

* BlockAdditional (level 1)

```c
{
  uint32_t crc;           // crc for actual decoded data
}
[ correction block data ]
```

#### Multichannel

Here we store the multichannel lossy WavPack blocks as for non-hybrid file.

The `BlockAdditional` contains the correction multichannel WavPack blocks.
They are stored consecutively with their CRC and blocksize.

* Block

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

* BlockAdditional (level 1)

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

