#!/bin/bash

USERNAME_FILENAME="username.file"
JOKES_SCRIPT_PATH="resources/jokes/jokes.sh"
WEATHER_SCRIPT_PATH="resources/weather/weather.sh"
ACTIVITY_SCRIPT_PATH="resources/activity/activity.sh"
LYRICS_FOLDER_PATH="resources/lyrics"
IS_NUMBER_EXPR='^[0-9]+$'
MAIN_MENU_EXIT_VALUE=1


USERNAME=$(<$USERNAME_FILENAME)

if [ -z $USERNAME ]
then
	echo "Application is not installed. Exiting..."
	sleep 0.8
	exit 0
fi

echo "Hello there $USERNAME"

#Functions
function displayMenu () {
	declare -a menuItems=( 'Show me the weather for next week!' 'Tell me a joke!' 'Show me the date!' 'Show me song lyrics!' 'Whan activity could I do today?' )

	COUNTER=1
	for ((i=0; i < ${#menuItems[@]}; i++))
	do
		echo "($COUNTER) ${menuItems[$i]}"
		((COUNTER++))
	done

	((MAIN_MENU_EXIT_VALUE=COUNTER))

	echo "($COUNTER) Exit"
}

function checkAndExecScript () {
	FILEPATH=$1
	if ! [ -f $FILEPATH ]
        then
                echo "$FILEPATH does not exist"
        elif ! [ -x $FILEPATH ]
        then
                echo "You do not have the permission to execute $FILEPATH"
        else
                source $FILEPATH
        fi
}

function displaySongList () {
	songFiles=$1
	
	echo ""
        echo "--------SONG LIST---------"
	COUNTER=1
        for ((i=0; i<${#songFiles[@]}; i++))
        do
                echo "($COUNTER) ${songFiles[$i]}"
        	((COUNTER++))
        done
        echo "($COUNTER) Go back"
	echo "--------------------------"
}

function displaySongListMenu () {
	songFiles=($(ls $LYRICS_FOLDER_PATH))

	while true
	do	
		displaySongList $songFiles

		read -p "Choose a song to display its lyrics or choose 'Go back' to return to the main menu: " SONGOPTION

		case "$SONGOPTION" in
		"$COUNTER")
			echo "Exiting song menu"
			sleep 0.8
			break;;
		*)
			sleep 0.8
			if [[ $SONGOPTION =~ $IS_NUMBER_EXPR && $SONGOPTION -ge 0 && $SONGOPTION -lt ${#songFiles[@]} ]]
			then
				((SONGOPTION--))
				echo ""
				cat $LYRICS_FOLDER_PATH/${songFiles[$SONGOPTION]}
				echo ""
				read -n 1 -r -s -p "Press any key to display song selection menu..." key
			else				
	                	echo "Please input a correct value!"
			fi
		esac
	done
}

#

#Logic
while true
do
	echo ""
	echo "*********************************"
	echo "How can I help you today?"
        
	displayMenu
	
        read -p "Choose an option: " OPTION
	echo "*********************************"
	echo ""

        case "$OPTION" in
	"1")
		sleep 0.8
		checkAndExecScript $WEATHER_SCRIPT_PATH
		;;
	"2")
		sleep 0.8
		checkAndExecScript $JOKES_SCRIPT_PATH
		;;
	"3")
		sleep 0.8
		echo "Today's date is $(date)"
		;;
	"4")	
		sleep 0.8
		displaySongListMenu
		;;
	"5")
		sleep 0.8
		checkAndExecScript $ACTIVITY_SCRIPT_PATH
		;;
	"$MAIN_MENU_EXIT_VALUE")
		sleep 0.8
                echo "Exiting, goodbye $USERNAME!"
                exit 0;;
	*)  
		sleep 0.8
            	echo "Please input a correct value!"
        esac
done
