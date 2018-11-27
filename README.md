# git-story

Various extensions to git, documented below.


* [Installation](#install-git-story)
* [Getting Started](#getting-started)
* [Example](#example)
* [Configuration](#configuration)
* [Documentation](#documentation)
  * [Branching extensions](#branching-extensions)
  * [Convenience extensions](#convenience-extensions)
  * [Log extensions](#log-extensions)
  * [Project integration extensions](#project-integration-extensions)
  * [Statistics extensions](#statistics-extensions)
  * [git-story interactions](#git-story-interactions)
  * [Misc](#misc)
* [Notes](#notes)
* [License](#license)

## Install git-story
```bash
curl -L https://raw.githubusercontent.com/buren/git-story/master/setup/install | bash
```
The above command will install and inject an import of the git-story script to either `.bash_profile`, `.bashrc` or `.zshrc` (in that order).  See [install script](https://github.com/buren/git-story/blob/master/setup/install) for details.

Reload your shell to initialize git-story extensions.

## Getting started


Branch model:

1. Start developing a feature, and name it `git feature <name>`
2. Save local changes and sync with remote `git finish`
3. Create a pull request

The principle is that you develop each new feature in its own branch and when
you're done you push it and create a pull request. See [GitHub flow](http://scottchacon.com/2011/08/31/github-flow.html) branch model.
Note that `git feature` and `git finish` are flexible. They both take an optional argument _target-branch_, which the current/new branch will sync with.

## Example
```bash
$ git feature branch-name   # Sets up clean workspace based on remote master.
$ git finish              # Commit changes, updates current and local branch.
```
Output [example](http://showterm.io/ec6267151db96042b6cf8) (video).

## Documentation

Print command usage:
```bash
$ git <git-story-extension> --usage
```
### Branching extensions

* Start developing a feature
  ```bash
  $ git feature <branch-name> <target-branch>
  ```
  this will create a new branch _branch-name_ based of master or specified _target-branch_. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the created branch to remote.
  Executes:
  1. Checkout _target-branch_
  2. Pull _target-branch_
  3. Create new branch _branch-name_
  4. Push _branch-name_

* Commit and sync with repository
  ```bash
  $ git finish <target-branch>
  ```
  commit the changes you've made and merge changes with _target-branch_.
  _target-branch_ is optional and the default is _target-branch_.
  Executes:
  1. Prompt commit message if any uncommitted changes
  2. Pull current branch
  3. Pull _target-branch_
  4. Push current branch
  5. Perform local merge with _target-branch_ if configured
will exit and print conflicted files if any merge conflicts are found.

* `git branch-status` shows current branch status.
* `git pull-branch` pull current, or specified, branch's remote changes.
* `git create-branch` create and checkout a new branch and push to remote.
* `git push-branch` push the current branch to remote.
* `git delete-branch` delete branch from remote and local.
* `git delete-merged` delete all merged branches locally and at remote.


### Convenience extensions
* `git addcom` add all files and commit.
* `git fuckit` commit all files and push current branch. Default is to prompt for commit message.
* `git redo-commit` redo last commit.
* `git goto <branch-name>` switches to branch _branch-name_ if the working directory is clean.
* `git abort-merge` aborts current merge.
* `git obliterate` remove file from local repository and its entire history.
* `git zip-project` create zip-file of project.
* `git ignore` add and list patterns to local and global gitignore.
* `git ignore-boilerplate` easy access to gitignore boilerplates from github.com/github/gitignore.
* `git conflicted` list files with merge-conflicts.
* `git todos` list all TODOS and FIXMES.
* `git tag-release` create a new tagged release.
* `git rename-tag` rename an existing release.
* `git changelog` print change log from last tag.
* `git squash-commits` squash given number of commits together.

### Log extensions
* `git history` view repository commit history.
* `git trail` shows the last common commit with current branch.
* `git neck` show commits until first branching point.
* `git divergence` show the difference between current branch and the same branch at remote.
* `git local-commits` show local commits that haven't been pushed to remote.
* `git commits-since` show commits since given time.

### Project integration extensions
* `git browse`  opens the repository on GitHub.
* `git package` package project, runs `GS_PACKAGE`.
* `git deploy` package project, runs `GS_DEPLOY`.
* `git install-project` install project, runs `GS_INSTALL`.
* `git test`    package project, runs `GS_PRE_COMMIT_HOOK`.
* `git tag-release` tags release, runs `GS_TAG_RELEASE`.

### Statistics extensions
* Show statistics for repository

        git stat <type>

        types:
          contrib <name> # shows statistics for all or specified author (alias: contributions)
          commits        # shows number of commits for each author
          weekdays       # prints statistics for number of commits per weekday
          hour           # prints statistics for number of commits per hour
          files          # prints number of files and lines
          diff           # Print stat of uncommitted changes
          log            # Print log with stat
          modified       # Print stat of most modified files

  prints statistics of given type.
* `git churn` count number of changes for each file.
* `git effort` like churn, but prettier and with active day count.
* `git summary` show summary for current project.

### git-story interactions
* `git gs-update` gets the latest version of git-story.
* `git gs-extend <extension-name>` add new git-story extension to git.
* `git gs` list git-story extensions.

### Misc
* `git repl` git read-eval-print-loop (REPL).


## Configuration
Configure `git-story` by creating a file `~/.gitstoryrc`
For project specific configurations create a file named `.gitstoryrc` at the project's git root.

See full example with comments in [docs/gitstoryrc-example](https://github.com/buren/git-story/blob/master/docs/gitstoryrc-example).

Available options and their [default](https://github.com/buren/git-story/blob/master/config) value:

    GS_DEFAULT_REMOTE='origin'          # Default remote for git story
    GS_GIT_STORY_BRANCH='master'        # Target branch for 'feature' & 'finish'
    GS_LOCAL_MERGE=false                # Perform local merge on 'finish'
    GS_PRINT_CHECKLIST=false            # Print checklist before 'finish'
    GS_GRAPHIC_PROMPT=false             # Show all prompts (on OSX) in a GUI dialog
    GS_PROMPT_ON_DONE=false             # Prompt user before 'finish'
    GS_TEST_ON_DONE=true                # Run test command before 'finish'
    GS_SIGN_RELEASE=true                # Sign tags created with 'tag-release'
    GS_SIGN_COMMITS=true                # Sign each commit created with addcom, with GPG-key
    GS_SIGN_COMMITS_STRING=true         # Sign each commit created with addcom, with --signoff
    GS_CHECKLIST_MESSAGE='...'          # Checklist string for 'finish'
    GS_PRE_COMMIT_HOOK=''               # A command that runs all tests
    GS_PACKAGE=''                       # Shell command for 'package'
    GS_DEPLOY=''                        # Shell command for 'deploy'
    GS_TAG_RELEASE=''                   # Shell command for 'tag-release'
    GS_INTSALL=''                       # Shell command for 'install'
    GS_HAS_GITHUB=true                  # Project has GitHub.
    GS_PROJECT_URL=''                   # Project URL
    GS_TEST_ON_AUTO_MERGE=true          # Run tests command on auto merge
    GS_PRODUCTION_BRANCH='heads/master' # Integration branch for production
    GS_NEXT_VERSION_BRANCH=''           # Integration branch for next
    GS_EDGE_BRANCH=''                   # Integration branch for edge
    GS_GIT_STORY_EXT_BRANCH='master'    # Target branch for git-story extension

## Notes
* The software is supplied “as is” and all use is at your own risk (see [license](https://github.com/buren/git-story/blob/master/LICENSE))
* `git branch-status` requires Ruby 1.8.7 or greater
* Tested on Linux/OSX/Windows using both zsh, bash and cygwin*, doesn't work with sh.
* Almost everything works with cygwin except:
  * `git trail`
  * `git neck` both neck and trail fails on `git -p column`
* Fork the repository and update the URL defined in [setup/install](https://github.com/buren/git-story/blob/master/setup/install#L2) to install and use your own version of git-story
* Thanks:
  * [visionmedia/git-extras](https://github.com/visionmedia/git-extras)
  * [cypher/dotfiles](https://github.com/cypher/dotfiles)
  * [simonwhitaker/gibo](https://github.com/simonwhitaker/gibo/)
* Uninstall git-story: `rm -rf ~/.git-story`


## License
git-story is released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
