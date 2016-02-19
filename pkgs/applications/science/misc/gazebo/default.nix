{ stdenv, fetchurl, cmake, pkgconfig, boost, protobuf, freeimage
  , xorg_sys_opengl, tbb, ogre, tinyxml-2
  , libtar, glxinfo,  libusb, libxslt, ruby, ignition-math2
  , pythonPackages, utillinux

  # these deps are hidden; cmake doesn't catch them
  , sdformat, curl, tinyxml, kde4, x11
  , ignition-transport, withIgnitionTransport ? true
  , libav, withLibAvSupport ? true
  , openal, withAudioSupport ? false
  , withQuickBuild ? false, withHeadless ? false, withLowMemorySupport ? false
  , doxygen, withDocs ? true
  , bullet, withBulletEngineSupport ? false
  , graphviz, withModelEditorSchematicView ? true # graphviz needed for this view
  , gdal, withDigitalElevationTerrainsSupport ? true
  , gts, withConstructiveSolidGeometrySupport ? true
  , hdf5, withHdf5Support ? true
}: with stdenv.lib;

let
  version = "7.0.0";
in stdenv.mkDerivation rec {
  name = "gazebo-${version}";

  src = fetchurl {
    url = "http://osrf-distributions.s3.amazonaws.com/gazebo/releases/${name}.tar.bz2";
    sha256 = "127q2g93kvmak2b6vhl13xzg56h09v14s4pki8wv7aqjv0c3whbl";
  };

  enableParallelBuilding = true; # gazebo needs this so bad
  cmakeFlags = []
    ++ optional withQuickBuild [ "-DENABLE_TESTS_COMPILATION=False" ]
    ++ optional withLowMemorySupport [ "-DUSE_LOW_MEMORY_TESTS=True" ]
    ++ optional withHeadless [ "-DENABLE_SCREEN_TESTS=False" ];

  buildInputs = [
    cmake pkgconfig boost protobuf
    freeimage
    xorg_sys_opengl
    tbb
    ogre
    ogrepaged   # needed in PX4
    tinyxml-2
    libtar
    glxinfo
    libusb
    libxslt
    ignition-math2
    sdformat
    pythonPackages.pyopengl

    # TODO: add these hidden deps to cmake configuration & submit upstream
    curl
    tinyxml
    x11
    kde4.qt4
  ] ++ optional stdenv.isLinux utillinux # on Linux needs uuid/uuid.h
    ++ optional withDocs doxygen
    ++ optional withLibAvSupport libav  #TODO: package rubygem-ronn and put it here
    ++ optional withAudioSupport openal
    ++ optional withBulletEngineSupport bullet
    ++ optional withIgnitionTransport ignition-transport
    ++ optional withModelEditorSchematicView graphviz
    ++ optional withDigitalElevationTerrainsSupport gdal
    ++ optional withConstructiveSolidGeometrySupport gts
    ++ optional withHdf5Support hdf5;

}
