#! octave-interpreter-name -qf
pkg load image
pkg load statistics

xDimension = 100;
yDimension = 500;
padding = 25;
global minWavelength = 400; # units of nm
global maxWavelength = 700; # units of nm
global numWavelengths = 3;

# the buffers we're writing to
global fieldImageWavelengths;

# write some stuff to the fieldImage
function drawLine( start, stop, wavelengthBin )

	global fieldImageWavelengths;
	offset = stop - start; # normalizing the offset vector
	length = sqrt( offset( 1 ) * offset( 1 ) + offset( 2 ) * offset( 2 ) );
	offset = ( offset ) ./ length;

	for i = 1:length
		# fraction = i / length;
		writeLoc = start + i * offset;
		fieldImageWavelengths( int32( writeLoc( 1 ) ), int32( writeLoc( 2 ) ), wavelengthBin ) += 1;
	endfor
end

function result = remap( value, low1, high1, low2, high2 )
	result = low2 + ( value - low1 ) * ( high2 - low2 ) / ( high1 - low1 );
end

function [ r, g, b ] = colorForWavelength( wavelength )
	# convert zucconi spectra code
end

function [ distance, normal ] = ( rayOrigin, rayDirection, sphereCenter, sphereRadius )
	
end

function shootRay( rayOrigin, rayDirection, rayWavelength )
	global minWavelength; # units of nm
	global maxWavelength; # units of nm
	global numWavelengths;

	# Ok, now they refract off the first surface, with wavelength dependent IoR
		# eventually want to add at least the schlick approximation for reflectance - now, we will consider it only as a refracted ray
	wavelengthBin = int32( floor( remap( rayWavelength, minWavelength, maxWavelength, 1, numWavelengths + 1 ) ) );
	drawLine( rayOrigin, rayOrigin + displacement, wavelengthBin );

	# refracted ray, intersecting with the second surface

end

# clear the sim field
fieldImageWavelengths = zeros( xDimension, yDimension, numWavelengths );

numSteps = 100;
raysPerStep = 100;
for steps = 1:numSteps
	# run the simulation for some number of rays
	for ray = 1:raysPerStep

		# what wavelength am I? 400nm to 700nm, visible light spectra
		rayWavelength = unifrnd( minWavelength, maxWavelength );

		# starting on the far left hand side, at a random point along the height
		point = [ unifrnd( padding, xDimension - padding ) 0 ];

		# do the computation for this generated ray
		shootRay( point, [ 0 1 ], wavelength );

	end
	printf( "\rStep %d of %d     ", steps, numSteps );
end

# create the output image
fieldImage = zeros( xDimension, yDimension, 3 );

# resolve the field image, from the wavelength bin histograms - some kind of vector mixing... yeah. tbd
# first things first, just 3 channel, matching

# determine cell with max total flux to scale the overall image accordingly
maxFlux = max( fieldImageWavelengths( : ) );

# need to compute the weighted output color, histogram times the corresponding colors for each frequency bin

fieldImage = fieldImageWavelengths ./ maxFlux;

# elementwise max of wavelengths bins, across the image... take the max of that... sum of that?

image( fieldImage );

# save out the fieldImage
# imwrite( fieldImage, 'test.png', 'png' );
printf( "Image Written.\n" );
# close all
