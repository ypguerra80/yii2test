<?php

namespace app\controllers\api;

use yii\rest\ActiveController;
use yii\filters\auth\CompositeAuth;
use yii\filters\auth\HttpBearerAuth;

/**
 * TaskController implements the REST API actions for Task model.
 */
class TaskController extends ActiveController
{
    public $modelClass = 'app\models\Task';

    /**
     * @inheritDoc
     */
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['authenticator'] = [
            'class' => CompositeAuth::class,
            'authMethods' => [
                HttpBearerAuth::class,
            ],
        ];
        return $behaviors;
    }

    //TODO: PUT action doesn't save the entity
    //TODO: DELETE action returns an http code 204

}
