{
  description = "Jetbrains Kotlin LSP. Alfa state. Took from #514623 on nixpkgs (credits to bew)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    let
      forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          kotlin-lsp = pkgs.callPackage ./kotlin-lsp.nix { };
          kotlin-lsp-2 = pkgs.callPackage ./kotlin-lsp-alt.nix { };
        in
        {
          inherit kotlin-lsp;
          inherit kotlin-lsp-2;
        }
      );
    };
}
