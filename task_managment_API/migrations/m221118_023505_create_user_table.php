<?php

use yii\db\Migration;

/**
 * Handles the creation of table `{{%user}}`.
 */
class m221118_023505_create_user_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->createTable('{{%user}}', [
            'id'            => $this->primaryKey(),
            'username'      => $this->string(50)->notNull(),
            'password'      => $this->string(255),
            'authKey'       => $this->string(255),
            'accessToken'   => $this->string(255),
        ]);
        $this->alterColumn('{{%user}}', 'id', $this->integer().' NOT NULL AUTO_INCREMENT');
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        $this->dropTable('{{%user}}');
    }
}
