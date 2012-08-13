
class config_app_server
{

  file 
  {
    'apache2.config':
      path    => '/etc/apache2/sites-available/default',
      ensure  => present,
      source  => '/vagrant/.puppet/vagrant/resources/apache2-vhost'
  }

  exec
  {
	'apache2.mods':
      path => '/bin:/usr/bin:/usr/sbin',
      command => 'a2enmod rewrite',
      require => File['apache2.config']
  }

  file 
  {
    'php5.config':
      path    => '/etc/php5/apache2/php.ini',
      ensure  => present,
      source  => '/vagrant/.puppet/vagrant/resources/php.ini'
  }

  file 
  {
    'php5cli.config':
      path    => '/etc/php5/cli/php.ini',
      ensure  => '/etc/php5/apache2/php.ini',
      require => File['php5.config']
  }

  # the mcrypt.ini file creates a notice when starting the php.cli,
  # removing the comment in the file fixes it
  file 
  {
    'mcrypt.fix':
      path    => '/etc/php5/conf.d/mcrypt.ini',
      ensure  => '/vagrant/.puppet/vagrant/resources/mcrypt.ini',
      require => File['php5.config']
  }

  file 
  {
    'phpmyadmin.apacheconfig':
      path    => '/etc/apache2/conf.d/apache.conf',
      ensure  => '/etc/phpmyadmin/apache.conf',
      require => File['php5.config']
  }

  exec
  {
	'mysql.password':
      unless => 'mysqladmin -uroot -proot status',
      path => '/bin:/usr/bin',
      command => 'mysqladmin -uroot password root'
  }

  file 
  {
    'project.basedir':
      path    => '/vagrant/project',
      ensure  => directory
  }

  file 
  {
    'system.logdir':
      path    => '/vagrant/app/log',
      ensure  => directory
  }

  file 
  {
    'apache.logdir':
      path    => '/vagrant/app/log/apache2',
      ensure  => directory,
      require => File['system.logdir']
  }

}
