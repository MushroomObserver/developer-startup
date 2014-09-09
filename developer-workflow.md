# developer-workflow #
This file describes the development workflow for the Mushroom Observer project.  We use a distributed workflow, known as "Integration-Manager" or "forking" workflow. See [Workflow][] below. 

This file assumes that you followed the directions in [README.md][] through [Create a user in the new instance of MO][] including setting up the VM by running `mo-dev /vagrant`.

## Configure Github and Git ##
- On [Github][], fork (create your own copy of) the [Official MO Repo][]. <br>
- In a new Terminal window on your local machine, switch to the mushroom-observer directory <br>
  `cd developer-startup/mushroom-observer`
- Add your personal [Github][] repository as a remote repository <br>
  `git remote add personal https://github.com/<YourGitUserName>/mushroom-observer.git`

## The Development Cycle ##
### Sync with the Official MO Repo ###
Synchronize your local machine, the VM, and your personal [Github][] to the [Official MO Repo][]. Use a [Git GUI][] or on your local machine:
````
git checkout master
git fetch origin
git merge origin/master
git push personal master
```

### Create a personal, feature branch ###
Create a new feature branch for your changes, and switch to that branch.  Use a [Git GUI][] or on your local machine: <br>
`git checkout -b <mybranch-name>`<br>
for example, `git checkout -b myfixes`

### Edit code ###
Your local machine's developer-startup directory has a 'mushroom-observer' sub-directory.  This is a 'shared folder' which mirrors /vagrant/mushroom-observer on the VM.  You can change code on one machine and it will appear on the other.

### Commit your changes to your personal machine ###
Work on your branch, e.g. _myfixes_.  Make commits using a [Git GUI][] or Git terminal commands on your local machine.  

When you are done with all your changes and are ready to contribute them to the Project, make sure they are all committed locally. Use a [Git GUI][] or on your local machine: <br>
`git commit -a -m "insert commit message"` <br>

### Contribute your changes to the MO Project ###
#### Re-sync with the [Official MO Repo][] ###
Make sure that your local commits are compatible with any changes to the [Official MO Repo][] since you last synced:
- Replay your local fixes on top of the [Official MO Repo][]. Use a [Git GUI][] or on your local machine: <br>
`git checkout myfixes` <br>
`git pull --rebase origin master` <br>
- **Fix any conflicts.**

#### Push your changes to your personal [Github][] repository ####
Use a [Git GUI][] or on your local machine  <br>
`git checkout myfixes` <br>
`git push personal myfixes` <br>

#### Create a Pull Request ####
- Go to your personal [Github][] repository and click on "Pull Request". 
- Switch to your feature branch
- Choose your feature branch in your personal [Github][] repo as the source branch
- Choose origin repo "master" as the destination branch. 
- For more information see [Using pull requests][].

- - -
# Notes #
## Workflow ##
![Integration-Manager-Workflow-Diagram](http://git-scm.com/figures/18333fig0502-tn.png)  
We use "integration-manager" or "forking" workflow.<br>
- Each developer:
  - Clones the official MO repository to the developer's local machine;
  - On the developer's local machine, creates a personal feature branch for the developer's changes;
  - Pushes the personal branch from the local machine to the developer's personal, publicly readable copy (fork) on [Github][];
  - Creates a pull request in [Github][].<br>
- A manager then
  - merges the developer's changes to the manager's local machine;
  - if the developer's changes are acceptable, pushes them to the official MO repository.

For more information, see [Integration-Manager Workflow][] and [Forking Workflow][]; _cf._ [What's the Workflow][].

## Git GUIs ##
Some developers primarily (or exclusively) use a Git GUI -- as opposed to typing Git commands at the terminal. Two free GUIs that have been found useful on the Mac are: [GitHub GUI][] and [SourceTree][].

- - -
[comment]: # (The following are link reference definitions)
[Create a user in the new instance of MO]: /README.md#create-a-user-in-the-new-instance-of-mo)
[Forking Workflow]: https://www.atlassian.com/git/workflows#!workflow-forking
[Git GUI]: /developer-workflow.md#git-guis/
[Github]: https://github.com/
[GitHub GUI]: https://central.github.com/mac/latest
[Initial Database]: /developer-workflow.md#intial-databse/ 
[Installing Ruby]: /developer-workflow.md#installing-ruby/ 
[Integration-Manager Workflow]: http://git-scm.com/book/en/Distributed-Git-Distributed-Workflows#Integration-Manager-Workflow
[Official MO Repo]: https://github.com/MushroomObserver/mushroom-observer
[PuTTY]: http://www.chiark.greenend.org.uk/~sgtatham/putty/
[README.md]: /README.md
[SourceTree]: http://www.sourcetreeapp.com
[Using pull requests]: https://help.github.com/articles/using-pull-requests
[What's the Workflow]: http://stackoverflow.com/questions/20956154/whats-the-workflow-to-contribute-to-an-open-source-project-using-git-pull-reque
[Workflow]: /developer-workflow.md#workflow/
