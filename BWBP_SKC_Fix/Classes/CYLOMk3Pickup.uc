//=============================================================================
// M30A2Pickup.
//=============================================================================
class CYLOMk3Pickup extends BallisticWeaponPickup
	placeable;

#exec OBJ LOAD FILE=BallisticWeapons2.utx
#exec OBJ LOAD FILE=BWBP_SKC_Tex.utx
#exec OBJ LOAD FILE=BallisticEffects.utx
#exec OBJ LOAD FILE=BallisticHardware2.usx

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(Texture'BWBP_SKC_Tex.M30A2.M30A2-SA');
	Level.AddPrecacheMaterial(Texture'BWBP_SKC_Tex.M30A2.M30A2-SB');
	Level.AddPrecacheMaterial(Texture'BWBP_SKC_Tex.M30A2.M30A2-Laser');
	Level.AddPrecacheMaterial(Texture'BWBP_SKC_Tex.M30A2.M30A2-Gauss');
	Level.AddPrecacheMaterial(Texture'ONSstructureTextures.CoreGroup.Invisible');
}
simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.M900.M900Grenade');
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.M900.M900MuzzleFlash');
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.Brass.EmptyRifleRound');
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.Ammo.M50Magazine');
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.M50.M50PickupHi');
	Level.AddPrecacheStaticMesh(StaticMesh'BallisticHardware2.M50.M50PickupLo');
}

defaultproperties
{
     LowPolyStaticMesh=StaticMesh'BallisticHardware2.M50.M50PickupLo'
     InventoryType=Class'BWBP_SKC_Fix.CYLOMk3MachineGun'
     RespawnTime=20.000000
     PickupMessage="You picked up the CYLO Mk2 Assault Weapon"
     PickupSound=Sound'BallisticSounds2.M50.M50Putaway'
     StaticMesh=StaticMesh'BallisticHardware2.M50.M50PickupHi'
     Physics=PHYS_None
     DrawScale=0.350000
     CollisionHeight=4.000000
}
