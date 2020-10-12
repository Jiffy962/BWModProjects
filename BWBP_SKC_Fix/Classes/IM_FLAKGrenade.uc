//=============================================================================
// IM_FLAKGrenade.
//
// ImpactManager subclass for FLAK explosions - it's loud!
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class IM_FLAKGrenade extends BCImpactManager;

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
			HitEffects[0]=Class'BallisticFix.IE_UnderWaterExplosion';
			HitSounds[0]=SoundGroup'BallisticSounds2.Explosions.Explode-UW';
		}
	}
	super.SpawnEffects(HitSurfaceType, Norm, Flags);
}

defaultproperties
{
     SurfaceRange=384.000000
     MinFluidDepth=128.000000
     HitEffects(0)=Class'Onslaught.ONSAVRiLRocketExplosion'
//     HitEffects(0)=Class'BWBP_SKC_Fix.IE_FLAKAirBurst'
     HitDecals(0)=Class'BallisticFix.AD_Explosion'
     HitSounds(0)=Sound'BWBP_SKC_Sounds.Misc.FLAK-GrenadeExplode'
     HitSoundVolume=8.000000
     HitSoundRadius=2500.000000
     EffectBackOff=64.000000
}
