#!/usr/bin/env bash
##############################################################################
# Initiates the applying of MacOS-specific settings and preferences          #
# IMPORTANT: Be sure to read files through thoughouly before executing       #
#                                                                            #
# CAUTION: This script will apply changes to your MacOS system configuration #
# Be sure to read it through carefully, and remove anything you don't want.  #
#                                                                            #
# Close any open System Preferences panes, to prevent them from overriding   #
# settings we’re about to change                                             #
#                                                                            #
# This file is inspired by - https:
##############################################################################
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
###########################################################################################
# Variables for system preferences and settings                                           #
# NOTE: Do NOT rename the computer — keep the user's existing name.                        #
###########################################################################################
COMPUTER_NAME=$(scutil --get ComputerName);
# echo "Computer name: $COMPUTER_NAME" # DEBUG
. ../scripts/functions.sh;
  info "Configuring macOS defaults...";
# Ask for the administrator password upfront
sudo -v;
# # Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

substep_info "Keeping computer name as $COMPUTER_NAME";
# (The original script renamed the machine to the author's hostname; that is disabled here.)

substep_info "Configuring MacOS system settings and preferences...";
source "$DIR/01-preferences.sh"
source "$DIR/02-apps.sh"
source "$DIR/03-security.sh"

substep_success "✔ All tasks were completed";
echo -e "         .:'\n     __ :'__\n  .'\`__\`-'__\`\`.\n \
:__________.-'\n :_________:\n  :_________\`-;\n   \`.__.-.__.'"

success "Restart $COMPUTER_NAME for changes to take effect.";
