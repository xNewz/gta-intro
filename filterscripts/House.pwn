//�к������ �ͧ Ez for ME
//�ŧ�� ��  �Ѻ�� �Թ�ѧ & ���
//�к����������Ѻ 0.3E - 0.3.8 ��Ẻ TXT
#include <a_samp>
#include <Dini>

//------------------------------------------------------------------------------

#define MAX_HOUSES 1000

//------------------------------------------------------------------------------

#define DIALOG_HOPTIONS 1500
#define DIALOG_PRICE 1501
#define DIALOG_INTERIOR 1502
#define DIALOG_SAVE 1503
#define DIALOG_REMOVEID 1504

//------------------------------------------------------------------------------

enum hInfo
{
	hPrice,
	hInterior,
	hNumber,
	hLocked,
	hOwned,
	hPick,
	hWorld,
	hOwner[MAX_PLAYER_NAME],
	Text3D:hLabel,
	Float:hX,
	Float:hY,
	Float:hZ,
}

//------------------------------------------------------------------------------

new HouseInfo[MAX_HOUSES][hInfo];
new houseid, InHouse[MAX_PLAYERS][MAX_HOUSES];

//------------------------------------------------------------------------------

if(strcmp(cmd, "/chouse", true) == 0)
{
    if (PlayerInfo[playerid][pAdmin] >= 1)//���������ʹ� ʤԻ ��Ф�Ѻ
	{
		ShowPlayerDialog(playerid, DIALOG_HOPTIONS, DIALOG_STYLE_MSGBOX, "House options", "{FFFFFF}�ҤҺ�ҹ", "���ҧ", "ź");
		return 1;
  	}
}

//------------------------------------------------------------------------------

if(strcmp(cmd, "/buyhouse", true) == 0)
{
	new name[MAX_PLAYER_NAME], Float:X, Float:Y, Float:Z, World, labelstring[144], string[144], file[50];
	World = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerName(playerid, name, sizeof(name));
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))
		{
			if(HouseInfo[i][hOwned] == 1) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ��ѧ����ռ���������");
			if(GetPlayerMoney(playerid) < HouseInfo[i][hPrice]) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}�س������Թ���ͷ��Ы��ͺ�ҹ��ѧ���");
			format(labelstring, sizeof(string), "{15FF00}��Ңͧ: {FFFFFF}%s\n{15FF00}�Ҥ�: {FFFFFF}%d", name, HouseInfo[i][hPrice]);
			DestroyPickup(HouseInfo[i][hPick]);
			HouseInfo[i][hPick] = CreatePickup(1272, 1, X, Y, Z, World);
			Update3DTextLabelText(HouseInfo[i][hLabel], 0xFFFFFFFF, labelstring);
			HouseInfo[i][hOwner] = name;
			HouseInfo[i][hOwned] = 1;
			format(string, sizeof(string), "{FF0000}[HOUSE]: {FFFFFF}�س���ͺ�ҹ����: {FF0000}%d {FFFFFF}����Ѻ {FF0000}$ %d", i, HouseInfo[i][hPrice]);
			SendClientMessage(playerid, -1, string);
			format(file, sizeof(file), "Houses/%d.ini", i);//��� save ��ҹ
			GivePlayerMoney(playerid, -HouseInfo[i][hPrice]);
			if(fexist(file))
			{
				dini_IntSet(file, "Owned", 1);
				dini_Set(file, "Owner", name);
			}
		}
	}
	return 1;
}

