//=============================================================================
// HVPCMk66PlasmaCannon
//
// This is the extreme voltage plasma cannon. E-V Plasma Cannon 9000. Aka BFG.
// Shoots big ol' balls of death.
// Also shoots rapid fire tiny balls of death.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class HVPCmk66PlasmaCannon extends BallisticWeapon;



var float		HeatLevel;			// Current Heat level, duh...
var bool		bIsVenting;			// Busy venting
var bool		bCriticalHeat;		// Heat is at critical levels
var() Sound		VentingSound;		// Sound to loop when venting
var() Sound		WarningSound;		// Sound to play when heat is critical
var() Sound		OverHeatSound;		// Sound to play when it overheats
var() Sound		PrimaryWarningSound;	// Sound to play when primary fire is dangerous.


var Actor GlowFX;



var bool		bWaterBurn;			// busy getting damaged in water

var bool	bArcOOA;			// Arcs have been killed cause ammo is out
var Actor	Arc1;				// The decorative side arc
var Actor	Arc2;				// The top arcs
var Actor	Arc3;
var Actor	Spiral;				// Red spiral that activates when charging secondary
var Actor	ClawSpark1;			// Sparks attached to claws when tracking enemy
var Actor	ClawSpark2;
var float	ClawAlpha;			// An alpha amount for claw movement interpolation
var float	RotorSpin;			// Rotation of rotor


var Emitter		FreeZap;		// The free zap emitter
var bool		bCanKillZap;	// Free zap is being killed and can be destroyed if needed, but we still want it rendered till then

var float		NextChangeMindTime;	// For AI
replication
{
	reliable if (ROLE==ROLE_Authority)
		ClientOverCharge, ClientSetHeat;
}

// -----------------------------------------------
// Events and target related stuff called from firemodes

simulated function ClientOverCharge()
{
	if (Firemode[1].bIsFiring)
		StopFire(1);
}
// Get the tracking zap emitter from attachment
simulated function HVCMk9_TrackingZap GetTargetZap()
{
	if (ThirdPersonActor == None)
		return None;
	return HVPCmk66Attachment(ThirdPersonActor).TargetZap;
}
// Activate the target zap and/or give it the list of targets (Server->Attachment->Client)
simulated function SetTargetZap(array<actor> Ts, array<vector> Vs)
{
	if (!FireMode[0].IsFiring())
		return;
	if (Role == ROLE_Authority)
		HVPCmk66Attachment(ThirdPersonActor).SetTargetZap(Ts, Vs);
	if (!Instigator.IsLocallyControlled())
		return;
	if (level.DetailMode > DM_High)
	{	if (ClawSpark1 == None)	class'BUtil'.static.InitMuzzleFlash (ClawSpark1, class'HVCMk9_ClawArc', DrawScale, self, 'ClawTip1');
		if (ClawSpark2 == None)	class'BUtil'.static.InitMuzzleFlash (ClawSpark2, class'HVCMk9_ClawArc', DrawScale, self, 'ClawTip2');	}
}
// Activate free zap (Server->Attachment->Client)
simulated function SetFreeZap()
{
	if (Role == ROLE_Authority)
		HVPCmk66Attachment(ThirdPersonActor).SetFreeZap();
	if (!Instigator.IsLocallyControlled())
		return;
	if (FreeZap != None)
	{	if (bCanKillZap)	FreeZap.Destroy();
		else				return;
	}
	KillTargetZap();
	FreeZap = spawn(class'HVCMk9_FreeZap', self);
	FreeZap.bHidden = true;
	bCanKillZap = false;
}
// Kill all zaps (Server->Attachment->Client)
simulated function KillZap()
{
	if (Role == ROLE_Authority)
		HVPCmk66Attachment(ThirdPersonActor).KillZap();
	if (Instigator.IsLocallyControlled())
	{	KillTargetZap();		KillFreeZap();		}
}
// Kill the target zap (local only)
simulated function KillTargetZap()
{
	if (ClawSpark1 != None)		Emitter(ClawSpark1).Kill();
	if (ClawSpark2 != None)		Emitter(ClawSpark2).Kill();
	Instigator.SoundPitch=64;
}
// Kill the free zap (local only)
simulated function KillFreeZap()
{
	if (FreeZap != None)
	{	FreeZap.Kill();	bCanKillZap = true;	}
}

