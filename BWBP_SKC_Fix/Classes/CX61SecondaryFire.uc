//=============================================================================
// CX61 Secondary Fire
//
// A medium ranged stream of fire which easily sears players and goes into small
// spaces. Uses trace / projectile combo for hit detection.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class CX61SecondaryFire extends BallisticFire;

var  	Actor						MuzzleFlame;
var   	bool						bIgnited;
var 	Sound					FireSoundLoop;
const FLAMERINTERVAL = 0.2f;

simulated function bool HasAmmo()
{
	return CX61AssaultRifle(Weapon).StoredGas > 0;
}

simulated function SwitchCX61Mode (byte NewMode)
{
	if(NewMode == 1)
	{
		BallisticFireSound.Sound=None;
		FireSoundLoop=Sound'BallisticSounds2.T10.T10-toxinLoop';
		GotoState('HealGas');
	}
	else if (NewMode == 0)
	{
		BallisticFireSound.Sound=Sound'BallisticSounds3.RX22A.RX22A-Ignite';
		FireSoundLoop=Sound'BallisticSounds3.RX22A.RX22A-FireLoop';
		GotoState('Flamer');
	}
	if (Weapon.bBerserk)
	{
		FireRate *= 0.75;
		RecoilPerShot *= 0.75;
		FireChaos *= 0.75;
	}
	if ( Level.GRI.WeaponBerserk > 1.0 )
	    FireRate /= Level.GRI.WeaponBerserk;

	Load=AmmoPerFire;
}

event Timer()
{
	super.Timer();
	if ( bIgnited && (!IsFiring() || Weapon.GetFireMode(0).IsFiring() ) )
	{
		StopFlaming();
	}
}

function StopFlaming()
{
	bIgnited = false;
	
	if (MuzzleFlame != None)
	{	
		Emitter(MuzzleFlame).Kill();	
		MuzzleFlame = None;	
	}

	Instigator.AmbientSound = BW.UsedAmbientSound;
}

function float MaxRange()	{	return 800;	}

simulated state Flamer
{
	function DoFireEffect()
	{
		local Vector Start, Dir, End, HitLocation, HitNormal;
		local Rotator Aim;
		local actor Other;
		local float Dist;
		local int i;
		local CX61FlameProjectile Prj;
	
	    // the to-hit trace always starts right in front of the eye
		Start = Instigator.Location + Instigator.EyePosition();
		Aim = GetFireAim(Start);
		Aim = Rotator(GetFireSpread() >> Aim);
	
	    Dir = Vector(Aim);
		End = Start + (Dir*MaxRange());
	
		Weapon.bTraceWater=true;
		for (i=0;i<20;i++)
		{
			Other = Trace(HitLocation, HitNormal, End, Start, true);
			if (Other == None || Other.bWorldGeometry || Mover(Other) != none || FluidSurfaceInfo(Other) != None || (PhysicsVolume(Other) != None && PhysicsVolume(Other).bWaterVolume))
				break;
			Start = HitLocation + Dir * FMax(32, (Other.CollisionRadius*2 + 4));
		}
		Weapon.bTraceWater=false;
	
		if (Other == None)
			HitLocation = End;
		if ( (FluidSurfaceInfo(Other) != None) || ((PhysicsVolume(Other) != None) && PhysicsVolume(Other).bWaterVolume) )
			Other = None;
	
		Dist = VSize(HitLocation-Start);
	
		Prj = Spawn (class'CX61FlameProjectile',Instigator,, Start, Rotator(HitLocation-Start));
		
		if (Prj != None)
		{
			Prj.Instigator = Instigator;
			Prj.InitFlame(HitLocation);
			Prj.bHitWall = Other != None;
		}
	
		CX61Attachment(Weapon.ThirdPersonActor).CX61UpdateFlameHit(Other, HitLocation, HitNormal);
		
		CX61AssaultRifle(Weapon).StoredGas -= 0.08;
	
		Super(BallisticFire).DoFireEffect();
	}
	
	//Do the spread on the client side
	function PlayFiring()
	{
	    ClientPlayForceFeedback(FireForce);  // jdf
	    FireCount++;
	
		if (FireSoundLoop != None)
			Instigator.AmbientSound = FireSoundLoop;
	
		if (!bIgnited)
		{
			BW.SafeLoopAnim(FireLoopAnim, FireAnimRate, TweenTime, ,"FIRE");
			bIgnited = true;
			Weapon.PlayOwnedSound(BallisticFireSound.Sound,BallisticFireSound.Slot,BallisticFireSound.Volume,BallisticFireSound.bNoOverride,BallisticFireSound.Radius,BallisticFireSound.Pitch,BallisticFireSound.bAtten);
		}
		if (MuzzleFlame == None)
			class'BUtil'.static.InitMuzzleFlash (MuzzleFlame, class'RX22AMuzzleFlame', Weapon.DrawScale*FlashScaleFactor, weapon, 'tip2');
	}
	
	//server
	function ServerPlayFiring()
	{
		if (!bIgnited)
		{
			BW.SafeLoopAnim(FireLoopAnim, FireAnimRate, TweenTime, ,"FIRE");
			bIgnited = true;
			Weapon.PlayOwnedSound(BallisticFireSound.Sound,BallisticFireSound.Slot,BallisticFireSound.Volume,BallisticFireSound.bNoOverride,BallisticFireSound.Radius,BallisticFireSound.Pitch,BallisticFireSound.bAtten);
		}
		if (FireCount == 0 && FireSoundLoop != None)
			Instigator.AmbientSound = FireSoundLoop;
	}
}

