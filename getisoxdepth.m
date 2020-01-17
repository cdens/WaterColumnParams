
function depth = getisoxdepth(var,depth,isoval,varargin)
% depth = getisoxdepth(var,depth,isoval,varargin)
% Author: Casey R. Densmore
%
% This function determines an isox depth (e.g. isotherm, isopycnal,
% isohaline) given input arrays of some variable (var, e.g. temperature)
% and depth, and an isox value specified by isoval.
%
% For example, given arrays temperature and depth, the 26 degree isotherm
% could be determined with isot_26C = getisoxdepth(temperature,depth,26)
%
% Optional input arguments:
%   o depthrange: a 2-value array that specifies limiting depths for
%       interpolation (e.g. monthrange=[0,200] only looks for isovalues
%       between the surface and 200m
%

if length(depth) ~= length(var)
    error('Input arrays must be matching lengths!')
end

depth = depth(:);
var = var(:);

%default is empty, whole profile
depthrange = [];

if nargin >= 5 %3 mandatory + at least 2 (key+value) optional inputs
    for n = 2:2:nargin-3
        key = varargin{n-1};
        value = varargin{n};
        
        switch(lower(key))
            case 'depthrange'
                if length(value) ~= 2 || ~isnumeric(value)
                    warning('Invalid argument passed for depthrange, ignoring this input')
                else
                    depthrange = value;
                end
        end
    end
end


if isnan(nanmean(var))
    depth = NaN;
else
    
    %remove NaN and Inf
    ind = find(~isnan(var) & ~isinf(var));
    var = var(ind);
    depth = depth(ind);
    
    %apply depth constraints if applicable
    if ~isempty(depthrange)
        ind = find(depth >= depthrange(1) & depth <= depthrange(2));
        newdepth = depth(ind);
        newvar = var(ind);
        
        %interpolate to get exact boundaries if they don't exist
        if newdepth(1) ~= depthrange(1)
            newdepth = [depthrange(1);newdepth];
            newvar = [interp1(depth,var,depthrange(1),'linear',NaN);newvar];
        end
        if newdepth(end) ~= depthrange(2)
            newdepth = [newdepth;depthrange(2)];
            newvar = [newvar;interp1(depth,var,depthrange(2),'linear',NaN)];
        end
        
        %save variables, remove NaNs again
        depth = newdepth;
        var = newvar;
        ind = find(~isnan(var));
        var = var(ind);
        depth = depth(ind);
    end
    
    %get unique values for interpolation
    [unique_values,uninds] = unique(var);
    undepths = depth(uninds);
    
    %interpolate
    if length(unique_values) > 1
        try
            depth = interp1(unique_values,undepths,isoval,'linear',NaN);
        catch %catches if the variable can't be interpolated
            error('Unable to interpolate depth: If this value is crossed at multiple depths, try specifying a range of depths to examine with the optional depthrange input')
        end
    else
        warning('Only one unique value for specified depths! IsoX-depth may be inaccurate')
        depth = undepths;
    end
end
end