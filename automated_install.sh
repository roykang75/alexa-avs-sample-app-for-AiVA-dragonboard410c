#!/bin/bash

#-------------------------------------------------------
# Paste from developer.amazon.com below
#-------------------------------------------------------

while [[ -z $ProductID ]] ; do
    echo "Enter your ProductId:"
    read ProductID
#    export SDK_CONFIG_PRODUCT_ID
done
while [[ -z $ClientID ]] ; do
    echo "Enter your ClientId:"
    read ClientID
#    export SDK_CONFIG_CLIENT_ID
done
while [[ -z $ClientSecret ]] ; do
    echo "Enter your ClientSecret:"
    read ClientSecret
#    export SDK_CONFIG_CLIENT_SECRET
done

#-------------------------------------------------------
# No need to change anything below this...
#-------------------------------------------------------

#-------------------------------------------------------
# Pre-populated for testing. Feel free to change.
#-------------------------------------------------------

# Your Country. Must be 2 characters!
Country='US'
# Your state. Must be 2 or more characters.
State='WA'
# Your city. Cannot be blank.
City='SEATTLE'
# Your organization name/company name. Cannot be blank.
Organization='AVS_USER'
# Your device serial number. Cannot be blank, but can be any combination of characters.
DeviceSerialNumber='123456789'
# Your KeyStorePassword. We recommend leaving this blank for testing.
KeyStorePassword=''

#-------------------------------------------------------
# add library path
#-------------------------------------------------------
echo "export LD_LIBRARY_PATH=/usr/lib/vlc:/usr/local/lib" | tee -a ~/.bashrc
echo "export VLC_PLUGIN_PATH=/usr/lib/vlc/plugins:/usr/local/lib/pkgconfig" | tee -a ~/.bashrc
echo "unset JAVA_TOOL_OPTIONS" | tee -a ~/.bashrc
source ~/.bashrc

#-------------------------------------------------------
# Function to parse user's input.
#-------------------------------------------------------
# Arguments are: Yes-Enabled No-Enabled Quit-Enabled
YES_ANSWER=1
NO_ANSWER=2
QUIT_ANSWER=3
parse_user_input()
{
  if [ "$1" = "0" ] && [ "$2" = "0" ] && [ "$3" = "0" ]; then
    return
  fi
  while [ true ]; do
    Options="["
    if [ "$1" = "1" ]; then
      Options="${Options}y"
      if [ "$2" = "1" ] || [ "$3" = "1" ]; then
        Options="$Options/"
      fi
    fi
    if [ "$2" = "1" ]; then
      Options="${Options}n"
      if [ "$3" = "1" ]; then
        Options="$Options/"
      fi
    fi
    if [ "$3" = "1" ]; then
      Options="${Options}quit"
    fi
    Options="$Options]"
    read -p "$Options >> " USER_RESPONSE
    USER_RESPONSE=$(echo $USER_RESPONSE | awk '{print tolower($0)}')
    if [ "$USER_RESPONSE" = "y" ] && [ "$1" = "1" ]; then
      return $YES_ANSWER
    else
      if [ "$USER_RESPONSE" = "n" ] && [ "$2" = "1" ]; then
        return $NO_ANSWER
      else
        if [ "$USER_RESPONSE" = "quit" ] && [ "$3" = "1" ]; then
          printf "\nGoodbye.\n\n"
          exit
        fi
      fi
    fi
    printf "Please enter a valid response.\n"
  done
}

#----------------------------------------------------------------
# Function to select a user's preference between several options
#----------------------------------------------------------------
# Arguments are: result_var option1 option2...
select_option()
{
  local _result=$1
  local ARGS=("$@")
  if [ "$#" -gt 0 ]; then
      while [ true ]; do
         local count=1
         for option in "${ARGS[@]:1}"; do
            echo "$count) $option"
            ((count+=1))
         done
         echo ""
         local USER_RESPONSE
         read -p "Please select an option [1-$(($#-1))] " USER_RESPONSE
         case $USER_RESPONSE in
             ''|*[!0-9]*) echo "Please provide a valid number"
                          continue
                          ;;
             *) if [[ "$USER_RESPONSE" -gt 0 && $((USER_RESPONSE+1)) -le "$#" ]]; then
                    local SELECTION=${ARGS[($USER_RESPONSE)]}
                    echo "Selection: $SELECTION"
                    eval $_result=\$SELECTION
                    return
                else
                    clear
                    echo "Please select a valid option"
                fi
                ;;
         esac
      done
  fi
}

