class TaskDTO{

  int id    = 0;
  int statusId = 0;
  int userId = 0;
  String title  = '';
  String description = '';

  TaskDTO();

  TaskDTO.fromMap(Map obj){
    id          = obj['id'];
    statusId    = obj['status_id'];
    userId      = obj['user_id'];
    title       = obj['title'];
    description = obj['description'];
  }

}