#!/bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/hort-der-republik/hdr-para-texts/archive/refs/heads/main.zip
unzip main

mv ./hdr-para-texts-main/data/ .

rm main.zip
rm -rf ./hdr-para-texts-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh
