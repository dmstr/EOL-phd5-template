<?php

use yii\codeception\TestCase;

class ControllerTest extends TestCase
{

    public $appConfig = '@tests/codeception/_config/test.php';

    /**
     * @group mandatory
     */
    public function testApp()
    {

        $this->assertNotNull(Yii::$app);
    }

    public function testController(){
        $this->assertNotFalse(Yii::$app->createController('site/index'));
    }
}
