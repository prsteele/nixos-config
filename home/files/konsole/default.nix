/* Configure _most_ of Konsole.

  Unfortunately, ~/.config/konsolerc is written to by Konsole itself, so
  it's difficult to manage with HM. Remember to

  1. Set the default profile to prsteele
  2. Remove toolbars

 */
{ config, ... }:
let
  konsoleDir = "${config.xdg.dataHome}/konsole/";
in
{
  home.file.${konsoleDir + "prsteele.profile"} = {
    source = ./prsteele.profile;
  };

  home.file.${konsoleDir + "monokai.colorscheme"} = {
    source = ./monokai.colorscheme;
  };
}
