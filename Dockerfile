# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update the package list and install PHP, Composer, and necessary utilities
RUN apt-get update && \
    apt-get install -y php-cli php-mbstring php-zip php-xml curl unzip git tzdata gcc make autoconf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install opentelemetry extension
RUN pecl install opentelemetry

# Set the working directory
WORKDIR /var/www/html

# Copy only the composer files and install dependencies
# COPY src/composer.json /var/www/html/composer.json
# COPY src/composer.lock /var/www/html/composer.lock
# RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copy the rest of the application files
COPY src/ /var/www/html/

# Ensure the public directory exists
RUN mkdir -p /var/www/html/public

# Expose port 8080
EXPOSE 8080

# Start the built-in PHP server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html/public"]
