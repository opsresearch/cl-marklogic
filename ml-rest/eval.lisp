;;;; xquery.lisp

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

(defun variables-to-json (variables)
  (format nil "{ ~{~a~^,~} }"
          (mapcar 
            (lambda (it) (format nil "\"~A\":\"~A\" " (car it) (cdr it))) 
            variables)))

(defun eval-xquery(xquery &optional (variables () ))
  "Evaluate an XQuery string inlining includes and applying variables."
  (read-from-string
    (extract-text-only
      (babel:octets-to-string
        (call (cdr (assoc :eval-path *connection*))
                       :method :post
                       :accept "multipart/mixed"
                       :parameters (list
                                     (cons "xquery" xquery)
                                     (cons "vars" (variables-to-json variables))))))))

