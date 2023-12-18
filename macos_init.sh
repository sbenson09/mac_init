#!/bin/zsh

HOSTNAME=sbenson-mba


Purple='\033[0;35m'       # Purple
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Color_Off='\033[0m'       # Text Reset



# Set computer's hostname
echo -e $Purple"Setting computer's hostname"$Color_Off

if [[ $(hostname) != $HOSTNAME ]]; then
	sudo scutil --set ComputerName $HOSTNAME
	sudo scutil --set HostName $HOSTNAME
	sudo scutil --set LocalHostName $HOSTNAME
else
    echo -e $Yellow"Warning:$Color_Off Hostname already set as $HOSTNAME"
fi

# Install Rosetta
echo -e	$Purple"Installing Rosetta"$Color_Off
if [[ `uname -m` != "arm64" ]] ; then
    echo "not arm64"
else
    if ! (arch -arch x86_64 uname -m > /dev/null) ; then
        echo "arm64: no Rosetta installed"
         softwareupdate --install-rosetta --agree-to-license
    else
        echo -e $Yellow"Warning:$Color_Off arm64: Rosetta already installed"
    fi
fi

# Install homebrew
echo -e $Purple"Installing homebrew"$Color_Off
if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/sbenson/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo -e $Yellow"Warning:$Color_Off brew already installed"
fi

# Install utilities through brew
echo -e $Purple"Installing utilities through brew"$Color_Off

brew_cask_apps=(
	"1password"
	"rectangle"
	"vivaldi"
	"vscodium"
	"hey"
	"monitorcontrol"
	"basecamp"
	"steam"
	"docker"
	"the-unarchiver"
	"appcleaner"
	"slack"
	"zoom"
	"discord"
	"firefox"
	"spotify"
	"github"
	"caffeine"
	"signal"
	"aldente"
	"transmit"
	"raycast"
	"sol"
	"maccy"
	"tailscale"
	"diffusionbee"
	"ferdium"
	"copilot"
	"anki"
	"vagrant"
	"google-cloud-sdk"
	"utm"
	"latest"
	"sonos"
	"hyper"
	"pocket-casts"
	"transmission"
	"grandperspective"
	"stats"
	"codewhisperer"
)

for app in "${brew_cask_apps[@]}"; do
	brew install --cask "$app" 2>&1 1>/dev/null
done

brew_apps=(
	"1password-cli"
	"wifi-password"
	"awscli"
	"python@3.11"
	"terraform"
	"htop"
	"tree"
	"jq"
	"gh"
	"kind"
	"wget"
	"kubernetes-cli"
	"ansible"
	"mas"
)

for app in "${brew_apps[@]}"; do
	brew install "$app" 2>&1 1>/dev/null
done

# Install utilities through mas #https://github.com/mas-cli/mas
echo -e $Purple"Installing utilities through mas"$Color_Off
mas install 1355679052 #Dropover
mas install 1357379892 #Menu Bar Controller for Sonos

# Configure brew autoupdate
# TO DO


# Log in to 1Password
echo -e $Purple"Logging in to 1Password"$Color_Off
if [[ $(op account list | grep sbenson@hey.com | wc -l | tr -d ' ') != 1 ]]; then
    op account add --address my.1password.com --email sbenson@hey.com
    eval $(op signin --account my)
fi

# Import private key from 1Password
# TO DO
# echo -e $Purple"Importing private key from 1Password"$Color_Off

echo -e $Green"Init script done"$Color_Off