#!/usr/bin/env bash

echo -n "Fetching qtile hash.. "
nix-prefetch-git --quiet https://github.com/qtile/qtile > /tmp/repo_qtile.json
REV=$(jq -r .rev < /tmp/repo_qtile.json)
SHA256=$(jq -r .sha256 < /tmp/repo_qtile.json)
echo "$SHA256"
if ( grep "$SHA256.*qtile" ./system/x11/default.nix &>/dev/null ); then
    echo "qtile sha256 in ./system/x11/default.nix is up to date"
else
    echo "Updating qtile in ./system/x11/default.nix.."
    sed -i "s/rev = .*# qtile/rev = ''$REV'';  # qtile/" ./system/x11/default.nix
    sed -i "s/sha256 = .*# qtile/sha256 = ''$SHA256'';  # qtile/" ./system/x11/default.nix
fi

echo -n "Fetching qtile-extras hash.. "
nix-prefetch-git --quiet --leave-dotGit https://github.com/elparaguayo/qtile-extras > /tmp/repo_qtile-extras.json
REV=$(jq -r .rev < /tmp/repo_qtile-extras.json)
SHA256=$(jq -r .sha256 < /tmp/repo_qtile-extras.json)
echo "$SHA256"
if ( grep "$SHA256.*extras" ./system/x11/default.nix &>/dev/null ); then
    echo "qtile-extras in ./system/x11/default.nix is up to date"
else
    echo "Updating qtile-extras in ./system/x11/default.nix.."
    sed -i "s/rev = .*# extras/rev = ''$REV'';  # extras/" ./system/x11/default.nix
    sed -i "s/sha256 = .*# extras/sha256 = ''$SHA256'';  # extras/" ./system/x11/default.nix
fi
