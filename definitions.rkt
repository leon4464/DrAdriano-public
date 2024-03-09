;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname definitions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require racket/class)
(require racket/list)
(require "base.rkt")

; constant definitions part 1

(provide GRAVITY)
(define GRAVITY 70)


(provide FPS)
(define FPS 60)


(provide CHARACTER-SPEED)
(define CHARACTER-SPEED 8)


(provide JUMP-POWER)
(define JUMP-POWER 18)


(provide CHARACTER-SIZE)
(define CHARACTER-SIZE 64)


(provide INITIAL-POS)
(define INITIAL-POS (make-posn 96 416))


(provide SCREEN-WIDTH)
(define SCREEN-WIDTH 1280)


(provide SCREEN-HEIGHT)
(define SCREEN-HEIGHT 720)


(provide STATIC-BACKGROUND)
(define STATIC-BACKGROUND (bitmap/file "img/Background.png"))


(provide STATIC-BACKGROUND-HEIGHT)
(define STATIC-BACKGROUND-HEIGHT (image-height STATIC-BACKGROUND))


(provide STATIC-BACKGROUND-WIDTH)
(define STATIC-BACKGROUND-WIDTH (image-width STATIC-BACKGROUND))


(provide DYNAMIC-BACKGROUND)
(define DYNAMIC-BACKGROUND (rectangle 2560 720 0 "black"))


(provide DYNAMIC-BACKGROUND-HEIGHT)
(define DYNAMIC-BACKGROUND-HEIGHT (image-height DYNAMIC-BACKGROUND))


(provide DYNAMIC-BACKGROUND-WIDTH)
(define DYNAMIC-BACKGROUND-WIDTH (image-width DYNAMIC-BACKGROUND))


(provide SIGN)
(define SIGN (bitmap/file "img/Sign.png"))


(provide BRIDGE0)
(define BRIDGE0 (bitmap/file "img/Bridge_0.png"))


(provide BRIDGE1)
(define BRIDGE1 (bitmap/file "img/Bridge_1.png"))


(provide BRIDGE2)
(define BRIDGE2 (bitmap/file "img/Bridge_2.png"))


(provide BRIDGE3)
(define BRIDGE3 (bitmap/file "img/Bridge_3.png"))


(provide BRIDGE4)
(define BRIDGE4 (bitmap/file "img/Bridge_4.png"))


(provide BRIDGE5)
(define BRIDGE5 (bitmap/file "img/Bridge_5.png"))


(provide BRIDGE6)
(define BRIDGE6 (bitmap/file "img/Bridge_6.png"))


(provide BRIDGE7)
(define BRIDGE7 (bitmap/file "img/Bridge_7.png"))


(provide BRIDGE8)
(define BRIDGE8 (bitmap/file "img/Bridge_8.png"))


(provide BRIDGE9)
(define BRIDGE9 (bitmap/file "img/Bridge_9.png"))


(provide HOLE0)
(define HOLE0 (bitmap/file "img/Hole_0.png"))


(provide HOLE1)
(define HOLE1 (bitmap/file "img/Hole_1.png"))


(provide END0)
(define END0 (bitmap/file "img/End_0.png"))


(provide END1)
(define END1 (bitmap/file "img/End_1.png"))


(provide END2)
(define END2 (bitmap/file "img/End_2.png"))


(provide END3)
(define END3 (bitmap/file "img/End_3.png"))


(provide END4)
(define END4 (bitmap/file "img/End_4.png"))


(provide END5)
(define END5 (bitmap/file "img/End_5.png"))


(provide END6)
(define END6 (bitmap/file "img/End_6.png"))


(provide END7)
(define END7 (bitmap/file "img/End_7.png"))


(provide END8)
(define END8 (bitmap/file "img/End_8.png"))


(provide DRADRIANO-IDLE)
(define DRADRIANO-IDLE (list (bitmap/file "img/DrAdriano_Idle.png")))


(provide RUN-RIGHT)
(define RUN-RIGHT (list (bitmap/file "img/animations/run_right/Frame_1.png") (bitmap/file "img/animations/run_right/Frame_2.png")))


(provide RUN-LEFT)
(define RUN-LEFT (list (bitmap/file "img/animations/run_left/Frame_1.png") (bitmap/file "img/animations/run_left/Frame_2.png")))


(provide JUMP)
(define JUMP (list (bitmap/file "img/animations/jump/Frame_1.png")))


(provide JUMP-RIGHT)
(define JUMP-RIGHT (list (bitmap/file "img/animations/jump_right/Frame_1.png") (bitmap/file "img/animations/jump_right/Frame_2.png")))


