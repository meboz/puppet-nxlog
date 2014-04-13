class nxlog (
    $package_ensure = installed,
    $package_name   = 'NXLOG-CE',
    $install_dir    = 'C:/Program Files (x86)/nxlog/',
    $package        = 'c:/temp/nxlog-ce-2.7.1191.msi',
    $service_name   = 'nxlog',
    $service_ensure = running,
    $config_dir     = 'C:/Program Files (x86)/nxlog/conf/',
)
{
    $config_file    = "${install_dir}conf/nxlog.conf"
    $default_root = 'C:/Program Files (x86)/nxlog/'
    $root_dir   = $install_dir
    
    if($install_dir != $default_root){
        notify { 'Your install directory is not default. You must adjust the ROOT define in your nxlog.conf file':
        
        }
    }
    
    if($package_ensure == 'installed'){
        service { $service_name:
            ensure  => $service_ensure,
            require => Package[$package_name]
        }        
    }
        
    package { $package_name:
        ensure  => $package_ensure,
        source  => $package,
        #install_options => ["INSTALLDIR=${install_dir}"]
    }
    
    $inputs = hiera('nxlog::conf::inputs')
    
    file { "${config_dir}nxlog.conf":
        ensure  => present,
        content => template('nxlog/nxlog.conf.erb'),
        notify  => Service[$service_name],
        require => Package[$package_name],
    }
    
    file { "${config_dir}conf.d":
        ensure  => directory,
        require => Package[$package_name],
    }
    
    #create_resources(nxlog::conf,hiera('nxlog::conf::inputs'))
}