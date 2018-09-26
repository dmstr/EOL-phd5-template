<?php

// @group mandatory

$projectPath = realpath(__DIR__.'/../../..');

$I = new FunctionalTester($scenario);

$I->wantTo('check project versioning');

$I->seeFileFound('version', $projectPath);

$I->openFile($projectPath.'/version');

$I->dontSeeInThisFile('dev');
$I->dontSeeInThisFile('dirty');
