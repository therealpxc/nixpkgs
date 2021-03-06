{ stdenv, fetchurl, pkgconfig, gnutls, jansson, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit, zlib, libiconv, fetchpatch
}:

with { inherit (stdenv.lib) optional optionals; };

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.4.5";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "87ce8ccc83511c5a1f4eadd3f0122f2f5ae86fb68e9b72f0700c6f5340ba95cb";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls jansson liburcu libidn
    nettle libedit
    libiconv
    # without sphinx &al. for developer documentation
  ]
    # Use embedded lmdb there for now, as detection is broken on Darwin somehow.
    ++ optionals stdenv.isLinux [ libcap_ng systemd lmdb ]
    ++ optional stdenv.isDarwin zlib; # perhaps due to gnutls

  # Not ideal but seems to work on Linux.
  configureFlags = optional stdenv.isLinux "--with-lmdb=${stdenv.lib.getLib lmdb}";

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  #doCheck = true; problems in combination with dynamic linking

  postInstall = ''rm -r "$out"/var'';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = https://knot-dns.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}

