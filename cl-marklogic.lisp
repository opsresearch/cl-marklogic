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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Connection

(defparameter *connection* '(
	(:URL         . "http://localhost:8001/")
	(:protocol      . "http")
	(:host          . "localhost")
	(:port          . 8000)
	(:evaluate-path . "/LATEST/eval")
  	(:user          . "admin")
  	(:password      . "passw0rd"))
"Rest Connection Parameters: an a-list of properties.")

(defun get-connection() *connection*)
(defun set-connection(new-value)
	(setf *connection* new-value))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ping()
	"Returns the string \"pong\" echoed back from the server."
	(evaluate-xquery 
		"
		xquery version '1.0-ml';
		'pong' 
		"
	))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Connection management.

(defmacro with-connection ((connection-value) &body body)
  "Binds `connection-value` to *connection* for the expression evaluation."
  `(let ((*connection* ,connection-value))
     (progn
       ,@body)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



