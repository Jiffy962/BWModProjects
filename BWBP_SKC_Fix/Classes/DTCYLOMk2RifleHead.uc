//=============================================================================
// DTCYLOMk2RifleHead.
//
// Damage type for the CYLO MK2 headshots.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2007 RuneStorm. All Rights Reserved.
//=============================================================================
class DTCYLOMk2RifleHead extends DT_BWBullet;

// HeadShot stuff from old sniper damage ------------------
static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;

	if ( PlayerController(Killer) == None )
		return;

	PlayerController(Killer).ReceiveLocalizedMessage( Class'XGame.SpecialKillMessage', 0, Killer.PlayerReplicationInfo, None, None );
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.headcount++;
		if ( (xPRI.headcount == 15) && (UnrealPlayer(Killer) != None) )
			UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
	}
}
// --------------------------------------------------------

defaultproperties
{
     bHeaddie=True
     DeathStrings(0)="%k CYLO IV'd %o's head right off."
     DeathStrings(1)="%k put a firey bullet in %o's head with his pyro CYLO."
     DeathStrings(2)="%k's incendiary CYLO rounds melted %o's face."
     DeathStrings(3)="%k put a incendiary round through %o's head."
     EffectChance=0.500000
     bIgniteFires=True
     DamageDescription=",Bullet,Flame,"
     WeaponClass=Class'BWBP_SKC_Fix.CYLOFS_AssaultWeapon'
     DeathString="%k CYLO IV'd %o's head right off."
     FemaleSuicide="%o routed herself."
     MaleSuicide="%o routed himself."
     bFastInstantHit=True
     bAlwaysSevers=True
     bSpecial=True
     PawnDamageSounds(0)=SoundGroup'BallisticSounds2.BulletImpacts.Headshot'
     GibPerterbation=0.200000
     KDamageImpulse=1000.000000
}
