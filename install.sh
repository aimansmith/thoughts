#!/bin/bash
cd `dirname "$0"`
# tar copies
if [ ! -d /etc/httpd/conf ]
then
  echo "no conf dir.  bailing"
fi
cd conf ; tar -cpf - * | ( cd /etc/httpd/conf ; tar -xpf - ) ; cd ..
if [ ! -d /var/www/cgi-bin ]
then
  echo "no cgi-bin dir.  bailing"
fi
cd cgi-bin ; tar -cpf - * | ( cd /var/www/cgi-bin ; tar -xpf - ) ; cd ..
/sbin/service httpd restart