//------------------------------------------------------------------------------
if(strcmp(cmd, "/sellhouse", true) == 0)
{
	new name[MAX_PLAYER_NAME], Float:X, Float:Y, Float:Z, World, labelstring[144], string[144], file[50];
	World = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerName(playerid, name, sizeof(name));
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))
		{
			if(HouseInfo[i][hOwned] == 0) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ����ѧ�������Ңͧ");
			if(strcmp(name, HouseInfo[i][hOwner], true)) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ���������繢ͧ�س");
			DestroyPickup(HouseInfo[i][hPick]);
			HouseInfo[i][hPick] = CreatePickup(1273, 1, X, Y, Z, World);
			format(labelstring, sizeof(labelstring), "{15FF00}House ID: {FFFFFF}%d\n{15FF00}�Ҥ�: {FFFFFF}%i\n\n{15FF00}Type {FFFFFF}/BuyHouse {15FF00}���ͫ��ͺ�ҹ", i, HouseInfo[i][hPrice]);
			Update3DTextLabelText(HouseInfo[i][hLabel], 0xFFFFFFFF, labelstring);
			HouseInfo[i][hOwned] = 0;
			HouseInfo[i][hOwner] = 0;
			format(string, sizeof(string), "{FF0000}[HOUSE]: {FFFFFF}�س��º�ҹ����: {FF0000}%d", i);
			SendClientMessage(playerid, -1, string);
			format(file, sizeof(file), "Houses/%d.ini", i);
			if(fexist(file))
			{
				dini_IntSet(file, "Owned", 0);
				dini_IntSet(file, "Owner", 0);
			}
		}
	}
	return 1;
}

//------------------------------------------------------------------------------

if(strcmp(cmd, "/enter", true) == 0)//��Һ�ҹ
{
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))
		{
			if(HouseInfo[i][hOwned] == 0) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ����������Ңͧ");
			if(HouseInfo[i][hLocked] == 1) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ�����͡");
			if(HouseInfo[i][hNumber] == 1000)
			{
                SetPlayerPos(playerid, 243.9951,304.9418,999.1484);
                SetPlayerFacingAngle(playerid, 267.0980);
                SetCameraBehindPlayer(playerid);
                SetPlayerInterior(playerid, 1);
			}
			if(HouseInfo[i][hNumber] == 2000)
			{
                SetPlayerPos(playerid, 2259.6702,-1135.8542,1050.6328);
                SetPlayerFacingAngle(playerid, 267.3974);
                SetCameraBehindPlayer(playerid);
                SetPlayerInterior(playerid, 10);
			}
			if(HouseInfo[i][hNumber] == 3000)
			{
                SetPlayerPos(playerid, 2308.8254,-1212.8070,1049.0234);
                SetPlayerFacingAngle(playerid, 359.8550);
                SetCameraBehindPlayer(playerid);
                SetPlayerInterior(playerid, 6);
			}
            if(HouseInfo[i][hNumber] == 4000)
			{
                SetPlayerPos(playerid, 260.7436,1237.5563,1084.2578);
                SetPlayerFacingAngle(playerid, 1.6415);
                SetCameraBehindPlayer(playerid);
                SetPlayerInterior(playerid, 9);
			}
			if(HouseInfo[i][hNumber] == 5000)
			{
                SetPlayerPos(playerid, -42.5742,1405.6521,1084.4297);
                SetPlayerFacingAngle(playerid, 359.1347);
                SetCameraBehindPlayer(playerid);
                SetPlayerInterior(playerid, 8);
			}
			InHouse[playerid][i] = 1;
			SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}�س����Һ�ҹ���º��������");
		}
	}
	return 1;
}

//------------------------------------------------------------------------------

if(strcmp(cmd, "/exit", true) == 0)//�͡��ҹ
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(InHouse[playerid][i] == 0) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}�س���������㹺�ҹ");
		SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
		SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}�س�͡�ҡ��ҹ���º��������");
	}
	return 1;
}

//------------------------------------------------------------------------------
if(strcmp(cmd, "/lock", true) == 0)//��͡��ҹ
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	for(new i = 0; i < MAX_HOUSES; i++)
	{
        if(strcmp(name, HouseInfo[i][hOwner], true)) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ���������繢ͧ�س");
        if(HouseInfo[i][hLocked] == 1) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ�ѹ�١��ͤ��������");
        HouseInfo[i][hLocked] = 1;
        SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}�س����͡����ҹ����");
	}
	return 1;
}

