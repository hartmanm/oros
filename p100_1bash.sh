#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

BASH_VERSION="1.4"
SUB_VERSION="p100"
#CLIENT='"cryptodredge_v0_18_0_cuda_9_2"'
#CLIENT='"cryptodredge_v0_17_0_cuda_9_2"'
#CLIENT='"cryptodredge_v0_18_0_cuda_10"'
#CLIENT='"trex"'
CLIENT='"trex_cuda10"'
#CLIENT='"fullzero"'
#CLIENT='"ewbf"'
#CLIENT='"gminer_1_38"'
# 0rig
ZRIG="/media/ramdisk/0rig*"
zrig=$(sed -e 's/\r$//' $ZRIG)
USER_ID=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="USER_ID"{printf("%s ", $4)}' | xargs)
RIG_NUMBER=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="RIG_NUMBER"{printf("%s ", $4)}' | xargs)
CUSTOMER_KEY=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="CUSTOMER_KEY"{printf("%s ", $4)}' | xargs)
OVERLORD=$(/usr/bin/curl $zrig 2>/dev/null | awk -F'"' '$2=="OVERLORD"{printf("%s ", $4)}' | xargs)
IPW=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
IP_AS_WORKER=$(echo -n $IPW | tail -c -3 | sed 'y/./0/')
MAC=$(ifconfig -a | grep -Po 'HWaddr \K.*$')
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

POWERLIMIT_WATTS="175"
CORE_OVERCLOCK="100"
MEMORY_OVERCLOCK="500"
FAN_SPEED="48"
EXPECTED_HASHRATE="2"
INDIVIDUAL_POWERLIMITS=""

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
var=ETH_POOL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
ETH_POOL=${b[1]}
var=RVN_POOL
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_POOL=${b[1]}
var=RVN_ADDRESS
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RVN_ADDRESS=${b[1]}
var=ETH_ADDRESS
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
ETH_ADDRESS=${b[1]}
var=COIN
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
COIN=${b[1]}
var=RIG_NUMBER
out=$(echo $RIG | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $var)
eval b=($out)
RIG_NUMBER=${b[1]}

INDEX=$(echo $RIG | grep -aob "ETHASH_SPECIFIC_OC_SETTINGS" | grep -oE '[0-9]+' | tail -n1)
ETHASH_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:56}
INDEX2=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
ETHASH_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:INDEX2}
ETHASH_SPECIFIC_OC_SETTINGS=${ETHASH_SPECIFIC_OC_SETTINGS:32:INDEX2}
ETHASH_SPECIFIC_OC_SETTINGS='"'$ETHASH_SPECIFIC_OC_SETTINGS

INDEX=$(echo $RIG | grep -aob "R_SPECIFIC" | grep -oE '[0-9]+' | tail -n1)
X16R_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:100}
INDEX2=$(echo $X16R_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | tail -n1)
X16R_SPECIFIC_OC_SETTINGS=${RIG:$INDEX:INDEX2}
X16R_SPECIFIC_OC_SETTINGS=${X16R_SPECIFIC_OC_SETTINGS:27:INDEX2}
X16R_SPECIFIC_OC_SETTINGS='"'$X16R_SPECIFIC_OC_SETTINGS

#INDEX=$(echo $RIG | grep -aob "CLIENT" | grep -oE '[0-9]+' | tail -n1)
#CLIENT=${RIG:$INDEX:250}
#INDEX2=$(echo $CLIENT | grep -aob "," | grep -oE '[0-9]+' | head -n1)
#CLIENT=${RIG:$INDEX:INDEX2}
#CLIENT=${CLIENT:11:INDEX2}
#CLIENT='"'$CLIENT

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
if [ $VERSION == "_init" ]
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

