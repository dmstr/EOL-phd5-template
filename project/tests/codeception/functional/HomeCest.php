<?php

/**
 * Class HomeCest
 * @group mandatory
 */
class HomeCest
{
    /**
     * @param E2eTester $I
     * @throws \Exception
     */
    public function checkHomePageReachability(FunctionalTester $I)
    {
        $I->wantTo('ensure that home page works');
        $I->amOnPage('/site/index');
        $I->seeElement('html');
        $I->seeResponseCodeIs(200);

        $I->seeLink('Login');
    }
}
