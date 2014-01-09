## Visual example
Goto http://pcottle.github.io/learnGitBranching/?NODEMO
type `import tree` in the console.

Then paste the below:

    {
      "branches": {
        "master": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C13",
          "id": "master",
          "type": "branch"
        },
        "story3": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C7",
          "id": "story3",
          "type": "branch"
        },
        "story7": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C10",
          "id": "story7",
          "type": "branch"
        },
        "story8": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C11",
          "id": "story8",
          "type": "branch"
        },
        "story13": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C15",
          "id": "story13",
          "type": "branch"
        },
        "story14": {
          "remoteTrackingBranchID": null,
          "remote": false,
          "target": "C14",
          "id": "story14",
          "type": "branch"
        }
      },
      "commits": {
        "C0": {
          "type": "commit",
          "parents": [],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:47:20 GMT+0100 (CET)",
          "commitMessage": "Quick commit. Go Bears!",
          "id": "C0",
          "rootCommit": true
        },
        "C1": {
          "type": "commit",
          "parents": [
            "C0"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:47:20 GMT+0100 (CET)",
          "commitMessage": "Quick commit. Go Bears!",
          "id": "C1"
        },
        "C2": {
          "type": "commit",
          "parents": [
            "C1"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:48:41 GMT+0100 (CET)",
          "commitMessage": "Update",
          "id": "C2"
        },
        "C3": {
          "type": "commit",
          "parents": [
            "C2"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:48:49 GMT+0100 (CET)",
          "commitMessage": "Update1",
          "id": "C3"
        },
        "C4": {
          "type": "commit",
          "parents": [
            "C1"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:49:19 GMT+0100 (CET)",
          "commitMessage": "Implement",
          "id": "C4"
        },
        "C5": {
          "type": "commit",
          "parents": [
            "C4"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:49:22 GMT+0100 (CET)",
          "commitMessage": "Implement more",
          "id": "C5"
        },
        "C6": {
          "type": "commit",
          "parents": [
            "C5"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:50:27 GMT+0100 (CET)",
          "commitMessage": "Implement",
          "id": "C6"
        },
        "C7": {
          "type": "commit",
          "parents": [
            "C3",
            "C5"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:50:54 GMT+0100 (CET)",
          "commitMessage": "Merge branch \"master\" into branch \"story3\"",
          "id": "C7"
        },
        "C8": {
          "type": "commit",
          "parents": [
            "C6"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:52:41 GMT+0100 (CET)",
          "commitMessage": "update",
          "id": "C8"
        },
        "C9": {
          "type": "commit",
          "parents": [
            "C5"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:53:10 GMT+0100 (CET)",
          "commitMessage": "'bug fix'",
          "id": "C9"
        },
        "C10": {
          "type": "commit",
          "parents": [
            "C9",
            "C7"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:53:20 GMT+0100 (CET)",
          "commitMessage": "Merge branch \"master\" into branch \"story7\"",
          "id": "C10"
        },
        "C11": {
          "type": "commit",
          "parents": [
            "C8",
            "C10"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:54:00 GMT+0100 (CET)",
          "commitMessage": "Merge branch \"master\" into branch \"story8\"",
          "id": "C11"
        },
        "C12": {
          "type": "commit",
          "parents": [
            "C11"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:54:20 GMT+0100 (CET)",
          "commitMessage": "'bug fix'",
          "id": "C12"
        },
        "C13": {
          "type": "commit",
          "parents": [
            "C12"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:55:00 GMT+0100 (CET)",
          "commitMessage": "'impl'",
          "id": "C13"
        },
        "C14": {
          "type": "commit",
          "parents": [
            "C13"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:55:39 GMT+0100 (CET)",
          "commitMessage": "'i'",
          "id": "C14"
        },
        "C15": {
          "type": "commit",
          "parents": [
            "C13"
          ],
          "author": "Peter Cottle",
          "createTime": "Thu Jan 09 2014 23:55:58 GMT+0100 (CET)",
          "commitMessage": "'update'",
          "id": "C15"
        }
      },
      "tags": {},
      "HEAD": {
        "id": "HEAD",
        "target": "story13",
        "type": "general ref"
      }
    }
