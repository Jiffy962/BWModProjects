//=============================================================================
// DT_MARSAssault.
//
// DamageType for the MASR assault rifle primary fire
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_MARSAssault extends DT_BWBullet;

defaultproperties
{
     DeathStrings(0)="%k's MARS-2 riddled %o with bulletholes."
     DeathStrings(1)="%o failed to clear %k's MARS crosshairs."
     DeathStrings(2)="%k savagely lit %o up with MARS-2 fire."
     DeathStrings(3)="%k terminated %o with an accurate MARS burst."
     WeaponClass=Class'BWBP_SKC_Fix.MarsAssaultRifle'
     DeathString="%k's MARS-2 riddled %o with bulletholes."
     FemaleSuicide="%o tactically missed with the planet Mars."
     MaleSuicide="%o tactically missed with a Mars bar."
     bFastInstantHit=True
     GibPerterbation=0.100000
     KDamageImpulse=3000.000000
     VehicleDamageScaling=0.650000
}
