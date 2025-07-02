#!/bin/bash
#
set -e

if [ -e /root/.bashrc ]; then
    source /root/.bashrc
fi

if [ ! -f /data/spug/SECRET_KEY ]; then
    SECRET_KEY=$(< /dev/urandom tr -dc '!@#%^.a-zA-Z0-9' | head -c50)
	echo $SECRET_KEY > /data/spug/SECRET_KEY
fi
SECRET_KEY=$(cat /data/spug/SECRET_KEY)
cat > /app/spug_api/spug/overrides.py << EOF
import os


DEBUG = False
ALLOWED_HOSTS = ['127.0.0.1']
SECRET_KEY = '${SECRET_KEY}'

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ.get('MYSQL_DATABASE'),
        'USER': os.environ.get('MYSQL_USER'),
        'PASSWORD': os.environ.get('MYSQL_PASSWORD'),
        'HOST': os.environ.get('MYSQL_HOST'),
        'PORT': os.environ.get('MYSQL_PORT'),
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES',
        }
    }
}
EOF

mkdir -p /data/spug/logs

# 默认账号密码
DEFAULT_USER="admin"
DEFAULT_PASSWORD="spug.cc"

# 判断环境变量是否为空
SPUG_ADMIN_USER=${SPUG_ADMIN_USER:-$DEFAULT_USER}
SPUG_ADMIN_PASSWORD=${SPUG_ADMIN_PASSWORD:-$DEFAULT_PASSWORD}

# 执行命令
/usr/bin/init_spug "$SPUG_ADMIN_USER" "$SPUG_ADMIN_PASSWORD"

exec supervisord -c /etc/supervisord.d/spug.ini