// -----------------------------------------------
// Heat stuff

simulated function float ChargeBar()
{
	return HeatLevel / 10;
}









simulated event Tick (float DT)
{

	if (HeatLevel > 0)
	{
		if (bIsVenting)
			Heatlevel = FMax(HeatLevel - 2.5 * DT, 0);
		else
			Heatlevel = FMax(HeatLevel - 0.25 * DT, 0);
	}


	super.Tick(DT);
}

simulated function AddHeat(float Amount)
{
	HeatLevel += Amount;

	if (HeatLevel >= 10 && HeatLevel < 15)
	{
		Heatlevel = 15;
		PlaySound(OverHeatSound,,12.7,,2048);
		class'IM_HVPCMk66Explosion'.static.StartSpawn(Location, vect(0,0,1), 0, self);
		HurtRadius(1000, 1536, class'DT_BFGExplode', 8000, location);
		Destroy();
	}

}

simulated function ClientSetHeat(float NewHeat)
{
	HeatLevel = NewHeat;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;

    Instigator = Other;
    W = Weapon(Other.FindInventoryType(class));
    if ( W == None )
    {
		bJustSpawned = true;
        Super(Inventory).GiveTo(Other);
        bPossiblySwitch = true;
        W = self;
		if (Pickup != None && BallisticWeaponPickup(Pickup) != None)
			MagAmmo = BallisticWeaponPickup(Pickup).MagAmmo;
		if (HVPCMk66Pickup(Pickup) != None)
			HeatLevel = FMax( 0.0, HVPCMk66Pickup(Pickup).HeatLevel - (level.TimeSeconds - HVPCMk66Pickup(Pickup).HeatTime) * 0.25 );
		if (level.NetMode == NM_ListenServer || level.NetMode == NM_DedicatedServer)
			ClientSetHeat(HeatLevel);
    }
    else if ( !W.HasAmmo() )
	    bPossiblySwitch = true;

    if ( Pickup == None )
        bPossiblySwitch = true;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if ( FireMode[m] != None )
        {
            FireMode[m].Instigator = Instigator;
            GiveAmmo(m,WeaponPickup(Pickup),bJustSpawned);
        }
    }

	if ( (Instigator.Weapon != None) && Instigator.Weapon.IsFiring() )
		bPossiblySwitch = false;

	if ( Instigator.Weapon != W )
		W.ClientWeaponSet(bPossiblySwitch);

    if ( !bJustSpawned )
	{
        for (m = 0; m < NUM_FIRE_MODES; m++)
			Ammo[m] = None;
		Destroy();
	}
}

// -----------------------------------------------
// Effects interpolation and tickers

simulated event Timer()
{
	if (Instigator.Weapon != self)
		return;
	if (!bWaterBurn || Clientstate == WS_BringUp || Clientstate == WS_PutDown)
	{
		if (Clientstate == WS_PutDown)
			class'BUtil'.static.KillEmitterEffect (GlowFX);
		super.Timer();
	}

	else if (Role == ROLE_Authority && Instigator != None && AmmoAmount(0) > 0)
	{
		ConsumeAmmo(0, 10);
		class'BallisticDamageType'.static.GenericHurt (Instigator, 5, Instigator, Location, vect(0,0,0), class'DT_BFGExplode');
	}
}

