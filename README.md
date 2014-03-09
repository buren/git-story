# git-story (beta)

#### Simplified git workflow.

Branch strategy based on [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html).

* [Installation](#install-git-story)
* [Getting Started](#getting-started)
* [Example](#example)
* [Configuration](#configuration)
* [Command list](#command-list)
* [Documentation](#documentation)
* [Notes](#notes)
* [License](#license)

## Install git-story

    curl https://raw2.github.com/buren/git-story/master/setup/install | bash
injects import of git-story script to either `.bash_profile`, `.bashrc` or `.zshrc` (in that order).

## Getting started
git-story tries to simplify the [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html) branching model, so that any VCS novice can use it within 5 minutes.

The model:

1. Start developing a feature, and name it `git dev <name>`
2. Save local changes and sync with remote `git done <commit_message>`
3. If any conflicts fix them and run `git done "Fixed merge conflicts in ..."`
4. Create a pull request on GitHub (or any other host)

The principle is that you develop each new feature in its on branch. Then when you're ready you push it and create a pull request.

## Example

    git dev branch_name        # Sets up clean workspace based of remote master.
    git done "Commit message"  # Commit changes, updates current and local branch.
Output [example](http://showterm.io/238c04d003bfb22f1d91d) (video).

## Command list

    git
       dev               Start developing a new feature
       done              Commit changes and sync with remote
       create-branch     Create and checkout a new branch on remote and local
       delete-branch     Delete branch from remote and local
       goto              Switch from current branch to specified branch
       abort-merge       Aborts current merge
       history           List repository commits
       tag-release       Create a new tag
       stat              Print statistics of git repository
       fetch-branches    Fetches all branches from remote
       browse            Open current git repository on Github
       test              Runs test command defined in .gitstoryrc
       package           Runs package command defined in .gitstoryrc
       release           Runs release command defined in .gitstoryrc
       trail             Show the last common commit with current branch
       neck              Show commits until first branching point
       branch-status     Show current branch status
       churn             Count number of changes for each file
       conflicted        List files with merge-conflicts
       divergence        Show difference between current branch and remote branch
       git-story         List git-story extensions
       git-story-extend  Add new git-story extension to git
       git-story-update  Update git-story to its latest version


## Documentation

* Start developing a feature

        git dev <branch_name>
        git dev <branch_name> <base_branch>
this will create a new branch <branch_name> based of master or specified <base_branch>. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the newly created branch to remote.
If --force is supplied as the second argument no checks are made.
No checks are made if --force is supplied as the second argument.
* Commit and sync with repository

        git done <commit_message> <target_branch>
comment and commit the changes you've made and merge changes made on <target_branch>.
`<target_branch>` is optional and defaults to 'master'.
If no merge conflicts, create a pull request. Otherwise fix all merge conflicts and run `git done "Fixed merge conflicts for ..."`.
* `git browse`  opens the repository on GitHub.
* `git package` Package the project. Runs `GS_PACKAGE`.
* `git release` Package the project. Runs `GS_RELEASE`
* `git test`    Package the project. Runs `GS_PRE_COMMIT_HOOK`.
* `git goto <branch_name>` switches to branch <branch_name> if all changes are stashed or committed.
* `git history` view repository commit history.
* `git tag-release` Create a new tagged release
* `git abort-merge` aborts current merge
* `git extend-with <extension-name>` add new git-story extension to git
* `git fetch-branches` .
* `git git-story-update` gets the latest version of git-story.
* `git git-story-extend` add new git-story extension to git.
* `git git-story` list git-story extensions.
* `git trail` shows the last common commit with current branch
* `git neck` show commits until first branching point
* `git branch-status` shows current branch status
* `git churn` count number of changes for each file
* `git conflicted` list files with merge-conflicts
* `git create-branch` create and checkout a new branch on remote and local
* `git delete-branch` delete branch from remote and local
* `git divergence` show the difference between current branch and the same remote
* `git git-story` list git-story extensions
* Show statistics for repository

        git stat <type>
                contributions   # shows statistics for all authors or specified author (alias: contrib)
                commits         # shows number of commits for each author
                weekdays        # prints statistics for number of commits per weekday
                hour            # prints statistics for number of commits per hour
                files           # prints number of files and lines
                diff            # print stat of uncomitted changes
                log             # print log with stat
                modified        # print stat of most modified files
show statistics for repository.

## Configuration
For project specific configurations create a file named `.gitstoryrc` at the project's git root.
Available options:

    GS_GIT_STORY_BRANCH       # (String)  Target branch for 'git done'       Default: "master"
    GS_PRE_COMMIT_HOOK        # (String)  A command that runs all tests      Default: ""
    GS_PACKAGE                # (String)  Shell command for 'package'        Default: ""
    GS_RELEASE                # (String)  Shell command for 'release'        Default: ""
    GS_PROMPT_ON_DONE         # (Boolean) Prompt user before executing done  Default: false
    GS_PRINT_CHECKLIST        # (Boolean) Print checklist before 'done'      Default: false
    GS_HAS_GITHUB             # (Boolean) Project has GitHub.                Default: true
    GS_PROJECT_URL            # (String)  Project URL                        Default: ""
    GS_PROMPT_BROWSE_URL      # (Boolean) Prompt to open project URL on done Default: true
    GS_CHECKLIST_MESSAGE      # (String)  Checklist string for 'done'        Default: "1. Have you..."
    GS_NEW_TAG_PROMPT         # (String)  Prompt text for tag-release        Default: "What tag..."
    GS_TEST_ON_AUTO_MERGE     # (Boolean) Run tests command on auto merge    Default: true

See [config](https://github.com/buren/git-story/blob/master/config) for details.

## Notes
* Tested on Linux/OSX using both zsh and bash
* The software is supplied “as is” and all use is at your own risk.

## License
git-story is released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
