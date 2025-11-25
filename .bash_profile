if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/s_takeuchi/.sdkman"
[[ -s "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/s_takeuchi/.sdkman/bin/sdkman-init.sh"

# complete -C /usr/local/Cellar/tfenv/1.0.2/versions/0.12.5/terraform terraform

export PATH="$HOME/.cargo/bin:$PATH"

# complete -C /usr/local/Cellar/tfenv/2.2.2/versions/0.12.30/terraform terraform