#-------------------------------------------------------
# Function to retrieve user account credentials
#-------------------------------------------------------
# Argument is: the expected length of user input
Credential=""
get_credential()
{
  Credential=""
  read -p ">> " Credential
  while [ "${#Credential}" -lt "$1" ]; do
    echo "Input has invalid length."
    echo "Please try again."
    read -p ">> " Credential
  done
}

#-------------------------------------------------------
# Function to confirm user credentials.
#-------------------------------------------------------
check_credentials()
{
  clear
  echo "====== AVS + AiVA and DragonBoard 410c User Credentials======"
  echo ""
  echo ""
  if [ "${#ProductID}" -eq 0 ] || [ "${#ClientID}" -eq 0 ] || [ "${#ClientSecret}" -eq 0 ]; then
    echo "At least one of the needed credentials (ProductID, ClientID or ClientSecret) is missing."
    echo ""
    echo ""
    echo "These values can be found here https://developer.amazon.com/edw/home.html, fix this now?"
    echo ""
    echo ""
    parse_user_input 1 0 1
  fi

  # Print out of variables and validate user inputs
  if [ "${#ProductID}" -ge 1 ] && [ "${#ClientID}" -ge 15 ] && [ "${#ClientSecret}" -ge 15 ]; then
    echo "ProductID >> $ProductID"
    echo "ClientID >> $ClientID"
    echo "ClientSecret >> $ClientSecret"
    echo ""
    echo ""
    echo "Is this information correct?"
    echo ""
    echo ""
    parse_user_input 1 1 0
    USER_RESPONSE=$?
    if [ "$USER_RESPONSE" = "$YES_ANSWER" ]; then
      return
    fi
  fi

  clear
  # Check ProductID
  NeedUpdate=0
  echo ""
  if [ "${#ProductID}" -eq 0 ]; then
    echo "Your ProductID is not set"
    NeedUpdate=1
  else
    echo "Your ProductID is set to: $ProductID."
    echo "Is this information correct?"
    echo ""
    parse_user_input 1 1 0
    USER_RESPONSE=$?
    if [ "$USER_RESPONSE" = "$NO_ANSWER" ]; then
      NeedUpdate=1
    fi
  fi
  if [ $NeedUpdate -eq 1 ]; then
    echo ""
    echo "This value should match your ProductID (or Device Type ID) entered at https://developer.amazon.com/edw/home.html."
    echo "The information is located under Device Type Info"
    echo "E.g.: RaspberryPi3"
    get_credential 1
    ProductID=$Credential
  fi

  echo "-------------------------------"
  echo "ProductID is set to >> $ProductID"
  echo "-------------------------------"

  # Check ClientID
  NeedUpdate=0
  echo ""
  if [ "${#ClientID}" -eq 0 ]; then
    echo "Your ClientID is not set"
    NeedUpdate=1
  else
    echo "Your ClientID is set to: $ClientID."
    echo "Is this information correct?"
    echo ""
    parse_user_input 1 1 0
    USER_RESPONSE=$?
    if [ "$USER_RESPONSE" = "$NO_ANSWER" ]; then
      NeedUpdate=1
    fi
  fi
  if [ $NeedUpdate -eq 1 ]; then
    echo ""
    echo "Please enter your ClientID."
    echo "This value should match the information at https://developer.amazon.com/edw/home.html."
    echo "The information is located under the 'Security Profile' tab."
    echo "E.g.: amzn1.application-oa2-client.xxxxxxxx"
    get_credential 28
    ClientID=$Credential
  fi

  echo "-------------------------------"
  echo "ClientID is set to >> $ClientID"
  echo "-------------------------------"

  # Check ClientSecret
  NeedUpdate=0
  echo ""
  if [ "${#ClientSecret}" -eq 0 ]; then
    echo "Your ClientSecret is not set"
    NeedUpdate=1
  else
    echo "Your ClientSecret is set to: $ClientSecret."
    echo "Is this information correct?"
    echo ""
    parse_user_input 1 1 0
    USER_RESPONSE=$?
    if [ "$USER_RESPONSE" = "$NO_ANSWER" ]; then
      NeedUpdate=1
    fi
  fi
  if [ $NeedUpdate -eq 1 ]; then
    echo ""
    echo "Please enter your ClientSecret."
    echo "This value should match the information at https://developer.amazon.com/edw/home.html."
    echo "The information is located under the 'Security Profile' tab."
    echo "E.g.: fxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxa"
    get_credential 20
    ClientSecret=$Credential
  fi

  echo "-------------------------------"
  echo "ClientSecret is set to >> $ClientSecret"
  echo "-------------------------------"

  check_credentials
}

