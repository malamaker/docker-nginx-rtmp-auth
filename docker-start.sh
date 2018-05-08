#!/bin/sh
# Startup script for bash container

# nginx-rtmp
if ps -ef | grep nginx >/dev/null 2>&1 ; then
    echo "nginx service is running"
    :
else
    echo "nginx service is NOT running. Starting..."    
    /usr/local/nginx/sbin/nginx
    if ps -ef | grep nginx >/dev/null 2>&1 ; then
       	echo "nginx service is running"
    else
	echo "nginx service start failed."
	raise error "nginx-rtmp service failed to start!!!"
	exit 1
    fi
fi

# postgres
if ps -ef | grep postgres >/dev/null 2>&1 ; then
    echo "postgres service is running"
    :
else
    echo "postgreSQL service is NOT running. Starting..."
    sh /etc/init.d/postgresql restart
    if ps -ef | grep postgres >/dev/null 2>&1 ; then
        echo "postgreSQL service is running"
    else
        echo "postgreSQL service start failed."
        raise error "postgreSQL service failed to start!!!"
        exit 1
    fi
fi

# apache2/phppsadmin
if ps -ef | grep apache2 >/dev/null 2>&1 ; then
    echo "apache2 service is running"
    :
else
    echo "apache2 service is NOT running. Starting..."
    sh /etc/init.d/apache2 restart
    if ps -ef | grep apache2 >/dev/null 2>&1 ; then
        echo "apache2 service is running"
    else
        echo "apache2 service start failed."
        raise error "apache2 service failed to start!!!"
        exit 1
    fi
fi

# flask: malamaker/nginx-rtmp-auth
if ps -ef | grep "flask run" >/dev/null 2>&1 ; then
    echo "nginx-rtmp-auth service is running"
    :
else
    echo "nginx-rtmp-auth service is NOT running. Starting..."
    flask run &
    if ps -ef | grep "flask run" >/dev/null 2>&1 ; then
         echo "nginx-rtmp-auth service is running"
    else
         echo "nginx-rtmp-auth service start failed."
         raise error "nginx-rtmp-auth service failed to start!!!"
         exit 1
    fi
fi

exit 0
