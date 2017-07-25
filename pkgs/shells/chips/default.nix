{ mkDerivation, aeson, base, base64-bytestring, bytestring, cmdargs
, directory, fetchgit, filepath, hspec, process, semver, stdenv
, template-haskell, text, unix, yaml
}:
mkDerivation {
  pname = "chips";
  version = "1.1.2";
  src = fetchgit {
    url = "https://github.com/xtendo-org/chips";
    sha256 = "08liff78p53093z3kqfdyq6hy97v459i28rsjskx9s6fk6mdh4zm";
    rev = "6f7f428a919c93651903e58c6f3439be892d5574";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base64-bytestring bytestring cmdargs directory filepath
    process semver template-haskell text unix yaml
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base hspec text ];
  homepage = "https://github.com/xtendo-org/chips#readme";
  description = "A plugin manager for the fish shell";
  license = stdenv.lib.licenses.gpl3;
}
