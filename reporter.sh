#!/bin/bash
###
### Script created by dAtUmErA
###

###
### Color definition
###
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 6`
yellow=`tput setaf 3`
orange=`tput setaf 131`
action=`tput setaf 132`
reset=`tput sgr0`

###
### Grant execution only for moniforce user
###
if [ $(whoami) != 'moniforce' ]; then
        echo "${red}ERROR${reset}: Debes utilizar el usuario moniforce para ejecutar el script $0"
        exit 1;
fi

###
### Script should include parameters 
###
if [[ $1 == "" ]]; then
        echo "${red}ERROR${reset}: El script $0 debe ir acompañado de los argumentos start , stop o status. "
        exit 1;
fi

###
### Load profile 
###
JAVA_HOME=/usr/java/jre
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:/opt/ruei/processor/bin:/opt/ruei/bin
export PATH
umask 027
source /etc/ruei.conf
source $RUEI_HOME/bin/env.sh


start() {
	project -start
}

stop() {
	project -stop	
}


status() {

    QJOBD_status=`ps -fea | grep -i qjobd | grep -v grep | grep -v defunct | awk '{print $2 , $8}'`
	LOGR_status=`ps -fea | grep -i logr | grep -v grep | grep -v defunct | awk '{print $2 , $8 , $9}' | grep -v lockexec`
	RSYNCLOGDIRD_status=`ps -fea | grep -i rsynclogdird | grep -v grep | grep -v defunct | awk '{print $2 , $8}' | grep -v lockexec`
	LOGMSGD_status=`ps -fea | grep -i logmsgd | grep -v grep | grep -v defunct | awk '{print $2 , $8}'`
	
	if [[ $QJOBD_status != "" ]]
                then
                        echo "The qjobd service is running at PID:"
			echo "$QJOBD_status"
                else
                        echo "The qjobd service isn't running"
        fi

        if [[ $LOGR_status != "" ]]
                then
                        echo "The logr service is running in the following PIDs:"
                        echo "$LOGR_status"
                else
                        echo "The logr service isn't running"
        fi

        if [[ $RSYNCLOGDIRD_status != "" ]]
                then
                        echo "The rsynclogdird service is running at PID:"
                        echo "$RSYNCLOGDIRD_status"
                else
                        echo "The rsynclogdird service isn't running"
        fi

        if [[ $LOGMSGD_status != "" ]]
                then
                        echo "The logmsgd service is running at PID:"
                        echo "$LOGMSGD_status"
                else
                        echo "The logmsgd service isn't running"
        fi

	if [[ $QJOBD_status != "" && $LOGR_status != "" && $RSYNCLOGDIRD_status != "" && $LOGMSGD_status != "" ]]
		then
			echo "Reporter services are running successfully"
		else 
			echo "Reporter services are down"
		fi
}



case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Invalid parameter"
        exit 1
        ;;
esac

exit 0