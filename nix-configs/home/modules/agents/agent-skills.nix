{
  config,
  lib,
  personal-skills,
  ...
}: {
  imports = [personal-skills.homeManagerModules.default];

  home.activation.prepareAgentSkillsTargets = lib.hm.dag.entryBetween ["agent-skills"] ["writeBoundary"] ''
    targets=(
      "${config.home.homeDirectory}/.agents/skills"
      "''${CLAUDE_CONFIG_DIR:-${config.home.homeDirectory}/.claude}/skills"
      "''${CODEX_HOME:-${config.home.homeDirectory}/.codex}/skills"
      "${config.home.homeDirectory}/.config/opencode/skills"
    )

    for target in "''${targets[@]}"; do
      if { [ -e "$target" ] || [ -L "$target" ]; } \
        && [ ! -e "$target/.agent-skills-managed.json" ]; then
        export AGENT_SKILLS_FORCE=1
        break
      fi
    done
  '';

  programs.agent-skills.targets = {
    agents.enable = true;
    claude.enable = true;
    codex.enable = true;
    opencode.enable = true;
  };
}
