#!/bin/bash

# Initialize MariaDB directory if not initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Start MariaDB in the background with low-memory optimizations
echo "Starting MariaDB..."
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' \
    --key-buffer-size=8M \
    --max-connections=10 \
    --thread-stack=192K \
    --query-cache-size=0 \
    --innodb-buffer-pool-size=16M \
    --innodb-log-buffer-size=1M \
    --performance-schema=OFF &

# Wait for MariaDB to start up
echo "Waiting for MariaDB to start..."
for i in {1..30}; do
    if mysqladmin ping -u root --silent; then
        break
    fi
    sleep 1
done

echo "Setting up root password and database..."
# Set root password to syedsyed and allow password access
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('syedsyed'); FLUSH PRIVILEGES;"

# Create database and import schema
mysql -u root -psyedsyed -e "CREATE DATABASE IF NOT EXISTS course_db;"
if [ -f "/usr/local/tomcat/schema.sql" ]; then
    echo "Importing database schema..."
    mysql -u root -psyedsyed course_db < /usr/local/tomcat/schema.sql
fi

echo "Database setup complete! Starting Tomcat..."
exec catalina.sh run
