{ stdenv, fetchurl, cmake, boost, ruby_1_9, ign_math2, tinyxml }:

let
  version = "4.0.0";
  ruby = ruby_1_9;
in
stdenv.mkDerivation rec {
  name = "sdformat-${version}";
  src = fetchurl {
    url = "http://osrf-distributions.s3.amazonaws.com/sdformat/releases/${name}.tar.bz2";
    sha256 = "b0f94bb40b0d83e35ff250a7916fdfd6df5cdc1e60c47bc53dd2da5e2378163e";
  };

  buildInputs = [
    cmake boost ruby ign_math2 tinyxml
  ];

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out .
  '';
}
