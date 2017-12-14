source /etc/profile
# append to the history file, don't overwrite it
shopt -s histappend

export PATH="$PATH:/workspace/bin"

source /workspace/bin/.completion/kubectl
