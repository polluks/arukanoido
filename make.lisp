(= *model* :vic-20)

(defun check-zeropage-size ()
  (when (< #x100 *pc*)
    (error "Zero page overflow by ~A bytes." (- *pc* #x100))))

(defconstant +degrees+ 256)
(defconstant smax 128)

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

(defun ball-directions ()
  (alet (* (/ +degrees+ 4) 3)
    (+ (subseq (ball-directions-x) ! +degrees+)
       (ball-directions-x))))

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
                            "brick-info.asm"
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
                          "draw-level.asm"
                          "level-data.asm"
                          ))
        cmds))

(make-game :prg "arkanoid.prg" "obj/arkanoid.vice.txt")

(print (length (ball-directions)))
(print (ball-directions))

(alet (elt (ball-directions) (/ +degrees+ 4))
  (unless (zero? !)
    (error "Sine of 0 should be 0 instead of ~A.~%" !)))

(alet (elt (ball-directions) (+ (/ +degrees+ 4) (/ +degrees+ 2)))
  (unless (zero? !)
    (error "Sine of 180 should be 0 instead of ~A.~%" !)))

(quit)
