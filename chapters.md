---
layout: default
---
#Chapters

## Example 1 : basic chaptering

In this example a movie is split in different chapters. It could also just be an audio file (album) on which each track corresponds to a chapter.

*   00000ms - 05000ms : Intro
*   05000ms - 25000ms : Before the crime
*   25000ms - 27500ms : The crime
*   27500ms - 38000ms : The killer arrested
*   38000ms - 43000ms : Credits

This would translate in the following matroska form :

```xml
<Chapters>
  <EditionEntry>
    <ChapterAtom>
      <ChapterUID format="hex">12 34 56</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>5000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Intro</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">23 45 67</ChapterUID>
      <ChapterTimeStart>5000000</ChapterTimeStart>
      <ChapterTimeEnd>25000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Before the crime</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapterString>Avant le crime</ChapterString>
        <ChapterLanguage>fra</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">34 56 78</ChapterUID>
      <ChapterTimeStart>25000000</ChapterTimeStart>
      <ChapterTimeEnd>27500000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>The crime</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapterString>Le crime</ChapterString>
        <ChapterLanguage>fra</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">45 67 89</ChapterUID>
      <ChapterTimeStart>27500000</ChapterTimeStart>
      <ChapterTimeEnd>38000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>After the crime</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapterString>Après le crime</ChapterString>
        <ChapterLanguage>fra</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">45 67 89</ChapterUID>
      <ChapterTimeStart>38000000</ChapterTimeStart>
      <ChapterTimeEnd>43000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Credits</ChapterString>
        <ChapterLanguage>eng</ChapterLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapterString>Générique</ChapterString>
        <ChapterLanguage>fra</ChapterLanguage>
      </ChapterDisplay>
    </ChapterAtom>
  </EditionEntry>
</Chapters>
```

## Example 2 : nested chapters

In this example an (existing) album is split into different chapters, and one of them contain another splitting.

### The Micronauts "Bleep To Bleep"

*   00:00 - 12:28 : Baby Wants To Bleep/Rock
    *   00:00 - 04:38 : Baby wants to bleep (pt.1)
    *   04:38 - 07:12 : Baby wants to rock
    *   07:12 - 10:33 : Baby wants to bleep (pt.2)
    *   10:33 - 12:28 : Baby wants to bleep (pt.3)
*   12:30 - 19:38 : Bleeper_O+2
*   19:40 - 22:20 : Baby wants to bleep (pt.4)
*   22:22 - 25:18 : Bleep to bleep
*   25:20 - 33:35 : Baby wants to bleep (k)
*   33:37 - 44:28 : Bleeper

```xml
<Chapters>
  <EditionEntry>
    <ChapterAtom>
      <ChapterUID format="hex">65 43 21</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>748000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Baby wants to Bleep/Rock</ChapterString>
      </ChapterDisplay>
      <ChapterAtom>
        <ChapterUID format="hex">12 34 56</ChapterUID>
        <ChapterTimeStart>0</ChapterTimeStart>
        <ChapterTimeEnd>278000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapterString>Baby wants to bleep (pt.1)</ChapterString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID format="hex">23 45 67</ChapterUID>
        <ChapterTimeStart>278000000</ChapterTimeStart>
        <ChapterTimeEnd>432000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapterString>Baby wants to rock</ChapterString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID format="hex">34 56 78</ChapterUID>
        <ChapterTimeStart>432000000</ChapterTimeStart>
        <ChapterTimeEnd>633000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapterString>Baby wants to bleep (pt.2)</ChapterString>
        </ChapterDisplay>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID format="hex">45 67 89</ChapterUID>
        <ChapterTimeStart>633000000</ChapterTimeStart>
        <ChapterTimeEnd>748000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapterString>Baby wants to bleep (pt.3)</ChapterString>
        </ChapterDisplay>
      </ChapterAtom>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">56 78 90</ChapterUID>
      <ChapterTimeStart>750000000</ChapterTimeStart>
      <ChapterTimeEnd>1178000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Bleeper_O+2</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">67 89 01</ChapterUID>
      <ChapterTimeStart>1180000000</ChapterTimeStart>
      <ChapterTimeEnd>1340000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Baby wants to bleep (pt.4)</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">78 90 12</ChapterUID>
      <ChapterTimeStart>1342000000</ChapterTimeStart>
      <ChapterTimeEnd>1518000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Bleep to bleep</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">89 01 23</ChapterUID>
      <ChapterTimeStart>1520000000</ChapterTimeStart>
      <ChapterTimeEnd>2015000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Baby wants to bleep (k)</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID format="hex">90 12 34</ChapterUID>
      <ChapterTimeStart>2017000000</ChapterTimeStart>
      <ChapterTimeEnd>2668000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Bleeper</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
  </EditionEntry>
</Chapters>
```

## Edition and chapter flags

### Chapter flags

There are two important flags that apply to chapter atoms: _enabled_ and _hidden_. The effect of those flags always applies to child atoms of an atom affected by that flag.

For example: Let's assume a parent atom with flag _hidden_ set to _true_; that parent contains two child atom, the first with _hidden_ set to _true_ as well and the second child with the flag either set to _false_ or not present at all (in which case the default value applies, and that again is _false_).