simulated event WeaponTick(float DT)
{
	local vector End;

	super.WeaponTick(DT);

	if (bCriticalHeat && !bIsVenting)
	{
		Instigator.AmbientSound = WarningSound;
		Instigator.SoundVolume = 196;
	}

	else if (bCriticalHeat && bIsVenting)
	{
		Instigator.AmbientSound = VentingSound;
		Instigator.SoundVolume = 128;
	}
	else if (!bCriticalHeat && !bIsVenting)
	{
		Instigator.AmbientSound = UsedAmbientSound;
		Instigator.SoundVolume = default.SoundVolume;
	}
	else if (!bCriticalHeat && bIsVenting)
	{
		Instigator.AmbientSound = VentingSound;
		Instigator.SoundVolume = 128;
	}	


	if (HeatLevel >= 8 && HeatLevel < 10)
	{
		bCriticalHeat=true;
		if (Arc1 != None)
			HVPCMk5_SideArc(Arc1).SetColorShift(HeatLevel/2);
	}
	else if (HeatLevel < 8 && HeatLevel > 0)
	{
		bCriticalHeat=false;	
		if (HeatLevel >= 5 && Arc1 != None)
			HVPCMk5_SideArc(Arc1).SetColorShift(HeatLevel/10);

	}
	if (HeatLevel > 5.05 && HeatLevel < 5.10)
		PlaySound(PrimaryWarningSound,,0.7,,16);
	if (HeatLevel >= 5 && Spiral == None)
		class'bUtil'.static.InitMuzzleFlash(Spiral, class'HVPCMk66_GreenSpiral', DrawScale, self, 'drum');
	else if (HeatLevel < 5)
	{
		if (Spiral != None)
			Emitter(Spiral).kill();
		if (Arc1 != None)
			HVPCMk5_SideArc(Arc1).SetColorShift(0);
	}




	if (AIController(Instigator.Controller) != None)
	{
		if (HeatLevel > 0)
		{
			if (  BotShouldReload() && !Instigator.Controller.LineOfSightTo(AIController(Instigator.Controller).Enemy) && !IsGoingToVent())
				BotReload();
		}
		else if (bIsVenting)
			ReloadRelease();
	}

	if (Instigator.PhysicsVolume.bWaterVolume)
	{
		if (AmmoAmount(0) > 0)
			AddHeat(DT*1.5);
		if (!bWaterBurn && Role == ROLE_Authority && (Clientstate == WS_ReadyToFire || !Instigator.IsLocallyControlled()))
		{
			bWaterBurn=true;
			SetTimer(0.2, true);
		}
	}
	else if (bWaterBurn)
	{
		bWaterBurn = false;
		if (TimerRate == 0.2)
			SetTimer(0.0, false);

	}
	if (!Instigator.IsLocallyControlled())
		return;

	if (GetTargetZap() != None || FireMode[1].bIsFiring)	{	if (ClawAlpha < 1)
	{
		ClawAlpha = FClamp(ClawAlpha + DT, 0, 1);
		SetBoneRotation('Claw1', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw2', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw3', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw1B', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw2B', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw3B', rot(-8192,0,0),0,ClawAlpha);
	}	}
	else if (ClawAlpha > 0)
	{
		ClawAlpha = FClamp(ClawAlpha - DT/3, 0, 1);
		SetBoneRotation('Claw1', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw2', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw3', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw1B', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw2B', rot(-8192,0,0),0,ClawAlpha);
		SetBoneRotation('Claw3B', rot(-8192,0,0),0,ClawAlpha);
	}
	if (level.DetailMode>DM_Low)
	{
		if (AmmoAmount(0) < 1 && !FireMode[1].bIsFiring)	{	if (!bArcOOA)
		{
			bArcOOA=true;
			if (Arc1 != None)	Arc1.Destroy();
			if (Arc2 != None)	Arc2.Destroy();
			if (Arc3 != None)	Arc3.Destroy();
		}	}
		else if (bArcOOA)
		{
			bArcOOA = false;
			InitArcs();
		}
		else if (FireMode[1].bIsFiring || FireMode[0].bIsFiring)
		{
			InitArcs();
		}

		if (!bArcOOA)
		{
			RotorSpin += DT*(65536 + 65536 * ClawAlpha);
			SetBoneRotation('Spinner', rot(0,0,1)*RotorSpin,0,1.f);
		}
	}

	if (ClawSpark1 != None)
	{
		End = GetBoneCoords('tip').Origin + vector(Instigator.GetViewRotation()) * 96;
		BeamEmitter(Emitter(ClawSpark1).Emitters[0]).BeamEndPoints[0].Offset = class'BallisticEmitter'.static.VtoRV(End, End);
		if (ClawSpark2 != None)
			BeamEmitter(Emitter(ClawSpark2).Emitters[0]).BeamEndPoints[0].Offset = BeamEmitter(Emitter(ClawSpark1).Emitters[0]).BeamEndPoints[0].Offset;
	}
}

// -----------------------------------------------
// The arc effects and stuff

simulated function BringUp(optional Weapon PrevWeapon)
{
	bIsVenting = false;
	bCriticalHeat = false;

	super.BringUp(PrevWeapon);

    	if (Instigator.IsLocallyControlled() && level.DetailMode == DM_SuperHigh && class'BallisticMod'.default.EffectsDetailMode >= 2 && (GlowFX == None || GlowFX.bDeleteMe))
		class'BUtil'.static.InitMuzzleFlash (GlowFX, class'HVPCMK66GreenGlow', DrawScale, self, 'tip');

	AmbientSound = None;
	Instigator.AmbientSound = UsedAmbientSound;
	Instigator.SoundVolume = default.SoundVolume;
	Instigator.SoundPitch = default.SoundPitch;
	Instigator.SoundRadius = default.SoundRadius;
	Instigator.bFullVolume = true;
	if (AmmoAmount(0) > 0 && level.DetailMode>DM_Low)
		InitArcs();
}
simulated function bool PutDown()
{
	if (super.PutDown())
	{
		if (bIsVenting)
		{
			if (level.NetMode == NM_Client)
				bIsVenting = false;
			ServerReloadRelease();
		}
		if (HeatLevel >= 8 && HeatLevel < 15)
		{
			Heatlevel = 6;
		}
		if (bCriticalHeat)
			bCriticalHeat = false;

		if (Arc1 != None)	Arc1.Destroy();
		if (Arc2 != None)	Arc2.Destroy();
		if (Arc3 != None)	Arc3.Destroy();
		bWaterBurn=false;
		Instigator.AmbientSound = None;
		Instigator.SoundVolume = Instigator.default.SoundVolume;
		Instigator.SoundPitch = Instigator.default.SoundPitch;
		Instigator.SoundRadius = Instigator.default.SoundRadius;
		Instigator.bFullVolume = Instigator.default.bFullVolume;
		return true;
	}
	return false;
}
simulated function ResetArcs()
{
	if (level.DetailMode>DM_Low)
	{
		if (Spiral !=None)
			Emitter(Spiral).kill();
		Spiral = None;
		if (Arc1==None && bArcOOA)
			return;
		InitArcs();
		if (Arc1 != None)
			HVPCMk5_SideArc(Arc1).SetColorShift(0);
		if (Arc2 != None)
			HVPCMk66_TopArc(Arc2).SetColorShift(0);
		if (Arc3 != None)
			HVPCMk66_TopArc(Arc3).SetColorShift(0);
	}
}
simulated function InitArcs()
{
	if (Arc1 == None)
	{
		class'bUtil'.static.InitMuzzleFlash(Arc1, class'HVPCMk5_SideArc', DrawScale, self, 'Arc3');
		class'bUtil'.static.InitMuzzleFlash(Arc1, class'HVPCMk66GreenGlow', DrawScale, self, 'tip');
	}
	if (Arc2 == None)
		class'bUtil'.static.InitMuzzleFlash(Arc2, class'HVPCMk66_TopArc',  DrawScale, self, 'Arc1');
	if (Arc3 == None)
		class'bUtil'.static.InitMuzzleFlash(Arc3, class'HVPCMk66_TopArc',  DrawScale, self, 'Arc2');
}



simulated event RenderOverlays (Canvas C)
{
	local vector End, X,Y,Z;
	if (Spiral != None)
		Spiral.SetRelativeRotation(rot(0,0,1)*RotorSpin);


	Super.RenderOverlays(C);
	if (FreeZap != None)
	{
		GetViewAxes(X,Y,Z);
		FreeZap.SetLocation(ConvertFOVs(GetBoneCoords('tip').Origin, DisplayFOV, Instigator.Controller.FovAngle, 96));
		FreeZap.SetRotation(rotator(Vector(GetAimPivot()*0.5) >> Instigator.GetViewRotation()));
		End = X * 1000;
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset = class'BallisticEmitter'.static.VtoRV(End, End);
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.X.Min -= 500 * Abs(X.Z);
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.X.Max += 500 * Abs(X.Z);
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.Y.Min -= 500 * Abs(X.X);
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.Y.Max += 500 * Abs(X.X);
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.Z.Min -= 500 * (1-Abs(X.Z));
		BeamEmitter(FreeZap.Emitters[0]).BeamEndPoints[0].Offset.Z.Max += 500 * (1-Abs(X.Z));

		BeamEmitter(FreeZap.Emitters[2]).BeamEndPoints[0].Offset = class'BallisticEmitter'.static.VtoRV(End+vect(100,100,100), End-vect(100,100,100));

		C.DrawActor(FreeZap, false, false, Instigator.Controller.FovAngle);
	}
	if (GetTargetZap() != None)
	{
		GetTargetZap().bHidden = true;
		GetTargetZap().SetLocation(ConvertFOVs(GetBoneCoords('tip').Origin, DisplayFOV, Instigator.Controller.FovAngle, 96));
		GetTargetZap().UpdateTargets();
		C.DrawActor(GetTargetZap(), false, false, Instigator.Controller.FovAngle);
	}
}


// -----------------------------------------------
// Reload / Venting stuff
simulated function bool IsGoingToVent()
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);
	if (Anim == 'StartReload')
 		return true;
	return false;
}

