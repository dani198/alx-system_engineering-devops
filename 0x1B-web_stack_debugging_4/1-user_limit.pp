# Set the maximum number of open files for the holberton user to unlimited
user_limits { 'holberton':
  limits => {
    'nofile' => {
      'soft' => 'unlimited',
      'hard' => 'unlimited',
    },
  },
}

# Allow the holberton user to open files with SELinux
selboolean { 'allow_user_exec_content':
  ensure => 'on',
  value  => true,
}

