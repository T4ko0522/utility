# Response Language

- Always respond to the user in Japanese, regardless of the input language.
- Internal thinking may be in any language.

# Sub-agents and Task Delegation

- If sub-agents are usable and independent contexts are enabled for tasks (such as refactoring, reviewing, wide-ranging exploration, searching on the web or in documents), or if you want to execute tasks in parallel, utilize sub-agents to delegate processing.

# Clarifying Requirements

- If user requests or requirements are unclear, repeatedly use `request_user_input` to delve deeper and clarify ambiguities.

# Design Principles

- There is no need to implement with minimal changes; prioritize conciseness and correctness of design.
- Adhere to the YAGNI principle, KISS principle, and DRY principle.
- Do not implement auxiliary functions or alternative paths for backward compatibility unless explicitly requested by the user.
