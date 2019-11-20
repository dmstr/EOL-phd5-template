<?php
// This is global bootstrap for autoloading

use Codeception\Configuration;

$rootPath = dirname(__DIR__, 3);

require $rootPath . '/vendor/autoload.php';
require $rootPath . '/config/env.php';

# TODO: review run webserver in YII_ENV=prod for acceptance tests, yii2-localurls has redirect issues in YII_ENV=test, see https://github.com/codemix/yii2-localeurls/issues/62
if (PHP_SAPI === 'cli' && getenv('YII_ENV') !== 'test') {
    echo "Error: YII_ENV must be set to 'test'\n";
    exit(1);
}

defined('YII_DEBUG') or define('YII_DEBUG', true);
defined('YII_ENV') or define('YII_ENV', 'test');

defined('YII_TEST_ENTRY_URL') or define(
    'YII_TEST_ENTRY_URL',
    parse_url(Configuration::config()['config']['test_entry_url'], PHP_URL_PATH)
);
defined('YII_TEST_ENTRY_FILE') or define('YII_TEST_ENTRY_FILE', realpath(dirname(__DIR__, 2) . '/web/index.php'));

require_once $rootPath . '/vendor/yiisoft/yii2/Yii.php';

$_SERVER['SCRIPT_FILENAME'] = YII_TEST_ENTRY_FILE;
$_SERVER['SCRIPT_NAME'] = YII_TEST_ENTRY_URL;
$_SERVER['SERVER_NAME'] = parse_url(Configuration::config()['config']['test_entry_url'], PHP_URL_HOST);
$_SERVER['SERVER_PORT'] = parse_url(Configuration::config()['config']['test_entry_url'], PHP_URL_PORT) ?: '80';

Yii::setAlias('@tests', dirname(__DIR__));
