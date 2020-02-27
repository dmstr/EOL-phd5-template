<?php

use yii\helpers\ArrayHelper;

// general configuration across all application types
$common = [
    'aliases' => [
        '@project' => '@root/project/src'
    ],
    'modules' => [
        'user' => [
            'generatePasswords' => true
        ],
    ]
];

// web specific application config
$web = [];

// console specific application config
$console = [];

return ArrayHelper::merge($common, ${APP_TYPE});
