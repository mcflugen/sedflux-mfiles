function map = grainsize(m)
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

% Another grain size colormap.
%
r = [129 255 254 254 255 186   2   0   0  13]/255.;
g = [  0   0 107 172 255 165 219 208 129   0]/255.;
b = [  0   0   0   0   0   0   0 219 254 129]/255.;

range = [4.5 7.5];
phe = linspace(range(1), range(2), m);
r = [0 0]/255;
g = [212 212]/255;
b = [0 255]/255;

r=interp1(linspace(1/m,m,length(r)),r,1:m);
g=interp1(linspace(1/m,m,length(g)),g,1:m);
b=interp1(linspace(1/m,m,length(b)),b,1:m);

r = [[  0 192 192 0]/255; ...
     [  4   5   6 8]];
g = [[212 128 128 212]/255; ...
     [  4   6   7   8]];
b = [[  0 128 128 255]/255; ...
     [  4 5.5 6.5 8]];

r=interp1(r(2,:),r(1,:),linspace(range(1),range(2),m));
g=interp1(g(2,:),g(1,:),linspace(range(1),range(2),m));
b=interp1(b(2,:),b(1,:),linspace(range(1),range(2),m));

map = [ r' g' b' ];

map = makeColorMap([64 212 64], [192 128 0], [0 212 255],m)/255;

hsv_sand = [.16 .2 .7];
hsv_silt = [.33 .9 .7];
hsv_clay = [.6  .9 .7];

%map = [ makeHSVSequentialMap([.0 .8 .7],m/5); ...
%        makeHSVSequentialMap([.108 .9 .7],m/5); ...
%        makeHSVSequentialMap( hsv_sand, m/5); ...
%        makeHSVSequentialMap( hsv_silt, m/5); ...
%        makeHSVSequentialMap( hsv_clay, m/5); ];

n = floor(m/3);

%        makeHSVSequentialMap([.108 .9 .7],n); ...
map = [ ...
        makeHSVSequentialMap( hsv_sand, n); ...
        makeHSVSequentialMap( hsv_silt, n); ...
        makeHSVSequentialMap( hsv_clay, n); ...
      ];

map = hsv2rgb(map);

function map = makeHSVSequentialMap(initial_val,n)

n_bins = 6;

h = initial_val(1)*ones(1,n);

s = linspace(initial_val(2),.3,n_bins);
s = repmat(s, ceil(n/n_bins), 1 );
s = s(1:n);

%s = [.9 .75 .6 .45 .3];
%s = [.3 .45 .6 .75 .9];
%s = interp1(linspace(1,n,n_bins),s,1:n,'nearest');

v = linspace(initial_val(3),1,n_bins);
v = repmat(v, ceil(n/n_bins), 1 );
v = v(1:n);

%v = [.6 .7 .8 .9 1.];
%v = [1 .9 .8 .7 .6];
%v = interp1(linspace(1,n,n_bins),v,1:n,'nearest');

map = [h' s' v'];

