new IntentosLogin[MAX_PLAYERS];
//new jPJE[MAX_PLAYERS][3][MAX_PLAYER_NAME];
#define DEFAULT_MAX_CHARACTERS	3

enum jInfo
{
	//Usuario
	ORM:ORMID,
	jSQLID,
	jNombre[33],
	jClave[BCRYPT_HASH_LENGTH],
	jEmail[101],
	jAdmin,
	jFacMan,
	jStaffMan,
	jPropMan,
	jIP[17],
	jCreditos,
	jPremium,
	jDpremium,
	jMpremium,
	jApremium,
	bool: LoggedIn,
	FechaReg[101],
	UltimaConexion[101],
	CharacterLimit,

	
	
	//Personaje
	ORM:ORMPJ,
	jSQLIDP,
	bool: EnChar,
	jUsuario,
	jNombrePJ[MAX_PLAYER_NAME],
	jNivel,
	jExp,
	jHoras,
	jPuntosRol,
	jPuntosRolNeg,
	jEdad,
	jSexo,
	jDinero,
	jRopa,
	ORM:inventoryORM,
	jMano[2],
	jManoCant[2],
	jManoData[2],
	jBolsillo[5],
	jBolsilloCant[5],
	jBolsilloData[5],
	jEspalda,
	jEspaldaCant,
	jPecho,
	jPechoCant,
	jEspaldaData,
	jPechoData,
	Float:jVida,
	Float:jChaleco,
	Float:jPosX,
	Float:jPosY,
	Float:jPosZ,
	Float:jPosR,
	jVW,
	jInt,
	jFaccion,
	jRango,
	jDiv,
	jFaccion2,
	jRangoFac2,
	jDiv2,
	jDocumento,
	jLicencias[2],
	jCocheLlaves[2],
	jCasa[2],
	jCasaLlaves,
	jFechaCreacion[101]
};


new
	muerto[MAX_PLAYERS],
	//No almacenables en la base de datos - Datos temporales, no persisten entre sesiones!
	/*
	Solicitudes
	1 - Cacheos
	*/
	solicitud_tipo[MAX_PLAYERS],
	solicitante[MAX_PLAYERS],
	solicitud_timer[MAX_PLAYERS],
	/*
	EditTypes
	1 - Accesorios (Primera vez colocados)
	2 - Edición de accesorios ya colocados
	*/	
	EditType[MAX_PLAYERS],
	// AutoSave
	autosaveTimer[MAX_PLAYERS],

	/* CheckPoints
	1 - Localizar vehiculo
	*/
	checkpoints[MAX_PLAYERS],
	esposado[MAX_PLAYERS],
	CinturonV[MAX_PLAYERS],
	DentroCasa[MAX_PLAYERS], // Esta el personaje dentro de un casa?
	DentroNegocio[MAX_PLAYERS], //Esta el personaje dentro de una negocio?
	asesino[MAX_PLAYERS][MAX_PLAYER_NAME], //Contendría la última persona que te asesinó/noqueo.
	Cache:characterCache[MAX_PLAYERS] // Cache necesaria para la precarga de personajes en tu cuenta.
;
enum characterToys
{
	ORM:ORM_toy,
	jToy_Gorro,
	jToy_Gafas,
	jToy_Boca,
	jToy_Cuerpo,
	jToy_Pecho,
	Float:GorroPos[3],
	Float:GorroRot[3],
	Float:GorroScale[3],
	Float:GafasPos[3],
	Float:GafasRot[3],
	Float:GafasScale[3],
	Float:BocaPos[3],
	Float:BocaRot[3],
	Float:BocaScale[3],
	Float:CuerpoPos[3],
	Float:CuerpoRot[3],
	Float:CuerpoScale[3],
	Float:PechoPos[3],
	Float:PechoRot[3],
	Float:PechoScale[3]
};

new
	CharToys[MAX_PLAYERS][characterToys],
	/*userData[MAX_PLAYERS][uInfo],
	characterData[MAX_PLAYERS][charInfo],
	characterInventory[MAX_PLAYERS][jInventory]*/
	Datos[MAX_PLAYERS][jInfo]
;