exec simulated function Reload(optional byte i)
{
	if (!IsFiring())
		SafePlayAnim('StartReload', 1.0, 0.1);
}
simulated function Notify_LGArcOff()
{
	Instigator.AmbientSound = VentingSound;
	Instigator.SoundVolume = 128;
	if (Arc1 != None)
	{	Emitter(Arc1).Kill();	Arc1=None;	}
	if (Arc2 != None)
	{	Emitter(Arc2).Kill();	Arc2=None;	}
	if (Arc3 != None)
	{	Emitter(Arc3).Kill();	Arc3=None;	}
}
simulated event AnimEnd (int Channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

	if (Anim == 'StartReload')
	{
		if (level.NetMode == NM_Client)
			bIsVenting = true;
		ServerStartReload();
	}
	super.AnimEnd(Channel);
}
function ServerStartReload (optional byte i)
{
	if (!Instigator.IsLocallyControlled())
	{	Instigator.AmbientSound = VentingSound;
		Instigator.SoundVolume = 128;	}
	bIsVenting = true;
}
simulated function PlayIdle()
{
    if (bIsVenting)
		SafeLoopAnim('ReloadLoop', 0.5, IdleTweenTime, ,"IDLE");
	else
		super.PlayIdle();
}

exec simulated  function ReloadRelease(optional byte i)
{
    local name anim;
    local float frame, rate;

	if (!bCriticalHeat)
	{
		Instigator.AmbientSound = UsedAmbientSound;
		Instigator.SoundVolume = default.SoundVolume;
	}
	if (!bIsVenting)
	{
		GetAnimParams(0, anim, frame, rate);
		if (Anim != 'StartReload')
			return;
		SafePlayAnim('EndReload', 1.0, 0.2);
		if (frame < 0.5)
			SetAnimFrame(1-frame);
	}
	else
		SafePlayAnim('EndReload', 1.0, 0.2);

	if (level.NetMode == NM_Client)
		bIsVenting = false;
	ServerReloadRelease();
}
simulated function Notify_LGArcOn()
{
	if (AmmoAmount(0) > 0 && level.DetailMode>DM_Low)
		InitArcs();
}
function ServerReloadRelease(optional byte i)
{
	if (!Instigator.IsLocallyControlled())
	{
		if (!bCriticalHeat)
		{
		Instigator.AmbientSound = UsedAmbientSound;
		Instigator.SoundVolume = default.SoundVolume;
		}
	}
	bIsVenting = false;
}
// End Venting -----------------------------------

