function map = atlas(m)
% ATLAS   atlas color map.
%    ATLAS(M) returns an M-by-3 matrix containing an atlas colormap.
%    ATLAS, by itself, is the same length as the current colormap.
% 
%    An ATLAS colormap is especially useful for displaying topographic
%    elevations.  The colors vary from green, to yellow, to reddish brown,
%    to white.
%
%    For example, to reset the colormap of the current figure:
% 
%              colormap(atlas)
% 
%    See also GRAY, HOT, COOL, BONE, COPPER, PINK, FLAG, PRISM, JET,
%    COLORMAP, RGBPLOT, HSV2RGB, RGB2HSV, SEISMIC, STERNSPECIAL.
%

if nargin < 1
   m = size(get(gcf,'colormap'),1);
end

if ( m<=0 )
   map = [];
   return;
end

r = [ .0625 .8 .3804 .8];
g = [ .2706 .8 .0824 .8];
b = [ .0625 .4 .0510 .8];

method = 'linear';

if ( m<4 )
   r = r(1:m);
   g = g(1:m);
   b = b(1:m);
else
   r=interp1([1/m 1/3 2/3 1]*m,r,1:m,method);
   g=interp1([1/m 1/3 2/3 1]*m,g,1:m,method);
   b=interp1([1/m 1/3 2/3 1]*m,b,1:m,method);
end

map = [ r' g' b' ];

map( map>1 ) = 1;
map( map<0 ) = 0;

r = [ 70 120 146 198 250 150 252 252 253]/255;
g = [120 100 126 178 230 234 238 243 249]/255;
b = [ 50  50  60  80 100 126 152 177 216]/255;

r = interp1 (linspace(1/m,m,length(r)),r,1:m);
g = interp1 (linspace(1/m,m,length(g)),g,1:m);
b = interp1 (linspace(1/m,m,length(b)),b,1:m);

map = [ r' g' b' ];
