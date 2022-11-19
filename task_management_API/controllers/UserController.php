<?php

namespace app\controllers;

use app\models\User;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\filters\AccessControl;

/**
 * UserController implements the CRUD actions for User model.
 */
class UserController extends Controller
{

    //TODO: create the roles admin and user

    /**
     * @inheritDoc
     */
    public function behaviors()
    {
        return array_merge(
            parent::behaviors(),
            [
                'verbs' => [
                    'class' => VerbFilter::className(),
                    'actions' => [
                        'delete' => ['POST'],
                    ],
                ],
                'access' => [
                    'class' => AccessControl::class,
                    'rules' => [
                        [
                            'allow' => true,
                            'actions' => ['login'],
                            'roles' => ['?'],
                        ],
                        [
                            'allow' => true,
                            'actions' => ['logout', 'index', 'view', 'create', 'update', 'delete'],
                            'roles' => ['@'],
                        ],
                    ],
                ],
            ]
        );
    }

    /**
     * Lists all User models.
     *
     * @return string
     */
    public function actionIndex()
    {
        $dataProvider = new ActiveDataProvider([
            'query' => User::find(),
            /*
            'pagination' => [
                'pageSize' => 50
            ],
            'sort' => [
                'defaultOrder' => [
                    'id' => SORT_DESC,
                ]
            ],
            */
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single User model.
     * @param int $id ID
     * @return string
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionView($id)
    {
        return $this->render('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new User model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return string|\yii\web\Response
     */
    public function actionCreate()
    {
        //TODO: It should display only username and password. I don't understand scenarios.
        $model = new User(['scenario' => User::SCENARIO_CREATE]);

        if ($this->request->isPost) {
            if($model->load($this->request->post())){
                $model->password = \Yii::$app->security->generatePasswordHash($model->password);
                $model->authKey = \Yii::$app->getSecurity()->generateRandomString();
                $model->accessToken = \Yii::$app->getSecurity()->generateRandomString();

                if ($model->save()) {
                    return $this->redirect(['view', 'id' => $model->id]);
                }
            }            
        } else {
            $model->loadDefaultValues();
        }

        return $this->render('create', [
            'model' => $model,
        ]);
    }

    /**
     * Updates an existing User model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param int $id ID
     * @return string|\yii\web\Response
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        $model->scenario = User::SCENARIO_CREATE;

        $currentPassword = $model->password;
        //TODO: It should be solved by scenarios
        $currentKey = $model->authKey;
        $currentToken = $model->accessToken;

        $model->password = '';
        $model->authKey = '';
        $model->accessToken = '';

        if ($this->request->isPost) {
            if($model->load($this->request->post())){

                if(!empty($model->password)){
                    $model->password = \Yii::$app->security->generatePasswordHash($model->password);
                }else{
                    $model->password = $currentPassword;
                }   
                
                $model->authKey = $currentKey;
                $model->accessToken = $currentToken;

                if($model->save()){
                    return $this->redirect(['view', 'id' => $model->id]);
                }
            }            
        }

        return $this->render('update', [
            'model' => $model,
        ]);
    }

    /**
     * Deletes an existing User model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param int $id ID
     * @return \yii\web\Response
     * @throws NotFoundHttpException if the model cannot be found
     */
    public function actionDelete($id)
    {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the User model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param int $id ID
     * @return User the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = User::findOne(['id' => $id])) !== null) {
            return $model;
        }

        throw new NotFoundHttpException('The requested page does not exist.');
    }
    
}
