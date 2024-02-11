{ ... }:
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

      theme = "ys";
    };

    initExtra = ''
      unsetopt BEEP
      set bell-style none

      if [ -f ~/.zshrc-ad-hoc ]; then
          . ~/.zshrc-ad-hoc
      fi
    '';
  };
}
