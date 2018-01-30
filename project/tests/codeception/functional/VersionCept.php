<?php

// @group mandatory

$rootPath = realpath(__DIR__.'/../../..');

$I = new FunctionalTester($scenario);

$I->wantTo('check application versioning');

$I->amInPath($rootPath);
$I->seeFileFound('version');

$I->openFile($rootPath.'/version');

$I->dontSeeInThisFile('dev');
$I->dontSeeInThisFile('dirty');
