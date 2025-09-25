//MySQL
#define db_host    "localhost"
#define db_user    "root"
#define db_db      "baserp"
#define db_pass    ""
new MySQL:SQLDB;
new initialname[MAX_PLAYERS][MAX_PLAYER_NAME];
new username[MAX_PLAYERS][33];

forward databaseOnGameModeInit();
forward databaseOnGameModeExit();

public databaseOnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	SQLDB = mysql_connect(db_host, db_user, db_pass, db_db);
	if(SQLDB == MYSQL_INVALID_HANDLE || mysql_errno(SQLDB) != 0)
	{
		new error[150];
		mysql_error(error, sizeof(error));
		serverLogRegister(sprintf("[MySQL] No se pudo conectar a la base de datos. ERROR: %s", error));
		SendRconCommand("exit");
	}
	else serverLogRegister("[MySQL] Conectado a la base de datos.");
	#if defined BUILD_DEBUG
		mysql_log(ALL);
	#endif
	#if defined BUILD_PRODUCTION
		mysql_log(ERROR | WARNING);
	#endif
	return 1;
}

public databaseOnGameModeExit()
{
	mysql_close(SQLDB);
	return 1;
}