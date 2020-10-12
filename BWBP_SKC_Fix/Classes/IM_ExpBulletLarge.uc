//=============================================================================
// IM_ExpBulletLarge.
//
// ImpactManager subclass for Bulldog 20mms
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class IM_ExpBulletLarge extends IM_Bullet;

defaultproperties
{
     HitEffects(0)=Class'BWBP_SKC_Fix.IE_BulletExpLConcrete'
     HitEffects(1)=Class'BWBP_SKC_Fix.IE_BulletExpLConcrete'
     HitEffects(2)=Class'BWBP_SKC_Fix.IE_BulletExpLDirt'
     HitEffects(3)=Class'BWBP_SKC_Fix.IE_BulletExpLMetal'
     HitEffects(4)=Class'BWBP_SKC_Fix.IE_BulletExpLWood'
     HitEffects(5)=Class'BWBP_SKC_Fix.IE_BulletExpLGrass'
     HitEffects(7)=Class'BWBP_SKC_Fix.IE_BulletExpLIce'
     HitEffects(8)=Class'BWBP_SKC_Fix.IE_BulletExpLSnow'
     HitDecals(0)=Class'BallisticFix.AD_BigBulletConcrete'
     HitDecals(1)=Class'BallisticFix.AD_BigBulletConcrete'
     HitDecals(3)=Class'BallisticFix.AD_BigBulletMetal'
     HitDecals(4)=Class'BallisticFix.AD_BigBulletWood'
     HitDecals(5)=Class'BallisticFix.AD_BigBulletConcrete'
     HitDecals(6)=Class'BallisticFix.AD_BigBulletConcrete'
     HitDecals(7)=Class'BallisticFix.AD_BigBulletConcrete'
     HitDecals(10)=Class'BallisticFix.AD_BigBulletConcrete'
     HitSounds(0)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(1)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(2)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(3)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(4)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(5)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(6)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(7)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(8)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSounds(9)=SoundGroup'BallisticSounds2.BulletImpacts.BulletWater'
     HitSounds(10)=Sound'BWBP_SKC_Sounds.Bulldog.Bulldog-Impact'
     HitSoundVolume=1.500000
     HitSoundRadius=164.000000
}
