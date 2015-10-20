;;;; appserver.lisp

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

(defun rest-api-create (group-name server-name port database-name modules-database-name)
  "Create a REST API server."
  (let ((json
          (format nil
                  "{ \"rest-api\": {
                  \"group\": \"~A\",
                  \"name\": \"~A\",
                  \"database\": \"~A\",
                  \"modules-database\": \"~A\",
                  \"port\": \"~A\"
                  }
                  }" group-name server-name database-name modules-database-name port)))
    (let ((resp
            (call-rest-api (cdr (assoc :rest-apis-path *connection*))
                           :method :post
                           :accept "application/json"
                           :content-type "application/json"
                           :content json)))
      (if resp (babel:octets-to-string resp) nil))))


