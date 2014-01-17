# git-story (beta)


Simplified git workflow.
Branch strategy based on [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html).

* [Installation](#install-git-story)
* [Example](#example)
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

## Example

    gs dev branch_name                     # Sets up clean workspace based of remote master.
    gs commit "Commit message"             # Commit changes locally.
    gs done "Commit message"               # Commit changes, update master and merge with repository.

## Documentation

* Start developing a feature

        gs dev <branch_name>
        gs dev <branch_name> <base_branch>
this will create a new branch <branch_name> based of master or specified <base_branch>. If the branch exists on remote pull the latest changes. Ensures the uniqueness of branch name at remote. Pushes the newly created branch to remote.
Alias: feature
* Commit your changes

        gs commit <commit_message>
comment and commit to the changes you've made.
Alias: checkpoint
* Commit and sync with repository

        gs done <commit_message> <target_branch>
comment and commit the changes you've made and merge changes made on <target_branch>.
`<target_branch>` is optional and defaults to 'master'.
If no merge conflicts; make a pull request `gs pull-request`. Otherwise fix all merge conflicts and run `gs done "Fixed merge conflicts for ..."` and then `gs pull-request`.
Alias: release
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
show statistics for repository.
Alias: statistics
Available commands:
⋅⋅* `gs stat contributions <author>` shows statistics for all authors or specified author (alias: contrib)
⋅⋅* `gs stat commits` shows number of commits for each author.
⋅⋅* `gs stat weekdays` prints statistics for number of commits per weekday.
⋅⋅* `gs stat hour`     prints statistics for number of commits per hour.

## Notes
Overides ```gs``` (Ghostscript) on Linux.

## License
Released under the [MIT License](https://github.com/buren/git-story/blob/master/LICENSE).
