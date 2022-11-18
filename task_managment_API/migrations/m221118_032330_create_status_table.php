<?php

use yii\db\Migration;

/**
 * Handles the creation of table `{{%status}}`.
 */
class m221118_032330_create_status_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->createTable('{{%status}}', [
            'id'        => $this->primaryKey(),
            'status'    => $this->string(50)->notNull(),
        ]);

        $this->alterColumn('{{%status}}', 'id', $this->integer());

        $this->createIndex(
            'idx-task-status_id',
            'task',
            'status_id'
        );

        $this->addForeignKey(
            'fk-task-status_id',
            'task',
            'status_id',
            'status',
            'id',
            'CASCADE'
        );

        $this->createIndex(
            'idx-task-user_id',
            'task',
            'user_id'
        );

        $this->addForeignKey(
            'fk-task-user_id',
            'task',
            'user_id',
            'user',
            'id',
            'CASCADE'
        );

        $this->insert('{{%status}}', [
            'id'        => 1,
            'status'    => 'Pending',
        ]);
        
        $this->insert('{{%status}}', [
            'id'        => 2,
            'status'    => 'Completed',
        ]);
        
        $this->insert('{{%status}}', [
            'id'        => 3,
            'status'    => 'Canceled',
        ]);
        
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        $this->dropForeignKey(
            'fk-task-user_id',
            'task'
        );

        $this->dropIndex(
            'idx-task-user_id',
            'task'
        );

        $this->dropForeignKey(
            'fk-task-status_id',
            'task'
        );

        $this->dropIndex(
            'idx-task-status_id',
            'task'
        );

        $this->delete('{{%status}}');

        $this->dropTable('{{%status}}');
    }
}
