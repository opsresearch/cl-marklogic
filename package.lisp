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
    
    #:set-config
    #:get-config
    #:with-config
    #:write-config
    #:read-config
    #:load-config
    #:save-config
    #:config-property
    
    #:get-cluster-config
    #:set-cluster-config
    #:with-cluster-config
    #:get-cluster-config-from-connection
    #:write-cluster-config
    #:read-cluster-config
    #:load-cluster-config
    #:save-cluster-config
    #:cluster-config-property
    #:cache-cluster-config
    
    #:get-id-names
    
    #:get-cluster-info
    #:cluster-ids
    #:cluster-names
    #:cluster-name-p
    #:cluster-property
    #:cluster-properties
    #:cluster-find-id-by-property
    
    #:get-group-info
    #:group-ids
    #:group-names
    #:group-name-p
    #:group-property
    #:group-properties
    #:group-find-id-by-property
    
    #:get-host-info
    #:host-ids
    #:host-names
    #:host-name-p
    #:host-property
    #:host-properties
    #:host-find-id-by-property
    
    #:get-database-info
    #:database-ids
    #:database-names
    #:database-name-p
    #:database-property
    #:database-properties
    #:database-attach-forest
    #:database-create
    #:database-find-id-by-property
    
    #:get-forest-info
    #:forest-ids
    #:forest-names
    #:forest-name-p
    #:forest-property
    #:forest-properties
    #:get-forest-status
    #:forest-create
    #:forest-find-id-by-property
    
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
    #:set-connection
    #:get-connection
    #:get-initial-connection
    #:with-connection
    #:write-connection
    #:read-connection
    #:load-connection
    #:save-connection
    #:connection-property
    
    #:call
    #:eval-xquery
    ))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (local-time:enable-read-macros))

