<?php

use yii\db\Migration;

/**
 * Handles the creation of table `{{%task}}`.
 */
class m221118_025145_create_task_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->createTable('{{%task}}', [
            'id'            => $this->primaryKey(),
            'status_id'     => $this->integer()->notNull(),
            'user_id'       => $this->integer()->notNull(),
            'title'         => $this->string(255)->notNull(),
            'description'   => $this->text()->notNull(),
            'created_at'    => $this->timestamp()->null()->defaultExpression('CURRENT_TIMESTAMP'),
            'attachment'    => $this->binary(),
        ]);

        $this->alterColumn('{{%task}}', 'id', $this->integer().' NOT NULL AUTO_INCREMENT');

    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {       
        $this->dropTable('{{%task}}');
    }
}
