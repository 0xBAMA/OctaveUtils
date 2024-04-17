#! octave-interpreter-name -qf
pkg load image
pkg load statistics

xDimension = 1000;
yDimension = 1000;
channels = 3;

# the buffer we're writing to
global fieldImage;

# write some stuff to the fieldImage
function drawLine( start, startColor, stop, stopColor )
	global fieldImage;
	offset = stop - start; # normalizing the offset vector
	length = sqrt( offset( 1 ) * offset( 1 ) + offset( 2 ) * offset( 2 ) );
	offset = ( offset ) ./ length;

	for i = 1:length
		writeLoc = start + i * offset;

		fraction = i / length;
		interpolatedColor = ( startColor .* ( 1 - fraction ) ) +  ( stopColor .* fraction );

		fieldImage( int32( writeLoc( 1 ) ), int32( writeLoc( 2 ) ), 1 ) = interpolatedColor( 1 );
		fieldImage( int32( writeLoc( 1 ) ), int32( writeLoc( 2 ) ), 2 ) = interpolatedColor( 2 );
		fieldImage( int32( writeLoc( 1 ) ), int32( writeLoc( 2 ) ), 3 ) = interpolatedColor( 3 );
	endfor
end

# clear the image
fieldImage = zeros( xDimension, yDimension, channels );

# drawing some random lines
numLines = 1000
for i = 1:numLines
	points = unifrnd( 10, 990, 2, 2 );
	drawLine(
		points( 1, : ), [ 0, 0, 1 ],
		points( 2, : ), [ 0, 1, 1 ]
	);
	printf( "\r%d / %d          ", i, numLines );
endfor

imshow( fieldImage );

# save out the fieldImage
# imwrite( fieldImage, 'test.png', 'png' );
printf( "Image Written.\n" );
# close all
