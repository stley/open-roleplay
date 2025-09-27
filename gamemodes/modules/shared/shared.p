forward Task:orm_update_s(ORM:id);
forward OnORMTaskUpdate(Task:t, ORM:id);


public OnORMTaskUpdate(Task:t, ORM:id){
    if(id != MYSQL_INVALID_ORM){
        if(orm_errno(id) != ERROR_OK) task_set_result(t, _:orm_errno(id));
        else task_set_result(t, 0);
    }
    return 1;
}

stock Task:orm_update_s(ORM:id){
    new Task:t = task_new();
    orm_update(id, "OnORMTaskUpdate", "d", _:t);
    return t;
}

Dialog_Close(playerid){
    yield 1;
    ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
}