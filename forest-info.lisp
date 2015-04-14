;;;; forest-info.lisp

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
(defun forest-ids (&optional (forest-info (get-forest-info)))
	"Returns the a list the forest ids in the cluster."
	(mapcar #'car forest-info))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun forest-property (forest-id property &optional (forest-info (get-forest-info)))
	"Returns the value of a forest property given the forest-id and property.
	The available properties are:
	  :name            -> String name of the forest.
	  :host            -> Id of the host holding the forest.
	  :database        -> Id of the database composed from the forest.
	  :replicas        -> List of the ids of this forest's replicas.
	  :data-directory  -> Path of the data directory.
	  :large-directory -> Path of the large data directory.
	  :fast-directory  -> Path of the fast data directory.
	 "
	(cdr (assoc property (cdr (assoc forest-id forest-info)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-forest-info()
	"Returns two tier nested a-lists containing properties of all of the forests in the cluster."
	(read-from-string 
		(evaluate-xquery "
		    xquery version '1.0-ml';
		    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
		    (:#include forest-info :)
		    local:forest-info()
		    "
		    )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


