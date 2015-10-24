;;;; forest.lisp

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

(defun forest-names (&optional (forest-info (get-forest-info)))
  "Get a list the forest names in the cluster."
  (mapcar (lambda (entry) (cdr (assoc :forest-name (cdr entry)))) forest-info))

(defun forest-name-p (forest-name &optional (forest-info (get-forest-info)))
  "Get T if forest-name exists or nil if not."
  (find forest-name (forest-names forest-info) :test #'equal))

(defun forest-ids (&optional (forest-info (get-forest-info)))
  "Get a list of the forest ids in the cluster."
  (mapcar #'car forest-info))

(defun forest-find-id-by-property (property value &optional (info (get-forest-info)))
      (car (find value info :test (lambda (val entry) (equal val (cdr(assoc property (cdr entry))))))))

(defun forest-properties (forest-id &optional (forest-info (get-forest-info)))
  "Get the properties for a forest-id."
  (cdr (assoc forest-id forest-info :test #'equal)))

(defun forest-property (forest-id property &optional (forest-info (get-forest-info)))
  "Get the value of a forest property given the forest-id and property.
    The available properties are:
      :time-stamp         -> The date and time this a-list was created.
      :forest-ids         -> Id of this forest.
      :forest-name        -> String name of the forest.
      :host-id            -> Id of the host holding the forest.
      :database-id        -> Id of the database composed from the forest.
      :replicas           -> List of the ids of this forest's replicas.
      :data-dir           -> Path of the normal data directory.
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
  (cdr (assoc property (forest-properties forest-id forest-info))))

(defun get-forest-info()
  "Get a two tier nested a-lists containing properties of all of the forests in the cluster."
  (let ((forest-info (assoc :forest-info *cluster-config*)))
    (if forest-info (cdr forest-info)
        (evaluate-xquery
          "
          xquery version '1.0-ml';
          import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
          declare namespace fs = 'http://marklogic.com/xdmp/status/forest';
          (:#include to-sexpy :)
          (:#include forest-info :)
          local:to-sexpy(local:forest-info())
          "
          ))))

(defun get-forest-status(forest-id)
  "Get the complete XML representation of the forest's status."
  (evaluate-xquery
    "
    xquery version '1.0-ml';
    declare variable $forest-id as xs:string external;
    (:#include to-sexpy :)
    local:to-sexpy(xdmp:forest-status(xs:unsignedLong($forest-id)))
    "
    (list (cons "forest-id" forest-id))
    ))

(defun forest-create(forest-name &key (host-name nil) (data-directory nil) (large-data-directory nil) (fast-data-directory nil))
  "Create a new forest."
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    declare variable $forest-name as xs:string external;
    declare variable $host-name as xs:string external;
    declare variable $data-directory as xs:string external;
    declare variable $large-data-directory as xs:string external;
    declare variable $fast-data-directory as xs:string external;
    (:#include to-sexpy :)
    
    let $config := admin:get-configuration()
    let $host-id :=        if ($host-name = 'NIL') then xdmp:host() else admin:host-get-id($config, $host-name)
    let $data-directory :=     if($data-directory = 'NIL') then () else $data-directory
    let $fast-data-directory :=    if($fast-data-directory = 'NIL') then () else $fast-data-directory
    let $large-data-directory :=   if($large-data-directory = 'NIL') then () else $large-data-directory
    
    let $config := admin:forest-create($config, $forest-name, $host-id, $data-directory, $large-data-directory, $fast-data-directory)
    let $_ := admin:save-configuration($config)
    return local:to-sexpy($forest-name)
    "
    (list 
      (cons "forest-name" forest-name)
      (cons "host-name" host-name)
      (cons "data-directory" data-directory)
      (cons "large-data-directory" large-data-directory)
      (cons "fast-data-directory" fast-data-directory)
      ))
  )

