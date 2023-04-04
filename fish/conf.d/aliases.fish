# Custom alias
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
alias httpserver='python -m http.server'
alias httpserver2='python -m SimpleHTTPServer'
alias grep='grep -I --color=auto --exclude-dir={.git,.venv,.vscode}'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -N -C --dirsfirst'
alias less='less -N'
alias ping='ping -i 0.2 -c 30'
alias ip4="ifconfig | grep -w inet | awk '{print \$2}'| sort"
alias ip6="ifconfig | grep -w inet6 | awk '{print \$2}'| sort"
alias tailf='tail -F'
alias cat='bat -p'

# macOS alias
if test (uname) = "Darwin"
    set -gx HOMEBREW_NO_AUTO_UPDATE true  # disable homebrew auto update
    set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    alias rmds='find . -type f -name .DS_Store -delete'
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias power="echo Power: (pmset -g batt|awk 'NR==2{print $3}'|sed 's/;//g')"
end

# Git alias
alias gst='git status -sb'
alias glg='git log --stat --graph --all --max-count=20 --show-signature'
alias gco='git checkout'

# brew
if command -v brew >/dev/null 2>&1
    # BREWHOME=`brew --prefix`
    set BREWHOME "/usr/local"
    set -gx LDFLAGS "-L$BREWHOME/lib"
    set -gx CPPFLAGS "-I$BREWHOME/include"
    set -gx PKG_CONFIG_PATH "$BREWHOME/lib/pkgconfig"
end
