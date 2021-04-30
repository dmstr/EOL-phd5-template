<?php

use yii\helpers\ArrayHelper;
use yii\i18n\DbMessageSource;

// general configuration across all application types
$common = [
    'aliases' => [
        '@project' => '@root/project/src'
    ],
    'modules' => [
        'user' => [
            'generatePasswords' => true
        ],
        'translatemanager' => [
            'root' => [
                '@project'
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
            'migrationPath' => [
                // add your project migration paths here
            ]
        ]
    ]
];

return ArrayHelper::merge($common, ${APP_TYPE});
