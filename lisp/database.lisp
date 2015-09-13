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
(defun database-names (&optional (database-info (get-database-info)))
  "Returns a list the database names in the cluster."
  (mapcar (lambda (entry) (cdr (assoc :database-name (cdr entry)))) database-info))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun database-name-p (database-name &optional (database-info (get-database-info)))
  "Returns T if database-name exists or nil if not."
  (find database-name (database-names database-info) :test #'equal))

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
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    (:#include to-sexpy :)
    (:#include database-info :)
    local:to-sexpy(local:database-info())
    "
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun database-create(database-name &key 
                                     (security-database-name "Security") 
                                     (schemas-database-name "Schemas") 
                                     (forest-attach-name nil) 
                                     (forest-create-name nil)
                                     (database-attach-name nil))
  "Creates a new database."
  
  ; create new forests if supplied
  (if (listp forest-create-name) 
      (mapcar #'forest-create forest-create-name)
      (forest-create forest-create-name))
  
  ; setup to attach attach new forests if created
  (when forest-create-name 
    (setf forest-attach-name forest-create-name))
  
  ; create new database
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    declare variable $database-name as xs:string external;
    declare variable $security-database-name as xs:string external;
    declare variable $schemas-database-name as xs:string external;
    (:#include to-sexpy :)
    let $config := admin:get-configuration()
    let $security-database-id := admin:database-get-id($config, $security-database-name)
    let $schemas-database-id := admin:database-get-id($config, $schemas-database-name)
    let $config := admin:database-create($config, $database-name, $security-database-id, $schemas-database-id)
    let $_ := admin:save-configuration($config)
    return local:to-sexpy($database-name)
    "
    (list 
      (cons "database-name" database-name)
      (cons "security-database-name" security-database-name)
      (cons "schemas-database-name" schemas-database-name)
      ))
  
  ; attach any sub-databases
  (if (listp database-attach-name) 
      (mapcar (lambda (name) (database-attach-sub-database database-name name)) database-attach-name)
      (database-attach-sub-database database-name database-attach-name))
  
  ; attach any forests
  (if (listp forest-attach-name) 
      (mapcar (lambda (name) (database-attach-forest database-name name)) forest-attach-name)
      (database-attach-forest database-name forest-attach-name))
  
  database-name
  
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun database-attach-forest(database-name forest-name)
  "Attaches a forest to a database."
  
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    declare variable $database-name as xs:string external;
    declare variable $forest-name as xs:string external;
    (:#include to-sexpy :)
    let $config := admin:get-configuration()
    let $database-id := admin:database-get-id($config, $database-name)
    let $forest-id := admin:forest-get-id($config, $forest-name)
    let $config := admin:database-attach-forest($config, $database-id, $forest-id)
    let $_ := admin:save-configuration($config)
    return local:to-sexpy($database-name)
    "
    (list 
      (cons "database-name" database-name)
      (cons "forest-name" forest-name)
      ))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun database-attach-sub-database(database-name sub-database-name)
  "Attaches a sub-database to a database."
  
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    declare variable $database-name as xs:string external;
    declare variable $sub-database-name as xs:string external;
    (:#include to-sexpy :)
    let $config := admin:get-configuration()
    let $database-id := admin:database-get-id($config, $database-name)
    let $sub-database-id := admin:database-get-id($config, $sub-database-name)
    let $config := admin:database-attach-sub-database($config, $database-id, $sub-database-id)
    let $_ := admin:save-configuration($config)
    return local:to-sexpy($database-name)
    "
    (list 
      (cons "database-name" database-name)
      (cons "sub-database-name" sub-database-name)
      ))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


