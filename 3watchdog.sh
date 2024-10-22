#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

WATCHDOG_VERSION="1.4"
SUB_VERSION="7"

# 0rig
ZRIG="/media/ramdisk/0rig*"
zrig=$(sed -e 's/\r$//' $ZRIG)
USER_ID=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="USER_ID"{printf("%s ", $4)}' | xargs)
RIG_NUMBER=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="RIG_NUMBER"{printf("%s ", $4)}' | xargs)
CUSTOMER_KEY=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="CUSTOMER_KEY"{printf("%s ", $4)}' | xargs)
OVERLORD=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="OVERLORD"{printf("%s ", $4)}' | xargs)
HASH_COUNT="1"
LOG=""
TIME="FIRST"
COINCHANGE=1
HASHRATE=0
itr=0
RIG_LOG=""
last_edit=000000
LAST_EDIT=000001
AUTH=$CUSTOMER_KEY
getRigs()
{
LOGGED_IN=$(/usr/bin/curl --header "Authorization: $AUTH" $OVERLORD/loggedin/$USER_ID)
LOGGED_IN=${LOGGED_IN:1:1}
if [[ $LOGGED_IN == "1" || $itr == 0 ]]
then
LAST_EDIT=$(/usr/bin/curl --header "Authorization: $AUTH" $OVERLORD/last_edit/$USER_ID)
LAST_EDIT=${LAST_EDIT:1:6}
echo $last_edit > /media/ramdisk/last_edit
echo $LAST_EDIT > /media/ramdisk/LAST_EDIT
if [[ $LAST_EDIT > $last_edit ]]
then
last_edit=$LAST_EDIT
TIME=$(date +%H%M%S)
echo $TIME > /media/ramdisk/inLAST_EDIT
AUTH="${CUSTOMER_KEY}"
RIGS=$(/usr/bin/curl --header "Authorization: $AUTH" $OVERLORD/user/$USER_ID/rigs)
sleep 2
t=$RIGS
t=${t// /}
t=${t//,/ }
t=${t##[}
t=${t%]}
eval a=($t)
target=$(($RIG_NUMBER - 1))
RIG=$(/usr/bin/curl --header "Authorization: $AUTH" $OVERLORD${a[target]})
var=RE2UNIX
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RE2UNIX=${b[1]}

var=DEV_WATCH
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
DEV_WATCH=${b[1]}

var=NANOPOOL_EMAIL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
NANOPOOL_EMAIL=${b[1]}
var=VERSION
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
VERSION=${b[1]}
var=EMAIL_UPDATES
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
EMAIL_UPDATES=${b[1]}


var=RVN_POOL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_POOL=${b[1]}

var=RVN_ADDRESS
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_ADDRESS=${b[1]}

var=CHATID
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
CHATID=${b[1]}
var=APIKEY
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
APIKEY=${b[1]}
var=COIN
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
COIN=${b[1]}
var=REBOOT
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
REBOOT=${b[1]}
var=UPDATE
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
UPDATE=${b[1]}

var=self
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
SELF=${b[1]}

var=X16R_SPECIFIC_OC_SETTINGS
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
X16R_SPECIFIC_OC_SETTINGS=${b[1]}



INDEX=$(echo $RIG | grep -aob "CLIENT_ARGS" | grep -oE '[0-9]+' | tail -n1)
CLIENT_ARGS=${RIG:$INDEX:250}
INDEX2=$(echo $CLIENT_ARGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CLIENT_ARGS=${RIG:$INDEX:INDEX2}
CLIENT_ARGS=${CLIENT_ARGS:16:INDEX2}
CLIENT_ARGS='"'$CLIENT_ARGS

INDEX=$(echo $RIG | grep -aob "CLIENT" | grep -oE '[0-9]+' | tail -n1)
CLIENT=${RIG:$INDEX:250}
INDEX2=$(echo $CLIENT | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CLIENT=${RIG:$INDEX:INDEX2}
CLIENT=${CLIENT:11:INDEX2}
CLIENT='"'$CLIENT

INDEX=$(echo $RIG | grep -aob "CLIENT_OC" | grep -oE '[0-9]+' | tail -n1)
CLIENT_OC=${RIG:$INDEX:38}
INDEX2=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
CLIENT_OC=${RIG:$INDEX:INDEX2}
CLIENT_OC=${CLIENT_OC:14:INDEX2}
CLIENT_OC='"'$CLIENT_OC
fi ## if [[ $LAST_EDIT > $last_edit ]]
fi ## if [[ $LOGGED_IN == "1" || $itr == 0 ]]
}
getRigs
itr=1
min_count=0


sendDataInit()
{
TIME=$(date +%H%M%S)
OUT=$(tail -10 /media/ramdisk/screenlog.0)
if [[ $COIN == "CLIENT" && $CLIENT == '"xmrstak"' ]]
then
OUT=$(tail -10 /media/ramdisk/xmrstak/screenlog.0)
fi
rig_log="${OUT//$'\n'/<br />}"
rig_log="${rig_log//$'[39m'/ }"
rig_log="${rig_log//$'[0m'/ }"
rig_log="${rig_log//$'[32m'/ }"
rig_log="${rig_log//$'[0;97m'/ }"
rig_log="${rig_log//$'[0;36m'/ }"
rig_log="${rig_log//$'[0;93m'/ }"
rig_log="${rig_log//$'[0;91m'/ }"
rig_log="${rig_log//$'[49m'/ }"
rig_log="${rig_log//$'[33m'/ }"
rig_log="${rig_log//$'[1;'/ }"
rig_log="${rig_log//$'[36m'/ }"
rig_log="${rig_log//$'[37m'/ }"
rig_log="${rig_log//$'[97m'/ }"
rig_log="${rig_log//$'[30m'/ }"
rig_log="${rig_log//$'[35m'/ }"
rig_log="${rig_log//$'[94m'/ }"
rig_log="${rig_log//$'[31m'/ }"
rig_log="${rig_log//$'[36m'/ }"

#rig_log=$(echo $rig_log | sed 's/\x1b\[[0-9;]*[mGKH]//g' | sed 's/\x1b\[[0-9;]*[mGKF]//g')
rig_log=$(echo $rig_log | sed 's/[^[:print:]\r\t]/ /g' | tr -d '\r')
echo ${rig_log} > /media/ramdisk/rig_log
MSG='{"HASHRATE": "0", "CYCLE": "'$TIME'", "RIG_LOG": "'${rig_log}'"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
}


sendDataCur()
{
HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", $HASHRATE}")
echo $HASHRATE > /media/ramdisk/HASHRATE
sleep 1
TIME=$(date +%H%M%S)
OUT=$(tail -10 /media/ramdisk/screenlog.0)
if [[ $COIN == "CLIENT" && $CLIENT == '"xmrstak"' ]]
then
OUT=$(tail -10 /media/ramdisk/xmrstak/screenlog.0)
fi
rig_log="${OUT//$'\n'/<br />}"
rig_log="${rig_log//$'[39m'/ }"
rig_log="${rig_log//$'[0m'/ }"
rig_log="${rig_log//$'[32m'/ }"
rig_log="${rig_log//$'[0;97m'/ }"
rig_log="${rig_log//$'[0;36m'/ }"
rig_log="${rig_log//$'[0;93m'/ }"
rig_log="${rig_log//$'[0;91m'/ }"
rig_log="${rig_log//$'[49m'/ }"
rig_log="${rig_log//$'[33m'/ }"
rig_log="${rig_log//$'[1;'/ }"
rig_log="${rig_log//$'[36m'/ }"
rig_log="${rig_log//$'[37m'/ }"
rig_log="${rig_log//$'[97m'/ }"
rig_log="${rig_log//$'[30m'/ }"
rig_log="${rig_log//$'[35m'/ }"
rig_log="${rig_log//$'[94m'/ }"
rig_log="${rig_log//$'[31m'/ }"
rig_log="${rig_log//$'[36m'/ }"

#rig_log=$(echo $rig_log | sed 's/\x1b\[[0-9;]*[mGKH]//g' | sed 's/\x1b\[[0-9;]*[mGKF]//g')
rig_log=$(echo $rig_log | sed 's/[^[:print:]\r\t]/ /g' | tr -d '\r')
echo ${rig_log} > /media/ramdisk/rig_log
MSG='{"HASHRATE": "'$HASHRATE'", "CYCLE": "'$TIME'", "RIG_LOG": "'${rig_log}'"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
}

updateCHECK()
{
echo "updateCHECK"
HASH=1
last_CHATID=$CHATID
last_APIKEY=$APIKEY
last_COIN=$COIN
last_REBOOT=$REBOOT
last_CLIENT=$CLIENT
last_UPDATE=$UPDATE
last_RVN_ADDRESS=$RVN_ADDRESS
last_X16R_SPECIFIC_OC_SETTINGS=$X16R_SPECIFIC_OC_SETTINGS
last_RVN_POOL=$RVN_POOL
last_EMAIL_UPDATES=$EMAIL_UPDATES
last_NANOPOOL_EMAIL=$NANOPOOL_EMAIL
last_RE2UNIX=$RE2UNIX
last_CLIENT=$CLIENT
last_CLIENT_OC=$CLIENT_OC
last_CLIENT_ARGS=$CLIENT_ARGS
getRigs

if [[ $last_REBOOT != $REBOOT ]]
then
echo "$(date) - going down for reboot"
LOG+="$(date) - going down for reboot"
LOG+=$'\n'
pkill -e miner
pkill -f miner
wtelegram
sleep 10
sudo reboot
fi

if [[ $last_UPDATE != $UPDATE ]]
then
echo "$(date) - going down for update"
LOG+="$(date) - going down for update"
LOG+=$'\n'
pkill -e miner
pkill -f miner
wtelegram
sleep 10
sudo reboot
fi

if [[ $RE2UNIX == "YES" ]]
then
echo "$(date) - re2unix: restarting mining process"
LOG+="$(date) - re2unix: restarting mining process"
LOG+=$'\n'
pkill -e miner
pkill -f miner
wtelegram
target=$(ps -ef | awk '$NF~"1bash.sh" {print $2}')
kill $target
echo ""
fi

if [[ $last_CHATID != $CHATID ]]
then
HASH=0
fi
if [[ $last_APIKEY != $APIKEY ]]
then
HASH=0
fi
if [[ $last_COIN != $COIN ]]
then
HASH=0
COINCHANGE=1
fi
if [[ $last_CLIENT != $CLIENT ]]
then
HASH=0
fi
if [[ $last_RVN_ADDRESS != $RVN_ADDRESS ]]
then
HASH=0
fi
if [[ $last_X16R_SPECIFIC_OC_SETTINGS != $X16R_SPECIFIC_OC_SETTINGS ]]
then
HASH=0
fi
if [[ $last_RVN_POOL != $RVN_POOL ]]
then
HASH=0
fi
if [[ $last_EMAIL_UPDATES != $EMAIL_UPDATES ]]
then
HASH=0
fi
if [[ $last_NANOPOOL_EMAIL != $NANOPOOL_EMAIL ]]
then
HASH=0
fi
if [[ $last_CLIENT != $CLIENT ]]
then
HASH=0
fi
if [[ $last_CLIENT_OC != $CLIENT_OC ]]
then
HASH=0
fi
if [[ $last_CLIENT_ARGS != $CLIENT_ARGS ]]
then
HASH=0
fi

# HASH == 0
echo ""
echo "HASH:" $HASH
echo ""
if [[ $HASH == 0 ]]
then

# COINCHANGE
if [[ $COINCHANGE == 1 ]]
then
sleep 1
HASHRATE="0"
sendDataCur
sleep 1
echo ""
COINCHANGE=0
fi ## COINCHANGE

echo "$(date) - new settings detected: restart 1bash"
LOG+="$(date) - new settings detected: restart 1bash"
LOG+=$'\n'
pkill -e miner
pkill -f miner
wtelegram
target=$(ps -ef | awk '$NF~"1bash.sh" {print $2}')
kill $target
echo ""
if [[ $GPU_COUNT < 7 ]]
then
sleep 35
fi
if [[ $GPU_COUNT > 6 ]]
then
sleep 80
fi

fi ## HASH == 0
}

wtelegram()
{
N_LENGTH=${#APIKEY}
if [[ $N_LENGTH > 30 ]]
then
sleep 2
MSG="
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IP_AS_WORKER
VERSION: $VERSION
LOG: $LOG
"
/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${APIKEY}/sendMessage -d "text=${MSG}" -d chat_id=${CHATID}
echo $MSG
sleep 2
fi

if [[ $EMAIL_UPDATES == "YES" || $DEV_WATCH == "YES" ]]
then
MSG="
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IP_AS_WORKER
VERSION: $VERSION
LOG: $LOG
"
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
ID_BOX=$SELF
R_LENGTH=${#ID_BOX}
RIG_ID=${ID_BOX:6:$R_LENGTH}
OUTPUT_LINE="$OVERLORD/email_alert/$RIG_ID"
/usr/bin/curl -X POST --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
sleep 5
fi
}


updateINIT()
{
itr=$(($itr + 1))
#updateNOW=$(($itr % 2))
updateNOW=0
# doubles update frequency
if [[ $updateNOW == 0 ]]
then
updateCHECK
sendDataCur
sleep 1
echo ""
fi
}


if [[ -d "/media/m1/2274EEAA26420CBD" ]]
then
IPW=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ifconfig -a | grep -Po 'HWaddr \K.*$')
fi
if [[ -d "/media/oros/0rig_here" ]]
then
IPW=$(ip address show | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ip link show | grep -Po 'ether \K.*$')
MAC=${MAC:0:17}
fi
IP_AS_WORKER=$(echo -n $IPW | tail -c -3 | sed 'y/./0/')
MAC_AS_WORKER=$(echo -n $MAC | tail -c -4 | sed 's|[:,]||g')
LOG+="$(date) - Watchdog Started"
LOG+=$'\n'
sleep 2





sleep 10
sendDataInit
echo "$(date) - waiting 20 seconds before going 'on watch'"
sleep 20
#sleep 30
THRESHOLD=90
RESTART=0
GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
COUNT=$((6 * $GPU_COUNT))
while true
do
sleep 10
TOP=0
GPU=0
REBOOTRESET=$(($REBOOTRESET + 1))
echo ""
echo "      GPU_COUNT: " $GPU_COUNT
UTILIZATIONS=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
echo ""
echo "GPU UTILIZATION: " $UTILIZATIONS
echo ""
numtest='^[0-9]+$'
for UTIL in $UTILIZATIONS
do
if ! [[ $UTIL =~ $numtest ]]
then
LOG+="$(date) - GPU FAIL - restarting system"
LOG+=$'\n'
echo "$(date) - GPU FAIL - restarting system"
echo ""
echo "current GPU activity:"
LOG+="current GPU activity:"
LOG+=$(nvidia-smi --query-gpu=gpu_bus_id --format=csv)
sendDataCur
echo "$(date) - reboot in 10 seconds"
echo ""
wtelegram
sleep 10
sudo reboot
fi
if [ $UTIL -lt $THRESHOLD ]
then
echo "$(date) - GPU under threshold found - GPU UTILIZATION: " $UTILIZATIONS
echo ""
COUNT=$(($COUNT - 1))
TOP=$(($TOP + 1))
fi
GPU=$(($GPU + 1))
done ## for UTIL in $UTILIZATIONS
if [ $TOP -gt 0 ]
then
if [ $COUNT -le 0 ]
then
INTERNET_IS_GO=0
if nc -vzw1 google.com 443;
then
INTERNET_IS_GO=1
fi
echo ""
if [[ $RESTART -gt 2 && $INTERNET_IS_GO == 1 ]]
then
echo "$(date) - Utilization is too low: reviving did not work so restarting system in 10 seconds"
LOG+="$(date) - Utilization is too low: reviving did not work so restarting system in 10 seconds"
LOG+=$'\n'
echo ""
sendDataCur
wtelegram
sleep 2
pkill -e miner
pkill -f miner
sleep 10
sudo reboot
fi
echo "$(date) - Utilization is too low: restart 1bash"
LOG+="$(date) - Low GPU Utilization Detected: restart 1bash"
LOG+=$'\n'
pkill -e miner
pkill -f miner
sendDataCur
wtelegram
target=$(ps -ef | awk '$NF~"1bash.sh" {print $2}')
kill $target
echo ""
RESTART=$(($RESTART + 1))
REBOOTRESET=0
COUNT=$GPU_COUNT
sleep 70
else
echo "$(date) - Low GPU Utilization Detected"
echo ""
fi ##[ $COUNT -le 0 ]
else
min_count=$(($min_count + 1))
ten=$(($min_count % 5))
if [[ $ten == 0 ]]
then
updateINIT
sleep 2
fi
COUNT=$((6 * $GPU_COUNT))


echo $CLIENT > /media/ramdisk/CLIENT
echo $COIN > /media/ramdisk/COIN
#hashrate


if [[ $COIN == "CLIENT" && $CLIENT == '"xmrstak"' ]]
then
#for xmrstak
HASHRATE=$(cat /media/ramdisk/xmrstak/screenlog.0 | grep "Highest:")
HASHRATE=$(echo $HASHRATE | tr -d "Highest: /")
echo $HASHRATE > /media/ramdisk/HASHRATE_xmr
fi


OLD_HASH=$HASHRATE
if [[ $COIN == "CLIENT" && $CLIENT == '"cryptodredge_0_19_1_c10"' || $COIN == "CLIENT" && $CLIENT == '"cryptodredge_0_18_0_c10"' || $COIN == "CLIENT" && $CLIENT == '"cryptodredge_v0_18_0_cuda_9_2"' || $COIN == "CLIENT" && $CLIENT == '"cryptodredge_v0_17_0_cuda_9_2"' ]]
then
#for cryptodredge
#OUT=$(tail -20 /media/ramdisk/screenlog.0)
#OUT=$(echo $OUT | sed 's/[^[:print:]\r\t]/ /g')
#INDEX=$(echo $OUT | grep -aob "MH/s" | grep -oE '[0-9]+' | tail -n1)
#before=$(($INDEX - 7))
#HASHRATE=$OUT
#HASHRATE=${HASHRATE:$before:7}
#HASHRATE=$(echo $HASHRATE | tr -d "MH/s" | tr -d "e :")
#echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredge0

#OUT2=$(cat /media/ramdisk/screenlog.0 | grep "Avr")
#HASHRATE=$(echo $OUT2 | sed 's/[^[:print:]\r\t]/ /g')
#HASHRATE=${HASHRATE:32:5}
#echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredge1

#HASHRATE2=$(echo $OUT | grep "diff=")
#HASHRATE2=${HASHRATE2:11:10}
#HASHRATE2=$(echo $HASHRATE2 | tr -d "MH/s")
#echo $HASHRATE2 > /media/ramdisk/HASHRATE_cryptodredge2
#if [[ $HASHRATE2 > $HASHRATE ]]
#then
#HASHRATE=$HASHRATE2
#fi
#echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredgeF

#HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Avr")
#HASHRATE=$(echo $HASHRATE | sed 's/[^[:print:]\r\t]/ /g')
#rig_log=$HASHRATE
#rig_log="${rig_log//$'[39m'/ }"
#rig_log="${rig_log//$'[0m'/ }"
#rig_log="${rig_log//$'[32m'/ }"
#rig_log="${rig_log//$'[0;97m'/ }"
#rig_log="${rig_log//$'[0;36m'/ }"
#rig_log="${rig_log//$'[0;93m'/ }"
#rig_log="${rig_log//$'[0;91m'/ }"
#rig_log="${rig_log//$'[49m'/ }"
#rig_log="${rig_log//$'[33m'/ }"
#rig_log="${rig_log//$'[36m'/ }"
#rig_log="${rig_log//$'[37m'/ }"
#rig_log="${rig_log//$'[97m'/ }"
#rig_log="${rig_log//$'[30m'/ }"
#rig_log="${rig_log//$'[35m'/ }"
#rig_log="${rig_log//$'[94m'/ }"
#rig_log="${rig_log//$'[31m'/ }"
#HASHRATE=$rig_log
#HASHRATE=${HASHRATE:43:9}
#HASHRATE=$(echo $HASHRATE | tr -d "MH/s" | tr -d ":")
#echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredge0

HASHRATE=$(tail -1 /media/ramdisk/screenlog.0 | grep "diff=")
HASHRATE=$(echo $HASHRATE | sed 's/[^[:print:]\r\t]/ /g')
rig_log=$HASHRATE
rig_log="${rig_log//$'[39m'/ }"
rig_log="${rig_log//$'[0m'/ }"
rig_log="${rig_log//$'[32m'/ }"
rig_log="${rig_log//$'[0;97m'/ }"
rig_log="${rig_log//$'[0;36m'/ }"
rig_log="${rig_log//$'[0;93m'/ }"
rig_log="${rig_log//$'[0;91m'/ }"
rig_log="${rig_log//$'[49m'/ }"
rig_log="${rig_log//$'[33m'/ }"
rig_log="${rig_log//$'[36m'/ }"
rig_log="${rig_log//$'[37m'/ }"
rig_log="${rig_log//$'[97m'/ }"
rig_log="${rig_log//$'[30m'/ }"
rig_log="${rig_log//$'[35m'/ }"
rig_log="${rig_log//$'[94m'/ }"
rig_log="${rig_log//$'[31m'/ }"
HASHRATE=$rig_log
echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredge
HASHRATE=$(tail -c 12 /media/ramdisk/HASHRATE_cryptodredge | tr -d "MH/s" | tr -d ":")
#HASHRATE=${HASHRATE:66:6}
#HASHRATE=$(echo $HASHRATE | tr -d "MH/s" | tr -d ":")
echo $HASHRATE > /media/ramdisk/HASHRATE_cryptodredge
fi


## needs to be changed
if [[ $COIN == "CLIENT" && $CLIENT == '"z_enemy_2_0"' || $COIN == "CLIENT" && $CLIENT == '"z_enemy_1_28"' ]]
then
# for z_enemy_1_28
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Speed:")
echo $HASHRATE > /media/ramdisk/HASHRATE_z_enemy_1_28
HASHRATE=$(tail -c 56 /media/ramdisk/HASHRATE_z_enemy_1_28 | tr -d ":")
HASHRATE=${HASHRATE:0:5}
fi ## if [[ $COIN == "CLIENT" && $CLIENT == '"z_enemy_1_28"' ]]


## needs to be changed
if [[ $COIN == "CLIENT" && $CLIENT == '"bminer_15_5_1"' ]]
then
# for bminer_15_5_1
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Speed:")
echo $HASHRATE > /media/ramdisk/HASHRATE_bminer_15_5_1
HASHRATE=$(tail -c 56 /media/ramdisk/HASHRATE_bminer_15_5_1 | tr -d ":")
HASHRATE=${HASHRATE:0:5}
HASHRATE=1
fi ## if [[ $COIN == "CLIENT" && $CLIENT == '"bminer_15_5_1"' ]]


if [[ $COIN == "CLIENT" && $CLIENT == '"claymore_14_2"' || $COIN == "CLIENT" && $CLIENT == '"claymore_12_0"' ]]
then
# for claymore
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Speed:")
echo $HASHRATE > /media/ramdisk/HASHRATE_claymore
HASHRATE=$(tail -c 58 /media/ramdisk/HASHRATE_claymore | tr -d " " | tr -d ":")
HASHRATE=${HASHRATE:0:5}
fi ## if [[ $COIN == "CLIENT" && $CLIENT == '"claymore*"' ]]


## needs to be changed
if [[ $COIN == "CLIENT" && $CLIENT == '"bci_progpowminer"' ]]
then
# for bci_progpowminer
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Speed")
echo $HASHRATE > /media/ramdisk/HASHRATE_bci_progpowminer
HASHRATE=$(sed 's/[^[:print:]\r\t]/ /g' /media/ramdisk/HASHRATE_bci_progpowminer)
echo $HASHRATE > /media/ramdisk/HASHRATE_bci_progpowminer
HASHRATE=$(tail -c 75 /media/ramdisk/HASHRATE_bci_progpowminer | tr -d "[1;36m")
HASHRATE=${HASHRATE:0:5}
HASHRATE=1
fi ## if [[ $COIN == "CLIENT" && $CLIENT == '"bci_progpowminer"' ]]


if [[ $COIN == "CLIENT" && $CLIENT == '"PhoenixMiner_4_2c"' ]]
then
# for PhoenixMiner_4_2c
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "speed:")
echo $HASHRATE > /media/ramdisk/HASHRATE_PhoenixMiner_4_2c
HASHRATE=$(sed 's/[^[:print:]\r\t]/ /g' /media/ramdisk/HASHRATE_PhoenixMiner_4_2c)
echo $HASHRATE > /media/ramdisk/HASHRATE_PhoenixMiner_4_2c
HASHRATE=$(tail -c 41 /media/ramdisk/HASHRATE_PhoenixMiner_4_2c)
HASHRATE=${HASHRATE:0:5}
fi ## if [[ $COIN == "CLIENT" && $CLIENT == '"PhoenixMiner_4_2c"' ]]


if [[ $COIN == "CLIENT" && $CLIENT == '"gminer_1_42"' || $COIN == "CLIENT" && $CLIENT == '"gminer_1_38"' || $COIN == "CLIENT" && $CLIENT == '"gminer_1_39"' || $COIN == "CLIENT" && $CLIENT == '"gminer_1_40"' || $COIN == "CLIENT" && $CLIENT == '"gminer_1_41"' ]]  # or any coin grincuckaroo29
then
#for gminer
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Total Speed:")
HASHRATE=$(echo $HASHRATE | sed 's/[^[:print:]\r\t]/ /g')
#echo $HASHRATE > /media/ramdisk/HASHRATE_TSgminer
HASHRATE=${HASHRATE:32:5}
#echo $HASHRATE > /media/ramdisk/HASHRATE_gminer
fi
if [[ $COIN == "CLIENT" && $CLIENT == '"fullzero"' ]]  # or any coin ETHASH
then
# for fullzero ethash
HASHRATE=$(tail -c 12 /media/ramdisk/screenlog.0 | tr -d "MH/s")
fi ## [[ $COIN == "CLIENT" && $CLIENT == '"fullzero"' ]]

if [[ $COIN == "CLIENT" && $CLIENT == '"ethminer_0_17_1"' ]]
then
# for ethminer
#using API
#HASHRATE=$(echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | netcat 127.0.0.1 3333)
#HASHRATE=${HASHRATE:57:7}
#HASHRATE=$(echo $HASHRATE  | tr -d ";" | tr -d '"')
#HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 1/1000 * $HASHRATE}")
##using API
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "Speed")
echo $HASHRATE > /media/ramdisk/HASHRATE_ethminer
HASHRATE=$(sed 's/[^[:print:]\r\t]/ /g' /media/ramdisk/HASHRATE_ethminer)
echo $HASHRATE > /media/ramdisk/HASHRATE_ethminer
HASHRATE=$(tail -c 75 /media/ramdisk/HASHRATE_ethminer | tr -d "[1;36m")
HASHRATE=${HASHRATE:0:5}
fi ## [[ $COIN == "CLIENT" && $CLIENT == '"ethminer_0_17_1"' ]]

if [[ $COIN == "RVN" || $COIN == "CLIENT" && $CLIENT == '"trex_0_14_4_c10"' || $COIN == "CLIENT" && $CLIENT == '"trex_0_10_2_c10"' || $COIN == "CLIENT" && $CLIENT == '"trex_0_9_2_c10"' || $COIN == "CLIENT" && $CLIENT == '"trex_0_9_2_c9"' ]]
then
# for suprminer
#HASHRATE=$(perl /home/m1/rvn/hashrate.pl)
#HASHRATE=$(echo $HASHRATE | tr -d "=" | tr -d ";" | tr -d "S")
#HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", $HASHRATE}")
#HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 1/1000 * $HASHRATE}")

# for trex
# old
#HASHRATE=$(tail -c 27 /media/ramdisk/screenlog.0 | tr -d "MH/s," | tr -d "-"| tr -d "ms")
#HASHRATE=${HASHRATE:1:6}
#HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 1 * $HASHRATE}")
# old
#HASHRATE=$(tail -25 /media/ramdisk/screenlog.0 | grep "[ OK ]")
#echo $HASHRATE > /media/ramdisk/HASHRATE_trex
#HASHRATE=$(tail -c 27 /media/ramdisk/HASHRATE_trex | grep "[ OK ]")
#echo $HASHRATE > /media/ramdisk/HASHRATE_trex
#HASHRATE=$(cat /media/ramdisk/HASHRATE_trex | tr -d "MH/s," | tr -d "-" | tr -d "ms" | tr -d " ")
#HASHRATE=${HASHRATE:4:4}
# old2



#HASHRATE=$(tail -c 27 /media/ramdisk/screenlog.0 | tr -d "MH/s," | tr -d "-"| tr -d "ms")
#HASHRATE=$(echo $HASHRATE | sed 's/[^[:print:]\r\t]/ /g')
#rig_log=$HASHRATE
#rig_log="${rig_log//$'[39m'/ }"
#rig_log="${rig_log//$'[0m'/ }"
#rig_log="${rig_log//$'[32m'/ }"
#rig_log="${rig_log//$'[0;97m'/ }"
#rig_log="${rig_log//$'[0;36m'/ }"
#rig_log="${rig_log//$'[0;93m'/ }"
#rig_log="${rig_log//$'[0;91m'/ }"
#rig_log="${rig_log//$'[49m'/ }"
#rig_log="${rig_log//$'[33m'/ }"
#rig_log="${rig_log//$'[36m'/ }"
#rig_log="${rig_log//$'[37m'/ }"
#rig_log="${rig_log//$'[97m'/ }"
#rig_log="${rig_log//$'[30m'/ }"
#rig_log="${rig_log//$'[35m'/ }"
#rig_log="${rig_log//$'[94m'/ }"
#rig_log="${rig_log//$'[31m'/ }"
#HASHRATE=$rig_log
#HASHRATE=${HASHRATE:1:6}
#HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 1 * $HASHRATE}")



# newest
HASHRATE=$(cat /media/ramdisk/screenlog.0 | grep "OK")
echo $HASHRATE > /media/ramdisk/HASHRATE_trex
HASHRATE=$(tail -c 22 /media/ramdisk/HASHRATE_trex | tr -d " " | tr -d "-")
HASHRATE=${HASHRATE:0:5}
fi

if [[ $COIN == "CLIENT" && $CLIENT == '"ewbf"' ]] # or any algo ZHASH
then
EWBF=$(/usr/bin/curl 127.0.0.1:42000)
EWBF2=$(echo -n $EWBF | tail -c 119)
EWBF2=${EWBF2:0:6}
EWBF2=$(echo -n $EWBF2 | tr -d " " | tr -d "t" | tr -d "<" | tr -d ">" | tr -d "d" | tr -d "S")
HASHRATE=$EWBF2
fi

# ensure hashrate is an int
isnum='^[0-9]+$'
HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 1 * $HASHRATE}")
if ! [[ $HASHRATE =~ $isnum ]]
then
if [[ $OLD_HASH == "" ]]
then
OLD_HASH=0
fi
HASHRATE=$OLD_HASH
fi


# EXPECTED_HASHRATE CHECK
echo "       HASHRATE: $HASHRATE"
echo ""
RIG_LOG+=$(tail /media/ramdisk/screenlog.0)
RIG_LOG+=$'\n\n'
if [[ $EXPECTED_HASHRATE != "for_advanced_use_only" && $EXPECTED_HASHRATE != "" ]]
then
MIN_HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 92/100 * $EXPECTED_HASHRATE}")
if [[ $COIN == "RVN" ]]
then
MIN_HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", 85/100 * $EXPECTED_HASHRATE}")
fi
CUR_HASHRATE=$(awk "BEGIN {printf \"%.0f\n\", $HASHRATE - $MIN_HASHRATE}")
if [ $CUR_HASHRATE -lt 0 ]
then
HASH_COUNT=$(($HASH_COUNT + 2))
fi
if [ $HASH_COUNT != 0 ]
then
HASH_COUNT=$(($HASH_COUNT -1))
fi
if [ $HASH_COUNT -gt 21 ]
then
echo "$(date) - hashrate below minimum detected: $CUR_HASHRATE rebooting"
LOG+="$(date) - hashrate below minimum detected: $CUR_HASHRATE rebooting"
LOG+=$'\n'
pkill -e miner
pkill -f miner
sendDataCur
wtelegram
sleep 10
sudo reboot
fi
echo "     FAIL_COUNT:  $HASH_COUNT"
echo ""
fi ## [[ $EXPECTED_HASHRATE != "for_advanced_use_only" && $EXPECTED_HASHRATE != "" ]]

fi ## [ $TOP -gt 0 ]
if [ $REBOOTRESET -gt 5 ]
then
RESTART=0
REBOOTRESET=0
fi
done ## while true
