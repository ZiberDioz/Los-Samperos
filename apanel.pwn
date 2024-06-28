//Dialogs
#DIALOG_AP_1 	//Clicked is ME!
#DIALOG_AP_2    //Seleccionar AdminPanel Corto o Largo

//OnPlayerClickPlayer
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(Info[playerid][pAdmin] == 0) return 1;
	if(playerid == clickedplayerid) ShowPlayerDialog(playerid, DIALOG_AP_1, DIALOG_STYLE_LIST, "{DF013A}• Selecciona:", "{DF013A}• {FFFFFF}Admin Duty\n{DF013A}• {FFFFFF}Modo Dios", "Seleccionar", "Cancelar");
	else
	{
	    SetPVarInt(playerid, "clickedidAP", clickedplayerid);
		ShowPlayerDialog(playerid, DIALOG_AP_2, DIALOG_STYLE_MSGBOX, "{DF013A}• Selecciona:", "{DF013A}• {FFFFFF}Selecciona que AdminPanel utilizarás:", "Básico", "Avanzado");
	}
	return 1;
}

//OnDialogResponse
		new clickedid = GetPVarInt(playerid, "clickedidAP");
		case DIALOG_AP_1:
		{
			if(!response)return 1;
			switch(listitem)
			{
			    case 0:
			    {
			        if(!strcmp(Info[playerid][pAdminName], "(null)", true)) return SendClientMessageEx(playerid, COLOR_GREY, "* No puedes administrar porque aún no han configurado tu nombre administrativo. Contácta a un administrador de rango mayor.");
					switch(Info[playerid][pAdminDuty])
					{
						case 0:
						{
			    			Info[playerid][pTempName] = 1;
			    			Info[playerid][pAdminDuty] = 1;
							GetPlayerHealth(playerid, Info[playerid][pHealth]);
							GetPlayerArmour(playerid, Info[playerid][pArmour]);
							SetPlayerName(playerid, Info[playerid][pAdminName]);
							SetPlayerHealth(playerid, 500000.0);
     						SetPlayerArmour(playerid, 500000.0);
							switch(Info[playerid][pSex])
							{
				    			case    1: SetPlayerSkin(playerid,217);
				    			case    2: SetPlayerSkin(playerid,211);
							}
							format(szMessage, sizeof(szMessage), ""COL_BLUE"Administración >"COL_WHITE" {FFFFFF}Admin %s (ID: %d) está ahora en servicio.", GetPlayerNameEx(playerid), playerid);
						}
						case 1:
						{
							Info[playerid][pTempName] = 0;
			    			Info[playerid][pAdminDuty] = 0;
							SetPlayerName(playerid, Info[playerid][pNormalName]);
							SetPlayerHealth(playerid, Info[playerid][pHealth]);
							SetPlayerArmour(playerid, Info[playerid][pArmour]);
							SetPlayerSkin(playerid,Info[playerid][pChar]);
							SetPlayerColor(playerid,TEAM_HIT_COLOR);
							format(szMessage, sizeof(szMessage), ""COL_BLUE"Administración >"COL_WHITE" {FFFFFF}Admin %s (ID: %d) ahora ya no está en servicio.", GetPlayerNameEx(playerid), playerid);
						}
					}
					SendAdminMessage(COLOR_GENERAL, szMessage);
			    }
			    case 1:
			    {
			        SetHP(playerid, INFINITY_HEALTH);
	    			GiveArmorToPlayer(playerid, 100000);
			    }
			}
		}
		case DIALOG_AP_2:
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            switch(Info[playerid][pAdmin])
		            {
		                case 1: ShowShortAdminPanel(playerid, 1);
						case 2: ShowShortAdminPanel(playerid, 2);
						case 3: ShowShortAdminPanel(playerid, 3);
						case 4: ShowShortAdminPanel(playerid, 4);
						case 5,6,7,8: ShowShortAdminPanel(playerid, 5);
					}
		        }
		        case 1:
		        {
		            switch(Info[playerid][pAdmin])
		            {
		                case 1: NoAutorizado
		                case 2: ShowLongAdminPanel(playerid, 2);
		                case 3: ShowLongAdminPanel(playerid, 3);
		                case 4: ShowLongAdminPanel(playerid, 4);
		                case 5,6,7,8: ShowLongAdminPanel(playerid, 5);
					}
		        }
			}
		}
		case DIALOG_AP_3:
		{
		    if(!response)return 1;
			switch(listitem)
			{
			    case 0:
			    {
			        SetPVarInt(playerid, "AdminPanelFix", 1);
			        ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_INPUT, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Ingresa la razón del Kick.", "Kickear", "");
			    }
			    case 1:
			    {
			        SetPVarInt(playerid, "AdminPanelFix", 2);
			        ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_INPUT, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Ingresa la razón del Jail.", "Aceptar", "");
			    }
			    case 2:
			    {
			        if(GetPVarInt(clickedid, "IsFrozen") == 1)
			        {
			            DeletePVar(clickedid, "IsFrozen");
						TogglePlayerControllable(clickedid, 1);
						format(string, sizeof(string), ""COL_BLUE"Administración >"COL_WHITE" %s fue descongelado por %s.",GetPlayerNameEx(clickedid),GetPlayerNameEx(playerid));
						ABroadCast(COLOR_GENERAL,string,1);
					}
					else
					{
					    TogglePlayerControllable(clickedid, 0);
						SetPVarInt(clickedid, "IsFrozen", 1);
						format(string, sizeof(string), ""COL_BLUE"Administración >"COL_WHITE" %s fue congelado por %s",GetPlayerNameEx(clickedid),GetPlayerNameEx(playerid));
						return ABroadCast(COLOR_GENERAL,string,1);
					}
				}
				case 3:
				{
				    if(GetPVarInt(clickedid, "Injured") != 1) return SendClientMessageEx(playerid, COLOR_GREY, "* Ese jugador no está herido!");
					format(szMessage, sizeof(szMessage), " Has revivido a %s.", GetPlayerNameEx(clickedid));
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					SendClientMessageEx(clickedid, COLOR_WHITE, "Fuiste revivido por un administrador y se te devolvio las armas.");
					format(szMessage, sizeof(szMessage),"AdmCmdExe: %s a revivido al usuario %s.", GetPlayerNameEx(playerid),GetPlayerNameEx(clickedid));
					ABroadCast(COLOR_GENERAL, szMessage, 1);
					KillEMSQueue(clickedid);
					ClearAnimations(clickedid);
					SetPlayerWeapons(clickedid);
					SetHP(clickedid, 100);
				}
				case 4: ShowStats(playerid,clickedid);
				case 5:
				{
				    if(Info[playerid][pSpectating] == -1)
					{
						GetPlayerPos(playerid, Info[playerid][pPos_x], Info[playerid][pPos_y], Info[playerid][pPos_z]);
						Info[playerid][pInt] = GetPlayerInterior(playerid);
						Info[playerid][pVW] = GetPlayerVirtualWorld(playerid);
						Info[playerid][pChar] = GetPlayerSkin(playerid);
		    		}
		    		SendClientMessage(playerid, COLOR_GREY, "* Para dejar de spectear presiona la tecla N.");
		    		Info[playerid][pSpectating] = userID;
		    		TogglePlayerSpectating(playerid, true);
					SetPlayerInterior(playerid, GetPlayerInterior(userID));
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userID));
		    		if(IsPlayerInAnyVehicle(userID)) { PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userID)); }
		    		else { PlayerSpectatePlayer(playerid, userID); }
					if(TutStep[userID] >= 1) SendClientMessageEx(playerid, COLOR_WHITE, "NOTA: Este jugador está en el tutorial, no considerar que usa Teleport Hack.");
				}
				case 6:
				{
					format(szMessage, sizeof(szMessage), ""COL_BLUE"Administración >"COL_WHITE" %s a enviado a %s [ID: %d] a Los Santos", GetPlayerNameEx(playerid), GetPlayerNameEx(clickedid), clickedid);
					ABroadCast(COLOR_GRAD1,szMessage,2);
					SendClientMessageEx(clickedid, COLOR_WHITE, " Fuiste teleportado!");
					SetPlayerPos(clickedid, 1529.6,-1691.2,13.3);
					SetPlayerVirtualWorld(clickedid, 0);
					SetPlayerInterior(clickedid, 0);
					Info[clickedid][pInt] = 0;
					Info[clickedid][pVW] = 0;
				}
				case 7:
				{
				    SetPVarInt(playerid, "AdminPanelFix", 3);
				    ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_MSGBOX, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Selecciona lo que deseas hacer:", "Ir", "Traer");
				}
				case 8:
				{
				    new Float:sl[3];
					GetPlayerPos(clickedid, sl[0], sl[1], sl[2]);
					SetPlayerPos(clickedid, sl[0], sl[1], sl[2]+5);
					PlayerPlaySound(clickedid, 1130, sl[0], sl[1], sl[2]+5);
					format(szMessage, sizeof(szMessage), ""COL_BLUE"Administración >"COL_WHITE" %s golpeó a %s",GetPlayerNameEx(playerid),GetPlayerNameEx(clickedid));
					ABroadCast(COLOR_GENERAL,szMessage,2);
					return SendClientMessageEx(clickedid, COLOR_RED2, szMessage);
				}
				case 9:
				{
				    SetPVarInt(playerid, "AdminPanelFix", 4);
				    ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_MSGBOX, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Selecciona lo que deseas modificar:", "Interior", "VWorld");
				}
				case 10:
				{
				    SetPVarInt(playerid, "AdminPanelFix", 5);
				    ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_INPUT, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Indica a cuanto quieres setear el HP del jugador:", "Aceptar", "");
				}
				case 11:
				{
				    SetPVarInt(playerid, "AdminPanelFix", 6);
				    ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_INPUT, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Indica a cuanto quieres setear el chaleco del jugador:", "Aceptar", "");
				}
				case 12:
				{
				    SetPVarInt(playerid, "AdminPanelFix", 7);
				    ShowPlayerDialog(playerid, DIALOG_AP_5, DIALOG_STYLE_INPUT, "{DF013A}• {FFFFFF}AdminPanel", "{FFFFFF}Indica el skin que quieres darle al jugador:", "Aceptar", "");
				}
				
			}
		}
		
