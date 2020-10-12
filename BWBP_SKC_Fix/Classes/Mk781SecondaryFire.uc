//=============================================================================
// Mk781SecondaryFire.
//
// I KNOW YOU'RE READING THIS AZARAEL.
// YOU AND MAYBE XAVIOUS.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2005 RuneStorm. All Rights Reserved.
//=============================================================================
class Mk781SecondaryFire extends BallisticShotgunFire;

var   bool		bLoaded; //Do we even have grenades?
var   bool		bIsCharging; //Are we charging?
var   float RailPower;
var   float ChargeRate;
var   float PowerLevel;
var   float MaxCharge;

var() Vector			SpawnOffset;		// Projectile spawned at this offset
var	  Projectile		Proj;				// The projectile actor

var() sound		PulseFireSound;
var() sound		ShotFireSound;


var       float		HUDRefreshTime;		// Used to keep the damn thing pretty


// Check if there is ammo in clip if we use weapon's mag or is there some in inventory if we don't
simulated function bool AllowFire()
{
	if (!CheckReloading())
		return false;		// Is weapon busy reloading
	if (!CheckWeaponMode())
		return false;		// Will weapon mode allow further firing
	if (Mk781Shotgun(BW).Grenades == 0 && !Mk781Shotgun(BW).bReady)
	{
		if (!bPlayedDryFire && DryFireSound.Sound != None)
		{
			Weapon.PlayOwnedSound(DryFireSound.Sound,DryFireSound.Slot,DryFireSound.Volume,DryFireSound.bNoOverride,DryFireSound.Radius,DryFireSound.Pitch,DryFireSound.bAtten);
			bPlayedDryFire=true;
		}
		if (bDryUncock)
			BW.bNeedCock=true;
		BW.bNeedReload = BW.MayNeedReload(ThisModeNum, 0);

		Mk781Shotgun(BW).EmptyAltFire(ThisModeNum);
		return false;		// Is there ammo in weapon's mag
	}
    return true;
}

simulated event ModeDoFire()
{

	if (!AllowFire())
		return;

	if (!Mk781Shotgun(Weapon).bReady)
	{
		Mk781Shotgun(Weapon).PrepAltFire();
		return;
	}
    	else
    	{
		super.ModeDoFire();
		Mk781Shotgun(Weapon).bReady = false;
		Mk781Shotgun(Weapon).PrepPriFire();
    	}

}



simulated function SwitchSilencerMode(bool bSilenced)
{
	if (bSilenced == true)
	{
			XInaccuracy=10;
			YInaccuracy=10;
		Mk781Attachment(Weapon.ThirdPersonActor).bSilenced=true;
		ProjectileClass=Class'Mk781PulseProjectile';
		BallisticFireSound.Sound=PulseFireSound;
		bLeadTarget=true;
		bInstantHit=false;
		GotoState('ElektroSlug');
		bSplashDamage=True;
		bRecommendSplashDamage=True;
		WarnTargetPct=0.10000;
	}
	
	else
	{
		XInaccuracy=default.XInaccuracy;
		YInaccuracy=default.YInaccuracy;
		Mk781Attachment(Weapon.ThirdPersonActor).bSilenced=false;
		ProjectileClass=None;
		BallisticFireSound.Sound=ShotFireSound;
		bLeadTarget=false;
		bInstantHit=true;
		GotoState('ElektroShot');
		bSplashDamage=false;
		bRecommendSplashDamage=false;
		WarnTargetPct=0.010000;
	}

}




