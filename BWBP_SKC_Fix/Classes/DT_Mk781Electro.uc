//=============================================================================
// DT_Mk781Electro.
//
// Damage type for the Mk781 lightning shell
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DT_Mk781Electro extends DT_BWShell;

var float	FlashF;
var vector	FlashV;

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	if (PlayerController(Victim.Controller) != None)
		PlayerController(Victim.Controller).ClientFlash(default.FlashF,default.FlashV);
	return super.GetPawnDamageEffect(HitLocation, Damage, Momentum, Victim, bLowDetail);
}

defaultproperties
{
     FlashF=-0.300000
     FlashV=(X=1500.000000,Y=1500.000000,Z=1500.000000)
     DeathStrings(0)="%k attempted some ranged electrotherapy on %o."
     DeathStrings(1)="%k's Mk.781 charged %o to 1.21 jiggawatts."
     DeathStrings(2)="%k's X-007 showed %o what licking 20 batteries is like.
     WeaponClass=Class'BWBP_SKC_Fix.Mk781Shotgun'
     DeathString="%k attempted some ranged electrotherapy on %o."
     FemaleSuicide="%o put the fork in the power outlet."
     MaleSuicide="%o put the spoon in the power outlet."
     GibPerterbation=0.400000
     KDamageImpulse=15000.000000
     VehicleDamageScaling=0.100000
     PawnDamageSounds(0)=Sound'BWBP_SKC_Sounds.Misc.XM84-StunEffect'
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
     bCauseConvulsions=True
     bNeverSevers=True
}
