{ stdenv, fetchurl, cmake, pkgconfig, boost, protobuf, gdal freeimage,  openal, 
  xorg_sys_opengl, strategoPackages.sdf, tbb, ogre, tinyxml_2, graphviz,
  libtar, glxinfo, hdf5, libav, libusb, bullet, libxslt, gts, ruby, ign_math2,
  
  # these deps are hidden; cmake doesn't catch them
  sdformat, curl, tinyxml, x11 }:

let
  version = "7.0.0"
in stdenv.mkDerivation rec {
  name = "gazebo-${version}";
  version = "0.0.1";
  src = ./.;
  rootDeps = with pkgs; [
    cmake pkgconfig boost protobuf
    gdal freeimage
    openal
    xorg_sys_opengl
    strategoPackages.sdf
    tbb
    ogre
    tinyxml_2
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
    ign_math2
    sdformat

    # hidden deps
    curl
    tinyxml
    x11
  ];

  pythonDeps = with pkgs.python27Packages; [
    pyopengl
  ];

  buildInputs = rootDeps ++ pythonDeps ++ pkgs.lib.optional stdenv.isLinux pkgs.utillinux;
}