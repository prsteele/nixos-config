final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    monokai = prev.callPackage ../modules/tmux-monokai { };
  };
}
