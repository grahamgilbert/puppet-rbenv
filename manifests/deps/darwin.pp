# == Class: rbenv::deps::darwin
#
class rbenv::deps::darwin {
  if $rbenv::manage_deps{
    if !defined(File['/etc/profile.d']){
      file {'/etc/profile.d':
        ensure => 'directory'
      }
    }
  }
}
