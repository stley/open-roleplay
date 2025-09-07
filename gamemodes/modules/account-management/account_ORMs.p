orm_user(playerid)
{
	new ORM:ormid = Datos[playerid][ORMID] = orm_create("accounts", SQLDB);
	orm_addvar_int(ormid, Datos[playerid][jSQLID], "SQLID");
	orm_addvar_string(ormid, Datos[playerid][jNombre], MAX_PLAYER_NAME, "Nombre");
	orm_addvar_int(ormid, Datos[playerid][jAdmin], "Administrador");
	orm_addvar_int(ormid, Datos[playerid][jFacMan], "FacMan");
	orm_addvar_int(ormid, Datos[playerid][jStaffMan], "StaffMan");
	orm_addvar_int(ormid, Datos[playerid][jPropMan], "PropMan");
	orm_addvar_int(ormid, Datos[playerid][jCreditos], "Creditos");
	orm_addvar_string(ormid, Datos[playerid][jClave], BCRYPT_HASH_LENGTH, "Clave");
	orm_addvar_string(ormid, Datos[playerid][jEmail], 101, "Email");
	orm_addvar_string(ormid, Datos[playerid][jIP], 17, "IP");

	/*orm_addvar_string(ormid, jPJE[playerid][0], MAX_PLAYER_NAME, "Personaje_1");
	orm_addvar_string(ormid, jPJE[playerid][1], MAX_PLAYER_NAME, "Personaje_2");
	orm_addvar_string(ormid, jPJE[playerid][2], MAX_PLAYER_NAME, "Personaje_3");*/

	orm_addvar_string(ormid, Datos[playerid][FechaReg], 101, "Fecha_Reg");
	orm_addvar_string(ormid, Datos[playerid][UltimaConexion], 101, "Ultima_Conexion");

	orm_addvar_int(ormid, Datos[playerid][jPremium], "Premium");
	orm_addvar_int(ormid, Datos[playerid][jDpremium], "dPremium");
	orm_addvar_int(ormid, Datos[playerid][jMpremium], "mPremium");
	orm_addvar_int(ormid, Datos[playerid][jApremium], "aPremium");
	orm_addvar_int(ormid, Datos[playerid][CharacterLimit], "CharacterLimit");
	orm_setkey(ormid, "SQLID");
}
orm_char(playerid)
{
	new ORM:ormid = Datos[playerid][ORMPJ] = orm_create("characters", SQLDB);
	orm_addvar_int(ormid, Datos[playerid][jUsuario], "Usuario");
	orm_addvar_string(ormid, Datos[playerid][jNombrePJ], MAX_PLAYER_NAME, "NombrePJ");
	orm_addvar_string(ormid, Datos[playerid][jFechaCreacion], 101, "Fecha_Creacion");
	orm_addvar_int(ormid, Datos[playerid][jSQLIDP], "SQLIDPJ");

	orm_addvar_int(ormid, Datos[playerid][jNivel], "Nivel");
	orm_addvar_int(ormid, Datos[playerid][jExp], "Experiencia");
	orm_addvar_int(ormid, Datos[playerid][jHoras], "Horas");
	orm_addvar_int(ormid, Datos[playerid][jPuntosRol], "PuntosRol");
	orm_addvar_int(ormid, Datos[playerid][jPuntosRolNeg], "PuntosRolNeg");

	orm_addvar_float(ormid, Datos[playerid][jVida], "Salud");
	orm_addvar_int(ormid, muerto[playerid], "Muerto");
	orm_addvar_float(ormid, Datos[playerid][jChaleco], "Chaleco");
	orm_addvar_float(ormid, Datos[playerid][jPosX], "PosX");
	orm_addvar_float(ormid, Datos[playerid][jPosY], "PosY");
	orm_addvar_float(ormid, Datos[playerid][jPosZ], "PosZ");
	orm_addvar_float(ormid, Datos[playerid][jPosR], "PosR");
	orm_addvar_int(ormid, Datos[playerid][jVW], "VirtualWorld"); 
	orm_addvar_int(ormid, Datos[playerid][jInt], "Interior"); 
	orm_addvar_int(ormid, Datos[playerid][jEdad], "Edad");
	orm_addvar_int(ormid, Datos[playerid][jSexo], "Sexo");
	orm_addvar_int(ormid, Datos[playerid][jDinero], "Dinero");
	orm_addvar_int(ormid, Datos[playerid][jRopa], "Ropa");
	orm_addvar_int(ormid, Datos[playerid][jMano][0], "ManoDer");
	orm_addvar_int(ormid, Datos[playerid][jManoCant][0], "ManoDerCant");
	orm_addvar_int(ormid, Datos[playerid][jMano][1], "ManoIzq");
	orm_addvar_int(ormid, Datos[playerid][jManoCant][1], "ManoIzCant");
	orm_addvar_int(ormid, Datos[playerid][jManoData][0], "ManoDerData");
	orm_addvar_int(ormid, Datos[playerid][jManoData][1], "ManoIzData");
	for(new bol; bol < 5; bol++)
	{
		new str[24];
		formatt(str, "Bolsillo%d", bol);
		orm_addvar_int(ormid, Datos[playerid][jBolsillo][bol], str);
		formatt(str, "BolsilloCant%d", bol);
		orm_addvar_int(ormid, Datos[playerid][jBolsilloCant][bol], str);
		formatt(str, "BolsilloData%d", bol);
		orm_addvar_int(ormid, Datos[playerid][jBolsilloData][bol], str); 
	}
	orm_addvar_int(ormid, Datos[playerid][jPecho], "Pecho"); 
	orm_addvar_int(ormid, Datos[playerid][jPechoCant], "PechoCant"); 
	orm_addvar_int(ormid, Datos[playerid][jEspalda], "Espalda"); 
	orm_addvar_int(ormid, Datos[playerid][jEspaldaCant], "EspaldaCant"); 
	orm_addvar_int(ormid, Datos[playerid][jEspaldaData], "EspaldaData"); 
	orm_addvar_int(ormid, Datos[playerid][jPechoData], "PechoData"); 
	orm_addvar_int(ormid, Datos[playerid][jFaccion], "Faccion"); 
	orm_addvar_int(ormid, Datos[playerid][jRango], "RangoFac"); 
	orm_addvar_int(ormid, Datos[playerid][jDiv], "DivFac"); 
	orm_addvar_int(ormid, Datos[playerid][jFaccion2], "Faccion2"); 
	orm_addvar_int(ormid, Datos[playerid][jRangoFac2], "RangoFac2"); 
	orm_addvar_int(ormid, Datos[playerid][jDiv2], "DivFac2"); 
	orm_addvar_int(ormid, Datos[playerid][jDocumento], "Documento"); 
	orm_addvar_int(ormid, Datos[playerid][jLicencias][0], "Licencia1");
	orm_addvar_int(ormid, Datos[playerid][jLicencias][1], "Licencia2");
	orm_addvar_int(ormid, Datos[playerid][jCoche][0], "Coche1");
	orm_addvar_int(ormid, Datos[playerid][jCoche][1], "Coche2");
	orm_addvar_int(ormid, Datos[playerid][jCocheLlaves][0], "CocheLlaves1"); 
	orm_addvar_int(ormid, Datos[playerid][jCocheLlaves][1], "CocheLlaves2"); 
	orm_addvar_int(ormid, Datos[playerid][jCasa][0], "Casa");
	orm_addvar_int(ormid, Datos[playerid][jCasa][1], "Casa2");
	orm_addvar_int(ormid, Datos[playerid][jCasaLlaves], "CasaLlaves"); 

	//Toys
	new ORM:ormtoy = CharToys[playerid][ORM_toy] = orm_create("char_toys", SQLDB);
	orm_addvar_int(ormtoy, Datos[playerid][jSQLIDP], "character_id");
	orm_addvar_int(ormtoy, CharToys[playerid][jToy_Gorro], "Gorro");
	orm_addvar_int(ormtoy, CharToys[playerid][jToy_Gafas], "Gafas");
	orm_addvar_int(ormtoy, CharToys[playerid][jToy_Boca], "Boca");
	orm_addvar_int(ormtoy, CharToys[playerid][jToy_Pecho], "Pecho");
	orm_addvar_int(ormtoy, CharToys[playerid][jToy_Cuerpo], "Cuerpo");
	
	orm_addvar_float(ormtoy, CharToys[playerid][GorroPos][0], "GorroPosX");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroPos][1], "GorroPosY");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroPos][2], "GorroPosZ");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroRot][0], "GorroRotX");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroRot][1], "GorroRotY");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroRot][2], "GorroRotZ");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroScale][0], "GorroScaleX");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroScale][1], "GorroScaleY");
	orm_addvar_float(ormtoy, CharToys[playerid][GorroScale][2], "GorroScaleZ");

	orm_addvar_float(ormtoy, CharToys[playerid][GafasPos][0], "GafasPosX");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasPos][1], "GafasPosY");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasPos][2], "GafasPosZ");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasRot][0], "GafasRotX");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasRot][1], "GafasRotY");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasRot][2], "GafasRotZ");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasScale][0], "GafasScaleX");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasScale][1], "GafasScaleY");
	orm_addvar_float(ormtoy, CharToys[playerid][GafasScale][2], "GafasScaleZ");

	orm_addvar_float(ormtoy, CharToys[playerid][BocaPos][0], "BocaPosX");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaPos][1], "BocaPosY");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaPos][2], "BocaPosZ");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaRot][0], "BocaRotX");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaRot][1], "BocaRotY");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaRot][2], "BocaRotZ");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaScale][0], "BocaScaleX");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaScale][1], "BocaScaleY");
	orm_addvar_float(ormtoy, CharToys[playerid][BocaScale][2], "BocaScaleZ");

	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoPos][0], "CuerpoPosX");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoPos][1], "CuerpoPosY");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoPos][2], "CuerpoPosZ");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoRot][0], "CuerpoRotX");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoRot][1], "CuerpoRotY");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoRot][2], "CuerpoRotZ");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoScale][0], "CuerpoScaleX");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoScale][1], "CuerpoScaleY");
	orm_addvar_float(ormtoy, CharToys[playerid][CuerpoScale][2], "CuerpoScaleZ");

	orm_addvar_float(ormtoy, CharToys[playerid][PechoPos][0], "PechoPosX");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoPos][1], "PechoPosY");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoPos][2], "PechoPosZ");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoRot][0], "PechoRotX");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoRot][1], "PechoRotY");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoRot][2], "PechoRotZ");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoScale][0], "PechoScaleX");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoScale][1], "PechoScaleY");
	orm_addvar_float(ormtoy, CharToys[playerid][PechoScale][2], "PechoScaleZ");
	
	orm_setkey(ormid, "SQLIDPJ");
	return 1;
}