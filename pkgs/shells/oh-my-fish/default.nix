{ stdenv, fetchFromGitHub, findutils }:

stdenv.mkDerivation rec {
  version = "v5";
  name = "oh-my-fish-${version}";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "oh-my-fish";
    rev = "${version}";
    sha256 = "0znzswxcvdjd4v6rjdw2g3rhyh4x8a1d4rrkhmd35s181qs66r7s";
  };

  buildCommand = ''
    mkdir -p $out/share/fish
    cp -rv $src/pkg $out/share/fish/pkg
    mkdir -p $out/share/omf
    ln -s $out/share/fish/pkg $out/share/omf/pkg

    for dir in $(find $src -maxdepth 1 -type d | grep -vE "^($src|$src/pkg)\$"); do
      cp -rv $dir $out/share/omf/$(basename $dir)
    done
  '';

  pathsToLink = "/share/fish/pkg";



  meta = with stdenv.lib; {
  description     = "A framework for managing your fish configuration";
  longDescription = ''
  Oh My Fish is a framework for managing your fish configuration.
  '';
  homepage        = "https://github.com/oh-my-fish/oh-my-fish";
  license         = licenses.mit;
  platforms       = platforms.all;
  maintainers     = with maintainers; [ ];
  };
}
