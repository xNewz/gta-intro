/*
||||||||||||||||||||||||||||||||||||||||||||
||Hunger System by RedWolfX               ||
||Do not re-release without my permisson  ||
||Hunger bar is raising every 5 minutes   ||
||To test it, use /makemehungry!          ||
||Hope you will enjoy :)                  ||
||||||||||||||||||||||||||||||||||||||||||||
*/
#include <a_samp>
#include <progress>
#include <zcmd>
#define COLOR_WHITE 0xFFFFFFAA
new Hungry[MAX_PLAYERS];
new Bar:Hunger[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
forward HungerTimer();
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Simple Hunger System By RedWolfX");
	print("--------------------------------------\n");
	SetTimer("HungerTimer", 300000, true);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
    Hunger[playerid] = CreateProgressBar(549.00, 60.00, 57.50, 3.20, -16776961, 100.0);
    Hungry[playerid] = 0;
	return 1;
}

public HungerTimer()
{
    for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    Hungry[i] = Hungry[i] + 1;
		}
	}
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    DestroyProgressBar(Hunger[playerid]);
	return 1;
}

public OnPlayerUpdate(playerid)
{
    SetProgressBarValue(Hunger[playerid], Hungry[ playerid ] * 10.0);
    UpdateProgressBar(Hunger[playerid], playerid);
	return 1;
}

CMD:makemehungry(playerid,params[]) // You can delete this command - Its only for testing
{
	SendClientMessage(playerid, COLOR_WHITE, "**Your hunger bar has been raised to 6!**");
	Hungry[playerid] = 6;
	return 1;
}

CMD:eat(playerid,params[])
{
	if(Hungry[playerid] > 5)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "**You are no longer hungry!**");
	    Hungry[playerid] = 0;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "**You are not hungry**");
	}
	return 1;
}
