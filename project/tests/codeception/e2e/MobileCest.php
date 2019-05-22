<?php

/**
 * Class MobileCest
 * @group mandatory
 */
class MobileCest
{
    /**
     * @param E2eTester $I
     * @throws \Exception
     */
    public function checkResponsiveLayout(E2eTester $I)
    {
        // resize window to desired dimensions
        $I->resizeWindow(320, 568);
        // go to home page
        $I->amOnPage('/');
        $I->makeScreenshot('mobile');

        // open navbar
        $I->click('button.navbar-toggle');
        $I->waitForElementVisible('#link-login');
        $I->seeElement('li.active');
        $I->seeElement('#link-login');

        $I->dontSeeHorizontalScrollbars();
        $I->makeScreenshot('mobile-open-menu');
    }
}
