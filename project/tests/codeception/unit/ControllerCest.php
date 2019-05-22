<?php

/**
 * Class ControllerCest
 *
 * @group mandatory
 */
class ControllerCest
{
    /**
     * @param UnitTester $I
     */
    public function testApp(UnitTester $I)
    {
        $I->assertNotNull(Yii::$app);
    }

    /**
     * @param UnitTester $I
     *
     * @throws \yii\base\InvalidConfigException
     */
    public function testController(UnitTester $I)
    {
        $I->assertNotEquals(false, Yii::$app->createController('site/index'));
    }
}