{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "feh-${version}";
  version = "2.19";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1sfhr6628xpj9p6bqihdq35y139x2gmrpydjlrwsl1rs77c2bgnf";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ]
    ++ optionals doCheck [ perlPackages.TestCommand perlPackages.TestHarness ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  preBuild = ''
    makeFlags="PREFIX=$out exif=1"
  '';

  libPath = makeLibraryPath ([ imlib2 curl xorg.libXinerama libjpeg libpng libexif xorg.libX11 ]);

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg.bin}/bin" \
                               --add-flags '--theme=feh' 
    '';

  checkPhase = ''
    PERL5LIB="${perlPackages.TestCommand}/lib/perl5/site_perl" make test
  '';
  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
