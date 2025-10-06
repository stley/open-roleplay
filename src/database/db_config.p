//MySQL
/*
#define db_host    "localhost"
#define db_user    "root"
#define db_db      "baserp"
#define db_pass    ""
*/
//If prefered to hard-code login info, uncomment all of this
#define mysql_config_filename	"mysql.ini"


new MySQL:SQLDB;
new initialname[MAX_PLAYERS][MAX_PLAYER_NAME];
new username[MAX_PLAYERS][33];

forward databaseOnGameModeInit();
forward databaseOnGameModeExit();

public databaseOnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	#if defined db_host
		SQLDB = mysql_connect(db_host, db_user, db_pass, db_db, option_id);
	#else
		SQLDB = mysql_connect_file(mysql_config_filename);
	#endif
	
	if(SQLDB == MYSQL_INVALID_HANDLE || mysql_errno(SQLDB) != 0)
	{
		new error[150];
		mysql_error(error, sizeof(error));
		serverLogRegister(sprintf("[MySQL] No se pudo conectar a la base de datos. ERROR: %s", error), CURRENT_MODULE);
		SendRconCommand("exit");
		return 1;
	}
	else serverLogRegister("[MySQL] Conectado a la base de datos.", CURRENT_MODULE);
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