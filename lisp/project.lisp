;;;; app.lisp

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

(defun install-database (database-name)	T)
(defun install-rest-server (server-name port database-name modules-database-name)	T)

(defun ingest-base-data (database-name &key (clear nil))
	(let ((path
		(merge-pathnames
			(make-pathname :directory '(:relative "data"))
			(asdf:system-source-directory :cl-marklogic)
			))))
	(ingest-directory database-name path :clear clear))

(defun ingest-base-modules (database-name &key (clear nil))
	(let ((path
		(merge-pathnames
			(make-pathname :directory '(:relative "modules"))
			(asdf:system-source-directory :cl-marklogic)
			))))
	(ingest-directory database-name path :clear clear))
