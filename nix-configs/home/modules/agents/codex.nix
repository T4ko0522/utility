{
  config,
  lib,
  ...
}: {
  home.activation.seedCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    codex_cfg="${config.home.homeDirectory}/.codex/config.toml"
    codex_tmpl="${./files/codex/config.toml}"
    mkdir -p "${config.home.homeDirectory}/.codex"
    if [ -L "$codex_cfg" ] || [ ! -e "$codex_cfg" ]; then
      rm -f "$codex_cfg"
      cp "$codex_tmpl" "$codex_cfg"
      chmod u+w "$codex_cfg"
    fi
  '';

  home.file = {
    ".codex/AGENTS.md".source = ./files/codex/AGENTS.md;
    ".codex/agents".source = ./files/codex/agents;
    ".codex/rules".source = ./files/codex/rules;
  };
}
