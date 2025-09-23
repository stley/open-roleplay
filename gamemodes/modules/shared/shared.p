forward Task:ORMAsyncUpdate(ORM:id);
forward OnORMUpdate(Task:t, ORM:id);


Task:ORMAsyncUpdate(ORM:id){
	new Task:t = task_new();
    orm_update(id, "OnORMUpdate", "d", _:t);
    return t;
}

public OnORMUpdate(Task:t, ORM:id){
	if(orm_errno(id) != ERROR_OK){
		task_set_result(t, _:orm_errno(id));
		return 1;
	}
	else task_set_result(t, _:orm_errno(id));
	return 1;
}