# Dockerfile for Moodle Development
FROM ubuntu:14.04
MAINTAINER Jim Witte <jwitte@illinois.edu>

EXPOSE 80 443

COPY required-packages.txt .

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

ADD ./foreground.sh /etc/apache2/foreground.sh

RUN apt-get update && \
    xargs apt-get install -y < required-packages.txt 

RUN rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html && \
	chmod +x /etc/apache2/foreground.sh

# Enable SSL, moodle requires it
RUN a2enmod ssl && a2ensite default-ssl

RUN mkdir /var/www/moodledata
RUN chown -R www-data:www-data /var/www/moodledata 

CMD ["/etc/apache2/foreground.sh"]

