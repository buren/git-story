# git-story (alpha)


Simplified git workflow.

## Example
Simplified branch strategy, based on [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html).

    $ gs dev branch_name                     # Sets up clean workspace based of remote master
    $ gs checkpoint "Commit message"         # Commit changes locally
    $ gs done "Commit message"               # Commit changes, merge with master

## Caution
Overides ```gs``` (Ghostscript) command on Linux.
