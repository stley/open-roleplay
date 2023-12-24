
forward Acc_OnUserFirstLoad(playerid);
forward Acc_OnPlayerRequestClass(playerid, classid);
public Acc_OnPlayerRequestClass(playerid, classid)
{
	new str[256];
	orm_user(playerid);
	mysql_format(SQLDB, str, sizeof(str), "SELECT * FROM `accounts` WHERE `Nombre` = '%e' LIMIT 1", username[playerid]);
	mysql_tquery(SQLDB, str, "Acc_OnUserFirstLoad", "d", playerid);
	return 1;
}

public Acc_OnUserFirstLoad(playerid)
{
	new str[150];
	if(cache_num_rows())
	{
		orm_apply_cache(Datos[playerid][ORMID], 0);
		formatt(str, "Bienvenido %s.\nIngresa tu contraseña para continuar.", username[playerid]);
		Dialog_Show(playerid, D_INGRESO, DIALOG_STYLE_PASSWORD, "Ingreso", str, "Ingresar", "Salir");
	}
	else
	{
		formatt(str, "Bienvenido %s.\nIngrese una contraseña para continuar.", username[playerid]);
		Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", str, "Continuar", "Salir");
	}
	return 1;
}
