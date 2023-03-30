; ==============================================================================
;	String processing routine
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                           http://hraroom.s602.xrea.com/msx/software/mgsp.html
;
;  �{�\�t�g�E�F�A����і{�\�t�g�E�F�A�Ɋ�Â��č쐬���ꂽ�h�����́A�ȉ��̏�����
;  �������ꍇ�Ɍ���A�ĔЕz����юg�p��������܂��B
;
;  1.�\�[�X�R�[�h�`���ōĔЕz����ꍇ�A��L�̒��쌠�\���A�{�����ꗗ�A����щ��L
;    �Ɛӏ��������̂܂܂̌`�ŕێ����邱�ƁB
;  2.�o�C�i���`���ōĔЕz����ꍇ�A�Еz���ɕt���̃h�L�������g���̎����ɁA��L��
;    ���쌠�\���A�{�����ꗗ�A����щ��L�Ɛӏ������܂߂邱�ƁB
;  3.���ʂɂ�鎖�O�̋��Ȃ��ɁA�{�\�t�g�E�F�A��̔��A����я��ƓI�Ȑ��i�⊈��
;    �Ɏg�p���Ȃ����ƁB
;
;  �{�\�t�g�E�F�A�́A���쌠�҂ɂ���āu����̂܂܁v�񋟂���Ă��܂��B���쌠�҂́A
;  ����ړI�ւ̓K�����̕ۏ؁A���i���̕ۏ؁A�܂�����Ɍ��肳��Ȃ��A�����Ȃ閾��
;  �I�������͈ÖقȕۏؐӔC�������܂���B���쌠�҂́A���R�̂�������킸�A���Q
;  �����̌�����������킸�A���ӔC�̍������_��ł��邩���i�ӔC�ł��邩�i�ߎ�
;  ���̑��́j�s�@�s�ׂł��邩���킸�A���ɂ��̂悤�ȑ��Q����������\����m��
;  ����Ă����Ƃ��Ă��A�{�\�t�g�E�F�A�̎g�p�ɂ���Ĕ��������i��֕i�܂��͑�p�T
;  �[�r�X�̒��B�A�g�p�̑r���A�f�[�^�̑r���A���v�̑r���A�Ɩ��̒��f���܂߁A�܂���
;  ��Ɍ��肳��Ȃ��j���ڑ��Q�A�Ԑڑ��Q�A�����I�ȑ��Q�A���ʑ��Q�A�����I���Q�A��
;  ���͌��ʑ��Q�ɂ��āA��ؐӔC�𕉂�Ȃ����̂Ƃ��܂��B
;
;  Note that above Japanese version license is the formal document.
;  The following translation is only for reference.
;
;  Redistribution and use of this software or any derivative works,
;  are permitted provided that the following conditions are met:
;
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. Redistributions in binary form must reproduce the above
;     copyright notice, this list of conditions and the following
;     disclaimer in the documentation and/or other materials
;     provided with the distribution.
;  3. Redistributions may not be sold, nor may they be used in a
;     commercial product or activity without specific prior written
;     permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
;  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
; ------------------------------------------------------------------------------
;	Date		Author	Ver		Description
;	2020/9/20	t.hara	1.0		1st release
; ==============================================================================

; ==============================================================================
;	strcpy
;	input)
;		hl .... Source string (ASCIIZ)
;		de .... Destination area address
;	output)
;		--
;	break)
;		af, de, hl, de
;	comment)
;		������̃R�s�[�B
;		DE �ɂ͏\���ȋ󂫗̈悪����O��B
; ==============================================================================
		scope	strcpy
strcpy::
		ld		a, [hl]
		ld		[de], a
		inc		hl
		inc		de
		or		a, a
		jr		nz, strcpy
		ret
		endscope

; ==============================================================================
;	strcmp
;	input)
;		de .... Target string 1 (ASCIIZ)
;		hl .... Target string 2 (ASCIIZ)
;	output)
;		zf .... 0: not match, 1: match
;		sf .... 0: [DE] >= [HL], 1: [DE] < [HL]
;	break)
;		af, b, de, hl
;	comment)
;		������̔�r
; ==============================================================================
		scope	strcmp
strcmp::
		ld		a, [de]
		ld		b, [hl]
		inc		hl
		inc		de
		cp		a, b
		ret		nz
		or		a, a
		jr		nz, strcmp
		ret
		endscope

; ==============================================================================
;	toupper
;	input)
;		a ..... Target character
;	output)
;		a ..... result of toupper(a)
;	break)
;		af
;	comment)
;		�A���t�@�x�b�g�̏ꍇ�A�啶���ɕύX����
; ==============================================================================
		scope	toupper
toupper::
		cp		a, 'a'
		ret		c
		cp		a, 'z' + 1
		ret		nc
		add		a, 'A' - 'a'
		ret
		endscope

; ==============================================================================
;	tolower
;	input)
;		a ..... Target character
;	output)
;		a ..... result of tolower(a)
;	break)
;		af
;	comment)
;		�A���t�@�x�b�g�̏ꍇ�A�������ɕύX����
; ==============================================================================
		scope	tolower
tolower::
		cp		a, 'A'
		ret		c
		cp		a, 'Z' + 1
		ret		nc
		add		a, 'a' - 'A'
		ret
		endscope

; ==============================================================================
;	strcmpi
;	input)
;		de .... Target string 1 (ASCIIZ)
;		hl .... Target string 2 (ASCIIZ)
;	output)
;		zf .... 0: not match, 1: match
;		sf .... 0: [DE] >= [HL], 1: [DE] < [HL]
;	break)
;		af, b, de, hl
;	comment)
;		�召��������ʂ��Ȃ��������r
; ==============================================================================
		scope	strcmpi
strcmpi::
		ld		a, [hl]
		call	toupper
		ld		b, a
		ld		a, [de]
		call	toupper
		inc		hl
		inc		de
		cp		a, b
		ret		nz
		or		a, a
		jr		nz, strcmpi
		ret
		endscope

; ==============================================================================
;	tostring
;	input)
;		hl .... Target value (unsigned int)
;		de .... Result buffer address
;	output)
;		[de] ... String
;	break)
;		af, bc, de, hl
;	comment)
;		HL�Ɋi�[����Ă��� 16bit �̐��l�𕶎���ɕϊ����� DE���w���o�b�t�@��
;		ASCIIZ�Ŋi�[����B
;		DE�̃o�b�t�@�� 6byte �����B
;		���͎��� de �ɂ͍����� 0 ���l�߂���B
;		de �́A�擪�� 0 ��ǂݔ�΂����ʒu���w�������Ė߂�B
; ==============================================================================
		scope	tostring
tostring::
		xor		a, a
		ld		bc, 40000
		sbc		hl, bc
		jr		nc, skip40000
		add		hl, bc
		ccf
		jr		skip40000_1
skip40000:
		ld		a, 4
skip40000_1:
		ld		bc, 20000
		sbc		hl, bc
		jr		nc, skip20000
		add		hl, bc
		ccf
		jr		skip20000_1
skip20000:
		or		a, 2
skip20000_1:
		ld		bc, 10000
		sbc		hl, bc
		jr		nc, skip10000
		add		hl, bc
		ccf
		jr		skip10000_1
skip10000:
		inc		a
skip10000_1:
		add		a, '0'			;	Cy = 0
		ld		[de], a
		inc		de

		xor		a, a
		ld		bc, 8000
		sbc		hl, bc
		jr		nc, skip8000
		add		hl, bc
		ccf
		jr		skip8000_1
skip8000:
		or		a, 8
skip8000_1:
		ld		bc, 4000
		sbc		hl, bc
		jr		nc, skip4000
		add		hl, bc
		ccf
		jr		skip4000_1
skip4000:
		or		a, 4
skip4000_1:
		ld		bc, 2000
		sbc		hl, bc
		jr		nc, skip2000
		add		hl, bc
		ccf
		jr		skip2000_1
skip2000:
		or		a, 2
skip2000_1:
		ld		bc, 1000
		sbc		hl, bc
		jr		nc, skip1000
		add		hl, bc
		ccf
		jr		skip1000_1
skip1000:
		inc		a
skip1000_1:
		add		a, '0'			;	Cy = 0
		ld		[de], a
		inc		de

		xor		a, a
		ld		bc, 800
		sbc		hl, bc
		jr		nc, skip800
		add		hl, bc
		ccf
		jr		skip800_1
skip800:
		or		a, 8
skip800_1:
		ld		bc, 400
		sbc		hl, bc
		jr		nc, skip400
		add		hl, bc
		ccf
		jr		skip400_1
skip400:
		or		a, 4
skip400_1:
		ld		bc, 200
		sbc		hl, bc
		jr		nc, skip200
		add		hl, bc
		ccf
		jr		skip200_1
skip200:
		or		a, 2
skip200_1:
		ld		bc, 100
		sbc		hl, bc
		jr		nc, skip100
		add		hl, bc
		ccf
		jr		skip100_1
skip100:
		inc		a
skip100_1:
		add		a, '0'			;	Cy = 0
		ld		[de], a
		inc		de

		ld		a, l
		ld		h, 0
		ld		b, 50
		sub		a, b
		jr		nc, skip50
		add		a, b
		jr		skip50_1
skip50:
		ld		h, 5
skip50_1:
		ld		b, 30
		sub		a, b
		jr		nc, skip30
		add		a, b
		jr		skip30_1
skip30:
		inc		h
		inc		h
		inc		h
skip30_1:
		ld		b, 20
		sub		a, b
		jr		nc, skip20
		add		a, b
		jr		skip20_1
skip20:
		inc		h
		inc		h
skip20_1:
		ld		b, 10
		sub		a, b
		jr		nc, skip10
		add		a, b
		jr		skip10_1
skip10:
		inc		h
skip10_1:
		add		a, '0'
		ld		l, a
		ld		a, h
		add		a, '0'
		ld		[de], a
		inc		de

		ld		a, l
		ld		[de], a
		inc		de

		xor		a, a
		ld		[de], a

		dec		de
		dec		de
		dec		de
		dec		de
		dec		de
skip_zero:
		ld		a, [de]
		inc		de
		cp		a, '0'
		jr		z, skip_zero
		dec		de

		or		a, a
		ret		nz
		dec		de
		ret
		endscope

; ==============================================================================
;	issjis1st
;	input)
;		a ..... Character code
;	output)
;		Cy .... 0: ASCII�R�[�h/���ȕ����R�[�h, 1: �}���`�o�C�g1byte��
;	break)
;		f
;	comment)
;		�����R�[�h A ���AShiftJIS �̃}���`�o�C�g1byte�ڂ��ǂ����𔻒肷��
; ==============================================================================
		scope	issjis1st
issjis1st::
		or		a, a
		ret		p			; 0�`127 �� ASCII�R�[�h
		cp		a, 161
		ret		c			; 128�`160 �� �}���`�o�C�g1byte��
		cp		a, 224
		ccf					; 161�`223 �� ���ȕ����R�[�h, 224�`255 �̓}���`�o�C�g1byte��
		ret
		endscope

; ==============================================================================
;	strlen
;	input)
;		hl .... Target string (ASCIIZ)
;	output)
;		bc .... String length
;	break)
;		af, bc, hl
; ==============================================================================
		scope	strlen
strlen::
		ld		bc, 0
loop:
		ld		a, [hl]
		or		a, a
		ret		z
		inc		hl
		inc		bc
		jp		loop
		endscope

; ==============================================================================
;	isspace
;	input)
;		a ..... Character code
;	output)
;		Cy .... 1: �X�y�[�X�L��������, 0: ����ȊO������
;	break)
;		f
;	comment)
;		�����R�[�h A ���A�z���C�g�X�y�[�X�������R�[�h�ł��邱�Ƃ��`�F�b�N����
;		�����x�D��ŁA�R���g���[���R�[�h���ׂăz���C�g�X�y�[�X�����ł�
; ==============================================================================
		scope	isspace
isspace::
		cp		a, ' ' + 1
		ret
		endscope

; ==============================================================================
;	isalpha
;	input)
;		a ..... Character code
;	output)
;		Cy .... 1: �A���t�@�x�b�g�L��������, 0: ����ȊO������
;	break)
;		f
;	comment)
;		�����R�[�h A ���A�A���t�@�x�b�g�������R�[�h�ł��邱�Ƃ��`�F�b�N����
; ==============================================================================
		scope	isalpha
isalpha::
		cp		a, 'A'
		ccf
		ret		nc
		cp		a, 'Z' + 1
		ret		c
		cp		a, 'a'
		ccf
		ret		nc
		cp		a, 'z' + 1
		ret
		endscope

; ==============================================================================
;	isdigit
;	input)
;		a ..... Character code
;	output)
;		Cy .... 1: ���l�L��������, 1: ����ȊO������
;	break)
;		f
;	comment)
;		�����R�[�h A ���A���l�������R�[�h�ł��邱�Ƃ��`�F�b�N����
; ==============================================================================
		scope	isdigit
isdigit::
		cp		a, '0'
		ccf
		ret		nc
		cp		a, '9' + 1
		ret
		endscope