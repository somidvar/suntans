clear all
close all
clc

dirname='D:';
fname='s.dat';
component=3;
type='s';
numprocs=1;
nstep=601;
Nkmax=100;
Nc=200;
i=1;
VERBOSE=0;
repeats=0;

cd('d:\github\suntans\mfiles\');
readalldata(dirname,fname,component,type,numprocs,nstep,Nkmax,Nc,i,repeats,VERBOSE)