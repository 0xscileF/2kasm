#!/bin/bash

DOCKERHUB_USERNAME="0xscilef" # Remember LOWERCASE :D
if [ ! -d "out" ]; then
	mkdir out
fi
IS_REMOTE_APP=0
IS_REMOTE_WEBTOP=1
if [ "$#" -lt 2 ]; then
    IS_REMOTE_APP=1
    IS_REMOTE_WEBTOP=0
fi
checkPackage() {
	TARGET_PACKAGE=$1
	BASE_URL="https://archlinux.org/packages/?sort=&q="
	AUR_URL="https://aur.archlinux.org/rpc/?v=5&type=search&by=name&arg="
	REQUEST_URL=$BASE_URL$TARGET_PACKAGE

	echo "Searching for $TARGET_PACKAGE in Core/Extra..."
	response=$(curl -s "$REQUEST_URL" | grep exact-matches)

	if [ ! -z "$response" ]; then
		repo=$(curl -s "$REQUEST_URL" | grep exact-matches -A30 | grep -E 'Core|Extra|Community')
		repo="${repo//"</td>"/}"
		repo="${repo//"<td>"/}"
		repo=$(echo "$repo" | xargs)
		if [ "$repo" = "Community" ]; then
			isAur=True
		fi
		TOINSTALL=$TARGET_PACKAGE
	else
		echo "Searching for $TARGET_PACKAGE in Community..."
		REQUEST_URL=$AUR_URL$TARGET_PACKAGE
		response=$(curl -s "$REQUEST_URL" | jq '.results | map(.Name) ')
		response=${response#'['}
		response=${response%']'}
		response=$(echo $response | xargs)
		if [ ! -z "$response" ]; then
			IFS=', ' read -r -a array <<<"$response"
			count=${#array[@]}
			if [ $count -gt 1 ]; then
				echo "Possible Candidates:"
				for i in $response; do
					name=$(echo $i | cut -c 1- | rev | cut -c2- | rev)
					echo "$i : name = $name"
					if [ $name = $TARGET_PACKAGE ]; then
						TOINSTALL=$name
						isAur=True
						break
					fi
				done
			elif [ $count -eq 1 ]; then
				name=$response
				TOINSTALL=$name
				isAur=True
			else
				# echo "No Package Candidate was found. Check spelling and try agian."
				echo "Neither '$TARGET_PACKAGE' nor possible candidates were found in 'Core/Extra/Community'"
				exit 1
			fi
		fi
	fi

}
echo "Can handle multiple programs, one fails all; First is autostarted; Space seperated list."
PACMAN_PKG=""
YAY_PKG=""
OMNI_PKG=""
for var in "$@"; do
	echo "$var"
	checkPackage "$var"
	if [ -z $TOINSTALL ]; then
		exit 1
	else
		echo "Wanted $TARGET_PACKAGE Got: $TOINSTALL"
		OMNI_PKG="$OMNI_PKG $TOINSTALL"
		if [ -z $isAur ]; then
			echo "Replacing in pacman"
			PACMAN_PKG="$PACMAN_PKG $TOINSTALL"
		else
			echo "Replacing in yay"
			YAY_PKG="$YAY_PKG $TOINSTALL"
		fi
	fi
done

TOINSTALL="$1"
EXEC_PATH=$TOINSTALL

BUILD_DIR="out/arch-$TOINSTALL"
BASEDIR="$(pwd)"
#  copy / reset base
if [ ! -d "$BUILD_DIR" ]; then
	cp -r arch-base $BUILD_DIR
	mv $BUILD_DIR/base.xml $BUILD_DIR/$TOINSTALL.xml
else
	rm -r $BUILD_DIR
	cp -r arch-base $BUILD_DIR
	mv $BUILD_DIR/base.xml $BUILD_DIR/$TOINSTALL.xml
fi
#cp base.xml out/$TOINSTALL.xml

# sed -i -e "s/YAY_PKG/$YAY_PKG/g" $BUILD_DIR/Dockerfile

# Get PKGBUILD
if [ -z $isAur ]; then
	PKGBUILD=$(curl -s "https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/$TOINSTALL/trunk/PKGBUILD")
else
	PKGBUILD=$(curl -s "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$TOINSTALL")
fi

# Get default execpath
PKGBUILDBUILD="${PKGBUILD//$'\\\n'/' '}"

#exit
PKGBUILD_PKGNAME=$(echo "$PKGBUILD" | grep 'pkgname=' | head -1 | sed 's/pkgname=//' | cut -d ' ' -f1)

PKGBUILD_PKGNAME=${PKGBUILD_PKGNAME//(/}
PKGBUILD_PKGNAME=${PKGBUILD_PKGNAME// /}
PKGBUILD_PKGBASE=$PKGBUILD_PKGNAME

#echo "ASDF $PKGBUILD_PKGNAME END"

#EXEC_PATH=$(echo "$PKGBUILD" | egrep "*ln -s*" | grep "/usr/bin" | xargs |cut -d ' ' -f4  | sed s/\$pkgdir// | sed 's/\$pkgname//' | sed 's/\${pkgdir}//' | sed 's/\${pkgname}//' | sed 's/\/\//\//')
#echo "Exec path should  be $EXEC_PATH"

#echo "BBBBB $PKGBUILD_PKGNAME OPER"
#echo "TESTEST $(echo "$PKGBUILDBUILD" | egrep "*ln -s*" | grep "/usr/bin" | xargs |cut -d ' ' -f4| sed s/\$pkgname/PKGBUILD_PKGNAME/ )"
EXEC_PATH=$(echo "$PKGBUILDBUILD" | egrep "*ln -s*" | grep "/usr/bin" | xargs | cut -d ' ' -f4 | sed "s/\$pkgname/$PKGBUILD_PKGNAME/" | sed 's/\$pkgdir//' | sed "s/\$pkgname/$PKGBUILD_PKGNAME/" | sed 's/\${pkgdir}//' | sed "s/\${pkgname}/$PKGBUILD_PKGNAME/" | sed "s/\${pkgbase}/$PKGBUILD_PKGNAME/" | sed 's/\/\//\//')
echo "Extracted Exec path is < $EXEC_PATH >"

SHORT_NAME=$(echo $TOINSTALL | cut -f1 -d"-")
if [[ ! "$EXEC_PATH" =~ "$SHORT_NAME" ]]; then
	echo "Couldn't extract exec path from pkgbuild.\nFalling back to name."
	EXEC_PATH=$SHORT_NAME
fi
echo "EXEC_PATH= $EXEC_PATH"

# Get favicon of upstream url
ICONURL=$(echo "$PKGBUILD" | grep -m1 "url" | sed s/url=// | cut -c2- | rev | cut -c2- | rev | sed -r 's#([^/])/[^/].*#\1#')/favicon.ico
echo "ICONURL=$ICONURL"

curl -o $BUILD_DIR/root/config/nobody/novnc-16x16.png "$ICONURL"

if [[ "$IS_REMOTE_WEBTOP" -eq 1 ]]; then
	sed -i -e "s/#IS_REMOTE_WEBTOP//g" $BUILD_DIR/Dockerfile
else
	sed -i -e "s/#IS_REMOTE_APP//g" $BUILD_DIR/Dockerfile
fi
sed -i -e "s/BASE_APPNAME/$SHORT_NAME/g" $BUILD_DIR/root/defaults/menu.xml
sed -i -e "s|EXEC_PATH|$EXEC_PATH|g" $BUILD_DIR/root/defaults/menu.xml
sed -i -e "s/OMNI_PKG/$OMNI_PKG/g" $BUILD_DIR/Dockerfile
# use | as delimeter as EXEC_PATH contains '/'
sed -i -e "s|EXEC_PATH|$EXEC_PATH|g" $BUILD_DIR/root/defaults/autostart

# sed -i -e "s/PACMAN_PKG/$PACMAN_PKG/g" $BUILD_DIR/Dockerfile
# sed -i -e "s/YAY_PKG/$YAY_PKG/g" $BUILD_DIR/Dockerfile

# keep track of used docker ports in list and set them accordingly in template file
NEXTPORT=$(expr $(cat ports) + 1)

# Update Template.xml
sed -i -e "s/BASE_APPNAME/$TOINSTALL/g" $BUILD_DIR/$TOINSTALL.xml
sed -i -e "s/BASE_PORT/$NEXTPORT/g" $BUILD_DIR/$TOINSTALL.xml
sed -i -e "s|BASE_ICON|$ICONURL|g" $BUILD_DIR/$TOINSTALL.xml

cd $BUILD_DIR

docker build -t $DOCKERHUB_USERNAME/$TOINSTALL .
docker push $DOCKERHUB_USERNAME/$TOINSTALL

# Maybe omit the run command and just past the xml?
# docker run -d -p 5900:5900 -p 6080:6080 --name=$TOINSTALL --security-opt seccomp=unconfined -v /mnt/user/appdata/data:/data -v /mnt/user/appdata/$DOCKERHUB_USERNAME-$TOINSTALL:/config -v /etc/localtime:/etc/localtime:ro -e WEBPAGE_TITLE=$TOINSTALL -e VNC_PASSWORD=mypassword -e UMASK=000 -e PUID=99 -e PGID=100 $DOCKERHUB_USERNAME/$TOINSTALL

cd $BASEDIR

if [ ! -d "/boot/config/plugins/dockerMan/templates-user/" ]; then
	echo "Not an unraid system."
	# --security-opt seccomp=unconfined
	echo "Run minimaly using:"
	echo "docker run -d -p $NEXTPORT:3000 --name=$TOINSTALL  -v /etc/localtime:/etc/localtime:ro $DOCKERHUB_USERNAME/$TOINSTALL"
else
	cp $BUILD_DIR/$TOINSTALL.xml /boot/config/plugins/dockerMan/templates-user/my-.xml
	ehco "The Template: $DOCKERHUB_USERNAME-$TOINSTALL has benn added."
fi
echo $NEXTPORT >ports
exit
