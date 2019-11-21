#!/bin/sh

set -e

case $INPUT_GAME in
  "hoi4") echo "Game selected as $INPUT_GAME" ;;
  "ck2") echo "Game selected as $INPUT_GAME" ;;
  "eu4") echo "Game selected as $INPUT_GAME" ;;
  "vic2") echo "Game selected as $INPUT_GAME" ;;
  "ir") echo "Game selected as $INPUT_GAME" ;;
  "stellaris") echo "Game selected as $INPUT_GAME" ;;
  *) echo "Wrong game, $INPUT_GAME is not valid" 1>&2 ; exit 1 # terminate and indicate error
esac

dotnet tool install --global CWTools.CLI
export PATH="$PATH:/github/home/.dotnet/tools"

cd /
mkdir -p /src
git clone --depth=1 https://github.com/tboby/cwtools-$INPUT_GAME-config.git /src/cwtools-$INPUT_GAME-config

cd /src/cwtools-$INPUT_GAME-config
git fetch
git pull

CWB_GAME=$INPUT_GAME 
if [ $INPUT_GAME == "stellaris" ]; then
  CWB_GAME="stl"
fi

cd /
mv $GITHUB_WORKSPACE/$CWB_GAME.cwb.7z .
p7zip -d $CWB_GAME.cwb.7z


if [ ! -f "$CWB_GAME.cwb" ]; then
    echo "$CWB_GAME.cwb does not exist"
    exit 1
fi

ruby /action/lib/cwtools.rb