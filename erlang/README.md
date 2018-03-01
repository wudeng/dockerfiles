# otp r16b03-1 on centos 6.7 final

平时用的开发环境，网上没找到对应的镜像，所以自己从写了一个。

## Dockerfile：直接从源码编译安装

需要注意的是r16b03-1对openssl的依赖，centos的openssl跟crypto不兼容，
如果直接用openssl-devel编译出来的otp启动crypto的时候会报错:

```
Eshell V5.10.4  (abort with ^G)
1> crypto:start().
** exception error: undefined function crypto:start/0
2>
=ERROR REPORT==== 1-Mar-2018::03:08:56 ===
Unable to load crypto library. Failed with error:
"load_failed, Failed to load NIF library: '/usr/local/lib/erlang/lib/crypto-3.2/priv/lib/crypto.so: undefined symbol: EC_GROUP_new_curve_GF2m'"
OpenSSL might not be installed on this system.

=ERROR REPORT==== 1-Mar-2018::03:08:56 ===
The on_load function for module crypto returned {error,
                                                 {load_failed,
                                                  "Failed to load NIF library: '/usr/local/lib/erlang/lib/crypto-3.2/priv/lib/crypto.so: undefined symbol: EC_GROUP_new_curve_GF2m'"}}
``` 

解决的办法是直接从源码编译openssl。

或者：

```
./configure CFLAGS="-DOPENSSL_NO_EC=1" && make && sudo make install
```

参考 
* http://erlang.org/pipermail/erlang-questions/2014-February/076760.html
* https://groups.google.com/forum/#!topic/erlang-programming/wW6Uuz4VO2w

> Found it, Centos 6.5 disables EC only partly. Most EC functions 
> are there, only the support for GF2m curves has been disabled 
> (that means all the sectXXXr1 and r2 curves won't work). 
> 
> The corresponding OpenSSL define OPENSSL_NO_EC2M is set. 
> 
> The simplest (untested) workaround would be to put a "-DOPENSSL_NO_EC=1" 
> into CFLAGS, e.g.: 
> 
>       CFLAGS="-DOPENSSL_NO_EC=1" ./configure 
> 
> Alternatively, you could edit lib/crypto/c_src/crypto.c and change: 
> 
> #if OPENSSL_VERSION_NUMBER >= 0x009080ffL \ 
>         && !defined(OPENSSL_NO_EC) \ 
>         && !defined(OPENSSL_NO_ECDH) \ 
>         && !defined(OPENSSL_NO_ECDSA) 
> # define HAVE_EC 
> #endif 
> 
> to 
> 
> #if OPENSSL_VERSION_NUMBER >= 0x009080ffL \ 
>         && !defined(OPENSSL_NO_EC) \ 
>         && !defined(OPENSSL_NO_EC2M) \ 
>         && !defined(OPENSSL_NO_ECDH) \ 
>         && !defined(OPENSSL_NO_ECDSA) 
> # define HAVE_EC 
> #endif 
> 
> Both will disable EC completely. 
> 

## Dockerfile-rpm：以rpm安装包安装

erlang solution提供了一套直接从rpm安装erlang的解决方案：
直接从 https://www.erlang-solutions.com/resources/download.html 下载对应的rpm包，通过yum install安装rpm包即可这种方式更加简单。
直接下载的速度很慢，可以用迅雷等工具下载下来再拷贝到Docker中。

```
FROM centos:6.7
MAINTAINER wudeng256@gmail.com

ENV LANG="en_US.UTF-8"

COPY esl-erlang_16.b.3-1~centos~6_amd64.rpm esl-erlang_16.b.3-1~centos~6_amd64.rpm

RUN yum install -y esl-erlang_16.b.3-1~centos~6_amd64.rpm

CMD ["erl"]
```
