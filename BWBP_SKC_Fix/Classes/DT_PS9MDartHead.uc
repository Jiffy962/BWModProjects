//=============================================================================
// DT_PS9mDartHead.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_PS9MDartHead extends DT_BWMiscDamage;

var float	FlashF;
var vector	FlashV;

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	if (PlayerController(Victim.Controller) != None)
		PlayerController(Victim.Controller).ClientFlash(default.FlashF, default.FlashV);
	return super.GetPawnDamageEffect(HitLocation, Damage, Momentum, Victim, bLowDetail);
}

defaultproperties
{
     FlashF=0.300000
     FlashV=(Y=2000.000000)
     DeathStrings(0)="%o's brain had a bad trip on %k's neurotoxin."
     DeathStrings(1)="%k gave %o an oral dose of PS9m neurotoxin."
     DeathStrings(2)="%k's PS9m toxin went to work on %o's brain."
     bDetonatesBombs=False
     DamageDescription=",Gas,GearSafe,Hazard,"
     MinMotionBlurDamage=1.000000
     MotionBlurDamageRange=20.000000
     MotionBlurFactor=12.000000
     bUseMotionBlur=True
     WeaponClass=Class'BWBP_SKC_Fix.PS9MPistol'
     DeathString="%o's brain had a bad trip on %k's neurotoxin."
     FemaleSuicide="%o had a bad trip."
     MaleSuicide="%o had a bad trip."
     bInstantHit=True
     bCausesBlood=False
     bDelayedDamage=True
     bNeverSevers=True
     PawnDamageSounds(0)=Sound'BWBP_SKC_SoundsExp.VSK.VSK-ImpactFlesh'
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     DamageOverlayTime=0.900000
     GibPerterbation=0.001000
     KDamageImpulse=90000.000000
     VehicleDamageScaling=0.001000
     VehicleMomentumScaling=0.001000
}