simulated function vector ConvertFOVs (vector InVec, float InFOV, float OutFOV, float Distance)
{
	local vector ViewLoc, Outvec, Dir, X, Y, Z;
	local rotator ViewRot;

	ViewLoc = Instigator.Location + Instigator.EyePosition();
	ViewRot = Instigator.GetViewRotation();
	Dir = InVec - ViewLoc;
	GetAxes(ViewRot, X, Y, Z);

    OutVec.X = Distance / tan(OutFOV * PI / 360);
    OutVec.Y = (Dir dot Y) * (Distance / tan(InFOV * PI / 360)) / (Dir dot X);
    OutVec.Z = (Dir dot Z) * (Distance / tan(InFOV * PI / 360)) / (Dir dot X);
    OutVec = OutVec >> ViewRot;

	return OutVec + ViewLoc;
}

simulated function Destroyed()
{
	if (FreeZap != None)
		FreeZap.Destroy();
	if (Arc1 != None)
		Arc1.Destroy();
	if (Arc2 != None)
		Arc2.Destroy();
	if (Arc3 != None)
		Arc3.Destroy();
	if (GlowFX != None)
		GlowFX.Destroy();
	if (ClawSpark1 != None)
		ClawSpark1.Destroy();
	if (ClawSpark2 != None)
		ClawSpark2.Destroy();
	if (Spiral != None)
		Spiral.Destroy();
	if (Instigator.AmbientSound == UsedAmbientSound || Instigator.AmbientSound == VentingSound || Instigator.AmbientSound == WarningSound)
	{
		Instigator.AmbientSound = None;
		Instigator.SoundVolume = Instigator.default.SoundVolume;
		Instigator.SoundPitch = Instigator.default.SoundPitch;
		Instigator.SoundRadius = Instigator.default.SoundRadius;
		Instigator.bFullVolume = Instigator.default.bFullVolume;
	}
	super.Destroyed();
}

