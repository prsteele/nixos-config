final: prev:
let
  emacsPackages = efinal: eprev:
    let
      mkPkg = x: efinal.callPackage x { };
    in
    {
      ace-jump-mode = mkPkg (
        { lib
        , fetchFromGitHub
        , trivialBuild
        }:
        trivialBuild {
          pname = "ace-jump-mode";
          version = "2.0";
          src = fetchFromGitHub {
            owner = "prsteele";
            repo = "ace-jump-mode";
            rev = "eb72fe2d607fc5620e3a6e76d88601a78ca391d8";
            hash = "sha256-SJoUowEF93PtBv9KZX4fcxCvn1hogADNF9rhJ+YK3zg=";
          };
          meta = {
            description = "Fast cursor jumping";
            homepage = "github.com/prsteele/ace-jump-mode";
            license = lib.licenses.gpl3Plus;
          };
        }
      );

      lean4-mode = mkPkg (
        { lib
        , fetchFromGitHub
        , trivialBuild
        , lsp-mode
        , magit-section
        }:
        trivialBuild {
          pname = "lean4-eri";
          version = "0.1";
          src = fetchFromGitHub {
            owner = "leanprover-community";
            repo = "lean4-mode";
            rev = "1388f9d1429e38a39ab913c6daae55f6ce799479";
            hash = "sha256-6XFcyqSTx1CwNWqQvIc25cuQMwh3YXnbgr5cDiOCxBk=";
          };

          packageRequires = [
            lsp-mode
            magit-section
          ];

          meta = {
            description = "Lean4 mode";
            homepage = "github.com/leanprover-community/lean4-mode";
            license = lib.licenses.asl20;
          };
        }
      );
    };
in
{
  emacsPackagesFor = emacs: (prev.emacsPackagesFor emacs).overrideScope emacsPackages;
}
