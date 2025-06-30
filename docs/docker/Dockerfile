FROM ubuntu:22.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# 替换为清华 APT 源
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
	sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu/|http://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
	apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
	pkg-config \
    nginx \
    redis-server \
    libmariadb-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    libldap2-dev \
    libsasl2-dev \
    supervisor \
    git \
    gcc \
    wget \
    unzip \
    net-tools \
    sshpass \
    rsync \
    sshfs \
    locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置 locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# pip 安装 python 包
RUN pip3 install --no-cache-dir --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/
RUN pip3 install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ \
    gunicorn \
    mysqlclient \
    cryptography==36.0.2 \
    apscheduler==3.7.0 \
    asgiref==3.2.10 \
    Django==2.2.28 \
    channels==2.3.1 \
    channels_redis==2.4.1 \
    paramiko==2.11.0 \
    django-redis==4.10.0 \
    requests==2.22.0 \
    GitPython==3.0.8 \
    python-ldap==3.4.0 \
    openpyxl==3.0.3 \
    user_agents==2.2.0

# 设置 bashrc
RUN echo -e '\n# Source definitions\n. /etc/profile\n' >> /root/.bashrc

RUN mkdir -p /data/repos
COPY init_spug /usr/bin/
COPY nginx.conf /etc/nginx/
COPY ssh_config /etc/ssh/
COPY spug.ini /etc/supervisord.d/
COPY redis.conf /etc/
COPY entrypoint.sh /
COPY web.tar.gz /web.tar.gz

RUN mkdir -p /root/.bashrc.d && \
    echo -e '\n# 自动加载 ~/.bashrc.d 目录中的脚本\nif [ -d "$HOME/.bashrc.d" ]; then\n  for f in "$HOME"/.bashrc.d/*.sh; do\n    [ -r "$f" ] && [ -f "$f" ] && . "$f"\n  done\nfi' >> /root/.bashrc

VOLUME /data
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
