;;;; admin-database.lisp

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

(in-package #:ml-rest)

;(setf drakma:*header-stream* *standard-output*)

(defparameter *initial-connection* 
  '((:protocol        . "http")
    (:host            . "localhost")
    (:port            . 8000)
    (:eval-path       . "/LATEST/eval")
    (:documents-path  . "/LATEST/documents")
    (:rest-apis-path  . "/LATEST/rest-apis")
    (:user            . "admin")
    (:password        . "passw0rd"))
  "A-list used to initialize the global connection.")

(defvar *connection* *initial-connection*
  "A-list used by default to connect.
  The macro with-connection can be used to override the connection.")

(defun get-initial-connection()
  "Get the connection that is used to initialize the global connection."
  *initial-connection*)

(defun get-connection()
  "Get the global connection value."
  *connection*)

(defun set-connection(new-value)
  "Set the global connection value."
  (setf *connection* new-value))

(defmacro with-connection ((connection-value) &body body)
  "Bind `connection-value` to *connection* to override the global connection a-list."
  `(let ((*connection* ,connection-value))
     (progn
       ,@body)))

(defun find-multi-marker (content)
  (let ((start (search "--" content)))
    (subseq content
            start
            (search (format nil "~C~C" #\return #\linefeed) content :start2 start)
            )))

(defun calc-text-offset (content)
  (+ 4 (search 
         (format nil "~C~C~C~C" #\return #\linefeed #\return #\linefeed)
         content)))

(defun extract-text-only (content)
  (let ((offset (calc-text-offset content))
        (end-marker (format nil "~A--" (find-multi-marker content))))
    (subseq content offset (+ -2 (search end-marker content :start2 offset)))))

(defun call( path &key (method :get) (parameters nil) (accept nil) (content nil) (content-type "application/json"))
	 (drakma:http-request 
    (format nil "~a://~a:~d~a" ;URI
            (cdr (assoc :protocol *connection*))
            (cdr (assoc :host *connection*))
            (cdr (assoc :port *connection*))
            path)
    :method method 
    ;:accept accept
    :content content
    :content-type content-type
    :basic-authorization (list
                           (cdr (assoc :user *connection*))
                           (cdr (assoc :password *connection*)))
    :parameters parameters))


