#!/bin/bash

wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_16.b.3-1~centos~6_amd64.rpm
docker build centos-otp:r16b03-1 . -f Dockerfile-rpm
