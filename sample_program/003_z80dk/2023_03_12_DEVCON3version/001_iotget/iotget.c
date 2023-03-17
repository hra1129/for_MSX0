// --------------------------------------------------------------------
//	IOTGET for MSX0 (2023/3/12 DEVCON3 version)
//
//	ex)
//		analog_level = iotget( "sample/analog" );
// --------------------------------------------------------------------

#include <stdlib.h>
#include <string.h>

#define IOT_PORT	8

int iotget( const char *p_device_path ) {
	int i, l;
	unsigned char r[2];

	l = strlen( p_device_path );
	outp( IOT_PORT, 0xAC );
	outp( IOT_PORT, 1 );
	outp( IOT_PORT, l );
	for( i = 0; i < l; i++ ) {
		outp( IOT_PORT, *p_device_path );
		p_device_path++;
	}
	outp( IOT_PORT, 0xAB );
	r[0] = inp(IOT_PORT);
	r[1] = inp(IOT_PORT);
	return *((int*) r );
}
