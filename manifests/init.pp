# Class: scheduled_runonce
#
# This module will allow a scheuduled task to run once on a host between the date/time specified.
# It checks if a file exists (IE: /tmp/pp.<date start> and if it does not, it will create and reboot
#
# Parameters:
#   class_enabled  (Boolean: default [true])
#     - Enables/Disables the process
#   datetime_start (String: Date Format [Y-m-d H:i:s], default [undefined])
#     - Start Date/Time of the reboot window
#   datetime_end   (String: Date Format [Y-m-d H:i:s], default [undefined])
#     - End Date/Time of the reboot window
#   command_var     (String: default [/sbin/shutdown -ra now])
#     - Command to execute
#   check_file     (String: default [/tmp/pp.scheduled-reboot])
#     - The check file that is created with Start DateTime added to the end.
#
class scheduled_runonce (
  $class_enabled     = true,
  $datetime_start    = '2012-06-10 12:53:00',
  $datetime_end      = '2012-06-10 12:53:59',
  $command_var       = '/sbin/shutdown -ra now',
  $check_file_prefix = '/tmp/pp.scheduled-runonce',
) {
  # Verify if target host is Linux
  if $::kernel == 'Linux' {
    # Get current date/time and convert to Linux string. Remove any carriage returns as well.
    $dt_current     = regsubst(generate('/bin/date', '+%s'),'\n','')
    $dt_start       = regsubst(generate('/bin/date', '-d',$datetime_start,'+%s'),'\n','')
    $dt_end         = regsubst(generate('/bin/date', '-d',$datetime_end,'+%s'),'\n','')
    $check_file = '${check_file_prefix}.${dt_start}'

    # Check if Class is disabled (Helps to disable some hosts)
    if $class_enabled == true {
      # Check if Date/Time is within allowed period
      if $dt_start <= $dt_current and $dt_end >= $dt_current {
        # Prep Command that is to be run
        $command_string = 'touch ${check_file};${command_var}'
        exec { "scheduled_reboot_command":
          command => $command_string,
          user    => root,
          onlyif  => '/usr/bin/test ! -f ${check_file}',
          path    => ['/usr/bin','/sbin'],
        }
        notice('Reboot command will run. ${command_string}')
      } else {
        notice('Not the right time. Current Date/Time: ${dt_current}. Start Date/Time: ${dt_start}. End Date/Time: ${dt_end}.')
      }
    } else {
      notice('Class disabled.')
    }
  }
}