#-------------------------------------------------------
# Inserts user-provided values into a template file
#-------------------------------------------------------
# Arguments are: template_directory, template_name, target_name
use_template()
{
  Template_Loc=$1
  Template_Name=$2
  Target_Name=$3
  while IFS='' read -r line || [[ -n "$line" ]]; do
    while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]]; do
      LHS=${BASH_REMATCH[1]}
      RHS="$(eval echo "\"$LHS\"")"
      line=${line//$LHS/$RHS}
    done
    echo "$line" >> "$Template_Loc/$Target_Name"
  done < "$Template_Loc/$Template_Name"
}

#-------------------------------------------------------
# Get alpn-boot.version according to the Java version
#-------------------------------------------------------
get_alpn_version()
{
  Java_Version=`java -version 2>&1 | awk 'NR==1{ gsub(/"/,""); print $3 }'`
  echo "java version: $Java_Version "
  Java_Major_Version=$(echo $Java_Version | cut -d '_' -f 1)
  Java_Minor_Version=$(echo $Java_Version | cut -d '_' -f 2)
  echo "major version: $Java_Major_Version minor version: $Java_Minor_Version"
  
  Alpn_Version=""
  if [ "$Java_Major_Version" = "1.8.0" ] && [ "$Java_Minor_Version" -gt 59 ]; then
    if [ "$Java_Minor_Version" -gt 160 ]; then
      Alpn_Version="8.1.12.v20180117"
    elif [ "$Java_Minor_Version" -gt 120 ]; then
      Alpn_Version="8.1.11.v20170118"
    elif [ "$Java_Minor_Version" -gt 111 ]; then
      Alpn_Version="8.1.10.v20161026"
    elif [ "$Java_Minor_Version" -gt 100 ]; then
      Alpn_Version="8.1.9.v20160720"
    elif [ "$Java_Version" == "1.8.0_92" ]; then
      Alpn_Version="8.1.8.v20160420"
    elif [ "$Java_Minor_Version" -gt 70 ]; then
      Alpn_Version="8.1.7.v20160121"
    elif [[ $Java_Version ==  "1.8.0_66" ]]; then
      Alpn_Version="8.1.6.v20151105"
    elif [[ $Java_Version ==  "1.8.0_65" ]]; then
      Alpn_Version="8.1.6.v20151105"
    elif [[ $Java_Version ==  "1.8.0_60" ]]; then
      Alpn_Version="8.1.5.v20150921"
    fi
  else
    echo "Unsupported or unknown java version ($Java_Version), defaulting to latest known ALPN."
    Echo "Check http://www.eclipse.org/jetty/documentation/current/alpn-chapter.html#alpn-versions to get the alpn version matching your JDK version."
    read -t 10 -p "Hit ENTER or wait ten seconds"
  fi
}

