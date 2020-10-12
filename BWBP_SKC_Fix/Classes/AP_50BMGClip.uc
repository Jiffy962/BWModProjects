//=============================================================================
// X82clip.
//
// 2 x 4 round clip for the X82.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class AP_50BMGClip extends BallisticAmmoPickup;

defaultproperties
{
     AmmoAmount=8
     InventoryType=Class'BWBP_SKC_Fix.Ammo_50BMG'
     PickupMessage="You got 8 .50 N6-BMG HEAP rounds for the X-83."
     PickupSound=Sound'BallisticSounds2.Ammo.ClipPickup'
     StaticMesh=StaticMesh'BWBP_SKC_Static.X83.X82A2Mag'
     PrePivot=(Z=13.000000)
     CollisionRadius=8.000000
     CollisionHeight=10.000000
}
