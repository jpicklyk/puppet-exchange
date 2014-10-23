class exchange::prerequisites(
  $exrole         = undef,
  $directory      = 's:\\Microsoft\\Exchange 2010\\',
  $filename       = 'FilterPack64bit.exe',
  $update         = 'filterpacksp2010-kb2687447-fullfile-x64-en-us.exe',
) {
  validate_re($exrole, '^$', "Unsupported role, choose 1 of 'unified', 'cas', or 'mailbox'")

  package { 'Microsoft Filter Pack 2.0':
    ensure => 'installed',
    source => "${directory}${filename}",
    install_options => ['/quiet','/norestart'],
  }
  
  $service {'Net.Tcp Port Sharing Service':
    ensure  => 'running',
    enable  => true,
  }
  
  case $exrole {
    'cas':      {$features = ['NET-Framework','RSAT-ADDS','Web-Server','Web-Basic-Auth','Web-Windows-Auth','Web-Metabase','Web-Net-Ext','Web-Lgcy-Mgmt-Console','WAS-Process-Model','RSAT-Web-Server','Web-ISAPI-Ext','Web-Digest-Auth','Web-Dyn-Compression','NET-HTTP-Activation','RPC-Over-HTTP-Proxy']}
    'mailbox':  {$features = ['NET-Framework','RSAT-ADDS','Web-Server','Web-Basic-Auth','Web-Windows-Auth','Web-Metabase','Web-Net-Ext','Web-Lgcy-Mgmt-Console','WAS-Process-Model','RSAT-Web-Server']}    
    default:    {$features = ['NET-Framework','RSAT-ADDS','Web-Server','Web-Basic-Auth','Web-Windows-Auth','Web-Metabase','Web-Net-Ext','Web-Lgcy-Mgmt-Console','WAS-Process-Model','RSAT-Web-Server','Web-ISAPI-Ext','Web-Digest-Auth','Web-Dyn-Compression','NET-HTTP-Activation','RPC-Over-HTTP-Proxy']}
  }
  
  windowsfeature{'$exrole':
    feature_name  => $features
  }
}