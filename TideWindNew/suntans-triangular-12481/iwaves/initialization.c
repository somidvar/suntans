#include "math.h"
#include "fileio.h"
#include "suntans.h"
#include "initialization.h"

#define sech 1/cosh
/*
 * Function: GetDZ
 * Usage: GetDZ(dz,depth,Nkmax,myproc);
 * ------------------------------------
 * Returns the vertical grid spacing in the array dz.
 *
 */
int GetDZ(REAL *dz, REAL depth, REAL localdepth, int Nkmax, int myproc) {
	int k, status;
	REAL z = 0, dz0, r = GetValue(DATAFILE, "rstretch", &status);

	if (dz != NULL) {
			//printf("Depth=%f\n",depth);
		//fflush(stdout);
		if (r == 1)
			for (k = 0; k < Nkmax; k++)
				dz[k] = depth / Nkmax;
		else if (r > 1 && r <= 1.1) {
			dz[0] = depth*(r - 1) / (pow(r, Nkmax) - 1);
			if (VERBOSE > 2) printf("Minimum vertical grid spacing is %.2f\n", dz[0]);
			for (k = 1; k < Nkmax; k++)
				dz[k] = r*dz[k - 1];
		}
		else if (r == 2) {
			dz[0] = 1;
			if (VERBOSE > 2) printf("Minimum vertical grid spacing is %.2f\n", dz[0]);
			for (k = 1; k < Nkmax; k++)
				dz[k] = (depth-dz[0])/(Nkmax-1);
		}		
		else if (r > 2 && r <= 2.1) {
			dz[0] = 1.5;
			dz[1]=(depth-dz[0])*(r - 2) / (pow(r-1, Nkmax-1) - 1);
			if (VERBOSE > 2) printf("Minimum vertical grid spacing is %.2f\n", dz[0]);
			for (k = 2; k < Nkmax; k++)
				dz[k] = (r-1)*dz[k - 1];
		}
		else if (r > -1.1 && r < -1) {
			r = fabs(r);
			dz[Nkmax - 1] = depth*(r - 1) / (pow(r, Nkmax) - 1);
			if (VERBOSE > 2) printf("Minimum vertical grid spacing is %.2f\n", dz[Nkmax - 1]);
			for (k = Nkmax - 2; k >= 0; k--)
				dz[k] = r*dz[k + 1];
		}
		else {
			printf("Error in GetDZ when trying to create vertical grid:\n");
			printf("Absolute value of stretching parameter rstretch must  be in the range (1,1.1).\n");
			exit(1);
		}
	}
	else {
		r = fabs(r);
		if (r != 1)
			dz0 = depth*(r - 1) / (pow(r, Nkmax) - 1);
		else
			dz0 = depth / Nkmax;
		z = dz0;
		for (k = 1; k < Nkmax; k++) {
			dz0 *= r;
			z += dz0;
			if (z >= localdepth) {
				return k;
			}
		}
	}
}
  
/*
 * Function: ReturnDepth
 * Usage: grid->dv[n]=ReturnDepth(grid->xv[n],grid->yv[n]);
 * --------------------------------------------------------
 * Helper function to create a bottom bathymetry.  Used in
 * grid.c in the GetDepth function when IntDepth is 0.
 *
 */
REAL ReturnDepth(REAL x, REAL y) {
	//Loading southern Monterey bay bathymetry
	REAL RightMargine=5000;
	REAL DomainLength=50000;
	REAL p1,p2,p3,p4,p5,BathymetryDepth;
	
	if (x>DomainLength-(1+RightMargine))
		BathymetryDepth=5;
	else if(x>DomainLength-(300+RightMargine))
	{
		p1 = -1.4433e-05;
		p2 = -0.012306;
		p3 = -4.8887;
		BathymetryDepth=-(p1*pow(DomainLength-x-RightMargine,2)+p2*pow(DomainLength-x-RightMargine,1)+p3);
	}
	else if(x>DomainLength-(825+RightMargine))
	{
		p1 = 8.5851e-08;
		p2 = -0.00016189;
		p3 = 0.031162;
		p4 = -7.1766;
		BathymetryDepth=-(p1*pow(DomainLength-x-RightMargine,3)+p2*pow(DomainLength-x-RightMargine,2)+p3*pow(DomainLength-x-RightMargine,1)+p4);
	}
	else if(x>DomainLength-(1303+RightMargine))
	{
		p1 = -1.0463e-07;
		p2 = 0.00039446;
		p3 = -0.50792;
		p4 = 166.49;
		BathymetryDepth=-(p1*pow(DomainLength-x-RightMargine,3)+p2*pow(DomainLength-x-RightMargine,2)+p3*pow(DomainLength-x-RightMargine,1)+p4);
	}	
	else if(x>DomainLength-(5400+RightMargine))
	{
		p1 = 3.9769e-07;
		p2 = -0.0069956;
		p3 = -48.817;
		BathymetryDepth=-(p1*pow(DomainLength-x-RightMargine,2)+p2*pow(DomainLength-x-RightMargine,1)+p3);
	}
	else
		BathymetryDepth=75;
	return BathymetryDepth;
}

 /*
  * Function: ReturnFreeSurface
  * Usage: grid->h[n]=ReturnFreeSurface(grid->xv[n],grid->yv[n]);
  * -------------------------------------------------------------
  * Helper function to create an initial free-surface. Used
  * in phys.c in the InitializePhysicalVariables function.
  *
  */
REAL ReturnFreeSurface(REAL x, REAL y, REAL d, propT *prop) {
	REAL SurfaceElevationTemp=0;
	if (prop->K1TideAmplitude>0)
		SurfaceElevationTemp+=-0.37;
	if (prop->M2TideAmplitude>0)
		SurfaceElevationTemp+=-0.49;
	return SurfaceElevationTemp;
}

/*
 * Function: ReturnSalinity
 * Usage: grid->s[n]=ReturnSalinity(grid->xv[n],grid->yv[n],z);
 * ------------------------------------------------------------
 * Helper function to create an initial salinity field.  Used
 * in phys.c in the InitializePhysicalVariables function.
 *
 */
REAL ReturnSalinity(REAL x, REAL y, REAL z, propT *prop) {
	return (0.3977*tanh(0.4288*(-z-prop->PycnoclineDepth))+25)/1000;
}

/*
 * Function: ReturnTemperature
 * Usage: grid->T[n]=ReturnTemperaturegrid->xv[n],grid->yv[n],z);
 * ------------------------------------------------------------
 * Helper function to create an initial temperature field.  Used
 * in phys.c in the InitializePhysicalVariables function.
 *
 */
REAL ReturnTemperature(REAL x, REAL y, REAL z, REAL depth) {
	return 1;
}

/*
 * Function: ReturnHorizontalVelocity
 * Usage: grid->u[n]=ReturnHorizontalVelocity(grid->xv[n],grid->yv[n],
 *                                            grid->n1[n],grid->n2[n],z);
 * ------------------------------------------------------------
 * Helper function to create an initial velocity field.  Used
 * in phys.c in the InitializePhysicalVariables function.
 *
 */
REAL ReturnHorizontalVelocity(REAL x, REAL y, REAL n1, REAL n2, REAL z) {
	return 0;
}
REAL ReturnSediment(REAL x, REAL y, REAL z, int sizeno) {
	return 0;
}
REAL ReturnBedSedimentRatio(REAL x, REAL y, int layer, int sizeno, int nsize) {
	return 0;
}
