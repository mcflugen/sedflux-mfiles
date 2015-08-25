function map = cmap_sequential(initial_val,n)

n_bins = 3;

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