As the parent is hidden all of its children are initially hidden as well. However, when a control track toggles the parent's _hidden_ flag to _false_ then only the the parent and its second child will be visible. The first child's explicitely set flag retains its value until its value is toggled to _false_ by a control track.

Corresponding behavior applies to the _enabled_ flag.

### Edition flags

The edition's _hidden_ flag behaves much the same as the chapter's _hidden_ flag: if an edition is hidden then none of its children SHALL be visible, no matter their own _hidden_ flags. If the edition is toggled to being visible then the chapter atom's _hidden_ flags decide whether or not the chapter is visible.

## Menu features

The menu features are handled like a _chapter codec_. That means each codec has a type, some private data and some data in the chapters.

The type of the menu system is defined by the ChapProcessCodecID parameter. For now only 2 values are supported : 0 matroska script, 1 menu borrowed from the DVD. The private data depend on the type of menu system (stored in ChapProcessPrivate), idem for the data in the chapters (stored in ChapProcessData).

### Matroska Script (0)

This is the case when [ChapProcessCodecID]({{site.baseurl}}/index.html#ChapProcessCodecID) = 0\. This is a script language build for Matroska purposes. The inspiration comes from ActionScript, javascript and other similar scripting languages. The commands are stored as text commands, in UTF-8\. The syntax is C like, with commands spanned on many lines, each terminating with a ";". You can also include comments at the end of lines with "//" or comment many lines using "/* */". The scripts are stored in ChapProcessData. For the moment ChapProcessPrivate is not used.

The one and only command existing for the moment is `GotoAndPlay( ChapterUID );`. As the same suggests, it means that when this command is encountered, the playback SHOULD jump to the Chapter specified by the UID and play it.

### DVD menu (1)

This is the case when [ChapProcessCodecID]({{site.baseurl}}/index.html#ChapProcessCodecID) = 1\. Each level of a chapter corresponds to a logical level in the DVD system that is stored in the first octet of the ChapProcessPrivate. This DVD hierarchy is as follows:


| ChapProcessPrivate | DVD Name | Hierarchy | Commands Possible | Comment |
| 0x30 | SS | DVD domain | - | First Play, Video Manager, Video Title |
| 0x2A | LU | Language Unit | - | Contains only PGCs |
| 0x28 | TT | Title | - | Contains only PGCs |
| 0x20 | PGC | Program Group Chain (PGC) | * |
| 0x18 | PG | Program 1 | Program 2 | Program 3 | - |
| 0x10 | PTT | Part Of Title 1 | Part Of Title 2 | - | Equivalent to the chapters on the sleeve. |
| 0x08 | CN | Cell 1 | Cell 2 | Cell 3 | Cell 4 | Cell 5 | Cell 6 | - |


You can also recover wether a Segment is a Video Manager (VMG), Video Title Set (VTS) or Video Title Set Menu (VTSM) from the [ChapterTranslateID]({{site.baseurl}}/index.html#ChapterTranslateID) element found in the Segment Info. This field uses 2 octets as follows:

1.  Domain Type: 0 for VMG, the domain number for VTS and VTSM
2.  Domain Value: 0 for VMG and VTSM, 1 for the VTS source.

For instance, the menu part from VTS_01_0.VOB would be coded [1,0] and the content part from VTS_02_3.VOB would be [2,1]. The VMG is always [0,0]

The following octets of ChapProcessPrivate are as follows:


| Octet 1 | DVD Name | Following Octets |
| 0x30 | SS | Domain name code (1: 0x00= First play, 0xC0= VMG, 0x40= VTSM, 0x80= VTS) + VTS(M) number (2) |
| 0x2A | LU | Language code (2) + Language extension (1) |
| 0x28 | TT | global Title number (2) + corresponding TTN of the VTS (1) |
| 0x20 | PGC | PGC number (2) + Playback Type (1) + Disabled User Operations (4) |
| 0x18 | PG | Program number (2) |
| 0x10 | PTT | PTT-chapter number (1) |
| 0x08 | CN | Cell number [VOB ID(2)][Cell ID(1)][Angle Num(1)] |


If the level specified in ChapProcessPrivate is a PGC (0x20), there is an octet called the Playback Type, specifying the kind of PGC defined:

*   0x00: entry only/basic PGC
*   0x82: Title+Entry Menu (only found in the Video Manager domain)
*   0x83: Root Menu (only found in the VTSM domain)
*   0x84: Subpicture Menu (only found in the VTSM domain)
*   0x85: Audio Menu (only found in the VTSM domain)
*   0x86: Angle Menu (only found in the VTSM domain)
*   0x87: Chapter Menu (only found in the VTSM domain)

The next 4 following octets correspond to the [User Operation flags](http://dvd.sourceforge.net/dvdinfo/uops.html) in the standard PGC. When a bit is set, the command SHOULD be disabled.

ChapProcessData contains the pre/post/cell commands in binary format as there are stored on a DVD. There is just an octet preceeding these data to specify the number of commands in the element. As follows: [# of commands(1)][command 1 (8)][command 2 (8)][command 3 (8)].

More information on the DVD commands and format on [DVD-replica](http://www.dvd-replica.com/DVD/), where we got most of the info about it. You can also get information on DVD from [the DVDinfo project](http://dvd.sourceforge.net/dvdinfo/).