#!/bin/bash

MASTER=""
FORK=""
FOLDER=""

function create_folder() {

  mkdir $1
  git clone $2 $1
  cd $1
}

function add_upstream() {

  # Add the remote, call it "upstream":
  git remote add upstream $1
  # Fetch all the branches of that remote into remote-tracking branches,
  # such as upstream/master:
  git fetch upstream
  # Make sure that you're on your master branch:
  git checkout master
  # merge changes
  git merge upstream/master
  # push to fork
  git push -f origin master
}


function print_help() {

	echo -e "Pass <script> \n 
		-m master-git \n
		-f fork-git \n
		-d dir \n
		-h printhelp and exit \n
		-r rebase with master-git in the current \n
	       	directory which is a fork  \n
		-a do all the stuff. Create folder checkout rebase \n"
}

 echo "Checking args"
  while getopts "m:f:d:rha" opt; do
    case $opt in
      m)
	MASTER=$OPTARG
        echo "Master set to $MASTER" >&2
	;;
      f)
	FORK=$OPTARG
        echo "Fork set to $FORK" >&2
	;;
      d)
	FOLDER=$OPTARG
        echo "Creating Folder $FOLDER ..." >&2
	;;
       r)
        echo "Rebasing folder $FOLDER with upstream $MASTER..." >&2
        add_upstream $MASTER
	;;
       h)
        echo "Help!" >&2
	print_help
	;;
       a)
	echo "Running Everything together"
        create_folder $FOLDER $FORK
        add_upstream $MASTER
	;;
      \?)
	echo "Invalid option: -$OPTARG" >&2
	;;
    esac
  done

  
