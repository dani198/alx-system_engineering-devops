exec { 'fix_phpp':
  command => 'strace -e trace=file sed -i s/phpp/php/g /var/www/html/wp-settings.php',
  path    => ['/bin', '/usr/bin/', '/usr/loca/bin/'],
}