#-------------------------------------------------------
# Script to check if all is good before install script runs
#-------------------------------------------------------
clear
echo "====== AVS + AiVA and DragonBoard 410c Licenses and Agreement ======"
echo ""
echo ""
echo "This code base is dependent on several external libraries and virtual environments like cmuSphinx, cmuPocksphinx, 96BoardGPIO, libsoc, Atlas, VLC, NodeJS, npm, OpenJDK, OpenSSL, Maven & CMake."
echo ""
echo "Please read the document \"Installer_Licenses.txt\" from the sample app repository and the corresponding licenses of the above."
echo ""
echo "Do you agree to the terms and conditions of the necessary software from the third party sources and want to download the necessary software from the third party sources?"
echo ""
echo ""
echo "======================================================="
echo ""
echo ""
parse_user_input 1 0 1

clear
echo "=============== AVS + AiVA and DragonBoard 410c Installer =========="
echo ""
echo ""
echo "Welcome to the AVS + AiVA and DragonBoard 410c installer."
echo "If you don't have an Amazon developer account, please register for one"
echo "at https://developer.amazon.com/edw/home.html and follow the"
echo "instructions on github.com to create an AVS device or application."
echo ""
echo ""
echo "======================================================="
echo ""
echo ""
echo "Do you have an Amazon developer account?"
echo ""
echo ""
parse_user_input 1 1 1
USER_RESPONSE=$?
if [ "$USER_RESPONSE" = "$NO_ANSWER" ]; then
  clear
  echo "====== Register for an Amazon Developer Account ======="
  echo ""
  echo ""
  echo "Please register for an Amazon developer account\nat https://developer.amazon.com/edw/home.html before continuing."
  echo ""
  echo ""
  echo "Ready to continue?"
  echo ""
  echo ""
  echo "======================================================="
  echo ""
  echo ""
  parse_user_input 1 0 1
fi


#--------------------------------------------------------------------------------------------
# Checking if script has been updated by the user with ProductID, ClientID, and ClientSecret
#--------------------------------------------------------------------------------------------

if [ "$ProductID" = "YOUR_PRODUCT_ID_HERE" ]; then
  ProductID=""
fi
if [ "$ClientID" = "YOUR_CLIENT_ID_HERE" ]; then
  ClientID=""
fi
if [ "$ClientSecret" = "YOUR_CLIENT_SECRET_HERE" ]; then
  ClientSecret=""
fi

check_credentials

# Preconfigured variables
OS=debian
User=$(id -un)
Group=$(id -gn)
Origin=$(pwd)
Samples_Loc=$Origin/samples
Java_Client_Loc=$Samples_Loc/javaclient
Wake_Word_Agent_Loc=$Samples_Loc/wakeWordAgent
Companion_Service_Loc=$Samples_Loc/companionService
#libsoc_Loc=$Wake_Word_Agent_Loc/libsoc
#DB410cBoardsGPIO_Loc=$Wake_Word_Agent_Loc/96BoardsGPIO
NineSixBoardsLib_Loc=$Origin/96Boards
SphinxLib_Loc=$Origin/cmuSphinx
External_Loc=$Wake_Word_Agent_Loc/ext
Locale="en-US"

mkdir $External_Loc
mkdir $NineSixBoardsLib_Loc
mkdir $SphinxLib_Loc

# Select a Locale
clear
echo "==== Setting Locale ====="
echo ""
echo ""
echo "Which locale would you like to use?"
echo ""
echo ""
echo "======================================================="
echo ""
echo ""
select_option Locale "en-US" "en-GB" "de-DE" "en-CA" "en-IN" "ja-JP" "en-AU"

Wake_Word_Detection_Enabled="true"
# Check if user wants to enable Wake Word "Alexa" Detection
clear
echo "=== Enabling GPIO Wake-Up Detection ===="
echo ""
echo ""
echo "Do you want to enable GPIO Wake-Up Detection?"
echo ""
echo ""
echo "======================================================="
echo ""
echo ""
parse_user_input 1 1 1
USER_RESPONSE=$?
if [ "$USER_RESPONSE" = "$NO_ANSWER" ]; then
  Wake_Word_Detection_Enabled="false"
fi

echo ""
echo ""
echo "==============================="
echo "*******************************"
echo " *** STARTING INSTALLATION ***"
echo "  ** this may take a while **"
echo "   *************************"
echo "   ========================="
echo ""
echo ""

