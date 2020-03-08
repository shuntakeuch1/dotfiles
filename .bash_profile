if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/s_takeuchi/.sdkman"
[[ -s "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh"
