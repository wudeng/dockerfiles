# otp r16b03-1 on centos 6.7 final

平时用的开发环境，网上没找到对应的镜像，所以自己从写了一个。


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

