/*
 * File: sources.c
 * Author: Oliver B. Fringer
 * Institution: Stanford University
 * --------------------------------
 * Right-hand sides for momentum and scalars, in the form rhs = dt*SOURCE at time step n.
 *
 * Copyright (C) 2005-2006 The Board of Trustees of the Leland Stanford Junior
 * University. All Rights Reserved.
 *
 */
#include "phys.h"
#include "sources.h"
#include "memory.h"
#include "sendrecv.h"
#include "math.h"
#include "initialization.h"

void MomentumSource(REAL **usource, gridT *grid, physT *phys, propT *prop) {
	int j, jptr, nc1, nc2, k;
	REAL Coriolis_f, ubar, depth_face;
	/* This is the sponge layer */
	/* MR Turned off - rSponge variable not initialized correctly!
	if(prop->sponge_distance) {
	  for(jptr=grid->edgedist[0];jptr<grid->edgedist[1];jptr++) {
		j = grid->edgep[jptr];

		nc1 = grid->grad[2*j];
		nc2 = grid->grad[2*j+1];

		ubar = 0;
		for(k=grid->etop[j];k<grid->Nke[j];k++) {
	  ubar += grid->dzf[j][k]*phys->u[j][k];
	  depth_face += grid->dzf[j][k];
		}
		ubar/=depth_face;

		for(k=grid->etop[j];k<grid->Nke[j];k++)
	  usource[j][k]-=prop->dt*exp(-4.0*rSponge[j]/prop->sponge_distance)/
		prop->sponge_decay*(phys->u[j][k]-ubar);
	  }
	}
	*/
	/* Coriolis for a 2d problem */
	
	//Added by ----Sorush Omidvar----. This is a replacement for the defult sponge layer. The sponge layer relax isohalines and velocity at the sea side.Start
	int EdgeCounter;
	if(SpongeCellDistance[0]!=SpongeCellDistance[0])
		printf("\n\n\nWarning. Initializing of sponge layer is needed.\n\n\n");

	if (prop->RadiationBoundary==1)
	{
		REAL CurrentDepth,RampFactor,SalinityTemporary, ThresholdVelocity,ThresholdSalinity;
		//It is suggested that ThresholdSalinity<ThresholdVelocity. In that way the salinity contour remain horizontal after propagation shoreward; otherwise vertical velocity can mess them since W and U should compensate
		ThresholdSalinity=0;
		ThresholdVelocity=0;
		int CellCounter, EdgeCounter;
		
		//Salinity relaxation at each cell
		for(CellCounter=0;CellCounter<grid->Nc;CellCounter++)
		{
			RampFactor=exp((-SpongeCellDistance[CellCounter]+prop->SpongeMean)/prop->SpongeSTD);
			if (RampFactor>=1-ThresholdSalinity)
				RampFactor=1;
			if(ThresholdSalinity>RampFactor)
				RampFactor=0;
			CurrentDepth=0;
			for(k=0;k<grid->Nk[CellCounter];k++)
			{			  
				CurrentDepth+=grid->dz[k]/2;
				//SUNTANS Default modified by ----Sorush Omidvar---- for the sake of simplicity
				SalinityTemporary=ReturnSalinity(grid->xv[CellCounter],grid->yv[CellCounter],CurrentDepth,prop);
				REAL SalinityDifference=SalinityTemporary-phys->s[CellCounter][k];
				phys->s[CellCounter][k]+=SalinityDifference*RampFactor;
				CurrentDepth+=grid->dz[k]/2;
			}
		}
		
		//Velocity relaxation at each edge
		for(EdgeCounter=0;EdgeCounter<grid->Ne;EdgeCounter++)
		{
			if(grid->n1[EdgeCounter]!=0)
			{			
				RampFactor=exp((-SpongeEdgeDistance[EdgeCounter]+prop->SpongeMean)/prop->SpongeSTD);
				if(RampFactor>=1-ThresholdVelocity)//Making the ramp factor 0 after a certain point
					RampFactor=1;
				else
					RampFactor=0;
				CurrentDepth=0;
				for(k=0;k<grid->Nkc[EdgeCounter];k++)
				{	
					REAL HorizontalDifference=0;
					HorizontalDifference+=grid->n1[EdgeCounter]*prop->DiurnalTideAmplitude*(1+sin((2*PI/prop->DiurnalTidePeriod)*prop->rtime))/2;//Making the Diurnal tide positive always
					HorizontalDifference+=grid->n1[EdgeCounter]*prop->SemiDiurnalTideAmplitude*(1+sin((2*PI/prop->SemiDiurnalTidePeriod)*prop->rtime))/2;//Making the Semi-Diurnal tide positive always
					if(prop->FrshFrontFlag)
					{
						CurrentDepth+=grid->dz[k]/2;
						if (CurrentDepth<=prop->CSal)
							HorizontalDifference+=grid->n1[EdgeCounter]*prop->ABoundaryVelocity*tanh(prop->BBoundaryVelocity*(CurrentDepth-prop->CSal));
						else
							HorizontalDifference+=grid->n1[EdgeCounter]*CBoundaryVelocity*tanh(prop->DBoundaryVelocity*(CurrentDepth-prop->CSal));
						CurrentDepth+=grid->dz[k]/2;
					}
					HorizontalDifference-=usource[EdgeCounter][k];
					usource[EdgeCounter][k]+=HorizontalDifference*RampFactor;
				}
			}
		}
	}
	//Added by ----Sorush Omidvar----. This is a replacement for the defult sponge layer. The sponge layer relax isohalines and velocity at the sea side.end
	if (prop->n == prop->nstart + 1) {
		printf("Initializing v Coriolis for a 2.5D simulation\n");
		fflush(stdout);
		v_coriolis = (REAL **)SunMalloc(grid->Ne * sizeof(REAL *), "MomentumSource");
		for (j = 0; j < grid->Ne; j++) {
			v_coriolis[j] = (REAL *)SunMalloc(grid->Nke[j] * sizeof(REAL), "MomentumSource");

			for (k = 0; k < grid->Nke[j]; k++)
				v_coriolis[j][k] = 0.0;
		}
	}
	//----Took out by -----Sorush Omidvar---- since the model is 2d.start
	/*
	// Hard-code coriolis here so that it can be zero in the main code
	Coriolis_f = 7.25e-5;

	for (jptr = grid->edgedist[0]; jptr < grid->edgedist[1]; jptr++) {
		j = grid->edgep[jptr];

		nc1 = grid->grad[2 * j];
		nc2 = grid->grad[2 * j + 1];

		for (k = grid->etop[j]; k < grid->Nke[j]; k++)
			usource[j][k] += prop->dt*Coriolis_f*(v_coriolis[j][k] * grid->n1[j] -
				InterpToFace(j, k, phys->uc, phys->u, grid)*grid->n2[j]);
	}

	for (jptr = grid->edgedist[0]; jptr < grid->edgedist[1]; jptr++) {
		j = grid->edgep[jptr];

		nc1 = grid->grad[2 * j];
		nc2 = grid->grad[2 * j + 1];

		for (k = grid->etop[j]; k < grid->Nke[j]; k++)
			v_coriolis[j][k] -= prop->dt*Coriolis_f*InterpToFace(j, k, phys->uc, phys->u, grid);
	}
	*/
	//----Took out by -----Sorush Omidvar---- since the model is 2d.end
}

