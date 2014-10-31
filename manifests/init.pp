# Class: exchange
#
# This module manages exchange
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class exchange(
  $exchange_dir,
  $prereq_dir,
  $role = 'unified',
  $organization_name,
  $version
) {
  validate_string($organization_name)
  validate_absolute_path($exchange_dir)
  validate_absolute_path($prereq_dir)
  validate_re($role, '^(unified|cas|mailbox)$', "Unsupported role \'${role}\', choose 1 of \'unified\', \'cas\', or \'mailbox\'")
  
  $exrole = $role ? {
    'unified'  => 'CA,MB,HT,MT',
    'cas'      => 'CA,HT,MT',
    'mailbox'   => 'MB,MT',
    default    => fail("Unsupported role: ${role}")
  }
  
  class { '::exchange::prerequisites':
    role    => $role,
    directory => $prereq_dir,
  } ->
    
  class {'::exchange::install':
    role    => $exrole,
    path      => $exchange_dir,
    orgname   => $organization_name,
  }
  contain exchange::prerequisites  
  contain exchange::install
}