simulated state HealGas
{
	function DoFireEffect()
	{
		local Vector Start, Dir, End, HitLocation, HitNormal;
		local Rotator Aim;
		local actor Other;
		local float Dist;
		local int i;
		local CX61HealProjectile Prj;
	
	    // the to-hit trace always starts right in front of the eye
		Start = Instigator.Location + Instigator.EyePosition();
		Aim = GetFireAim(Start);
		Aim = Rotator(GetFireSpread() >> Aim);
	
	    Dir = Vector(Aim);
		End = Start + (Dir*MaxRange());
	
		Weapon.bTraceWater=true;
		for (i=0;i<20;i++)
		{
			Other = Trace(HitLocation, HitNormal, End, Start, true);
			if (Other == None || Other.bWorldGeometry || Mover(Other) != none || FluidSurfaceInfo(Other) != None || (PhysicsVolume(Other) != None && PhysicsVolume(Other).bWaterVolume))
				break;
			Start = HitLocation + Dir * FMax(32, (Other.CollisionRadius*2 + 4));
		}
		Weapon.bTraceWater=false;
	
		if (Other == None)
			HitLocation = End;
		if ( (FluidSurfaceInfo(Other) != None) || ((PhysicsVolume(Other) != None) && PhysicsVolume(Other).bWaterVolume) )
			Other = None;
	
		Dist = VSize(HitLocation-Start);
	
		Prj = Spawn (class'CX61HealProjectile',Instigator,, Start, Rotator(HitLocation-Start));
		
		if (Prj != None)
		{
			Prj.Instigator = Instigator;
		}
		
		CX61AssaultRifle(Weapon).StoredGas -= 0.02;
		CX61Attachment(Weapon.ThirdPersonActor).CX61UpdateGasHit(HitLocation);
	
		Super(BallisticFire).DoFireEffect();
	}
	
	//Do the spread on the client side
	function PlayFiring()
	{
	    ClientPlayForceFeedback(FireForce);  // jdf
	    FireCount++;
		
		if (!bIgnited)
		{
			BW.SafeLoopAnim(FireLoopAnim, FireAnimRate, TweenTime, ,"FIRE");
			bIgnited = true;
		}
	
		if (FireSoundLoop != None)
			Instigator.AmbientSound = FireSoundLoop;
	}
	
	//server
	function ServerPlayFiring()
	{
		if (!bIgnited)
		{
			BW.SafeLoopAnim(FireLoopAnim, FireAnimRate, TweenTime, ,"FIRE");
			bIgnited = true;
		}
		
		if (FireCount == 0 && FireSoundLoop != None)
			Instigator.AmbientSound = FireSoundLoop;
	}
}

// Flamer should fire unless the gun's reloading
simulated function bool AllowFire()
{
	if (!CheckReloading() || Instigator.HeadVolume.bWaterVolume || CX61AssaultRifle(Weapon).StoredGas <= 0)
	{
		if (bIgnited)
			StopFiring();
		return false;
	}
	return true;
}

function StopFiring()
{
	bIgnited = false;
	Instigator.AmbientSound = None;
	NextFireTime = Level.TimeSeconds + FLAMERINTERVAL;
	if (MuzzleFlame != None)
	{
		Emitter(MuzzleFlame).Kill();
		MuzzleFlame = None;
	}
}

simulated function DestroyEffects()
{
	Super.DestroyEffects();
	if (MuzzleFlame != None)
		MuzzleFlame.Destroy();
}

defaultproperties
{
	 FireAnim=""
     AmmoClass=Class'BWBP_SKC_Fix.Ammo_CX61Flechette'
     AmmoPerFire=0
     BallisticFireSound=(Sound=Sound'BallisticSounds3.RX22A.RX22A-Ignite',Volume=0.600000,Slot=SLOT_Interact,bNoOverride=False)
     bPawnRapidFireAnim=True
     FireChaos=0.050000
     FireEndAnim="SprayEnd"
     FireLoopAnim="SprayLoop"
     FireRate=0.090000
     FireSoundLoop=Sound'BallisticSounds3.RX22A.RX22A-FireLoop'
     FlashBone='tip2'
     RecoilPerShot=0.000000
     ShakeOffsetMag=(X=-10.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=1.500000
     ShakeRotMag=(X=64.000000,Y=64.000000,Z=64.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     TweenTime=0.000000
     WarnTargetPct=0.200000
}