# Install dependencies
echo "========== Update Aptitude ==========="
sudo apt-get update
sudo apt-get upgrade -yq

echo "Install package dependencies"
echo "sudo apt-get install -y git build-essential autoconf automake libtool swig3.0 python-dev nodejs-dev cmake pkg-config libpcre3-dev openjdk-8-jdk vlc-nox vlc-data nano"
sudo apt-get install -y git build-essential autoconf automake libtool swig3.0 python-dev nodejs-dev cmake pkg-config libpcre3-dev openjdk-8-jdk vlc-nox vlc-data nano

echo "========== Installing Libraries ALSA, Atlas ==========="
sudo apt-get -y install libasound2-dev
sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install pulseaudio
sudo ldconfig

echo "========== Installing Libraries for cmuSphinx ==========="
sudo apt-get -y install bison libasound2-dev swig autoconf automake libtool python-dev

echo "========== Getting the code for libsoc ==========="
cd $NineSixBoardsLib_Loc
git clone https://github.com/jackmitch/libsoc.git
cd libsoc
autoreconf -i
./configure --enable-python2 --enable-board="dragonboard410c"
make && sudo make install
sudo ldconfig

echo "========== Getting the code for 96BoardsGPIO ==========="
cd $NineSixBoardsLib_Loc
git clone https://github.com/roykang75/96BoardsGPIO.git
cd 96BoardsGPIO
./autogen.sh
./configure
make && sudo make install
sudo ldconfig

echo "========== Getting the code for cmuSphinxbase ==========="
cd $SphinxLib_Loc
git clone https://github.com/roykang75/sphinxbase.git
cd sphinxbase
./autogen.sh
./configure --enable-fixed
make
sudo make install

echo "========== Getting the code for cmuPocketSphin AiVA DB410c ==========="
cd $SphinxLib_Loc
git clone https://github.com/roykang75/pocketsphinx-AiVA-DB410c.git

cd pocketsphinx-AiVA-DB410c
mkdir extlib
cp ../../96Boards/96BoardsGPIO/lib/.libs/lib96BoardsGPIO.la ./extlib
cp ../../96Boards/96BoardsGPIO/lib/.libs/lib96BoardsGPIO.so ./extlib

cp ../../96Boards/libsoc/lib/.libs/libsoc.la ./extlib
cp ../../96Boards/libsoc/lib/.libs/libsoc.so ./extlib

./autogen.sh
./configure
make
sudo make install

cd $Origin

echo "========== Installing VLC and associated Environmental Variables =========="
sudo apt-get install -y vlc vlc-nox vlc-data
#Make sure that the libraries can be found
sudo sh -c "echo \"/usr/lib/vlc\" >> /etc/ld.so.conf.d/vlc_lib.conf"
sudo sh -c "echo \"VLC_PLUGIN_PATH=\"/usr/lib/vlc/plugin\"\" >> /etc/environment"

# Create a libvlc soft link if doesn't exist
if ! ldconfig -p | grep "libvlc.so "; then
  [ -e $Java_Client_Loc/lib ] || mkdir $Java_Client_Loc/lib
  if ! [ -e $Java_Client_Loc/lib/libvlc.so ]; then
   Target_Lib=`ldconfig -p | grep libvlc.so | sort | tail -n 1 | rev | cut -d " " -f 1 | rev`
   ln -s $Target_Lib $Java_Client_Loc/lib/libvlc.so
  fi 
fi

sudo ldconfig

echo "========== Installing NodeJS =========="
sudo apt-get install -y nodejs npm build-essential
sudo ln -s /usr/bin/nodejs /usr/bin/node
node -v
sudo ldconfig

echo "========== Installing Maven =========="
sudo apt-get install -y maven
mvn -version
sudo ldconfig

echo "========== Installing OpenSSL and Generating Self-Signed Certificates =========="
sudo apt-get install -y openssl
sudo ldconfig

unset JAVA_TOOL_OPTIONS

echo "========== Generating ssl.cnf =========="
if [ -f $Java_Client_Loc/ssl.cnf ]; then
  rm $Java_Client_Loc/ssl.cnf
fi
use_template $Java_Client_Loc template_ssl_cnf ssl.cnf

