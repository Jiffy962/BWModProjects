//=============================================================================
// DTA49Skrith.
//
// Damage type for A49 projectiles
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DTA49Skrith extends DT_BWMiscDamage;

defaultproperties
{
     DeathStrings(0)="%k's A49 burned %o's corpse away."
     DeathStrings(1)="%o's was charred and cauterized by %k's A49."
     DeathStrings(2)="%k turned %o's legs to drumsticks with an A49."
     DeathStrings(3)="%k's blue plasma burned away %o's head."
     BloodManagerName="BallisticFix.BloodMan_A73Burn"
     WeaponClass=Class'BWBP_SKC_Fix.A49SkrithBlaster'
     DeathString="%k's A49 burned %o's corpse away."
     FemaleSuicide="%o's A49 melted her feet to the ground."
     MaleSuicide="%o's A49 melted his feet to the ground."
     GibPerterbation=0.200000
     KDamageImpulse=1000.000000
}
