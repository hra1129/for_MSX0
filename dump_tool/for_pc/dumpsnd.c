// --------------------------------------------------------------------
//	DUMPRCV.COM for MSX0 向けに送りつけるテキストファイルを作るツール
// ====================================================================
//	2023/3/20	t.hara(HRA!)
// --------------------------------------------------------------------

#include <stdio.h>
#include <malloc.h>
#include <ctype.h>

// --------------------------------------------------------------------
unsigned char *get_file_image( const char *p_in_name, int *p_file_size ) {
	unsigned char *p_image;
	FILE *p_in;

	p_in = fopen( p_in_name, "rb" );
	if( p_in == NULL ) {
		fprintf( stderr, "[ERROR] Cannot open the file [%s].\n", p_in_name );
		exit(1);
	}
	fseek( p_in, 0, SEEK_END );
	*p_file_size = (int) ftell( p_in );
	fseek( p_in, 0, SEEK_SET );
	p_image = (unsigned char*) malloc( *p_file_size );
	if( p_image == NULL ) {
		fprintf( stderr, "[ERROR] Not enough memory.\n" );
		exit(1);
	}
	fread( p_image, 1, *p_file_size, p_in );
	fclose( p_in );
	return p_image;
}

// --------------------------------------------------------------------
void put_file_name( FILE *p_out, const char *p_in_name ) {
	int l, p, total_len;

	for( l = 0; l < 8; l++ ) {
		if( p_in_name[l] == '.' || p_in_name[l] == '\0' ) {
			break;
		}
		if( isdigit( p_in_name[l] ) || isalpha( p_in_name[l] ) || p_in_name[l] == '_' ) {
			fputc( p_in_name[l], p_out );
		}
		else {
			fprintf( stderr, "[ERROR] Invalid input file name.\n" );
			exit(1);
		}
	}
	total_len = l;
	for( ; p_in_name[l] != '.' && p_in_name[l] != '\0'; l++ ) {
	}
	if( p_in_name[l] == '.' ) {
		l++;
	}
	p = l;
	for( l = 0; l < 3; l++ ) {
		if( isdigit( p_in_name[p+l] ) || isalpha( p_in_name[p+l] ) || p_in_name[p+l] == '_' ) {
			fputc( p_in_name[p+l], p_out );
		}
		else {
			fprintf( stderr, "[ERROR] Invalid input file name.\n" );
			exit(1);
		}
	}
	total_len += l;
	if( total_len < (8 + 3) ) {
		fputc( ':', p_out );
	}
}

// --------------------------------------------------------------------
void convert_file_image( const char *p_out_name, const char *p_in_name, int file_size, unsigned char *p_image ) {
	FILE *p_out;
	int d, l, p;

	p_out = fopen( p_out_name, "wb" );
	if( p_out == NULL ) {
		fprintf( stderr, "[ERROR] Cannot create the file [%s].\n", p_out_name );
		exit(1);
	}
	//	ファイル名
	put_file_name( p_out, p_in_name );
	//	中身
	for( p = 0; p < file_size; ) {
		d = p_image[p];
		for( l = 1; l < 256 && p < file_size && p_image[p + l] == d; l++ ) {
		}
		if( l > 2 ) {
			//	ランレングス
			fprintf( p_out, "r%02X%02X", d, l & 255 );
			p += l;
		}
		else {
			fprintf( p_out, "%02X", d );
			p++;
		}
	}
	fclose( p_out );
}

// --------------------------------------------------------------------
void dump_snd( const char *p_in_name, const char *p_out_name ) {
	int file_size;
	unsigned char *p_image;

	p_image = get_file_image( p_in_name, &file_size );
	convert_file_image( p_out_name, p_in_name, file_size, p_image );
}

// --------------------------------------------------------------------
static void usage( const char *p_name ) {

	fprintf( stderr, "Usage> %s <input_file> <output.txt>\n", p_name );
}

// --------------------------------------------------------------------
int main( int argc, char *argv[] ) {

	printf( "DUMPSND.EXE\n" );
	printf( "2023/3/20 t.hara(HRA!)\n" );

	if( argc != 3 ) {
		usage( argv[0] );
		exit(1);
	}
	dump_snd( argv[1], argv[2] );
	printf( "Completed.\n" );
	return 0;
}
