#!/bin/bash

# script to sync changes from the upstream project to this fork (using "master" to track the changes)
# and rebase the "hardened" (default) branch on top of the imported changes

set -e  # stop on first error

echo "Fetching upstream..."
git fetch upstream

echo "Updating master..."
git switch master
git merge upstream/master --ff-only
git push origin master

echo "Syncing submodules..."
git submodule update --init --recursive

echo "Rebasing hardened..."
git switch hardened
git rebase master
git push origin hardened --force-with-lease

echo "Done. All branches up to date."