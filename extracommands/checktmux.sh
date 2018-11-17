#!/bin/sh

if [[ -z "$TMUX" ]]; then
	ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a detached session
	if [[ -z "$ID" ]]; then
		ID="$( tmux ls | grep -m1 attached | cut -d: -f1 )" # get the id of a any session (including attached sessions)
		if [[ -z "$ID" ]]; then
			tmux new-session # otherwise create a new session
		else
			tmux attach-session -t "$ID" # if we have any session, connect to that
		fi
	else
		tmux attach-session -t "$ID" # if we have a detached session, connect to that
	fi
else
	# we're already attached to a TMUX session
	echo "Connected" > /dev/null
fi