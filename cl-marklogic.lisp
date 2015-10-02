;;;; cl-marklogic.lisp

;;;; ;;;;; BEGIN LICENSE BLOCK ;;;;;
;;;; 
;;;; Copyright (C) 2015 OpsResearch LLC (a Delaware company)
;;;; 
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU Lesser General Public License, version 3,
;;;; as published by the Free Software Foundation.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;; 
;;;; ;;;;; END LICENSE BLOCK ;;;;;

(in-package #:cl-marklogic)

(defun ping()
  "Receive the string \"pong\" echoed back from the server."
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    '&quot;pong&quot;' 
    "
    ))

(defun echo(string)
  "Receive the string argument echoed back from the server."
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    declare variable $string as xs:string external;
    (:#include to-sexpy :)
    local:to-sexpy($string) 
    "
    (list (cons "string" string))
    ))

(defun host-time()
  "Get the current local dateTime of the server."
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    (:#include to-sexpy :)
    local:to-sexpy(current-dateTime())
    "
    ))

