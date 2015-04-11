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

(defun evaluate-xquery(xquery)
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
					:basic-authorization `(
						,(cdr (assoc :user *connection*))
						,(cdr (assoc :password *connection*)))
					:parameters `(
						("xquery" . ,xquery))))))

	(extract-text-only content)

	))

