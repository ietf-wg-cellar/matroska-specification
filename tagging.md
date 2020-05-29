---
title: Tagging
---

# Tagging

When a Tag is nested within another Tag, the nested Tag becomes an attribute of the base tag. For instance, if you wanted to store the dates that a singer used certain addresses for, that singer being the lead singer for a track that included multiple bands simultaneously, then your tag tree would look something like this:

* Targets
  * TrackUID
* BAND
  * LEADPERFORMER
    * ADDRESS
      * DATE
      * DATEEND
    * ADDRESS
      * DATE

In this way, it becomes possible to store any Tag as attributes of another tag.

Multiple items SHOULD never be stored as a list in a single TagString. If there is more than one tag of a certain type to be stored, then more than one SimpleTag SHOULD be used.

For authoring Tags outside of EBML, the [following XML syntax is proposed](https://www.matroska.org/files/tags/matroskatags.dtd) [used in mkvmerge](https://mkvtoolnix.download/doc/mkvmerge.html#mkvmerge.tags). Binary data SHOULD be stored using BASE64 encoding if it is being stored at authoring time.

## Why official tags matter

There is a debate between people who think all tags SHOULD be free and those who think all tags SHOULD be strict. If you look at this page you will realize we are in between.

Advanced-users application might let you put any tag in your file. But for the rest of the applications, they usually give you a basic list of tags you can use. Both have their needs. But it's usually a bad idea to use custom/exotic tags because you will probably be the only person to use this information even though everyone else could benefit from it. So hopefully when someone wants to put information in one's file, they will find an official one that fit them and hopefully use it ! If it's not in the list, this person can contact us any time for addition of such a missing tag. But it doesn't mean it will be accepted... Matroska files are not meant the become a whole database of people who made costumes for a film. A website would be better for that... It's hard to define what SHOULD be in and what doesn't make sense in a file. So we'll treat each request carefully.

We also need an official list simply for developers to be able to display relevant information in their own design (if they choose to support a list of meta-information they SHOULD know which tag has the wanted meaning so that other apps could understand the same meaning).

## Tag translations

To be able to save tags from other systems to Matroska we need to translate them to our system. There is a translation table [on our site](othertagsystems/comparetable.html).

## Tag Formatting

* The TagName SHOULD always be written in all capital letters and contain no space.
* The fields with dates SHOULD have the following format: YYYY-MM-DD hh:mm:ss.mss YYYY = Year, MM = Month, DD = Days, HH = Hours, mm = Minutes, ss = Seconds, mss = Milliseconds. To store less accuracy, you remove items starting from the right. To store only the year, you would use, "2004". To store a specific day such as May 1st, 2003, you would use "2003-05-01".
* Fields that require a Float SHOULD use the "." mark instead of the "," mark. To display it differently for another local, applications SHOULD support auto replacement on display. Also, a thousandths separator SHOULD NOT be used.
* For currency amounts, there SHOULD only be a numeric value in the Tag. Only numbers, no letters or symbols other than ".". For instance, you would store "15.59" instead of "$15.59USD".

## Target types

The TargetType element allows tagging of different parts that are inside or outside a given file. For example in an audio file with one song you could have information about the album it comes from and even the CD set even if it's not found in the file.

For application to know what kind of information (like TITLE) relates to a certain level (CD title or track title), we also need a set of official TargetType names. For now audio and video will have different values &amp; names. That also means the same tag name can have different meanings depending on where it is (otherwise we would end up with 15 TITLE_ tags).

TargetTypeValue | Audio strings                   | Video strings             | Comment
----------------|:--------------------------------|:--------------------------|:-------
70              | COLLECTION                      | COLLECTION                | the high hierarchy consisting of many different lower items
60              | EDITION / ISSUE / VOLUME / OPUS | SEASON / SEQUEL / VOLUME  | a list of lower levels grouped together
50              | ALBUM / OPERA / CONCERT         | MOVIE / EPISODE / CONCERT | the most common grouping level of music and video (equals to an episode for TV series)
40              | PART / SESSION                  | PART / SESSION            | when an album or episode has different logical parts
30              | TRACK / SONG                    | CHAPTER                   | the common parts of an album or a movie
20              | SUBTRACK / PART / MOVEMENT      | SCENE                     | corresponds to parts of a track for audio (like a movement)
10              | -                               | SHOT                      | the lowest hierarchy found in music or movies

An upper level value tag applies to the lower level. That means if a CD has the same artist for all tracks, you just need to set the ARTIST tag at level 50 (ALBUM) and not to each TRACK (but you can). That also means that if some parts of the CD have no known ARTIST the value MUST be set to nothing (a void string "").

When a level doesn't exist it MUST NOT be specified in the files, so that the TOTAL_PARTS and PART_NUMBER elements match the same levels.

Here is an example of how these `organizational` tags work: If you set 10 TOTAL_PARTS to the ALBUM level (40) it means the album contains 10 lower parts. The lower part in question is the first lower level that is specified in the file. So if it's TRACK (30) then that means it contains 10 tracks. If it's MOVEMENT (20) that means it's 10 movements, etc.

## Official tags

The following is a complete list of the supported Matroska Tags. While it is possible to use Tag names that are not listed below, this is not recommended as compatibility will be compromised. If you find that there is a Tag missing that you would like to use, then please contact the Matroska team for its inclusion in the specifications before the format reaches 1.0.
