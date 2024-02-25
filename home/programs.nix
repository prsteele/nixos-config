{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Patrick Steele";
    userEmail = "prsteele@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # This will only apply to standalone installs; when using HM via
  # NixOS, HM is used as a submodule, and HM will decline to install
  # itself.
  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    prefix = "C-u";
    baseIndex = 1;
    clock24 = true;
    historyLimit = 50000;
    keyMode = "emacs";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      monokai
    ];

    extraConfig = ''
      # Reload configuration
      bind -N "Reload tmux configuration" R source-file "~/.config/tmux/tmux.conf" \; display-message "reloaded configuration"

      # Swap to the last window
      bind u last-window

      # Use the main-horizontal layout by default, and select them main pane when creating or destroying panes
      set-hook -g after-split-window "select-layout main-horizontal; select-pane -t 1"
      set-hook -g pane-exited "select-layout main-horizontal; select-pane -t 1"

      # Add a new pane as the main pane
      bind-key -N "Add a new pane, and rotate it to be active" ";" split-window -h -t -1 -c "#{pane_current_path}" \; rotate-window -D

      # Open new windows in the directory of the current pane
      bind-key -N "Create a new window" "c" new-window -c "#{pane_current_path}"

      # Instead of moving between panes, just rotate them
      bind-key -N "Rotate between panes" -r "o" rotate-window -U
      bind-key -N "Rotate between panes" -r "i" rotate-window -D
    '';
  };

  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
    };

    oh-my-zsh = {
      enable = true;

      plugins = [
        "z"
        "git"
      ];

      theme = "psteele";

      custom = "${config.xdg.configHome}/oh-my-zsh-custom/";
    };

    initExtra = ''
      unsetopt BEEP
      set bell-style none

      if [ -f ~/.zshrc-ad-hoc ]; then
          . ~/.zshrc-ad-hoc
      fi
    '';

    sessionVariables = {
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
    };

    shellAliases = {
      gg = "git -P grep";
    };
  };
}
