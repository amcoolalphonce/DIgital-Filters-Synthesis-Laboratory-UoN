% NAME
% REGISTRATION NUMBER

% defining the numerator and denominators of the  s-plane
num_z = 2;
denom_z = [1 3 2];

% sampling time
T = 1;

[num_z, denom_z] = impinvar(num_s, denom_s, 1/T);