/*
 * Function: HeatSource
 * Usage: HeatSource(grid,phys,prop,A,B);
 * --------------------------------------
 * Source terms for heat equation of the form
 *
 * dT/dt + u dot grad T = d/dz ( kappaT dT/dz) + A + B*T
 *
 * Assuming adiabatic top and bottom.  Horizontal advection is
 * explicit while all other terms use the theta method.
 *
 * Note that they must be set to zero if there is no heat
 * flux since these are temporary variables with values that may
 * be assigned elsewhere.
 *
 */
void HeatSource(REAL **A, REAL **B, gridT *grid, physT *phys, propT *prop, metT *met, int myproc, MPI_Comm comm) {
	int i, k;
	for (i = 0; i < grid->Nc; i++)
		for (k = 0; k < grid->Nk[i]; k++)
			A[i][k] = B[i][k] = 0;
}

/*
* Funtion: SaltSoutce
*/

void SaltSource(REAL **A, REAL **B, gridT *grid, physT *phys, propT *prop, metT *met) {
	int i, k;
	for (i = 0; i < grid->Nc; i++)
		for (k = 0; k < grid->Nk[i]; k++)
			A[i][k] = B[i][k] = 0;
}

/*
 * Function: InitSponge
 * Usage: InitSponge(grid,myproc);
 * -------------------------------
 * Apply a sponge layer to all type 2 boundaries.
 *
 */
