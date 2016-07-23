#!/bin/bash
TYPE=$1
if [ "$TYPE" == "feat" ]; then
	MESSAGE="a new feature"
elif [ "$TYPE" == "fix" ]; then
	MESSAGE="a bug fix"
elif [ "$TYPE" == "docs" ]; then
	MESSAGE="changes to documentation"
elif [ "$TYPE" == "style" ]; then
	MESSAGE="formatting, missing semi colons, etc; no code change"
elif [ "$TYPE" == "refactor" ]; then
	MESSAGE="refactoring production code"
elif [ "$TYPE" == "test" ]; then
	MESSAGE="adding tests, refactoring test; no production code change"
elif [ "$TYPE" == "chore" ]; then
	MESSAGE="updating build tasks, package manager configs, etc; no production code change"
elif [ "$TYPE" == "ui" ]; then
	MESSAGE="changes to UI; mostly XML changes"
else
	MESSAGE="nothing"
fi

if [ "$MESSAGE" == "nothing" ]; then
	echo "commit help"
	echo "feat - a new feature"
	echo "fix - a bug fix"
	echo "docs - cahnges to documentation"
	echo "style - formatting, missing semi colons, etc; no logical code change"
	echo "refactor - refactoring production code"
	echo "test - adding tests, refactoring test; no production code change"
	echo "chore - updating build tasks, package manager configs, etc; no production code change"
	echo "ui - changes to UI; mostly XML changes"
	exit
else 

	ARE_THERE_UNSTAGED_FILES=$(git status | grep "Changes not staged for commit" | wc -l)
	if [ "$ARE_THERE_UNSTAGED_FILES" == "       1" -o "$ARE_THERE_UNSTAGED_FILES" == "1" ]; then
		echo "There are unstaged files in the current branch, do you want to add all and proceed ? [y/n]"
		read choice
		if [ "$choice" == "y" -o "$choice" == "Y" ]; then
			$( git add --all )
		else 
			exit
		fi

	else 
		echo "We are Good"
	fi
	echo "Committing $MESSAGE"
fi

echo "Enter a commit message:"
read commitmessage
git commit -m "$TYPE: $commitmessage"
git push -u origin master
