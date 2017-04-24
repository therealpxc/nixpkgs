{ stdenv, coreutils, gnused, bash, tmux, fetchFromGitHub, wemuxEtcPrefix ? null, wemuxBinName ? "wemux" }:

let
  osConfigPath = if stdenv.isDarwin then "/usr/local/etc" else "/etc";
  configPath = if wemuxEtcPrefix != null then wemuxEtcPrefix else osConfigPath;
in

stdenv.mkDerivation rec {
  name = "${wemuxBinName}-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "zolrath";
    repo = "wemux";
    rev = "v${version}";
    sha256 = "10n3nvbsp4s9yjjnir2n63hn2d42ndlicshk77nbjjpgygwidhd6";
  };

  buildInputs = [ coreutils gnused bash tmux ];

  patchPhase = ''
    patchShebangs wemux
    substituteInPlace man/wemux.1 \
      --replace "/usr/local/etc" '${configPath}' \
      --replace "wemux" '${wemuxBinName}'
    substituteInPlace wemux \
      --replace '`whoami`' '`${coreutils}/bin/whoami`' \
      --replace '`wemux ' '`'"$out/bin/${wemuxBinName} " \
      --replace '$(wemux ' '$('"$out/bin/${wemuxBinName} " \
      --replace '<(wemux ' '<('"$out/bin/${wemuxBinName} " \
      --replace '>(wemux ' '>('"$out/bin/${wemuxBinName} " \
      --replace '="tmux' '="${tmux}/bin/tmux' \
      --replace "| cut" "| ${coreutils}/bin/cut" \
      --replace "| sed" "| ${gnused}/bin/sed" \
      --replace "/usr/local/etc" '${configPath}'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1 $out/share/doc/${wemuxBinName}
    gzip -c man/wemux.1 > $out/share/man/man1/${wemuxBinName}.1.gz
    cp wemux $out/bin/${wemuxBinName}
    cp wemux.conf.example $out/share/doc/${wemuxBinName}/wemux.conf
  '';
}