//------------------------------------------------------------------------------

if(strcmp(cmd, "/unlock", true) == 0)//�Դ��ҹ
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	for(new i = 0; i < MAX_HOUSES; i++)
	{
        if(strcmp(name, HouseInfo[i][hOwner], true)) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}��ҹ���������繢ͧ�س");
        if(HouseInfo[i][hLocked] == 0) return SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}�Ŵ��͡��ҹ����");
        HouseInfo[i][hLocked] = 0;
        SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}�س��Ŵ��͡����ҹ����");
	}
	return 1;
}

//------------------------------------------------------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_HOPTIONS)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_PRICE, DIALOG_STYLE_INPUT, "�Ҥ�", "{FFFFFF}�ô����ҤҺ�ҹ:", "Continue", "Back");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_REMOVEID, DIALOG_STYLE_INPUT, "ź��ҹ ID", "{FFFFFF}�ô��� ID ��ҹ����ź", "Continue", "Back");
		}
	}
	if(dialogid == DIALOG_PRICE)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_PRICE, DIALOG_STYLE_INPUT, "�Ҥ�", "{FFFFFF}�ô����ҤҺ�ҹ:", "Continue", "Back");
            SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}Price setted.");
			HouseInfo[houseid][hPrice] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_INTERIOR, DIALOG_STYLE_LIST, "Interior", "Interior #1\nInterior #2\nInterior #3\nInterior #4\nInterior #5", "Continue", "Back");
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_HOPTIONS, DIALOG_STYLE_MSGBOX, "House Interior", "{FFFFFF}�ô���͡ Int ��ҹ", "Create", "Remove");
		}
	}
	if(dialogid == DIALOG_INTERIOR)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new string[500];
				format(string, sizeof(string), "{FFFFFF}�س���������ҵ�ͧ��èкѹ�֡��ҹ���?\n\n{FF0000}House ID: {FFFFFF}%d\n{FF0000}House �Ҥ�: {FFFFFF}%d\n{FF0000}House Interior: {FFFFFF}Interior #1.", houseid, HouseInfo[houseid][hPrice]);
				ShowPlayerDialog(playerid, DIALOG_SAVE, DIALOG_STYLE_MSGBOX, "Save", string, "Yes", "No");
				SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��������{FF0000}Interior #1.");
				HouseInfo[houseid][hInterior] = 3;
				HouseInfo[houseid][hNumber] = 1000;

			}
			if(listitem == 1)
			{
                new string[500];
				format(string, sizeof(string), "{FFFFFF}�س���������ҵ�ͧ��èкѹ�֡��ҹ���?\n\n{FF0000}House ID: {FFFFFF}%d\n{FF0000}House �Ҥ�: {FFFFFF}%d\n{FF0000}House Interior: {FFFFFF}Interior #2.", houseid, HouseInfo[houseid][hPrice]);
				SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��������{FF0000}Interior #2.");
				ShowPlayerDialog(playerid, DIALOG_SAVE, DIALOG_STYLE_MSGBOX, "Save", string, "Yes", "No");
				HouseInfo[houseid][hInterior] = 3;
				HouseInfo[houseid][hNumber] = 2000;
			}
			if(listitem == 3)
			{
                new string[500];
				format(string, sizeof(string), "{FFFFFF}�س���������ҵ�ͧ��èкѹ�֡��ҹ���?\n\n{FF0000}House ID: {FFFFFF}%d\n{FF0000}House �Ҥ�: {FFFFFF}%d\n{FF0000}House Interior: {FFFFFF}Interior #3", houseid, HouseInfo[houseid][hPrice]);
				SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��������{FF0000}Interior #3.");
				ShowPlayerDialog(playerid, DIALOG_SAVE, DIALOG_STYLE_MSGBOX, "Save", string, "Yes", "No");
				HouseInfo[houseid][hInterior] = 2;
				HouseInfo[houseid][hNumber] = 3000;
			}
			if(listitem == 4)
			{
                new string[500];
				format(string, sizeof(string), "{FFFFFF}�س���������ҵ�ͧ��èкѹ�֡��ҹ���?\n\n{FF0000}House ID: {FFFFFF}%d\n{FF0000}House �Ҥ�: {FFFFFF}%d\n{FF0000}House Interior: {FFFFFF}Interior #4", houseid, HouseInfo[houseid][hPrice]);
				SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��������{FF0000}Interior #4.");
				ShowPlayerDialog(playerid, DIALOG_SAVE, DIALOG_STYLE_MSGBOX, "Save", string, "Yes", "No");
				HouseInfo[houseid][hInterior] = 2;
				HouseInfo[houseid][hNumber] = 4000;
			}
			if(listitem == 5)
			{
                new string[500];
				format(string, sizeof(string), "{FFFFFF}�س���������ҵ�ͧ��èкѹ�֡��ҹ���?\n\n{FF0000}House ID: {FFFFFF}%d\n{FF0000}House �Ҥ�: {FFFFFF}%d\n{FF0000}House Interior: {FFFFFF}Interior #5.", houseid, HouseInfo[houseid][hPrice]);
				SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��������{FF0000}Interior #5.");
				ShowPlayerDialog(playerid, DIALOG_SAVE, DIALOG_STYLE_MSGBOX, "Save", string, "Yes", "No");
				HouseInfo[houseid][hInterior] = 5;
				HouseInfo[houseid][hNumber] = 5000;
			}
		}
		else
		{
	    	ShowPlayerDialog(playerid, DIALOG_PRICE, DIALOG_STYLE_INPUT, "�Ҥ�", "{FFFFFF}�ô����ҤҺ�ҹ:", "Continue", "Back");
		}
	}
	if(dialogid == DIALOG_SAVE)
	{
		if(response)
		{
			new Float:X, Float:Y, Float:Z, World, string[144], labelstring[144], file[50];
			World = GetPlayerVirtualWorld(playerid);
			format(string, sizeof(string), "{FF0000}[HOUSE]: {FFFFFF}House ID: {FF0000}%d {FFFFFF}��ҹ�١���ҧ��������", houseid);
			format(labelstring, sizeof(labelstring), "{15FF00}House ID: {FFFFFF}%d\n{15FF00}�Ҥ�: {FFFFFF}%i\n\n{15FF00}Type {FFFFFF}/BuyHouse {15FF00}���ͫ��ͺ�ҹ", houseid, HouseInfo[houseid][hPrice]);
			SendClientMessage(playerid, -1, string);
			GetPlayerPos(playerid, X, Y, Z);
			HouseInfo[houseid][hX] = X;
			HouseInfo[houseid][hY] = Y;
			HouseInfo[houseid][hZ] = Z;
			HouseInfo[houseid][hPick] = CreatePickup(1273, 1, X, Y, Z, World);
			HouseInfo[houseid][hLabel] = Create3DTextLabel(labelstring, 0xFFFFFFFF, X, Y, Z, 25.0, 0, 0);
			format(file, sizeof(file), "Houses/%d.ini", houseid);
			if(!fexist(file))
			{
				dini_Create(file);
				dini_IntSet(file, "Price", HouseInfo[houseid][hPrice]);
				dini_IntSet(file, "Interior", HouseInfo[houseid][hInterior]);
				dini_IntSet(file, "Owned", 0);
				dini_FloatSet(file, "Position X", X);
				dini_FloatSet(file, "Position Y", Y);
				dini_FloatSet(file, "Position Z", Z);
		    }
		    houseid++;
		}
		else
		{
			SendClientMessage(playerid, -1, "{FF0000}[HOUSE]: {FFFFFF}��ҹ�س�١����");
		}
	}
	if(dialogid == DIALOG_REMOVEID)
	{
		if(response)
		{
			new hID, file[50], string[100];
			hID = strval(inputtext);
			format(file, sizeof(file), "Houses/%d.ini", hID);
			if(!fexist(file))
			{
                SendClientMessage(playerid, -1, "{FF0000}ERROR: {FFFFFF}���ʺ�ҹ������������㹰ҹ������");
			}
			else
			{
				HouseInfo[hID][hPrice] = 0;
				HouseInfo[hID][hLocked] = 0;
				HouseInfo[hID][hOwned] = 0;
				HouseInfo[hID][hOwner] = 0;
				HouseInfo[hID][hX] = 0;
				HouseInfo[hID][hY] = 0;
				HouseInfo[hID][hZ] = 0;
				DestroyPickup(HouseInfo[hID][hPick]);
				Update3DTextLabelText(HouseInfo[hID][hLabel], 0xFFFFFFFF, " ");
				format(string, sizeof(string), "{FF0000}[HOUSE]: {FFFFFF}House ID: {FF0000}%d {FFFFFF}��ҹⴹź����");
				SendClientMessage(playerid, -1, string);
				dini_Remove(file);
			}
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_HOPTIONS, DIALOG_STYLE_MSGBOX, "House options", "{FFFFFF}�ô���͡������͡�ͧ�س", "Create", "Remove");
		}
	}
	return 1;
}

