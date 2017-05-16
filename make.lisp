(defvar *shadowvic?* nil)
(defvar *add-charset-base?* t)
(defvar *preshifted-sprites?* nil)
(defvar *show-cpu?* nil)
(defvar *make-only-vic?* t)

(defun ascii2pixcii (x)
  (@ [?
       (== 32 (char-code _))  (code-char 255)
       (alpha-char? _)        (code-char (+ (- (char-code _) (char-code #\A)) (get-label 'framechars)))
       _]
     (string-list x)))

(defconstant *bricks*
    '(#\  #\w #\o #\c #\g #\r #\b #\p #\y #\s #\x))

(defconstant *levels* '(
; Round 01
(4
"sssssssssssss"
"rrrrrrrrrrrrr"
"yyyyyyyyyyyyy"
"bbbbbbbbbbbbb"
"ppppppppppppp"
"ggggggggggggg")

; Round 02
(2
"w            "
"wo           "
"woc          "
"wocg         "
"wocgr        "
"wocgrb       "
"wocgrbp      "
"wocgrbpy     "
"wocgrbpyw    "
"wocgrbpywo   "
"wocgrbpywoc  "
"wocgrbpywocg "
"ssssssssssssr")

; Round 03
(3
"ggggggggggggg"
"             "
"wwwxxxxxxxxxx"
"             "
"rrrrrrrrrrrrr"
"             "
"xxxxxxxxxxwww"
"             "
"ppppppppppppp"
"             "
"bbbxxxxxxxxxx"
"             "
"ccccccccccccc"
"             "
"xxxxxxxxxxccc")

; Round 04
(4
" ocgsb ywocg "
" cgsby wocgs "
" gsbyw ocgsb "
" sbywo cgsbp "
" bywoc gsbpy "
" ywocg sbpyw "
" wocgs bpywo "
" ocgsb pywoc "
" cgsbp ywocg "
" gsbpy wocgs "
" sbpyw ocgsb "
" bpywo cgsbp "
" pywoc gsbpy "
" ywocg sbpyw ")

; Round 05
(2
"   y     y   "
"   y     y   "
"    y   y    "
"    y   y    "
"   sssssss   "
"   sssssss   "
"  ssrsssrss  "
"  ssrsssrss  "
" sssssssssss "
" sssssssssss "
" sssssssssss "
" s sssssss s "
" s s     s s "
" s s     s s "
"    ss ss    "
"    ss ss    ")

; Round 06
(4
"b r g c g r b"
"b r g c g r b"
"b r g c g r b"
"b r g c g r b"
"b r g c g r b"
"b xoxoxoxox b"
"b r g c g r b"
"b r g c g r b"
"b r g c g r b"
"b r g c g r b"
"o o x o x o o"
"b r g c g r b")

; Round 07
(4
"     yyp     "
"    yyppb    "
"   yyppbbr   "
"   yppbbrr   "
"  yppbbrrgg  "
"  ppbbrrggc  "
"  pbbrrggcc  "
"  bbrrggcco  "
"  brrggccoo  "
"  rrggccoow  "
"   ggccoow   "
"   gccooww   "
"    cooww    "
"     oww     ")

; Round 08
(4
"   x x x x   "
" x         x "
" xx x   x xx "
"      w      "
" x   xox   x "
"   x  c  x   "
"      g      "
"   x  r  x   "
" x   xbx   x "
"      p      "
" xx x   x xx "
" x         x "
"   x x x x   ")

; Round 09
(2
" x x     x x "
" xgx     xgx "
" xcx     xcx "
" xxx     xxx "
"             "
"    pwwwy    "
"    poooy    "
"    pcccy    "
"    pgggy    "
"    prrry    "
"    pbbby    ")

; Round 10
(0
" x           "
"             "
" x           "
" x           "
" x           "
" x     b     "
" x    bcb    "
" x   bcwcb   "
" x  bcwcwcb  "
" x bcwcscwcb "
" x  bcwcwcb  "
" x   bcwcb   "
" x    bcb    "
" x     b     "
" x           "
" x           "
" x           "
" xxxxxxxxxxxx")

; Round 11
(4
" sssssssssss "
" s         s "
" s sssssss s "
" s s     s s "
" s s sss s s "
" s s s s s s "
" s s sss s s "
" s s     s s "
" s sssssss s "
" s         s "
" sssssssssss ")

; Round 12
(4
"xxxxxxxxxxxxx"
"    x     xp "
" xw x     x  "
" x  x  x  x  "
" x  xg x  x  "
" x  x  x  x  "
" x ox  x bx  "
" x  x  x  x  "
" x  x  x  x  "
" x  x rx  x  "
" x  x  x  x  "
" xc    x     "
" x     x    y"
" xxxxxxxxxxxx")

; Round 13
(4
" yyy www yyy "
" ppp ooo ppp "
" bbb ccc bbb "
" rrr ggg rrr "
" ggg rrr ggg "
" ccc bbb ccc "
" ooo ppp ooo "
" www yyy www ")

; Round 14
(4
"bbbbbbbbbbbbb"
"x           x"
"bbbbbbbbbbbbb"
"             "
"ossssssssssso"
"x           x"
"wwwwwwwwwwwww"
"             "
"csssssssssssc"
"x           x"
"rrrrrrrrrrrrr"
"             "
"rrrrrrrrrrrrr"
"x           x")

; Round 15
(6
"cwxcccccccxwc"
"cwyxcccccxgwc"
"cwyyxcccxggwc"
"cwyyyxwxgggwc"
"cwyyyywggggwc"
"cwyyyywggggwc"
"cwyyyywggggwc"
"csyyyywggggsc"
"ccsyyywgggscc"
"cccsyywggsccc"
"ccccsywgscccc"
"cccccswsccccc")

; Round 16
(4
"      x      "
"    ww ww    "
"  ww  x  ww  "
"ww  oo oo  ww"
"  oo  x  oo  "
"oo  yy yy  oo"
"  yy  x  yy  "
"yy  gg gg  yy"
"  gg  x  gg  "
"gg  rr rr  gg"
"  rr  x  rr  "
"rr  bb bb  rr"
"  bb     bb  "
"bb         bb")

; Round 17
(4
"      s      "
"   bbbsggg   "
"  bbbwwwggg  "
"  bbwwwwwgg  "
" bbbwwwwwggg "
" bbbwwwwwggg "
" bbbwwwwwggg "
" s  s s s  s "
"      s      "
"      s      "
"      s      "
"    x x      "
"    xxx      "
"     x       ")

; Round 18
(4
"o xyyyyyyyx o"
"o xxyyyyyxx o"
"o x xyyyx x o"
"o x pxyxc x o"
"o x p s c x o"
"o x p g c x o"
"o x p g c x o"
"o x p g c x o"
"o x p g c x o"
"oxxxp g cxxxo")

; Round 19
(4
"  xxxxxxxxx  "
"  grbpxpbrg  "
"  grbpxpbrg  "
"  grbpxpbrg  "
"  grbpypbrg  "
"  grbpxpbrg  "
"  grbpxpbrg  "
"  grbpxpbrg  "
"  xxxxxxxxx  ")

; Round 20
(4
"xwxoxcxgxrxbx"
"xpxsxsxsxsxyx"
"             "
"xpx x x x x x"
"x xpx x x x x"
"x x xpx x x x"
"x x x xpx x x"
"x x x x xpx x"
"           p "
"  x x x xpx  "
"  x x xpx x  "
"  x xpx x x  "
"   px x x    "
" p    x      ")


; Round 21
(4
" xooooooooox "
" x         x "
" x xxxxxxx x "
" x x     x x "
" x x     x x "
" x x rrr x x "
" x x ggg x x "
" x x bbb x x "
" x x www x x "
" x x     x x "
" x xcccccx x "
" x         x "
" x         x "
" xxxxxxxxxxx ")

; Round 22
(4
"yyyyyyyyyyyyy"
"yyyyyyyyyyyyy"
"             "
"rrx xrrrx xrr"
"rrx xrrrx xrr"
"rrx xrrrx xrr"
"rrx xrrrx xrr"
"             "
"wwwwwwwwwwwww"
"wwwwwwwwwwwww")

; Round 23
(4
"ccccccccccccc"
"             "
"  sss sss sss"
"  sgs sgs sgs"
"  sss sss sss"
"             "
" sss sss sss "
" srs srs srs "
" sss sss sss "
"             "
"sss sss sss  "
"sbs sbs sbs  "
"sss sss sss  ")

; Round 24
(7
"     www     "
"     www     "
"     www     "
"    wwwww    "
"    wbwbw    "
"   wbbwbbw   "
"   bbbbbbb   "
"  bbbbbbbbb  "
"  bbbbbbbbb  "
" bbbbbbbbbbb "
"bbbbbbbbbbbbb")

; Round 25
(4
"rrrrrrrrrrrrr"
"ggggggggggggg"
"bbbbbbbbbbbbb"
"xxxxxsssxxxxx"
"xrrrx   xbbbx"
"xrrrx   xbbbx"
"x           x"
"x           x"
"x   xgggx   x"
"x   xgggx   x"
"xsssxxxxxsssx")

; Round 26
(4
"  xsssx      "
" x     x     "
"x  ccc  x    "
"x ggggg x    "
"x bbbbb x    "
"x  ppp  x    "
" x     x     "
"  xxxxx      ")

; Round 27
(11
"sssssssssssss"
"yyyyyyyyyyyyy"
"sssssssssssss"
"             "
"sssssssssssss"
"rrrrrrrrrrrrr"
"sssssssssssss")

; Round 28
(3
"bbbbbbbbbbbbb"
"bxxxxpxpxxxxb"
"bx         xb"
"bxp       pxb"
"bxpp     ppxb"
"bxppp   pppxb"
" bxppp pppxb "
"  bxpppppxb  "
"   bxpppxb   "
"    bxpxb    "
"     bpb     "
"      b      ")

; Round 29
(4
"yyyyyx xyyyyy"
"pppppx xppppp"
"xxwxxx xxxwxx"
"bbbbbx xbbbbb"
"rrrrrb xrrrrr"
"gggggx xggggg"
"sswssx xsswss"
"cccccx xccccc"
"ooooox xooooo"
"wwwwwx xwwwww")

; Round 30
(4
"yp           "
"ypbr         "
"ypbrgc       "
"ypbrgcow     "
"ypbrgcowyp   "
"spbrgcowypbr "
" xsrgcowypbrg"
"   xscowypbrg"
"     xswypbrg"
"       xspbrg"
"         xsrg"
"           xs")

; Round 31
(4
"g r b p y w o"
"s s s s s s s"
" b r g c o w "
" s s s s s s "
"c g r b p y w"
"s s s s s s s"
" p b r g c o "
" s s s s s s "
"o c g r b p y"
"s s s s s s s"
" y p b r g c "
" s s s s s s "
"w o c g r b p"
"s s s s s s s")

; Round 32
(4
"  x x x x x  "
"  x x x x x  "
"  x x x xgg  "
"  x x x x x  "
"  x x xrrrr  "
"  x x x x x  "
"  x xbbbbbb  "
"  x x x x x  "
"  xpppppppp  "
"  x x x x x  "
"  yyyyyyyyy  "
"  sssssssss  ")
))

(= *model* :vic-20)

(defun check-zeropage-size ()
  (when (< #x100 *pc*)
    (error "Zero page overflow by ~A bytes." (- *pc* #x100))))

(defconstant +degrees+ 256)
(defconstant smax 127)

(defun negate (x)
  (@ [- _] x))

(defun full-sin-wave (x)
  (+ x
     (reverse x)
     (negate x)
     (reverse (negate x))))

(defun full-cos-wave (x)
  (+ x
     (reverse (negate x))
     (negate x)
     (reverse x)))

(define-filter bytes #'byte)

(defun ball-directions-x ()
  (let m (/ 360 +degrees+)
    (bytes (full-sin-wave (maptimes [integer (/ (* 3 smax (degree-sin (* m _))) 5)] (/ +degrees+ 4))))))

(defun ball-directions-y ()
  (let m (/ 360 +degrees+)
    (bytes (full-cos-wave (maptimes [integer (* smax (degree-cos (* m _)))] (/ +degrees+ 4))))))

(defun make (to files cmds)
  (apply #'assemble-files to files)
  (make-vice-commands cmds "break .stop"))

(defun make-game (version file cmds)
  (make file
        (@ [+ "src/" _] `("../bender/vic-20/vic.asm"
                          "constants.asm"
                          "zeropage.asm"
                          ,@(unless *shadowvic?*
                              '("../bender/vic-20/basic-loader.asm"))
                          "init.asm"
                          "gfx-background.asm"
                          "gfx-sprites.asm"
                          "brick-info.asm"
                          "sprite-inits.asm"
                          "chars.asm"
                          "screen.asm"
                          "blitter.asm"
                          "random.asm"
                          "math.asm"
                          "bits.asm"
                          "line-addresses.asm"
                          "irq.asm"
                          "main.asm"
                          "lifes.asm"
                          "gfx.asm"
                          "roundstart.asm"
                          "vaus.asm"
                          "laser.asm"
                          "ball.asm"
                          "bonus.asm"
                          "sprites.asm"
                          "sprites-vic-common.asm"
                          ,(? *preshifted-sprites?*
                              "sprites-vic-3k.asm"
                              "sprites-vic.asm")
                          "draw-level.asm"
                          "score.asm"
                          ,@(unless *shadowvic?*
                              '("../bender/vic-20/minigrafik-display.asm"))
                          "gfx-doh.asm"
                          "gfx-title.asm"
                          "music.asm"
                          "end.asm"))
        cmds))

(defun get-brick (x)
  (position x *bricks*))

(defconstant +level-data+ (with-queue q
                            (dolist (level *levels*)
                              (enqueue q (+ 3 level.)) ; Y offset of bricks.
                              (dolist (line .level)
                                (dolist (brick (string-list line))
                                  (enqueue q (get-brick brick))))
                              (enqueue q 15))
                            (with-queue qo
                              (dolist (j (group (queue-list q) 32) (queue-list qo))
                                (dolist (i (group j 2))
                                  (enqueue qo (+ (* i. 16) (| .i. 0))))))))

(defun paddle-xlat ()
  (maptimes [bit-and (integer (+ 8 (/ (- 255 _) ; TODO: Häh?
                                      (/ 256 (++ (* 8 12))))))
                     #xfe] 256))

(= *model* :vic-20+xk)

(make-game :prg "arukanoido.prg" "arukanoido.vice.txt")

(format t "Updating POKEs…~%")
(with-output-file o "POKES"
  (with (addr (- (get-label 'poke_unlimited)
                 (get-label 'relocation_offset))
         jmp #x4c
         lo (low (get-label 'retry))
         hi (high (get-label 'retry)))
    (format o "Unlimited lifes: POKE~A,~A:POKE~A,~A:POKE~A,~A~%"
            addr jmp (++ addr) lo (+ 2 addr) hi)))

(unless *make-only-vic?*
  (with-temporary *shadowvic?* t
    (format t "Making shadowVIC version…~%")
    (make-game :prg "arukanoido-shadowvic.bin" "arukanoido-shadowvic.vice.txt")))

(format t "Level data: ~A B~%" (length +level-data+))
(quit)
