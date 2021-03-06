clear all; close all; clc;
%% Implementation
tic
% Knot vector
Xi = [ 0 0 0 1 2 3 4 4 5 5 5];
% Xi = [ 0 0  1 2 3 4 5 5.5 6 6];
% Coordinates for B-spline
x = [0 1  2  2 4 5 2 1]';
y = [0 -1 -1 1 1 3 5 2]';
w = [1  1  1 2 3 1 5 1]';
% Number of knots
k = length(Xi);
% Number of coordinates
n = length(x);
% Order of basis
p = k-n-1;
fprintf('Time to load data: %2.2f seconds\n',toc); tic;
res = 300;

% Generate basis
[ R , U] = nrbasis_num( Xi, w,res );
fprintf('Time to generate basis: %2.2f seconds\n',toc); tic;

% Calculate B-spline curve
Cx = R'*x;
Cy = R'*y;
fprintf('Time to generate curve: %2.2f seconds\n',toc); tic;
%% Generate new Basis, with knot refinement
Pw = [x.*w y.*w w];
X = [ 4.5 ]; r = length(X)-1;
[Xi_bar,Qw] = RefineKnotVectCurve(length(x)-1,p,Xi,Pw,X,r);
qw = Qw(:,3);
Qw(:,1) = Qw(:,1)./qw;
Qw(:,2) = Qw(:,2)./qw;

% Calculate new curve
[ N2, U2 ] = nrbasis_num( Xi_bar, qw, res );
Cx2 = N2' * Qw(:,1);
Cy2 = N2' * Qw(:,2);
fprintf('Time to generate new basis and curve: %2.2f seconds\n',toc); tic;








%% Plot basis
figure(1)
plotNurbsBasis( R, U )
fprintf('Time to plot basis: %2.2f seconds\n',toc); tic;
%% PLot curve
figure()
plotNurbsCurve2D( Cx, Cy, Xi, U, x, y )
fprintf('Time to plot curve: %2.2f seconds\n',toc); tic;
title('Initial curve')
%% Plot basis
figure(3)
plotNurbsBasis( N2, U2 )
title('Refined basis')
%% Plot second curve
figure(4)
plotNurbsCurve2D( Cx2, Cy2, Xi_bar, U2, Qw(:,1), Qw(:,2) )
title('Refined curve')
fprintf('Time to plot new basis: %2.2f seconds\n',toc); tic;

%% Comparison
figure(5)
plot(Cx,Cy)
grid on
hold on
plot(x,y,':o')

plot(Cx2,Cy2,'r:')
grid on
hold on
plot(Qw(:,1),Qw(:,2),'r:o')
title('Comparison')