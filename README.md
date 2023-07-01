# Official EmoTracker pack for the Golden Sun: The Lost Age Randomizer

This tracker for the [Golden Sun: The Lost Age randomiser](https://gs2randomiser.com) is intended for use with the [EmoTracker](https://emotracker.net) software by EmoSaru.

## Requirements

[EmoTracker](https://emotracker.net/download/) is required to use this tracker.

This tracker also includes auto-tracking functionality, which requires BizHawk/EmuHawk v2.4 or lower due to dependency on ConnectorLib for GBA auto-tracking.

## Installation

The tracker pack is currently not available through EmoTracker's package manager, and thus needs to be installed manually using the following steps:

1. Clone this repository or download it as a ZIP file and it in the `%USERPROFILE%\Documents\EmoTracker\packs` directory.
2. If EmoTracker was open during the first step: close and restart EmoTracker.
3. Check to make sure that the tracker pack appears under `Settings -> Installed Packages -> Other`

## Usage

To use this tracker pack, open EmoTracker and select this pack under `Settings -> Installed Packages -> Other`.
Refer to the [EmoTracker Discord server](https://emotracker.net/community/) for information on how to set up auto-tracking.

The pack contains several configuration options for the different randomiser settings. These can be found by clicking the gear icon at the top of the item display.
The settings are as follows:

- **Mode:** The item shuffle mode. Cycles through "Key items only", "Chests & tablets" and "All items".
- **Require \.\.\.:** These settings corrspond to the logic skips/glitches settings in the randomiser.
- **Hide yellows checks:** This prevents locations that are accessible through glitches from showing up on the map tracker.
- **Enable item captures:** This makes locations that are visible but not accessible show up on the map tracker. To be used with the "Show items outside chest" randomiser setting.
- **Enable boss logic requirements:** This makes boss-locked locations inaccessible on the map tracker if the number of tracked Djinn does not meet the logical requirement.
- **Only show major locations:** Only shows only major item locations on the map tracker. To be used with the "Major/Minor" item shuffle modes.

When using the randomiser setting that makes the Lemurian Ship available from the start, make sure to mark the Lemurian Ship as obtained in the "Progression" section of the tracker.
This will be done automatically when using auto-tracking.

## Support

For general EmoTracker support and/or issues, please refer to the [EmoTracker Discord server](https://emotracker.net/community/).

For bugs and issues specific to this tracker pack, you can either open an issue in the [issue tracker](https://github.com/Karanum/gstla_emotracker_pack/issues)
or post it in the `#gs2-rando-discussion` channel of the [Golden Sun Speedrunning Discord](https://discord.com/invite/QWwxrmN).

**Note:** The latest version of ConnectorLib can randomly cause the auto-tracker script to get stuck on an error. 
This can be solved by reloading the tracker (double arrows in the top-right of EmoTracker) and restarting the auto-tracker script.

## Contribution

Everyone is free to contribute to this repository by making a pull request with their changes. As long as the changes solve an issue or improve the tracker pack in some way, 
they will generally be accepted. I may decline the pull request if I believe the changes would be better as a separate version of the tracker pack.

I aim to look at pull requests as soon as possible. If a pull request has been open for more than 7 days without response it likely slipped my mind, 
so please notify me by commenting on the pull request or through the [Golden Sun Speedrunning Discord](https://discord.com/invite/QWwxrmN).

## Acknowledgments

This tracker pack is heavily based on the original Golden Sun: The Lost Age tracker by MarvinXLII.
While the original is no longer publicly available, a modified version can be found at https://github.com/Karanum/gs2-emotracker-fork.
