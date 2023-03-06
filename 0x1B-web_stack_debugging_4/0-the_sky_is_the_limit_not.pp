# This Puppet manifest will install and configure Nginx, Gunicorn and Flask
# on the web server, and then optimize Nginx to handle high traffic.

# Install Nginx, Gunicorn, and Flask
class web_server {
  package { ['nginx', 'gunicorn', 'python3-pip']:
    ensure => installed,
  }

  # Install Flask and other required Python packages
  exec { 'install_python_packages':
    command => '/usr/bin/pip3 install flask==2.0.2 gunicorn==20.1.0',
    path    => ['/usr/bin'],
    unless  => '/usr/bin/pip3 show flask && /usr/bin/pip3 show gunicorn',
  }
}

# Configure Nginx, Gunicorn, and Flask
class web_server::config {
  # Configure Gunicorn
  file { '/etc/systemd/system/gunicorn.service':
    ensure  => file,
    content => "\
[Unit]
Description=Gunicorn instance to serve Flask app
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/AirBnB_clone_v2
Environment=\"PATH=/home/ubuntu/AirBnB_clone_v2/venv/bin\"
ExecStart=/home/ubuntu/AirBnB_clone_v2/venv/bin/gunicorn --workers 3 --bind unix:/home/ubuntu/AirBnB_clone_v2/web_dynamic/2-hbnb.py web_dynamic.2-hbnb:app

[Install]
WantedBy=multi-user.target
",
  }

  # Configure Nginx
  file { '/etc/nginx/sites-available/default':
    ensure  => file,
    content => "\
server {
    listen 80;
    listen [::]:80 default_server;
    server_name _;

    location /airbnb-onepage/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /status {
        access_log off;
        return 200;
    }
}
",
    notify  => Service['nginx'],
  }

  # Configure Flask
  file { '/home/ubuntu/AirBnB_clone_v2/web_dynamic/2-hbnb.py':
    ensure  => file,
    content => "\
#!/usr/bin/python3
from flask import Flask, render_template
app = Flask(__name__)
@app.route('/airbnb-onepage/', strict_slashes=False)
def hello():
    return 'Hello HBNB!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
",
    require => Class['web_server'],
  }
}

# Optimize Nginx to handle high traffic
class web_server::optimization {
  # Increase the number of worker processes and worker connections
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    content => "\
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
    multi_accept on;
}

http {
    client_max_body_size 100M;
    server_tokens off;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log

