//=============================================================================
// Ammo_Tranq.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class Ammo_Tranq extends BallisticAmmo;

defaultproperties
{
     MaxAmmo=100
     InitialAmount=20
     bTryHeadShot=True
     IconFlashMaterial=Shader'BallisticUI2.Icons.AmmoIconsFlashing'
     PickupClass=Class'BWBP_SKC_Fix.AP_Tranq'
     IconMaterial=Texture'BWBP_SKC_Tex.M30A2.AmmoIcon_M30A2'
     IconCoords=(X1=128,X2=191,Y2=63)
     ItemName="Tranquilizer Darts"
}