echo "========== Generating generate.sh =========="
if [ -f $Java_Client_Loc/generate.sh ]; then
  rm $Java_Client_Loc/generate.sh
fi
use_template $Java_Client_Loc template_generate_sh generate.sh

echo "========== Executing generate.sh =========="
chmod +x $Java_Client_Loc/generate.sh
cd $Java_Client_Loc && bash ./generate.sh
cd $Origin

echo "========== Configuring Companion Service =========="
if [ -f $Companion_Service_Loc/config.js ]; then
  rm $Companion_Service_Loc/config.js
fi
use_template $Companion_Service_Loc template_config_js config.js

echo "========== Configuring Java Client =========="
if [ -f $Java_Client_Loc/config.json ]; then
  rm $Java_Client_Loc/config.json
fi
use_template $Java_Client_Loc template_config_json config.json

echo "========== Configuring ALSA Devices =========="
if [ -f /home/$User/.asoundrc ]; then
  rm /home/$User/.asoundrc
fi
printf "pcm.!default {\n  type asym\n   playback.pcm {\n     type plug\n     slave.pcm \"hw:0,0\"\n   }\n   capture.pcm {\n     type plug\n     slave.pcm \"hw:1,0\"\n   }\n}" >> /home/$User/.asoundrc

echo "========== Installing CMake =========="
sudo apt-get install -y cmake
sudo ldconfig

echo "========== Installing Java Client =========="
if [ -f $Java_Client_Loc/pom.xml ]; then
  rm $Java_Client_Loc/pom.xml
fi

get_alpn_version

cp $Java_Client_Loc/pom_pi.xml $Java_Client_Loc/pom.xml

sed -i "s/The latest version of alpn-boot that supports .*/The latest version of alpn-boot that supports JDK $Java_Version -->/" $Java_Client_Loc/pom.xml
sed -i "s:<alpn-boot.version>.*</alpn-boot.version>:<alpn-boot.version>$Alpn_Version</alpn-boot.version>:" $Java_Client_Loc/pom.xml

cd $Java_Client_Loc && mvn validate && mvn install && cd $Origin

echo "========== Installing Companion Service =========="
cd $Companion_Service_Loc && npm install && cd $Origin

if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
  echo "========== Preparing External dependencies for Wake Word Agent =========="
  mkdir $External_Loc/include
  mkdir $External_Loc/lib
  mkdir $External_Loc/resources

  cp $NineSixBoardsLib_Loc/libsoc/lib/include/*.h $External_Loc/include/
  cp $NineSixBoardsLib_Loc/libsoc/lib/.libs/libsoc.a $External_Loc/lib/libsoc.a

  cp $NineSixBoardsLib_Loc/96BoardsGPIO/lib/gpio.h $cp $External_Loc/include/
  cp $NineSixBoardsLib_Loc/96BoardsGPIO/lib/.libs/lib96BoardsGPIO.a $External_Loc/lib/lib96BoardsGPIO.a

  echo "========== Compiling Wake Word Agent =========="
  cd $Wake_Word_Agent_Loc/src && cmake . && make -j4
#  cd $Wake_Word_Agent_Loc/tst && cmake . && make -j4
fi

chown -R $User:$Group $Origin
chown -R $User:$Group /home/$User/.asoundrc

cd $Origin
chmod +x run_sphinx*
chmod +x sphinx_test.sh

echo ""
echo '============================='
echo '*****************************'
echo '========= Finished =========='
echo '*****************************'
echo '============================='
echo ""

Number_Terminals=2
if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
  Number_Terminals=3
fi
echo "To run the demo, do the following in $Number_Terminals seperate terminals:"
echo "Run the companion service: cd $Companion_Service_Loc && npm start"
echo "Run the AVS Java Client: cd $Java_Client_Loc && mvn exec:exec"
if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
  echo "Run the wake word agent: "
  echo "  GPIO: PLEASE NOTE -- If using this option, run the wake word agent as sudo:"
  echo "  cd $Wake_Word_Agent_Loc/src && sudo ./wakeWordAgent -e gpio"
fi
