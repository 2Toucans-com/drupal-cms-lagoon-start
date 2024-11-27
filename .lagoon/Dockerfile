FROM uselagoon/php-8.3-cli-drupal:latest AS cli

RUN mkdir -p -v -m775 /app

COPY composer.* /app
COPY assets /app/assets
COPY config /app/config

ADD https://git.drupalcode.org/project/drupal_cms.git#0.x /app/drupal_cms

RUN mkdir -p -v -m775 /home/.composer/cache \
    && fix-permissions /home/.composer/cache \
    && mkdir -p -v -m775 /app/web/sites/default/files \
    && fix-permissions /app/web/sites/default/files \
    && mkdir -p -v -m775 /app/vendor \
    && fix-permissions /app/vendor \
    && mkdir -p -v -m775 /app/web \
    && fix-permissions /app/web

# RUN composer install --no-dev
RUN apk add --no-cache jq \
    && cd /app/drupal_cms \
    # following https://git.drupalcode.org/project/drupal_cms/-/blob/0.x/.ddev/config.yaml?ref_type=heads#L16
    && jq -s ".[0] * .[1] * .[2]" project_template/composer.json dev.composer.json components.composer.json >composer.json \
    && cd /app \
    && composer install --no-dev \
    # removing the additional drupal-scaffold configuration to allow PB/AU to work
    && composer config extra.drupal-scaffold --unset \
    && composer update --no-dev --lock\
    # couple of nasty hacks to get the installer to work
    && cp -r /app/drupal_cms/project_template/web/profiles/drupal_cms_installer /app/web/profiles/ \
    && cp -r /app/web/recipes /app/

# Define where the Drupal Root is located
ENV WEBROOT=web

FROM uselagoon/nginx-drupal:latest AS nginx

COPY --from=cli /app /app

ENV WEBROOT=web

FROM uselagoon/php-8.3-fpm:latest AS php
 
COPY --from=cli /app /app
# php-fpm needs to have the composer binary and rsync available
COPY --from=cli /usr/local/bin/composer /usr/local/bin/composer

RUN apk add --no-cache \
    rsync
