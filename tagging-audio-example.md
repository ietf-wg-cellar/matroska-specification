---
---

# Audio Tags Example

## Introduction

Audio content is usually found with tags, i.e. meta information about the content you can listen to like the artist name, the track title, the year of release, etc. The problem is that people are now ripping their CDs in just one file for consistency on their hard-drive and usually avoiding gap problems on live/classical/mixes albums. So now you can find many tracks in just one file, and the usual flat structure to tag content doesn't work anymore.

The XML Tag files matching [mkvmerge's DTD format](https://matroska.org/files/tags/matroskatags.dtd) for all the examples on this page can be found in a [zip file](https://matroska.org/files/tags/audiotags.zip).

Let's consider the mini-album of [The Micronauts](http://www.the-micronauts.com/) "[Bleep To Bleep](http://www.discogs.com/release/8788)", as found in the chapter examples. The tracks are laid out on the CD as follows:

*   00:00 - 12:28 : Baby Wants To Bleep/Rock
    *   **01** - 00:00 - 04:38 : Baby wants to bleep (pt.1)
    *   **02** - 04:38 - 07:12 : Baby wants to rock
    *   **03** - 07:12 - 10:33 : Baby wants to bleep (pt.2)
    *   **04** - 10:33 - 12:28 : Baby wants to bleep (pt.3)
*   **05** - 12:30 - 19:38 : Bleeper_O+2
*   **06** - 19:40 - 22:20 : Baby wants to bleep (pt.4)
*   **07** - 22:22 - 25:18 : Bleep to bleep
*   **08** - 25:20 - 33:35 : Baby wants to bleep (k)
*   **09** - 33:37 - 44:28 : Bleeper

Tracks 01 to 04 are linked together and are actually making just one "virtual" track to the listener.

## One file with all tracks

In this case the file contains one continuous audio track of 44:28\. Chapters are used to virtually split the content in many parts, ie the CD tracks. A basic ripping application would rip the CD tracks as follows :

*   Chapters
    *   EditionEntry
        *   ChapterAtom
            *   ChapterUID = 123456
            *   ChapterTimeStart = 0 ns
            *   ChapterTimeEnd = 278,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 234567
            *   ChapterTimeStart = 278,000,000 ns
            *   ChapterTimeEnd = 432,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 345678
            *   ChapterTimeStart = 432,000,000 ns
            *   ChapterTimeEnd = 633,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 456789
            *   ChapterTimeStart = 633,000,000 ns
            *   ChapterTimeEnd = 748,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 567890
            *   ChapterTimeStart = 750,000,000 ns
            *   ChapterTimeEnd = 1,178,500,000 ns
        *   ChapterAtom
            *   ChapterUID = 678901
            *   ChapterTimeStart = 1,180,000,000 ns
            *   ChapterTimeEnd = 1,340,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 789012
            *   ChapterTimeStart = 1,342,000,000 ns
            *   ChapterTimeEnd = 1,518,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 890123
            *   ChapterTimeStart = 1,520,000,000 ns
            *   ChapterTimeEnd = 2,015,000,000 ns
        *   ChapterAtom
            *   ChapterUID = 901234
            *   ChapterTimeStart = 2,017,000,000 ns
            *   ChapterTimeEnd = 2,668,000,000 ns

Now let's see how a basic tagging of this file would work ([XML version](https://matroska.org/files/tags/bleep-one.xml)) :

*   Tags
    *   Tag
        *   Targets (_no target means the whole content of the file, otherwise you can put all ChapterUIDs_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Micronauts"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep To Bleep"
        *   SimpleTag
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "9"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2004-04"
    *   Tag
        *   Targets
            *   ChapterUID = 123456
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.1)"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
    *   Tag
        *   Targets
            *   ChapterUID = 234567
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to rock"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "2"
    *   Tag
        *   Targets
            *   ChapterUID = 345678
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.2)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "3"
    *   Tag
        *   Targets
            *   ChapterUID = 456789
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.3)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "4"
    *   Tag
        *   Targets
            *   ChapterUID = 567890
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleeper_O+2"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "5"
    *   Tag
        *   Targets
            *   ChapterUID = 678901
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.4)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "6"
    *   Tag
        *   Targets
            *   ChapterUID = 789012
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep to bleep"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "7"
    *   Tag
        *   Targets
            *   ChapterUID = 890123
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (k)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "8"
    *   Tag
        *   Targets
            *   ChapterUID = 901234
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleeper"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "9"

## One file per CD track

