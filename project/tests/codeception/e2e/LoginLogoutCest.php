<?php

/**
 * Class LoginLogoutCest
 * @group mandatory
 */
class LoginLogoutCest
{

    /**
     * @param E2eTester $I
     *
     * @throws \Exception
     */
    public function loginLogout(E2eTester $I)
    {
        // login with correct credentials
        $I->login('admin', 'admin1');

        // open user menu to see logout button
        $I->click('.nav #link-user-menu a');
        $I->waitForElementVisible('#link-logout', 5);
        // click logout button
        $I->click('#link-logout');
        // wait for logout and ensure no error occurred
        $I->waitForElementNotVisible('#link-logout');
        $I->dontSee('405', 'h1');
        $I->seeElement('#link-login');
    }
}
