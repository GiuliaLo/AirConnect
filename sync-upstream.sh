# script to sync changes from the upstream project to this fork (using "master" to track the changes)
# and rebase the "hardened" (default) branch on top of the imported changes
git fetch upstream
git switch master && git merge upstream/master --ff-only && git push origin master
git switch hardened && git rebase master && git push origin hardened --force-with-lease