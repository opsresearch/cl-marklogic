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
	"Returns a list the forest ids in the cluster."
	(mapcar #'car forest-info))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun forest-property (forest-id property &optional (forest-info (get-forest-info)))
	"Returns the value of a forest property given the forest-id and property.
	The available properties are:
	  :time-stamp         -> The date and time this a-list was created.
	  :forest-ids         -> Id of this forest.
	  :forest-name        -> String name of the forest.
	  :host-id            -> Id of the host holding the forest.
	  :database-id        -> Id of the database composed from the forest.
	  :replicas           -> List of the ids of this forest's replicas.
	  :data-dir  	      -> Path of the normal data directory.
	  :large-dir          -> Path of the large data directory.
	  :fast-dir           -> Path of the fast data directory.
      :master-forest      -> Id of the master forest.
      :journals-size      -> Size of the journals on disk (MB).
      :large-data-size    -> Size of the large data on disk (MB).
      :data-size          -> Size of the normal data on disk (MB).
      :memory-size        -> Size of the normal data in memory (MB). 
      :fast-data-size     -> Size of the fast data on disk.
      :fast-memory-size   -> Size of the fast data in memory.
      :device-space       -> Available space on the normal device (MB).
      :large-device-space -> Available space on the large device (MB).
      :fast-device-space  -> Available space on the fast device (MB).
	 "
	(cdr (assoc property (cdr (assoc forest-id forest-info)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-forest-info()
	"Returns two tier nested a-lists containing properties of all of the forests in the cluster."
	(read-from-string 
		(evaluate-xquery
			"
		    xquery version '1.0-ml';
		    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
		    declare namespace fs = 'http://marklogic.com/xdmp/status/forest';
		    (:#include forest-info :)
		    local:forest-info()
		    "
		    )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-forest-status(forest-id)
	"Returns the complete XML representation of the forest's status."
	(evaluate-xquery
		"
	    xquery version '1.0-ml';
		declare variable $forest-id as xs:string external;
		xdmp:forest-status(xs:unsignedLong($forest-id))
		"
		(list (cons "forest-id" forest-id))
	    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


