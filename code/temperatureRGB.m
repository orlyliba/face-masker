function sRGB = temperatureRGB(temperature)
%
% Author: Tanner Helland, MATLAB Translator: Christopher Wells UCSD Fall 2014
%
% http://www.TannerHelland.com/4435/convert-temperature-rgb-algorithm-code/
%
% Start with a temperature, in Kelvin, somewhere between 1000 and 40000°K
% Note also that the temperature and color variables need to be declared
% as floating-point. The algorithm interpolates between three RGB curves.
%
% Mitchell Charity’s original Temperature (K) to RGB (sRGB) data appeared
% in the CIE 1964 10-degree CMFs in 100° K stepsize increments and scaled
% Temperature to Hundreds {100,200…1000, 1100,1200…2000,2100….40000}
%
% http://www.vendian.org/mncharity/dir3/blackbody/UnstableURLs/bbr_color.html
%
%
% Initialize Function Parameters
%
temperature = double(temperature / 100);
%
sRGB = [0,0,0];
%
red = 0; green = 0; blue = 0;
%
% Calculate RED:
%
%
if temperature <= 66, red = 255;    
else
    red = temperature - 60;
    red = 329.698727446 * (red ^ -0.1332047592);        
end
if red > 255, red = 255; end
if red < 0, red = 0; end
%
% Calculate GREEN:
%
if temperature <= 66    
    green = temperature;
    green = (99.4708025861 * reallog(green)) - 161.1195681661;        
else    
    green = temperature - 60;
    green = 288.1221695283 * (green ^ -0.0755148492);    
end
if green > 255, green = 255; end
if green < 0, green = 0; end
%
% Calculate BLUE:
%
if temperature >= 66, blue = 255;    
elseif temperature <= 19, blue = 0;    
else
    blue = temperature - 10;
    blue = (138.5177312231 * reallog(blue)) - 305.0447927307;    
end
if blue > 255, blue = 255; end
if blue < 0, blue = 0; end
%
% Return RGB Vector
%
sRGB = [red,green,blue];

end
%
% – Calculate temperature RGB
% – Loop through the image one pixel at a time. For each pixel:
% — Get RGB values
% — Calculate luminance of those RGB values (Luminance = (Max(R,G,B) + Min(R,G,B)) / 2)
% — Alpha-blend the RGB values with the temperature RGB values at the requested strength (max strength = 50/50 blend)
% — Calculate HSL equivalents for the newly blended RGB values
% — Convert those HSL equivalents back to RGB, but substitute the ORIGINAL luminance value (this maintains the luminance of the pixel)