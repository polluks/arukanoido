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
(defconstant smax 128)

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

(defun integer-to-byte (x)
  (? (< x 0)
     (+ 256 x)
     x))

(define-filter integers-to-bytes #'integer-to-byte)

(defun ball-directions-x ()
  (let m (/ 360 +degrees+)
    (integers-to-bytes (full-sin-wave (maptimes [integer (* smax (degree-sin (* m _)))] (/ +degrees+ 4))))))
;    (integers-to-bytes (full-sin-wave (maptimes [integer (/ (* 3 smax (degree-sin (* m _))) 5)] (/ +degrees+ 4))))))

(defun ball-directions-y ()
  (let m (/ 360 +degrees+)
    (integers-to-bytes (full-cos-wave (maptimes [integer (* smax (degree-cos (* m _)))] (/ +degrees+ 4))))))

(defun make (to files cmds)
  (apply #'assemble-files to files)
  (make-vice-commands cmds "break .stop"))

(defun make-game (version file cmds)
  (make file
        (@ [+ "src/" _] '("../bender/vic-20/vic.asm"
                          "zeropage.asm"
                          "../bender/vic-20/basic-loader.asm"
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
                          "main.asm"
                          "controllers.asm"
                          "ball.asm"
                          "bonus.asm"
                          "sprites.asm"
                          "sprites-vic.asm"
                          "draw-level.asm"
                          "score.asm"
                          "level-data.asm"
                          "end.asm"
                          ))
        cmds))

(defun make-level-data ()
  (with-output-file o "src/level-data.asm"
    (format o "level_data:~%")
    (dolist (level *levels*)
      (format o "~A~%" (+ 3 level.))
      (dolist (line .level)
        (dolist (brick (string-list line))
          (alet (position brick *bricks* :test #'==)
            (format o " ~A" !)))
        (format o " 0 0~%"))
      (format o " 255~%~%"))))

(make-level-data)
  
(defun paddle-xlat ()
  (maptimes [integer (/ _ 2.5)] 256))

(= *model* :vic-20+xk)

(make-game :prg "arukanuido.prg" "arukanuido.vice.txt")

(with-output-file o "POKES"
  (with (addr (- (get-label 'poke_unlimited)
                 (get-label 'relocation_offset))
         jmp #x4c
         lo (low (get-label 'retry))
         hi (high (get-label 'retry)))
    (format o "Unlimited lifes: POKE~A,~A:POKE~A,~A:POKE~A,~A~%"
            addr jmp (++ addr) lo (+ 2 addr) hi)))

(format t "Ball directions X:~%")
(print (ball-directions-x))
(print (elt (ball-directions-x) 0))
(print (elt (ball-directions-y) 0))
(print (elt (ball-directions-x) 128))
(print (elt (ball-directions-y) 128))
(format t "Ball directions Y:~%")
(print (ball-directions-y))
(quit)
