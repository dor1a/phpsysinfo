# phpSysInfo
# VERSION v3.3.4

FROM ubuntu:latest

LABEL email="me@formellow.com"
LABEL name="dor1"
LABEL description="phpSysInfo"

# Copy configration
COPY ./default /etc/nginx/sites-available/
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set time-zone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update sources
RUN echo "deb http://mirror.kakao.com/ubuntu focal main restricted universe multiverse" | tee /etc/apt/sources.list
RUN echo "deb http://mirror.kakao.com/ubuntu focal-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirror.kakao.com/ubuntu focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirror.kakao.com/ubuntu focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirror.kakao.com/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt update

# Install packages
RUN apt install -y -o Dpkg::Options::="--force-confold" nginx php7.4-fpm php7.4-xml php7.4-mbstring git pciutils supervisor

# Install sources
RUN git clone https://github.com/phpsysinfo/phpsysinfo.git /var/www/html/phpsysinfo
RUN cp /var/www/html/phpsysinfo/phpsysinfo.ini.new /var/www/html/phpsysinfo/phpsysinfo.ini

RUN mv /var/www/html/phpsysinfo/* /var/www/html/ && \
    rm /var/www/html/index.nginx-debian.html && \
    rm -rf /var/www/html/phpsysinfo

VOLUME ["/var/www/html"]

WORKDIR ["/var/www/html"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]