void InitSponge(gridT *grid, int myproc, propT *prop) {
	int Nb, p1, p2, mark, g1, g2, k;
	int j, n, NeAll, NpAll;
	REAL *xb, *yb, *xp, *yp, r2;
	char str[BUFFERLENGTH];
	FILE *ifile;

	NeAll = MPI_GetSize(EDGEFILE, "InitSponge", myproc);
	NpAll = MPI_GetSize(POINTSFILE, "InitSponge", myproc);

	xp = (REAL *)SunMalloc(NpAll * sizeof(REAL), "InitSponge");
	yp = (REAL *)SunMalloc(NpAll * sizeof(REAL), "InitSponge");
	rSponge = (REAL *)SunMalloc(grid->Ne * sizeof(REAL), "InitSponge");
	
	SpongeCellDistance= (REAL *)SunMalloc(grid->Nc*sizeof(REAL),"InitSponge");//Added by ----Sorush Omidvar----
	SpongeEdgeDistance= (REAL *)SunMalloc(grid->Ne*sizeof(REAL),"InitSponge");//Added by ----Sorush Omidvar----	

	// Read in points on entire grid
	ifile = MPI_FOpen(POINTSFILE, "r", "InitSponge", myproc);
	for (j = 0; j < NpAll; j++) {
		xp[j] = getfield(ifile, str);
		yp[j] = getfield(ifile, str);
		getfield(ifile, str);
	}
	fclose(ifile);

	// Count number of nonzero boundary markers on entire grid
	ifile = MPI_FOpen(EDGEFILE, "r", "InitSponge", myproc);
	Nb = 0;
	for (j = 0; j < NeAll; j++) {
		fscanf(ifile, "%d %d %d %d %d", &p1, &p2, &mark, &g1, &g2);
		if (mark == 2 || mark == 3)
			Nb++;
	}
	fclose(ifile);

	xb = (REAL *)SunMalloc(Nb * sizeof(REAL), "InitSponge");
	yb = (REAL *)SunMalloc(Nb * sizeof(REAL), "InitSponge");

	n = 0;
	ifile = MPI_FOpen(EDGEFILE, "r", "InitSponge", myproc);
	for (j = 0; j < NeAll; j++) {
		fscanf(ifile, "%d %d %d %d %d", &p1, &p2, &mark, &g1, &g2);
		if (mark == 2 || mark == 3) {
			xb[n] = 0.5*(xp[p1] + xp[p2]);
			yb[n] = 0.5*(yp[p1] + yp[p2]);
			n++;
		}
	}
	fclose(ifile);
	
	//Added by ----Sorush Omidvar----. Initializing sponge cell and edge distance for each cells and edges. start
	if(myproc==0)
	{
		printf("Sponge Layer Cell Location X=%f, Y=%f\t\n",prop->SpongeCellLocationX,prop->SpongeCellLocationY);
		printf("Sponge Layer Edge Location X=%f, Y=%f\t\n",prop->SpongeEdgeLocationX,prop->SpongeEdgeLocationY);
		fflush(stdout);
	}
	
	int CellCounter;
	for(CellCounter=0;CellCounter<grid->Nc;CellCounter++)
	{
		SpongeCellDistance[CellCounter]=pow(prop->SpongeCellLocationX-grid->xv[CellCounter],2)+pow(prop->SpongeCellLocationY-grid->yv[CellCounter],2);
		SpongeCellDistance[CellCounter]=sqrt(SpongeCellDistance[CellCounter]);
	}
	int EdgeCounter;
	for(EdgeCounter=0;EdgeCounter<grid->Ne;EdgeCounter++)
	{
		SpongeEdgeDistance[EdgeCounter]=pow(prop->SpongeEdgeLocationX-grid->xe[EdgeCounter],2)+pow(prop->SpongeEdgeLocationY-grid->ye[EdgeCounter],2);
		SpongeEdgeDistance[EdgeCounter]=sqrt(SpongeEdgeDistance[EdgeCounter]);
	}
	//Added by ----Sorush Omidvar----. Initializing sponge cell and edge distance for each cells and edges. end
	//Added by ----Sorush Omidvar----. Calculating CBoundaryVelocity based on its analytical value derived by integrals.start
	if(prop->FrshFrontFlag)
	{
		MaxDepthBoundaryVelocity=0;
		for(k=0;k<grid->Nkmax;k++)
			MaxDepthBoundaryVelocity+=grid->dz[k];
		MinDepthBoundaryVelocity=grid->dz[0]/2;//getting the minimum depth at the center of the cell
		MaxDepthBoundaryVelocity-=grid->dz[grid->Nkmax-1]/2;//getting the maximum depth at the center of the cell

		CBoundaryVelocity=prop->ABoundaryVelocity*prop->DBoundaryVelocity/prop->BBoundaryVelocity;
		CBoundaryVelocity*=log(cosh(prop->BBoundaryVelocity*(MinDepthBoundaryVelocity-prop->CSal)));
		CBoundaryVelocity/=log(cosh(prop->DBoundaryVelocity*(MaxDepthBoundaryVelocity-prop->CSal)));	
		/*
		REAL FrontFlux1,FrontFlux2,CurrentDepth;
		CurrentDepth=0;
		FrontFlux1=0;
		FrontFlux2=0;
		for(k=0;k<grid->Nkmax;k++)
		{
			CurrentDepth+=grid->dz[k]/2;//getting the depth at the middle of the edge
			if (CurrentDepth<=prop->CSal)
				FrontFlux1+=prop->ABoundaryVelocity*tanh(prop->BBoundaryVelocity*(CurrentDepth-prop->CSal));
			else
				FrontFlux2+=CBoundaryVelocity*tanh(prop->DBoundaryVelocity*(CurrentDepth-prop->CSal));
			CurrentDepth+=grid->dz[k]/2;//getting the depth at the middle of the edge
		}
		
		if(prop->ABoundaryVelocity==0)
			CBoundaryVelocity=0;
		else
			CBoundaryVelocity*=fabs(FrontFlux1/FrontFlux2);//The net flux is not zero because CBoundaryVelocity is found in continuous world rather than a discrete one		
		*/
	}	
	//Added by ----Sorush Omidvar----. Calculating CBoundaryVelocity based on its analytical value derived by integrals.end
	
	// Now compute the minimum distance between the edge on the
	// local processor and the boundary and place this in rSponge.
	for (j = 0; j < grid->Ne; j++) {
		rSponge[j] = INFTY;

		for (n = 0; n < Nb; n++) {
			r2 = pow(xb[n] - grid->xe[j], 2) + pow(yb[n] - grid->ye[j], 2);
			if (r2 < rSponge[j])
				rSponge[j] = r2;
		}
		rSponge[j] = sqrt(rSponge[j]);
		//    printf("Processor %d: rSponge[%d]=%f\n",myproc,j,rSponge[j]);
	}
}