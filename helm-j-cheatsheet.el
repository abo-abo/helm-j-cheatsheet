;;; helm-j-cheatsheet.el --- Quick J reference for Emacs

;; Copyright (C) 2013  Oleh Krehel

;; Author: Oleh Krehel <ohwoeowho@gmail.com>
;; URL: https://github.com/abo-abo/helm-j-cheatsheet
;; Version: 0.1
;; Package-Requires: ((helm "1.5.3") (j-mode "1.0.0"))

;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:
;;
;; The J cheat sheet for Emacs:
;; * look up a command by English name
;; * look up a command at http://www.jsoftware.com/help/dictionary/

;;; Code:

(require 'helm)
(require 'helm-match-plugin)
(require 'j-mode)

(defgroup helm-j-cheatsheet nil
  "Quick J reference."
  :group 'helm
  :prefix "jc-")

(defface jc-verb-face
    '((t (:foreground "#110099")))
  "Face for verbs."
  :group 'helm-j-cheatsheet)

(defface jc-conjunction-face
    '((t (:foreground "#7F0055" :weight bold)))
  "Face for conjunctions."
  :group 'helm-j-cheatsheet)

(defface jc-adverb-face
    '((t (:foreground "#BE314C")))
  "Face for adverbs."
  :group 'helm-j-cheatsheet)

(defvar jc-verbs
  '(("=" "Self-Classify" "Equal" "d000")
    ("<" "Box" "Less Than" "d010")
    ("<." "Floor" "Lesser Of (Min)" "d011")
    ("<:" "Decrement" "Less Or Equal" "d012")
    (">" "Open" "Larger Than" "d020")
    (">." "Ceiling" "Larger of (Max)" "d021")
    (">:" "Increment" "Larger Or Equal" "d022")
    ("_:" "Infinity" "\"" "d032")
    ("+" "Conjugate" "Plus" "d100")
    ("+." "Real / Imaginary" "GCD (Or)" "d101")
    ("+:" "Double" "Not-Or" "d102")
    ("*" "Signum" "Times" "d110")
    ("*." "Length/Angle" "LCM (And)" "d111")
    ("*:" "Square" "Not-And" "d112")
    ("-" "Negate" "Minus" "d120")
    ("-." "Not" "Less" "d121")
    ("-:" "Halve" "Match" "d122")
    ("%" "Reciprocal" "Divide" "d130")
    ("%." "Matrix Inverse" "Matrix Divide" "d131")
    ("%:" "Square Root" "Root" "d132")
    ("^" "Exponential" "Power" "d200")
    ("^." "Natural Log" "Logarithm" "d201")
    ("$" "Shape Of" "Shape" "d210")
    ("$." "Sparse" "\"" "d211")
    ("$:" "Self-Reference" "" "d212")
    ("~." "Nub" "" "d221")
    ("~:" "Nub Sieve" "Not-Equal" "d222")
    ("|" "Magnitude" "Residue" "d230")
    ("|." "Reverse" "Rotate (Shift)" "d231")
    ("|:" "Transpose" "\"" "d232")
    ("," "Ravel" "Append" "d320")
    (",." "Ravel Items" "Stitch" "d321")
    (",:" "Itemize" "Laminate" "d322")
    (";" "Raze" "Link" "d330")
    (";:" "Words" "Sequential Machine" "d332")
    ("#" "Tally" "Copy" "d400")
    ("#." "Base 2" "Base" "d401")
    ("#:" "Antibase 2" "Antibase" "d402")
    ("!" "Factorial" "Out Of" "d410")
    ("/:" "Grade Up" "Sort" "d422")
    ("\\:" "Grade Down" "Sort" "d432")
    ("[" "Same" "Left" "d500")
    ("[:" "Cap" "\"" "d502")
    ("]" "Same" "Right" "d500")
    ("{" "Catalogue" "From" "d520")
    ("{." "Head" "Take" "d521")
    ("{:" "Tail" "" "d522")
    ("{::" "Map" "Fetch" "d523")
    ("}." "Behead" "Drop" "d531")
    ("}:" "Curtail" "" "d532")
    ("\"." "Do" "Numbers" "d601")
    ("\":" "Default Format" "Format" "d602")
    ("?" "Roll" "Deal" "d640")
    ("?." "Roll" "Deal (fixed seed)" "d641")
    ("A." "Anagram Index" "Anagram" "dacapdot")
    ("C." "Cycle-Direct" "Permute" "dccapdot")
    ("e." "Raze In" "Member (In)" "dedot")
    ("E." "" "Member of Interval" "decapdot")
    ("i." "Integers" "Index Of" "didot")
    ("i:" "Steps" "Index Of Last" "dico")
    ("I." "Indices" "Interval Index" "dicapdot")
    ("j." "Imaginary" "Complex" "djdot")
    ("L." "Level Of" "" "dlcapdot")
    ("o." "Pi Times" "Circle Function" "dodot")
    ("p." "Roots" "Polynomial" "dpdot")
    ("p.." "Poly. Deriv." "Poly. Integral" "dpdotdot")
    ("p:" "Primes" "\"" "dpco")
    ("q:" "Prime Factors" "Prime Exponents" "dqco")
    ("r." "Angle" "Polar" "drdot")
    ("s:" "Symbol" "\"" "dsco")
    ("u:" "Unicode" "\"" "duco")
    ("x:" "Extended Precision" "Num/Denom" "dxco")))

(defun jc-prep (face)
  "Return a function that fontifies a string."
  `(lambda(s)
    (replace-regexp-in-string
     "\\[[^]]*\\]"
     (lambda(x) (propertize (substring x 1 -1) 'face ',face))
     s)))

(defun jc-action-show-doc (x)
  "Extract from X the operation name and `j-help-lookup-symbol'."
  (j-help-lookup-symbol
   (and (string-match "^\\([^ ]+\\) " x)
        (match-string 1 x))))

(defvar helm-source-j-cheatsheet
  `(((name . "Adverbs")
     (candidates
      ,@(mapcar
         (jc-prep 'jc-adverb-face)
         '("~   [Reflex] • [Passive] / Evoke"
           "/   [Insert] • [Table]"
           "/.  [Oblique] • [Key]"
           "\\   [Prefix] • [Infix]"
           "\\.  [Suffix] • [Outfix]"
           "}   [Item Amend] • [Amend] (m} u})"
           "b.  [Boolean] / [Basic]"
           "f.  [Fix]"
           "M.  [Memo]"
           "t.  [Taylor Coeff.] (m t. u t.)"
           "t:  [Weighted Taylor]")))
     (action . jc-action-show-doc))
    ((name . "Conjunctions")
     (candidates
      ,@(mapcar
         (jc-prep 'jc-conjunction-face)
         '("^:  [Power] (u^:n u^:v)"
           ".   [Determinant] • [Dot Product]"
           "..  [Even]"
           ".:  [Odd]"
           ":   [Explicit]/[Monad-Dyad]"
           ":.  [Obverse]"
           "::  [Adverse]"
           ";.  [Cut]"
           "!.  [Fit]"
           "!:  [Foreign]"
           "\"   [Rank] (m\"n u\"n m\"v u\"v)"
           "`   [Tie] (Gerund)"
           "`:  [Evoke Gerund]"
           "@   [Atop]"
           "@.  [Agenda]"
           "@:  [At]"
           "&   [Bond] / [Compose]"
           "&.  [Under] (Dual)"
           "&.: [Under] (Dual)"
           "&:  [Appose]"
           "d.  [Derivative]"
           "D.  [Derivative]"
           "D:  [Secant Slope]"
           "H.  [Hypergeometric]"
           "L:  [Level At]"
           "S:  [Spread]"
           "T.  [Taylor Approximation]")))
     (action . jc-action-show-doc))
    ((name . "Verbs")
     (candidates
      ,@(mapcar
         (lambda(x)
           (format "% -3s % -18s %s"
                   (car x)
                   (propertize (cadr x) 'face 'jc-verb-face)
                   (propertize (caddr x) 'face 'jc-verb-face)))
         jc-verbs))
     (action . jc-action-show-doc))))

;;;###autoload
(defun helm-j-cheatsheet ()
  "Use helm to show a J cheat sheet."
  (interactive)
  (helm :sources helm-source-j-cheatsheet))

(provide 'helm-j-cheatsheet)

;;; helm-j-cheatsheet.el ends here
