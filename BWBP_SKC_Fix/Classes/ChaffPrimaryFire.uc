//=============================================================================
// ChaffPrimaryFire.
//
// MOA-C Chaff Grenade thrown overhand
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class ChaffPrimaryFire extends BallisticGrenadeFire;


function PlayPreFire()
{
	Weapon.SetBoneScale (0, 1.0, ChaffGrenadeWeapon(Weapon).GrenadeBone);
	Weapon.SetBoneScale (1, 1.0, ChaffGrenadeWeapon(Weapon).GrenadeBone2);
	if (ChaffGrenadeWeapon(Weapon).bPrimed)
		Weapon.PlayAnim(NoClipPreFireAnim, PreFireAnimRate, TweenTime);
	else
		Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);
	ChaffGrenadeWeapon(Weapon).bPrimed = false;
}

defaultproperties
{
     NoClipPreFireAnim="PrepThrowPrimed"
     SpawnOffset=(X=25.000000,Y=10.000000,Z=2.000000)
     BrassOffset=(X=10.000000)
     BallisticFireSound=(Sound=Sound'BallisticSounds2.NRP57.NRP57-Throw',Radius=32.000000,bAtten=True)
     PreFireAnim="PrepThrow"
     FireAnim="Throw"
     AmmoClass=Class'BWBP_SKC_Fix.Ammo_Chaff'
     FireRate=2
     ShakeRotMag=(X=32.000000,Y=8.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=1.500000
     ShakeOffsetMag=(X=-3.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=1.500000
     ProjectileClass=Class'BWBP_SKC_Fix.ChaffGrenade'
}