(provide JUMP-LEFT)
(define JUMP-LEFT (list (bitmap/file "img/animations/jump_left/Frame_1.png") (bitmap/file "img/animations/jump_left/Frame_2.png")))


(provide GRID-SIZE)
(define GRID-SIZE 64)


(provide BEAN-TOP)
(define BEAN-TOP (bitmap/file "img/Bean_T.png"))


(provide BEAN-MIDDLE)
(define BEAN-MIDDLE (bitmap/file "img/Bean_M.png"))


(provide BLOCK1)
(define BLOCK1 (bitmap/file "img/Block1.png"))


(provide PLATFORM1)
(define PLATFORM1 (bitmap/file "img/Platform1.png"))


(provide PLATFORM-RIGHT)
(define PLATFORM-RIGHT (bitmap/file "img/Platform_R.png"))


(provide PLATFORM-LEFT)
(define PLATFORM-LEFT (bitmap/file "img/Platform_L.png"))


(provide GROUND1)
(define GROUND1 (bitmap/file "img/Ground1.png"))


(provide GROUND2)
(define GROUND2 (bitmap/file "img/Ground2.png"))


(provide HOLE-LEFT-TOP)
(define HOLE-LEFT-TOP (bitmap/file "img/Hole_LT.png"))


(provide HOLE-LEFT-BOTTOM)
(define HOLE-LEFT-BOTTOM (bitmap/file "img/Hole_LB.png"))


(provide HOLE-RIGHT-TOP)
(define HOLE-RIGHT-TOP (bitmap/file "img/Hole_RT.png"))


(provide HOLE-RIGHT-BOTTOM)
(define HOLE-RIGHT-BOTTOM (bitmap/file "img/Hole_RB.png"))


(provide HEART)
(define HEART (bitmap/file "img/Heart.png"))


(provide NO-HEART)
(define NO-HEART (bitmap/file "img/NoHeart.png"))


