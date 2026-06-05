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
        in
        {
          inherit kotlin-lsp;
          default = kotlin-lsp;
        }
      );
    };
}
