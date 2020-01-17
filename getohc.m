function ohc = getohc(temperature,depths,varargin)
% ohc = getohc(temperature,depths,varargin)
% Author: Casey R. Densmore
%
% This function calculates ocean heat content for an array of temperature
% (degC) and depth (m) values.
%
% Optional input arguments:
%   o refval: the reference temperature against which OHC is calculated 
%       (e.g. to calculate tropical cyclone heat potential for input 
%       temperatures in Celsius, set refval=26).
%       Default: 0 degC
%   o refdepth: a reference depth (m) above which OHC is calculated
%

temperature = temperature(:);
depths = depths(:);
refval = [];
refdepth = [];

%varargin- refval and refdepth
if nargin >= 4 %2 mandatory + at least 2 (key+value) optional inputs
    for n = 2:2:nargin-2
        key = varargin{n-1};
        value = varargin{n};
        
        switch(lower(key))
            case 'refval'
                if length(value) ~= 1 || ~isnumeric(value)
                    warning('Invalid argument passed for refval, ignoring this input')
                else
                    refval = value;
                end
            case 'refdepth'
                if length(value) ~= 1 || ~isnumeric(value)
                    warning('Invalid argument passed for refdepth, ignoring this input')
                else
                    refdepth = value;
                end
        end
    end
elseif nargin == 3
    warning('Key-value pairs must be entered to control optional arguments')
end

if isempty(refdepth)
    refdepth = max(depths);
end
if isempty(refval)
    refval = 0;
end

if depths(1) ~= 0
    depths = [0; depths];
    temperature = [temperature(1); temperature];
end

alldepths = 0:refdepth;

%gets temp and depth to degC isotherm
curtemperature = interp1(depths,temperature,alldepths,'linear',NaN);
curtemperature = curtemperature(curtemperature >= refval)-refval;

% OHC calculation- uses integral of temp to 26C isotherm, multiplied by rho ~1023 kg*m-3
% and cp ~ 4186 J*kg-1*K-1, converted from m2 to cm2 (factor of 1E-7), so
% constant = rho*cp*conversion = 1023*4186*1E-7 = 0.42823
ohc = 0.42823.*nansum(curtemperature); %OHC [kJ/cm^2]

end