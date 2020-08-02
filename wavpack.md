---
---

# Matroska Codec - WavPack

[WavPack](http://www.wavpack.com/) stores each data in variable length frames. That means each frame can have a different number of samples.

For multi-track files (more than 2 tracks, like for 5.1). A frame consists of many blocks. The first one having the flag `WV_INITIAL_BLOCK` and the last one `WV_FINAL_BLOCK`. For a mono or stereo files, both flags are set in each block.

Each block starts with a header saved in little-endian with the following format :

```c
typedef struct PACKED_STRUCTURE {
  char ck_id [4];         // "wvpk"
  uint32_t ck_size;       // size of entire frame (minus 8, of course)
  uint16_t version;       // major & minor version; only supported major version is 4; minor varies with the features used
  uint8_t track_no;       // track number (0 if not used, like now)
  uint8_t index_no;       // remember these? (0 if not used, like now)
  uint32_t total_samples; // for entire file (-1 if unknown)
  uint32_t block_index;   // index of first sample in block (to file begin)
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
} wavpack_header_t;
```


WavPack has an hybrid mode. That means the data are encoded in 2 files. The first one has a lossy part and the second file has the correction file that olds the missing data to reconstruct the original file losslessly. Each block in the correction file corresponds to a block in the lossy file with the same number of samples, that's also true for a multi-track file. That means if a frame is made of 4 blocks, the correction file will have 4 blocks in the corresponding frame. The header of the correction block is exactly the same as in the lossy block, except for the crc. In Matroska we store the correction part as an additional data available to the Block (see BlockAdditions)


To save space and avoid redundant information in Matroska we remove data from the header, when saved in Matroska. All the data are kept in little-endian.

## Lossless &amp; lossy mono/stereo file

* CodecPrivate

```c
{
  uint16_t version;       // major & minor version; only supported major version is 4; minor varies with the features used
}
```

* Block

```c
{
  uint32_t block_samples; // # samples in this block
  uint32_t flags;         // various flags for id and decoding
  uint32_t crc;           // crc for actual decoded data
}
[ block data ]
```

## Hybrid mono/stereo files
* CodecPrivate

```c
{
  uint16_t version;       // major & minor version; only supported major version is 4; minor varies with the features used
}
```

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

## Lossless &amp; lossy multi-track file
* CodecPrivate

```c
{
  uint16_t version;       // major & minor version; only supported major version is 4; minor varies with the features used
}
```

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

## Hybrid multi-track files
* CodecPrivate

```c
{
  uint16_t version;       // major & minor version; only supported major version is 4; minor varies with the features used
}
```

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
