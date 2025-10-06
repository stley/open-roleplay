forward Task:orm_async_update(ORM:id);
forward OnORMTaskUpdate(Task:t, ORM:id);


Task:orm_async_update(ORM:id){
    new Task:t = task_new();
    orm_update(id, "OnORMTaskUpdate", "dd", _:t, _:id);
    return t;
}

public OnORMTaskUpdate(Task:t, ORM:id){
    if(id != MYSQL_INVALID_ORM)
        task_set_result(t, _:orm_errno(id));
    else task_set_result(t, _:ERROR_INVALID);
    return 1;
}

Dialog_Close(playerid){
    yield 1;
    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
}