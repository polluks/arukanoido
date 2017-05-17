(var *bytecodes* nil)

(fn syscallbyindex (x)
  (elt *bytecodes* x))

(fn syscall-name (x)
  (downcase (symbol-name x.)))

(fn syscall-bytecodes-source ()
  (apply #'+ (maptimes [format nil "c_~A=~A~%" (syscall-name (syscallbyindex _))
                                               (++ _)]
                       (length *bytecodes*))))

(fn syscall-vectors (label prefix)
  (+ label ": "
     (apply #'+ (pad (mapcar [format nil "~A~A" prefix (syscall-name _)]
                             *bytecodes*)
                     " "))
     (format nil "~%")))

(fn syscall-vectors-l () (syscall-vectors "syscall_vectors_l" "<"))
(fn syscall-vectors-h () (syscall-vectors "syscall_vectors_h" ">"))
(fn syscall-args-l () (syscall-vectors "syscall_args_l" "<args_"))
(fn syscall-args-h () (syscall-vectors "syscall_args_h" ">args_"))

(fn syscall-args ()
  (apply #'+ (mapcar [+ (format nil "args_~A: " (syscall-name _))
                        (apply #'+ (pad (+ (list (princ (length ._) nil))
									       (mapcar [downcase (symbol-name _)] ._))
										" "))
						(format nil "~%")]
                     *bytecodes*)))

(defmacro define-bytecode (name &rest args)
  (| (assoc name *bytecodes*)
     (acons! name args *bytecodes*))
  nil)

;;;;;;;;;;;;;;;;;;;;;;
;;; Function calls :::
;;;;;;;;;;;;;;;;;;;;;;
(define-bytecode apply) ; Argument is destination address.

(= *bytecodes* (reverse *bytecodes*))

(fn gen-vcpu-tables (path)
  (with-output-file o path
    (princ (+ (syscall-bytecodes-source)
              (syscall-vectors-l)
              (syscall-vectors-h)
              (syscall-args-l)
              (syscall-args-h)
              (syscall-args))
           o)))
