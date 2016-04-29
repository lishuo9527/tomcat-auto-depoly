#!/bin/bash

#################################
# Tomcat自动部署脚本
#
# Auhthor: lis
# Date: 2016-04-29
################################

usage()
{
    echo "Usage: ${0##*/} [projName] [deploy] | deploy the specified project "
	echo "       ${0##*/} [start|stop|restart] | start or stop or restart tomcat" 
    exit 1
}

deploy()
{
	echo 'step1) stop tomcat'
	pid=`ps aux|grep java|grep $tomcatPath|awk '{printf $2}'`
	kill -9 $pid
	echo 'stop tomcat finished...Done! '

	echo 'step2) start tomcat'
	rm -rf $tPath
	rm -rf $tWar
	cp $fWar $tWar
	echo 'copy $projName.war file ... Done!'

	bash $tomcatPath/bin/startup.sh
	echo 'Done!'

	echo 'show logs? y/n'
	read command
	if [ "$command" == "y" ]; then
		tail -f $tomcatPath/logs/catalina.out
	fi
}

restart()
{
	echo 'step1) stop tomcat'
	pid=`ps aux|grep java|grep $tomcatPath|awk '{printf $2}'`
	kill -9 $pid
	echo 'stop tomcat finished...Done! '

	echo 'step2) start tomcat'
	bash $tomcatPath/bin/startup.sh
	echo 'Done!'

	echo 'show logs? y/n'
	read command
	if [ "$command" == "y" ]; then
		tail -f $tomcatPath/logs/catalina.out
	fi
}

start()
{
	echo 'start tomcat...'
	bash $tomcatPath/bin/startup.sh
	echo -n 'Done!'

	echo 'show logs? y/n'
	read command
	if [ "$command" == "y" ]; then
		tail -f $tomcatPath/logs/catalina.out
	fi
}

stop()
{
	echo 'stop tomcat...'
	pid=`ps aux|grep java|grep $tomcatPath|awk '{printf $2}'`
	kill -9 $pid
	echo 'Done! '
}

## project name
projName=$1

## FTP 上传路径
ftpPath=/usr/local/tomcat/temp
fWar=$ftpPath/$projName.war

## tomcat 路径
tomcatPath=/usr/local/tomcat
tPath=$tomcatPath/$projName
tWar=$tomcatPath/$projName.war


if [ "$2" == "deploy" ]; then
    deploy
elif [ "$1" == "restart" ]; then 
    restart
elif [ "$1" == "start" ]; then 
    start
elif [ "$1" == "stop" ]; then 
    stop
else
    usage
fi