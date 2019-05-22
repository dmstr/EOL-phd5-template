<?php

/**
 * Class ErrorPageCest
 * @group mandatory
 */
class ErrorPageCest
{
    /**
     * @param E2eTester $I
     * @throws \Exception
     */
    public function checkNotFoundPage(FunctionalTester $I)
    {
        $I->wantTo('ensure that error page works');

        $I->amOnPage('/_this_page_does_not_exist_');
        $I->seeResponseCodeIs(404);
        $I->see('Not Found');
    }
}
