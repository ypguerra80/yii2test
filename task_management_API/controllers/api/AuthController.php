<?php

namespace app\controllers\api;

use yii\rest\ActiveController;
use yii\filters\VerbFilter;
use yii\helpers\ArrayHelper;
use app\models\User;

/**
 * AuthController implements the REST API actions for authentication.
 */
class AuthController extends ActiveController
{

    public $modelClass = 'app\models\User';

    /**
     * @inheritDoc
     */
    public function actions()
    {
        return ['authenticate', 'available', 'register'];
    }

     /**
     * @inheritDoc
     */
    public function behaviors() {
        return ArrayHelper::merge(parent::behaviors(), [    
            'verbs' => [    
                'class' => VerbFilter::className(),    
                'actions' => [    
                    'authenticate'  => ['post'],
                    'register'      => ['post'],     
                ],    
            ],    
        ]);
    
    }

    public function actionAuthenticate(){
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        //TODO: Do I need to sanitize user data?... Or Yii takes care of it
        $username = \Yii::$app->request->post('username');
        $password = \Yii::$app->request->post('password');

        $user = \app\models\User::findByUsername($username);

        if(empty($user) || !$user->validatePassword($password, false)){
            return [
                'success' => false,
            ];
        }

        $user->accessToken = \Yii::$app->getSecurity()->generateRandomString();
        $user->scenario = User::SCENARIO_CREATE;
        $user->save();

        return [
            'success'   => true,
            'token'     => $user->accessToken,
            'id'        => $user->id,
        ];
    }

    public function actionAvailable($name){
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        //TODO: Do I need to sanitize user data?... Or Yii takes care of it
        $user = \app\models\User::findByUsername($name);

        return [
            'available' => empty($user),
        ];
    }

    public function actionRegister(){
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;

        //TODO: Do I need to sanitize user data?... Or Yii takes care of it
        $username = \Yii::$app->request->post('username');
        $password = \Yii::$app->request->post('password');

        $user = \app\models\User::findByUsername($username);

        if(empty($user)){
            $user = new User(['scenario' => User::SCENARIO_CREATE]);
            $user->username = $username;
            $user->password = \Yii::$app->security->generatePasswordHash($password);
            $user->authKey = \Yii::$app->getSecurity()->generateRandomString();
            $user->accessToken = \Yii::$app->getSecurity()->generateRandomString();
            $user->isAdmin = 0;

            if ($user->save()) {
                return [
                    'success'   => true,
                    'token'     => $user->accessToken,
                    'id'        => $user->id,
                ];
            }
        }

        return [
            'success' => false,
        ];
    }
}