// AI Interface =====
// Is reloading a good idea???
function bool BotShouldReload ()
{
	if ( (!bIsVenting) && (HeatLevel > 2) && (Level.TimeSeconds - AIController(Instigator.Controller).LastSeenTime > AIReloadTime) &&
		 (Level.TimeSeconds - Instigator.LastPainTime > AIReloadTime) )
		return true;
	return false;
}
// Makes a bot reload if they have the skill or its forced
// Allows clever bots to reload when they get the chance and dumb ones only when they have to
function bool BotReload(optional bool bForced)
{
	if (bForced || AIController(Instigator.Controller).Skill >= Rand(4))
	{
		Reload();
		return true;
	}
	return false;
}

// return false if out of range, can't see target, etc.
function bool CanAttack(Actor Other)
{
    local float Dist;
    local vector HitLocation, HitNormal, projStart;
    local actor HitActor;
    local int EC;
    local AIController B;
    local actor Victims;

    if ( (Instigator == None) || (Instigator.Controller == None) )
        return false;

    // check that target is within range
    Dist = VSize(Instigator.Location - Other.Location);
    if (Dist > FireMode[1].MaxRange())
	{
		BotReload();
        return false;
	}
    // check that can see target
    if (BotShouldReload() && !Instigator.Controller.LineOfSightTo(Other) && !IsGoingToVent())
	{
		BotReload();
        return false;
	}

	if (HeatLevel >= 10 && !IsGoingToVent())
	{
		BotReload();
        return false;
	}

	if (Instigator.PhysicsVolume.bWaterVolume)
	{
		B = AIController(Instigator.Controller);
		if (B != None && B.Skill >= Rand(4))
		{
			ForEach Instigator.PhysicsVolume.TouchingActors(class'Actor', Victims)
			{
				if (Pawn(Victims) != None)
				{
					Dist = VSize(Victims.location - Instigator.location);
					if (Dist > 1900)
						continue;
					if (level.Game.bTeamGame && Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller))
					{
						if (B.Skill >= Rand(4) && TeamGame(level.Game) != None && TeamGame(level.Game).FriendlyFireScale > 0.1)
							return false;
					}
					else
						EC += Min(1500, 2000 - Dist);
				}
			}
			if (EC < 1990)
				return false;
		}
	}
	if (bIsVenting && HeatLevel < 10 && AIController(Instigator.Controller).Skill >= Rand(5) && (Level.TimeSeconds - Instigator.LastPainTime < 0.5))
		ReloadRelease();
	if (bIsVenting && AIController(Instigator.Controller).Skill + Rand(2) >= HeatLevel)
		ReloadRelease();

    // check that would hit target, and not a friendly
	if (level.Game.bTeamGame)
	{
    	projStart = Instigator.Location + Instigator.EyePosition();
		HitActor = Trace(HitLocation, HitNormal, Other.Location + Other.CollisionHeight * vect(0,0,0.8), projStart, true);
    	if ( (HitActor == None) || (HitActor == Other) || (Pawn(HitActor) == None)
			|| (Pawn(HitActor).Controller == None) || !Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller) )
        	return true;
	    return false;
    }
   	return true;
}

