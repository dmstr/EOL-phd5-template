<?php


class ProjectCest
{
    public function _before(CliTester $I)
    {
    }

    public function _after(CliTester $I)
    {
    }

    // tests
    public function testYii(CliTester $I)
    {
        $I->runShellCommand('yii');
        $I->seeInShellOutput('This is Yii');
    }
}
