{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg, libwebp
, ApplicationServices
}:

let
  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else if stdenv.system == "armv7l-linux" then "armv7l"
    else throw "ImageMagick is not supported on this platform.";

  cfg = {
    version = "7.0.6-1";
    sha256 = "1i3gsc0ps7cbvfmnk6fbi5hng18jwh4x4dqbz90a45x85023w9vs";
    patches = [];
  };
in

stdenv.mkDerivation rec {
  name = "imagemagick-${version}";
  inherit (cfg) version;

  src = fetchurl {
    urls = [
      "mirror://imagemagick/releases/ImageMagick-${version}.tar.xz"
      # the original source above removes tarballs quickly
      "http://distfiles.macports.org/ImageMagick/ImageMagick-${version}.tar.xz"
      "https://bintray.com/homebrew/mirror/download_file?file_path=imagemagick-${version}.tar.xz"
    ];
    inherit (cfg) sha256;
  };

  patches = [ ./imagetragick.patch ] ++ cfg.patches;

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ [ "--with-gcc-arch=${arch}" ]
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optionals (ghostscript != null)
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ]
    ++ lib.optionals (stdenv.cross.libc or null == "msvcrt")
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkgconfig libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      libpng libtiff libxml2
    ]
    ++ lib.optionals (stdenv.cross.libc or null != "msvcrt")
      [ openexr librsvg openjpeg ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 ]
    ++ lib.optionals (stdenv.cross.libc or null != "msvcrt")
      [ libX11 libXext libXt libwebp ]
    ;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16HDRI" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '${pkgconfig}/bin/pkg-config'"
    done
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ the-kenny wkennington ];
  };
}
