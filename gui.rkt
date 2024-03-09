;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname gui) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require "definitions.rkt")
(require "base.rkt")
(require racket/list)
(require "collision-physics.rkt")

; Function in-rectangular-field?

;; DATA TYPE DEFINITION
; Posn<> - built-in
; Number - built-in
; Boolean - built-in

;; INPUT/OUTPUT
; Signature:
; in-rectangular-field? : Posn<Number> Posn<Pons<Number>> -> Boolean

;; PROBLEM STATEMENT
; Predicate which takes a rectangular field (two points, i.e. a posn of posn of Number values) and a pos (a point, i.e. a posn
; of Number values) and checks whether the coordinates of a pos can be considered "in" a rectangular field.
; This function assumes coordinates start at (0,0).

;; HEADER
; (define (in-rectangular-field? (make-posn 0 0) (make-posn (make-posn 0 0) (make-posn 0 0))) #false)

;; EXAMPLES
; Test mapping
; 1-3 - a point within the range of a rectangular field passed to in-rectangular-field? returns #true
; 4-5 - a point outside the range of a rectangular field passed to in-rectangular-field? returns #false

; Test 1 - in range example 1 returns #true (general case)
(check-expect
 (in-rectangular-field?
  (make-posn 350 350)
  (make-posn
   (make-posn 300 300)
   (make-posn 400 400)
   )
  )
 #true
 )

; Test 2 - in range example 2 returns #true (general case)
(check-expect
 (in-rectangular-field?
  (make-posn 205 375)
  (make-posn
   (make-posn 201 373)
   (make-posn 208 400)
   )
  )
 #true
 )

; Test 3 - in range example 3 returns #true ("edge" case - x & y are on edge of rect to test correct inequalities)
(check-expect
 (in-rectangular-field?
  (make-posn 0 0)
  (make-posn
   (make-posn 0 0)
   (make-posn 400 400)
   )
  )
 #true
 )

; Test 4 - out of range example 0 returns #false
(check-expect
 (in-rectangular-field?
  (make-posn 0 0)
  (make-posn
   (make-posn 300 300)
   (make-posn 400 400)
   )
  )
 #false
 )

; Test 5 - out of range example 0 returns #false
(check-expect
 (in-rectangular-field?
  (make-posn 0 0)
  (make-posn
   (make-posn 200 200)
   (make-posn 205 210)
   )
  )
 #false
 )

;; TEMPLATE
;(define (in-rectangular-field? pos rectangular-field)
;   ... (posn-x (posn-x rectangular-field)) ...
;   ... (posn-y (posn-x rectangular-field)) ...
;   ... (posn-x (posn-y rectangular-field)) ...
;   ... (posn-y (posn-y rectangular-field)) ...
;   ... (posn-x pos) ...
;   ... (posn-y pos) ...))

;; IMPLEMENTATION
(provide in-rectangular-field?)
(define (in-rectangular-field? pos rectangular-field)
  ; use max and min so the rectangular field can be given in any order
  (and
   ; check x (must be "between" the two x values of rectangular field)
   (<= (min (posn-x (posn-x rectangular-field)) (posn-x (posn-y rectangular-field)))
       (posn-x pos)
       (max (posn-x (posn-x rectangular-field)) (posn-x (posn-y rectangular-field))))

   ; check y (must be "between" the two y values of rectangular field)
   (<= (min (posn-y (posn-x rectangular-field)) (posn-y (posn-y rectangular-field)))
       (posn-y pos)
       (max (posn-y (posn-x rectangular-field)) (posn-y (posn-y rectangular-field))))
   )
  )