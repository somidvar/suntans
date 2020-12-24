/*
 * Boundaries test file.
 *
 */
#include "boundaries.h"
#include "sediments.h"
#include "initialization.h"
#include "stdlib.h"

/*
 * Function: OpenBoundaryFluxes
 * Usage: OpenBoundaryFluxes(q,ubnew,ubn,grid,phys,prop);
 * ----------------------------------------------------
 * This will update the boundary flux at the edgedist[2] to edgedist[3] edges.
 * 
 * Note that phys->uold,vold contain the velocity at time step n-1 and 
 * phys->uc,vc contain it at time step n.
 *
 * The radiative open boundary condition does not work yet!!!  For this reason c[k] is
 * set to 0
 *
 */
void OpenBoundaryFluxes(REAL **q, REAL **ub, REAL **ubn, gridT *grid, physT *phys, propT *prop) {
	int j, jptr, ib, k, forced;
	REAL *uboundary = phys->a, **u = phys->uc, **v = phys->vc, **uold = phys->uold, **vold = phys->vold;
	REAL z, c0, c1, C0, C1, dt = prop->dt, u0, u0new, uc0, vc0, uc0old, vc0old, ub0;

	for (jptr = grid->edgedist[2]; jptr < grid->edgedist[3]; jptr++) {
		j = grid->edgep[jptr];

		ib = grid->grad[2 * j];

		for (k = grid->etop[j]; k < grid->Nke[j]; k++)
			ub[j][k] = phys->boundary_u[jptr - grid->edgedist[2]][k] * grid->n1[j] +
			phys->boundary_v[jptr - grid->edgedist[2]][k] * grid->n2[j];
	}
}

/*
 * Function: BoundaryScalars
 * Usage: BoundaryScalars(boundary_s,boundary_T,grid,phys,prop);
 * -------------------------------------------------------------
 * This will set the values of the scalars at the open boundaries.
 * 
 */
void BoundaryScalars(gridT *grid, physT *phys, propT *prop, int myproc, MPI_Comm comm) {
	int jptr, j, ib, k;
	REAL z;

	for (jptr = grid->edgedist[2]; jptr < grid->edgedist[3]; jptr++) {
		//Commented by ----Sorush Omidvar----start
		j = grid->edgep[jptr];
		ib = grid->grad[2 * j];

		for (k = grid->ctop[ib]; k < grid->Nk[ib]; k++) {
			phys->boundary_T[jptr - grid->edgedist[2]][k] = phys->T[ib][k];
			phys->boundary_s[jptr - grid->edgedist[2]][k] = phys->s[ib][k];
		}
		//Commented by ----Sorush Omidvar----end
		if (prop->n == prop->nstart + 1)//Added by ----Sorush Omidvar----
			printf("Type-2 enabled without NETCDF in BoundaryScalars at %d.\n", jptr);//Added by ----Sorush Omidvar----
		fflush(stdout);
		/*
		int jind;
		jind = jptr - grid->edgedist[2];
		j = grid->edgep[jptr];
		ib = grid->grad[2 * j];
		//Added by ----Sorush Omidvar---- to get values for temperature and salinity at the boundary from initial condition. Start
		REAL CurrentDepth = 0;
		REAL ColumnDepth = ReturnDepth(grid->xe[jptr], grid->ye[jptr]);
		if (ib == -1)
		{
			printf("\n\nError. There is something wrong with the grid. Take a look at the boundaries.c\n\n\n");
			fflush(stdout);
			exit(11);
		}
		for (k = grid->ctop[ib]; k < grid->Nk[ib]; k++)
		{
			CurrentDepth += grid->dz[k] / 2;//getting the depth at the middle of the edge
			REAL TempDepth = CurrentDepth + (1 - CurrentDepth / ColumnDepth)*phys->h[ib];
			if (TempDepth < 0)
				TempDepth = 0;
			phys->boundary_T[jind][k] = ReturnTemperature(grid->xe[jptr], grid->ye[jptr], TempDepth, ColumnDepth);
			if (k == 275)
			{
				printf("k=%d\tCurrentDepth=%f\tTempDepth=%f\n", k, CurrentDepth, TempDepth);
				fflush(stdout);
			}
			phys->boundary_s[jind][k] = ReturnSalinity(grid->xe[jptr], grid->ye[jptr], TempDepth);
			CurrentDepth += grid->dz[k] / 2;//getting the depth at the middle of the edge
		}
		*/
		//Added by ----Sorush Omidvar---- to get values for temperature and salinity at the boundary from initial condition. End
	}
}

/*
 * Function: BoundaryVelocities
 * Usage: BoundaryVelocities(grid,phys,prop,myproc);
 * -------------------------------------------------
 * This will set the values of u,v,w, and h at the boundaries.
 * 
 */