if [[ $COIN == "ETH" ]]
then
CLIENT_LOCAL="/media/ramdisk/fullzero/ETHASH -U -S $ETH_POOL -O $ETH_ADDRESS.$RIG_NUMBER:x;"
#CLIENT_LOCAL="/media/ramdisk/ethminer/0_17/ethminer -U -P stratum+tcp://$ETH_ADDRESS.$RIG_NUMBER:x@$ETH_POOL --api-bind -3333"
ETHASH="/media/ramdisk/fullzero"
if [[ ! -d $ETHASH ]]
then
# download fullzero ETHASH to ramdisk
cd /media/ramdisk
FILENAME="fullzero.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/fullzero/ETHASH
fi ## [[ ! -d $ETHASH ]]
#(PL,CC,MC,FS,EH)
#ETHASH_SPECIFIC_OC_SETTINGS
Y="0"
if [[ $Y == "0" ]]
then
INDEX=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
POWERLIMIT_WATTS=${ETHASH_SPECIFIC_OC_SETTINGS:1:INDEX}
INDEX=$(($INDEX + 2))
ETHASH_SPECIFIC_OC_SETTINGS=${ETHASH_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
CORE_OVERCLOCK=${ETHASH_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
ETHASH_SPECIFIC_OC_SETTINGS=${ETHASH_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
MEMORY_OVERCLOCK=${ETHASH_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
ETHASH_SPECIFIC_OC_SETTINGS=${ETHASH_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
FAN_SPEED=${ETHASH_SPECIFIC_OC_SETTINGS:0:INDEX}
INDEX=$(($INDEX + 1))
ETHASH_SPECIFIC_OC_SETTINGS=${ETHASH_SPECIFIC_OC_SETTINGS:INDEX}
INDEX=$(echo $ETHASH_SPECIFIC_OC_SETTINGS | grep -aob "," | grep -oE '[0-9]+' | head -n1)
INDEX=$(($INDEX - 1))
EXPECTED_HASHRATE=${ETHASH_SPECIFIC_OC_SETTINGS:0:INDEX}
echo ""
echo ""
echo "ETHASH_SPECIFIC_OC_SETTINGS are: $ETHASH_SPECIFIC_OC_SETTINGS"
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
fi ## [[ $COIN == "ETH" ]]

if [[ $COIN == "RVN" ]]
then
#CLIENT_LOCAL="/media/ramdisk/suprminer/ccminer -a x16r -o $RVN_POOL -u $RVN_ADDRESS.$RIG_NUMBER -p x;"
CLIENT_LOCAL="/media/ramdisk/trex_cuda10/t-rex -a x16r -o $RVN_POOL -u $RVN_ADDRESS.$RIG_NUMBER -p x;"
N_LENGTH=${#NANOPOOL_EMAIL}
if [[ $N_LENGTH > 10 ]]
then
CLIENT_LOCAL="/media/ramdisk/trex_cuda10/t-rex -a x16r -o $RVN_POOL -u $RVN_ADDRESS.$RIG_NUMBER/$NANOPOOL_EMAIL -p x;"
fi
TREX="/media/ramdisk/trex_cuda10"
if [[ ! -d $TREX ]]
then
# download trex to ramdisk
cd /media/ramdisk
FILENAME="trex_cuda10.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/trex_cuda10/t-rex
fi ## [[ ! -d $TREX ]]
#(PL,CC,MC,FS,EH)
#X16R_SPECIFIC_OC_SETTINGS
Y="0"
if [[ $Y == "0" ]]
then
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
fi ##  [[ $Y == "0" ]]
fi ## [[ $COIN == "RVN" ]]


if [[ $COIN == "CLIENT" ]]
then
#CLIENT_ARGS=${CLIENT_ARGS}
CLIENT=${CLIENT}


if [[ $CLIENT == '"xmrstak"' ]]
then
XMRSTAK="/media/ramdisk/xmrstak"
if [[ ! -d $XMRSTAK ]]
then
# download xmrstak to ramdisk
cd /media/ramdisk
FILENAME="xmrstak.zip"
URL="https://openrig.net/$FILENAME"
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


if [[ $CLIENT == '"cryptodredge_v0_17_0_cuda_9_2"' ]]
then
CLIENT_LOCAL="/media/ramdisk/cryptodredge_v0_17_0_cuda_9_2/CryptoDredge ${CLIENT_ARGS:1:-1}"
CRYPTODREDGE="/media/ramdisk/cryptodredge_v0_17_0_cuda_9_2"
if [[ ! -d $CRYPTODREDGE ]]
then
# download cryptodredge to ramdisk
cd /media/ramdisk
FILENAME="cryptodredge_v0_17_0_cuda_9_2.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/cryptodredge_v0_17_0_cuda_9_2/CryptoDredge
fi ## [[ ! -d $CRYPTODREDGE ]]
fi ## [[ $CLIENT == "cryptodredge_v0_17_0_cuda_9_2" ]]

if [[ $CLIENT == '"cryptodredge_v0_18_0_cuda_10"' ]]
then
CLIENT_LOCAL="/media/ramdisk/cryptodredge_v0_18_0_cuda_10/CryptoDredge ${CLIENT_ARGS:1:-1}"
CRYPTODREDGE="/media/ramdisk/cryptodredge_v0_18_0_cuda_10"
if [[ ! -d $CRYPTODREDGE ]]
then
# download cryptodredge to ramdisk
cd /media/ramdisk
FILENAME="cryptodredge_v0_18_0_cuda_10.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/cryptodredge_v0_18_0_cuda_10/CryptoDredge
fi ## [[ ! -d $CRYPTODREDGE ]]
fi ## [[ $CLIENT == "cryptodredge_v0_18_0_cuda_10" ]]

if [[ $CLIENT == '"cryptodredge_v0_18_0_cuda_9_2"' ]]
then
CLIENT_LOCAL="/media/ramdisk/cryptodredge_v0_18_0_cuda_9_2/CryptoDredge ${CLIENT_ARGS:1:-1}"
CRYPTODREDGE="/media/ramdisk/cryptodredge_v0_18_0_cuda_9_2"
if [[ ! -d $CRYPTODREDGE ]]
then
# download cryptodredge to ramdisk
cd /media/ramdisk
FILENAME="cryptodredge_v0_18_0_cuda_9_2.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/cryptodredge_v0_18_0_cuda_9_2/CryptoDredge
fi ## [[ ! -d $CRYPTODREDGE ]]
fi ## [[ $CLIENT == "cryptodredge_v0_18_0_cuda_9_2" ]]


if [[ $CLIENT == '"gminer_1_38"' ]]
then
CLIENT_LOCAL="/media/ramdisk/gminer_1_38/miner ${CLIENT_ARGS:1:-1}"
GMINER="/media/ramdisk/gminer_1_38"
if [[ ! -d $GMINER ]]
then
# download gminer to ramdisk
cd /media/ramdisk
FILENAME="gminer_1_38.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/gminer_1_38/miner
fi ## [[ ! -d $GMINER ]]
fi ## [[ $CLIENT == "gminer_1_38" ]]

if [[ $CLIENT == '"trex"' ]]
then
CLIENT_LOCAL="/media/ramdisk/trex/t-rex ${CLIENT_ARGS:1}"
TREX="/media/ramdisk/trex"
if [[ ! -d $TREX ]]
then
# download trex to ramdisk
cd /media/ramdisk
FILENAME="trex.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/trex/t-rex
fi ## [[ ! -d $TREX ]]
fi ## [[ $CLIENT == "trex" ]]
###
if [[ $CLIENT == '"trex_cuda10"' ]]
then
CLIENT_LOCAL="/media/ramdisk/trex_cuda10/t-rex ${CLIENT_ARGS:1:-1}" ###
TREX="/media/ramdisk/trex_cuda10"
if [[ ! -d $TREX ]]
then
# download trex_cuda10 to ramdisk
cd /media/ramdisk
FILENAME="trex_cuda10.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/trex_cuda10/t-rex
fi ## [[ ! -d $TREX ]]
fi ## [[ $CLIENT == "trex_cuda10" ]]
###
if [[ $CLIENT == '"fullzero"' ]]
then
CLIENT_LOCAL="/media/ramdisk/fullzero/ETHASH ${CLIENT_ARGS:1:-1}"
ETHASH="/media/ramdisk/fullzero"
if [[ ! -d $ETHASH ]]
then
# download fullzero ETHASH to ramdisk
cd /media/ramdisk
FILENAME="fullzero.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/fullzero/ETHASH
fi ## [[ ! -d $ETHASH ]]
fi ## [[ $CLIENT == "fullzero" ]]

if [[ $CLIENT == '"ewbf"' ]]
then
CLIENT_LOCAL="/media/ramdisk/ewbf/miner $CLIENT_ARGS"
EWBF="/media/ramdisk/ewbf"
if [[ ! -d $EWBF ]]
then
# download ewbf to ramdisk
cd /media/ramdisk
FILENAME="ewbf.zip"
URL="https://openrig.net/$FILENAME"
wget --no-check-certificate $URL -O $FILENAME
sleep 2
unzip $FILENAME
sleep 2
sudo rm -r /media/ramdisk/__MACOSX
chmod +x /media/ramdisk/ewbf/miner
fi ## [[ ! -d $EWBF ]]
fi ## [[ $CLIENT == "ewbf" ]]


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

cd /media/ramdisk
if [[ $COIN == "CLIENT" && $CLIENT == '"xmrstak"' ]]
then
> /media/ramdisk/xmrstak/screenlog.0
cd /media/ramdisk/xmrstak
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
