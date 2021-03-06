//=============================================================================
// DTMJ51AssaultHead.
//
// DamageType for MJ51 headshots
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class DTMJ51AssaultHead extends DT_BWBullet;

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
     DeathStrings(0)="%o got %vh brain shredded by %k's MJ51."
     DeathStrings(1)="%o lost his head thanks to %k's MJ51."
     DeathStrings(2)="%k's MJ51 lifted %o's head off %vh shoulders."
     WeaponClass=Class'BWBP_SKC_Fix.MJ51Carbine'
     DeathString="%o got %vh brain shredded by %k's MJ51."
     FemaleSuicide="%o saw a bullet coming up the barrel of her MJ51."
     MaleSuicide="%o saw a bullet coming up the barrel of his MJ51."
     bFastInstantHit=True
     bAlwaysSevers=True
     bSpecial=True
     PawnDamageSounds(0)=SoundGroup'BallisticSounds2.BulletImpacts.Headshot'
     GibPerterbation=0.200000
     KDamageImpulse=1000.000000
     VehicleDamageScaling=0.650000
}
