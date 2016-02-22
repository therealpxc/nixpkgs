{ stdenv, fetchurl }:

let
  version = "0.5.2";
in
stdenv.mkDerivation rec {
  name = "genromfs-${version}";

  src = fetchurl {
    url = "http://tcpdiag.dl.sourceforge.net/project/romfs/genromfs/${version}/${name}.tar.gz";
    sha256 = "0q6rpq7cmclmb4ayfyknvzbqysxs4fy8aiahlax1sb2p6k3pzwrh";
  };

  configurePhase = ''
    substituteInPlace Makefile --replace "prefix = /usr" "prefix = $out"
  '';

  meta = with stdenv.lib; {
    homepage = "";
    description = "";
    #    license = licenses.;
    maintainers = with maintainers; [ therealpxc ];
    platforms = platforms.all;
  };
}