// choose between regular or alt-fire
function byte BestMode()
{
	local Bot B;
	local float Result, Dist;
	local Controller C;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Rand(2);

	Dist = VSize(B.Enemy.Location - Instigator.Location);
	if (level.Game.bTeamGame && Rand(7) < B.Skill)
	{
		for (C=level.ControllerList;C!=None;C=C.nextController)
			if (Instigator.Controller.SameTeamAs(C) && C.Pawn != None && Normal(C.Pawn.Location - Instigator.Location) Dot Normal(B.Enemy.Location - Instigator.Location) > 0.75)
				return 1;
	}
	Result = FRand()-0.1;
	if (Instigator.PhysicsVolume.bWaterVolume)
	{
		if (B.Enemy.PhysicsVolume == Instigator.PhysicsVolume && Dist > 200)
			Result -= 0.5;
		else if (Dist < 200)
			Result += 0.4;
		if (Result > 0.5)
			return 1;
		return 0;
	}

	// Stubborn ass bots want to keep zapping
	if (NextChangeMindTime > level.TimeSeconds)
		return 0;

	if (HeatLevel > 5)
		Result -= 0.1 * B.Skill * ((HeatLevel-5)/5);
	if (Dist > 1150)
		Result += 0.08 * B.Skill;
	else if (Dist < 500)
		result -= 0.05 * B.Skill;
	if (VSize(B.Enemy.Velocity) < 100)
		Result += 0.3;
	Result += 0.4 * (FMax(0.0, Normal(B.Enemy.Velocity) Dot vector(Instigator.GetViewRotation())) * 2 - 1);

	if (Result > 0.5)
		return 1;
	NextChangeMindTime = level.TimeSeconds + 4;
	return 0;
}

function float GetAIRating()
{
	local Bot B;
	local float Result, Dist;
	local vector Dir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return Super.GetAIRating();

	Dir = B.Enemy.Location - Instigator.Location;
	Dist = VSize(Dir);

	Result = Super.GetAIRating();
	if (Instigator.PhysicsVolume.bWaterVolume)
		Result -= 0.15 * B.Skill;
	if (Dist > 1600)
	{
		Result -= (Dist-1360)/1500;
		if (B.Enemy.Weapon != None && B.Enemy.Weapon.bSniping)
			Result -= 0.08 * B.Skill;
	}
	else if (Dist > 1200)
		Result -= 0.15;
	if (B.Enemy.Weapon != None && B.Enemy.Weapon.bMeleeWeapon)
		Result += 0.07 * B.Skill;

	return Result;
}
// tells bot whether to charge or back off while using this weapon
function float SuggestAttackStyle()	{	return 0.5;	}
// tells bot whether to charge or back off while defending against this weapon
function float SuggestDefenseStyle()	{	return -0.5;	}
// End AI Stuff =====


simulated function Rotator CalcNewAimOffset()
{
	local rotator R;

	R = default.AimOffset;

	if (!BCRepClass.default.bNoJumpOffset && SprintControl != None && SprintControl.bSprinting)
		R += SprintOffset;

	return R;
}

