# git-story (beta)

#### Simplified git workflow.

_git-story_ aims to simplify the [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html) branching model, so that any VCS novice can use it within 5 minutes.

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
The above command will install and inject an import of the _git-story_ script to either `.bash_profile`, `.bashrc` or `.zshrc` (in that order).

Reload your shell to initialize _git-story_ extensions.

## Getting started


The model:

1. Start developing a feature, and name it `git dev <name>`
2. Save local changes and sync with remote `git done`
3. Create a pull request

The principle is that you develop each new feature in its own branch and when
you're done you push it and create a pull request.

## Example

    git dev branch_name   # Sets up clean workspace based on remote master.
    git done              # Commit changes, updates current and local branch.
Output [example](http://showterm.io/f25fff6593f82dcdab7d1) (video).

## Documentation

### GitHub Flow extensions

* Start developing a feature

      git dev <branch_name>
      git dev <branch_name> <base_branch>
this will create a new branch <branch_name> based of master or specified <base_branch>. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the created branch to remote.
* Commit and sync with repository

      git done <target_branch>
commit the changes you've made and merge changes with <target_branch>.
`<target_branch>` is optional and the default is `master`.

### git convenience extensions
* `git addcom <commit_message>` add all files and commit.
* `git fuckit` commit all files with optional <message> and push current branch. Default is to prompt for commit message.
* `git redo-commit` Redo last commit.
* `git tag-release` Create a new tagged release.
* `git goto <branch_name>` switches to branch <branch_name> if the working directory is clean.
* `git history` view repository commit history.
* `git abort-merge` aborts current merge.
* `git conflicted` list files with merge-conflicts.
* `git todos` list all TODOS and FIXMES.

### git branching extensions
* `git branch-status` shows current branch status.
* `git pull-branch` pull current, or specified, branch's remote changes.
* `git create-branch` create and checkout a new branch and push to remote.
* `git delete-branch` delete branch from remote and local.
* `git push-branch` push the current branch to remote.
* `git trail` shows the last common commit with current branch.
* `git neck` show commits until first branching point.
* `git divergence` show the difference between current branch and the same branch at remote.

### Project integration
* `git browse`  opens the repository on GitHub.
* `git package` Package the project. Runs `GS_PACKAGE`.
* `git release` Package the project. Runs `GS_RELEASE`.
* `git install-project` Install the project. Runs `GS_INSTALL`.
* `git test`    Package the project. Runs `GS_PRE_COMMIT_HOOK`.

### Git statistics
* Show statistics for repository

      git stat <type>
               contributions # shows statistics for all authors or specified author (alias: contrib)
               commits       # shows number of commits for each author
               weekdays      # prints statistics for number of commits per weekday
               hour          # prints statistics for number of commits per hour
               files         # prints number of files and lines
               diff          # print stat of uncommitted changes
               log           # print log with stat
               modifie       # print stat of most modified files
show statistics for repository.
* `git churn` count number of changes for each file.

### git-story interactions
* `git gs-update` gets the latest version of _git-story_.
* `git gs-extend <extension-name>` add new _git-story_ extension to git.
* `git gs` list _git-story_ extensions.


## Configuration
For project specific configurations create a file named `.gitstoryrc` at the project's git root.

See full example with comments in [docs/gitstoryrc-example](https://github.com/buren/git-story/blob/master/docs/gitstoryrc-example).

Available options and their default value:

    GS_DEFAULT_REMOTE='origin'          # Default remote for git story
    GS_GIT_STORY_BRANCH='master'        # Target branch for 'dev' & 'done'
    GS_LOCAL_MERGE=false                # Perform local merge on 'done'
    GS_PRINT_CHECKLIST=false            # Print checklist before 'done'
    GS_PROMPT_ON_DONE=false             # Prompt user before 'done'
    GS_TEST_ON_DONE=true                # Run test dcommand before 'done'
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
    GS_GIT_STORY_EXT_BRANCH='master'    # Target branch for git-story extension
Default [config](https://github.com/buren/git-story/blob/master/config).

## Notes
* The software is supplied “as is” and all use is at your own risk (see [license](https://github.com/buren/git-story/blob/master/LICENSE))
* `git branch-status` requires Ruby 1.8.7 or greater
* Tested on Linux/OSX/Windows using both zsh, bash and cygwin*, doesn't work with sh.
* Almost everything works with cygwin except:
  * `git trail`
  * `git neck` both neck and trail fails on `git -p column`
  * `git browse` does nothing (`xdg-open`/`open` not available)
* Fork the repository and update the URL defined in [setup/install](https://github.com/buren/git-story/blob/master/setup/install#L2) to install and use your own version of _git-story_

## License
_git-story_ is released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