(provide GRID)
(define GRID (list (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "bT" "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "pL" "pR" "  " "  " "bM" "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
                   (list "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "bT" "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "bM" "  " "  " "  " "  " "  " "  " "  " "  " "e6" "e7" "e8" "  ")
                   (list "  " "  " "  " "  " "  " "bT" "  " "pL" "pR" "  " "bM" "  " "  " "  " "  " "  " "  " "  " "  " "pL" "pR" "  " "  " "  " "  " "  " "  " "bM" "  " "  " "  " "  " "  " "  " "  " "  " "e3" "e4" "e5" "  ")
                   (list "  " "s0" "  " "b1" "  " "bM" "  " "  " "  " "  " "bM" "  " "n6" "n7" "n8" "n9" "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "bM" "  " "  " "pL" "p1" "pR" "  " "  " "  " "e0" "e1" "e2" "  ")
                   (list "g1" "g1" "g1" "g1" "g1" "g1" "g1" "g1" "g1" "g1" "g1" "n0" "n1" "n2" "n3" "n4" "n5" "gL" "  " "  " "  " "  " "  " "  " "  " "  " "  " "bM" "  " "  " "  " "  " "  " "  " "gR" "g1" "g1" "g1" "g1" "g1")
                   (list "g2" "g2" "g2" "g2" "g2" "g2" "g2" "g2" "g2" "g2" "g2" "g2" "h0" "  " "  " "h1" "g2" "gl" "  " "  " "  " "  " "  " "  " "  " "  " "  " "bM" "  " "  " "  " "  " "  " "  " "gr" "g2" "g2" "g2" "g2" "g2")))


; further constant definitions at bottom of file (use structs in next section as a dependency)
; structure definitions now


; Struct CharacterState

; DATA TYPE DEFINITION:
; a CharacterState is a structure (make-character-state statename active sprite new renderPriority)
;    where:
;        statename       : String
;        active          : Boolean
;        sprite          : Maybe<Image>
;        new             : Boolean
;        renderPriority  : Number
;
; interpretation:
;                 statename is a String needed to represent the name of the CharacterState (example "running" , "idle" , "powerup" , etc)
;
;                 active is a Boolean representing whether or not a CharacterState is currently active
;
;                 sprite is a Maybe<image> which is one of:
;                   - an Image ; the characterstate has an image to be rendered, when it is active (ex. a "running" image when the character is running)
;                   - #false   ; the state has not been activated
;
;                 new is a Boolean value representing whether the animation has just been activated or not (as some characterState instances look temporarily different when they are started for the first time)
;
;                 renderPriority is an Number (strictly a positive Integer) to dictate which characterState instances should be rendered and addressed first
;

; IMPLEMENTATION:
(provide (struct-out character-state))
(define-struct character-state [statename frame sprite new? priority])


; Struct character

; DATA TYPE DEFINITION:
; a Character is a Structure (make-character pos type states size dead momentum)
;      where pos      : a Posn of Number values
;            type     : a String
;            states   : a Maybe<List>
;            size     : a Posn of Number values
;            lives    : a Number
;            momentum : a Posn of Number values
;
; interpretation:
;                 a pos consists of an x and y Number value representing the location of the character in the game
;                 (which must be integers, but can be negative or positive as characters can be "off-screen")
;
;                 a type consists of a String which is one of:
;                 - "DrAdriano" ; the main player character the game is centered around, using the sprite DrAdriano.png
;                               ; with no "special abilities"
;
;                 a states attribute is one of:
;                   - a List<CharacterState> ; the character has CharacterState attributes which affect them (movement, rendering, etc)
;                   - #false ; the character has no CharacterState attributes which are currently affecting them
;
;                 a size is a Posn of Number values representing the dimensions of a character (the height and the width) in pixels
;
;                 a lives is a Number representing the amount of lives that the character has left (strictly an Integer between 0 and 3 inclusive)
;
;                 a momentum is a Posn of Number values which is the current momentum of the character, on both the x and y axis
;                 which is the rate of movement along one partciular axis (can be any non-integer real number)

; IMPLEMENTATION:
(provide (struct-out character))
(define-struct character [pos type states size lives momentum])


; struct level-state

; DATA TYPE DEFINITION:
; LevelState is a Structure (make-level-state grid character enemies startpos timer background)
;   where grid       : is a Grid
;         character  : is a Character
;         enemies    : is #false
;         startpos   : is a Posn
;         timer      : is a Number
;         background : is an Image

; Purpose statement :
; the LevelState stores all the objects necessary to draw (on the screen) and play the current level.

; IMPLEMENTATION:
(provide (struct-out level-state))
(define-struct level-state [grid character enemies startpos timer background])


; struct game-state

; DATA TYPE DEFINITION:
; GameState is a Structure (make-game-state is-running active-state)
;    where is-running   : is a Boolean
;          active-state : is a LevelState (for now)
;          key-pressed  : is a List<Strings>

; IMPLEMENTATION:
(provide (struct-out game-state))
(define-struct game-state [is-running active-state key-pressed])


;; struct menu-state
; not yet finalised (need to use in prod and then determine additional requirements)

; DATA TYPE DEFINITION:
; A menu-state is a struct (make-menu-state buttons buttons text background endtime endtime-action key-actions)
;      where buttons         : Maybe<List>
;            text            : Maybe<List>
;            background      : Image
;            endtime         : Maybe<Number>
;            endtime-action  : Maybe<String>
;            key-actions     : Maybe<List>
;            
;
; interpretation:
;            buttons is a Maybe<List> which is one of:
;              - a List<rectanglular-button-element> ; a list containing all of the rectangular button structs present in this menustate instance
;              - #false                              ; a boolean false (the menu-state does not have any buttons to render)
;
;            text is a Maybe<List> which is one of:
;              - a List<text-element>   ; a list containing all of the text element structs present in this menustate instance
;              - #false                 ; a boolean false (the menu-state does not have any text to render)
;
;            background is an Image to struct to be used as the background (the base) of the menu
;
;            endtime is a Maybe<Number> which is one of:
;              - a Number representing the system time (time since the epoch) at which the menustate should end ; the menustate instance ends at a specific timer
;              - #false                                                                                         ; the menustate does not end at a specific time
;
;            endtime-action is a Maybe<String> which is one of:
;              - a String representing an action (a code understood by the on-key function) of what to be done after the screen ends ; the menustate ends at a specific timer and game should do action
;              - #false                                                                                                              ; the menustate does not end at a specific time
;
;            key-actions is a Maybe<List> which is one of:
;              - a List<key-action> of 1 to many elements where:
;                    - a key-action is a list of strictly two elements, firstly a String representing a key which can be pressed matching (see Universe Library docs)        ; the menustate has keys which should be detected and handled
;                      and secondly a String representing a code to trigger when this key is pressed                                                                         ; when they are pressed
;              - #false                                                                                                                                                      ; the menustate has no keys to detect / handle
;
;
;
; constraints:
;            - if there is an endtime which is a Number and not a #false, there must also be an action which is not a #false
;
(provide (struct-out menu-state))
(define-struct menu-state (buttons text background endtime endtime-action key-actions))


;; struct rectangular-button-element

; DATA TYPE DEFINITION:
; A rectangular-button-element is a struct (make-rectangular-button-element pos size background text trigger-field hover-field trigger-action hover-action)
;      where pos            : posn<Number>
;            size           : posn<Number>
;            background     : Image
;            text-element   : Maybe<String>
;            trigger-field  : posn<Number>
;            hover-field    : posn<Number>
;            trigger-action : Maybe<String>
;            hover-action   : Maybe<String>
;
;
; interpretation:
;            pos is a posn<Number> representing the x and y coordinates of the position of the button on the screen in pixels
;            (both x and y values must be positive integers, in the range of the screen) measured from the center of the button
;
;            size is a posn<Number> representing the x and y dimensions of the button on the screen in pixels (both x and y values
;            must be positive integers)
;
;            background is an Image to be used as the background of the background itself
;
;            the text-element is a Maybe<text-element> which is one of:
;              - A text-element associated with the button ; the button has an "associated" text-element which should only ever be displayed
;                                                          ; with the button (i.e. if button is removed, this text should a
;              - #false                                    ; the button has no "associated" text-element
;
;            the trigger-field is a posn<posn<Number>> which represents the two points which span the "trigger-field" i.e. what to consider
;            when determining if a button click is associated with this button - this normally is the "whole button" but can alternatively
;            be other dimensions (such as a small part of a button) each posn represents a point - where the x & y coordinates are given in pixels.
;
;            the hover-field is a posn<posn<Number>> which represents the two points which span the "hover-field" i.e. what to consider
;            when determining if a button hover is associated with this button - this normally is the "whole button" but can alternatively
;            be other dimensions (such as a small part of a button) each posn represents a point - where the x & y coordinates are given in pixels (relative to the whole Image)
;
;            the trigger-action is a maybe<String> which represents a code for an action of what to do once the button is triggered (i.e. clicked)
;            this can be one of many strings "recognisable" in the on-key function (such as "start:SPLASH" to start a splash screen)
;
;            the hover-action is a maybe<String> which represents a code for an action of what to do once the button is hovered on
;            this can be one of many strings "recognisable" in the on-key function (such as "start:SPLASH" to start a splash screen)
;
;
(provide (struct-out rectangular-button-element))
(define-struct rectangular-button-element [pos size background text-element trigger-field hover-field trigger-action hover-action])

;; struct text-element

; DATA TYPE DEFINITION:
; A text-element is a struct (make-text-element text pos)
;      where text : Text
;            pos  : posn<Number>
;
;   
; interpretation:
;            text is a universe library text struct to be rendered on the screen
;
;            pos is a posn<Number> representing the x and y coordinates of the position of the text on the screen in pixels (where to render it)
;            (both x and y values must be positive integers, in the range of the screen) measured left of the text
;
;
(provide (struct-out text-element))
(define-struct text-element [text pos])


; Function get-state

;; DATA TYPE DEFINITION:
; CharacterState - defined above
; Maybe<CharacterState> - Either a CharacterState or #false
; List - built-in
; String - built-in


;; INPUT/OUTPUT:
; Signature:
; get-state : List<CharacterState> String -> Maybe<CharacterState>


; Purpose statement:
; Searches a list of CharacterStates for a state with a given identifier. 
; Returns the CharacterState if found, otherwise returns false.

; Header:
; (define (get-state lst "test") #false)

;; EXAMPLES:
; Test 1 - the state we are searching is present
(check-expect (get-state (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "jump" #true DRADRIANO-IDLE #false 0))
                         "Right")
              (make-character-state "Right" #true DRADRIANO-IDLE #false 0))

; Test 2 - the state we are searching is NOT present
(check-expect (get-state (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "jump" #true DRADRIANO-IDLE #false 0))
                         "Sneak")
              #false)

;; TEMPLATE:
;(define (get-state lst id)
;        ... (first lst) ...
;        ... (rest lst) ...
;        ... lst ...
;        ... id ...)

;; IMPEMENTATION:
(provide get-state)
(define (get-state lst id)
  (local [(define index (index-of (map (lambda (e) (equal? (character-state-statename e) id)) lst) #true))]
    (if (number? index)
        (list-ref lst index)
        #false)))


; Function remove-state

;; DATA TYPE DEFINITION:
; List - built-in
; String - built-in
; CharacterState - defined above

;; INPUT/OUTPUT:
; Signature:
; remove-state : List<CharacterState> String -> List<CharacterState>

; Purpose statement:
; returns the CharacterState associated with the given String, or returns false if there is no associated state

; Header:
; (define (remove-state lst "test") lst)

;; EXAMPLES:
; Test 1 - the state we wont to remove is present
(check-expect (remove-state (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "jump" #true DRADRIANO-IDLE #false 0))
                         "Right")
              (list (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                    (make-character-state "jump" #true DRADRIANO-IDLE #false 0)))

; Test 2 - the state we wont to remove is NOT present
(check-expect (remove-state (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                               (make-character-state "jump" #true DRADRIANO-IDLE #false 0))
                         "Sneak")
              (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0)
                    (make-character-state "Left" #true DRADRIANO-IDLE #false 0)
                    (make-character-state "jump" #true DRADRIANO-IDLE #false 0)))

;; TEMPLATE:
;(define (get-state lst id)
;        ... (first lst) ...
;        ... (rest lst) ...
;        ... lst ...
;        ... id ...)

;; IMPEMENTATION:
(provide remove-state)
(define (remove-state lst id)
  (remove #false (remove-duplicates (for/list ([e lst])
                                      (if (equal? id (character-state-statename e))
                                          #false
                                          e)))))



;; struct button

; DATA TYPE DEFINITION:
; A mouse-key is a struct (make-mouse-key pos action)
;      where pos    : posn<Number>
;            status : String
;
;   
; interpretation:
;            pos is a Posn of Numbers (strictly positive integers within the screen range in pixels) representing where a mouse action has happened
;
;            status is a String, strictly one of the following values:
;                - "hover" ; the mouse is currently located at pos but isn't clicked
;                - "click" ; the left mouse button is clicked
(provide (struct-out mouse-key))
(define-struct mouse-key [pos status])


; constant definitions part 2
(provide TEST-GAME-STATE)
(define TEST-GAME-STATE (make-game-state #true
                                         (make-level-state (list (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "")
                                                                 (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                           (make-character (make-posn 100 415)
                                                                           "DrAdriano"
                                                                           (list (make-character-state "Right" #true DRADRIANO-IDLE #false 0))
                                                                           (make-posn 64 64)
                                                                           3
                                                                           (make-posn 0 0))
                                                           #false
                                                           (make-posn 0 0)
                                                           60
                                                           (rectangle 0 0 "solid" "white"))
                                         '()))

(provide NOT-WORKING-GAME-STATE)
(define NOT-WORKING-GAME-STATE (make-game-state #false
                                                (make-level-state (list (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "" "" "" "" "" "" "" "")
                                                                        (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                                  (make-character (make-posn 100 415)
                                                                                  "DrAdriano"
                                                                                  (list (make-character-state "Idle" #true DRADRIANO-IDLE #false 0))
                                                                                  (make-posn 64 64)
                                                                                  3
                                                                                  (make-posn 0 0))
                                                                  #false
                                                                  (make-posn 0 0)
                                                                  60
                                                                  (rectangle 0 0 "solid" "white"))
                                                '()))

(provide LEVELONE)
(define LEVELONE (make-game-state #true
                                  (make-level-state GRID
                                                    (make-character INITIAL-POS
                                                                    "DrAdriano"
                                                                    (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                    (make-posn 28 60)
                                                                    3
                                                                    (make-posn 0 0))
                                                    #false
                                                    (make-posn 0 0)
                                                    60
                                                    (rectangle 2560 720 0 "white"))
                                  '()))

(provide SPLASH)
(define SPLASH (make-menu-state #false
                                (list (make-text-element (bitmap/file "img/Splash_Logo.png") (make-posn 640 360))
                                      (make-text-element (bitmap/file "img/press_space.png") (make-posn 640 575)))
                                (bitmap/file "img/Background.png")
                                #false ; endtime - 5 seconds from now
                                #false ; action - start level 1 after the SPLASH screen
                                (list
                                 (list " " "start:LEVELONE")
                                 )
                                )
  )

(provide INITIAL-GAME-STATE)
(define INITIAL-GAME-STATE (make-game-state
                            #true ; the game-state is running
                            SPLASH
                            '()
                            )
  )


(provide GAMEOVER)
(define GAMEOVER (make-menu-state #false ; make the menu
                                  (list (make-text-element (bitmap/file "img/gameOver.png") (make-posn 640 360)))
                                  (bitmap/file "img/Background.png")
                                  (+ (current-seconds) 3) ; endtime - 3 seconds from now
                                  "start:SPLASH" ; action - start splashscreen
                                  #false)
  )

(provide YOUWON)
(define YOUWON (make-menu-state #false ; make the menu
                                (list (make-text-element (bitmap/file "img/youWon.png") (make-posn 640 360)))
                                (bitmap/file "img/Background.png")
                                (+ (current-seconds) 3) ; endtime - 3 seconds from now
                                "start:SPLASH" ; action - start splashscreen
                                #false)
  )