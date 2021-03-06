//=============================================================================
// DT_MRL.
//
// DamageType for the JL-21 PeaceMaker
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2007 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_LS14Rocket extends DT_BWExplode;

defaultproperties
{
     DeathStrings(0)="%k made a night-light out of %o's stomach with a rocket."
     DeathStrings(1)="%o tried to catch %k's rocket in a lapse of judgement."
     DeathStrings(2)="%k lodged a rocket down %o's throat."
     DeathStrings(3)="%o French kissed %k's rocket and %vh teeth turned into shards."
     DeathStrings(4)="%k launched a rocket right up %o's nostril."
     WeaponClass=Class'BWBP_SKC_Fix.LS14Carbine'
     DeathString="%k made a night-light out of %o's stomach with a rocket."
     FemaleSuicide="%o had her heart set aflame by a LS-14 rocket."
     MaleSuicide="%o had his heart set aflame by a LS-14 rocket."
     bDelayedDamage=True
     VehicleDamageScaling=0.250000
     VehicleMomentumScaling=0.500000
}
