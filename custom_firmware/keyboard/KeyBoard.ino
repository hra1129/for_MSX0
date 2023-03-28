// --------------------------------------------------------------------
//	M5stack faces keyboard custom firmware
// ====================================================================
//	2023/3/23 modified by t.hara (HRA!)
// --------------------------------------------------------------------

#include <Wire.h>

#define FACES_KEYBOARD_I2C_ADDR 0x08

// --------------------------------------------------------------------
//	bit operations
#define set_bit(   valiable, bitn )    ( valiable  |=  (1<<(bitn)) )
#define clear_bit( valiable, bitn )    ( valiable  &= ~(1<<(bitn)) )
#define get_bit(   valiable, bitn )    ( valiable  &   (1<<(bitn)) )

// --------------------------------------------------------------------
//	LED control
#define  led_left_on()		set_bit(   DDRC, 0 ); set_bit(   PORTC, 0 )
#define  led_right_on()		set_bit(   DDRC, 0 ); clear_bit( PORTC, 0 )
#define  led_off()			clear_bit( DDRC, 0 ); clear_bit( PORTC, 0 )

// --------------------------------------------------------------------
//	IRQ control
#define irq_clear()			set_bit(   PORTB, 2 )
#define irq_request()		clear_bit( PORTB, 2 )

// --------------------------------------------------------------------
#define _NRM		0x00000
#define _Fn			0x00100
#define _Sym		0x00200
#define _PC1		0x01000
#define _PC2		0x02000
#define _PC3		0x03000
#define _PB			0x10000
#define _PD			0x20000
#define _BIT(n)		(1 << (n))

