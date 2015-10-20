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

(in-package #:cl-marklogic)

(defun read-stream (stream)
  (let ((seq (make-array (file-length stream) :element-type 'character :fill-pointer t)))
    (setf (fill-pointer seq) (read-sequence seq stream))
    seq))


(defun read-include (include)
  (with-open-file (stream 
                    (merge-pathnames
                      (make-pathname :directory '(:relative "xquery" "include") :name include :type "xqy")
                      (asdf:system-source-directory :cl-marklogic)
                      ))
                  (read-stream stream)))

(defun inline-includes (xquery)
  (let ((begin (search "(:#include " xquery)))
    (if begin 
        (let ((file-begin (search " " xquery :start2 begin))
              (end (search ":)" xquery :start2 begin)))
          (inline-includes 
            (format nil "~A~A~A"
                    (subseq xquery 0 begin)
                    (read-include (string-trim " " (subseq xquery file-begin end )))
                    (subseq xquery (+ 2 end)))))
        xquery)))

(defun evaluate-xquery(xquery &optional (variables () ))
  "Evaluate an XQuery string inlining includes and applying variables."
  (ml-rest:eval-xquery (inline-includes xquery) variables))



