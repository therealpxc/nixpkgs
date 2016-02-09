{ stdenv, fetchurl, cmake, mesa, freeglut }:

stdenv.mkDerivation rec {
  ver = "2.83.7";
  name = "bullet-${ver}";
  src = fetchurl {
    url = "https://github.com/bulletphysics/bullet3/archive/${ver}.tar.gz";
    sha256 = "00d1d8f206ee85ffd171643ac8e72f9f4e0bf6dbf3d4ac55f4495cb168b51243";
  };

  buildInputs = [ cmake mesa freeglut ];
  configurePhase = ''
    cmake -DBUILD_SHARED_LIBS=ON -DBUILD_EXTRAS=OFF -DBUILD_BULLET2_DEMOS=OFF \
          -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_UNIT_TESTS=OFF -DBUILD_BULLET3=OFF \
          -DCMAKE_INSTALL_PREFIX=$out .
  '';

  meta = {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics. 
    '';
    homepage = http://code.google.com/p/bullet/;
    license = stdenv.lib.licenses.zlib;
    maintainers = with stdenv.lib.maintainers; [ aforemny ];
  };
}
