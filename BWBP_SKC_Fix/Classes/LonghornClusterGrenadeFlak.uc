//=============================================================================
// LonghornClusterGrenadeFlak.
//
// Small cluster bomb spawned from LonghornClusterGrenade. Fuse starts after first
// bounce. Causes little damage but lots of knockback.
//
// Split this off from the main grenade, this and its subclasses require
// different handling.
//
// by Casey "Xavious" Johnson and Azarael
// Copyright(c) 2012 Casey Johnson. All Rights Reserved.
//=============================================================================
class LonghornClusterGrenadeFlak extends BallisticGrenade;

var float                ZBonus;
var bool bDetonating;

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	
    Acceleration = Normal(Velocity) * AccelSpeed;
	
	if (Level.NetMode == NM_DedicatedServer)
		return;
		
	InitEffects();
	
	if ( Level.bDropDetail || Level.DetailMode == DM_Low )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC == None) || (Instigator == None) || (PC != Instigator.Controller) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated event Timer()
{
	if (StartDelay > 0)
	{
		StartDelay = 0;
		bHidden=false;
		SetPhysics(default.Physics);
		//SetCollision (default.bCollideActors, default.bBlockActors, default.bBlockPlayers);
		InitProjectile();
		//InitEffects();
		SetTimer(0.15, false);
		return;
	}
	if (HitActor != None)
	{
		if ( Instigator == None || Instigator.Controller == None )
			HitActor.SetDelayedDamageInstigatorController( InstigatorController );
		class'BallisticDamageType'.static.GenericHurt (HitActor, Damage, Instigator, Location, MomentumTransfer * (HitActor.Location - Location), MyDamageType);
	}
	
	if (bDetonating)
		Explode(Location, vect(0,0,1));
	
	else if (!bCollideActors)
		SetCollision(true,true,true);
}

simulated function InitProjectile ()
{
    local float r;
    
    r=((FRand()-0.50)*0.50)+1; // Lets make it a bit more random.
    DetonateDelay *= r;
    Speed*=r;
    
	Velocity = Speed * Vector(VelocityDir);
	if (RandomSpin != 0 && !bNoInitialSpin)
		RandSpin(RandomSpin);
	if (DetonateOn == DT_Timer)
		SetTimer(DetonateDelay, false);
}

simulated function InitEffects ()
{
	local Vector X,Y,Z;

	bDynamicLight=default.bDynamicLight; // Set up some effects, team colored
	if (Level.NetMode != NM_DedicatedServer && TrailClass != None && Trail == None)
	{
		GetAxes(Rotation,X,Y,Z);
		Trail = Spawn(TrailClass, self,, Location + X*TrailOffset.X + Y*TrailOffset.Y + Z*TrailOffset.Z, Rotation);
		if(LonghornGrenadeTrail(Trail) != None)
		{
			if(Instigator != None)
			{
				LonghornGrenadeTrail(Trail).SetupColor(Instigator.GetTeamNum());
			}
		}
		if (Emitter(Trail) != None)
			class'BallisticEmitter'.static.ScaleEmitter(Emitter(Trail), DrawScale);
		if (Trail != None)
			Trail.SetBase (self);
	}
}

simulated event ProcessTouch( actor Other, vector HitLocation )
{
	local float BoneDist;

	if (Other == Instigator && (!bCanHitOwner))
		return;
	if (Other == HitActor)
		return;
	if (Base != None)
		return;
		
	log("Entering ProcessTouch");
		
	// Should override complete ProcessTouch to prevent clusters from damaging the same player from impact multiple times within X time.
	if(Pawn(Other) != None)
	{
        Velocity *= 0.5; // Clusters don't bounce as far off of players
    	if (Pawn(Other).Physics == PHYS_Falling && Other != Instigator) // Bonus damage for hitting enemies in air
		   	class'BallisticDamageType'.static.GenericHurt (Other, ImpactDamage*0.5, Instigator, HitLocation, Velocity, ImpactDamageType);
	}

	if ( Instigator == None || Instigator.Controller == None )
		Other.SetDelayedDamageInstigatorController( InstigatorController );
	if (PlayerImpactType == PIT_Detonate || DetonateOn == DT_Impact)
	{
		class'BallisticDamageType'.static.GenericHurt (Other, ImpactDamage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType);
		HitActor = Other;
		Explode(HitLocation, Normal(HitLocation-Other.Location));
		return;
	}
	if ( PlayerImpactType == PIT_Bounce || (PlayerImpactType == PIT_Stick && (VSize (Velocity) < MinStickVelocity)) )
	{
		HitWall (Normal(HitLocation - Other.Location), Other);
		class'BallisticDamageType'.static.GenericHurt (Other, ImpactDamage, Instigator, HitLocation, Velocity, ImpactDamageType);
	}
	else if ( PlayerImpactType == PIT_Stick && Base == None )
	{
		SetPhysics(PHYS_None);
		if (DetonateOn == DT_ImpactTimed)
		{
			bDetonating=True;
			SetTimer(DetonateDelay, false);
		}
		HitActor = Other;
		if (Other != Instigator && Other.DrawType == DT_Mesh)
			Other.AttachToBone( Self, Other.GetClosestBone( Location, Velocity, BoneDist) );
		else
			SetBase (Other);
		class'BallisticDamageType'.static.GenericHurt (Other, ImpactDamage, Instigator, HitLocation, Velocity, ImpactDamageType);
		SetRotation (Rotator(Velocity));
		Velocity = vect(0,0,0);
	}

	if(Instigator != None && Instigator.GetTeamNum() == 1)
		LightHue = 160;
}

