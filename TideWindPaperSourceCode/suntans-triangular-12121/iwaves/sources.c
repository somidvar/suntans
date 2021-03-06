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
#include "math.h"
#include "initialization.h"
#include "stdlib.h"


void MomentumSource(REAL **usource, gridT *grid, physT *phys, propT *prop) {
	int j, jptr, nc1, nc2, k;
	REAL Coriolis_f, ubar, depth_face, RampFactor;
	/* This is the sponge layer */
	//--MR-- turned the sponge off, but it has been debugged, checked and backed online by ----Sorush Omidvar----
	if (!SpongeEdgeDistance || !SpongeCellDistance)
	{
		printf("\n\nError. Initializing of sponge layer is needed.\n\n\n");
		exit(10);
	}

	for (jptr = grid->edgedist[0]; jptr < grid->edgedist[1]; jptr++) {
		j = grid->edgep[jptr];

		ubar = 0;
		depth_face = 0;
		for (k = grid->etop[j]; k < grid->Nke[j]; k++) {
			ubar += grid->dzf[j][k] * phys->u[j][k];
			depth_face += grid->dzf[j][k];
		}
		ubar /= depth_face;
		//RampFactor=prop->dt*exp(-4.0*SpongeEdgeDistance[j]/prop->sponge_distance)/prop->sponge_decay//Default sponge and changed by ----Sorush Omidvar----

		RampFactor = 0.5*exp(-SpongeEdgeDistance[j]);
		if (RampFactor<0.0001)
			RampFactor=0;
		for (k = grid->etop[j]; k < grid->Nke[j]; k++)
			usource[j][k] -= RampFactor*(phys->u[j][k] - ubar);
	}
	/*
	  //Added by ----Sorush Omidvar----. This is a replacement for the defult sponge layer. The sponge layer relax isohalines and velocity at the sea side.Start


	  REAL ColumnDepth,CurrentDepth,RampFactor,SalinityTemporary,ThresholdSalinity;
	  ThresholdSalinity=0.01;
	  int CellCounter, EdgeCounter;

	  //Salinity relaxation at each cell

	  for(CellCounter=0;CellCounter<grid->Nc;CellCounter++)
	  {
		  RampFactor=exp((-SpongeCellDistance[CellCounter]+0)/(prop->sponge_distance));
		  if (RampFactor>=1-ThresholdSalinity)//Making the ramp factor 1 after a certain point
			  RampFactor=1;
		  ColumnDepth=ReturnDepth(grid->xv[CellCounter],grid->yv[CellCounter]);
		  CurrentDepth=0;
		  for(k=0;k<grid->Nk[CellCounter];k++)
		  {
			  CurrentDepth+=grid->dz[k]/2;
			  REAL TempDepth=CurrentDepth+(1-CurrentDepth/ColumnDepth)*phys->h[CellCounter];
			  if (TempDepth<0)
				  TempDepth=0;
			  SalinityTemporary=ReturnSalinity(grid->xv[CellCounter],grid->yv[CellCounter],TempDepth);
			  REAL SalinityDifference=SalinityTemporary-phys->s[CellCounter][k];
			  phys->s[CellCounter][k]+=SalinityDifference*RampFactor;
			  CurrentDepth+=grid->dz[k]/2;
		  }
	  }
	  //Added by ----Sorush Omidvar----. This is a replacement for the defult sponge layer. The sponge layer relax isohalines and velocity at the sea side.end
	*/
	/* Coriolis for a 2d problem */
	if (prop->n == prop->nstart + 1) {
		printf("Initializing v Coriolis for a 2.5D simulation\n");
		v_coriolis = (REAL **)SunMalloc(grid->Ne * sizeof(REAL *), "MomentumSource");
		for (j = 0; j < grid->Ne; j++) {
			v_coriolis[j] = (REAL *)SunMalloc(grid->Nke[j] * sizeof(REAL), "MomentumSource");

			for (k = 0; k < grid->Nke[j]; k++)
				v_coriolis[j][k] = 0.0;
		}
	}

	// Hard-code coriolis here so that it can be zero in the main code
	Coriolis_f = 8.67e-5;

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
void InitSponge(gridT *grid, int myproc) {
	int Nb, p1, p2, mark, g1, g2;
	int j, n, NeAll, NpAll;
	REAL *xb, *yb, *xp, *yp, r2;
	char str[BUFFERLENGTH];
	FILE *ifile;

	NeAll = MPI_GetSize(EDGEFILE, "InitSponge", myproc);
	NpAll = MPI_GetSize(POINTSFILE, "InitSponge", myproc);

	xp = (REAL *)SunMalloc(NpAll * sizeof(REAL), "InitSponge");
	yp = (REAL *)SunMalloc(NpAll * sizeof(REAL), "InitSponge");
	rSponge = (REAL *)SunMalloc(grid->Ne * sizeof(REAL), "InitSponge");

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
	//Added by ----Sorush Omidvar----. Initializing sponge cell and edge distance for each cells and edges. start
	SpongeCellDistance = (REAL *)SunMalloc(grid->Nc * sizeof(REAL), "InitSponge");//Added by ----Sorush Omidvar----
	SpongeEdgeDistance = (REAL *)SunMalloc(grid->Ne * sizeof(REAL), "InitSponge");//Added by ----Sorush Omidvar----	

	REAL SpongeXCenterLocationLeft,SpongeXCenterLocationRight, SpongeYCenterLocation;
	SpongeXCenterLocationLeft = 3000;
	SpongeXCenterLocationRight=48000;
	SpongeYCenterLocation = 0;
	if (myproc == 0)
	{
		printf("Sponge Layer Edge Location X=%f, Y=%f\t\n", SpongeXCenterLocationLeft, SpongeYCenterLocation);
		printf("Sponge Layer Edge Location X=%f, Y=%f\t\n", SpongeXCenterLocationRight, SpongeYCenterLocation);
		fflush(stdout);
	}
	int CellCounter;
	for (CellCounter = 0; CellCounter < grid->Nc; CellCounter++)
	{
		SpongeCellDistance[CellCounter] = pow(SpongeXCenterLocationLeft - grid->xv[CellCounter], 2);
		SpongeCellDistance[CellCounter] = sqrt(SpongeCellDistance[CellCounter]);

	}
	int EdgeCounter;
	for (EdgeCounter = 0; EdgeCounter < grid->Ne; EdgeCounter++)
	{
		if (grid->xe[EdgeCounter] < SpongeXCenterLocationLeft)
			SpongeEdgeDistance[EdgeCounter] = 0;
		else if (grid->xe[EdgeCounter]>SpongeXCenterLocationRight)
			SpongeEdgeDistance[EdgeCounter] = 0;
		else
		{
			if(grid->xe[EdgeCounter]-SpongeXCenterLocationLeft>SpongeXCenterLocationRight-grid->xe[EdgeCounter])
				SpongeEdgeDistance[EdgeCounter] =(SpongeXCenterLocationRight- grid->xe[EdgeCounter])/ 800;
			else
				SpongeEdgeDistance[EdgeCounter] = (grid->xe[EdgeCounter] - SpongeXCenterLocationLeft)/ 3200;
		}
	}
	//Added by ----Sorush Omidvar----. Initializing sponge cell and edge distance for each cells and edges. end 
}