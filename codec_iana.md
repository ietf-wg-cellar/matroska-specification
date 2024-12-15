# IANA Considerations

## Matroska Codec IDs Registry

This document defines registries for Codec IDs stored in the `CodecID` element.
A `CodecID` is a case-sensitive ASCII string with a `V_`, `A_`, `S_` and `B_` prefix for
video, audio, subtitle and button tracks respectively. The details of the string format
are found in (#codec-id).

To register a new Codec ID in this registry, one needs a Codec ID string, a TrackType value,
a description, a Change Controller, and an optional Reference to a document describing the Codec ID.

Some Codec IDs values are deprecated and **SHOULD NOT** be used.
Such Codec IDs are marked as "Reclaimed" in the "Matroska Codec IDs" registry.

(#codec-id-registry-table) shows the initial contents of the "Matroska Codec IDs" registry.
The Change Controller for the initial entries is the IETF.

Codec ID | Track Type | Description            | Reference
--------:|:----------:|:-----------------------|:------------------------------
V_AV1 | 1 | Alliance for Open Media AV1 | This document, (#v-av1)
V_AVS2 | 1 | AVS2-P2/IEEE.1857.4 | This document, (#v-avs2)
V_AVS3 | 1 | AVS3-P2/IEEE.1857.10 | This document, (#v-avs3)
V_CAVS | 1 | AVS1-P2/IEEE.1857.3 | This document, (#v-cavs)
V_DIRAC | 1 | Dirac / VC-2 | This document, (#v-dirac)
V_FFV1 | 1 | FFV1 | This document, (#v-ffv1)
V_MJPEG | 1 | Motion JPEG | This document, (#v-mjpeg)
V_MPEGH/ISO/HEVC | 1 | HEVC/H.265 | This document, (#v-mpegh-iso-hevc)
V_MPEGI/ISO/VVC | 1 | VVC/H.266 | This document, (#v-mpegi-iso-vvc)
V_MPEG1 | 1 | MPEG 1 | This document, (#v-mpeg1)
V_MPEG2 | 1 | MPEG 2 | This document, (#v-mpeg2)
V_MPEG4/ISO/AVC | 1 | AVC/H.264 | This document, (#v-mpeg4-iso-avc)
V_MPEG4/ISO/AP | 1 | MPEG4 ISO advanced profile | This document, (#v-mpeg4-iso-ap)
V_MPEG4/ISO/ASP | 1 | MPEG4 ISO advanced simple profile | This document, (#v-mpeg4-iso-asp)
V_MPEG4/ISO/SP | 1 | MPEG4 ISO simple profile | This document, (#v-mpeg4-iso-sp)
V_MPEG4/MS/V3 | 1 | Microsoft MPEG4 V3 | This document, (#v-mpeg4-ms-v3)
V_MS/VFW/FOURCC | 1 | Microsoft Video Codec Manager | This document, (#v-ms-vfw-fourcc)
V_QUICKTIME | 1 | Video taken from QuickTime files | This document, (#v-quicktime)
V_PRORES | 1 | Apple ProRes | This document, (#v-prores)
V_REAL/RV10 | 1 | RealVideo 1.0 aka RealVideo 5 | This document, (#v-real-rv10)
V_REAL/RV20 | 1 | RealVideo G2 and RealVideo G2+SVT | This document, (#v-real-rv20)
V_REAL/RV30 | 1 | RealVideo 8 | This document, (#v-real-rv30)
V_REAL/RV40 | 1 | rv40 : RealVideo 9 | This document, (#v-real-rv40)
V_THEORA | 1 | Theora | This document, (#v-theora)
V_UNCOMPRESSED | 1 | Raw uncompressed video frames | This document, (#v-uncompressed)
V_VP8 | 1 | VP8 Codec format | This document, (#v-vp8)
V_VP9 | 1 | VP9 Codec format | This document, (#v-vp9)
A_AAC | 2 | Advanced Audio Coding | This document, (#a-aac)
A_AAC/MPEG2/LC | 2 | Low Complexity | This document, (#a-aac-mpeg2-lc)
A_AAC/MPEG2/LC/SBR | 2 | Low Complexity with Spectral Band Replication | This document, (#a-aac-mpeg2-lc-sbr)
A_AAC/MPEG2/MAIN | 2 | MPEG2 Main Profile | This document, (#a-aac-mpeg2-main)
A_AAC/MPEG2/SSR | 2 | Scalable Sampling Rate | This document, (#a-aac-mpeg2-ssr)
A_AAC/MPEG4/LC | 2 | Low Complexity | This document, (#a-aac-mpeg4-lc)
A_AAC/MPEG4/LC/SBR | 2 | Low Complexity with Spectral Band Replication | This document, (#a-aac-mpeg4-lc-sbr)
A_AAC/MPEG4/LTP | 2 | Long Term Prediction | This document, (#a-aac-mpeg4-ltp)
A_AAC/MPEG4/MAIN | 2 | MPEG4 Main Profile | This document, (#a-aac-mpeg4-main)
A_AAC/MPEG4/SSR | 2 | Scalable Sampling Rate | This document, (#a-aac-mpeg4-ssr)
A_AC3 | 2 | Dolby Digital / AC-3 | This document, (#a-ac3)
A_AC3/BSID9 | 2 | Dolby Digital / AC-3 | This document, (#a-ac3-bsid9)
A_AC3/BSID10 | 2 | Dolby Digital / AC-3 | This document, (#a-ac3-bsid10)
A_ALAC | 2 | ALAC (Apple Lossless Audio Codec) | This document, (#a-alac)
A_ATRAC/AT1 | 2 | Sony ATRAC1 Codec | This document, (#a-atrac-at1)
A_DTS | 2 | Digital Theatre System | This document, (#a-dts)
A_DTS/EXPRESS | 2 | Digital Theatre System Express | This document, (#a-dts-express)
A_DTS/LOSSLESS | 2 | Digital Theatre System Lossless | This document, (#a-dts-lossless)
A_EAC3 | 2 | Dolby Digital Plus / E-AC-3 | This document, (#a-eac3)
A_FLAC | 2 |  FLAC | This document, (#a-flac)
A_MLP | 2 | Meridian Lossless Packing / MLP | This document, (#a-mlp)
A_MPC | 2 | MPC (musepack) SV8 | This document, (#a-mpc)
A_MPEG/L1 | 2 | MPEG Audio 1, 2 Layer I | This document, (#a-mpeg-l1)
A_MPEG/L2 | 2 | MPEG Audio 1, 2 Layer II | This document, (#a-mpeg-l2)
A_MPEG/L3 | 2 | MPEG Audio 1, 2, 2.5 Layer III | This document, (#a-mpeg-l3)
A_MS/ACM | 2 | Microsoft Audio Codec Manager (ACM) | This document, (#a-ms-acm)
A_REAL/14_4 | 2 | Real Audio 1 | This document, (#a-real-14-4)
A_REAL/28_8 | 2 | Real Audio 2 | This document, (#a-real-28-8)
A_REAL/ATRC | 2 | Sony Atrac3 Codec | This document, (#a-real-atrc)
A_REAL/COOK | 2 | Real Audio Cook Codec | This document, (#a-real-cook)
A_REAL/RALF | 2 | Real Audio Lossless Format | This document, (#a-real-ralf)
A_REAL/SIPR | 2 | Sipro Voice Codec | This document, (#a-real-sipr)
A_OPUS | 2 |  Opus interactive speech and audio codec | This document, (#a-opus)
A_PCM/FLOAT/IEEE | 2 | Floating-Point, IEEE compatible | This document, (#a-pcm-float-ieee)
A_PCM/INT/BIG | 2 | PCM Integer Big Endian | This document, (#a-pcm-int-big)
A_PCM/INT/LIT | 2 | PCM Integer Little Endian | This document, (#a-pcm-int-lit)
A_QUICKTIME | 2 | Audio taken from QuickTime files | This document, (#a-quicktime)
A_QUICKTIME/QDMC | 2 | QDesign Music | This document, (#a-quicktime-qdmc)
A_QUICKTIME/QDM2 | 2 | QDesign Music v2 | This document, (#a-quicktime-qdm2)
A_TRUEHD | 2 | Dolby TrueHD | This document, (#a-truehd)
A_TTA1 | 2 | The True Audio | This document, (#a-tta1)
A_VORBIS | 2 | Vorbis | This document, (#a-vorbis)
A_WAVPACK4 | 2 | WavPack | This document, (#a-wavpack4)
S_ARIBSUB| 17 | ARIB STD-B24 subtitles | This document, (#s-aribsub)
S_DVBSUB| 17 | Digital Video Broadcasting subtitles | This document, (#s-dvbsub)
S_HDMV/PGS| 17 | HDMV presentation graphics subtitles | This document, (#s-hdmv-pgs)
S_HDMV/TEXTST| 17 | HDMV text subtitles | This document, (#s-hdmv-textst)
S_KATE| 17 | Karaoke And Text Encapsulation | This document, (#s-kate)
S_IMAGE/BMP| 17 | Bitmap | This document, (#s-image-bmp)
S_ASS | 17 | Advanced SubStation Alpha Format | Reclaimed, (#s-text-ass)
S_TEXT/ASS| 17 | Advanced SubStation Alpha Format | This document, (#s-text-ass)
S_TEXT/ASCII| 17 | ASCII Plain Text | This document, (#s-text-ascii)
S_TEXT/SSA| 17 | SubStation Alpha Format | This document, (#s-text-ssa)
S_TEXT/USF| 17 | Universal Subtitle Format | This document, (#s-text-usf)
S_TEXT/UTF8| 17 | UTF-8 Plain Text | This document, (#s-text-utf8)
S_TEXT/WEBVTT| 17 | Web Video Text Tracks (WebVTT) | This document, (#s-text-webvtt)
S_SSA | 17 | SubStation Alpha Format | Reclaimed, (#s-text-ass)
S_VOBSUB| 17 | VobSub subtitles | This document, (#s-vobsub)
B_VOBBTN | 18 | VobBtn Buttons | This document, (#b-vobbtn)
Table: Initial Contents of "Matroska Codec IDs" Registry{#codec-id-registry-table}

## Matroska BlockAdditional Type IDs Registry

This document defines registries for BlockAdditional Type IDs stored in the `BlockAddIDType` element.
The values correspond to the unsigned integer `BlockAddIDType` value described in [@!RFC9559, section 5.1.4.1.17.3].

To register a new BlockAdditional Type ID in this registry, one needs a `BlockAddIDType` unsigned integer,
a `BlockAddIDName` string value, a Change Controller, and an optional Reference to a document describing the BlockAdditional Type ID.

(#blockadd-id-registry-table) shows the initial contents of the "Matroska BlockAdditional Type IDs" registry.
The Change Controller for the initial entries is the IETF.

BlockAddIDType | BlockAddIDName            | Reference
--------:|:--------------------------|:------------------------------
0 | Use BlockAddIDValue | This document, (#use-blockaddidvalue)
1 | Opaque data | This document, (#opaque-data)
4 | ITU T.35 metadata | This document, (#itu-t-35-metadata)
121 | SMPTE ST 12-1 timecode | This document, (#smpte-st-12-1-timecode)
0x64766343 | Dolby Vision configuration dvcC | This document, (#dvcc)
0x61766345 | Dolby Vision enhancement-layer AVC configuration | This document, (#avce)
0x64767643 | Dolby Vision configuration dvvC | This document, (#dvvc)
0x64767743 | Dolby Vision configuration dvwC | This document, (#dvwc)
0x68766345 | Dolby Vision enhancement-layer HEVC configuration | This document, (#hvce)
0x6D766343 | MVC configuration | This document, (#mvcc)
Table: Initial Contents of "Matroska BlockAdditional Type IDs" Registry{#blockadd-id-registry-table}
