function map = grainsize(m,range)
% SANDSILTCLAY   sandsiltclay color map.
%    SANDSILTCLAY(M) returns an M-by-3 matrix containing a sandsiltclay
%    colormap.  SANDSILTCLAY, by itself, is the same length as the current
%    colormap.
% 
%    A SANDSILTCLAY colormap is especially useful for displaying sediment
%    properties such as grain size.  The colors vary from yellow, through
%    black, to blue.
%
%    For example, to reset the colormap of the current figure:
% 
%              colormap(sandsiltclay)
% 
%    See also GRAY, HOT, COOL, BONE, COPPER, PINK, FLAG, PRISM, JET,
%    COLORMAP, RGBPLOT, HSV2RGB, RGB2HSV, SEISMIC, STERNSPECIAL.
%

if nargin < 1
   m = size(get(gcf,'colormap'),1);
end

%r = [.9 1 .5 0 0];
%g = [.9 .5 0 0 0];
%b = [0 0 0 .5 1];

%r=interp1([1/m .25 .5 .75 1]*m,r,1:m);
%g=interp1([1/m .25 .5 .75 1]*m,g,1:m);
%b=interp1([1/m .25 .5 .75 1]*m,b,1:m);

% Another grain size colormap.
%
%r = [129 255 254 254 255 186 2 0 0 13]/255.;
%g = [0 0 107 172 255 165 219 208 129 0]/255.;
%b = [0 0 0 0 0 0 0 219 254 129]/255.;

r = [[128 255 255 255 255 128 0 0 0  0]/255.; ...
     [ -8  -6  -4  -2   0   2 4 6 8 10]];
g = [[  0   0  85 171 255 165 212 212 106  0]/255.; ...
     [ -8  -6  -4  -2   0   2   4   6   8 10]];
b = [[  0   0   0   0   0   0 0 255 255 128]/255.; ...
     [ -8  -6  -4  -2   0   2 4   6   8  10]];

r=interp1(r(2,:),r(1,:),linspace(range(1),range(2),m));
g=interp1(g(2,:),g(1,:),linspace(range(1),range(2),m));
b=interp1(b(2,:),b(1,:),linspace(range(1),range(2),m));

%f = .9*sin( [1:m]*.5*pi/m );
%r = r.*f;
%b = b.*f;

%r=interp1(linspace(1/m,m,length(r)),r,1:m);
%g=interp1(linspace(1/m,m,length(g)),g,1:m);
%b=interp1(linspace(1/m,m,length(b)),b,1:m);

map = [ r' g' b' ];
