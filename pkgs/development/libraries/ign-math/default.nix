{ stdenv, fetchurl, pcre, zlib, perl }:

let version = "1.0.0";
in
stdenv.mkDerivation rec {
  name = "ignition-math-${version}";

  src = fetchurl {
    #url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    url = "http://gazebosim.org/distributions/ign-math/releases/${name}.tar.bz2";
    sha256 = "5c15bbafdab35d1e0b2f9e43ea13fc665e29c19530c94c89b92a86491128b30a";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ pcre zlib ];

  postPatch = ''
    patchShebangs qpdf/fix-qdf
  '';

  preCheck = ''
    patchShebangs qtest/bin/qtest-driver
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/math;
    description = "Math library by Ingition Robotics, created for the Gazebo project";
    license = licenses.apache2;
    maintainers = with maintainers; [ pxc ];
    platforms = platforms.all;
  };
}
