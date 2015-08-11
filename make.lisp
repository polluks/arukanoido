(= *model* :vic-20)

(defun check-zeropage-size ()
  (when (< #x100 *pc*)
    (error "Zero page overflow by ~A bytes." (- *pc* #x100))))

(defconstant +degrees+ 32)
(defconstant smax 3)

(defun negate (x)
  (@ [- _] x))

(defun full-wave (x)
  (+ x
     (reverse x)
     (negate x)
     (reverse (negate x))))

(defun integer-to-byte (x)
  (? (< x 0)
     (+ 256 x)
     x))

(define-filter integers-to-bytes #'integer-to-byte)

(defun ball-directions-x ()
  (let m (/ 360 +degrees+)
    (integers-to-bytes (full-wave (maptimes [integer (* smax (degree-sin (* m _)))] (/ +degrees+ 4))))))

(defun ball-directions-y ()
  (subseq (+ (ball-directions-x) (ball-directions-x)) (/ +degrees+ 4) +degrees+))

(defun make (to files cmds)
  (apply #'assemble-files to files)
  (make-vice-commands cmds "break .stop"))

(defun make-game (version file cmds)
  (make file
        (@ [+ "src/" _] '("../bender/vic-20/vic.asm"
                          "zeropage.asm"
                          "../bender/vic-20/basic-loader.asm"
                          "init.asm"
                            "stackmem-start.asm"
                            "stackmem-end.asm"
                            "lowmem-start.asm"
                              "gfx-sprites.asm"
                              "sprite-inits.asm"
                              "chars.asm"
                              "screen.asm"
                              "blitter.asm"
                              "random.asm"
                              "math.asm"
                              "bits.asm"
                              "line-addresses.asm"
                            "lowmem-end.asm"
                          "gfx-background.asm"
                          "init-end.asm"
                          "main.asm"
                          "controllers.asm"
                          "sprites.asm"
                          "sprites-vic.asm"
                          ))
        cmds))

(make-game :prg "arkanoid.prg" "obj/arkanoid.vice.txt")

(print (ball-directions-x))
(print (ball-directions-y))
;(print (elt (ball-directions-x) (half +degrees+)))
(print (degree-sin 179))
(quit)
