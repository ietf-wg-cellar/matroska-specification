---
---

# Audio Codecs

## WavPack

[@!WAVPACK] stores each data in variable length frames. That means each frame can have a different number of samples.

For multi-track files (more than 2 tracks, like for 5.1), a frame consists of many blocks.
The first one having the `INITIAL_BLOCK` (bit 11) flag set and the last one the `FINAL_BLOCK` (bit 12) flag set.
For a mono or stereo files, both flags are set in each block.

Each block starts with a header saved in little-endian with the `WavpackHeader` format defined in [@!WAVPACK].

WavPack has a hybrid mode. That means the data are encoded in 2 files. The first one has a lossy part and the second file has the correction file that olds the missing data to reconstruct the original file losslessly. Each block in the correction file corresponds to a block in the lossy file with the same number of samples, that's also true for a multi-track file. This means that if a frame is made of 4 blocks, the correction file will have 4 blocks in the corresponding frame. The header of the correction block is exactly the same as in the lossy block, except for the crc. In Matroska, we store the correction part as an additional data available to the Block (see BlockAdditions).


To save space and avoid redundant information in Matroska we remove data from the header, when saved in Matroska. All the data are kept in little-endian.

The `CodecPrivate` contains the `version` 16-bit integer from the `WavpackHeader` of [@!WAVPACK] stored in little-endian.

### Lossless And Lossy Mono/Stereo File

* Block

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
}
[ block data ]
```

### Hybrid Mono/Stereo Files

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

### Lossless And Lossy Multi-track File

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

### Hybrid Multi-track Files

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

