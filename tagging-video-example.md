---
---

# Video Tags Example


*   [Introduction](#introduction)
*   [Basic movie](#basic-movie)
*   [One file with all DVDs](#whole)
*   [One file per DVD](#dvd)
*   [One file per episode](#episode)
*   [Season trailer](#trailer)

## Introduction

Video content usually doesn't have tags in the file. But that doesn't mean it's a good thing. Here are some real-life examples where it makes sense to have tags. As for [audio]({{site.baseurl}}/tagging-audio-example.html) you can have all video parts of a bigger ensemble in the same file or in smaller files.

The XML Tag files matching [mkvmerge's DTD format](https://matroska.org/files/tags/matroskatags.dtd) for all the examples on this page can be found in a [zip file](https://matroska.org/files/tags/videotags.zip).

## Basic movie

Here is a very basic example of how you would add the title, director, date of release and comment about a movie on one DVD ([XML version](https://matroska.org/files/tags/dune.xml)).

*   Tags
    *   Tag (_about the movie_)
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Dune"
        *   SimpleTag
            *   TagName = "DIRECTOR"
            *   TagString = "David Lynch"
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1984"
        *   SimpleTag
            *   TagName = "COMMENT"
            *   TagString = "One of the best sci-fi movies."

## Bigger example

Let's consider [the Simpsons DVDs](http://www2.foxstore.com/detail.html?item=361&u=987698787). You have a set of DVDs, each containing a few episodes of a whole season. The episodes would be spanned as follows :

*   **Season 1**
    *   **DVD #1** (Chapter UID = 98)
        *   **Episode 1** (Chapter UID = 123)
            *   Intro (Chapter UID = 963)
            *   Episode content (Chapter UID = 852)
            *   Credits (Chapter UID = 741)
        *   **Episode 2** (Chapter UID = 234)
            *   Intro (Chapter UID = 159)
            *   Episode content (Chapter UID = 267)
            *   Credits (Chapter UID = 348)
        *   **Episode 3** (Chapter UID = 345)
            *   **Intro**
            *   **Episode content**
            *   **Credits**
        *   **Episode 4** (Chapter UID = 456)
            *   **Intro**
            *   **Episode content**
            *   **Credits**
    *   **DVD #2** (Chapter UID = 87)
        *   **Episode 5** (Chapter UID = 567)
            *   **Intro**
            *   **Episode content**
            *   **Credits**
        *   **Episode 6** (Chapter UID = 678)
            *   **Intro**
            *   **Episode content**
            *   **Credits**
        *   **Episode 7** (Chapter UID = 789)
            *   **Intro**
            *   **Episode content**
            *   **Credits**
        *   **Episode 8** (Chapter UID = 890)
            *   **Intro**
            *   **Episode content**
            *   **Credits**

## One file with all DVDs

In this case the file contains one continuous video track with all episodes one after the other. Chapters are used to virtually split the content in many parts, ie the DVDs, the episodes and chapters. A good ripping application would rip the DVDs with the same structure as above as nested chapters.

Now let's see how a basic tagging of this file would work ([XML version](https://matroska.org/files/tags/simpsons-s01.xml)) :

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 123
            *   _TargetTypeValue = 50_
            *   _TargetType = "EPISODE"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons family"
        *   SimpleTag (_the number of the episode in this DVD_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
    *   Tag (_about a part of the episode_)
        *   Targets (_the intro is the same for episode 1 & episode 2, so we target both chapters_)
            *   ChapterUID = 963
            *   ChapterUID = 159
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag (_no need for a PART_NUMBER for this, but you can have one_)
            *   TagName = "TITLE"
            *   TagString = "first intro ever"
    *   Tag (_about a part of the episode_)
        *   Targets
            *   ChapterUID = 852
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "episode 1 content"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 234
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons 2nd round"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 345
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Homer is lazy"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "3"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 456
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bart is naughty"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "4"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 567
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lisa goes to school"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = _"5"_
    *   etc...

## One file per DVD

Now let's split this first season file in 2 pieces (episode 1-4 and 5-8). The big difference is that the SEASON info are repeated in each files :

#### DVD #1 / File #1 ([XML version](https://matroska.org/files/tags/simpsons-s01_14.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 123
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons family"
        *   SimpleTag (_the number of the episode in this file_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
    *   Tag (_about a part of the episode_)
        *   Targets (_the intro is the same for episode 1 & episode 2, so we target both chapters_)
            *   ChapterUID = 963
            *   ChapterUID = 159
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag (_no need for a PART_NUMBER for this, but you can have one_)
            *   TagName = "TITLE"
            *   TagString = "first intro ever"
    *   Tag (_about a part of the episode_)
        *   Targets
            *   ChapterUID = 852
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "episode 1 content"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 234
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons 2nd round"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "2"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 345
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Homer is lazy"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "3"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 456
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Bart is naughty"
        *   SimpleTag
            *   TagName = _"PART_NUMBER"_
            *   TagString = "4"

#### DVD #2 / File #2 ([XML version](https://matroska.org/files/tags/simpsons-s01_58.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 567
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lisa goes to school"
        *   SimpleTag (_episode one of this season_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "5"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 678
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Marge gets pregnant"
        *   SimpleTag (_episode one of this season_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "6"
    *   etc...

## One file per episode

In this case we have 8 files, one for each episode.

#### Episode 1 / File #1 ([XML version](https://matroska.org/files/tags/simpsons-s01e01.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about an episode_)
        *   Targets (_as always, no need to specify a target at it spans the whole file/segment, but you can_)
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons family"
        *   SimpleTag (_the number of the episode in this DVD_)
            *   TagName = _"PART_NUMBER"_
            *   TagString = "1"
    *   Tag (_about a part of the episode_)
        *   Targets (_here the chapter target is needed_)
            *   ChapterUID = 963
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag (_no need for a PART_NUMBER for this, but you can have one_)
            *   TagName = "TITLE"
            *   TagString = "first intro ever"
    *   Tag (_about a part of the episode_)
        *   Targets
            *   ChapterUID = 852
            *   TargetTypeValue = 30
            *   TargetType = "CHAPTER"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "episode 1 content"

#### Episode 2 / File #2 ([XML version](https://matroska.org/files/tags/simpsons-s01e02.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about the episode_)
        *   Targets
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons 2nd round"
        *   SimpleTag
            *   TagName = "PART_NUMBER"
            *   TagString = "2"

etc...

#### Episode 5 / File #5 ([XML version](https://matroska.org/files/tags/simpsons-s01e05.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "The Simpsons"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "1989"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "1" (_the season number_)
        *   SimpleTag (_the number of episodes_)
            *   TagName = "TOTAL_PARTS"
            *   TagString = "8"
    *   Tag (_about an episode_)
        *   Targets
            *   ChapterUID = 567
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Lisa goes to school"
        *   SimpleTag (_episode one of this season_)
            *   TagName = "PART_NUMBER"
            *   TagString = "5"

etc...

## Season Trailer

This example is a little more complex as it uses tag nesting. This is the [Dexter Season 5 trailer available on YouTube](http://www.youtube.com/watch?v=CUbCMbW-BRE). It is copyrighted by [ShowTime](http://www.sho.com/). This is neither an episode (so the episode value is set to 0 as it's before the season starts) and it is not a proper element so SAMPLE is used to nest some information that would actually be used at the regular level. The sample file available with these tags merged are [available here](https://sourceforge.net/projects/matroska/files/test_files/cover_art.mkv/download).

#### Layout ([XML version](https://matroska.org/files/tags/trailer.xml))

*   Tags
    *   Tag (_about the whole show_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 70_
            *   _TargetType = "COLLECTION"_
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Dexter"
        *   SimpleTag (_the information about the copyright on this file_)
            *   TagName = "COPYRIGHT"
            *   TagString = "Showtime"
            *   SimpleTag
                *   TagName = "URL"
                *   TagString = "[http://www.sho.com/](http://www.sho.com/)"
    *   Tag (_about the season_)
        *   Targets (_no target means the whole content of the file, otherwise you can put all matching ChapterUIDs_)
            *   _TargetTypeValue = 60_
            *   _TargetType = "SEASON"_
        *   SimpleTag
            *   TagName = "DATE_RELEASE"
            *   TagString = "2010"
        *   SimpleTag (_note there is no TOTAL_PARTS of seasons as the series is not stopped_)
            *   TagName = "PART_NUMBER"
            *   TagString = "5" (_the season number_)
    *   Tag (_about the trailer_)
        *   Targets (_as always, no need to specify a target at it spans the whole file/segment, but you can_)
            *   TargetTypeValue = 50
            *   TargetType = "EPISODE"
        *   SimpleTag
            *   TagName = "TITLE"
            *   TagString = "Dexter Season 5 trailer"
        *   SimpleTag (_the information specific to the trailer aspect of the file_)
            *   TagName = "SAMPLE"
            *   SimpleTag
                *   TagName = "PART_NUMBER"
                *   TagString = "0"
            *   SimpleTag
                *   TagName = "TITLE"
                *   TagString = "Trailer"
        *   SimpleTag (_a link to the original file_)
            *   TagName = "ORIGINAL"
            *   SimpleTag
                *   TagName = "URL"
                *   TagString = "[https://www.youtube.com/results?search_query=dexter+season+5+trailer](https://www.youtube.com/results?search_query=dexter+season+5+trailer)"
