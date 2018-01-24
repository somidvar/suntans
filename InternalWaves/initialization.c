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
		if (r == 1)
			for (k = 0; k < Nkmax; k++)
				dz[k] = depth / Nkmax;
		else if (r > 1 && r <= 1.1) {
			dz[0] = depth*(r - 1) / (pow(r, Nkmax) - 1);
			if (VERBOSE > 2) printf("Minimum vertical grid spacing is %.2f\n", dz[0]);
			for (k = 1; k < Nkmax; k++)
				dz[k] = r*dz[k - 1];
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
	//Sunatans default
	/*
	REAL Ls, xmid, Ds, D0;

	Ls = 30000;
	xmid = 100000;
	D0 = 3000;
	Ds = 200;
	return D0 - 0.5*(D0 - Ds)*(1 + tanh(4 * (x - xmid) / Ls));

	if (x <= xmid - Ls / 2)
		return D0;
	else if (x > xmid + Ls / 2)
		return Ds;
	else
		return D0 - (D0 - Ds)*((x - xmid) / Ls + 0.5);
	*/
	
	//Added by ----Sorush Omidvar---- when the shore is located at x=0.Start
	/*
	REAL ABath, BBath, CBath, DBath;
	ABath = 40;
    BBath = 0.0009;
    CBath = 1500;
    DBath = 35;
	return ABath*(tanh(-BBath*(-x + CBath))) + DBath;	
	*/
	//Added by ----Sorush Omidvar---- when the shore is located at x=0.End
	//Added by ----Sorush Omidvar---- when the shore is located at x=0.In this the shore side is extended by 1 Km and also the bathymetry is cut by Z=-10.Start
	REAL ABath, BBath, CBath, DBath;
	ABath = 40;
    BBath = 0.00009;
    CBath = 1500;
    DBath = 35;
	REAL Temporary=ABath*(tanh(-BBath*(-(x-1000) + CBath))) + DBath;
	if Temporary<10
		return 10;
	else
		return Temporary;
	//Added by ----Sorush Omidvar---- when the shore is located at x=0.In this the shore side is extended by 1 Km and also the bathymetry is cut by Z=-10.End
	
}

/*
 * Function: ReturnFreeSurface
 * Usage: grid->h[n]=ReturnFreeSurface(grid->xv[n],grid->yv[n]);
 * -------------------------------------------------------------
 * Helper function to create an initial free-surface. Used
 * in phys.c in the InitializePhysicalVariables function.
 *
 */
REAL ReturnFreeSurface(REAL x, REAL y, REAL d) {
	return 0;
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
	//Suntans default
	/*
	REAL deltaS, alphaS, D_pycnocline;

	deltaS = 0.024;
	alphaS = 0.0187;
	D_pycnocline = 20;

	if (z < -D_pycnocline)
		return deltaS*pow(-z, 0.0187);
	else
		return deltaS*pow(D_pycnocline, 0.0187);
	*/
	
	//Added by ----Sorush Omidvar----. Salinity stratification and front.Start
	REAL SalinityDifference,SalinityTemporary,FreshWater,SalinityMin,SalinityMax,SalinityVariation,DepthMax,SalinityCorrectionFactor;
	if(prop->SalinityAdjustmentFlag)
	{
		//Finding the maximum and minimum depth to find the asymptote
		DepthMax=ReturnDepth(prop->SpongeCellLocationX,prop->SpongeCellLocationY);
		SalinityMax=prop->ASal*(tanh(prop->BSal*(DepthMax -prop->CSal))) + prop->DSal;
		SalinityMin=prop->ASal*(tanh(prop->BSal*(0 -prop->CSal))) + prop->DSal;
		SalinityVariation=SalinityMax-SalinityMin;
		//Scale up or down the salinity variation
		SalinityCorrectionFactor=prop->SalinitySpecifiedRange/SalinityVariation;		
		//keeping min and max of salinity profile constant
		SalinityMax=SalinityCorrectionFactor*prop->ASal*(tanh(prop->BSal*(DepthMax -prop->CSal))) + prop->DSal;
		SalinityDifference=prop->SalinitySpecifiedMax-SalinityMax;
	}
	else
	{
		//No modification to profile salinity is made
		SalinityCorrectionFactor=1;
		SalinityDifference=0;
	}
	SalinityTemporary=SalinityCorrectionFactor*prop->ASal*(tanh(prop->BSal*(z -prop->CSal))) + prop->DSal;
	SalinityTemporary+=SalinityDifference;
	return SalinityTemporary;

	//Added by ----Sorush Omidvar----. Salinity stratification and front.End
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
	return 10;
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