static const int msx_key[ /* Yn */ ][ /* Xn */ ] = {
	{	//	Y0								MSX-Key  M5-Key
		_Fn  | _PD | _PC2 | _BIT(0),	//	0        Fn+P
		_Fn  | _PB | _PC2 | _BIT(1),	//	1        Fn+Q
		_Fn  | _PB | _PC2 | _BIT(0),	//	2        Fn+W
		_Fn  | _PD | _PC2 | _BIT(5),	//	3        Fn+E
		_Fn  | _PD | _PC2 | _BIT(6),	//	4        Fn+R
		_Fn  | _PD | _PC2 | _BIT(7),	//	5        Fn+T
		_Fn  | _PD | _PC2 | _BIT(4),	//	6        Fn+Y
		_Fn  | _PD | _PC2 | _BIT(3),	//	7        Fn+U
	},
	{	//	Y1
		_Fn  | _PD | _PC2 | _BIT(2),	//	8        Fn+I
		_Fn  | _PD | _PC2 | _BIT(1),	//	9        Fn+O
		_Sym | _PD | _PC1 | _BIT(5),	//	-        Sym+X
		_Sym | _PB | _PC1 | _BIT(0),	//	^        Sym+Z
		_Sym | _PD | _PC3 | _BIT(1),	//	\        Sym+L
		_Sym | _PD | _PC3 | _BIT(3),	//	@        Sym+J
		_Fn  | _PD | _PC3 | _BIT(4),	//	[        Fn+H
		_Sym | _PD | _PC3 | _BIT(4),	//	+        Sym+H
	},
	{	//	Y2
		_Sym | _PD | _PC3 | _BIT(7),	//	*        Sym+G
		_Fn  | _PD | _PC3 | _BIT(3),	//	]        Fn+J
		_Fn  | _PD | _PC1 | _BIT(7),	//	<        Fn+V
		_Fn  | _PD | _PC1 | _BIT(4),	//	>        Fn+B
		_Fn  | _PD | _PC1 | _BIT(6),	//	/        Fn+C
		_Fn  | _PD | _PC3 | _BIT(1),	//	_        Fn+L
		_NRM | _PB | _PC3 | _BIT(1),	//	A        A
		_NRM | _PD | _PC1 | _BIT(4),	//	B        B
	},
	{	//	Y3
		_NRM | _PD | _PC1 | _BIT(6),	//	C        C
		_NRM | _PD | _PC3 | _BIT(5),	//	D        D
		_NRM | _PD | _PC2 | _BIT(5),	//	E        E
		_NRM | _PD | _PC3 | _BIT(6),	//	F        F
		_NRM | _PD | _PC3 | _BIT(7),	//	G        G
		_NRM | _PD | _PC3 | _BIT(4),	//	H        H
		_NRM | _PD | _PC2 | _BIT(2),	//	I        I
		_NRM | _PD | _PC3 | _BIT(3),	//	J        J
	},
	{	//	Y4
		_NRM | _PD | _PC3 | _BIT(2),	//	K        K
		_NRM | _PD | _PC3 | _BIT(1),	//	L        L
		_NRM | _PD | _PC1 | _BIT(2),	//	M        M
		_NRM | _PD | _PC1 | _BIT(3),	//	N        N
		_NRM | _PD | _PC2 | _BIT(1),	//	O        O
		_NRM | _PD | _PC2 | _BIT(0),	//	P        P
		_NRM | _PB | _PC2 | _BIT(1),	//	Q        Q
		_NRM | _PD | _PC2 | _BIT(6),	//	R        R
	},
	{	//	Y5
		_NRM | _PB | _PC3 | _BIT(1),	//	S        S
		_NRM | _PD | _PC2 | _BIT(7),	//	T        T
		_NRM | _PD | _PC2 | _BIT(3),	//	U        U
		_NRM | _PD | _PC1 | _BIT(7),	//	V        V
		_NRM | _PB | _PC2 | _BIT(0),	//	W        W
		_NRM | _PD | _PC1 | _BIT(5),	//	X        X
		_NRM | _PD | _PC2 | _BIT(4),	//	Y        Y
		_NRM | _PB | _PC1 | _BIT(0),	//	Z        Z
	},
	{	//	Y6
		_NRM | _PB | _NRM | _BIT(5),	//	Sft      aA
		_NRM | _PB | _NRM | _BIT(4),	//	Ctrl     Alt
		_NRM | _PB | _PC1 | _BIT(1),	//	Grp      0
		_Sym | _PD | _PC1 | _BIT(6),	//	Caps     Sym+C
		_Sym | _PD | _PC3 | _BIT(2),	//	Kana     Sym+K
		_Sym | _PB | _PC2 | _BIT(0),	//	F1       Sym+W
		_Sym | _PD | _PC2 | _BIT(5),	//	F2       Sym+E
		_Sym | _PD | _PC2 | _BIT(6),	//	F3       Sym+R
	},
	{	//	Y7
		_Sym | _PD | _PC2 | _BIT(7),	//	F4       Sym+T
		_Sym | _PD | _PC2 | _BIT(4),	//	F5       Sym+Y
		_Sym | _PB | _PC2 | _BIT(1),	//	ESC      Sym+Q
		_Sym | _PB | _PC3 | _BIT(1),	//	TAB      Sym+A
		_Sym | _PD | _PC2 | _BIT(3),	//	Stp      Sym+U
		_NRM | _PD | _PC2 | _BIT(0),	//	BS       Del
		_Sym | _PD | _PC2 | _BIT(1),	//	Select   Sym+O
		_NRM | _PB | _NRM | _BIT(6),	//	Return   Enter
	},
	{	//	Y8
		_NRM | _PD | _PC1 | _BIT(0),	//	Space    Space
		_Sym | _PD | _PC2 | _BIT(2),	//	CLS      Sym+I
		_Sym | _PD | _PC2 | _BIT(0),	//	Ins      Sym+P
		_Fn  | _PD | _PC3 | _BIT(0),	//	Del      Fn+Del
		_Fn  | _PD | _PC1 | _BIT(3),	//	Left     Fn+N
		_Fn  | _PD | _PC3 | _BIT(2),	//	Up       Fn+K
		_Fn  | _PD | _PC1 | _BIT(2),	//	Down     Fn+M
		_Fn  | _PD | _PC1 | _BIT(1),	//	Right    Fn+$
	},
};

