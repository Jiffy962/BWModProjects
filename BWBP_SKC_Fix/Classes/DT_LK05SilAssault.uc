//=============================================================================
// DT_LK05SilAssault.
//
// DamageType for the _LK05 that is sulenced. DETH MASSAGES
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_LK05SilAssault extends DT_BWBullet;

defaultproperties
{
     DeathStrings(0)="%k quietly eliminated %o with the LK05."
     DeathStrings(1)="%o was silenced by %k's LK05 rounds."
     DeathStrings(2)="%k assasinated %o with a suppressed LK05."
     DeathStrings(3)="%o was silently downed by %k's LK05."
     WeaponClass=Class'BWBP_SKC_Fix.LK05Carbine'
     DeathString="%k quietly eliminated %o with the LK05."
     FemaleSuicide="%o is quite horrible with firearms."
     MaleSuicide="%o is quite horrible with firearms."
     bFastInstantHit=True
     GibPerterbation=0.100000
     KDamageImpulse=3000.000000
     VehicleDamageScaling=0.500000
}
