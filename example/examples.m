% This script shows several examples, demonstrating how to use solver pathfollow.
clear;
clc;

%% Simple LP 
A = [1 1 -1  0;
     1 2  0 -1];
b = [ 3; 4];
c = [ 2; 1 ; 0; 0];

p = pathfollow(A,b,c);
p.solve;

%% Example on Randomly Generated Primal Nondegenrate LP
% This piece of code is from the book Linear Programming with Matalb
m = 5;
n = 8;

A = randn(m,n);

x = [rand(floor(n/2),1); zeros(n-floor(n/2),1)];
s = [zeros(floor(n/2),1); rand(n-floor(n/2),1)];

x = x(randperm(n));
s = s(randperm(n)); 

y = rand(m,1);

b = A*x; c=A'*y+s;

p = pathfollow(A,b,c);
p.solve;

%% Example from netlib (afiro)
load afiro
p = pathfollow(A,b,c);
p.solve;
