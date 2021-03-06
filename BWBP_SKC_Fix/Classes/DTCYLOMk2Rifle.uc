//=============================================================================
// DTCyloMk2Rifle.
//
// Damage type for the incendiary Mk2 CYLO.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2007 RuneStorm. All Rights Reserved.
//=============================================================================
class DTCYLOMk2Rifle extends DT_BWBullet;

defaultproperties
{
     DeathStrings(0)="%o's chest was given airholes by %k's CYLO Firestorm."
     DeathStrings(1)="%k turned %o into a human clarinet with %kh CYLO Firestorm."
     DeathStrings(2)="%k's CYLO Firestorm made short work of %o."
     DeathStrings(3)="%k's CYLO Firestorm made %o into mincemeat."
     bIgniteFires=True
     DamageDescription=",Bullet,Flame,"
     WeaponClass=Class'BWBP_SKC_Fix.CYLOFS_AssaultWeapon'
     DeathString="%o's chest was given airholes by %k's CYLO Firestorm."
//     FemaleSuicide="%o somehow shot herself."
//     MaleSuicide="%o, how the hell did you shoot yourself?"
     FemaleSuicide="%o spat fire at her feet."
     MaleSuicide="%o spat fire at his feet."
     bFastInstantHit=True
     GibPerterbation=0.100000
     KDamageImpulse=3000.000000
     VehicleDamageScaling=0.800000
}
