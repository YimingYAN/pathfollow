Infeasible Primal-dual Path-following IPM
--------
A **Matlab object-oriented** implementation of infeasible primal-dual path-following interior point method.

Author: Yiming Yan @ University of Edinburgh


Before you start
---------------------------------------------------------------------------
This is a demo version of the implementation
of infeasible primal-dual path-following ipm for Linear Programming.

The main solver pathfollow (/src/pathfollow.m) only accepts LP problems 
in the standard form, namely
```
        min c'*x 
        s.t. Ax = b, 
             x>=0.        
```

How to use
--------
run ```setup``` first to add necessary paths.

```p = pathfollow(A,b,c);```             Create an object.

```p = pathfollow(A,b,c, parameters);``` Create an object with user defined parameters.

```p.solve;```                           Solve the problem.

Examples
----------
Exmaples can be found in example/examples.m

References
---------------------------------------------------------------------------
1. Stephen Wright, Primal-Dual Interior-Point Method
2. Michael C. Ferris, Olvi L. Mangasarian, Stephen J. Wright, Linear Programming with Matlab




