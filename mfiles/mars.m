function map = mars(m)
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

%map = cmap_sequential ([.57 .42 .78],m);
%map = cmap_sequential ([18/360 .92 .72],m);
map = cmap_sequential ([.33 .9 .7],m);
map = hsv2rgb( map );

