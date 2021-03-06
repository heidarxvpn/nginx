FROM debian:wheezy

COPY nginx_signing.key /nginx_signing.key
RUN apt-key add nginx_signing.key
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.7.10

RUN apt-get update && \
  apt-get install -y wget && \
  apt-get build-dep -y nginx && \
  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz && \
  cd nginx-${NGINX_VERSION} && \
  ./configure --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module --sbin-path=/usr/local/sbin --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log && \
  make && \
  make install && \
  cd .. && \
  mkdir -p /etc/nginx/conf.d /etc/nginx/ssl /var/log/nginx /public && \
  rm -rf nginx-${NGINX_VERSION}* && \
  apt-get remove -y wget binutils bsdmainutils build-essential bzip2 cpp cpp-4.7 debhelper dpkg-dev file g++ g++-4.7 gcc gcc-4.7 gettext gettext-base groff-base html2text intltool-debian libasprintf0c2 libc-dev-bin libc6-dev libclass-isa-perl libcroco3 libdpkg-perl libffi5 libgdbm3 libgettextpo0 libglib2.0-0 libgmp-dev libgomp1 libitm1 libmagic1 libmpc2 libmpfr4 libpcre3-dev libpcrecpp0 libpipeline1 libquadmath0 libssl-dev libssl1.0.0 libswitch-perl libtimedate-perl libunistring0 libxml2 linux-libc-dev make man-db patch perl perl-modules po-debconf zlib1g-dev && \
  apt-get install -y zlib1g openssl ca-certificates && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
