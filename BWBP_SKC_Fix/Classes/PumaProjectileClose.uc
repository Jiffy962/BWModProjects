//=============================================================================
// PUMACloseProjectile.
//
// Energy explosive. Blows up in your face.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class PUMAProjectileClose extends BallisticGrenade;


defaultproperties
{
     DetonateDelay=0.000100
     bNoInitialSpin=True
     bAlignToVelocity=True
     bCanHitOwner=false
     ImpactDamage=100
     ImpactDamageType=Class'BallisticFix.DTM50Grenade'
     ImpactManager=Class'BWBP_SKC_Fix.IM_PumaDetClose'
     TrailClass=Class'Onslaught.ONSSkyMineEffect'
     MyRadiusDamageType=Class'BWBP_SKC_Fix.DT_PumaSelf'
     SplashManager=Class'BallisticFix.IM_ProjWater'
     ShakeRadius=512.000000
     MotionBlurRadius=300.000000
     Speed=6000.000000
     Damage=110.000000
     DamageRadius=360.000000
     MomentumTransfer=60000.000000
     MyDamageType=Class'BWBP_SKC_Fix.DT_PumaSelf'
     StaticMesh=StaticMesh'BWBP_SKC_Static.Bulldog.Frag12Proj'
     DrawScale=2.000000
     LifeSpan=16.000000
     LightHue=180
     LightSaturation=100
     LightBrightness=160.000000
     LightRadius=8.000000
}
