#!/usr/bin/env bash

# MIT License

# Copyright (c) 2020 Dane Williams
# Copyright (c) 2022 Max Petretta, https://maxpetretta.com
# Copyright (c) 2024 Pat Steele

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Adopted from https://github.com/maxpetretta/tmux-monokai-pro, which
# in turn adopts https://github.com/dracula/tmux


#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

main()
{
  # set configuration option variables
  show_powerline=true
  show_flags=true
  show_left_icon=session
  show_left_icon_padding=1
  show_military=true
  timezone=""
  show_timezone=true
  show_left_sep=""
  show_right_sep=""
  show_refresh=5

  white='#fcfcfa'
  black='#2d2a2e'
  gray='#727072'
  green='#a9dc76'
  yellow='#ffd866'
  cyan='#ab9df2'

  # Handle left icon configuration
  case $show_left_icon in
    smiley)
      left_icon="☺";;
    session)
      left_icon="#S";;
    window)
      left_icon="#W";;
    hostname)
      left_icon="#H";;
    shortname)
      left_icon="#h";;
    *)
      left_icon=$show_left_icon;;
  esac

  # Handle left icon padding
  padding=""
  if [ "$show_left_icon_padding" -gt "0" ]; then
    padding="$(printf '%*s' $show_left_icon_padding)"
  fi
  left_icon="$left_icon$padding"

  # Handle powerline option
  if $show_powerline; then
    right_sep="$show_right_sep"
    left_sep="$show_left_sep"
  fi

  # Set timezone unless hidden by configuration
  if [[ -z "$timezone" ]]; then
    case $show_timezone in
      false)
        timezone="";;
      true)
        timezone="#(date +%Z)";;
    esac
  fi

  case $show_flags in
    false)
      flags=""
      current_flags="";;
    true)
      flags="#{?window_flags,#[fg=${cyan}]#{window_flags},}"
      current_flags="#{?window_flags,#[fg=${cyan}]#{window_flags},}"
  esac

  # sets refresh interval to every 5 seconds
  tmux set-option -g status-interval $show_refresh

  # set the prefix + t time format
  if $show_military; then
    tmux set-option -g clock-mode-style 24
  else
    tmux set-option -g clock-mode-style 12
  fi

  # set length
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  tmux set-option -g pane-active-border-style "fg=${green}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  # Status left
  if $show_powerline; then
    tmux set-option -g status-left "#[fg=${green},bg=${black}]#[bg=${green},fg=${black},bold] ${left_icon} #[fg=${green},bg=${gray}]${left_sep}"
    powerbg=${gray}
  else
    tmux set-option -g status-left "#[bg=${green},fg=${black},bold] ${left_icon} "
  fi

  # Status right
  tmux set-option -g status-right ""

  # Show the time
  IFS=' ' read -r -a colors <<< "green gray"
  script="%a %d/%m %R ${timezone} "
  tmux set-option -ga status-right "#[fg=${!colors[0]},bg=${powerbg},nobold,nounderscore,noitalics]${right_sep}#[fg=${!colors[1]},bg=${!colors[0]}] $script "

  # Window option
  if $show_powerline; then
    tmux set-window-option -g window-status-current-format "#[bg=${white},fg=${gray}]${left_sep} #[fg=${black},bg=${white}]#I #W${current_flags} #[bg=${gray},fg=${white}]${left_sep}"
  else
    tmux set-window-option -g window-status-current-format "#[fg=${gray},bg=${white}] #I #W${current_flags} "
  fi

  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W${flags}"
  tmux set-window-option -g window-status-activity-style "bold"
  tmux set-window-option -g window-status-bell-style "bold"
}

# run main function
main
