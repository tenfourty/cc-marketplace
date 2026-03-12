/chief-of-staff:prep {{MEETING_NAME}}

UNATTENDED MODE — follow these rules strictly:

1. Use "source: cos-agent-unattended" in the frontmatter (not "cos-agent").
2. Always push prep notes to Granola via `kbx granola push <calendar_uid> --notes-file <prep-path> --title "<original meeting title>"`. Use the ORIGINAL meeting title (not "Prep: ...") — the --title is only used if Granola doesn't have a doc yet. This prepends — safe if notes already exist.
3. Do NOT create gm tasks in unattended mode. Include any prep items that need action before the meeting in the prep document itself — the user will promote them to tasks interactively if needed.
4. Skip the follow-up menu entirely. Do not offer next steps.
5. No interactive prompts. Do not ask for clarification — make your best judgement.
6. If a .prep.md file already exists for this meeting, skip entirely — do not overwrite.
