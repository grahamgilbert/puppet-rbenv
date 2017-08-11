# == Define: rbenv::plugin
#
# === Variables
#
# [$install_dir]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::gem define.
#   Default: $rbenv::install_dir
#   This variable is required.
#
# [$latest]
#   This defines whether the plugin is kept up-to-date.
#   Defaults: false
#   This vaiable is optional.
#
# [$env]
#   This is used to set environment variables when installing plugins.
#   Default: []
#   This variable is optional.
#
# === Requires
#
# You will need to install the git package on the host system.
#
# === Examples
#
# rbenv::plugin { 'jamis/rbenv-gemset': }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::plugin(
  $install_dir = $rbenv::install_dir,
  $latest      = false,
  $env         = $rbenv::env,
  $test_path   = $rbenv::test_path,
  $chown_path  = $rbenv::chown_path
) {
  include rbenv

  $plugin = split($name, '/') # divide plugin name into array

  Exec { environment => $env }

  exec { "install-${name}":
    command => "/usr/bin/git clone https://github.com/${name}.git",
    cwd     => "${install_dir}/plugins",
    onlyif  => "${test_path} -d ${install_dir}/plugins",
    unless  => "${test_path} -d ${install_dir}/plugins/${plugin[1]}",
  }~>
  exec { "rbenv-permissions-${name}":
    command     => "${chown_path} -R ${rbenv::owner}:${rbenv::group} \
                    ${install_dir} && \
                    /bin/chmod -R g+w ${install_dir}",
    refreshonly => true,
  }

  # run `git pull` on each run if we want to keep the plugin updated
  if $latest == true {
    exec { "update-${name}":
      command => '/usr/bin/git pull',
      cwd     => "${install_dir}/plugins/${plugin[1]}",
      user    => $rbenv::owner,
      onlyif  => "${test_path} -d ${install_dir}/plugins/${plugin[1]}",
    }
  }
}
