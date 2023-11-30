			org			0xD130

dosdump:
			cp			a, 0x02
			ret			nz
			inc			hl
			inc			hl
			di
			ld			a, [hl]
			ld			h, 0x40
			call		0x0024			; ENASLT

			ld			hl, 0x6000
	bank_number := $+1
			ld			a, 0
			ld			[hl], a

			ld			de, 0x9000
			ld			hl, 0x4000
			ld			bc, 0x4000
			ldir

			ld			hl, 0x6000
			xor			a, a
			ld			[hl], a

			ld			a, [0xFCC1]
			ld			h, 0x40
			call		0x0024			; ENASLT
			ei
			xor			a, a
			ret
