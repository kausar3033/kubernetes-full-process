#!/bin/sh -x

set -x

ssh ibos@masterIP 'echo "pass" | sudo -S sh -c "git clone https://github.com/kausar3033/kubernetes-full-process.git && cd kubernetes-full-process/ && chmod +x single.sh && sed -i '\''s/\r$//'\'' single.sh"'
# run from windows mobaxtream
