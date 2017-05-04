{ fish, fish-nix-utils, name ? "smartfish", callPackage, 
  fish-config ? callPackage ./config.nix {} }:

with fish-nix-utils;

wrap-fish {
  inherit fish;
  inherit name;
  inherit fish-config;
}
