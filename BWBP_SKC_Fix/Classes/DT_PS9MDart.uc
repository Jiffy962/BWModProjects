//=============================================================================
// DT_PS9MDart.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_PS9MDart extends DT_BWMiscDamage;

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
     DeathStrings(0)="%o was dissolved by %k's PS9m neurotoxin."
     DeathStrings(1)="%k's PS9m neurotoxin ate away at %o ."
     DeathStrings(2)="%o got a dose of neurotoxin from %k's PS9m."
     DeathStrings(3)="%k fulfilled %kh contract on %o."
     DeathStrings(4)="%k assassinated %o with a PS9m."
     bDetonatesBombs=False
     DamageDescription=",Gas,GearSafe,Hazard,"
     MinMotionBlurDamage=1.000000
     MotionBlurDamageRange=20.000000
     MotionBlurFactor=2.000000
     bUseMotionBlur=True
     WeaponClass=Class'BWBP_SKC_Fix.PS9mPistol'
     DeathString="%o was dissolved by %k's PS9m neurotoxin."
     FemaleSuicide="%o took some of her own medicine."
     MaleSuicide="%o took some of his own medicine."
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
