# scheduled_runonce

####Table of Contents
1. [Overview](#overview)
2. [Module Description - What the run once module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with run once](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with RunOnce](#beginning-with-run-once)
4. [License](#license)

##Overview

Allow a task to run once on a server between the provided date/time.

##Module Description

This module will allow a scheduled task to run once on a host between the date/time specified. It checks if a file exists (IE: /tmp/pp.<date start>) and if it does not, it will create and run the command.

By default the command is "/sbin/shutdown -ra now"

This module was tested and works great within RedHat Satellite 6.1.

##Setup

##Setup Requirements

Make sure touch is within the path /usr/bin or /sbin

The default command_var variable is set to "/sbin/shutdown -ra now" which will reboot your server. The intended purpose of this was originally to allow scheduled reboots, but I modified it to do more.

##Beginning with run once

```puppet
    scheduled_runonce {
      "class_enabled" => true,
      "datetime_start" => "2012-06-12 12:53:00",
      "datetime_end" => "2012-06-12 12:53:59",
      "command_var" => "/sbin/shutdown -ra now",
      "check_file" => "/tmp/pp.sched_runonce",
    }
```

    class_enabled  (Boolean: default [true])
    - Enables/Disables the process
    datetime_start (String: Date Format [Y-m-d H:i:s], default [undefined])
    - Start Date/Time of the reboot window
    datetime_end   (String: Date Format [Y-m-d H:i:s], default [undefined])
    - End Date/Time of the reboot window
    command_var     (String: default [/sbin/shutdown -ra now])
    - Command to execute
    check_file     (String: default [/tmp/pp.scheduled-reboot])
    - The check file that is created with Start DateTime added to the end.

##License

Copyright 2015 Eric B

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
