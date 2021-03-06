{ fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "nlopt-2.4.2";

  src = fetchurl {
    url = "http://ab-initio.mit.edu/nlopt/${name}.tar.gz";
    sha256 = "12cfkkhcdf4zmb6h7y6qvvdvqjs2xf9sjpa3rl3bq76px4yn76c0";
  };

  configureFlags = "--with-cxx --enable-shared --with-pic --without-guile --without-python --without-matlab ";

  meta = {
    homepage = "http://ab-initio.mit.edu/nlopt/";
    description = "Free open-source library for nonlinear optimization";
    license = stdenv.lib.licenses.lgpl21Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };

}
