<?php

// @group mandatory

$rootPath = realpath(__DIR__.'/../../..');

$I = new FunctionalTester($scenario);

$I->wantTo('check application versioning');

$I->amInPath($rootPath);
$I->dontSeeFileFound('version');

$I->amInPath($rootPath.'/src');
$I->seeFileFound('version');

$I->openFile($rootPath.'/src/version');

$I->dontSeeInThisFile('dev');
$I->dontSeeInThisFile('dirty');
