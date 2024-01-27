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

  programs.tmux = {
    enable = true;
    prefix = "C-u";
  };

  programs.zsh = {
    enable = true;

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

      if [ -f ~/.zsh-ad-hoc ]; then
          . ~/.zsh-ad-hoc
      fi
    '';
  };
}
