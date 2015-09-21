<?php

$options['show-passwords'] = 1;
$options['default-major'] = 7;
$options['structure-tables']['common'] = array(
  'cache',
  'cache_bootstrap',
  'cache_field',
  'cache_filter',
  'cache_form',
  'cache_image',
  'cache_menu',
  'cache_page',
  'cache_token',
  'flood',
  'sessions',
  'watchdog',
);

$options['shell-aliases']['dump'] = 'sql-dump --structure-tables-key=common --gzip --result-file=sites/default/database.sql';
$options['shell-aliases']['on'] = 'variable-delete -y --exact maintenance_mode';
$options['shell-aliases']['off'] = 'variable-set -y --always-set maintenance_mode 1';
