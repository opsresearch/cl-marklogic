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
;; Initial value for the global default connection

(defparameter *initial-connection* '(
	(:protocol      	. "http")
	(:host          	. "localhost")
	(:port          	. 8000)
	(:evaluate-path 	. "/LATEST/eval")
	(:document-path 	. "/LATEST/documents")
	(:rest-apis-path 	. "/LATEST/rest-apis")
  	(:user          	. "admin")
  	(:password      	. "passw0rd"))
"This global parameter is an a-list used to initialize the global connection.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global default connection

(defvar *connection* *initial-connection*
"This global variable is an a-list used by default to connect.
The macro with-connection can be used to override the connection.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get initial connection value

(defun get-initial-connection()
"This function returns the connection that is used to initialize the global connection."
 *initial-connection*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get global default connection

(defun get-connection()
"This function returns the global connection value."
 *connection*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set global default connection

(defun set-connection(new-value)
"This function sets the global connection value."
	(setf *connection* new-value))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Host check

(defun ping()
	"Returns the string \"pong\" echoed back from the server."
	(evaluate-xquery 
		"
		xquery version '1.0-ml';
		'&quot;pong&quot;' 
		"
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Host echo

(defun echo(string)
	"Returns the string argument echoed back from the server."
	(evaluate-xquery 
		"
		xquery version '1.0-ml';
		declare variable $string as xs:string external;
	    (:#include to-sexpy :)
		local:to-sexpy($string) 
		"
		(list (cons "string" string))
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Host dateTime

(defun host-time()
	"Returns the current local dateTime of the server."
	(evaluate-xquery 
		"
		xquery version '1.0-ml';
	    (:#include to-sexpy :)
		local:to-sexpy(current-dateTime())
		"
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Connection override.

(defmacro with-connection ((connection-value) &body body)
  "Binds `connection-value` to *connection* to override the global connection a-list."
  `(let ((*connection* ,connection-value))
     (progn
       ,@body)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



