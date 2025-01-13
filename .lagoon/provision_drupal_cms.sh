#!/bin/bash

cd /app

git clone https://git.drupalcode.org/project/drupal_cms.git ./

jq -s ".[0] * .[1] * .[2]" project_template/composer.json dev.composer.json components.composer.json >composer.json

git config --global --add safe.directory /app

composer require amazeeio/drupal_integrations drupal/lagoon_logs

composer install --no-dev

cp -r project_template/web/profiles/drupal_cms_installer /app/web/profiles/



