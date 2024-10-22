#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

BASH_VERSION="1.5"
SUB_VERSION="1"
WATCHDOG="YES"
sudo ufw enable

SSH=$(which ssh)
[[ $SSH == "" ]] && {
echo "installing ssh"
sudo apt install ssh -y
sleep 3
}

[[ -d "/media/m1/0rig_here_" ]] &&
then
IPW=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ifconfig -a | grep -Po 'HWaddr \K.*$')
fi
if [[ -d "/media/oros/0rig_here" ]]
then
IPW=$(ip address show | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ip link show | grep -Po 'ether \K.*$')
MAC=${MAC:0:17}

if [[ $WATCHDOG == "YES" ]]
then
if [[ -d "/media/m1/2274EEAA26420CBD" || -d "/media/m1/0rig_here_" ]]
then
if [[ -d "/media/m1/2274EEAA26420CBD" ]]
then
cp /media/m1/2274EEAA26420CBD/0rig* /media/ramdisk/0rig.txt
fi
if [[ -d "/media/m1/0rig_here_" ]]
then
cp /media/m1/0rig_here_/0rig* /media/ramdisk/0rig.txt
fi
IPW=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ifconfig -a | grep -Po 'HWaddr \K.*$')
fi
if [[ -d "/media/oros/0rig_here" ]]
then
cp /media/oros/0rig_here/0rig* /media/ramdisk/0rig.txt
IPW=$(ip address show | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MAC=$(ip link show | grep -Po 'ether \K.*$')
MAC=${MAC:0:17}
fi
sleep 2
fi
# 0rig
ZRIG="/media/ramdisk/0rig.txt"
zrig=$(sed -e 's/\r$//' $ZRIG)
USER_ID=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="USER_ID"{printf("%s ", $4)}' | xargs)
RIG_NUMBER=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="RIG_NUMBER"{printf("%s ", $4)}' | xargs)
CUSTOMER_KEY=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="CUSTOMER_KEY"{printf("%s ", $4)}' | xargs)
OVERLORD=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="OVERLORD"{printf("%s ", $4)}' | xargs)
IP_AS_WORKER=$(echo -n $IPW | tail -c -3 | sed 'y/./0/')
MAC_AS_WORKER=$(echo -n $MAC | tail -c -4 | sed 's|[:,]||g')

email_update()
{
if [[ $EMAIL_UPDATES == "YES" || $DEV_WATCH == "YES" ]]
then
sleep 2
GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
MSG="
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IPW
COIN: $COIN
VERSION: $VERSION
"
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
R_LENGTH=${#SELF}
RIG_ID=${SELF:6:$R_LENGTH}
OUTPUT_LINE="$OVERLORD/email_alert/$RIG_ID"
/usr/bin/curl -X POST --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
sleep 2
fi
}

email_updateXR()
{
if [[ $EMAIL_UPDATES == "YES" || $DEV_WATCH == "YES" ]]
then
sleep 2
GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
MSG="
XORG UPDATED: REBOOTING $VERSION
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IPW
COIN: $COIN
"
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
R_LENGTH=${#SELF}
RIG_ID=${SELF:6:$R_LENGTH}
OUTPUT_LINE="$OVERLORD/email_alert/$RIG_ID"
/usr/bin/curl -X POST --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
sleep 2
fi
}

telegramXR()
{
N_LENGTH=${#APIKEY}
if [[ $N_LENGTH > 30 ]]
then
sleep 2
GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
MSG="
XORG UPDATED: REBOOTING $VERSION
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IPW
COIN: $COIN
"
/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${APIKEY}/sendMessage -d "text=${MSG}" -d chat_id=${CHATID}
echo $MSG
sleep 2
fi
}

telegram()
{
N_LENGTH=${#APIKEY}
if [[ $N_LENGTH > 30 ]]
then
sleep 2
GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
MSG="
RIG#: $RIG_NUMBER
MAC: $MAC_AS_WORKER
GPU_COUNT: $GPU_COUNT
IP: $IPW
COIN: $COIN
VERSION: $VERSION
"
/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${APIKEY}/sendMessage -d "text=${MSG}" -d chat_id=${CHATID}
echo $MSG
sleep 2
fi
}

POWERLIMIT_WATTS="107"
CORE_OVERCLOCK="101"
MEMORY_OVERCLOCK="501"
FAN_SPEED="48"
EXPECTED_HASHRATE="2"
INDIVIDUAL_POWERLIMITS="0"

getRigs()
{
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
var=RIG_MAC
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RIG_MAC=${b[1]}
var=RIG_IP
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RIG_IP=${b[1]}
var=BASE_VERSION
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
BASE_VERSION=${b[1]}
var=EMAIL_UPDATES
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
EMAIL_UPDATES=${b[1]}
var=CHATID
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
CHATID=${b[1]}
var=APIKEY
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
APIKEY=${b[1]}
var=UPDATE
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
UPDATE=${b[1]}


var=self
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
SELF=${b[1]}
var=VERSION
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
VERSION=${b[1]}
var=NANOPOOL_EMAIL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
NANOPOOL_EMAIL=${b[1]}
var=RVN_POOL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_POOL=${b[1]}
var=RVN_ADDRESS
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_ADDRESS=${b[1]}
var=COIN
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
COIN=${b[1]}
var=RIG_NUMBER
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RIG_NUMBER=${b[1]}

INDEX=$(echo $RIG | grep -aob "R_SPECIFIC" | grep -oE '[0-9]+' | tail -n1)
X16R_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:100}
INDEX2=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
X16R_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:INDEX2}
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:27:INDEX2}
X16R_SPECIFIC_OC_SETTINGS='"'$X16R_SPECIFIC_OC_SETTINGS

INDEX=$(echo $RIG | grep -aob "CLIENT" | grep -oE '[0-9]+' | tail -n1)
CLIENT=${RIG:$INDEX:250}
INDEX2=$(echo $CLIENT | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CLIENT=${RIG:$INDEX:INDEX2}
CLIENT=${CLIENT:11:INDEX2}
CLIENT='"'$CLIENT

INDEX=$(echo $RIG | grep -aob "CLIENT_ARGS" | grep -oE '[0-9]+' | tail -n1)
CLIENT_ARGS=${RIG:$INDEX:250}
INDEX2=$(echo $CLIENT_ARGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CLIENT_ARGS=${RIG:$INDEX:INDEX2}
CLIENT_ARGS=${CLIENT_ARGS:16:INDEX2}
CLIENT_ARGS='"'$CLIENT_ARGS

INDEX=$(echo $RIG | grep -aob "CLIENT_OC" | grep -oE '[0-9]+' | tail -n1)
CLIENT_OC=${RIG:$INDEX:38}
INDEX2=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
CLIENT_OC=${RIG:$INDEX:INDEX2}
CLIENT_OC=${CLIENT_OC:14:INDEX2}
CLIENT_OC='"'$CLIENT_OC

#INDEX=$(echo $RIG | grep -aob "INDIVIDUAL_POWERLIMITS" | grep -oE '[0-9]+' | tail -n1)
#INDIVIDUAL_POWERLIMITS=${RIG:$INDEX:38}
#INDEX2=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
#INDIVIDUAL_POWERLIMITS=${RIG:$INDEX:INDEX2}
#INDIVIDUAL_POWERLIMITS=${INDIVIDUAL_POWERLIMITS:14:INDEX2}
#INDIVIDUAL_POWERLIMITS='"'$INDIVIDUAL_POWERLIMITS

#echo $INDIVIDUAL_POWERLIMITS
}
getRigs

# kill 3watchdog if re2unix == "YES"
if [[ $RE2UNIX == "YES" ]]
then
pkill -e 3watchdog
pkill -f 3watchdog
sleep 2
MSG='{"RE2UNIX": "1"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
fi ## [[ $RE2UNIX == "YES" ]]
sleep 2
# download 3watchdog to ramdisk
URL="$OVERLORD/3watchdog.sh"
DL=$(/usr/bin/curl $URL)
cat <<EOF >/media/ramdisk/3watchdog.sh
$DL
EOF
sleep 2

if [[ $RIG_MAC != $MAC || $RIG_IP != $IPW ]]
then
sleep 2
MSG='{"RIG_IP": "'$IPW'","RIG_MAC": "'$MAC'"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
sleep 2
fi

echo ""
echo ""
echo "oros_v$VERSION"
echo ""
# xorg
sudo nvidia-xconfig --enable-all-gpus --cool-bits=28 --allow-empty-initial-configuration # 31
XORG="FAIL"
if grep -q '"Coolbits" "28"' /etc/X11/xorg.conf; #31
then
XORG="OK"
fi
if [ $XORG == "FAIL" ]
then
telegramXR
email_updateXR
echo "XORG UPDATED"
echo ""
echo "Rebooting in 2"
echo ""
sleep 2
sudo reboot
fi ## [ $XORG == "FAIL" ]
if [[ $VERSION == "_init" ]]
then
telegramXR
email_updateXR
MSG='{"VERSION": "'$BASE_VERSION'"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
echo "XORG UPDATED"
echo ""
echo "Rebooting in 2"
echo ""
sleep 2
sudo reboot
fi ## [ $VERSION == "_init" ]

# CHECK VERSION
#if [[ $VERSION != $BASH_VERSION ]]
#then
#URL="$OVERLORD/update"
#pkill -e 3watchdog
#pkill -f 3watchdog
#sleep 2
#echo ""
#echo "Update Starting!"
#echo ""
#sudo dpkg --configure -a
#sleep 2
#UP=$(/usr/bin/curl $URL)
#cat <<EOF >/media/ramdisk/UP
#$UP
#EOF
#cd /media/ramdisk
#sleep 2
#sudo bash /media/ramdisk/UP
#sleep 2
#echo ""
#echo "Update Complete!"
#echo ""
#fi ## CHECK VERSION
echo ""
echo "RIG_NUMBER:  $RIG_NUMBER"
echo ""
echo ""
echo "COIN:  $COIN"
echo ""

if [[ $COIN == "RVN" ]]
then
CLIENT_LOCAL="/media/ramdisk/trex_0_14_4_c10/t-rex -a x16r -o $RVN_POOL -u $RVN_ADDRESS.$RIG_NUMBER -p x;"
N_LENGTH=${#NANOPOOL_EMAIL}
if [[ $N_LENGTH > 10 ]]
then
CLIENT_LOCAL="/media/ramdisk/trex_0_14_4_c10/t-rex -a x16r -o $RVN_POOL -u $RVN_ADDRESS.$RIG_NUMBER/$NANOPOOL_EMAIL -p x;"
fi
TREX="/media/ramdisk/trex_0_14_4_c10"
if [[ ! -d $TREX ]]
then
# download trex to ramdisk
cd /media/ramdisk
FILENAME="trex_0_14_4_c10.zip"
#URL="https://openrig.net/$FILENAME"
URL="https://storage.googleapis.com/oros/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/trex_0_14_4_c10/t-rex
fi ## [[ ! -d $TREX ]]
#(PL,CC,MC,FS,EH)
#X16R_SPECIFIC_OC_SETTINGS
Y="0"
if [[ $Y == "0" ]]
then
INDEX=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
POWERLIMIT_WATTS=${X16R_SPECIFIC_OC_SETTINGS:1:INDEX}
INDEX=$(($INDEX + 2))
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CORE_OVERCLOCK=${X16R_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
MEMORY_OVERCLOCK=${X16R_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
FAN_SPEED=${X16R_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
EXPECTED_HASHRATE=${X16R_SPECIFIC_OC_SETTINGS:0:INDEX}
echo ""
echo "X16R_SPECIFIC_OC_SETTINGS are: $X16R_SPECIFIC_OC_SETTINGS"
echo ""
echo ""
echo "POWERLIMIT_WATTS is: $POWERLIMIT_WATTS"
echo ""
echo ""
echo "CORE_OVERCLOCK is: $CORE_OVERCLOCK"
echo ""
echo ""
echo "MEMORY_OVERCLOCK is: $MEMORY_OVERCLOCK"
echo ""
echo ""
echo "FAN_SPEED is: $FAN_SPEED"
echo ""
echo ""
echo "EXPECTED_HASHRATE is: $EXPECTED_HASHRATE"
echo ""
echo $POWERLIMIT_WATTS > /media/ramdisk/POWERLIMIT_WATTS
echo $CORE_OVERCLOCK > /media/ramdisk/CORE_OVERCLOCK
echo $MEMORY_OVERCLOCK > /media/ramdisk/MEMORY_OVERCLOCK
echo $FAN_SPEED > /media/ramdisk/FAN_SPEED
echo $EXPECTED_HASHRATE > /media/ramdisk/EXPECTED_HASHRATE
fi ##  [[ $Y == "0" ]]
fi ## [[ $COIN == "RVN" ]]

if [[ $COIN == "CLIENT" ]]
then
CLIENT=${CLIENT}
###
echo $CLIENT_ARGS > /media/ramdisk/CLIENT_ARGS
sed -i "s/RIG/${RIG_NUMBER}/g" /media/ramdisk/CLIENT_ARGS
CLIENT_ARGS=$(cat /media/ramdisk/CLIENT_ARGS | tr -d "$")
###
client_download()
{
EXE=${1}
CLIENT="${CLIENT:1:-1}"
CLIENT_LOCAL="/media/ramdisk/$CLIENT/$EXE ${CLIENT_ARGS:1:-1}"
DIR="/media/ramdisk/$CLIENT"
if [[ ! -d $DIR ]]
then
# download to ramdisk
cd /media/ramdisk
FILENAME="$CLIENT.zip"
#URL="https://openrig.net/$FILENAME"
URL="https://storage.googleapis.com/oros/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/$CLIENT/$EXE
fi
}

###
if [[ $CLIENT == '"xmrstak"' ]]
then
XMRSTAK="/media/ramdisk/xmrstak"
if [[ ! -d $XMRSTAK ]]
then
# download xmrstak to ramdisk
cd /media/ramdisk
FILENAME="xmrstak.zip"
#URL="https://openrig.net/$FILENAME"
URL="https://storage.googleapis.com/oros/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/xmrstak/xmr-stak
cp /media/ramdisk/xmrstak/libxmrstak_cuda_backend_cuda9_2.so /media/ramdisk/xmrstak/libxmrstak_cuda_backend_cuda10_0.so
fi ## [[ ! -d $XMRSTAK ]]
cd /media/ramdisk/xmrstak
#CLIENT_ARGS="xmr-us-east1.nanopool.org:14444!YOUR_XMR_ADDRESS.YOUR_PAYMENT_ID.YOUR_WORKER/YOUR_EMAIL"
INDEX=$(echo $CLIENT_ARGS | grep -aob "!" | grep -oE '[0-9]+' | tail -n1)
echo $INDEX > /media/ramdisk/INDEX
INDEX=$(($INDEX + 1))
CLIENT_ARGS2=${CLIENT_ARGS:$INDEX:-1}
echo $CLIENT_ARGS2 > /media/ramdisk/CLIENT_ARGS2
INDEX=$(($INDEX - 2))
CLIENT_ARGS1=${CLIENT_ARGS:1:$INDEX}
echo $CLIENT_ARGS1 > /media/ramdisk/CLIENT_ARGS1
> /media/ramdisk/xmrstak/pools.txt
sleep 1
cat <<EOF >/media/ramdisk/xmrstak/pools.txt
"pool_list" :
[{"pool_address" : "$CLIENT_ARGS1", "wallet_address" : "$CLIENT_ARGS2", "rig_id" : "", "pool_password" : "x", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },],
"currency" : "monero",
EOF
CLIENT_LOCAL="/media/ramdisk/xmrstak/xmr-stak"
fi ## [[ $CLIENT == "xmrstak" ]]


if [[ $CLIENT == '"cryptodredge_0_19_1_c10"' || $CLIENT == '"cryptodredge_0_18_0_c10"' || $CLIENT == '"cryptodredge_v0_18_0_cuda_9_2"' || $CLIENT == '"cryptodredge_v0_17_0_cuda_9_2"' ]]
then
client_download "CryptoDredge"
fi ## [[ $CLIENT == "cryptodredge_0_19_1_c10" ]]
###
if [[ $CLIENT == '"trex_0_14_4_c10"' || $CLIENT == '"trex_0_10_2_c10"' || $CLIENT == '"trex_0_9_2_c10"' || $CLIENT == '"trex_0_9_2_c9"' ]]
then
client_download "t-rex"
fi ## [[ $CLIENT == "trex_0_10_2_c10" ]]
###
if [[ $CLIENT == '"gminer_1_42"' || $CLIENT == '"gminer_1_41"' || $CLIENT == '"gminer_1_40"' || $CLIENT == '"gminer_1_39"' || $CLIENT == '"gminer_1_38"' ]]
then
client_download "miner"
fi ## [[ $CLIENT == "gminer_1_42" ]]
###
if [[ $CLIENT == '"bminer_15_5_1"' ]]
then
client_download "bminer"
fi ## [[ $CLIENT == "bminer_v15_5_1" ]]
###
if [[ $CLIENT == '"z_enemy_2_0"' || $CLIENT == '"z_enemy_1_28"' ]]
then
client_download "z-enemy"
fi ## [[ $CLIENT == "z_enemy_2_0" ]]
###
if [[ $CLIENT == '"claymore_14_2"' || $CLIENT == '"claymore_12_0"' ]]
#if [[ $CLIENT == '"claymore_12_0"' ]]
then
CLIENT='"claymore_12_0"'
client_download "ethdcrminer64"
fi ## [[ $CLIENT == "claymore" ]]
###

#if [[ $CLIENT == '"claymore_14_2"' ]]
#then
#client_download "EthDcrMiner64.exe"
#fi ## [[ $CLIENT == "claymore_14_2" ]]

###
if [[ $CLIENT == '"PhoenixMiner_4_2c"' ]]
then
client_download "PhoenixMiner"
fi ## [[ $CLIENT == "PhoenixMiner_4_2c" ]]
###
if [[ $CLIENT == '"bci_progpowminer"' ]]
then
client_download "progpowminer_9.2"
fi ## [[ $CLIENT == "bci_progpowminer" ]]
###
if [[ $CLIENT == '"fullzero"' ]]
then
client_download "ETHASH"
fi ## [[ $CLIENT == "fullzero" ]]
###
if [[ $CLIENT == '"ethminer_0_17_1"' ]]
then
client_download "ethminer"
fi ## [[ $CLIENT == "ethminer_0_17_1" ]]
###
if [[ $CLIENT == '"ewbf"' ]]
then
client_download "miner"
fi ## [[ $CLIENT == "ewbf" ]]
###




#(PL,CC,MC,FS,EH) example: 130,100,500,49,1
#CLIENT_OC
INDEX=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
POWERLIMIT_WATTS=${CLIENT_OC:1:INDEX}
INDEX=$(($INDEX + 2))
CLIENT_OC=${CLIENT_OC:INDEX}
INDEX=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CORE_OVERCLOCK=${CLIENT_OC:0:INDEX}
INDEX=$(($INDEX + 1))
CLIENT_OC=${CLIENT_OC:INDEX}
INDEX=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | head -n1)
MEMORY_OVERCLOCK=${CLIENT_OC:0:INDEX}
INDEX=$(($INDEX + 1))
CLIENT_OC=${CLIENT_OC:INDEX}
INDEX=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | head -n1)
FAN_SPEED=${CLIENT_OC:0:INDEX}
INDEX=$(($INDEX + 1))
CLIENT_OC=${CLIENT_OC:INDEX}
INDEX=$(echo $CLIENT_OC | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
EXPECTED_HASHRATE=${CLIENT_OC:0:INDEX}

echo ""
echo "CLIENT is: '$CLIENT'"
echo ""
echo ""
echo "CLIENT_ARGS are: $CLIENT_ARGS"
echo ""
echo ""
echo "POWERLIMIT_WATTS is: $POWERLIMIT_WATTS"
echo ""
echo ""
echo "CORE_OVERCLOCK is: $CORE_OVERCLOCK"
echo ""
echo ""
echo "MEMORY_OVERCLOCK is: $MEMORY_OVERCLOCK"
echo ""
echo ""
echo "FAN_SPEED is: $FAN_SPEED"
echo ""
echo ""
echo "EXPECTED_HASHRATE is: $EXPECTED_HASHRATE"
echo ""
echo $CLIENT_LOCAL > /media/ramdisk/CLIENT_LOCAL
echo $CLIENT_ARGS > /media/ramdisk/CLIENT_ARGS
fi ##[[ $COIN == "CLIENT" ]]

# OC
sudo nvidia-smi -pl $POWERLIMIT_WATTS
N_LENGTH=${#INDIVIDUAL_POWERLIMITS}
if [[ $N_LENGTH > 2 ]]
then
Y="1"
if [[ $Y == "0" ]]
then
INDEX=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
GPU0=${INDIVIDUAL_POWERLIMITS:1:INDEX}
INDEX=$(($INDEX + 2))
INDIVIDUAL_POWERLIMITS=${INDIVIDUAL_POWERLIMITS:INDEX}
INDEX=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
GPU1=${INDIVIDUAL_POWERLIMITS:0:INDEX}
INDEX=$(($INDEX + 1))
INDIVIDUAL_POWERLIMITS=${INDIVIDUAL_POWERLIMITS:INDEX}
INDEX=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
GPU2=${INDIVIDUAL_POWERLIMITS:0:INDEX}
INDEX=$(($INDEX + 1))
INDIVIDUAL_POWERLIMITS=${INDIVIDUAL_POWERLIMITS:INDEX}
INDEX=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
GPU3=${INDIVIDUAL_POWERLIMITS:0:INDEX}
INDEX=$(($INDEX + 1))
INDIVIDUAL_POWERLIMITS=${INDIVIDUAL_POWERLIMITS:INDEX}
INDEX=$(echo $INDIVIDUAL_POWERLIMITS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
GPU4=${INDIVIDUAL_POWERLIMITS:0:INDEX}

GPU5=0
#implement GPU5 or any number of GPUs
echo ""
echo ""
echo "INDIVIDUAL_POWERLIMITS are: $INDIVIDUAL_POWERLIMITS"
echo ""
echo ""
echo ""
echo $INDIVIDUAL_POWERLIMITS > /media/ramdisk/INDIVIDUAL_POWERLIMITS

sudo nvidia-smi -i 0 -pl $GPU0
sudo nvidia-smi -i 1 -pl $GPU1
sudo nvidia-smi -i 2 -pl $GPU2
sudo nvidia-smi -i 3 -pl $GPU3
sudo nvidia-smi -i 4 -pl $GPU4
sudo nvidia-smi -i 5 -pl $GPU5
fi ##  [[ $Y == "0" ]]
fi ## if [[ $N_LENGTH > 2 ]]

GPUS=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
MSG='{"NUMBER_OF_GPUS": "'$GPUS'"}'
BULLET="${MSG}"
AUTH="${CUSTOMER_KEY}"
OUTPUT_LINE="$OVERLORD$SELF"
/usr/bin/curl -X PATCH --output /dev/null $OUTPUT_LINE --header "Authorization: $AUTH" --header "Content-Type: application/json" -d "$BULLET"
NVD=nvidia-settings
sudo nvidia-smi -pm 1
gpu=0
crash=0
while [ $gpu -lt $GPUS ]
do
${NVD} -a [gpu:$gpu]/GPUGraphicsClockOffset[2]=$CORE_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUMemoryTransferRateOffset[2]=$MEMORY_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUGraphicsClockOffset[3]=$CORE_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUMemoryTransferRateOffset[3]=$MEMORY_OVERCLOCK
gpu=$(($gpu+1))
done
gpu=0
MANUAL_FANS=1
while [ $gpu -lt $GPUS ]
do
if [ $FAN_SPEED -lt 50 ]
then
MANUAL_FANS=0
fi
${NVD} -a [gpu:$gpu]/GPUFanControlState=$MANUAL_FANS
if [[ $MANUAL_FANS == 1 ]]
then
${NVD} -a [fan:$gpu]/GPUTargetFanSpeed=$FAN_SPEED
fi
gpu=$(($gpu+1))
done
## OC

# clear log
> /media/ramdisk/screenlog.0
sleep 2
# WATCHDOG
if [[ $WATCHDOG == "YES" ]]
then
HCD='/media/ramdisk/3watchdog.sh'
echo ""
echo "LAUNCHING:  Watchdog"
sleep 2
running=$(ps -ef | awk '$NF~"3watchdog.sh" {print $2}')
if [ "$running" == "" ]
then
guake -n $HCD -r watchdog -e "bash $HCD"
echo ""
echo "process in guake terminal Tab (press f12 to view)"
echo ""
running=""
fi ## [ "$running" == "" ]
fi ## [[ $WATCHDOG == 'YES' ]]
## WATCHDOG

cd /media/ramdisk
if [[ $COIN == "CLIENT" && $CLIENT == '"xmrstak"' ]]
then
> /media/ramdisk/xmrstak/screenlog.0
cd /media/ramdisk/xmrstak
fi
if [[ $COIN == "CLIENT" && $CLIENT == '"bci_progpowminer"' ]]
then
> /media/ramdisk/bci_progpowminer/screenlog.0
cd /media/ramdisk/bci_progpowminer
fi
SHELL=$CLIENT_LOCAL
screen -dmS miner -L $SHELL

telegram
email_update

while [ 1 ]
do
sleep 1
done
fi
