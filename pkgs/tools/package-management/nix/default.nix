{ lib, stdenv, fetchurl, fetchFromGitHub, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, aws-sdk-cpp, brotli, readline
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook5_xsl
, libseccomp, busybox
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let

  sh = busybox.override {
    useMusl = true;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_ASH y
      CONFIG_ASH_BUILTIN_ECHO y
      CONFIG_ASH_BUILTIN_TEST y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y
    '';
  };

  common = { name, suffix ? "", src, fromGit ? false }: stdenv.mkDerivation rec {
    inherit name src;
    version = lib.getVersion name;

    is112 = lib.versionAtLeast version "1.12pre";

    VERSION_SUFFIX = lib.optionalString fromGit suffix;

    # 1.11.8 doesn't yet have the patch to work on LLVM 4, so we patch it for now. Take this out once
    # we move to a higher version. I'd pull the specific patch from upstream but it doesn't apply cleanly.
    patchPhase = lib.optionalString (!lib.versionAtLeast version "1.12pre") ''
      substituteInPlace src/libexpr/json-to-value.cc \
        --replace 'std::less<Symbol>, gc_allocator<Value *>' \
                  'std::less<Symbol>, gc_allocator<std::pair<const Symbol, Value *> >'
    '';

    outputs = [ "out" "dev" "man" "doc" ];

    nativeBuildInputs =
      [ pkgconfig ]
      ++ lib.optionals (!is112) [ perl ]
      ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl ];

    buildInputs = [ curl openssl sqlite xz ]
      ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
      ++ lib.optionals fromGit [ brotli readline ] # Since 1.12
      ++ lib.optional stdenv.isLinux libseccomp
      ++ lib.optional ((stdenv.isLinux || stdenv.isDarwin) && is112)
          (aws-sdk-cpp.override {
            apis = ["s3"];
            customMemoryManagement = false;
          });

    propagatedBuildInputs = [ boehmgc ];

    # Note: bzip2 is not passed as a build input, because the unpack phase
    # would end up using the wrong bzip2 when cross-compiling.
    # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
    postUnpack =
      '' export CPATH="${bzip2.dev}/include"
         export LIBRARY_PATH="${bzip2.out}/lib"
         export CXXFLAGS="-Wno-error=reserved-user-defined-literal"
      '';

    configureFlags =
      [ "--with-store-dir=${storeDir}"
        "--localstatedir=${stateDir}"
        "--sysconfdir=/etc"
        "--disable-init-state"
        "--enable-gc"
      ]
      ++ lib.optionals (!is112) [
        "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
        "--with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}"
      ] ++ lib.optionals (is112 && stdenv.isLinux) [
        "--with-sandbox-shell=${sh}/bin/busybox"
      ];

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = true;

    separateDebugInfo = stdenv.isLinux;

    crossAttrs = {
      postUnpack =
        '' export CPATH="${bzip2.crossDrv}/include"
           export NIX_CROSS_LDFLAGS="-L${bzip2.crossDrv}/lib -rpath-link ${bzip2.crossDrv}/lib $NIX_CROSS_LDFLAGS"
        '';

      configureFlags =
        ''
          --with-store-dir=${storeDir} --localstatedir=${stateDir}
          --with-dbi=${perlPackages.DBI}/${perl.libPrefix}
          --with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}
          --with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}
          --disable-init-state
          --enable-gc
        '' + stdenv.lib.optionalString (
            stdenv.cross ? nix && stdenv.cross.nix ? system
        ) ''--with-system=${stdenv.cross.nix.system}'';

      doInstallCheck = false;
    };

    enableParallelBuilding = true;

    meta = {
      description = "Powerful package manager that makes package management reliable and reproducible";
      longDescription = ''
        Nix is a powerful package manager for Linux and other Unix systems that
        makes package management reliable and reproducible. It provides atomic
        upgrades and rollbacks, side-by-side installation of multiple versions of
        a package, multi-user package management and easy setup of build
        environments.
      '';
      homepage = http://nixos.org/;
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.all;
    };

    passthru = { inherit fromGit; };
  };

  perl-bindings = { nix }: stdenv.mkDerivation {
    name = "nix-perl-" + nix.version;

    inherit (nix) src;

    postUnpack = "sourceRoot=$sourceRoot/perl";

    nativeBuildInputs =
      [ perl pkgconfig curl nix libsodium ]
      ++ lib.optionals nix.fromGit [ autoreconfHook autoconf-archive ];

    configureFlags =
      [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
      ];

    preConfigure = "export NIX_STATE_DIR=$TMPDIR";

    preBuild = "unset NIX_INDENT_MAKE";
  };

in rec {

  nix = nixStable;

  nixStable = (common rec {
    name = "nix-1.11.13";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0913975e262f8069fde6e71a5fae757bb3aef558c51d1711034c525146ea5913";
    };
  }) // { perl-bindings = nixStable; };

  nixUnstable = (lib.lowPrio (common rec {
    name = "nix-1.12${suffix}";
    suffix = "pre5511_c94f3d55";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "c94f3d5575d7af5403274d1e9e2f3c9d72989751";
      sha256 = "1akfzzm4f07wj6l7za916xv5rnh71pk3vl8dphgradjfqb37bv18";
    };
    fromGit = true;
  })) // { perl-bindings = perl-bindings { nix = nixUnstable; }; };

}
