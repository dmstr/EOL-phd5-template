<?php

use yii\helpers\ArrayHelper;
use yii\i18n\DbMessageSource;

// general configuration across all application types
$common = [
    'aliases' => [
        '@project' => '@root/project/src'
    ],
    'components' => [
        'i18n' => [
            'translations' => [
                'noty' => [
                    'class' => DbMessageSource::class,
                    'sourceLanguage' => 'xx-XX',
                    'sourceMessageTable' => '{{%language_source}}',
                    'messageTable' => '{{%language_translate}}',
                    'cachingDuration' => 86400,
                    'enableCaching' => !YII_ENV_DEV
                ]
            ]
        ]
    ],
    'modules' => [
        'user' => [
            'generatePasswords' => true
        ],
        'translatemanager' => [
            'root' => [
                '@project',
                '@vendor/loveorigami/yii2-notification-wrapper/src'
            ]
        ]
    ]
];

// web specific application config
$web = [];

// console specific application config
$console = [
    'controllerMap' => [
        'migrate' => [
            'migrationPath' => []
        ]
    ]
];

return ArrayHelper::merge($common, ${APP_TYPE});
