/*
 * File: sources.h
 * Author: Oliver B. Fringer
 * Institution: Stanford University
 * --------------------------------
 * Header file for sources.c.
 *
 * Copyright (C) 2005-2006 The Board of Trustees of the Leland Stanford Junior 
 * University. All Rights Reserved.
 *
 */
#ifndef _sources_h
#define _sources_h

#include "grid.h"
#include "phys.h"
#include "met.h"

REAL **v_coriolis;
REAL *rSponge;
REAL *SpongeCellDistance;//Added by ----Sorush Omidvar----
REAL *SpongeEdgeDistance;;//Added by ----Sorush Omidvar----
REAL CBoundaryVelocity,MinDepthBoundaryVelocity,MaxDepthBoundaryVelocity;;//Added by ----Sorush Omidvar----

void MomentumSource(REAL **usource, gridT *grid, physT *phys, propT *prop);
void HeatSource(REAL **A, REAL **B, gridT *grid, physT *phys, propT *prop, metT *met, int myproc, MPI_Comm comm);
void SaltSource(REAL **A, REAL **B, gridT *grid, physT *phys, propT *prop, metT *met);
void InitSponge(gridT *grid, int myproc, propT *prop);

#endif