stock ShowLongAdminPanel(i, type)
{
	szMessage = "";
	switch(type)
	{
	    case 2:
	    {
	        strcat(szMessage, "• Restriccion de Armas\n• Canal Dudas\n• Canal de Anuncios\n• Ver Armas\n• Silenciar");
		    ShowPlayerDialog(i, DIALOG_AP_4, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
	    }
	    case 3:
	    {
	        strcat(szMessage, "• Restriccion de Armas\n• Canal Dudas\n• Canal de Anuncios\n• Ver Armas\n• Silenciar");
	        strcat(szMessage, "\n• Cambiar Acento\n• Desarmar\n• Forzar Muerte\n• Test de Rol\n• Canal de Reportes");
		    ShowPlayerDialog(i, DIALOG_AP_4, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
	    }
	    case 4:
	    {
	        strcat(szMessage, "• Restriccion de Armas\n• Canal Dudas\n• Canal de Anuncios\n• Ver Armas\n• Silenciar");
	        strcat(szMessage, "\n• Cambiar Acento\n• Desarmar\n• Forzar Muerte\n• Test de Rol\n• Canal de Reportes");
	        strcat(szMessage, "\n• Dar Objeto\n• Dar Fichas\n• Borrar Planta\n• Ver Toys\n• Ver IP");
		    ShowPlayerDialog(i, DIALOG_AP_4, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
	    }
	    case 5:
	    {
	        strcat(szMessage, "• Restriccion de Armas\n• Canal Dudas\n• Canal de Anuncios\n• Ver Armas\n• Silenciar");
	        strcat(szMessage, "\n• Cambiar Acento\n• Desarmar\n• Forzar Muerte\n• Test de Rol\n• Canal de Reportes");
	        strcat(szMessage, "\n• Dar Objeto\n• Dar Fichas\n• Borrar Planta\n• Ver Toys\n• Ver IP");
	        strcat(szMessage, "\n• Canal de Bugs\n• Divorcio");
		    ShowPlayerDialog(i, DIALOG_AP_4, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
	    }
	}
	return 1;
}
		
stock ShowShortAdminPanel(i,type)
{
	szMessage = "";
	switch(type)
	{
		case 1:
		{
		    strcat(szMessage, "• Kickear\n• Jail\n• Congelar/Descongelar\n• Revivir\n• Ver Cuenta");
		    ShowPlayerDialog(i, DIALOG_AP_3, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
		}
		case 2:
		{
		    strcat(szMessage, "• Kickear\n• Jail\n• Congelar/Descongelar\n• Revivir\n• Ver Cuenta");
		    strcat(szMessage, "\n• Spectear\n• Enviar a LS\n• Ir/Traer\n• Golpear\n• Dar INT/VW");
		    ShowPlayerDialog(i, DIALOG_AP_3, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
		}
		case 3:
		{
		    strcat(szMessage, "• Kickear\n• Jail\n• Congelar/Descongelar\n• Revivir\n• Ver Cuenta");
            strcat(szMessage, "\n• Spectear\n• Enviar a LS\n• Ir/Traer\n• Golpear\n• Dar INT/VW");
            strcat(szMessage, "\n• Dar Vida\n• Dar Chaleco\n• Dar Skin\n• Liberar de Jail\n• Banear");
			ShowPlayerDialog(i, DIALOG_AP_3, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
		}
		case 4:
		{
		    strcat(szMessage, "• Kickear\n• Jail\n• Congelar/Descongelar\n• Revivir\n• Ver Cuenta");
		    strcat(szMessage, "\n• Spectear\n• Enviar a LS\n• Ir/Traer\n• Golpear\n• Dar INT/VW");
            strcat(szMessage, "\n• Dar Vida\n• Dar Chaleco\n• Dar Skin\n• Liberar de Jail\n• Banear");
		    strcat(szMessage, "\n• Advertencia");
		    ShowPlayerDialog(i, DIALOG_AP_3, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
		}
		case 5:
		{
		    strcat(szMessage, "• Kickear\n• Jail\n• Congelar/Descongelar\n• Revivir\n• Ver Cuenta");
		    strcat(szMessage, "\n• Spectear\n• Enviar a LS\n• Ir/Traer\n• Golpear\n• Dar INT/VW");
            strcat(szMessage, "\n• Dar Vida\n• Dar Chaleco\n• Dar Skin\n• Liberar de Jail\n• Banear");
		    strcat(szMessage, "\n• Advertencia");
		    strcat(szMessage, "\n• Dinero\n• Armas");
		    ShowPlayerDialog(i, DIALOG_AP_3, DIALOG_STYLE_LIST, "{DF013A}• {FFFFFF}AdminPanel", szMessage, "Seleccionar", "Cancelar");
		}
	}
	return 1;
}
