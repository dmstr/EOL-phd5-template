<?php

/**
 * Class LoginLogoutCest
 * @group mandatory
 */
class ProjectCest
{
    /**
     * @param CliTester $I
     */
    public function testYii(CliTester $I)
    {
        $I->runShellCommand('yii');
        $I->seeInShellOutput('This is Yii');
    }
}
