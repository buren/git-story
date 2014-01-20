# git-story (beta)


Simplified git workflow.
Branch strategy based on [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html).

* [Installation](#install-git-story)
* [Example](#example)
* [Configuration](#configuration)
* [Command list](#command-list)
* [Documentation](#documentation)
* [Notes](#notes)
* [License](#license)

## Install git-story

    curl https://raw2.github.com/buren/git-story/master/setup/install.sh | bash
injects import of git-story script to either `.bash_profile`, `.bashrc` or `.zshrc` (in that order).

## Getting started
git-story is a git branching model which tries to so simple that any VCS novice should be able to effectively use it within 5 minutes.

The model:

1. Start developing a feature, and name it `gs dev <name>`
2. Save local changes and sync with remote `gs done <commit_message>`
3. If any conflicts fix them and `gs done "Fixed merge conflicts in ..."`
4. Make a pull request on GitHub `gs pull-request`

The principle is that you develop each new feature in its on branch. Then when you're ready you go to the projects GitHub page and create a pull request.

## Example

    gs dev branch_name                     # Sets up clean workspace based of remote master.
    gs done "Commit message"               # Commit changes, update master and merge with repository.
Output [example](http://showterm.io/74f38902aa7540458057b) (video).

## Configuration
For project specific configurations create a file named `.gitstoryrc` at the git root.
Available options:

    GS_PRE_COMMIT_HOOK   # (String)  A command that runs all tests.     Default: ""
    GS_PRINT_CHECKLIST   # (Boolean) Print checklist before `gs done`.  Default: false
    GS_HAS_GITHUB        # (Boolean) Project has GitHub.                Default: true
    GS_PROJECT_URL       # (String)  Project URL.                       Default: ""
    GS_PROMPT_BROWSE_URL # (Boolean) Prompt to open project URL.        Default: true
    GS_CHECKLIST_MESSAGE # (String)  Checklist string.                  Default: "1. Have you written..."

See [config.sh](https://github.com/buren/git-story/blob/master/config.sh) for details.

## Command list

    gs <command>
       dev               # Start developling a new feature (alias: feature)
       pull              # Download changes from remote branch to local workspace
       commit            # Commit changes and push branch to remote (alias: checkpoint)
       done              # Commit changes and sync with remote (alias: release)
       test              # Runs test command defined in .gitstoryrc (alias: pre-commit)
       switchto          # Switch from current branch to specified branch (alias: branch, goto)
       diff              # List status and uncomitted changes
       pull-request      # Open current git repository on Github (alias: open, github)
       history           # List repository commits (alias: repo-history)
       show              # Show last or specified commit (alias: last)
       status            # Shows the current git status
       where             # Shows all available branches (alias: branches)
       list              # Print command list
       stat              # Print statistics of git repository (alias: statistics)
       get-update        # Update git-story

## Documentation

* Start developing a feature

        gs dev <branch_name>
        gs dev <branch_name> <base_branch>
this will create a new branch <branch_name> based of master or specified <base_branch>. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the newly created branch to remote.
Alias: `feature`
* Commit your changes

        gs commit <commit_message>
comment and commit to the changes you've made.
Alias: `checkpoint`
* Commit and sync with repository

        gs done <commit_message> <target_branch>
comment and commit the changes you've made and merge changes made on <target_branch>.
`<target_branch>` is optional and defaults to 'master'.
If no merge conflicts; make a pull request `gs pull-request`. Otherwise fix all merge conflicts and run `gs done "Fixed merge conflicts for ..."` and then `gs pull-request`.
Alias: `release`
* Fetch and merge

        gs pull
fetch and merge from remote.
Example: If the current branch is "test_feature" the command will try to fetch and merge the remote version of test_feature.
* ```gs pull-request``` opens the repository on GitHub. Alias: `open`, `github`
* ```gs where``` prints all branches and marks the current one with a *. Alias: `branches`
* ```gs switchto <branch_name>``` switches to branch <branch_name> if all changes are stashed or committed. Alias: `branch`, `goto`
* ```gs diff``` view all uncommitted changes
* ```gs history``` view repository commit history. Alias: `repo-history`
* ```gs list``` list all available git-story commands
* ```gs get_update``` gets the latest version of git-story. Alias: `get-update`, `getupdate`
* Show commited changes

        gs show
        gs show <sha>
view the last commit in current branch or specified commit <sha>.
Alias: `last`
* Show statistics for repository

        gs stat <type>
                contributions <author> # shows statistics for all authors or specified author (alias: contrib)
                commits                # shows number of commits for each author
                weekdays               # prints statistics for number of commits per weekday
                hour                   # prints statistics for number of commits per hour

show statistics for repository.
Alias: `statistics`

## Notes
Overides ```gs``` (Ghostscript) on Linux.

## License
Released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