//as super except for bDetonating
simulated event HitWall(vector HitNormal, actor Wall)
{
    local Vector VNorm;

	if (DetonateOn == DT_Impact)
	{
		Explode(Location, HitNormal);
		return;
	}
	else if (DetonateOn == DT_ImpactTimed && !bHasImpacted)
	{
		bDetonating=True;
		SetTimer(DetonateDelay, false);
	}
	if (Pawn(Wall) != None)
	{
		DampenFactor *= 0.5;
		DampenFactorParallel *= 0.5;
	}

	bCanHitOwner=true;
	bHasImpacted=true;

    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

	if (RandomSpin != 0)
		RandSpin(100000);
	Speed = VSize(Velocity);
	if (Speed < 50 || (Velocity.Z < 8 && HitNormal.Z > 0.9))
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		if (Trail != None && !TrailWhenStill)
		{
			DestroyEffects();
		}
	}
	else if (Pawn(Wall) == None && (Level.NetMode != NM_DedicatedServer) && (Speed > 100) && (!Level.bDropDetail) && (Level.DetailMode != DM_Low) && EffectIsRelevant(Location,false))
	{
		if (ImpactSound != None)
			PlaySound(ImpactSound, SLOT_Misc );
		if (ImpactManager != None)
			ImpactManager.static.StartSpawn(Location, HitNormal, Wall.SurfaceType, Owner);
    }
}

simulated function TargetedHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation, Optional actor Victim )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir, NewMomentum;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) && Victims != Victim && Victims != HurtWall)
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
            NewMomentum = damageScale * Momentum * dir;
			class'BallisticDamageType'.static.GenericHurt
			(
				Victims,
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				NewMomentum,
				DamageType
			);
		}
	}
	bHurtEntry = false;
}

defaultproperties
{
	 bBlockActors=False
	 bBlockPlayers=False
	 bCollideActors=False
     bAlignToVelocity=True
     bDynamicLight=True
     bNoInitialSpin=False
     Damage=25.000000
     DamageRadius=300.000000
     DampenFactor=0.350000
     DampenFactorParallel=0.400000
     DetonateDelay=1.250000
     DetonateOn=DT_ImpactTimed
     DrawScale=0.500000
     ImpactDamage=9
     ImpactDamageType=Class'BWBP_SKC_Fix.DT_LonghornShotDirect'
     ImpactManager=Class'BWBP_SKC_Fix.IM_LonghornCluster'
     LifeSpan=20
     LightBrightness=32.000000
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightRadius=4.000000
     LightSaturation=192
     LightType=LT_Steady
     MomentumTransfer=15000.000000
     MotionBlurFactor=3.000000
     MotionBlurRadius=384.000000
     MotionBlurTime=1.000000
     MyDamageType=Class'BWBP_SKC_Fix.DT_LonghornShotRadius'
     MyRadiusDamageType=Class'BWBP_SKC_Fix.DT_LonghornShotRadius'
     RotationRate=(Roll=32768)
     ShakeRadius=512.000000
     Speed=550.000000
     SplashManager=Class'BallisticFix.IM_ProjWater'
     StaticMesh=StaticMesh'BWBP_SKC_StaticExp.Longhorn.ClusterProj'
     TrailClass=Class'BWBP_SKC_Fix.LonghornGrenadeTrailSmall'
}
