FROM uselagoon/php-8.3-cli-drupal:latest AS cli

RUN mkdir -p -v -m775 /app && fix-permissions /app

COPY ./.lagoon/fixapp_entrypoint.sh /lagoon/entrypoints/99_fixapp.sh

COPY ./provision_drupal_cms /usr/local/bin/

RUN mkdir -p -v -m775 /home/.composer/cache \
    && fix-permissions /home/.composer/cache
RUN  chown -R 1000:0 /app/ && chmod -R g+w /app/


#RUN apk add --no-cache jq
    # && cd /app/drupal_cms \
    # # following https://git.drupalcode.org/project/drupal_cms/-/blob/0.x/.ddev/config.yaml?ref_type=heads#L16
    # && jq -s ".[0] * .[1] * .[2]" project_template/composer.json dev.composer.json components.composer.json >composer.json \
    # && cd /app \
    # && composer install --no-dev \
    # # removing the additional drupal-scaffold configuration to allow PB/AU to work
    # && composer config extra.drupal-scaffold --unset \
    # && composer update --no-dev --lock\
    # # couple of nasty hacks to get the installer to work
    # && cp -r /app/drupal_cms/project_template/web/profiles/drupal_cms_installer /app/web/profiles/ \
    # && cp -r /app/web/recipes /app/

COPY ./.lagoon/cli-memory.ini /usr/local/etc/php/conf.d/01-drupal-cms-cli-memory-limit.ini

RUN mkdir -p -v -m775 /app && fix-permissions /app

# Define where the Drupal Root is located
ENV WEBROOT=web

FROM uselagoon/nginx-drupal:latest AS nginx

# COPY --from=cli /app /app

ENV WEBROOT=web

FROM uselagoon/php-8.3-fpm:latest AS php
 
# COPY --from=cli /app /app
# php-fpm needs to have the composer binary and rsync available
COPY --from=cli /usr/local/bin/composer /usr/local/bin/composer

COPY ./.lagoon/cli-memory.ini /usr/local/etc/php/conf.d/01-drupal-cms-cli-memory-limit.ini

RUN apk add --no-cache \
    rsync
