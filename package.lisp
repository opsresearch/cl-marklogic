;;;; package.lisp

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

(defpackage #:cl-marklogic
  (:use #:cl)
  (:export
    #:ping
    #:echo
    
    #:get-cluster-config
    #:set-cluster-config
    #:with-cluster-config
    #:get-cluster-config-from-connection
    #:write-cluster-config
    #:read-cluster-config
    #:read-sample-cluster-config
    #:cache-cluster-config
    
    #:get-cluster-info
    #:cluster-ids
    #:cluster-names
    #:cluster-name-p
    #:cluster-property
    #:cluster-properties
    
    #:get-group-info
    #:group-ids
    #:group-names
    #:group-name-p
    #:group-property
    #:group-properties
    
    #:get-host-info
    #:host-ids
    #:host-names
    #:host-name-p
    #:host-property
    #:host-properties
    
    #:get-database-info
    #:database-ids
    #:database-names
    #:database-name-p
    #:database-property
    #:database-properties
    #:database-attach-forest
    #:database-create
    
    #:get-forest-info
    #:forest-ids
    #:forest-names
    #:forest-name-p
    #:forest-property
    #:forest-properties
    #:get-forest-status
    #:forest-create
    
    #:evaluate-xquery
    #:host-time
    #:rest-api-create
    #:put-document
    #:get-document
    #:delete-document
    #:put-document
    #:post-documents
    #:ingest-directory
    #:ingest-source-directory
    #:install-database
    #:install-base-data
    #:install-base-modules
    #:install-rest-server
    ))

(defpackage #:ml-rest
  (:use #:cl)
  (:export
    #:call
    #:eval-xquery
    #:set-connection
    #:get-connection
    #:get-initial-connection
    #:with-connection
    ))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (local-time:enable-read-macros))

