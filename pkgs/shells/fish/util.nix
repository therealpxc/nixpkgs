{ smartfish, makeWrapper, buildEnv }:

rec {
  wrap-fish = { fish, name, fish-config }: buildEnv rec {
    inherit name;

    pathsToLink = [
      "/share/fish/pkg"
      "/share/fish/vendor_functions.d"
      "/share/fish/vendor_completions.d"
      "/share/fish/vendor_conf.d"

      # TODO: add "/bin/${command-basename}" for every command used by a fish package
    ];

    paths = [];

    buildInputs = [ makeWrapper ];

    postBuild = ''
      makeWrapper "${fish}/bin/fish" "$out/bin/fish" \
        --set __fish_inject_base_paths $env/etc/fish 
    '';

    # TODO: handle fish-config-file in any way

  };
  
  makeCustomizable = fish: fish.overrideAttrs (oldAttrs: rec {
      customize = { name, fish-config }:
        wrap-fish { 
          inherit fish;
          inherit name;
          inherit fish-config;
        };
    });
}
