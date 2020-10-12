//=============================================================================
// IM_LAWSmall.
//
// ImpactManager subclass for THE GOD DARN NUKES
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class IM_LAWSmall extends BCImpactManager;

var() float		SurfaceRange;
var() float		MinFluidDepth;

simulated function SpawnEffects (int HitSurfaceType, vector Norm, optional byte Flags)
{
	local vector WLoc, WNorm;
	local bool bHitWater;
	local float ImpactDepth;

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = !PhysicsVolume.TraceThisActor(WLoc, WNorm, Location, Location + vect(0,0,1)*SurfaceRange);
		ImpactDepth = WLoc.Z - Location.Z;
		if (ImpactDepth > MinFluidDepth)
		{
			if (bHitWater && ImpactDepth < SurfaceRange)
				Spawn (Class'BallisticFix.IE_WaterSurfaceBlast', Owner,, WLoc);
			HitEffects[HitSurfaceType]=Class'BallisticFix.IE_UnderWaterExplosion';
			HitSounds[HitSurfaceType]=SoundGroup'BallisticSounds2.Explosions.Explode-UW';
		}
	}
	super.SpawnEffects(HitSurfaceType, Norm, Flags);
}
/*
	EST_Default,	0
	EST_Rock,		1
	EST_Dirt,		2
	EST_Metal,		3
	EST_Wood,		4
	EST_Plant,		5
	EST_Flesh,		6
    EST_Ice,		7
    EST_Snow,		8
    EST_Water,		9
    EST_Glass,		10
*/

defaultproperties
{
     SurfaceRange=684.000000
     MinFluidDepth=128.000000
     HitEffects(0)=Class'BWBP_SKC_Fix.IE_RocketExplosionBig'
     HitEffects(1)=Class'BallisticFix.IE_HAMRExplosionDirt'
     HitEffects(2)=Class'BallisticFix.IE_HAMRExplosionDirt'
     HitEffects(3)=Class'BWBP_SKC_Fix.IE_RocketExplosionBig'
     HitEffects(4)=Class'BallisticFix.IE_HAMRExplosionDirt'
     HitEffects(5)=Class'BallisticFix.IE_HAMRExplosionDirt'
     HitEffects(6)=Class'BWBP_SKC_Fix.IE_RocketExplosionBig'
     HitEffects(7)=Class'BWBP_SKC_Fix.IE_RocketExplosionBig'
     HitEffects(8)=Class'BallisticFix.IE_HAMRExplosion'
     HitEffects(9)=Class'BallisticFix.IE_HAMRExplosionDirt'
     HitEffects(10)=Class'BWBP_SKC_Fix.IE_RocketExplosionBig'
     HitDecals(0)=Class'BallisticFix.AD_Explosion'
     HitSounds(0)=Soundgroup'BWBP_SKC_SoundsExp.LAW.LAW-Boom'
     HitSoundVolume=2.500000
     HitSoundRadius=2548.000000
     EffectBackOff=96.000000
}
