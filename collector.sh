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
export JAVA_HOME=/usr/java/jre
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:/opt/ruei/processor/bin:/opt/ruei/bin
export PATH
umask 027
source /etc/ruei.conf
source $RUEI_HOME/bin/env.sh



start() {
	appsensor start wg	        
}

stop() {
        appsensor stop wg
}


status() {

        COLLECTOR_status=`appsensor status wg | awk '{print $2}'`
	COLLECTOR_PID=`ps -fea | grep "/opt/ruei/collector/lib64/appsensor/panther --Instance=wg" | grep -v grep | awk '{print $2}'`
        if [[ $COLLECTOR_status == "enabled" ]]
                then
                        echo "The collector service is $COLLECTOR_status in PID:"
                        echo "$COLLECTOR_PID"
                else
                        echo "The collector service isn't running"
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