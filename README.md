# Dracula for [tmux](https://github.com/tmux/tmux/wiki)

> A dark theme for [tmux](https://github.com/tmux/tmux/wiki)

![Screenshot](./screenshot.png)

## Install

All instructions can be found at [draculatheme.com/tmux](https://draculatheme.com/tmux).

## Configuration

Configuration and options can be found at [draculatheme.com/tmux](https://draculatheme.com/tmux).

## Features

* Support for powerline
* Day, date, time, timezone
* Current location based on network with temperature and forecast icon (if available)
* Network connection status and SSID
* Battery percentage and AC power connection status
* CPU usage
* Color code based on if prefix is active or not
* List of windows with current window highlighted
* When prefix is enabled smiley face turns from green to yellow
* When charging, 'AC' is displayed
* If forecast information is available, a ☀, ☁, ☂, or ❄ unicode character corresponding with the forecast is displayed alongside the temperature

## Features added in this fork:
 
 * Adds an option to enable Kubernetes Context and Namespace display on bottom right bar, ported from Jon Mosco - https://github.com/jonmosco/kube-tmux 
  ** @dracula-kubeconfig
  * Please note that this is licensed differently than Dracula.
 * Adds an option to also show battery status of Apple Airpods/Airpods Pro/Beats (Case, Left, and Right) to the battery/AC section. (macOS only)
  ** @dracula-airpods
 * Updated weather script ported from Jezen Thomas <jezen@jezenthomas.com> and found in github.com/kylepeeler/tmux-dracula is available for use.
  ** Want the old one? Go get it and replace in in your own github.

## Compatibility

Compatible with macOS and Linux. Tested on tmux 3.0a


## Team

This theme is maintained by the following person(s) and a bunch of [awesome contributors](https://github.com/dracula/tmux/graphs/contributors).

[![Dane Williams](https://avatars3.githubusercontent.com/u/22798229?v=4&s=70)](https://github.com/danerwilliams) |
--- |
[Dane Williams](https://github.com/danerwilliams) |

## License

[MIT License](./LICENSE)
