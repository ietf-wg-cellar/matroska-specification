# minver Value

All the new elements have a `minver` attribute of "5".
If they are present in a Matroska file the EBML Header **MUST** have a `DocTypeReadVersion` of 5 or more.


# Audio Emphasis

id / type / default:
: 0x52F1 / uinteger / 0

path:
: `\Segment\Tracks\TrackEntry\Audio\Emphasis`

minOccurs / maxOccurs:
: 1 / 1

minver:
: 5

definition:
: Audio emphasis applied on audio samples. The player **MUST** apply the inverse emphasis to get the proper audio samples.

restrictions:
: See (#EmphasisValues).

stream copy:
: True ([@!RFC9559, section 8])

|value|label|definition|
|:---|:---|:---|
|`0` |No emphasis |  |
|`1` |CD audio |First order filter with zero point at 50 microseconds and a pole at 15 microseconds. Also found on DVD Audio and MPEG audio.  |
|`2` |reserved |  |
|`3` |CCIT J.17 |Defined in [@!ITU-J.17].  |
|`4` |FM 50 |FM Radio in Europe. RC Filter with a time constant of 50 microseconds.  |
|`5` |FM 75 |FM Radio in the USA. RC Filter with a time constant of 75 microseconds.  |
|`10` |Phono RIAA |Phono filter with time constants of t1=3180, t2=318 and t3=75 microseconds. [@!NAB1964]  |
|`11` |Phono IEC N78 |Phono filter with time constants of t1=3180, t2=450 and t3=50 microseconds.  |
|`12` |Phono TELDEC |Phono filter with time constants of t1=3180, t2=318 and t3=50 microseconds.  |
|`13` |Phono EMI |Phono filter with time constants of t1=2500, t2=500 and t3=70 microseconds.  |
|`14` |Phono Columbia LP |Phono filter with time constants of t1=1590, t2=318 and t3=100 microseconds.  |
|`15` |Phono LONDON |Phono filter with time constants of t1=1590, t2=318 and t3=50 microseconds.  |
|`16` |Phono NARTB |Phono filter with time constants of t1=3180, t2=318 and t3=100 microseconds.  |
Table: Emphasis Values{#EmphasisValues}


# Chapter Skipping

id / type:
: 0x4588 / uinteger

path:
: `\Segment\Chapters\EditionEntry\+ChapterAtom\ChapterSkipType`

maxOccurs:
: 1

definition:
: Indicates what type of content the `ChapterAtom` contains and might be skipped.
It can be used to automatically skip content based on the type.
If a `ChapterAtom` is inside a `ChapterAtom` that has a `ChapterSkipType` set, it
**MUST NOT** have a `ChapterSkipType` or have a `ChapterSkipType` with the same value as it's parent `ChapterAtom`.
If the `ChapterAtom` doesn't contain a `ChapterTimeEnd`, the value of the `ChapterSkipType` is only valid
until the next `ChapterAtom` with a `ChapterSkipType` value or the end of the file.


restrictions:
: See (#ChapterSkipTypeValues).

|value|label|definition|
|:---|:---|:---|
|`0` |No Skipping |Content which should not be skipped.  |
|`1` |Opening Credits |Credits usually found at the beginning of the content.  |
|`2` |End Credits |Credits usually found at the end of the content.  |
|`3` |Recap |Recap of previous episodes of the content, usually found around the beginning.  |
|`4` |Next Preview |Preview of the next episode of the content, usually found around the end. It may contain spoilers the user wants to avoid.  |
|`5` |Preview |Preview of the current episode of the content, usually found around the beginning. It may contain spoilers the user want to avoid.  |
|`6` |Advertisement |Advertisement within the content.  |
Table: ChapterSkipType Values{#ChapterSkipTypeValues}

# Chapter Edition Display

## EditionDisplay Element

id / type:
: 0x4520 / master

path:
: `\Segment\Chapters\EditionEntry\EditionDisplay`

minver:
: 5

definition:
: Contains a possible string to use for the edition display for the given languages.


## EditionString Element

id / type:
: 0x4521 / utf-8

path:
: `\Segment\Chapters\EditionEntry\EditionDisplay\EditionString`

minOccurs / maxOccurs:
: 1 / 1

minver:
: 5

definition:
: Contains the string to use as the edition name.


## EditionLanguageIETF Element

id / type:
: 0x45E4 / string

path:
: `\Segment\Chapters\EditionEntry\EditionDisplay\EditionLanguageIETF`

minver:
: 5

definition:
: One language corresponding to the EditionString,
in the form defined in [@!RFC5646]; see [@!RFC9559, section 12] on language codes.

# Zstandard Compression

This document adds value "4" to the `ContentCompAlgo` element ([@RFC9559, section 5.1.4.1.31.6]).
It corresponds to the Zstandard (zstd) compression algorithm [@!RFC8878].

When the Zstandard compression algorithm is used, the `ContentCompSettings` element ([@RFC9559, section 5.1.4.1.31.7])
**MAY** optionally contain a dictionary to improve compression efficiency.

