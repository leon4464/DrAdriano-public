;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname collision-physics) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require "definitions.rkt")
(require "base.rkt")
(require racket/list)



; Function legal-movement?

; Dependencies:
; - pixels-to-grid
; - collision-in-grid
; - collision-in-row
; - block-with-collision
; - subrows
; - subcolumns

;; DATA TYPE DEFINITION
; Posn - built-in
; List<> - built-in
; String - built-in
; Number - built-in
; Boolean - built-in

;; INPUT / OUTPUT
; Signature: Posn Posn List<List<String>> Number String-> Boolean

; PURPOSE STATEMENT:
; Predicate to answer whether a candidate movement for a player is legal or not (to prevent player from going outside of the level or through obstacles)

;; HEADER:
;; (define (legal-movement? (make-posn 64 64) (make-posn 0 0) (list (list "" "") (list "" "")) 53 "test") #false)

;; EXAMPLES

;; Test Mapping (to ensure test coverage)
; Tests 1-3 are to ensure the function correctly returns #false (not a legal movement) when the characters are off the map
;       -> 3 also contain irrelevant obstacles
;
; Tests 4-7 are to ensure the function correctly returns #false (not a legal movement) when the characters are touching an obstacle
;
;
; Tests 8-11 are to ensure the function correctly returns #true (a legal movement) when there is no relevant obstacle
;
; Tests 12+ are misc
;
; Function not tested for non 64 box grid sizes
; Function not tested for non 64x64 character sizes

; Test 1 - When player is too far to the left (off the map) the movement is illegal
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 31 128) ; (player is off the map based on his X position & size (left half of body)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")) ; no potential obstacles
               64
               "")
               #false)

; Test 2 - When the player is too far to the top (off the map) the movement is illegal
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 128 31) ; (player is off the map based on Y position & size (upper half of body)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")) ; no potential obstacles
               64
               "")
               #false)

; Test 3 - When the player is too far to the right (off the map) the movement is illegal
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 481 128) ; (player is off the map based on X position (right half of body - as 8 * 64 = 512, which is 1 above the max permitted, and count from center)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")) ; irrelevant obstacles
               64
               "")
               #false)

; Test 4 - Player is touching an obstacle above
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 223 223) ; (player is at center of map)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "b1" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #false)

; Test 5 - Player is touching an obstacle left
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 223 223) ; (player is at center of map)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "b1" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #false)

; Test 6 - Player is touching an obstacle below
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 224 224) ; (player is at center of map)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "b1" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #false)

; Test 7 - Player is touching an obstacle right
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 224 224) ; (player is at center of map)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "b1" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #false)



; Test 8 - Realistic, Legal Situation 1
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 255 255)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
               64
               "")
               #true)



; Test 9 - Realistic, Legal Situation 2
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 140 384)
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "b1" "" "" "" "")
                     (list "" "" "" "b1" "" "" "" "")
                     (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
               64
               "")
               #true)

; Test 10 - Realistic, Legal Situation 3
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 384 256) ; DrAdriano is over the pit about to die
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "b1" "b1" "" "" "" "" "b1" "b1"))
               64
               "")
               #true)

; Test 11 - Realistic, Legal Situation 4
(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 256 159) ; DrAdriano is standing on a platform
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "p1" "p1" "p1" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #true)

