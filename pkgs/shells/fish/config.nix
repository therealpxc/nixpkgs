{ stdenv, buildEnv
  , enableVendorExtensions ? false
  , extraDependencies ? []
  , configMain ? ""
  , configSnippets ? []
  , configCompletions ? []
  , configFunctions ? []
}:

# This file defines the fish-config package. A fish package may be built with
# given fish-config. A Nix user may also install a fish-config to their user
# profile, and fish (built from a Nix package with the appropriate options)
# will read from it. Similarly, a fish-config may be installed on the default
# profile (root's user profile). In addition, a fish-config may be selected for
# an entire NixOS instance.
#
# The Nix fish package allows Nix hackers to toggle reading from each of these
# sources. They are read in the following order, skipping those elements which
# come from disabled sources:
#   -> built-in (at the Nix package level) fish-config
#   -> default Nix profile (i.e., /nix/var/nix/profiles/default)
#   -> user Nix profile (i.e., /nix/var/nix/profiles/per-user/<username>)
#   -> system Nix profile [NixOS-only] (i.e., /nix/var/nix/profiles/system)
#
# On NixOS, a fish-config may be added to the system Nix profile by adding a
# fish-config package to environment.systemPackages, and it will affect all
# users (of compatible fish packages) on the system. The configuration of the
# system profile will automatically be linked into /etc, and other global NixOS
# paths as appropriate. Administrators may alternatively specify a fish-config
# package via programs.fish.config = <fish-config>, but attempting to declare
# an operating system-wide fish configuration both ways will result in a 
# collision and the system will not build successfuly.
#
# The appropriate elements of each fish-config are sourced when fish normally
# sources their counterparts on non-Nix systems:
#   compiled-in -> vendor-supplied -> admin/Nix-specified -> user-specified
# so that each the appropriate components of each fish-config are read at the
# same time as the administrator-specified components would be read on ‘vanilla’
# fish compiled without Nix. Recall that with fish, all components are sourced
# according to the same ordering (specified above); They vary only in their
# sourcing behaviors.
#
# Configuration snippets
#   • locations:
#     ◦ <prefix>/conf.d/*.fish
#     ◦ <prefix>/vendor_conf.d/
#   • sourcing behavior:
#     ◦ rightmost source with given configMainname (e.g. <configMain> in
#       <prefix>/conf.d/<configMain>.fish) preempts sources to its left, bypassing
#       them so that they are not sourced.
#
# Configuration files
#   • locations:
#       ◦ <prefix>/config.fish
#   • sourcing behavior:
#       ◦ all present files are sourced in order from left to right, so that
#         environment or other changes in earlier files may be overriden in
#         later files
#
# Completion and function paths
#   • locations:
#     ◦ <prefix>/(completions|functions)
#     ◦ <prefix>/vendor_(completions|functions).d
#     ◦ <prefix>/generated_(completions|functions)
#   • sourcing behavior:
#     ◦ left preempts right as with snippets
#
# See the fish documentation for more information on how fish reads configs:
#   http://fishshell.com/docs/current/index.html#initialization

with stdenv.lib;

let
  configFile = builtins.toFile "config.fish" configMain;
  snippetFiles = map (snippet: builtins.toFile "${snippet.name}.conf.fish" snippet.content) configSnippets;
  completionFiles = map (completion: builtins.toFile "${completion.name}.fish" completion.content) configCompletions;
  functionFiles = map (function: builtins.toFile "${function.name}.fish" completion.content) configFunctions;
in

buildEnv {
  name = "fish-config";
  pathsToLink = [
    "/bin"
    "/etc/fish"
  ] ++ optional enableVendorExtensions [
    "/share/fish/vendor_functions.d"
    "/share/fish/vendor_completions.d"
    "/share/fish/vendor_conf.d"
  ];
  
  paths = [] ++ extraDependencies;

  buildInputs = [] ++ extraDependencies;
  
  postBuild = ''
    ln -s ${configFile} $out/etc/fish/config.fish
    
    mkdir -p $out/etc/fish/conf.d $out/etc/fish/completions $out/etc/fish/functions
    ln -s ${(concatStringsSep " " snippetFiles)} $out/etc/fish/conf.d/
    ln -s ${(concatStringsSep " " completionFiles)} $out/etc/fish/completions/
    ln -s ${(concatStringsSep " " functionFiles)} $out/etc/fish/functions/
  '';
}
