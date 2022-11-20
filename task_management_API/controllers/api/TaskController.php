<?php

namespace app\controllers\api;

use yii\rest\ActiveController;
use yii\filters\auth\CompositeAuth;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\helpers\ArrayHelper;
use app\models\Task;

/**
 * TaskController implements the REST API actions for Task model.
 */
class TaskController extends ActiveController
{
    public $modelClass = 'app\models\Task';

    /**
     * @inheritDoc
     */
    public function actions()
    {
        return ['get-my-tasks'];
    }

    /**
     * @inheritDoc
     */
    // public function behaviors()
    // {
    //     $behaviors = parent::behaviors();
    //     $behaviors['authenticator'] = [
    //         'class' => CompositeAuth::class,
    //         'authMethods' => [
    //             HttpBearerAuth::class,
    //         ],
    //     ];
    //     return $behaviors;
    // }
    // public function behaviors() {
    //     return ArrayHelper::merge(parent::behaviors(), [    
    //         'verbs' => [    
    //             'class' => VerbFilter::className(),    
    //             'actions' => [    
    //                 'authenticate'  => ['post'],
    //                 'register'      => ['post'],     
    //             ],    
    //         ],    
    //     ]);
    
    // }

    //TODO: PUT action doesn't save the entity
    //TODO: DELETE action returns an http code 204

    public function actionGetMyTasks($userId){
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        $tasks = \app\models\Task::findByUserId($userId);

        return [
            'success' => true,
            'data'  => $tasks,
        ];
    }

}
