// --------------------------------------------------------------------
//	MSX0 test program
//	2023/3/18 t.hara (HRA!)
// --------------------------------------------------------------------

#include <stdio.h>
#include "iotget.h"

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {
	int analog_level;

	for(;;) {
		analog_level = iotget( "sample/analog" );
		printf( "ANALOG LV: %d\n", analog_level );
	}
	return 0;
}
