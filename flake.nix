{
  description = "mariawellington.com — Jekyll/Ruby dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ ruby ];

            shellHook = ''
              export BUNDLE_PATH="$PWD/.bundle"
              export BUNDLE_BIN="$PWD/.bundle/bin"
              export GEM_HOME="$PWD/.bundle"
              export GEM_PATH="$PWD/.bundle"
              export PATH="$BUNDLE_BIN:$PATH"

              echo "nix develop ready: $(ruby -v)"
              echo "Run: bundle install && bundle exec jekyll serve --livereload"
            '';
          };
        }
      );
    };
}
