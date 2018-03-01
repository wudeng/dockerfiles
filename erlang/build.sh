#!/bin/bash

wget http://erlang.org/download/otp_src_R16B03-1.tar.gz
docker build centos-otp:r16b03-1 .
