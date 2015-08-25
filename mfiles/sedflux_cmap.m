function map = sedflux_cmap(map)

if nargin < 1
   map = colormap
end

map (1,:) = [.7 .7 1.];
map (2,:) = [1. 1. 1.];
map (end,:) = [.7 .7 .7];

