//=============================================================================
// DT_HVCOverheat.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_BFGExplode extends DT_BWFire;

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
     FlashF=0.100000
     FlashV=(X=2000.000000,Y=600.000000,Z=600.000000)
     DeathStrings(0)="%o was a casualty of %k's overloaded E-V HPC."
     DeathStrings(1)="%k went supernova in %o's face."
     DeathStrings(2)="%o was too close to the exploding %k's E-V HPC."
     DeathStrings(3)="%k took out %o in a glorious E-V HPC explosion."
     FemaleSuicides(0)="%o exploded her new E-V HPC."
     FemaleSuicides(1)="%o overloaded her hyper plasma cannon."
     FemaleSuicides(2)="%o's EV-HPC went haywire and blew up."
     MaleSuicides(0)="%o exploded his new E-V HPC."
     MaleSuicides(1)="%o overloaded a hyper plasma cannon."
     MaleSuicides(2)="%o's EV-HPC went haywire and blew up."
     BloodManagerName="BallisticFix.BloodMan_Lightning"
     ShieldDamage=200
     DamageDescription=",Electro,Hazard,Plasma,"
     bNoSeverStumps=True
     WeaponClass=Class'BWBP_SKC_Fix.HVPCMk66PlasmaCannon'
     DeathString="%k went supernova in %o's face."
     FemaleSuicide="%o exploded her new EV-HPC."
     MaleSuicide="%o exploded his new EV-HPC."
     bInstantHit=True
     bSkeletize=True
     bCauseConvulsions=True
     bCausesBlood=True
     bNeverSevers=False
     bFlaming=True
     GibModifier=5.500000
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     DamageOverlayTime=0.900000
     GibPerterbation=1.200000
     KDamageImpulse=20000.000000
}
