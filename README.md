# Intro

A bmp280 mqqt sensor in Fennel on top of NodeMCU


# Usage

Prequisits:

```bash
# Fennel
$ sudo apt install luarocks -y
$ luarocks --local install fennel
# nodemcu upload tool
$ sudo apt install npm
$ npm install nodemcu-tool
```

Upload and compile:

```bash
$ make upload
```

Make sure enable the following when you build the nodemcu image:

```bash
// Mqtt and Wifi are enabled by default
#define LUA_USE_MODULES_BME280
#define LUA_USE_MODULES_BME280_MATH
#define LUA_USE_MODULES_SJSON
```



# Copyright and license

Copyright [2020] [Ronen Narkis]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
