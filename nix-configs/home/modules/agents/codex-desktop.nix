{
  codex-desktop-linux,
  config,
  llm-agents,
  lib,
  localPackages,
  pkgs,
  ...
}: let
  codexPackage = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
  codexDesktopBasePackage = codex-desktop-linux.packages.${pkgs.stdenv.hostPlatform.system}.codex-desktop.override {
    linuxFeatureIds = ["pet-overlay"];
  };
  codexDesktopPackage = pkgs.callPackage ../../../pkgs/codex-desktop/package.nix {
    basePackage = codexDesktopBasePackage;
  };
in {
  programs.codexDesktopLinux = {
    enable = true;
    package = codexDesktopPackage;
    cliPackage = codexPackage;
  };

  home.activation = {
    normalizeCodexPetPosition = lib.hm.dag.entryAfter ["writeBoundary"] ''
      codex_dir="${config.home.homeDirectory}/.codex"

      for state_file in "$codex_dir/.codex-global-state.json" "$codex_dir/.codex-global-state.json.bak"; do
        [ -f "$state_file" ] || continue
        state_tmp="$state_file.tmp.$$"
        if ${pkgs.jq}/bin/jq '
          def bottom_right:
            if (.displayBounds? | type) == "object" then
              .x = (.displayBounds.x + .displayBounds.width - 136)
              | .y = (.displayBounds.y + .displayBounds.height - 145)
              | .placement = "bottom-end"
            else
              .
            end;

          if type == "object" and (. ["electron-avatar-overlay-bounds"] | type) == "object" then
            .["electron-avatar-overlay-bounds"] |= bottom_right
            | if (.["electron-avatar-overlay-bounds"].byDisplayId? | type) == "object" then
                .["electron-avatar-overlay-bounds"].byDisplayId |= with_entries(.value |= bottom_right)
              else
                .
              end
            | if (.["electron-avatar-overlay-bounds"].byResolution? | type) == "object" then
                .["electron-avatar-overlay-bounds"].byResolution |= with_entries(.value |= bottom_right)
              else
                .
              end
          else
            .
          end
        ' "$state_file" > "$state_tmp"; then
          if ! ${pkgs.coreutils}/bin/cmp -s "$state_tmp" "$state_file"; then
            ${pkgs.coreutils}/bin/chmod --reference="$state_file" "$state_tmp"
            ${pkgs.coreutils}/bin/mv "$state_tmp" "$state_file"
          else
            ${pkgs.coreutils}/bin/rm -f "$state_tmp"
          fi
        else
          ${pkgs.coreutils}/bin/rm -f "$state_tmp"
        fi
      done
    '';
  };

  home.file = {
    ".codex/pets/reimu/pet.json".source = "${localPackages.codexPetReimu}/pet.json";
    ".codex/pets/reimu/spritesheet.webp".source = "${localPackages.codexPetReimu}/spritesheet.webp";
  };
}
