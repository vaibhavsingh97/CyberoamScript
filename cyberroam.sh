#!/bin/bash
#############################################
## (c) 2016 Vaibhav Singh                  ##
## Author by Vaibhav Singh                 ##
#############################################
LOGFILE=($HOME)/.cyberoamlog
OUTPUT=/tmp/.cyberoamout
CONFIGFILE=($HOME)/client.conf

ACTION=NULL
MODE=0
RETCODE=0
MESSAGE_LOGIN=="You have successfully logged in"
TEMP=1
PARAM=inputParameters
EXPLICIT=NULL

#Server configuration file
USERNAME=username
PASSWORD=password
SERVER=server
PORT=port
PAGE=page

Error(){
    echo -n "Error: "
    case $RETCODE in
      1) echo "Something went wrong. Wget failed";;
      2) echo "Parse error in wget command. Please test  check command options.";;
      3) echo "File I/O error in Wget. Please ensure that the script has read and write permission in $HOME and /tmp";;
      4) echo "Netwok Failure. Could not connect to server.";;
      5) echo "SSL Verification Failure.Why are you trying to use SSL anyways.";;
      6) echo "username/password Authentication failure. If you get this message, you mannaged to send authentication tokens seperately apart from POSt request. Please contact me with the patch!";;
      7) echo "Unknown Protocol error.";;
      8) echo "Server returned an error.";;
      201) echo ${RESPONSE};;
      205) echo "Could not locate Wget on our system. Please that you have Wget installed.";;
      206) echo "Unknown parameter input.";;
      207) echo "The Configuration file could not be read correctly. If you recently updated the script, please generate a new conf file by deleting ${CONFIGFILE}";;
      *) echo "known error. Please send your $LOGFILE to <vaibhav.singh.14cse@bml.edu.in> for analysis";;
 esac
 rm ${OUTPUT} 2> /dev/null
 exit $RETCODE
}
login(){
  ACTION=Login
  Mode=191
  wget --timeout=10 --tries=3 -d --post-data="username=${USERNAME}&password=${PASSWORD}&mode=${MODE}&btnsubmit=${ACTION}" "http://${SERVER}:${PORT}/${PAGE}" -0 ${OUTPUT} -o ${LOGFILE} 2> /dev/null
  RETCODE=$?
  if ["$RETCODE" -gt 0];
   then
    error
  fi
  RESPONSE=`cat ${OUTPUT}| sed 's/<message><!\[CDATA\[/&\n/;s/.*\n//;s/]]><\/message>/\n&/;s/\n.*//'`
  if ["$RESPONSE"=="$ {MESSAGE_LOGIN}"];
   then
    echo "Logged In"
  else
    RETCODE=201
    error
  fi
}
