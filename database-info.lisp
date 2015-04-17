;;;; database-info.lisp

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
(defun database-ids (&optional (database-info (get-database-info)))
	"Returns a list the database ids in the cluster."
	(mapcar #'car database-info))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun database-property (database-id property &optional (database-info (get-database-info)))
	"Returns the value of a database property given the database-id and property.
	The available properties are:
	  :time-stamp      -> The date and time this a-list was created.
      :forest-ids      -> Id of this database.
	  :database-name   -> String name of the database.
	  :forests         -> Attached forest IDs.
	"
	(cdr (assoc property (cdr (assoc database-id database-info)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-database-info()
	"Returns two tier nested a-lists containing properties of all of the databases in the cluster."
	(read-from-string 
		(evaluate-xquery "
		    xquery version '1.0-ml';
		    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
		    (:#include database-info :)
		    local:database-info()
		    "
		    )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