simulated state ElektroSlug
{
	// Became complicated when acceleration came into the picture
	// Override for even wierder situations
	function float MaxRange()
	{
		if (ProjectileClass.default.MaxSpeed > ProjectileClass.default.Speed)
		{
			// We know BW projectiles have AccelSpeed
			if (class<BallisticProjectile>(ProjectileClass) != None && class<BallisticProjectile>(ProjectileClass).default.AccelSpeed > 0)
			{
				if (ProjectileClass.default.LifeSpan <= 0)
					return FMin(ProjectileClass.default.MaxSpeed, (ProjectileClass.default.Speed + class<BallisticProjectile>(ProjectileClass).default.AccelSpeed * 2) * 2);
				else
					return FMin(ProjectileClass.default.MaxSpeed, (ProjectileClass.default.Speed + class<BallisticProjectile>(ProjectileClass).default.AccelSpeed * ProjectileClass.default.LifeSpan) * ProjectileClass.default.LifeSpan);
			}
			// For the rest, just use the max speed
			else
			{
				if (ProjectileClass.default.LifeSpan <= 0)
					return ProjectileClass.default.MaxSpeed * 2;
				else
					return ProjectileClass.default.MaxSpeed * ProjectileClass.default.LifeSpan*0.75;
			}
		}
		else // Hopefully this proj doesn't change speed.
		{
			if (ProjectileClass.default.LifeSpan <= 0)
				return ProjectileClass.default.Speed * 2;
			else
				return ProjectileClass.default.Speed * ProjectileClass.default.LifeSpan;
		}
	}

	// Get aim then spawn projectile
	function DoFireEffect()
	{
		local Vector StartTrace, X, Y, Z, Start, End, HitLocation, HitNormal;
		local Rotator Aim;
		local actor Other;

	    Weapon.GetViewAxes(X,Y,Z);
    	// the to-hit trace always starts right in front of the eye
	    Start = Instigator.Location + Instigator.EyePosition();

	    StartTrace = Start + X*SpawnOffset.X + Z*SpawnOffset.Z;
    	if ( !Weapon.WeaponCentered() )
		    StartTrace = StartTrace + Weapon.Hand * Y*SpawnOffset.Y;

		Aim = GetFireAim(StartTrace);
		Aim = Rotator(GetFireSpread() >> Aim);

		End = Start + (Vector(Aim)*MaxRange());
		Other = Trace (HitLocation, HitNormal, End, Start, true);

		if (Other != None)
			Aim = Rotator(HitLocation-StartTrace);
	    SpawnProjectile(StartTrace, Aim);

		SendFireEffect(none, vect(0,0,0), StartTrace, 0);
		// Skip the instant fire version which would cause instant trace damage.
		Super(BallisticFire).DoFireEffect();
	}

	function SpawnProjectile (Vector Start, Rotator Dir)
	{
		Proj = Spawn (ProjectileClass,,, Start, Dir);
		Proj.Instigator = Instigator;
	}
}

simulated state ElektroShot
{
// Get aim then run several individual traces using different spread for each one
function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;
	local int i;

	Aim = GetFireAim(StartTrace);
	for (i=0;i<TraceCount;i++)
	{
		R = Rotator(GetFireSpread() >> Aim);
		DoTrace(StartTrace, R);
	}
	// Tell the attachment the aim. It will calculate the rest for the clients
	SendFireEffect(none, Vector(Aim)*TraceRange.Max, StartTrace, 0);

	Super(BallisticFire).DoFireEffect();
}

// Even if we hit nothing, this is already taken care of in DoFireEffects()...
function NoHitEffect (Vector Dir, optional vector Start, optional vector HitLocation, optional vector WaterHitLoc)
{
	local Vector V;

	V = Instigator.Location + Instigator.EyePosition() + Dir * TraceRange.Min;
	if (TracerClass != None && Level.DetailMode > DM_Low && class'BallisticMod'.default.EffectsDetailMode > 0 && VSize(V - BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation()) > 200 && FRand() < TracerChance)
		Spawn(TracerClass, instigator, , BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation(), Rotator(V - BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation()));
	if (ImpactManager != None && WaterHitLoc != vect(0,0,0) && Weapon.EffectIsRelevant(WaterHitLoc,false) && bDoWaterSplash)
		ImpactManager.static.StartSpawn(WaterHitLoc, Normal((Instigator.Location + Instigator.EyePosition()) - WaterHitLoc), 9, Instigator);
}

