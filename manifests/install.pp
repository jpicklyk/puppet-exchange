class exchange::install (
  $exrole = undef,
  $path,
  $orgname,
) {
  
  validate_string(orgname)
  
  $setuprole = $exrole ? {
    default => 'CA,MB,HT,MT'
  }
  
  
  exec{'Schema Prep':
    command   => "setup.com /PS",
    path      => "${path}",
    provider  => powershell,
    unless    => 'Try {Get-ADObject $("CN=ms-Exch-Schema-Version-Pt,"+$((Get-ADRootDSE).NamingContexts | Where-Object {$_ -like "*Schema*"}))}Catch {exit 1}',    
  } ~>
  
  exec{'Doamin Prep':
    command   => "setup.com /PrepareAD /OrganizationName:${orgname}",
    path      => "${path}",
    provider  => powershell,
    require => Exec['Schema Prep'],
  } ->
  
  exec{'Install Role':
    command   => "${path}\\setup.com /mode:install /role:${setuprole} /organizationName:'${orgname}'",
    provider  => powershell,
    unless    => 'Try {Get-ExchangeServer}Catch{exit 1}',
    timeout   => 0
  }
  
}