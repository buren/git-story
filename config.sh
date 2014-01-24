# Default options

# Tests
export GS_PRE_COMMIT_HOOK

# Package
export GS_PACKAGE

# Done
export GS_PRINT_CHECKLIST=false
export GS_PROMPT_ON_DONE=false

# GitHub
export GS_HAS_GITHUB=true

# Project Website
export GS_PROJECT_URL # No need to setup if project hosted on Github. If set it overrides GitHub path.
export GS_PROMPT_BROWSE_URL=true

# Prompts
export GS_CHECKLIST_MESSAGE="
Checklist:
\t 1. Have you written tests?
\t 2. Do all tests pass?
\t 3. Have you refactored your code?
\t 4. Are you ready for possible merge conflicts?"
