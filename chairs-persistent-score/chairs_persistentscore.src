#include <sourcemod>
#include <sdktools>

#define PLUGIN_AUTHOR "Chairs"
#define PLUGIN_VERSION "0.0.2"
#pragma semicolon 1

#define MAX_NAME_LEN 40
#define MAX_RECORDED_PLAYERS 50
#define MAX_SID_LEN 32

new Handle:g_steamIdArray;

new s_playerKills[MAX_RECORDED_PLAYERS];
new s_playerDeaths[MAX_RECORDED_PLAYERS];

public Plugin:myinfo = 
{
	name = "Chairs PersistentScore",
	author = PLUGIN_AUTHOR,
	description = "To stop bastards leaving and resetting their score",
	version = PLUGIN_VERSION,
	url = "173.199.78.154:27015"
};

public OnPluginStart(){

	CreateConVar( "chairs_persistentscore_Version", PLUGIN_VERSION, "Chairs_PersistentScore", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY );
	
	HookEvent("player_disconnect", 	EventPlayerDisconnect);
		
	g_steamIdArray = CreateArray(MAX_RECORDED_PLAYERS);
}

public OnClientPostAdminCheck(client) {
	
	if(IsFakeClient(client)) 
    { 
        return; 
    } 
	
	new String:sidBuf[MAX_SID_LEN] = "";
	GetClientAuthId(client, AuthId_Steam2, sidBuf, MAX_SID_LEN);
	
	/*
	PrintToChatAll( "\x03[Chairs PersistentScore] Player joined with SID %s and buff size: %d", sidBuf, GetArraySize(g_steamIdArray));
	*/
	
	new String:sidArrayBuf[MAX_SID_LEN];

	for (new idx = 0; idx < GetArraySize(g_steamIdArray); idx++) {
	
		GetArrayString(g_steamIdArray, idx, sidArrayBuf, MAX_SID_LEN);

		if (StrEqual(sidBuf, sidArrayBuf)) {

			PrintToChatAll( "\x03[Chairs PersistentScore] Setting %s with Kills [%d] : Deaths [%d]", sidBuf, s_playerKills[idx], s_playerDeaths[idx]);

			SetClientFrags(client, s_playerKills[idx]);
			SetClientDeaths(client, s_playerDeaths[idx]);
			break;
		}
	}

}

public OnMapStart() {

	ClearArray(g_steamIdArray);
	/*
	PrintToChatAll( "\x03[Chairs PersistentScore] Resetting score pool");
	*/
}

public EventPlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new playerId = GetClientOfUserId(GetEventInt(event, "userid"));
	
	new String:sidBuf[MAX_SID_LEN] = "";
	GetClientAuthId(playerId, AuthId_Steam2, sidBuf, MAX_SID_LEN);
	
	new String:sidArrayBuf[MAX_SID_LEN];

	new found = 0;
	
	for (new idx = 0; idx < GetArraySize(g_steamIdArray); idx++) {

		GetArrayString(g_steamIdArray, idx, sidArrayBuf, MAX_SID_LEN);
		/*
		PrintToChatAll( "\x03[Chairs PersistentScore] SidArrayBuff value: %s", sidArrayBuf);
		*/
	
		if (StrEqual(sidBuf, sidArrayBuf)) {
			s_playerKills[idx]=GetClientFrags(playerId);
			s_playerDeaths[idx]=GetClientDeaths(playerId);
			found = 1;
			/*
			PrintToChatAll( "\x03[Chairs PersistentScore] FOUND EXISTING PLAYER Steam ID: %s | IDX: %d disconnected with Kills %d | Deaths %d ", sidBuf, GetArraySize(g_steamIdArray), s_playerKills[GetArraySize(g_steamIdArray)], s_playerDeaths[GetArraySize(g_steamIdArray)]);
			*/
			break;
		}
	}

	if (found == 0) {
		PushArrayString(g_steamIdArray, sidBuf);
		s_playerKills[GetArraySize(g_steamIdArray) - 1]=GetClientFrags(playerId);
		s_playerDeaths[GetArraySize(g_steamIdArray) - 1]=GetClientDeaths(playerId);
		/*
		PrintToChatAll( "\x03[Chairs PersistentScore] ADDING NEW PLAYER Steam ID: %s | IDX: %d disconnected with Kills %d | Deaths %d ", sidBuf, GetArraySize(g_steamIdArray), s_playerKills[GetArraySize(g_steamIdArray)], s_playerDeaths[GetArraySize(g_steamIdArray)]);
		*/
	}

} 

stock SetClientFrags( index, frags )
{
	SetEntProp( index, Prop_Data, "m_iFrags", frags );
	return 1;
}

stock SetClientDeaths( index, deaths )
{
	SetEntProp( index, Prop_Data, "m_iDeaths", deaths );
	return 1;
}
