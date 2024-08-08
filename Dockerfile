FROM ruby:2.7.8
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim
# Diretório de trabalho para a aplicação Rails
WORKDIR /app

# Copiar os arquivos da aplicação
COPY . .

# Definir variáveis de ambiente para o ambiente de produção
ENV RAILS_ENV="development" \
    RACK_ENV='development' \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Instalar dependências do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    node-gyp \
    pkg-config \
    python-is-python3 \
    libcurl4-openssl-dev \
    libxml2-dev \
    apache2-utils \
    nginx \
    openssl \
    ruby-dev \
    sudo \
    net-tools \
    lsof \
    supervisor
# Instalar dependências JavaScript
ARG NODE_VERSION=20.11.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Instalar módulos do Node.js
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copiar os arquivos Gemfile e Gemfile.lock para o contêiner
COPY Gemfile Gemfile.lock ./

# Atualizar o RubyGems
RUN gem update --system 3.2.3

# Instalar o Bundler
RUN gem install bundler:2.4.22

# Instale o Rails
RUN gem install rails -v 5.2.8

# Instalar as dependências Ruby
RUN bundle install

# Criar o diretório tmp/pids e o arquivo server.pid
RUN mkdir -p tmp/pids && touch tmp/pids/server.pid

#RUN bundle exec rails credentials:edit

#COPY config/master.key /app/config/master.key

# Executar as migrações e sementes
#RUN bundle exec rails db:migrate

# Criar diretório para logs do Sidekiq
RUN mkdir -p /var/log/sidekiq

# Copiar arquivo de configuração do Supervisor para o contêiner
COPY sidekiq.conf /etc/supervisor/conf.d/sidekiq.conf

# Configurar o Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crie o diretório para armazenar os certificados SSL
RUN mkdir -p /etc/nginx/ssl

# Crie o diretório para armazenar os certificados SSL do Apache
RUN mkdir -p /etc/apache2/ssl

RUN mkdir -p /var/log/apache2/

# Gere o certificado SSL autoassinado
RUN openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" \
    -keyout /etc/nginx/ssl/private.key -out /etc/nginx/ssl/certificate.crt

# Criar diretório para logs do Puma
RUN mkdir -p /var/log/puma

# Copiar o arquivo de configuração do Puma para o contêiner
COPY config/puma.rb /app/config/puma.rb

# Copiar arquivo de configuração do Supervisor principal para o contêiner
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Preparar os assets
#RUN bundle exec rails assets:precompile

# Expor a porta 3000
EXPOSE 3000

# Comando padrão para execução
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]