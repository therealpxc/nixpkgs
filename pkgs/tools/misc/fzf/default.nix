{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub, writeText }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.16.4";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "0kq4j6q1xk17ryzzcb8s6l2zqsjkk75lrwalias9gwcriqs6k6yn";
  };

  outputs = [ "bin" "out" "man" ];

  fishHook = writeText "load-fzf-keybindings.fish" "fzf_key_bindings";

  buildInputs = [ ncurses ];

  goDeps = ./deps.nix;

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf'|'$bin/bin/fzf'|" plugin/fzf.vim
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf-tmux'|'$bin/bin/fzf-tmux'|" plugin/fzf.vim
  '';

  preInstall = ''
    mkdir -p $bin/share/fish/vendor_functions.d $bin/share/fish/vendor_conf.d
    cp $src/shell/key-bindings.fish $bin/share/fish/vendor_functions.d/fzf_key_bindings.fish
    cp ${fishHook} $bin/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
  '';

  postInstall = ''
    cp $src/bin/fzf-tmux $bin/bin
    mkdir -p $man/share/man
    cp -r $src/man/man1 $man/share/man
    mkdir -p $out/share/vim-plugins
    ln -s $out/share/go/src/github.com/junegunn/fzf $out/share/vim-plugins/${name}
  '';

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    # fixes cycle between $out and $bin
    # otool -l shows that the binary includes an LC_RPATH to $out/lib
    # it seems safe to remove that since but the directory does not exist.
    install_name_tool -delete_rpath $out/lib $bin/bin/fzf
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
