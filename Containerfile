FROM quay.tdl.devu.ca:8443/images/httpd-24:latest

# Add application sources
ADD app-src/index-2.html /var/www/html/index.html

# The run script uses standard ways to run the application
CMD run-httpd
