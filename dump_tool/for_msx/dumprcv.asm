; --------------------------------------------------------------------
;	DUMPRCV
; ====================================================================
;	2023/3/20	t.hara(HRA!)
; --------------------------------------------------------------------

		org			0x100

; --------------------------------------------------------------------
;	main routine
; --------------------------------------------------------------------
		scope		main
main::
		; �v�����v�g��\��
		ld			de, prompt
		call		puts
		; �t�@�C���������
		call		get_file_name
		call		put_file_name
		; �t�@�C�����J��
		call		open_file
		; ���g�������o��
		call		fwrite_body
		; �t�@�C�������
		call		close_file
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		get_file_name
get_file_name::
		ld			hl, fcb_name
	loop_file_name:
		push		hl
		call		getc
		pop			hl
		cp			a, '.'
		jr			z, input_file_ext
		cp			a, ':'
		jr			z, end_of_input_file_name
		call		check_name_char
		jp			nc, invalid_char
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, fcb_name + 8
		jr			nz, loop_file_name
	input_file_ext:
		ld			hl, fcb_ext
	loop_file_ext:
		push		hl
		call		getc
		pop			hl
		cp			a, ':'
		jr			z, end_of_input_file_name
		call		check_name_char
		jp			nc, invalid_char
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, fcb_ext + 3
		jr			nz, loop_file_ext
	end_of_input_file_name:
		ret

	invalid_char:
		ld			de, invalid_char
		call		puts
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		put_file_name
put_file_name::
		; �v�����v�g�\��
		ld			de, s_file_name
		call		puts
		; �t�@�C������\��
		ld			b, 8
		ld			hl, fcb_name
	loop_file_name:
		ld			[save_bc], bc
		ld			[save_hl], hl
		ld			a, [hl]
		cp			a, ' '
		jr			z, put_dot		; �r���� ' ' �𔭌�������g���q�̕\���ֈڂ�
		call		putc
		ld			hl, [save_hl]
		ld			bc, [save_bc]
		inc			hl
		djnz		loop_file_name
	put_dot:
		ld			a, '.'			; �t�@�C�����Ɗg���q�̋�؂�� '.' ��\��
		call		putc
		; �g���q��\��
		ld			b, 3
		ld			hl, fcb_ext
	loop_file_ext:
		ld			[save_bc], bc
		ld			[save_hl], hl
		ld			a, [hl]
		cp			a, ' '
		jr			z, put_end		; �r���� ' ' �𔭌�������\�����I��
		call		putc
		ld			hl, [save_hl]
		ld			bc, [save_bc]
		inc			hl
		djnz		loop_file_ext
	put_end:
		ld			a, '\r'
		call		putc
		ld			a, '\n'
		call		putc
		ret
		endscope

; --------------------------------------------------------------------
		scope		open_file
open_file::
		; fopen
		ld			de, fcb
		ld			c, D1F_FMAKE
		call		bdos
		or			a, a						; 00h ����, FFh ���s
		jp			nz, cannot_create_file
		ret
	cannot_create_file:
		ld			de, s_cannot_create_file
		call		puts
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		close_file
close_file::
		ld			de, fcb
		ld			c, D1F_FCLOSE
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		fwrite_body
fwrite_body::
		; 1��������
		call		getc
		call		isdigit
		jp			c, get_one_byte_command
		call		is_A_to_F
		jp			c, get_one_byte_command
		; �I���L��
		cp			a, 'e'
		ret			z
		; ���������O�X�L��
		cp			a, 'r'
		jp			z, decompress_run_length
		; ���̋L���͖���
		jp			fwrite_body

		; 1�o�C�g��t
	get_one_byte_command:
		call		get_one_byte
		ld			[dta], a
		; - 1�o�C�g�����o��
		ld			de, dta				; �]�����A�h���X���w��
		ld			c, D1F_SETDTA
		call		bdos
	xxxxxxxxx::
		ld			hl, 1
		ld			[fcb_recode_size], hl

		ld			de, fcb
		ld			hl, 1				; 1���R�[�h (1���R�[�h�� FCB �� 1byte �ɂ��Ă���)
		ld			c, D1F_WRBLK
		call		bdos
		jp			fwrite_body

		; ���������O�X�f�R�[�h
	decompress_run_length:
		call		get_one_byte
		ld			[dta], a
		call		getc
		call		get_one_byte
		ld			b, a

	decompress_loop:
		push		bc
		; - 1�o�C�g�����o��
		ld			de, dta				; �]�����A�h���X���w��
		ld			c, D1F_SETDTA
		call		bdos

		ld			hl, 1
		ld			[fcb_recode_size], hl

		ld			de, fcb
		ld			hl, 1				; 1���R�[�h (1���R�[�h�� FCB �� 1byte �ɂ��Ă���)
		ld			c, D1F_WRBLK
		call		bdos
		pop			bc
		djnz		decompress_loop
		jp			fwrite_body
		endscope

; --------------------------------------------------------------------
		scope		get_one_byte
get_one_byte::
		add			a, -'0'
		cp			a, 10
		jr			c, skip_hex1
		add			a, '0'-'A'+10
	skip_hex1:
		add			a, a
		add			a, a
		add			a, a
		add			a, a
		ld			[save_bc], a
		call		getc
		add			a, -'0'
		cp			a, 10
		jr			c, skip_hex2
		add			a, '0'-'A'+10
	skip_hex2:
		ld			c, a
		ld			a, [save_bc]
		or			a, c
		ret
		endscope

; --------------------------------------------------------------------
		scope		is_A_to_F
is_A_to_F::
		cp			a, 'A'
		ccf
		ret			nc
		cp			a, 'F'+1
		ret
		endscope

; --------------------------------------------------------------------
		scope		check_name_char
check_name_char::
		call		isdigit
		ret			c
		call		isalpha
		ret			c
		cp			a, '_'
		jr			nz, is_not_valid_char
		scf						; Cy=1
		ret
	is_not_valid_char:
		or			a, a		; Cy=0
		ret
		endscope

; --------------------------------------------------------------------
;	include
; --------------------------------------------------------------------
		include		"MSXDOS1.ASM"
		include		"STDIO.ASM"
		include		"STRING.ASM"

; --------------------------------------------------------------------
;	datas
; --------------------------------------------------------------------
prompt::
		ds			"DUMPRCV v1.0\r\n"
		ds			"Programmed by (C)2023 HRA!\r\n"
		db			0

s_file_name::
		ds			"FILE NAME:"
		db			0

s_cannot_create_file::
		ds			"Cannot create the file.\r\n"
		db			0

save_bc::
		dw			0
save_hl::
		dw			0

fcb::
		db			0			; drive num
	fcb_name:
		ds			"        "	; file name
	fcb_ext:
		ds			"   "		; file ext.
		dw			0			; current block
	fcb_recode_size:
		dw			1			; recode size
		db			0,0,0,0		; file size
		dw			0			; date
		dw			0			; time
		db			0			; device ID
		db			0			; directory location
		dw			0			; start cluster
		dw			0			; end cluster
		dw			0			; offset
		dw			0			; current recode
		db			0,0,0,0		; random recode

dta::
		db			0
