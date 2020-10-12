//=============================================================================
// Ammo_G28Grenades.
//
// Ammo for the G28
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class Ammo_G28Grenades extends BallisticAmmo;

defaultproperties
{
     MaxAmmo=9
     InitialAmount=3
     IconFlashMaterial=Shader'BWBP_SKC_Tex.G28.AmmoIcon_MedFlash'
     PickupClass=Class'BWBP_SKC_Fix.G28Pickup'
     IconMaterial=Texture'BWBP_SKC_Tex.G28.AmmoIcon_Med'
     IconCoords=(X2=64,Y2=64)
     ItemName="G28 Medicinal Aerosol Ammo"
}
