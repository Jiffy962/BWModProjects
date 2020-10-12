//=============================================================================
// IM_A73Projectile.
//
// ImpactManager subclass for A73 projectiles
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class IM_HVPCProjectileSmall extends BCImpactManager;

defaultproperties
{
     HitEffects(0)=Class'BWBP_SKC_Fix.IE_HVPCSmallGeneral'
     HitDecals(0)=Class'BallisticFix.AD_MRLExplosion'
     HitSounds(0)=Sound'BWBP_SKC_Sounds.XavPlas.Xav-ImpactSmall'
     HitSoundVolume=1.000000
     HitSoundRadius=128.000000
}
