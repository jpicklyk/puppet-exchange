class exchange::install (
  $role,
  $path,
  $orgname,
) {
  
  validate_string($orgname)
  validate_string($path)
  validate_re($role,'^(?:CA|MB|HT|MT)(?:(?:\,(?:CA|MB|HT|MT))?)*$')
  
  
  exec{'Schema Prep':
    command   => "${path}\\setup.com /PS",
    provider  => powershell,
    unless    => 'import-module activedirectory;Try {Get-ADObject $("CN=ms-Exch-Schema-Version-Pt,"+$((Get-ADRootDSE).NamingContexts | Where-Object {$_ -like "*Schema*"}))}Catch {exit 1}', 
    timeout   => 0,   
  } ~>
  
  exec{'Doamin Prep':
    command   => "${path}\\setup.com /PrepareAD /OrganizationName:'${orgname}'",
    provider  => powershell,
    require => Exec['Schema Prep'],
    unless    => 'Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010;Try {Get-ExchangeServer}Catch{exit 1}',
    timeout   => 0
  } ->
  
  exec{'Install Role':
    command   => "${path}\\setup.com /mode:install /role:'${role}' /organizationName:'${orgname}'",
    provider  => powershell,
    unless    => 'Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010;Try {Get-ExchangeServer}Catch{exit 1}',
    timeout   => 0
  }
  
  reboot{'after exchange':
    subscribe => Exec['Install Role'],
  }
  
}