{
  lib,
  stdenvNoCC,
  fetchurl,
  testers,
}:

let
  # Written by the shared Nix receiver (package-distribution) on the first
  # update-zepp-life release; the flake evaluates this file only then.
  versions = lib.importJSON ./versions.json;
  platformKey = stdenvNoCC.hostPlatform.system;
  versionInfo =
    versions.${platformKey}
      or (throw "zepp-life: unsupported platform '${platformKey}'");
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zepp-life";
  inherit (versionInfo) version;

  src = fetchurl {
    inherit (versionInfo) url sha256;
  };

  # The release assets are raw binaries (not archives)
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # Linux binaries are statically linked (CGO_ENABLED=0) — no dynamic linker to
  # patch, no libraries to strip.  macOS binaries are self-contained.
  dontStrip = true;
  dontPatchELF = true;
  dontFixup = stdenvNoCC.hostPlatform.isLinux;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/zepp-life
    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "zepp-life --version";
    };
  };

  meta = {
    description = "Sync Zepp Life activity and body measurements into a local SQLite database";
    homepage = "https://github.com/vmvarela/zepp-life";
    changelog = "https://github.com/vmvarela/zepp-life/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "zepp-life";
    platforms = builtins.attrNames versions;
  };
})
