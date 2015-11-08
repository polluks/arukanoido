if @*coinop?*
    org $2000
end

relocated_start = @(+ charset (* num_chars 8))

relocation_offset = @(- relocated_start loaded_start)
loaded_end = @(- relocated_end relocation_offset)

main:
if @*coinop?*
    jmp loaded_start
end

    lda #<loaded_end
    sta s
    lda #>loaded_end
    sta @(++ s)
    lda #<relocated_end
    sta d
    lda #>relocated_end
    sta @(++ d)
    ldy #0
l:  lda (s),y
    sta (d),y
    ldx #s
    jsr dec_zp
    ldx #d
    jsr dec_zp
    lda s
    cmp #@(low (-- loaded_start))
    bne -l
    lda @(++ s)
    cmp #@(high (-- loaded_start))
    bne -l
    jmp relocated_start

dec_zp:
    dec 0,x
    pha
    lda 0,x
    cmp #255
    bne +n
    dec 1,x
n:  pla
    rts

loaded_start:
if @(not *coinop?*)
    org relocated_start
end

    sei
    lda #$7f
    sta $912e       ; Disable and acknowledge interrupts.
    sta $912d
    sta $911e       ; Disable restore key NMIs.

if @nil
    ; Copy code to $200-3ff.
    ldx #0
l:  lda lowmem,x
    sta $200,x
    lda @(+ lowmem #x100),x
    sta $300,x
    dex
    bne -l

    ; Copy code to stack.
    ldx #$5f
l:  lda stackmem,x
    sta $180,x
    dex
    bpl -l
end

    ; Clear character 0.
    ldx #7
    lda #0
l:  sta charset,x
    dex
    bpl -l

    ; Copy background characters to charset.
    ldx #@(- gfx_background_end gfx_background)
l:  lda @(-- gfx_background),x
    sta @(-- (+ charset (* bg_start 8))),x
    dex
    bne -l

    lda #20     ; Horizontal screen origin.
    sta $9000
    lda #21     ; Vertical screen origin.
    sta $9001
;    lda #@(+ 128 15) ; Number of columns.
    lda #15     ; Number of columns.
    sta $9002
    lda #@(* 32 2) ; Number of rows.
    sta $9003
    lda #@(+ vic_screen_1000 vic_charset_1400)
    sta $9005
    lda #@(* light_cyan 16) ; Auxiliary color.
    sta $900e
    lda #@(+ reverse red)   ; Screen and border color.
    sta $900f

    jmp start