defaultproperties
{
     VentingSound=Sound'BWBP2-Sounds.LightningGun.LG-Coolant'
     WarningSound=Sound'BWBP_SKC_Sounds.BFG.BFG-Critical'
     OverHeatSound=Sound'BWBP4-Sounds.Misc.BH-Explode'
     PrimaryWarningSound=Sound'BWBP2-Sounds.LightningGun.LG-OverHeat'
     PlayerSpeedFactor=0.650000
     PlayerJumpFactor=0.600000
     TeamSkins(0)=(RedTex=Shader'BallisticWeapons2.Hands.RedHand-Shiny',BlueTex=Shader'BallisticWeapons2.Hands.BlueHand-Shiny')
     UsedAmbientSound=Sound'BWBP2-Sounds.LightningGun.LG-Ambient'
     AIReloadTime=0.200000
     BigIconMaterial=Texture'BWBP_SKC_Tex.BFG.BigIcon_BFG'
     BCRepClass=Class'BallisticFix.BallisticReplicationInfo'
     InventorySize=70
     bWT_Hazardous=True
     bWT_Energy=True
     bWT_Super=True
     SpecialInfo(0)=(Info="600.0;80.0;1.0;100.0;0.5;0.8;5.0")
     BringUpSound=(Sound=Sound'BWBP_SKC_Sounds.XavPlas.Xav-Select',Volume=2.200000)
     PutDownSound=(Sound=Sound'BWBP2-Sounds.LightningGun.LG-Putaway',Volume=0.600000)
     bNoMag=True
     WeaponModes(1)=(bUnavailable=True,Value=4.000000)
     SightPivot=(Pitch=768)
     SightOffset=(X=-18.000000,Z=23.299999)
     SightDisplayFOV=40.000000
     CrosshairCfg=(Pic1=Texture'BallisticUI2.Crosshairs.M50Out',Pic2=Texture'BallisticUI2.Crosshairs.Misc4',USize2=256,VSize2=256,Color1=(G=248,R=0),Color2=(B=153,G=168,R=170,A=173),StartSize2=82)
     CrosshairInfo=(SpreadRatios=(X1=0.250000,Y1=0.375000,X2=1.000000,Y2=1.000000),MaxScale=3.000000)
     CrosshairChaosFactor=0.700000
     SprintOffSet=(Pitch=-3000,Yaw=-5000)
     AimAdjustTime=0.400000
     AimSpread=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
     ViewAimFactor=0.350000
     ViewRecoilFactor=0.450000
     ChaosSpeedThreshold=380.000000
     ChaosAimSpread=(X=(Min=-1100.000000,Max=1100.000000),Y=(Min=-1100.000000,Max=1100.000000))
     RecoilYawFactor=0.100000
     RecoilXFactor=0.300000
     RecoilYFactor=0.300000
     RecoilMax=256.000000
     RecoilDeclineTime=0.750000
     FireModeClass(0)=Class'BWBP_SKC_Fix.HVPCMk66PrimaryFire'
     FireModeClass(1)=Class'BWBP_SKC_Fix.HVPCMk66SecondaryFire'
     IdleAnimRate=1.200000
     PutDownTime=0.500000
     BringUpTime=0.500000
     AIRating=0.750000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="E-V Hyper Plasma Cannon 9000||Manufacturer: Nexron Defence|Primary: Super Plasma Charge|Secondary: Directed Plasma Pulse||[Document Begins - Details Classified] --- (--- ----- ------ ------) -- - ----- ---- ------- -- ---- --- ------ -- --- ---. ---- -- ------ -- --------- -- --------. ------ ---- ------ ------ --- --- -- - ------ -------- ------ -------------- --- - ---. ------- ----. ------- ----- -- - ----- --- --- ------- -- -------- ------ --- ----------. ---- ------- -- --- ---- ---------- --. ----- ---- -----. ---- - -- --------- ----- - ---------- --- -- -----. *[Info Removed]* Troops have been noted calling the (--- ----- ----- ------) a Big F-cking Gun."
     Priority=196
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross1"
     BallisticInventoryGroup=9
     InventoryGroup=0
     GroupOffset=11
     PickupClass=Class'BWBP_SKC_Fix.HVPCMk66Pickup'
     PlayerViewOffset=(X=-3.000000,Y=9.500000,Z=-9.500000)
     BobDamping=1.600000
     AttachmentClass=Class'BWBP_SKC_Fix.HVPCMk66Attachment'
     IconMaterial=Texture'BWBP_SKC_Tex.BFG.SmallIcon_BFG'
     IconCoords=(X2=127,Y2=31)
     ItemName="E-V Plasma Cannon 9000"
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=180
     LightSaturation=100
     LightBrightness=192.000000
     LightRadius=12.000000
     Mesh=SkeletalMesh'BWBP2b-Anims.Lighter'
     DrawScale=0.450000
     Skins(0)=Shader'BallisticWeapons2.Hands.Hands-Shiny'
     Skins(1)=Texture'BWBP_SKC_Tex.BFG.BFG-Skin'
     bFullVolume=True
     SoundVolume=64
     SoundRadius=128.000000
}
