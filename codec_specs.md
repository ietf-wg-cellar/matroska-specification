---
layout: default
---
# CodecID

As an additional resource to this page Haali has created a [list of codec IDs in a PDF](http://haali.su/mkv/codecs.pdf).

For each TrackEntry inside [matroska]({{site.baseurl}}/index.html), there has to be a [CodecID]({{site.baseurl}}/index.html#CodecID) defined. This ID is represent the codec used to encode data in the Track. The codec works with the coded data in the stream, but also with some codec initialisation. There are 2 different kind of codec "initialisation" :

*   CodecPrivate in the TrackEntry
*   CodecState in the BlockGroup

Each of these elements contain the same kind of data. And these data depend on the codec used.

Important Note:

Please, when reading through this list, always keep in mind that the intention behind it is `NOT` to list all existing audio and video codecs, but more to list those codecs that are `currently supported` in matroska (or will be supported soon), and therfore need a well defined codec ID so that all developers supporting matroska will use the same ID. A list of all the codecs we plan to support in the future [can be found on the CoreCodec forum](http://www.corecodec.com/modules.php?op=modload&amp;name=PNphpBB2&amp;file=viewtopic&amp;t=227) (subject to be changed constantly). If you feel we missed support for a very important codec, please tell us on our development mailing list (matroska-devel at freelists.org).

See

| Codec ID | Name | Description |
| Video |
| V_MS/VFW/FOURCC | Microsoft (TM) Video Codec Manager (VCM) | V_MS/VFW/FOURCC - Microsoft (TM) Video Codec Manager (VCM)
The private data contains the VCM structure BITMAPINFOHEADER including the extra private bytes, as [defined by Microsoft](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/gdi/bitmaps_1rw2.asp). The data are stored in little endian format (like on IA32 machines). Where is the Huffman table stored in HuffYUV, not AVISTREAMINFO ??? And the FourCC, not in AVISTREAMINFO.fccHandler ??? |
| V_UNCOMPRESSED | Video, raw uncompressed video frames | The private data is void, all details about the used colour specs and bit depth are to be put/read from the KaxCodecColourSpace elements. |
| V_MPEG4/ISO/??? | MPEG4 ISO Profile Video | The stream complies with, and uses the CodecID for, one of the MPEG-4 profiles listed below. |

| V_MPEG4/ISO/SP | MPEG4 ISO simple profile (DivX4) | stream was created via improved codec API (UCI) or even transmuxed from AVI (no b-frames in Simple Profile), frame order is coding order |
| V_MPEG4/ISO/ASP | MPEG4 ISO advanced simple profile (DivX5, XviD, FFMPEG) | stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI! Note there are differences how b-frames are handled in these native streams, when being compared to a VfW created stream, as here there are `no` dummy frames inserted, the frame order is exactly the same as the coding order, same as in MP4 streams! |
| V_MPEG4/ISO/AP | MPEG4 ISO advanced profile | stream was created ... (see above) |

 |
| V_MPEG4/MS/V3 | Microsoft (TM) MPEG4 V3 | and derivates, means DivX3, Angelpotion, SMR, etc.; stream was created using VfW codec or transmuxed from AVI; note that V1/V2 are covered in VfW compatibility mode |
| V_MPEG1 | MPEG 1 | The matroska video stream will contain a demuxed Elementary Stream (ES ), where block boundaries are still to be defined. Its RECOMMENDED to use MPEG2MKV.exe for creating those files, and to compare the results with selfmade implementations |
| V_MPEG2 | MPEG 2 | The matroska video stream will contain a demuxed Elementary Stream (ES ), where block boundaries are still to be defined. Its RECOMMENDED to use MPEG2MKV.exe for creating those files, and to compare the results with selfmade implementations |
| V_REAL/???? | Real Video(TM) | The stream is one of the Real Video(TM) video streams listed below. Source for the codec names are from [Karl Lillevold on Doom9](http://forum.doom9.org/showthread.php?s=&amp;threadid=55773&amp;perpage=20&amp;pagenumber=2#post331855). The CodecPrivate element contains a "real_video_props_t" structure in Big Endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h). |

| V_REAL/RV10 | RealVideo 1.0 aka RealVideo 5
 | Individual slices from the Real container are combined into a single frame. |
| V_REAL/RV20 | RealVideo G2 and RealVideo G2+SVT | Individual slices from the Real container are combined into a single frame. |
| V_REAL/RV30 | RealVideo 8 | Individual slices from the Real container are combined into a single frame. |
| V_REAL/RV40 | rv40 : RealVideo 9 | Individual slices from the Real container are combined into a single frame. |

 |
| V_QUICKTIME | Video taken from QuickTime(TM) files | Several codecs as stored in QuickTime, e.g. Sorenson or Cinepak. The CodecPrivate contains all additional data that is stored in the 'stsd' (sample description) atom in the QuickTime file **after** the mandatory video descriptor structure (starting with the size and FourCC fields). For an explanation of the QuickTime file format read [Apple's PDF on QuickTime](http://developer.apple.com/documentation/quicktime/QTFF/qtff.pdf). |

| V_THEORA | Theora | The private data contains the first three Theora packets in order. The lengths of the packets precedes them. The actual layout is: 

* Byte 1: number of distinct packets '`#p`' minus one inside the CodecPrivate block. This MUST be '2' for current (as of 2016-07-08) Theora headers. 
* Bytes 2..n: lengths of the first '`#p`' packets, coded in [Xiph-style lacing]({{site.baseurl}}/index.html#lacing). The length of the last packet is the length of the CodecPrivate block minus the lengths coded in these bytes minus one. 
* Bytes n+1..: The Theora identification header, followed by the commend header followed by the codec setup header. Those are described in the [Theora specs](http://www.theora.org/doc/Theora_I_spec.pdf).

 |
| V_PRORES | Apple ProRes | The private data contains the fourcc as found in MP4 movies:

*   apch: ProRes 422 High Quality
*   apcn: ProRes 422 Standard Definition
*   apcs: ProRes 422 LT
*   apco: ProRes 422 Proxy
*   ap4h: ProRes 4444

[this page for more technical details on ProRes](http://wiki.multimedia.cx/index.php?title=Apple_ProRes#Frame_layout)

 |
| Audio |
| A_MPEG/L3 | MPEG Audio 1, 2, 2.5 Layer III | 

The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame.

Corresponding ACM wFormatTag : 0x0055

 |
| A_MPEG/L2 | MPEG Audio 1, 2 Layer II | 

The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame.

Corresponding ACM wFormatTag : 0x0050

 |
| A_MPEG/L1 | MPEG Audio 1, 2 Layer I | 

The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame.

Corresponding ACM wFormatTag : 0x0050

 |
| A_PCM/INT/BIG | PCM Integer Big Endian | 

The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element

Corresponding ACM wFormatTag : ???

 |
| A_PCM/INT/LIT | PCM Integer Little Endian | 

The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element

Corresponding ACM wFormatTag : 0x0001

 |
| A_PCM/FLOAT/IEEE | Floating Point, IEEE compatible | 

The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element (32 bit in most cases). The float are stored in little endian order (most common float format).

Corresponding ACM wFormatTag : 0x0003

 |
| A_MPC | MPC (musepack) SV8 | The main developer for musepack has requested that we wait until the SV8 framing has been fully defined for musepack before defining how to store it in Matroska. |
| 

A_AC3

A_AC3/BSID9

A_AC3/BSID10

 | (Dolby™) AC3 | 

BSID <= 8 !! The private data is void ??? Corresponding ACM wFormatTag : 0x2000 ; channel number have to be read from the corresponding audio element

AC3/BSID9 and AC3/BSID10 (DolbyNet) :
The ac3 frame header has, similar to the mpeg-audio header a version field. Normal ac3 is defiened as bitstream id 8 (5 Bits, numbers are 0-15). Everything below 8 is still compatible with all decoders that handle 8 correctly. Everything higher are additions that break decoder compatibility.
For the samplerates 24kHz (00); 22,05kHz (01) and 16kHz (10) the BSID is 9
For the samplerates 12kHz (00); 11,025kHz (01) and 8kHz (10) the BSID is 10

 |
| A_ALAC | ALAC (Apple Lossless Audio Codec) | The private data contains ALAC's magic cookie (both the codec specific configuration as well as the optional channel layout information). Its format is described in [ALAC's official source code](http://alac.macosforge.org/trac/browser/trunk/ALACMagicCookieDescription.txt). |

| A_DTS | Digital Theatre System | Supports DTS, DTS-ES, DTS-96/26, DTS-HD High Resolution Audio and DTS-HD Master Audio. The private data is void. Corresponding ACM wFormatTag : 0x2001 |

| A_DTS/EXPRESS | Digital Theatre System Express | DTS Express (a.k.a. LBR) audio streams. The private data is void. Corresponding ACM wFormatTag : 0x2001 |

| A_DTS/LOSSLESS | Digital Theatre System Lossless | DTS Lossless audio that does not have a core substream. The private data is void. Corresponding ACM wFormatTag : 0x2001 |

| A_VORBIS | Vorbis | The private data contains the first three Vorbis packet in order. The lengths of the packets precedes them. The actual layout is:
Byte 1: number of distinct packets '`#p`' minus one inside the CodecPrivate block. This MUST be '2' for current (as of 2016-07-08) Vorbis headers.
Bytes 2..n: lengths of the first '`#p`' packets, coded in [Xiph-style lacing]({{site.baseurl}}/index.html#lacing). The length of the last packet is the length of the CodecPrivate block minus the lengths coded in these bytes minus one.
Bytes n+1..: The [Vorbis identification header](http://www.xiph.org/ogg/vorbis/doc/vorbis-spec-ref.html), followed by the [Vorbis comment header](http://www.xiph.org/ogg/vorbis/doc/v-comment.html) followed by the [codec setup header](http://www.xiph.org/ogg/vorbis/doc/vorbis-spec-ref.html). |


| A_FLAC | [FLAC (Free Lossless Audio Codec)](http://flac.sourceforge.net/) | The private data contains all the header/metadata packets before the first data packet. These include the first header packet containing only the word `fLaC` as well as all metadata packets. |
| A_REAL/???? | Realmedia Audio codecs | The stream contains one of the following audio codecs. In each case the CodecPrivate element contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure (differentiated by their "version" field; Big Endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h). |

| A_REAL/14_4 | Real Audio 1 |
| A_REAL/28_8 | Real Audio 2 |
| A_REAL/COOK | Real Audio Cook Codec (codename: Gecko) |
| A_REAL/SIPR | Sipro Voice Codec |
| A_REAL/RALF | Real Audio Lossless Format |
| A_REAL/ATRC | Sony Atrac3 Codec |

 |
| A_MS/ACM | Microsoft(TM) Audio Codec Manager (ACM) | The private data contains the ACM structure WAVEFORMATEX including the extra private bytes, as [defined by Microsoft](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/multimed/mmstr_625u.asp). The data are stored in little endian format (like on IA32 machines). |
| A_AAC/?????/??? | AAC Profile Audio | The stream complies with, and uses the CodecID for, one of the AAC profiles listed below. AAC audio always uses wFormatTag 0xFF |

| A_AAC/MPEG2/MAIN | MPEG2 Main Profile | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG2/LC | Low Complexity | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG2/LC/SBR | Low Complexity with Spectral Band Replication | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG2/SSR | Scalable Sampling Rate | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG4/MAIN | MPEG4 Main Profile | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG4/LC | Low Complexity | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG4/LC/SBR | Low Complexity with Spectral Band Replication | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG4/SSR | Scalable Sampling Rate | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |
| A_AAC/MPEG4/LTP | Long Term Prediction | The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied. |

 |
| A_QUICKTIME | Audio taken from QuickTime(TM) files | Several codecs as stored in QuickTime, e.g. QDesign Music v1 or v2\. The CodecPrivate contains all additional data that is stored in the 'stsd' (sample description) atom in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields). For an explanation of the QuickTime file format read [Apple's PDF on QuickTime](http://developer.apple.com/documentation/quicktime/QTFF/qtff.pdf). |

| A_QUICKTIME/???? | QuickTime audio codecs | This CodecID is deprecated in favor of A_QUICKTIME (without a trailing codec name). Otherwise the storage is identical; see A_QUICKTIME for details. |

 A_QUICKTIME/QDMC | QDesign Music |

| A_QUICKTIME/QDM2 | QDesign Music v2 |

| A_TTA1 | [The True Audio](http://tausoft.org/) lossles audio compressor | [TTA format description](http://tausoft.org/wiki/True_Audio_Codec_Format)
Each frame is kept intact, including the CRC32. The header and seektable are dropped. The private data is void. SamplingFrequency, Channels and BitDepth are used in the TrackEntry. wFormatTag = 0x77A1 |

| A_WAVPACK4 | [WavPack](http://www.wavpack.com/) lossles audio compressor | The Wavpack packets consist of a stripped header followed by the frame data. For multi-track (> 2 tracks) a frame consists of many packets. For hybrid files (lossy part + correction part), the correction part is stored in an additional block (level 1). For more details, check the [WavPack muxing description](wavpack.html). |
| Subtitle |
| S_TEXT/UTF8 | UTF-8 Plain Text | Basic text subtitles. For more information, please look at the [Subtitle specifications]({{site.baseurl}}/subtitles.html). |
| S_TEXT/SSA | Subtitles Format | The [Script Info] and [V4 Styles] sections are stored in the codecprivate. Each event is stored in its own Block. For more information, please read the [specs for SSA/ASS](../subtitles/ssa.html). |
| S_TEXT/ASS | Advanced Subtitles Format | The [Script Info] and [V4 Styles] sections are stored in the codecprivate. Each event is stored in its own Block. For more information, please read the [specs for SSA/ASS]({{site.baseurl}}/subtitles.html). |
| S_TEXT/USF | Universal Subtitle Format | This is mostly defined, but not typed out yet. It will first be available on the [USF specs page]({{site.baseurl}}/subtitles.html). |
| S_TEXT/WEBVTT | Web Video Text Tracks Format (WebVTT) | Advanced text subtitles. For more information about the storage please look at the [WebVTT in Matroska specifications]({{site.baseurl}}/subtitles.html). |
| S_IMAGE/BMP | Bitmap | Basic image based subtitle format; The subtitles are stored as images, like in the DVD. The timestamp in the block header of matroska indicates the start display time, the duration is set with the Duration element. The full data for the subtitle bitmap is stored in the Block's data section. |
| S_VOBSUB | VobSub subtitles | The same subtitle format used on DVDs. Supoprted is only format version 7 and newer. VobSubs consist of two files, the .idx containing information, and the .sub, containing the actual data. The .idx file is stripped of all empty lines, of all comments and of lines beginning with `alt:` or `langidx:`. The line beginning with `id:` SHOULD be transformed into the appropriate Matroska track language element and is discarded. All remaining lines but the ones containing timestamps and file positions are put into the `CodecPrivate` element.
For each line containing the timestamp and file position data is read from the appropriate position in the .sub file. This data consists of a MPEG program stream which in turn contains SPU packets. The MPEG program stream data is discarded, and each SPU packet is put into one Matroska frame. |
| S_KATE | Karaoke And Text Encapsulation | A subtitle format developped for ogg. The mapping for Matroska is described on the [Xiph wiki](http://wiki.xiph.org/index.php/OggKate#Matroska_mapping). As for Theora and Vorbis, Kate headers are stored in the private data as xiph-laced packets. |
| Buttons |
| B_VOBBTN | VobBtn Buttons | Based on [MPEG/VOB PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html). The file contains a header consisting of the string "butonDVD" followed by the width and height in pixels (16 bits integer each) and 4 reserved bytes. The rest is full [PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html). |


To be supported later :

'V_MSWMV'; Video, Microsoft Video

'V_INDEO5'; Video, Indeo 5; transmuxed from AVI or created using VfW codec

'V_MJPEG'; Video, MJpeg codec (lossy mode, general)

'V_MJPEG2000'; Video, MJpeg 2000

'V_MJPEG2000LL'; Video, MJpeg Lossless

'V_DV'; Video, DV Video, type 1 (audio and video mixed)

'V_TARKIN'; Video, Ogg Tarkin

'V_ON2VP4'; Video, ON2, VP4

'V_ON2VP5'; Video, ON2, VP5

'V_3IVX'; Video, 3ivX (is D4 decoder downwards compatible?)

'V_HUFFYUV'; Video, HuffYuv, lossless; auch als VfW möglich

'V_COREYUV'; Video, CoreYuv, lossless; auch als VfW möglich

'V_RUDUDU'; Nicola's Rududu Wavelet codec

...... to be continued