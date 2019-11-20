<?php

/**
 * Class VersionCest
 *
 * @group mandatory
 */
class VersionCest
{
    /**
     * @param E2eTester $I
     *
     * @throws \Exception
     */
    public function checkVersioningString(FunctionalTester $I)
    {
        $projectPath = realpath(dirname(__DIR__, 3));

        $I->wantTo('check project versioning');

        $I->seeFileFound('version', $projectPath);

        $I->openFile($projectPath . '/version');

        $I->dontSeeInThisFile('dev');
        $I->dontSeeInThisFile('dirty');
    }
}