static int send_y_index = 0;
static int is_sending = 0;
static unsigned char msx_key_matrix[9] = {
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

// --------------------------------------------------------------------
void setup() {
	int i;

	// ports initialization -------------
	DDRB	= 0x04;			//	1 (OUTPUT) = bit2, 0 (INPUT) = bit7-3, bit1-0
	PORTB	= 0xfb;
	irq_clear();

	DDRC	= 0x0F;			//	1 (OUTPUT) = bit3-0, 0 (INPUT) = bit7-4
	PORTB	= 0x0F;

	DDRD	= 0x00;			//	0 (INPUT) = bit7-0
	PORTD	= 0xff;

	led_off();

	Wire.begin( FACES_KEYBOARD_I2C_ADDR );
	Wire.onRequest( requestEvent );
}

// --------------------------------------------------------------------
void requestEvent() {

	Wire.write( msx_key_matrix[ send_y_index ] );
	if( send_y_index == 0 ) {
		irq_clear();
	}
	send_y_index++;
	if( send_y_index == 9 ) {
		send_y_index = 0;
		is_sending = 0;
	}
}

// --------------------------------------------------------------------
unsigned char get_keymatrix( void ) {
	int modifier_keys = (((PINB & 0x08) << 5) | (((PINB & 0x80) << 2)) ^ 0x300;
	
	if (aA_Pressed)
  {
    FN = 0; SYM = 0; ALT = 0;
    while (aA_Pressed)delay(1); //release key
    if (aA == 0) //had not pressed
    {
      delay(200);  //detect doblue click
      if (aA_Pressed)
      {
        while (aA_Pressed)delay(1);
        aA = 2;
        LedMode = 2;
      }
      else
      {
        aA = 1;
        LedMode = 1;
      }
    }
    else // had pressed
    {
      delay(200);
      if (aA_Pressed)
      {
        while (aA_Pressed)delay(1);
        if (aA == 2)
        {
          aA = 0;
        }
        else
        {
          LedMode = 2;
          aA = 2;
        }
      }
      else
      {
        aA = 0;
      }
    }
  }
  if (ALT_Pressed)
  {
    FN = 0; SYM = 0; aA = 0;
    LedMode = 3;
    ALT = 1;
  }
  else
  {
    ALT = 0;
  }


  if (FN_Pressed)
  {
    aA = 0; SYM = 0; ALT = 0;
    while (FN_Pressed)delay(1); //release key
    if (FN == 0) //had not pressed
    {
      delay(200);  //detect doblue click
      if (FN_Pressed)
      {
        while (FN_Pressed)delay(1);
        FN = 2;
        LedMode = 5;
      }
      else
      {
        FN = 1;
        LedMode = 4;
      }
    }
    else // had pressed
    {
      delay(200);
      if (FN_Pressed)
      {
        while (FN_Pressed)delay(1);
        if (FN == 2)
        {
          FN = 0;
        }
        else
        {
          LedMode = 5;
          FN = 2;
        }
      }
      else
      {
        FN = 0;
      }
    }
  }
  if (SYM_Pressed)
  {
    aA = 0; FN = 0; ALT = 0;
    while (SYM_Pressed)delay(1); //release key
    if (SYM == 0) //had not pressed
    {
      delay(200);  //detect doblue click
      if (SYM_Pressed)
      {
        while (SYM_Pressed)delay(1);
        SYM = 2;
        LedMode = 6;
      }
      else
      {
        SYM = 1;
        LedMode = 7;
      }
    }
    else // had pressed
    {
      delay(200);
      if (SYM_Pressed)
      {
        while (SYM_Pressed)delay(1);
        if (SYM == 2)
        {
          SYM = 0;
        }
        else
        {
          LedMode = 6;
          SYM = 2;
        }
      }
      else
      {
        SYM = 0;
      }
    }
  }

  if (ENTER_Pressed)
  {
    while (ENTER_Pressed)delay(1);  //ENTER
    return 29;
  }

  //normal key scan
  set_bit(PORTC, 1);
  set_bit(PORTC, 3);
  clear_bit(PORTC, 2);
  delay(2);
  switch (PIND)
  {
    case 0xfe: while (PIND != 0xff)delay(1); return  9; break;
    case 0xfd: while (PIND != 0xff)delay(1);  return 8; break;
    case 0xfb: while (PIND != 0xff)delay(1);  return 7; break;
    case 0xf7: while (PIND != 0xff)delay(1); return 6; break;
    case 0xef: while (PIND != 0xff)delay(1); return 5; break;
    case 0xdf: while (PIND != 0xff)delay(1); return 2; break;
    case 0xbf: while (PIND != 0xff)delay(1); return  3; break;
    case 0x7f: while (PIND != 0xff)delay(1); return  4; break;
  }
  switch (PINB & 0x03)
  {
    case 0x01: while ((PINB & 0x03) != 0x03)delay(1); return 0; break;
    case 0x02: while ((PINB & 0x03) != 0x03)delay(1); return 1; break;
  }
  set_bit(PORTC, 1);
  set_bit(PORTC, 2);
  clear_bit(PORTC, 3);
  delay(2);
  switch (PIND)
  {
    case 0xfe: while (PIND != 0xff)delay(1); return  19; break;
    case 0xfd: while (PIND != 0xff)delay(1);  return 18; break;
    case 0xfb: while (PIND != 0xff)delay(1);  return 17; break;
    case 0xf7: while (PIND != 0xff)delay(1); return 16; break;
    case 0xef: while (PIND != 0xff)delay(1); return 15; break;
    case 0xdf: while (PIND != 0xff)delay(1); return 12; break;
    case 0xbf: while (PIND != 0xff)delay(1); return  13; break;
    case 0x7f: while (PIND != 0xff)delay(1); return  14; break;
  }
  switch (PINB & 0x03)
  {
    case 0x01: while ((PINB & 0x03) != 0x03)delay(1); return 10; break;
    case 0x02: while ((PINB & 0x03) != 0x03)delay(1); return 11; break;
  }

  set_bit(PORTC, 2);
  set_bit(PORTC, 3);
  clear_bit(PORTC, 1);
  delay(2);
  switch (PIND)
  {
    case 0xfe: while (PIND != 0xff)delay(1); return  32; break;
    case 0xfd: while (PIND != 0xff)delay(1);  return 28; break;
    case 0xfb: while (PIND != 0xff)delay(1);  return 27; break;
    case 0xf7: while (PIND != 0xff)delay(1); return 26; break;
    case 0xef: while (PIND != 0xff)delay(1); return 25; break;
    case 0xdf: while (PIND != 0xff)delay(1); return 22; break;
    case 0xbf: while (PIND != 0xff)delay(1); return  23; break;
    case 0x7f: while (PIND != 0xff)delay(1); return  24; break;
  }
  switch (PINB & 0x03)
  {
    case 0x01: while ((PINB & 0x03) != 0x03)delay(1); return 31; break;
    case 0x02: while ((PINB & 0x03) != 0x03)delay(1); return 21; break;
  }

  return 255;

}
unsigned int idle = 0;
unsigned char KeyMap[35][5] =
{ {'q', 'Q', '#', '~', 144},
  {'w', 'W', '1', '^', 145},
  {'e', 'E', '2', '&', 146},
  {'r', 'R', '3', '`', 147},
  {'t', 'T', '(', '<', 148},
  {'y', 'Y', ')', '>', 149},
  {'u', 'U', '_', '{', 150},
  {'i', 'I', '-', '}', 151},
  {'o', 'O', '+', '[', 152},
  {'p', 'P', '@', ']', 153},
  {'a', 'A', '*', '|', 154},
  {'s', 'S', '4', '=', 155},
  { 'd', 'D', '5', '\\', 156},
  {'f', 'F', '6', '%', 157},
  {'g', 'G', '/', 180, 158},
  {'h', 'H', ':', 181, 159},
  {'j', 'J', ';', 182, 160},
  {'k', 'K', '\'', 183 , 161},
  {'l', 'L', '"', 184, 162},
  {8 , 8, 127, 8, 163}, //del & backspace
  {255, 255, 255, 185, 164}, //alt
  {'z', 'Z', '7', 186, 165},
  {'x', 'X', '8', 187, 166},
  {'c', 'C', '9', 188, 167},
  {'v', 'V', '?', 189, 168},
  {'b', 'B', '!', 190, 169},
  {'n', 'N', ',', 191, 170},
  {'m', 'M', '.', 192, 171},
  {'$', '$', 255, 193, 172},
  {13, 13, 13, 13, 173}, //enter
  {255, 255, 255, 255, 174}, //aA
  {'0', '0', '0', '0', 175},
  {' ', ' ', ' ', ' ', 176},
  {255, 255, 255, 255, 177},
  {255, 255, 27, 255, 178}
};
void loop()
{
  idle++;
  unsigned char kk = GetInput();
  if (aA == 0 && ALT == 0 && FN == 0 && SYM == 0)
    LedMode = 0;
  switch (LedMode)
  {
    case 0: led_off(); break;
    case 1: led_left_on(); break;
    case 2:
      if ((idle / 20) % 2 == 1)
      {
        led_off();
      } else {
        led_left_on();
      } break;
    case 3:
      if ((idle / 10) % 2 == 1)
      {
        led_off();
      }
      else
      {
        led_left_on();
      } break;
    case 4: led_right_on(); break;
    case 5:
      if ((idle / 20) % 2 == 1)
      {
        led_off();
      }
      else
      {
        led_right_on();
      } break;
    case 6:
      if ((idle / 10) % 2 == 1)
      {
        led_off();
      }
      else
      {
        led_right_on();
      } break;
    case 7:
      if ((idle / 30) % 2 == 1)
      {
        led_left_on();
      }
      else
      {
        led_right_on();
      } break;
    case 8:
      if ((idle / 20) % 2 == 1)
      {
        led_left_on();
      }
      else
      {
        led_right_on();
      } break;
  }
  if (kk == 29)
  {
    KEY = 0x0d; twoBytes = 1; KEY2 = 0x0a;//enter
    hadPressed = 1; irq_request();
  }
  else if (kk < 36)
  {
    if (ALT > 0)
    {
      KEY = KeyMap[kk][4];
    }
    else
    {
      if (SYM > 0)
      {
        if (SYM == 1)SYM = 0;
        KEY = KeyMap[kk][2];
      }
      else
      {
        if (FN > 0)
        {
          if (FN == 1)FN = 0;
          KEY = KeyMap[kk][3];
        }
        else
        {
          if (aA > 0)
          {
            if (aA == 1)
              aA = 0;
            KEY = KeyMap[kk][1];
          }
          else
            KEY = KeyMap[kk][0];
        }
      }
    }
    hadPressed = 1;
    irq_request();
  }
}
