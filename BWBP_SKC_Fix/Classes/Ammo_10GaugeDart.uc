//=============================================================================
// Ammo_10GaugeDart.
//
// 10 Gauge Flechette shotgun ammo. Used by Mk781
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class Ammo_10GaugeDart extends BallisticAmmo;

defaultproperties
{
     MaxAmmo=36
     InitialAmount=18
     IconFlashMaterial=Shader'BallisticUI2.Icons.AmmoIcon_12GaugeFlash'
     PickupClass=Class'BWBP_SKC_Fix.AP_10GaugeDartBox'
     IconMaterial=Texture'BWBP_SKC_TexExp.M1014.AmmoIcon_10GaugeDartBox'
     IconCoords=(X2=63,Y2=63)
     ItemName="10 Gauge Flechette Shells"
}
