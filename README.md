# git-story (beta)

#### Simplified git workflow.

git-story tries to simplify the [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html) branching model, so that any VCS novice can use it within 5 minutes.

It also includes various extensions to git, documented below.

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


The model:

1. Start developing a feature, and name it `git dev <name>`
2. Save local changes and sync with remote `git done <commit_message>`
3. If any conflicts fix them and run `git done "Fixed merge conflicts in ..."`
4. Create a pull request on GitHub (or any other host)

The principle is that you develop each new feature in its own branch. Then when you're done you push it and create a pull request.

## Example

    git dev branch_name        # Sets up clean workspace based on remote master.
    git done "Commit message"  # Commit changes, updates current and local branch.
Output [example](http://showterm.io/f25fff6593f82dcdab7d1) (video).

## Command list

    git
       dev               Start developing a new feature
       done              Commit changes and sync with remote
       update            Pull current branch's remote changes
       addcom            Adds all files and commit them
       fuckit            Commit all files and push current branch
       push-branch       Push the current branch to remote
       create-branch     Create and checkout a new branch on remote and local
       delete-branch     Delete branch from remote and local
       goto              Switch from current branch to specified branch
       abort-merge       Aborts current merge
       history           List repository commits
       tag-release       Create a new tag
       redo-commit       Redo last commit.
       stat              Print statistics of git repository
       fetch-branches    Fetches all branches from remote
       browse            Open current git repository on Github
       test              Runs test command defined in .gitstoryrc
       package           Runs package command defined in .gitstoryrc
       release           Runs release command defined in .gitstoryrc
       install-project   Runs install command defined in .gitstoryrc
       trail             Show the last common commit with current branch
       neck              Show commits until first branching point
       branch-status     Show current branch status
       churn             Count number of changes for each file
       conflicted        List files with merge-conflicts
       divergence        Show difference between current branch and remote branch
       gs                List git-story extensions
       gs-extend         Add new git-story extension to git
       gs-update         Update git-story to its latest version


## Documentation

* Start developing a feature

        git dev <branch_name>
        git dev <branch_name> <base_branch>
this will create a new branch <branch_name> based of master or specified <base_branch>. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the created branch to remote.
* Commit and sync with repository

        git done <commit_message> <target_branch>
comment and commit the changes you've made and merge changes made on <target_branch>.
`<target_branch>` is optional and defaults to 'master'.
If no merge conflicts, create a pull request. Otherwise fix all merge conflicts and run `git done "Fixed merge conflicts for ..."`.
* `git update` pull current branch's remote changes.
* `git addcom <commit_message>` add all files and commit.
* `git fuckit` commit all files with optional <message> and push current branch. Default message is 'Update'.
* `git push-branch` push the current branch to remote.
* `git browse`  opens the repository on GitHub.
* `git package` Package the project. Runs `GS_PACKAGE`.
* `git release` Package the project. Runs `GS_RELEASE`.
* `git install-project` Install the project. Runs `GS_INSTALL`.
* `git test`    Package the project. Runs `GS_PRE_COMMIT_HOOK`.
* `git goto <branch_name>` switches to branch <branch_name> if the working directory is clean.
* `git history` view repository commit history.
* `git tag-release` Create a new tagged release.
* `git redo-commit` Redo last commit.
* `git abort-merge` aborts current merge.
* `git extend-with <extension-name>` add new git-story extension to git.
* `git fetch-branches`.
* `git gs-update` gets the latest version of git-story.
* `git gs-extend` add new git-story extension to git.
* `git gs` list git-story extensions.
* `git trail` shows the last common commit with current branch.
* `git neck` show commits until first branching point.
* `git branch-status` shows current branch status.
* `git churn` count number of changes for each file.
* `git conflicted` list files with merge-conflicts.
* `git create-branch` create and checkout a new branch on remote and local.
* `git delete-branch` delete branch from remote and local.
* `git divergence` show the difference between current branch and the same remote.
* Show statistics for repository

        git stat <type>
                contributions   # shows statistics for all authors or specified author (alias: contrib)
                commits         # shows number of commits for each author
                weekdays        # prints statistics for number of commits per weekday
                hour            # prints statistics for number of commits per hour
                files           # prints number of files and lines
                diff            # print stat of uncommitted changes
                log             # print log with stat
                modified        # print stat of most modified files
show statistics for repository.

## Configuration
For project specific configurations create a file named `.gitstoryrc` at the project's git root.
See example with comments in docs/gitstoryrc-example
Available options and there default value:

    GS_DEFAULT_REMOTE='origin'          # Default remote for git story
    GS_GIT_STORY_BRANCH='master'        # Target branch for 'done'
    GS_LOCAL_MERGE=false                # Perform local merge on 'done'
    GS_PRINT_CHECKLIST=false            # Print checklist before 'done'
    GS_PROMPT_ON_DONE=false             # Prompt user before 'done'
    GS_CHECKLIST_MESSAGE='...'          # Checklist string for 'done'
    GS_PRE_COMMIT_HOOK=''               # A command that runs all tests
    GS_PACKAGE=''                       # Shell command for 'package'
    GS_RELEASE=''                       # Shell command for 'release
    GS_INTSALL=''                       # Shell command for 'install'
    GS_HAS_GITHUB=true                  # Project has GitHub.
    GS_PROJECT_URL=''                   # Project URL
    GS_TEST_ON_AUTO_MERGE=true          # Run tests command on auto merge
    GS_PRODUCTION_BRANCH='heads/master' # Integration branch for production
    GS_NEXT_VERSION_BRANCH=''           # Integration branch for next
    GS_EDGE_BRANCH=''                   # Integration branch for edge
    GS_GIT_STORY_EXT_BRANCH='master'
See [config](https://github.com/buren/git-story/blob/master/config) for details.

## Notes
* Tested on Linux/OSX using both zsh and bash
* Wont work with sh
* The software is supplied “as is” and all use is at your own risk (see [license](https://github.com/buren/git-story/blob/master/LICENSE)
* `git branch-status` requires Ruby 1.8.7 or greater

## License
git-story is released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
