#include <sourcemod>
#include <sdktools>

#define PLUGIN_AUTHOR "Chairs"
#define PLUGIN_VERSION "0.0.4"
#pragma semicolon 1

new Handle:gPluginEnabled = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Chairs ResetScore",
	author = PLUGIN_AUTHOR,
	description = "To stop bastards typing !rs",
	version = PLUGIN_VERSION,
	url = "173.199.78.154:27015"
};
public OnPluginStart()
{
	RegConsoleCmd( "say", CommandSay );
	RegConsoleCmd( "say_team", CommandSay );
	
	gPluginEnabled = CreateConVar( "chairs_resetscore", "1" );
	CreateConVar( "chairs_resetscore_version", PLUGIN_VERSION, "Chairs_ResetScore", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY );
}
public Action:CommandSay( id, args )
{
	decl String:Said[ 128 ];
	GetCmdArgString( Said, sizeof( Said ) - 1 );
	StripQuotes( Said );
	TrimString( Said );
	
	if( StrEqual( Said, "!rs" ) || StrEqual( Said, "!resetscore" ) )
	{
		if( GetConVarInt( gPluginEnabled ) == 0 )
		{
			PrintToChat( id, "\x03[Chairs ResetScore] Plugin not enabled" );
			PrintToConsole( id, "[Chairs ResetScore] Plugin not enabled" );
		
			return Plugin_Continue;
		}
			
		SetClientFrags( id, GetClientFrags( id ) - 1 );
		SetClientDeaths( id, GetClientDeaths( id ) + 1 );
	
		decl String:Name[ 32 ];
		GetClientName( id, Name, sizeof( Name ) - 1 );

		PrintToChatAll( "\x03[Chairs ResetScore] My name is %s and I'm an arse", Name );
	}
	
	return Plugin_Continue;
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
