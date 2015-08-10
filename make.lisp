(= *model* :vic-20)

(defun check-zeropage-size ()
  (when (< #x100 *pc*)
    (error "Zero page overflow by ~A bytes." (- *pc* #x100))))

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
(quit)
