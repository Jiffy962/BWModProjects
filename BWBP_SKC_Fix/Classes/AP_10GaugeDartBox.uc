//=============================================================================
// AP_10GaugeDartBox.
//
// A box of 18 10 gauge dartshotgun shells.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class AP_10GaugeDartBox extends BallisticAmmoPickup;


var   Pickup			M900Ammo;
var() class<Pickup>		M900AmmoClass;

event PostBeginPlay()
{
	local Vector S, V, HitLoc, HitNorm, E;
	local Actor T;
	local Rotator R;

	Super.PostBeginPlay();

	V = VRand()*64;
	V.Z = 0;
	S = Location;
	S.Z += M900AmmoClass.default.CollisionHeight - CollisionHeight;
	E.X = M900AmmoClass.default.CollisionRadius;
	E.Y = M900AmmoClass.default.CollisionRadius;
	E.Z = M900AmmoClass.default.CollisionHeight;

	T = Trace(HitLoc, HitNorm, S+V, S, false, E);
	if (T == None)
		HitLoc = S+V;

	R.Yaw = Rand(65536);
	M900Ammo = Spawn(M900AmmoClass,,,HitLoc, R);
}

simulated function Destroyed()
{
	if (M900Ammo != None)
		M900Ammo.Destroy();
	 super.Destroyed();
}


defaultproperties
{
     M900AmmoClass=Class'BWBP_SKC_Fix.AP_10GaugeZapBox'
     AmmoAmount=18
     InventoryType=Class'BWBP_SKC_Fix.Ammo_10GaugeDart'
     PickupMessage="You picked up 18 flechette shells for the Mk.781"
     PickupSound=Sound'BallisticSounds2.Ammo.ShotBoxPickup'
     StaticMesh=StaticMesh'BallisticHardware2.Ammo.M763ShellBox'
     DrawScale=0.300000
     CollisionRadius=8.000000
     CollisionHeight=4.500000
     Skins(0)=Texture'BWBP_SKC_TexExp.M1014.M1014ShellBox'
}
