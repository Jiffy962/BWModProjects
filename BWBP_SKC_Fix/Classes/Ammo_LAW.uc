//=============================================================================
// Ammo_LAW.
//
// Ammo for the LAW Launcher. Fires T70B1 Nuclear Shockwave rockets
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class Ammo_LAW extends BallisticAmmo;

defaultproperties
{
     MaxAmmo=3
     InitialAmount=1
     IconFlashMaterial=Shader'BWBP_SKC_TexExp.LAW.AmmoIcon_LAWFlash'
     PickupClass=Class'BWBP_SKC_Fix.AP_LAWTube'
     IconMaterial=Texture'BWBP_SKC_TexExp.LAW.AmmoIcon_LAW'
     IconCoords=(X1=128,Y1=64,X2=191,Y2=127)
}
