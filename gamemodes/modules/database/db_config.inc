//MySQL
#define db_host    "localhost"
#define db_user    "root"
#define db_db      "baserp"
#define db_pass    "" 
new MySQL:SQLDB;
new username[MAX_PLAYERS][MAX_PLAYER_NAME];
forward SQL_OnGameModeInit();
forward SQL_OnGameModeExit();
public SQL_OnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	SQLDB = mysql_connect(db_host, db_user, db_pass, db_db);
	if(SQLDB == MYSQL_INVALID_HANDLE || mysql_errno(SQLDB) != 0)
	{
		printf("[MySQL] No se pudo conectar a la base de datos.");
		new error[150];
		mysql_error(error, sizeof(error));
		printf("[ERROR]: %s", error);
		SendRconCommand("exit");
	}
	else printf("[MySQL] Conectado a la base de datos.");
	return 1;
}

public SQL_OnGameModeExit()
{
	mysql_close(SQLDB); // Closing the database.
	return 1;
}