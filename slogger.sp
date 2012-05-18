/********************************** SLogger **********************************/

#pragma tabsize 0
#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

#define PLUGIN_VERSION "1.07"
#define TEAM_RED 2
#define TEAM_BLUE 3

new String:g_slogFile[PLATFORM_MAX_PATH+1];

public Plugin:myinfo = {
	name = "SLogger",
	author = "RogueDarkJedi",
	description = "Logs data from the server into nice little files that can be parsed for things",
	version = PLUGIN_VERSION,
	url = "http://roguedarkjedi.com"
}

public OnPluginStart(){
  ResetConVar(CreateConVar("sm_slogger_version", PLUGIN_VERSION, "SLogger Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD), true, true);
  
  RegConsoleCmd("say", Command_Say);
  RegConsoleCmd("say2", Command_Say);
  RegConsoleCmd("say_team", Command_Say);
  
  ServerCommand("sm config Logging on");
}

//////////////////////////////////////////////////////////////////////////////
//Map States
//////////////////////////////////////////////////////////////////////////////
public OnMapStart()
{
  /* Get the map */
  decl String:curMap[64];
  GetCurrentMap(curMap, sizeof(curMap));
  
  /* Generate the log file namestuffs */
  Format(g_slogFile, sizeof(g_slogFile), "logs/slog_test.log");
  
  /* Mention the map */
  LogToFile(g_slogFile, "---Map Loading: %s---", curMap);
  
  HookEvent("teamplay_round_start", teamplay_round_start);
  HookEvent("teamplay_round_win", teamplay_round_win);
  HookEvent("player_death", player_death);
  HookEvent("player_changeclass", player_changeclass);
  HookUserMessage(GetUserMessageId("VoiceSubtitle"), UserMessageHook, false);
}


public OnMapEnd()
{
  LogToFile(g_slogFile, "---Map Over---");
  UnhookEvent("teamplay_round_start", teamplay_round_start);
  UnhookEvent("teamplay_round_win", teamplay_round_win);
  UnhookEvent("player_death", player_death);
  UnhookEvent("player_changeclass", player_changeclass);
  UnhookUserMessage(GetUserMessageId("VoiceSubtitle"), UserMessageHook, false);
}

//////////////////////////////////////////////////////////////////////////////
//Client Connection States
//////////////////////////////////////////////////////////////////////////////
public OnClientAuthorized(client, const String:auth[]){
  if(client != 0)
  {
    LogToFile(g_slogFile, "[CON] %N connected SID: %s", client, auth);
  }
}

public OnClientDisconnect(client){
  if(client != 0 && IsClientInGame(client))
  {
    decl String:steamid[256]; 
    GetClientAuthString(client, steamid, sizeof(steamid));
    LogToFile(g_slogFile, "[DIS] %N disconnected SID: %s", client, steamid);
  }
}

//////////////////////////////////////////////////////////////////////////////
//Client Say
//////////////////////////////////////////////////////////////////////////////
public Action:Command_Say(client,args){
  if(client == 0)
    return Plugin_Continue;
  
  decl String:speech[128];
  GetCmdArgString(speech,sizeof(speech));
  
  LogToFile(g_slogFile, "[CHAT] %N T: %d A: %d Msg: %s", client, GetClientTeam(client), IsPlayerAlive(client), speech);
   
  return Plugin_Continue;
}

public Action:UserMessageHook(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init) 
{
  new String:szBuffer[400];
  new sendingClient = BfReadByte(bf);
  
  if(sendingClient == 0) 
    return Plugin_Continue;
  
  new healthVal = GetEntProp(sendingClient, Prop_Send, "m_iHealth");
  while (BfGetNumBytesLeft(bf) > 0)
  {
      Format(szBuffer, sizeof(szBuffer), "%s %d", szBuffer, BfReadByte(bf));
  }
  
  LogToFile(g_slogFile, "[VCHAT] %N (%d) T: %d HP: %d Msg: %s", sendingClient, TF2_GetPlayerClass(sendingClient), GetClientTeam(sendingClient), healthVal, szBuffer);
  
  return Plugin_Continue;
}


//////////////////////////////////////////////////////////////////////////////
//Map Events
//////////////////////////////////////////////////////////////////////////////
public Action:teamplay_round_start(Handle:event,  const String:name[], bool:dontBroadcast) {  
  LogToFile(g_slogFile, "[ROUND START] Players: %d / %d", GetClientCount(), MaxClients);
}

public Action:teamplay_round_win(Handle:event,  const String:name[], bool:dontBroadcast) {
  LogToFile(g_slogFile, "[ROUND WIN] Winner: %d. WinReason: %d. Time: %f. Points (players): Red (%d) = %d | Blue (%d) = %d", GetEventInt(event, "team"), GetEventInt(event, "winreason"), GetEventFloat(event, "round_time"), GetTeamClientCount(TEAM_RED), GetTeamScore(TEAM_RED), GetTeamClientCount(TEAM_BLUE), GetTeamScore(TEAM_BLUE));
}


//////////////////////////////////////////////////////////////////////////////
//Client Events
//////////////////////////////////////////////////////////////////////////////

public Action:player_death(Handle:event,  const String:name[], bool:dontBroadcast) {

  new victim = GetClientOfUserId(GetEventInt(event, "userid"));
  new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  new assister = GetClientOfUserId(GetEventInt(event, "assister"));
  
  if(victim == attacker || attacker == 0)
  {
    LogToFile(g_slogFile, "[DEATH] V: %N (%d) A: %N Wep: SUICIDE", victim, TF2_GetPlayerClass(victim), victim);
    return Plugin_Continue;
  }
  
  decl String:weaponName[256+1];
  GetEventString(event, "weapon_logclassname", weaponName, sizeof(weaponName));
  
  new healthVal = GetEntProp(attacker, Prop_Send, "m_iHealth");
  
  new attackerTeam = GetClientTeam(attacker);
  
  if(assister != 0)
  {
    LogToFile(g_slogFile, "[DEATH] V: %N (%d) A: %N (%d) Wep: %s T: %d HP: %d As: %N (%d)", victim, TF2_GetPlayerClass(victim), attacker, TF2_GetPlayerClass(attacker), weaponName, attackerTeam, healthVal, assister, TF2_GetPlayerClass(assister));
  }
  else
  {
    LogToFile(g_slogFile, "[DEATH] V: %N (%d) A: %N (%d) Wep: %s T: %d HP: %d", victim, TF2_GetPlayerClass(victim), attacker, TF2_GetPlayerClass(attacker), weaponName, attackerTeam, healthVal);
  }
  
  return Plugin_Continue;
}

public Action:player_changeclass(Handle:event,  const String:name[], bool:dontBroadcast) {

  //Get the user
  new client = GetClientOfUserId(GetEventInt(event, "userid"));
  
  //Get what class they are trying to be
  new TFClassType:class = TFClassType:GetEventInt(event, "class");
  
  LogToFile(g_slogFile, "[CLASSCHNG] %N T: %d Cl: %d", client, GetClientTeam(client), class);
  
  return Plugin_Continue;
}
