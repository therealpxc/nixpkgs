{ stdenv, fetchurl, cmake, pkgconfig, utillinux,
   protobuf, zeromq, cppzmq }:

let
  version = "1.0.1";
in
stdenv.mkDerivation rec {
  name = "ign-transport-${version}";

  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport-${version}.tar.bz2";
    sha256 = "08qyd70vlymms1g4smblags9f057zsn62xxrx29rhd4wy8prnjsq";
  };

#  configurePhase = ''
#    cmake -DCMAKE_INSTALL_PREFIX=$out .
#  '';

  buildInputs = [ cmake protobuf zeromq cppzmq pkgconfig
    utillinux # we need utillinux/e2fsprogs uuid/uuid.h
  ];

  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/math;
    description = "Math library by Ingition Robotics, created for the Gazebo project";
    license = licenses.apache2;
    maintainers = with maintainers; [ therealpxc ];
    platforms = platforms.all;
  };
}
