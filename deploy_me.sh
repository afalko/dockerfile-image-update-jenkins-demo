#!/bin/bash

git pull

cd jenkins
./build_and_start.sh
cd ..
