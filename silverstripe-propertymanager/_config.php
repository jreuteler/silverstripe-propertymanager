<?php

global $project;
$project = 'silverstripe-propertymanager';

global $database;
$database = '';

require_once('conf/ConfigureFromEnv.php');

// Set the site locale
i18n::set_locale('en_US');


if (!defined('PROPERTYMANAGER_DIR')) {
    define('PROPERTYMANAGER_DIR', basename(dirname(__FILE__)));
}
