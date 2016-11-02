---
layout: default
---
# CodecID

As an additional resource to this page Haali has created a [list of codec IDs in a PDF](http://haali.su/mkv/codecs.pdf).

For each TrackEntry inside [matroska]({{site.baseurl}}/index.html), there has to be a [CodecID]({{site.baseurl}}/index.html#CodecID) defined. This ID is represent the codec used to encode data in the Track. The codec works with the coded data in the stream, but also with some codec initialisation. There are 2 different kind of codec "initialisation":

*   CodecPrivate in the TrackEntry
*   CodecState in the BlockGroup

Each of these elements contain the same kind of data. And these data depend on the codec used.

Important Note:

The intention behind this list is `NOT` to list all existing audio and video codecs, but rather to list those codecs that are `currently supported` in Matroska and therefore need a well defined codec ID so that all developers supporting Matroska will use the same ID. If you feel we missed support for a very important codec, please tell us on our development mailing list (matroska-devel at lists.matroska.org).


## Video Codecs

  
Codec ID: "V_MS/VFW/FOURCC"  
Codec Name: Microsoft (TM) Video Codec Manager (VCM)  
Description: The private data contains the VCM structure BITMAPINFOHEADER including the extra private bytes, as [defined by Microsoft](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/gdi/bitmaps_1rw2.asp). The data are stored in little endian format (like on IA32 machines). Where is the Huffman table stored in HuffYUV, not AVISTREAMINFO ??? And the FourCC, not in AVISTREAMINFO.fccHandler ???

  
Codec ID: V_UNCOMPRESSED  
Codec Name: Video, raw uncompressed video frames  
Description: The private data is void, all details about the used colour specs and bit depth are to be put/read from the KaxCodecColourSpace elements.

  
Codec ID: V_MPEG4/ISO/???  
Codec Name: MPEG4 ISO Profile Video  
Description: The stream complies with, and uses the CodecID for, one of the MPEG-4 profiles listed below.

  
Codec ID: V_MPEG4/ISO/SP  
Codec Name: MPEG4 ISO simple profile (DivX4)  
Description: Stream was created via improved codec API (UCI) or even transmuxed from AVI (no b-frames in Simple Profile), frame order is coding order

  
Codec ID: V_MPEG4/ISO/ASP  
Codec Name: MPEG4 ISO advanced simple profile (DivX5, XviD, FFMPEG)  
Description: Stream was created via improved codec API (UCI) or transmuxed from MP4, not simply transmuxed from AVI! Note there are differences how b-frames are handled in these native streams, when being compared to a VfW created stream, as here there are `no` dummy frames inserted, the frame order is exactly the same as the coding order, same as in MP4 streams!

  
Codec ID: V_MPEG4/ISO/AP  
Codec Name: MPEG4 ISO advanced profile  
Description: (Same as above)

  
Codec ID: V_MPEG4/MS/V3  
Codec Name: Microsoft (TM) MPEG4 V3  
Description: and derivates, means DivX3, Angelpotion, SMR, etc.; stream was created using VfW codec or transmuxed from AVI; note that V1/V2 are covered in VfW compatibility mode

  
Codec ID: V_MPEG1  
Codec Name: MPEG 1  
Description: The matroska video stream will contain a demuxed Elementary Stream (ES ), where block boundaries are still to be defined. Its RECOMMENDED to use MPEG2MKV.exe for creating those files, and to compare the results with selfmade implementations

  
Codec ID: V_MPEG2  
Codec Name: MPEG 2  
Description: The matroska video stream will contain a demuxed Elementary Stream (ES ), where block boundaries are still to be defined. Its RECOMMENDED to use MPEG2MKV.exe for creating those files, and to compare the results with selfmade implementations

  
Codec ID: V_REAL/????  
Codec Name: Real Video(TM)   
Description: The stream is one of the Real Video(TM) video streams listed below. Source for the codec names are from [Karl Lillevold on Doom9](http://forum.doom9.org/showthread.php?s=&amp;threadid=55773&amp;perpage=20&amp;pagenumber=2#post331855). The CodecPrivate element contains a "real_video_props_t" structure in Big Endian byte order as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

  
Codec ID: V_REAL/RV10  
Codec Name: RealVideo 1.0 aka RealVideo 5  
Description: Individual slices from the Real container are combined into a single frame.

  
Codec ID: V_REAL/RV20  
Codec Name: RealVideo G2 and RealVideo G2+SVT  
Description: Individual slices from the Real container are combined into a single frame.

  
Codec ID: V_REAL/RV30  
Codec Name: RealVideo 8  
Description: Individual slices from the Real container are combined into a single frame.

  
Codec ID: V_REAL/RV40  
Codec Name: rv40 : RealVideo 9  
Description: Individual slices from the Real container are combined into a single frame.

  
Codec ID: V_QUICKTIME  
Codec Name: Video taken from QuickTime(TM) files  
Description: Several codecs as stored in QuickTime, e.g. Sorenson or Cinepak. The CodecPrivate contains all additional data that is stored in the 'stsd' (sample description) atom in the QuickTime file **after** the mandatory video descriptor structure (starting with the size and FourCC fields). For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

  
Codec ID: V_THEORA  
Codec Name: Theora  
Description: The private data contains the first three Theora packets in order. The lengths of the packets precedes them. The actual layout is: 

* Byte 1: number of distinct packets '`#p`' minus one inside the CodecPrivate block. This MUST be '2' for current (as of 2016-07-08) Theora headers. 
* Bytes 2..n: lengths of the first '`#p`' packets, coded in [Xiph-style lacing]({{site.baseurl}}/index.html#lacing). The length of the last packet is the length of the CodecPrivate block minus the lengths coded in these bytes minus one. 
* Bytes n+1..: The Theora identification header, followed by the commend header followed by the codec setup header. Those are described in the [Theora specs](http://www.theora.org/doc/Theora_I_spec.pdf).

  
Codec ID: V_PRORES  
Codec Name: Apple ProRes  
Description: The private data contains the fourcc as found in MP4 movies:

*   apch: ProRes 422 High Quality
*   apcn: ProRes 422 Standard Definition
*   apcs: ProRes 422 LT
*   apco: ProRes 422 Proxy
*   ap4h: ProRes 4444

[this page for more technical details on ProRes](http://wiki.multimedia.cx/index.php?title=Apple_ProRes#Frame_layout)


## Audio 

  
Codec ID: A_MPEG/L3  
Codec Name: MPEG Audio 1, 2, 2.5 Layer III  
Description: The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0055

  
Codec ID: A_MPEG/L2  
Codec Name: MPEG Audio 1, 2 Layer II  
Description: The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0050

  
Codec ID: A_MPEG/L1  
Codec Name: MPEG Audio 1, 2 Layer I  
Description: The private data is void. The data contain everything needed for playback in the MPEG Audio header of each frame. Corresponding ACM wFormatTag : 0x0050

  
Codec ID: A_PCM/INT/BIG  
Codec Name: PCM Integer Big Endian  
Description: The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element. Corresponding ACM wFormatTag : ???

  
Codec ID: A_PCM/INT/LIT  
Codec Name: PCM Integer Little Endian  
Description: The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element. Corresponding ACM wFormatTag : 0x0001

  
Codec ID: A_PCM/FLOAT/IEEE  
Codec Name: Floating Point, IEEE compatible  
Description: The private data is void. The bitdepth has to be read and set from KaxAudioBitDepth element (32 bit in most cases). The float are stored in little endian order (most common float format). Corresponding ACM wFormatTag : 0x0003

  
Codec ID: A_MPC  
Codec Name: MPC (musepack) SV8  
Description: The main developer for musepack has requested that we wait until the SV8 framing has been fully defined for musepack before defining how to store it in Matroska.

  
Codec ID: A_AC3  
Codec Name: (Dolby™) AC3  
Description: BSID <= 8 !! The private data is void ??? Corresponding ACM wFormatTag : 0x2000 ; channel number have to be read from the corresponding audio element

  
Codec ID: A_AC3/BSID9  
Codec Name: (Dolby™) AC3  
Description: The ac3 frame header has, similar to the mpeg-audio header a version field. Normal ac3 is defiened as bitstream id 8 (5 Bits, numbers are 0-15). Everything below 8 is still compatible with all decoders that handle 8 correctly. Everything higher are additions that break decoder compatibility.
For the samplerates 24kHz (00); 22,05kHz (01) and 16kHz (10) the BSID is 9
For the samplerates 12kHz (00); 11,025kHz (01) and 8kHz (10) the BSID is 10

  
Codec ID: A_AC3/BSID10  
Codec Name: (Dolby™) AC3  
Description: (Same as above)

  
Codec ID: A_ALAC  
Codec Name: ALAC (Apple Lossless Audio Codec)  
Description: The private data contains ALAC's magic cookie (both the codec specific configuration as well as the optional channel layout information). Its format is described in [ALAC's official source code](http://alac.macosforge.org/trac/browser/trunk/ALACMagicCookieDescription.txt).

  
Codec ID: A_DTS  
Codec Name: Digital Theatre System  
Description: Supports DTS, DTS-ES, DTS-96/26, DTS-HD High Resolution Audio and DTS-HD Master Audio. The private data is void. Corresponding ACM wFormatTag : 0x2001
 
  
Codec ID: A_DTS/EXPRESS  
Codec Name: Digital Theatre System Express  
Description: DTS Express (a.k.a. LBR) audio streams. The private data is void. Corresponding ACM wFormatTag : 0x2001

  
Codec ID: A_DTS/LOSSLESS  
Codec Name: Digital Theatre System Lossless  
Description: DTS Lossless audio that does not have a core substream. The private data is void. Corresponding ACM wFormatTag : 0x2001

  
Codec ID: A_VORBIS  
Codec Name: Vorbis  
Description: The private data contains the first three Vorbis packet in order. The lengths of the packets precedes them. The actual layout is:
Byte 1: number of distinct packets '`#p`' minus one inside the CodecPrivate block. This MUST be '2' for current (as of 2016-07-08) Vorbis headers.
Bytes 2..n: lengths of the first '`#p`' packets, coded in [Xiph-style lacing]({{site.baseurl}}/index.html#lacing). The length of the last packet is the length of the CodecPrivate block minus the lengths coded in these bytes minus one.
Bytes n+1..: The [Vorbis identification header](http://www.xiph.org/ogg/vorbis/doc/vorbis-spec-ref.html), followed by the [Vorbis comment header](http://www.xiph.org/ogg/vorbis/doc/v-comment.html) followed by the [codec setup header](http://www.xiph.org/ogg/vorbis/doc/vorbis-spec-ref.html).

  
Codec ID: A_FLAC  
Codec Name: [FLAC (Free Lossless Audio Codec)](http://flac.sourceforge.net/)  
Description: The private data contains all the header/metadata packets before the first data packet. These include the first header packet containing only the word `fLaC` as well as all metadata packets.

  
Codec ID: A_REAL/????  
Codec Name: Realmedia Audio codecs  
Description: The stream contains one of the following audio codecs. In each case the CodecPrivate element contains either the "real_audio_v4_props_t" or the "real_audio_v5_props_t" structure (differentiated by their "version" field; Big Endian byte order) as found in [librmff](https://github.com/mbunkus/mkvtoolnix/blob/master/lib/librmff/librmff.h).

  
Codec ID: A_REAL/14_4  
Codec Name: Real Audio 1  
Description: 

  
Codec ID: A_REAL/28_8  
Codec Name: Real Audio 2  
Description: 

  
Codec ID: A_REAL/COOK  
Codec Name: Real Audio Cook Codec (codename: Gecko)  
Description: 

  
Codec ID: A_REAL/SIPR   
Codec Name: Sipro Voice Codec  
Description: 

  
Codec ID: A_REAL/RALF  
Codec Name: Real Audio Lossless Format  
Description: 

  
Codec ID: A_REAL/ATRC  
Codec Name: Sony Atrac3 Codec  
Description: 

  
Codec ID: A_MS/ACM  
Codec Name: Microsoft(TM) Audio Codec Manager (ACM)  
Description: The private data contains the ACM structure WAVEFORMATEX including the extra private bytes, as [defined by Microsoft](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/multimed/mmstr_625u.asp). The data are stored in little endian format (like on IA32 machines).

  
Codec ID: A_AAC/?????/???  
Codec Name: AAC Profile Audio  
Description: The stream complies with, and uses the CodecID for, one of the AAC profiles listed below. AAC audio always uses wFormatTag 0xFF

  
Codec ID: A_AAC/MPEG2/MAIN  
Codec Name: MPEG2 Main Profile  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG2/LC  
Codec Name: Low Complexity  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG2/LC/SBR  
Codec Name: Low Complexity with Spectral Band Replication  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG2/SSR  
Codec Name: Scalable Sampling Rate  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG4/MAIN  
Codec Name: MPEG4 Main Profile  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG4/LC  
Codec Name: Low Complexity  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG4/LC/SBR  
Codec Name: Low Complexity with Spectral Band Replication  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG4/SSR  
Codec Name: Scalable Sampling Rate  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_AAC/MPEG4/LTP  
Codec Name: Long Term Prediction  
Description: The private data is void. Channel number and sample rate have to be read from the corresponding audio element. Audio stream is stripped from ADTS headers and normal matroska frame based muxing scheme is applied.

  
Codec ID: A_QUICKTIME  
Codec Name: Audio taken from QuickTime(TM) files  
Description: Several codecs as stored in QuickTime, e.g. QDesign Music v1 or v2\. The CodecPrivate contains all additional data that is stored in the 'stsd' (sample description) atom in the QuickTime file **after** the mandatory sound descriptor structure (starting with the size and FourCC fields). For an explanation of the QuickTime file format read [QuickTime File Format Specification](https://developer.apple.com/library/mac/documentation/QuickTime/QTFF/QTFFPreface/qtffPreface.html).

  
Codec ID: A_QUICKTIME/????  
Codec Name: QuickTime audio codecs  
Description: This CodecID is deprecated in favor of A_QUICKTIME (without a trailing codec name). Otherwise the storage is identical; see A_QUICKTIME for details.

  
Codec ID: A_QUICKTIME/QDMC  
Codec Name: QDesign Music  
Description: 

  
Codec ID: A_QUICKTIME/QDM2  
Codec Name: QDesign Music v2  
Description: 

  
Codec ID: A_TTA1  
Codec Name: [The True Audio](http://tausoft.org/) lossles audio compressor  
Description: [TTA format description](http://tausoft.org/wiki/True_Audio_Codec_Format)
Each frame is kept intact, including the CRC32. The header and seektable are dropped. The private data is void. SamplingFrequency, Channels and BitDepth are used in the TrackEntry. wFormatTag = 0x77A1

  
Codec ID: A_WAVPACK4  
Codec Name: [WavPack](http://www.wavpack.com/) lossles audio compressor  
Description: The Wavpack packets consist of a stripped header followed by the frame data. For multi-track (> 2 tracks) a frame consists of many packets. For hybrid files (lossy part + correction part), the correction part is stored in an additional block (level 1). For more details, check the [WavPack muxing description](wavpack.html).

## Subtitle 

  
Codec ID: S_TEXT/UTF8  
Codec Name: UTF-8 Plain Text  
Description: Basic text subtitles. For more information, please look at the [Subtitle specifications]({{site.baseurl}}/subtitles.html).

  
Codec ID: S_TEXT/SSA  
Codec Name: Subtitles Format  
Description: The [Script Info] and [V4 Styles] sections are stored in the codecprivate. Each event is stored in its own Block. For more information, please read the [specs for SSA/ASS]({{site.baseurl}}/subtitles.html).

  
Codec ID: S_TEXT/ASS  
Codec Name: Advanced Subtitles Format  
Description: The [Script Info] and [V4 Styles] sections are stored in the codecprivate. Each event is stored in its own Block. For more information, please read the [specs for SSA/ASS]({{site.baseurl}}/subtitles.html).

  
Codec ID: S_TEXT/USF  
Codec Name: Universal Subtitle Format   
Description: This is mostly defined, but not typed out yet. It will first be available on the [USF specs page]({{site.baseurl}}/subtitles.html).

  
Codec ID: S_TEXT/WEBVTT  
Codec Name: Web Video Text Tracks Format (WebVTT)  
Description: Advanced text subtitles. For more information about the storage please look at the [WebVTT in Matroska specifications]({{site.baseurl}}/subtitles.html).

  
Codec ID: S_IMAGE/BMP  
Codec Name: Bitmap  
Description: Basic image based subtitle format; The subtitles are stored as images, like in the DVD. The timestamp in the block header of matroska indicates the start display time, the duration is set with the Duration element. The full data for the subtitle bitmap is stored in the Block's data section.

  
Codec ID: S_VOBSUB  
Codec Name: VobSub subtitles  
Description: The same subtitle format used on DVDs. Supoprted is only format version 7 and newer. VobSubs consist of two files, the .idx containing information, and the .sub, containing the actual data. The .idx file is stripped of all empty lines, of all comments and of lines beginning with `alt:` or `langidx:`. The line beginning with `id:` SHOULD be transformed into the appropriate Matroska track language element and is discarded. All remaining lines but the ones containing timestamps and file positions are put into the `CodecPrivate` element.
For each line containing the timestamp and file position data is read from the appropriate position in the .sub file. This data consists of a MPEG program stream which in turn contains SPU packets. The MPEG program stream data is discarded, and each SPU packet is put into one Matroska frame.

  
Codec ID: S_KATE  
Codec Name: Karaoke And Text Encapsulation  
Description: A subtitle format developped for ogg. The mapping for Matroska is described on the [Xiph wiki](http://wiki.xiph.org/index.php/OggKate#Matroska_mapping). As for Theora and Vorbis, Kate headers are stored in the private data as xiph-laced packets.

## Buttons

  
Codec ID: B_VOBBTN  
Codec Name: VobBtn Buttons   
Description: Based on [MPEG/VOB PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html). The file contains a header consisting of the string "butonDVD" followed by the width and height in pixels (16 bits integer each) and 4 reserved bytes. The rest is full [PCI packets](http://dvd.sourceforge.net/dvdinfo/pci_pkt.html).