(check-expect (legal-movement?
               (make-posn 64 64)
               (make-posn 37 128) ; DrAdriano is standing on a platform
               (list (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" "")
                     (list "" "" "" "" "" "" "" ""))
               64
               "")
               #true)


;; TEMPLATE
;(define (legal-movement? charactersize position levelgrid gridsize block)
;  ... (pons-x charactersize) ...
;  ... (posn-y charactersize) ...
;  ... (posn? charactersize) ...
;  ... (pons-x position) ...
;  ... (posn-y position) ...
;  ... (posn? position) ...
;  ... (first levelgrid) ...
;  ... (rest levelgrid) ...
;  ... gridsize ...
;  ... block ...)

;; IMPLEMENTATION
(provide legal-movement?)
(define (legal-movement? charactersize position levelgrid gridsize block)
  (and
   ; 4 - check the player is also still in the screen of the game
   (and
    (>= (- (posn-y position) (quotient (posn-y charactersize) 2)) 24) ; check y is not negative
    (>= (- (posn-x position) (quotient (posn-x charactersize) 2)) 0) ; check x is not negative
    (<= (+ (posn-x position) (quotient (posn-x charactersize) 2)) (* gridsize (length (first levelgrid))))) ; check x does not exceed grid
   
    ; 3 - check for instances of illegal things within the new subgrid
   (not (collision-in-grid? ; check there are no illegal blocks in the proposed space the character will take up
    ; 2 - splice the columns to be proper
    (subcolumns
     (quotient (- (posn-x position) (quotient (posn-x charactersize) 2))
               gridsize) ; X left
     (quotient (+ (posn-x position) (quotient (posn-x charactersize) 2))
               gridsize) ; X right
     ; 1 - splice the rows to be proper
     (subrows
      (quotient (- (posn-y position) (quotient (posn-y charactersize) 2)) ; Y top
                gridsize)
      (quotient (+ (posn-y position) (quotient (posn-y charactersize) 2)) ; Y bottom
                gridsize)
      levelgrid
      )
     )
    block
    ))
  )
)

;; AUX FUNCTIONS

; Function collisions-in-grid

;; DATA TYPE DEFINITION
; List<> - built-in
; String - built-in

;; INPUT / OUTPUT
; Signature: collision-in-grid? List<List<String>> String -> Boolean

; PURPOSE STATEMENT
; Given a grid, return whether there is a collision (i.e. a block type which would cause a collision when touched) in the grid

;; HEADER
;; (define (collision-in-grid? (list (list "" "") (list "" "")) "test") #false)

;; EXAMPLES
; Test 1 - Detects a single block as a collision
(check-expect (collision-in-grid? (list (list "" "" "" "" "" "" "" "")
                                       (list "" "b1" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" ""))
                                  "")
              #true)

; Test 2 - Detects a two blocks as a collision
(check-expect (collision-in-grid? (list (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "b1" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "p1" "" "" "")
                                       (list "" "" "" "" "" "" "" ""))
                                  "")
              #true)

; Test 3 - Detects lack of blocks as no collisions
(check-expect (collision-in-grid? (list (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" ""))
                                  "")
              #false)

; Test 4 - Detects no collisons if there are only s and e (start and end blocks)
(check-expect (collision-in-grid? (list (list "" "" "" "" "" "" "" "")
                                       (list "" "s0" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "e0" "" "" "")
                                       (list "" "" "" "" "" "" "" "")
                                       (list "" "" "" "" "" "" "" ""))
                                  "")
              #false)

;; TEMPLATE
;(define (collision-in-grid? grid block)
;  ... (first grid) ...
;  ... (rest grid) ...
;  ... block ...)

;; IMPLEMENTATION
(define (collision-in-grid? grid block)
  (number? (index-of (map (lambda (x) (collision-in-row? x block)) grid ) #true)))


; Function block-with-collision? 

;; DATA TYPE DEFINITION
; String - built-in
; Boolean - built-in

;; INPUT / OUTPUT
; Signature: block-with-collision? String -> Boolean

; PURPOSE STATEMENT
; Given a string, return whether it is a block type which would cause a collision when touched

;; HEADER
;; (define (block-with-collision? "s") #false)

;; EXAMPLES
(check-expect (block-with-collision? "s0")
              #false)
(check-expect (block-with-collision? "e0")
              #false)
(check-expect (block-with-collision? "")
              #false)
(check-expect (block-with-collision? "  ")
              #false)
(check-expect (block-with-collision? "b1")
              #true)
(check-expect (block-with-collision? "p1")
              #true)
(check-expect (block-with-collision? "g1")
              #true)

;; TEMPLATE
;(define (block-with-collision? b)
;  ... b ...)


;; IMPLEMENTATION
(define (block-with-collision? b)
  (or
   (equal? b "b1")
   (equal? b "p1")
   (equal? b "g1")
   (equal? b "gL")
   (equal? b "gl")
   (equal? b "gR")
   (equal? b "gr")
   (equal? b "pL")
   (equal? b "pR")
   (equal? b "bT")
   (equal? b "bM")
   (equal? b "n0")
   (equal? b "n1")
   (equal? b "n2")
   (equal? b "n3")
   (equal? b "n4")
   (equal? b "n5")
   (equal? b "h0")
   (equal? b "h1")))

; Function collisions-in-row 

;; DATA TYPE DEFINITION
; List<> - built-in
; String - built-in
; Boolean - built-in

;; INPUT / OUTPUT
; Signature: collision-in-row? List<String> String -> Boolean

; PURPOSE STATEMENT
; Predicate checking for blocks with collision attributes in 1D list (i.e. a row)

;; HEADER
;; (define (collision-in-row? (list "" "") "test") #false)

;; EXAMPLES
; Test 1 - No blocks, so no detected collisions expected
(check-expect
 (collision-in-row? (list "" "" "" "" "" "" "" "") "")
 #false)

; Test 2 - No collision blocks, so no detected collisions expected
(check-expect
 (collision-in-row? (list "s0" "" "" "" "" "" "" "e0") "")
 #false)

; Test 3 - One collision block, collisions should be detected
(check-expect
 (collision-in-row? (list "b1" "" "" "" "" "" "" "") "")
 #true)

; Test 4 - One different collision block for good measure, should be detected as true
(check-expect
 (collision-in-row? (list "" "" "p1" "" "" "" "" "") "")
 #true)

; Test 5 - Multiple collision blocks in row
(check-expect
 (collision-in-row? (list "" "" "" "" "p1" "" "" "b1") "")
 #true)

;; TEMPLATE
;(define (collision-in-row? row block)
;  ... (first row) ...
;  ... (rest row) ...
;  ... block ...)

;; IMPLEMENTATION
(define (collision-in-row? row block)
  (if (equal? block "end")
      (number? (index-of (map (lambda (x) (equal? x "e1")) row) #true))
      (number? (index-of (map block-with-collision? row) #true))))


; Function subrows

; KNOWN ISSUES : fails on list with single element

;; DATA TYPE DEFINITION:
; List<> - built-in
; Number - built-in
; String - built-in

;; INPUT/OUTPUT:
; subrows : Number Number List<String> -> List<String>

; PURPOSE STATEMENT
; Given a list, return a new sliced list with only elements x1 -> x2 inclusive

;; HEADER
;; (define (subrows 2 3 (list "" "")) (list "" ""))

;; EXAMPLES
; Test 1 - Taking middle numbers
(check-expect
 (subrows 1 2 (list "A" "B" "C" "D"))
 (list "B" "C")
 )

; Test 2 - Taking beginning numbers
(check-expect
 (subrows 0 4 (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"))
 (list "A" "B" "C" "D" "E")
 )

; Test 3 - Taking end numbers
(check-expect
 (subrows 6 10 (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"))
 (list "G" "H" "I" "J" "K")
 )

; Test 4 - Taking only 2 values
(check-expect
 (subrows 9 10 (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"))
 (list "J" "K")
 )

; Test 5 - Taking only 1 value
(check-expect
 (subrows 1 1 (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"))
 (list "B")
 )

;; TEMPLATE
;(define (subrows x1 x2 grid)
;  ... (first grid) ...
;  ... (rest grid) ...
;  ... x1 ...
;  ... x2 ...)


;; IMPLEMENTATION
(define (subrows x1 x2 grid)
  (if (>= (length (drop grid x1)) 2)
      (take (drop grid x1) ; remove the irrelevant first parts of our grid (indices 0 -> x1)
            (+ (- x2 x1) 1)) ; remove the irrelevant second parts of our grid (keep only first remaining x2-x1)
      (drop grid x1)))
  
; Function subcolumns (aux to legal-movement?)

;; DATA TYPE DEFINITION
; List<> - built-in
; Number - built-in
; String - built-in

;; INPUT/OUTPUT
; subcolumns : Number Number List<List<String>> -> List<List<String>>

; PURPOSE STATEMENT
; Given a grid, return a subgrid with the columns removed which are not relevant to the character's movement

;; HEADER
;; (define (subcolumns 2 3 (list (list "" "") (list "" ""))) (list (list "" "") (list "" "")))

;; EXAMPLES
; already in subrows, not needed

;; TEMPLATE
;(define (subcolumns x1 x2 grid)
;  ... (first grid) ...
;  ... (rest grid) ...
;  ... x1 ...
;  ... x2 ...)

;; IMPLEMENTATION
(define (subcolumns y1 y2 grid)
  (map (lambda (row) (subrows y1 y2 row)) grid))
