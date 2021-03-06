;; -*- Mode:Lisp; Syntax:ANSI-Common-LISP; Coding:us-ascii-unix; fill-column:158 -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;; @file      tst-util.lisp
;; @author    Mitch Richling <https://www.mitchr.me>
;; @brief     Unit Tests.@EOL
;; @std       Common Lisp
;; @see       use-util.lisp
;; @copyright
;;  @parblock
;;  Copyright (c) 1997,2004,2010,2013,2015, Mitchell Jay Richling <https://www.mitchr.me> All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
;;
;;  1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
;;
;;  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation
;;     and/or other materials provided with the distribution.
;;
;;  3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software
;;     without specific prior written permission.
;;
;;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;;  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
;;  DAMAGE.
;;  @endparblock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defpackage :MJR_UTIL-TESTS (:USE :COMMON-LISP :LISP-UNIT :MJR_UTIL))

(in-package :MJR_UTIL-TESTS)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_non-empty-seqp
  (assert-equalp nil (mjr_util_non-empty-seqp nil))
  (assert-equalp nil (mjr_util_non-empty-seqp #()))
  (assert-equalp 1   (mjr_util_non-empty-seqp #(1)))
  (assert-equalp 1   (mjr_util_non-empty-seqp '(1)))
  (assert-equalp 3   (mjr_util_non-empty-seqp #(1 2 3)))
  (assert-equalp 3   (mjr_util_non-empty-seqp '(1 2 3)))
  (assert-equalp nil (mjr_util_non-empty-seqp 1))
  (assert-equalp nil (mjr_util_non-empty-seqp 't))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_max-print-width
  (assert-equalp 2 (mjr_util_max-print-width '(1 2 3 4 5 6 7 8 9 10)))
  (assert-equalp 2 (mjr_util_max-print-width #(1 2 3 4 5 6 7 8 9 10)))
  (assert-equalp 2 (mjr_util_max-print-width '(1 2 3 4 5 6 7 8 9 10) "~a"))
  (assert-equalp 2 (mjr_util_max-print-width '(1 2 3 4 5 6 7 8 9 10) "~d"))
  (assert-equalp 5 (mjr_util_max-print-width '(1 2 3 4 5 6 7 8 9 10) "~5d"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_strip-kwarg
  (assert-equalp '(:FOO 1 :BAR 2 :FOOBAR 3)     (mjr_util_strip-kwarg '(:FOO 1 :BAR 2 :FOOBAR 3)))
  (assert-equalp '(:FOO 1 :FOOBAR 3)            (mjr_util_strip-kwarg '(:FOO 1 :BAR 2 :FOOBAR 3) :STRIP-LIST '(:BAR)))
  (assert-equalp '(:BAR 2)                      (mjr_util_strip-kwarg '(:FOO 1 :BAR 2 :FOOBAR 3) :KEEP-LIST  '(:BAR)))
  (assert-equalp nil                            (mjr_util_strip-kwarg nil))
  ;; Errors
  (assert-error 'error                          (mjr_util_strip-kwarg 't))
  (assert-error 'error                          (mjr_util_strip-kwarg '(:FOO 1 :BAR 2 :FOOBAR 3 4)))
  (assert-error 'error                          (mjr_util_strip-kwarg '(:FOO 1 4 :BAR 2 :FOOBAR 3)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_split-seq-if
  (assert-equalp '((1 1 1) (3) (4))  (mjr_util_split-seq-if (list 1 1 1 7 3 9 4) (lambda (x) (> x 4))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_split-seq-on-elt
  (assert-equalp '((1 1 1) (3) (4))  (mjr_util_split-seq-on-elt (list 1 1 1 2 3 2 4) 2))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_super-concatenate
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list 1 2 3 4 5 6 7 8 9 0)                 #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2 3 4 5 6 7 8 9 0))              #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list #(1 2 3 4 5 6 7 8 9 0))              #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2 3 4 5) '(6 7 8 9 0))           #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list #(1 2 3 4 5) #(6 7 8 9 0))           #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2 3 4 5) #(6 7 8 9 0))           #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list #(1 2 3 4 5) '(6 7 8 9 0))           #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2) #(3 4) #(5 6) '(7 8) 9 0)     #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2) #(3 4) #(5 6) '(7 8) 9 #(0))  #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2) #(3 4) #(5 6) '(7 8) #(9 0))  #'<))
  (assert-equalp '(0 1 2 3 4 5 6 7 8 9)  (sort (mjr_util_super-concatenate  'list '(1 2) 3 4 #(5 6) '(7 8) #(9 0))     #'<))
  (assert-equalp nil                           (mjr_util_super-concatenate  'list ))
  (assert-equalp nil                           (mjr_util_super-concatenate  'list nil))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-test mjr_util_get-kwarg-vals
  (assert-equalp '(1 2)             (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:bar 2 :foo 1))))
  (assert-equalp '(1 2)             (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foo 1 :bar 2))))
  (assert-equalp '(nil nil)         (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :barfoo 2))))
  (assert-equalp '(nil nil)         (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '())))
  (assert-equalp '()                (multiple-value-list (mjr_util_get-kwarg-vals '()          '(:foo 1 :bar 2))))
  (assert-equalp '(nil 2)           (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:bar 2))))
  (assert-equalp '(1 2)             (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :bar 2 :foo 1))))
  (assert-equalp '(nil 2)           (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :bar 2))))

  (assert-error 'error              (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :barfoo 2)     't)))
  (assert-error 'error              (multiple-value-list (mjr_util_get-kwarg-vals '()          '(:foo 1 :bar 2)           't)))
  (assert-error 'error              (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :bar 2 :foo 1) 't)))
  (assert-error 'error              (multiple-value-list (mjr_util_get-kwarg-vals '(:foo :bar) '(:foobar 1 :bar 2)        't)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(run-tests
 )
