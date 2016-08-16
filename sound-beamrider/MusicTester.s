.include "music.h"
.segment "CODE"

; Globals--------------------------------------------------------------------
.global RESTART
.global Charset
.global CharNumBase
.global CharAlphaBase
LASTKEY  = 197

; ------------------------------ InitSoundAndVideo -----------------------------
InitSoundAndVideo:
								; Init music player
								jsr initmusic
								
                                ; Setup IRQ to our own handler which chains the SSS
                                SEI
                                LDX #<IrqHandler                ; allows for tear-free flipping
                                LDY #>IrqHandler
                                STX $0314
                                STY $0315
                                CLI
								rts
	
; ------------------------------PlaySongBlocking ---------------------

IrqHandler:
								jsr domusic
								JMP $EABF
