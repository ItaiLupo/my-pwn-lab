{
  description = "Pwn Lab Toolchain Shell Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            clang
            lld
            patchelf
            just
            direnv
            gdb
            nix-direnv
             musl.dev
            (python3.withPackages (ps: with ps; [
              ipython
              pwntools
              pyperclip
            ]))
          ];

          shellHook = ''
            export PWN_LAB_ROOT=$PWD
             export MUSL_INC="-I${pkgs.musl.dev.src} -I${pkgs.musl.dev}/include  -I${pkgs.musl.dev.src}/src/internal -I${pkgs.musl.dev.src}/arch/x86_64"
            echo "[*] Pwn Lab Infrastructure Loaded Automatically via direnv"
          '';
        };
      });
    };
}
