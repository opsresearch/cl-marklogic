;;;; get-hosts.lisp

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
(defun host-ids (&optional (host-info (get-host-info)))
	"Returns the a list the host ids in the cluster."
	(mapcar #'car host-info))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun host-property (host-id property &optional (host-info (get-host-info)))
	"Returns the value of a host property given the host-id and property.
	The available properties are:
	  :name        -> String name of the host.
	  :port        -> Port number to which the host is bound.
	  :group-id    -> Id of the group to which the host belongs.
	  :group-name  -> String name of the group for convenience.
	  :zone        -> Zone where the host is assigned.
	 "
	(cdr (assoc property (cdr (assoc host-id host-info)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-host-info()
	"Returns two tier nested a-lists containing properties of all of the hosts in the cluster."
	(read-from-string 
		(evaluate-xquery "
		    xquery version '1.0-ml';
		    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
		    (:#include host-info :)
		    local:host-info()
		    "
		    )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


