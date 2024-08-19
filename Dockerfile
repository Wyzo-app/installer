# Base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    openssh-client \
    mysql-client \
    php \
    php-cli \
    php-mysql \
    php-xml \
    php-mbstring \
    curl \
    composer \
    && apt-get clean

# Generate SSH keys
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_backend -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_shopping -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_blog -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_tag -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_translations -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_system -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_static_content -N "" && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa_menu -N ""

# Copy SSH config
COPY ssh_config /root/.ssh/config

# Clone repository and submodules
RUN git clone --recurse-submodules git@github.com:yourusername/your-backend-repo.git /app && \
    cd /app && \
    composer install && \
    php artisan migrate && \
    php artisan db:seed && \
    php artisan cache:clear

# Expose port for the application
EXPOSE 8000

# Start the Laravel application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
