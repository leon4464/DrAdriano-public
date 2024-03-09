;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname function-template) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #true #true none #false () #false)))
;; Inside this file you can find a basic template for you to copy, so that every thing is the same and is easier to read for all
;; Everything that is surrounded by <> has to be changed, according to the pattern present inside the brackets, like the name of the function: {functionName>




; Function <function-name>
; <100>% completed
;
; Missing:
; - <what is still needed to be implemented>
; - <another thing that has to be implemented>

; Dependencies:
; - <name-of-the-function>
; - <only-if-needed>

;; DATA TYPE DEFINITION:
; <DataType> - <definition or where i can find it>
; <AnotherDataType> - <defined in definitions.rkt>
; <OneMoreDataType> - <built-in>

;; INPUT/OUTPUT:
; Signature:
; <function-name> : <DataTypeOfTheFirstArgument> <DataTypeOfTheSecondArgument> <DataTypeOfTheThirdArgument> -> <DataTypeOfTheOutput>

; Purpose statement:
; <brief description of what the function does>

; Header:
; (define (<function-name> <"a possible first argument"> <1> <state>) <"a possible output">)

;; EXAMPLES:
; Test <1> - <description of what is the test checking for>
(check-expect (<function-name>
               ; <a brief description of what we are passing to the function>
               <(the (inputof)
                     (the function))>)
              ; <a brief description of what we are expecting>
               <(the (expected output)
                     (of the function))>)

;; TEMPLATE:
;(define (<function-name> <theNameIDecideTheFirstArgumentHave> <theNameIDecideTheSecondArgumentHave>)
;        ... (<an-operation-i-can-do-on FirstArgument>) ...
;        ... (<another-operation-i-can-do-on FirstArgument>) ...
;        ... (<an-operation-i-can-do-on FirstArgument>) ...
;        ... <FirstArgument> ...
;        ... <SecondArgument> ...)

;; IMPEMENTATION:
(define (<function-name> <theNameIDecideTheFirstArgumentHave> <theNameIDecideTheSecondArgumentHave>)
         ; <sometimes add some phrases to explain what you are doing (expecially ADRIANO!)>
        (<implementation done by you>))

