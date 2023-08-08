function result = toSI(value,dimension)
%toSI Convert to the International System of Units
%   Velocity, angular velocity, torque
if (dimension == "vel") result=value/3.6;end % m/s
if (dimension == "angvel") result=value*(2*pi)/60;end % rad/s
if (dimension == "torque") result=value*0.0980665;end % nm
if (dimension == "lb") result=value/2.20462;end % nm
end