//------------------------------------------------------------------------------

public OnFilterScriptInit()
{
	LoadHouses();
	return 1;
}

//------------------------------------------------------------------------------

stock LoadHouses()
{
	new file[50], labelstring[144], stringlabel[144];
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		format(file, sizeof(file), "Houses/%d.ini", i);
		if(fexist(file))
		{
			HouseInfo[i][hPrice] = dini_Int(file, "Price");
			HouseInfo[i][hInterior] = dini_Int(file, "Interior");
			HouseInfo[i][hOwned] = dini_Int(file, "Owned");
			HouseInfo[i][hX] = dini_Float(file, "Position X");
			HouseInfo[i][hY] = dini_Float(file, "Position Y");
			HouseInfo[i][hZ] = dini_Float(file, "Position Z");
			strmid(HouseInfo[i][hOwner], dini_Get(file, "Owner"), false, strlen(dini_Get(file, "Owner")), MAX_PLAYER_NAME);
			format(labelstring, sizeof(labelstring), "{15FF00}House ID: {FFFFFF}%d\n{15FF00}�Ҥ�: {FFFFFF}%i\n\n{15FF00}Type {FFFFFF}/BuyHouse {15FF00}���ͫ��ͺ�ҹ", i, HouseInfo[i][hPrice]);
			format(stringlabel, sizeof(stringlabel), "{15FF00}House ID: {FFFFFF}%d\n\n{15FF00}�Ҥ�: {FFFFFF}%i\n{15FF00}��Ңͧ: {FFFFFF}%s", i, HouseInfo[i][hPrice], HouseInfo[i][hOwner]);
            if(HouseInfo[i][hOwned] == 0)
			{
				HouseInfo[i][hPick] = CreatePickup(1273, 1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 0);
				HouseInfo[i][hLabel] = Create3DTextLabel(labelstring, 0xFFFFFFFF, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 25.0, 0, 0);
			}
			else if(HouseInfo[i][hOwned] == 1)
			{
			    HouseInfo[i][hPick] = CreatePickup(1272, 1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 0);
				HouseInfo[i][hLabel] = Create3DTextLabel(stringlabel, 0xFFFFFFFF, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 25.0, 0, 0);
			}
			houseid++;
		}
	}
	printf("LOADED HOUSES: %d", houseid);
	return 1;
}

//------------------------------------------------------------------------------
