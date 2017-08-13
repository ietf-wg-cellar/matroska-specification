---
---

# Menu Specifications

## Introduction

This document is a _draft of the Menu system_ that will be the default one in Matroska. As it will just be composed of a Control Track, it will be seen as a "codec" and could be replaced later by something else if needed.

A menu is like what you see on DVDs, when you have some screens to select the audio format, subtitles or scene selection.

## Requirements

What we'll try to have is a system that can do almost everything done on a DVD, or more, or better, or drop the unused features if necessary.

As the name suggests, a Control Track is a track that can control the playback of the file and/or all the playback features. To make it as simple as possible for players, the Control Track will just give orders to the player and get the actions associated with the highlights/hotspots.

### Highlights/Hotspots

A highlight is basically a rectangle/key associated with an action UID. When that rectangle/key is activated, the player send the UID of the action to the Control Track handler (codec). The fact that it can also be a key means that even for audio only files, a keyboard shortcut or button panel could be used for menus. But in that case, the hotspot will have to be associated with a name to display.

So this highlight is sent from the Control Track to the Player. Then the player has to handle that highlight until it's deactivated (see Playback Features)

The highlight contains a UID of the action, a displayable name (UTF-8), an associated key (list of keys to be defined, probably up/down/left/right/select), a screen position/range and an image to display. The image will be displayed either when the user place the mouse over the rectangle (or any other shape), or when an option of the screen is selected (not activated). There could be a second image used when the option is activated. And there could be a third image that can serve as background. This way you could have a still image (like in some DVDs) for the menu and behind that image blank video (small bitrate).

When a highlight is activated by the user, the player has to send the UID of the action to the Control Track. Then the Control Track codec will handle the action and possibly give new orders to the player.

The format used for storing images SHOULD be extensible. For the moment we'll use PNG and BMP, both with alpha channel.

### Playback features

All the following features will be sent from the Control Track to the Player :

*   Jump to chapter (UID, prev, next, number)
*   Disable all tracks of a kind (audio, video, subtitle)
*   Enable track UID (the kind doesn't matter)
*   Define/Disable a highlight
*   Enable/Disable jumping
*   Enable/Disable track selection of a kind
*   Select Edition ID (see chapters)
*   Pause playback
*   Stop playback
*   Enable/Disable a Chapter UID
*   Hide/Unhide a Chapter UID

All the actions will be written in a normal Matroska track, with a timecode. A "Menu Frame" SHOULD be able to contain more that one action/highlight for a given timecode. (to be determined, EBML format structure)

### Player requirements

Some players might not support the control track. That mean they will play the active/looped parts as part of the data. So I suggest putting the active/looped parts of a movie at the end of a movie. When a Menu-aware player encounter the default Control Track of a Matroska file, the first order SHOULD be to jump at the start of the active/looped part of the movie.

## Working Graph

```
Matroska Source file -> Control Track <-> Player.
                     -> other tracks   -> rendered
```

## Ideas

```
!!!! KNOW Where the main/audio/subs menu starts wherever we are (use chapters) !!!!

!!!! Keep in mind the state of the selected tracks of each kind (more than 1 for each possible) !!!!
!!!! Order of blending !!!!
!!!! What if a command is not supported by the player ? !!!!
!!!! Track selection issue, only applies when 'quitting' the menu (but still possible to change live too) !!!!
!!!! Allow to hide (not render) some parts of a movie for certain editions !!!!
!!!! Get the parental level of the player (can be changed live) !!!!
```

## Data Structure

As a Matroska side project, the obvious choice for storing binary data is EBML.