void BoundaryVelocities(gridT *grid, physT *phys, propT *prop, int myproc, MPI_Comm comm) {
	int jptr, j, ib, k, boundary_index;
	REAL z, amp = prop->amp, rtime = prop->rtime, omega = prop->omega, boundary_flag;

	for (jptr = grid->edgedist[2]; jptr < grid->edgedist[3]; jptr++) {
		/* //Commented by ----Sorush Omidvar----start
	  j = grid->edgep[jptr];

	  ib = grid->grad[2*j];

	  for(k=grid->etop[j];k<grid->Nke[j];k++) {
		phys->boundary_u[jptr-grid->edgedist[2]][k]=prop->amp*sin(prop->omega*prop->rtime);
		phys->boundary_v[jptr-grid->edgedist[2]][k]=0;
		phys->boundary_w[jptr-grid->edgedist[2]][k]=0;
	  }*///Commented by ----Sorush Omidvar----end
		if (prop->n == prop->nstart + 1)//Added by ----Sorush Omidvar----
			printf("Type-2 enabled without NETCDF in BoundaryVelocities at=%d.\n", jptr);//Added by ----Sorush Omidvar----

		int jind;
		jind = jptr - grid->edgedist[2];
		j = grid->edgep[jptr];
		//Added by ----Sorush Omidvar---- to implement the tides at open boundaries considering the FrontTidesWindsDelay.start

		REAL WaterColumnHeight, HeightCorrectionFactor;
		int NeighbourCell;

		NeighbourCell = grid->grad[2 * j];
		if (NeighbourCell == -1)
			NeighbourCell = grid->grad[2 * j + 1];
		if (NeighbourCell == -1)
		{
			printf("\n\nError. There is something wrong with the grid at jptr=%d. Take a look at the boundaries.c\n\n\n", jptr);
			exit(11);
		}
		WaterColumnHeight = 0;
		for (k = 0; k < grid->Nkc[NeighbourCell]; k++)
			WaterColumnHeight += grid->dz[k];
		HeightCorrectionFactor = (WaterColumnHeight + phys->h[NeighbourCell]) / WaterColumnHeight;//To keep the velocity equal between ebb and flood
		
		//REAL UTides=prop->M2TideAmplitude*sin(2*PI/(12.42*3600)*prop->rtime);
		//if(prop->rtime>=prop->TidePhaseDifference)
			//UTides +=prop->K1TideAmplitude*sin(2*PI/(23.93*3600)*(prop->rtime-prop->TidePhaseDifference));
		
		REAL UTides,M2InitialPhaseLag,M2Period,K1Period;
		M2InitialPhaseLag=90;
		M2Period=12.4*3600;
		K1Period=23.9*3600;
		if (prop->rtime>=(360-M2InitialPhaseLag)*M2Period/360)
			UTides =prop->M2TideAmplitude*sin(2*PI/M2Period*(prop->rtime-(360-M2InitialPhaseLag)*M2Period/360));
		if (prop->rtime>=(360-prop->TidePhaseDifference)*K1Period/360)
			UTides +=prop->K1TideAmplitude*sin(2*PI/K1Period*(prop->rtime-(360-prop->TidePhaseDifference)*K1Period/360));
		
		UTides /= HeightCorrectionFactor;
		for (k = grid->etop[j]; k < grid->Nke[j]; k++)
		{
			phys->boundary_u[jind][k] = UTides * 1 * grid->n1[j];//For our model all of the N1 and N2 are negative
			phys->boundary_v[jind][k] = 0;
			phys->boundary_w[jind][k] = 0;
		}
		//Added by ----Sorush Omidvar---- to implement the tides at open boundaries considering the FrontTidesWindsDelay.end
	}
}

/*
 * Function: WindStress
 * Usage: WindStress(grid,phys,prop,myproc);
 * -----------------------------------------
 * Set the wind stress.
 *
 */
void WindStress(gridT *grid, physT *phys, propT *prop, metT *met, int myproc) {
	int j, jptr;
	REAL WindPeriod=24*3600;
	REAL ReductionFactor=-10000;
	if(prop->rtime<2*WindPeriod)
		ReductionFactor=1.0*prop->rtime/(WindPeriod*2.0);
	else
		ReductionFactor=1;
	for (jptr = grid->edgedist[0]; jptr < grid->edgedist[5]; jptr++) {
		j = grid->edgep[jptr];
		
		if (prop->rtime>=(360-prop->WindPhaseDifference)*WindPeriod/360)
			phys->tau_T[j] = grid->n1[j] * ReductionFactor*prop->tau_T*0.5*(1+sin(2*PI/WindPeriod*(prop->rtime-(360-prop->WindPhaseDifference)*WindPeriod/360)));
		phys->tau_B[j] = 0;
	}
}


void InitBoundaryData(propT *prop, gridT *grid, int myproc, MPI_Comm comm){}
void AllocateBoundaryData(propT *prop, gridT *grid, boundT **bound, int myproc, MPI_Comm comm){}
void BoundarySediment(gridT *grid, physT *phys, propT *prop) {}
