# admin-workflow #

Initial thoughts on what admin should do after receiving a Pull Request for a developer's feature branch.  I have not checked these for accuracy (do the commands accomplish what I say?), and I'm in the dark on best practices.

## Notify other admins that you are handling the request? ##
Perhaps notify everyone (other admins, the developer, all subscribers) by commenting on the Pull Request

## Initial review in [GitHub][] ##
Using the links in the Pull-Request email:
- Is the change desirable?  If not, comment on the request.
- Eyeball the diffs to see if the code is reasonable: Does it look like it will work? Is the quality reasonable?

## Review the changes on your local machine ##
(Nathan floated the idea that each admin should have two local MO repos:  (1) one for your own development work (and where you act like any other developer), (2) one for admin work (like checking and merging other developer's work).)

### Get the changes ###
- If you haven't done it already, add the developer's personal [GitHub][] repo as a remote of your local repo and get the developer's repo.  Then create a local feature branch and switch to it. Use a [Git GUI][] or:
```
git remote add <your name for the remote> git@github.com:<DeveloperGitUserName>/mushroom-observer.git
git fetch <remote> 
git checkout -b <branch> <remote>/<branch>
```
For instance, the following makes @JoeCohen's personal Github repository a remote (named "JoeCohen") of your local repo, and switches to its "myfix" branch:
```
git remote add git@github.com:JoeCohen/mushroom-observer.git
git fetch JoeCohen
git -b myfix JoeCohen/myfix
```
### Experiment with the changes ###

- run the MO test suite
- See if the change works as advertised
- Look for obvious bad side effects

## Add the changes to the [Official MO Repo][] ##
I'm again unsure of the best practice.  To be safe, it's probably best to  sync to the [Official MO Repo][] because if it changed, we need to make sure we're still compatible.  If everything's okay, merge the developer's work and push it to the [Official MO Repo][]. (If there are incompatibilties, either (a) the admin can fix them, complete the merge, and then push to the [Official MO Repo][], or (b) ask the developer to fix them.) Use a [Git GUI][] or 
```
git checkout master
git fetch origin
git merge origin/master
git merge <developer's feature branch>
git push orgin/master
```
Do we need to do anything in [Github][] or [Pivotal Tracker][]?

# References #
- [Git workflow][]
- [Integration-Manager Workflow][]
- [Maintaining a Project][]
- [Using pull requests][]

- - -
[comment]: # (The following are link reference definitions)
[Create a user in the new instance of MO]: /README.md#create-a-user-in-the-new-instance-of-mo)
[Forking Workflow]: https://www.atlassian.com/git/workflows#!workflow-forking
[Git fetch and merge]: http://longair.net/blog/2009/04/16/git-fetch-and-merge/
[Git GUI]: /developer-workflow.md#git-guis/
[Git workflow]: https://sandofsky.com/blog/git-workflow.html
[Github]: https://github.com/
[GitHub GUI]: https://central.github.com/mac/latest
[Initial Database]: /developer-workflow.md#intial-databse/ 
[Installing Ruby]: /developer-workflow.md#installing-ruby/ 
[Integration-Manager Workflow]: http://git-scm.com/book/en/Distributed-Git-Distributed-Workflows#Integration-Manager-Workflow
[Official MO Repo]: https://github.com/MushroomObserver/mushroom-observer
[Maintaining a Project]: http://git-scm.com/book/en/Distributed-Git-Maintaining-a-Project
[Pivotal Tracker]: https://www.pivotaltracker.com/n/projects/224629
[PuTTY]: http://www.chiark.greenend.org.uk/~sgtatham/putty/
[README.md]: /README.md
[SourceTree]: http://www.sourcetreeapp.com
[Using pull requests]: https://help.github.com/articles/using-pull-requests
[What's the Workflow]: http://stackoverflow.com/questions/20956154/whats-the-workflow-to-contribute-to-an-open-source-project-using-git-pull-reque
[Workflow]: /developer-workflow.md#workflow/

  
