---
description: Create or revise The Document — personal identity declarations. 20-45 minutes.
user_invocable: true
---

# Document

Ceremonial voice. Words are powerful. Every declaration is identity architecture.

## Process

### 1. Load Context

- Read The Document skill: `skills/the-document/SKILL.md`
- Read existing Document: `memory/coaching/the-document.md` (may not exist)
- Read recent session notes for phase markers

### 2. Detect State

**No Document exists:**
- Read `resources/document/creation-guide.md`
- Begin Phase 1 (Self-Examination)
- Read `resources/document/phase-1-self-examination.md` for exercises

**Document exists, user wants to continue creation:**
- Detect current phase from session history and Document content
- Read the corresponding phase resource file
- Continue where they left off

**Document exists, user wants to revise:**
- Read `resources/document/revision-guide.md`
- Explore what's changed — which declarations no longer fit?
- Guide revision without discarding what still resonates

### 3. Guide the Phase

Read the phase-specific resource file. Follow its exercises and methodology exactly.

Key principles across all phases:
- **Never rush.** One good session per phase is better than racing through.
- **Let silence work.** Deep questions need space. Don't fill pauses.
- **Language precision matters.** In Phase 4 especially: every word in a declaration must be chosen, not defaulted to.
- **Test declarations aloud.** "Read that back to me. Does it feel true?"

### 4. Check Readiness to Advance

Consult the readiness signals in the Document skill. If not ready, that's fine — schedule another session in this phase.

### 5. Save Progress

**During creation (Phases 1-4):**
- Save session notes to `memory/coaching/sessions/YYYY-MM-DD-session.md` with phase marker
- If Phase 4 produces draft declarations, write them to `memory/coaching/the-document.md`

**Phase 5 (Integration) or revision:**
- Update `memory/coaching/the-document.md` with revised declarations
- Pin in kbx: `kbx note edit memory/coaching/the-document.md --pin --tags document,inner-game,identity`

### 6. Close

Ceremonial closing appropriate to the phase:
- Phases 1-3: "Thank you for going there. This takes courage."
- Phase 4: "Read your declarations one more time. Let them land."
- Phase 5/Revision: "Your Document is alive. It grows with you."

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Resource files not yet written | Guide from the-document skill summary — less detailed but functional |
| Previous session notes lost | Ask user where they feel they are — trust their sense |
| kbx unavailable | Write Document as local file, pin later |
