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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Response processing

(defun find-multi-marker (content)
	(let (
		(start (search "--" content)))
	(subseq content
	 start
	 (search (format nil "~C~C" #\return #\linefeed) content :start2 start)
	 )))

(defun calc-text-offset (content)
	(+ 4 (search 
		(format nil "~C~C~C~C" #\return #\linefeed #\return #\linefeed)
		content)))

(defun extract-text-only (content)
	(let(
		(offset (calc-text-offset content))
		(end-marker (format nil "~A--" (find-multi-marker content))))
			(subseq content offset (+ -2 (search end-marker content :start2 offset)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Query processing

(defun read-stream (stream)
  (let ((seq (make-array (file-length stream) :element-type 'character :fill-pointer t)))
    (setf (fill-pointer seq) (read-sequence seq stream))
    seq))


(defun read-include (include)
	(with-open-file (stream 
		(merge-pathnames
			(make-pathname :directory '(:relative "xquery") :name include :type "xqy")
			(asdf:system-source-directory :cl-marklogic)
			))
 		(read-stream stream)))

(defun variables-to-json (variables)
	(format nil "{ ~{~a~} }"
		(mapcar 
			(lambda (it) (format nil "\"~A\":\"~A\" " (car it) (cdr it))) 
			variables)))

(defun inline-includes (xquery)
	(let (
		(begin (search "(:#include " xquery)))
	
	(if begin 
		(let (
			(file-begin (search " " xquery :start2 begin))
			(end (search ":)" xquery :start2 begin)))
			
				(inline-includes 
					(format nil "~A~A~A"
						(subseq xquery 0 begin)
						(read-include (string-trim " " (subseq xquery file-begin end )))
						(subseq xquery (+ 2 end))
						)))
		xquery )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evaluate an XQuery string

(defun evaluate-xquery(xquery &optional (variables () ))
"Evaluate an XQuery string inlining includes and applying variables."
	(let(
		(content 
			(babel:octets-to-string
				 (drakma:http-request 
					(format nil "~a://~a:~d~a" ;URI
						(cdr (assoc :protocol *connection*))
						(cdr (assoc :host *connection*))
						(cdr (assoc :port *connection*))
						(cdr (assoc :evaluate-path *connection*)))
					:method :post 
					:accept "multipart/mixed"
					:basic-authorization (list
						(cdr (assoc :user *connection*))
						(cdr (assoc :password *connection*)))
					:parameters (list
						(cons "xquery" (inline-includes xquery))
						(cons "vars" (variables-to-json variables)))))))
	(extract-text-only content)
	))

