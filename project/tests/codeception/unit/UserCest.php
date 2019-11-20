<?php

use Da\User\Model\User;

/**
 * Class ControllerCest
 *
 * @group mandatory
 */
class UserCest
{
    /**
     * @param UnitTester $I
     */
    public function testUserLoginLogout(UnitTester $I)
    {
        $identity = User::findIdentity(1);

        $I->assertNotNull($identity);
        $I->assertTrue(\Yii::$app->user->login($identity));
        $I->assertTrue(\Yii::$app->user->logout());
    }

    /**
     * @param UnitTester $I
     */
    public function testNonExistingUserModel(UnitTester $I)
    {
        $I->assertNull(User::findIdentity(99999));
    }
}
