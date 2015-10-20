;;;; connection.lisp

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

(defvar *connection* nil
  "A-list used by default to connect.
  The macro with-connection can be used to override the connection.")

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

(defun write-connection (&optional (to *standard-output*) &key (connection (get-connection)))
  (cond ((streamp to)  (write connection :stream to :readably t))          
        (T (with-open-file (stream to :direction :output :if-exists :supersede)
                           (write connection :stream stream :readably t)))))

(defun read-connection (&optional (from *standard-input*))
  (cond ((streamp from)  (read from))
        (T (with-open-file (stream from :direction :input)
                           (read stream)))))

(defun read-sample-connection (config)
  (read-connection 
    (merge-pathnames
      (make-pathname :directory '(:relative "samples" "connection") :name config :type "rest")
      (asdf:system-source-directory :cl-marklogic))))

(set-connection (read-sample-connection "localhost"))