Now let's split this one file in pieces :

### Track 1 / File #1
[XML version](https://matroska.org/files/tags/bleep-trackfile1.xml)

*   Tags
    *   Tag
        *   Targets (no target means the whole content of the file, otherwise you can put all ChapterUIDs)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Micronauts"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep To Bleep"
        *   SimpleTag
            *   TagName = "TOTAL_PARTS"
            *   TagString = "9"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2004-04"
    *   Tag
        *   Targets (_no chapter target since the file may not contain one, but if it does you can use it_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.1)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "1"

### Track 2 / File #2
[XML version](https://matroska.org/files/tags/bleep-trackfile2.xml)

*   Tags
    *   Tag
        *   Targets (no target means the whole content of the file, otherwise you can put all ChapterUIDs)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Micronauts"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep To Bleep"
        *   SimpleTag
            *   TagName = "TOTAL_PARTS"
            *   TagString = "9"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2004-04"
    *   Tag
        *   Targets (_no chapter target since the file may not contain one, but if it does you can use it_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to rock"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "2"

etc...

## One file per "meaningful" track

In this case the 4 first tracks appear in one file.

### Tracks 1-2-3-4 / File #1
[XML version](https://matroska.org/files/tags/bleep-continuous1.xml)

*   Tags
    *   Tag
        *   Targets (no target means the whole content of the file, otherwise you can put all ChapterUIDs)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Micronauts"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep To Bleep"
        *   SimpleTag
            *   TagName = "TOTAL_PARTS"
            *   TagString = _"6"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2004-04"
    *   Tag
        *   Targets (_include all chapters that match the first 4 tracks, if chapters are present in the file_)
            *   ChapterUID = 123456
            *   ChapterUID = 234567
            *   ChapterUID = 345678
            *   ChapterUID = 456789
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = _"Baby wants to bleep/rock"_
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "1"
        *   SimpleTag
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "4"
    *   Tag (_the following tags may or may not be included in the file, it can't be if no chapters are used_)
        *   Targets
            *   ChapterUID = 123456
            *   _TargetTypeValue = 20_
            *   _TargetType = "PART"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.1)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "1"
    *   Tag
        *   Targets
            *   ChapterUID = 234567
            *   _TargetTypeValue = 20_
            *   _TargetType = "PART"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to rock"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "2"
    *   Tag
        *   Targets
            *   ChapterUID = 345678
            *   _TargetTypeValue = 20_
            *   _TargetType = "PART"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.2)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "3"
    *   Tag
        *   Targets
            *   ChapterUID = 456789
            *   _TargetTypeValue = 20_
            *   _TargetType = "PART"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Baby wants to bleep (pt.3)"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "4"

### Tracks 5 / File #2
[XML version](https://matroska.org/files/tags/bleep-continuous2.xml)

*   Tags
    *   Tag
        *   Targets (no target means the whole content of the file, otherwise you can put all ChapterUIDs)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Micronauts"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleep To Bleep"
        *   SimpleTag
            *   TagName = "TOTAL_PARTS"
            *   TagString = _"6"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2004-04"
    *   Tag
        *   Targets (_no chapter target since the file may not contain one, but if it does you can use it_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bleeper_O+2"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "2"

etc...

## Album on 2 CDs

Many albums contain 2 CD in the box. Here is an example of a real-life case and how to keep the information about the physical source: Future Sound Of London "[Lifeforms](http://www.discogs.com/release/8067)". In this example we'll have one file per CD track.

### File #1 : CD #1 - Track #1
[XML version](https://matroska.org/files/tags/lifeform-1_1.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lifeforms"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Future Sound Of London"
        *   SimpleTag (_the number of tracks in the album_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "19"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1994"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Virgin Records UK"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_the number of the track in the album_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Cascade"

### File #2 : CD #1 - Track #2 
[XML version](https://matroska.org/files/tags/lifeform-1_2.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lifeforms"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Future Sound Of London"
        *   SimpleTag (_the number of tracks in the album_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "19"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1994"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Virgin Records UK"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_the number of the track in the album_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Ill Flower"

etc...

### File #9 : CD #2 - Track #1
[XML version](https://matroska.org/files/tags/lifeform-2_1.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lifeforms"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Future Sound Of London"
        *   SimpleTag (_the number of tracks in the album_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "19"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1994"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Virgin Records UK"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_the number of the track in the album_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "9"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Domain"

etc...

## Album with 2 different CDs

This is almost the same as the previous example. But this time each CD in the pack is related to a different logical level: DJ Hell "[Electronicbody-Housemusic](http://www.discogs.com/release/63287)". In this example we'll have one file per CD track.

### File #1 : CD #1 - Track #1
[XML version](https://matroska.org/files/tags/hell-eh-1_1.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Electronicbody-Housemusic"
        *   SimpleTag
            *   TagName = "MIXED_BY"
            *   TagString = "DJ Hell"
        *   SimpleTag (_the number of parts in the album : 2 sessions_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2002-10-28"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "React"
    *   Tag (_information about the 1st session CD_)
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 40_
            *   _TargetType = "SESSION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Housemusic"
        *   SimpleTag (_the number of the session_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of tracks in the session_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "18"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_the number of the track in the album_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Underground Resistance"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Inspiration"

### File #2 : CD #1 - Track #2
[XML version](https://matroska.org/files/tags/hell-eh-1_2.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Electronicbody-Housemusic"
        *   SimpleTag
            *   TagName = "MIXED_BY"
            *   TagString = "DJ Hell"
        *   SimpleTag (_the number of parts in the album : 2 sessions_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2002-10-28"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "React"
    *   Tag (_information about the 1st session CD_)
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 40_
            *   _TargetType = "SESSION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Housemusic"
        *   SimpleTag (_the number of the session_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of tracks in the session_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "18"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_2 of 18_)
            *   TagName = "PART_NUMBER"
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Metro Area"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Miura"

etc... Now from second CD/mix :

### File #19 : CD #2 - Track #1
[XML version](https://matroska.org/files/tags/hell-eh-2_1.xml)

*   Tags
    *   Tag
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Electronicbody-Housemusic"
        *   SimpleTag
            *   TagName = "MIXED_BY"
            *   TagString = "DJ Hell"
        *   SimpleTag (_the number of parts in the album : 2 sessions_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2002-10-28"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "React"
    *   Tag (_information about the 1st session CD_)
        *   Targets (_no target since it covers the whole file and more_)
            *   _TargetTypeValue = 40_
            *   _TargetType = "SESSION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Electronicbody"
        *   SimpleTag (_2 of 2_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag (_the number of tracks in the session_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "16"
    *   Tag
        *   Targets (_no target since it covers the whole file_)
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag (_1 of 16_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "German Broadcaster"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "S-Channel"
        *   SimpleTag
            *   TagName = "SUBTITLE"
            *   TagString = "Radio Broadcast Mix"

etc...

## Collection of CD sets

Sometimes an album can contain many CDs. And sometimes an album can be part of a bigger collection, like a CD series. Here is one example of such a real-life case and how it would be tagged. We'll **only cover the case of 1 file per CD**. Other cases could be deduced from the previous examples.

The example here is a Big Beat collection called "Big Beat Elite" by the Lacerba label. There are 3 instances in this collection : "[Big Beat Elite](http://www.discogs.com/release/70919)", "[Big Beat Elite Repeat](http://www.discogs.com/release/72561)" and "[Big Beat Elite Complete](http://www.discogs.com/release/157518)". Each item in the collection contains 3 CDs. 2 CDs containing the tracks, and the 3rd CD containing the same tracks but mixed. We won't tag all the content here, just giving examples how some CDs or tracks would be tagged in the file.

### File #1 : Big Beat Elite CD #1 containing plain tracks
[XML version](https://matroska.org/files/tags/bigbeat-1_1.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1997"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "10"
    *   Tag
        *   Targets (_the first track of the first CD_)
            *   ChapterUID = 123456
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Sol Brothers"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "That Elvis Track"
    *   Tag
        *   Targets (_the second track of the CD is a remix_)
            *   ChapterUID = 234567
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Saint Etienne"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Filthy"
        *   SimpleTag
            *   TagName = _"SUBTITLE"_
            *   TagString = "Monkey Mafia Mix"
        *   SimpleTag
            *   TagName = _"REMIXED_BY"_
            *   TagString = "Monkey Mafia"
    *   etc...

### File #2 : Big Beat Elite CD #2 containing plain tracks
[XML version](https://matroska.org/files/tags/bigbeat-1_2.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag (_this tag may be omitted as it's the same as the upper level, but it wouldn't be coherent with other CDs_)
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1997"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "10"
    *   Tag
        *   Targets (_the first track of the CD_)
            *   ChapterUID = 987654
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Bentley Rhythm Ace"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Run On The Spot"
    *   Tag
        *   Targets (_the second track of the CD_)
            *   ChapterUID = 876543
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Eboman"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Donuts With Buddah"
    *   etc...

### File #3 : Big Beat Elite CD #3 containing mixed tracks
[XML version](https://matroska.org/files/tags/bigbeat-1_3.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag (_this tag may be omitted as it's the same as the upper level, but it wouldn't be coherent with other CDs_)
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1997"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite Mixed by XYZ"
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "3"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "20"
    *   Tag
        *   Targets (_the first track of the CD_)
            *   ChapterUID = 258369
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Aleem"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Why Hawaii?"
        *   SimpleTag
            *   TagName = "SUBTITLE"
            *   TagString = "Original Formula Mix"
    *   Tag
        *   Targets
            *   ChapterUID = 147258
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Saint Etienne"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Filthy"
        *   SimpleTag
            *   TagName = _"SUBTITLE"_
            *   TagString = "Monkey Mafia Mix"
        *   SimpleTag
            *   TagName = _"REMIXED_BY"_
            *   TagString = "Monkey Mafia"
    *   Tag
        *   Targets
            *   ChapterUID = 147258
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Mo & Skinny"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Wake Up"
    *   etc...

### File #4 : Big Beat Elite Repeat CD #1
[XML version](https://matroska.org/files/tags/bigbeat-2_1.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = _"Big Beat Elite Repeat"_
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1998"
    *   Tag
        *   Targets
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "10"
    *   Tag
        *   Targets (_the first track of the CD_)
            *   ChapterUID = 369852
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Jean-Jacques Perrey"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "E.V.A."
        *   SimpleTag
            *   TagName = "SUBTITLE"
            *   TagString = "Fatboy Slim Remix"
        *   SimpleTag
            *   TagName = "REMIXED_BY"
            *   TagString = "Fatboy Slim"
    *   Tag
        *   Targets
            *   ChapterUID = 741258
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Lo-Fidelity Allstars"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Kool Rok Bass"
    *   etc...

### File #5 : Big Beat Elite Repeat CD #2
[XML version](https://matroska.org/files/tags/bigbeat-2_2.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = _"Big Beat Elite Repeat"_
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1998"
    *   Tag
        *   Targets
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "10"
    *   Tag
        *   Targets (_the first track of the CD_)
            *   ChapterUID = 369852
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Rasmus"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Mass Hysteria"
    *   Tag
        *   Targets
            *   ChapterUID = 741258
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Primal Scream"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Burning Wheel"
        *   SimpleTag
            *   TagName = "SUBTITLE"
            *   TagString = "Chemical Brothers Remix"
        *   SimpleTag
            *   TagName = "REMIXED_BY"
            *   TagString = "The Chemical Brothers"
    *   etc...

### File #6 : Big Beat Elite Repeat CD #3 mixed

(you can deduce it yourself as an exercise)

### File #7 : Big Beat Elite Complete CD #1
[XML version](https://matroska.org/files/tags/bigbeat-3_1.xml)

*   Tags
    *   Tag
        *   Targets (_tagging the volume information, no target since it covers the whole file_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Big Beat Elite"
        *   SimpleTag (_the number of CD sets in the collection_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "LABEL"
            *   TagString = "Lacerba"
    *   Tag
        *   Targets (_tagging the CD information, no target since it covers the whole file_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "VOLUME"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = _"Big Beat Elite Complete"_
        *   SimpleTag (_the number of the set in the collection_)
            *   TagName = "PART_NUMBER"
            *   TagString = _"3"_
        *   SimpleTag (_the number of CDs in the set_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "3"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1998"
    *   Tag
        *   Targets
            *   _TargetTypeValue = 50_
            *   _TargetType = "ALBUM"_
        *   SimpleTag (_the number of the CD in the set_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag (_the number of tracks on the CD_)
            *   TagName = _"TOTAL_PARTS"_
            *   TagString = "10"
    *   Tag
        *   Targets (_the first track of the CD_)
            *   ChapterUID = 369852
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "The Herbaliser"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Wall Crawling Giant Insect Breaks"
    *   Tag
        *   Targets
            *   ChapterUID = 741258
            *   _TargetTypeValue = 30_
            *   _TargetType = "TRACK"_
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
        *   SimpleTag
            *   TagName = "ARTIST"
            *   TagString = "Psychedelia Smith"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Different Strokes"
    *   etc...

### File #8 : Big Beat Elite Complete CD #2

(you can deduce it yourself as an exercise)

### File #9 : Big Beat Elite Complete CD #3 mixed

(you can deduce it yourself as an exercise)
