{ stdenv, fetchurl, cmake, pkgconfig, boost, protobuf, gdal, freeimage,  openal,
  xorg_sys_opengl, tbb, ogre, tinyxml-2, graphviz,
  libtar, glxinfo, hdf5, libav, libusb, bullet, libxslt, gts, ruby, ignition-math2,
  pythonPackages, utillinux,

  # these deps are hidden; cmake doesn't catch them
  sdformat, curl, tinyxml, kde4, x11 }:

let
  version = "7.0.0";
in stdenv.mkDerivation rec {
  name = "gazebo-${version}";

  src = fetchurl {
    url = "http://osrf-distributions.s3.amazonaws.com/gazebo/releases/${name}.tar.bz2";
    sha256 = "127q2g93kvmak2b6vhl13xzg56h09v14s4pki8wv7aqjv0c3whbl";
  };

  enableParallelBuilding = true; # gazebo needs this so bad
  cmakeFlags = [
    "-DENABLE_TESTS_COMPILATION=False"
  ];

#  configurePhase = ''
#    cmake -DENABLE_TESTS_COMPILATION=False
#  '';

  buildInputs = [
    cmake pkgconfig boost protobuf
    gdal freeimage
    openal
    xorg_sys_opengl
    tbb
    ogre
    tinyxml-2
    graphviz
    libtar
    glxinfo
    hdf5
    libav
    libusb
    bullet
    libxslt
    gts
    ruby
    ignition-math2
    sdformat
    pythonPackages.pyopengl

    # hidden deps
    curl
    tinyxml
    x11
    kde4.qt4
  ] ++ stdenv.lib.optional stdenv.isLinux utillinux;

}
