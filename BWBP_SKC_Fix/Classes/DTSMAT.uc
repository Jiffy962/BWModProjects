//=============================================================================
// SMAT.
//
// DamageType for the SMAT
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DTSMAT extends DT_BWExplode;

defaultproperties
{
     DeathStrings(0)="%o intercepted one of %k's anti-tank rounds."
     DeathStrings(1)="%o got a big surprise from %k's SM-AT/AA."
     DeathStrings(2)="%k aimed %kh recoilless rifle at %o's face."
     WeaponClass=Class'BWBP_SKC_Fix.SMATLauncher'
     DeathString="%o was obliterated by %k's SM-AT/AA."
     FemaleSuicide="%o pointed her SMAT in the wrong direction."
     MaleSuicide="%o pointed his SMAT in the wrong direction."
     bDelayedDamage=True
     VehicleDamageScaling=1.200000
}
