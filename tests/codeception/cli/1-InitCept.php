<?php

// @group run-once
// @group mandatory

$I = new CliTester($scenario);

$I->runShellCommand('yii app/setup');
$I->seeInShellOutput('Initializing application');
$I->seeInShellOutput('[OK]');

$I->runShellCommand('yii migrate/up');
$I->seeInShellOutput('No new migration found');

$I->runShellCommand("yii user/password admin admin1");
$I->seeInShellOutput('Password has been changed');

// TODO
$I->runShellCommand("yii user/delete --interactive=0 dev");
$I->runShellCommand("yii user/create dev@example.com dev dev1");
$I->runShellCommand("yii user/delete --interactive=0 editor");
$I->runShellCommand("yii user/create editor@example.com editor editor1");
$I->runShellCommand("yii user/delete --interactive=0 preview");
$I->runShellCommand("yii user/create preview@example.com preview preview1");
