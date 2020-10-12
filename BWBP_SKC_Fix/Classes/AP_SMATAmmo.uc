//=============================================================================
// AP_SMATAmmo.
//
// 2 loose rockets for the SMAT
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class AP_SMATAmmo extends BallisticAmmoPickup;

defaultproperties
{
     AmmoAmount=2
     InventoryType=Class'BWBP_SKC_Fix.Ammo_SMAT'
     PickupMessage="You picked up 2 HV Flak 16 Rockets"
     PickupSound=Sound'BallisticSounds2.Ammo.RocketPickup'
     StaticMesh=StaticMesh'BallisticHardware2.Ammo.G5Rockets'
     DrawScale=0.750000
     Skins(0)=Texture'BWBP_SKC_Tex.SMAA.SMAARocket'
     CollisionRadius=8.000000
     CollisionHeight=5.000000
}
