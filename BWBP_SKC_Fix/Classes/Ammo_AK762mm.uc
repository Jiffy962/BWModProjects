//=============================================================================
// Ammo_AK762mm.
//
// 7.62mm SOVIET BULLETS. USED IN THE ONLY SOVIET GUN THAT MATTERS
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class Ammo_AK762mm extends BallisticAmmo;

defaultproperties
{
     MaxAmmo=160
     InitialAmount=40
     bTryHeadShot=True
     IconFlashMaterial=Shader'BWBP_SKC_TexExp.AK490.AmmoIcon_AK490Flash'
     PickupClass=Class'BWBP_SKC_Fix.AP_AK490Mag'
     IconMaterial=Texture'BWBP_SKC_TexExp.AK490.AmmoIcon_AK490'
     IconCoords=(X2=64,Y2=64)
     ItemName="7.62 AP Rifle Rounds"
}