// Spawn the impact effects here for StandAlone and ListenServers cause the attachment won't do it
simulated function bool ImpactEffect(vector HitLocation, vector HitNormal, Material HitMat, Actor Other, optional vector WaterHitLoc)
{
	local int Surf;

	if (ImpactManager != None && WaterHitLoc != vect(0,0,0) && Weapon.EffectIsRelevant(WaterHitLoc,false) && bDoWaterSplash)
		ImpactManager.static.StartSpawn(WaterHitLoc, Normal((Instigator.Location + Instigator.EyePosition()) - WaterHitLoc), 9, Instigator);

	if (!Other.bWorldGeometry && Mover(Other) == None)
		return false;

	if (!bAISilent)
		Instigator.MakeNoise(1.0);
	if (ImpactManager != None && Weapon.EffectIsRelevant(HitLocation,false))
	{
		if (Vehicle(Other) != None)
			Surf = 3;
		else if (HitMat == None)
			Surf = int(Other.SurfaceType);
		else
			Surf = int(HitMat.SurfaceType);
		ImpactManager.static.StartSpawn(HitLocation, HitNormal, Surf, instigator);
		if (TracerClass != None && Level.DetailMode > DM_Low && class'BallisticMod'.default.EffectsDetailMode > 0 && VSize(HitLocation - BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation()) > 200 && FRand() < TracerChance)
			Spawn(TracerClass, instigator, , BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation(), Rotator(HitLocation - BallisticAttachment(Weapon.ThirdPersonActor).GetTipLocation()));
	}
	return true;
}

}


defaultproperties
{
     ShotFireSound=Sound'BWBP_SKC_Sounds.HyperBeamCannon.343Primary-Hit'
     PulseFireSound=Sound'BWBP_SKC_Sounds.Autolaser.Autolaser-Fire'
     ProjectileClass=Class'BWBP_SKC_Fix.Mk781PulseProjectile'
     bUseWeaponMag=False
     bModeExclusive=False
     AmmoPerFire=0
     AmmoClass=Class'BWBP_SKC_Fix.Ammo_10GaugeZap'
     SpawnOffset=(X=20.000000,Y=9.000000,Z=-9.000000)
     TraceCount=30
     TracerClass=Class'BWBP_SKC_Fix.TraceEmitter_Supercharge'
     ImpactManager=Class'BWBP_SKC_Fix.IM_Supercharge'
     TraceRange=(Min=2000.000000,Max=4000.000000)
     Damage=10
     DamageHead=15
     DamageLimb=9
     RangeAtten=1.000000
     DamageType=Class'BWBP_SKC_Fix.DT_Mk781Electro'
     DamageTypeHead=Class'BWBP_SKC_Fix.DT_Mk781Electro'
     DamageTypeArm=Class'BWBP_SKC_Fix.DT_Mk781Electro'
     KickForce=8000
     PenetrateForce=100
     bPenetrate=True
     MuzzleFlashClass=Class'BWBP_SKC_Fix.PlasmaFlashEmitter'
     FlashScaleFactor=2.000000
     BrassClass=Class'BWBP_SKC_Fix.Brass_ShotgunZap'
     BrassOffset=(X=-1.000000,Z=-1.000000)
     RecoilPerShot=768.000000
     VelocityRecoil=180.000000
//     XInaccuracy=1600.000000
//     YInaccuracy=150.000000
     XInaccuracy=1300.000000
     YInaccuracy=1200.000000
     BallisticFireSound=(Sound=Sound'BWBP_SKC_Sounds.HyperBeamCannon.343Primary-Hit',Volume=1.600000)
     FireEndAnim=
     TweenTime=0.000000
     FireRate=0.500000
     ShakeRotMag=(X=128.000000,Y=64.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-30.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=0.900000
     WarnTargetPct=0.100000
     aimerror=400.000000
}
