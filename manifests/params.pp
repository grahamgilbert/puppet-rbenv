# == Class: rbenv::params
#
# This class manages per-osfamily rbenv settings and should *not* be called directly.
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2013 Justin Downing
#
class rbenv::params {
  case $::osfamily {
    'Debian': {
      $group = 'adm'
      $test_path = '/usr/bin/test'
      $chown_path = '/bin/chown'
    }
    'RedHat': {
      $group = 'wheel'
      $test_path = '/usr/bin/test'
      $chown_path = '/bin/chown'
    }
    'Suse': {
      $group = 'users'
      $test_path = '/usr/bin/test'
      $chown_path = '/bin/chown'
    }
    'Darwin': {
      $group = 'wheel'
      $test_path = '/bin/test'
      $chown_path = '/usr/sbin/chown'
    }
    default: {
      fail('The rbenv module currently only suports Debian, RedHat, and Suse.')
    }
  }
}
