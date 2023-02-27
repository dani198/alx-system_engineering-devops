#This is a Puppet manifest code that uses the exec resource type to execute 
exec { 'fix_phpp':
  command => 'sed -i s/phpp/php/g /var/www/html/wp-settings.php',
  path    => ['/bin', '/usr/bin/', '/usr/loca/bin/'],
}
