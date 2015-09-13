;;;; document.lisp

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
;; Query processing

(defun octets-to-string (octets)
  (if octets (babel:octets-to-string octets) octets))

(defun put-document(uri content content-type &key (database nil) )
  "Put a document by URI."
		(call-rest-api (cdr (assoc :document-path *connection*))
                 :method :put
                 :accept "appliation/json"
                 :content content
                 :parameters (list
                               (cons "uri" uri)
                               (cons "database" database)
                               )))

(defun get-document(uri &key (accept nil) (database nil))
  "Get a document by URI."
  (call-rest-api (cdr (assoc :document-path *connection*))
                 :method :get
                 :accept accept
                 :parameters (list
                               (cons "uri" uri)
                               (cons "database" database))))

(defun delete-document(uri &key (database nil))
  "Delete a document BY URI."
		(call-rest-api (cdr (assoc :document-path *connection*))
                 :method :delete
                 :accept "appliation/json"
                 :parameters (list
                               (cons "uri" uri)
                               (cons "database" database))))

(defun ingest-source-directory (database-name system dir-name &key (clear nil))
  (let ((path
          (merge-pathnames
            (make-pathname :directory `(:relative ,dir-name))
            (asdf:system-source-directory system)
            )))
    (ingest-directory database-name path :clear clear)))

(defun ingest-directory (database-name path &key (clear nil))	T)



