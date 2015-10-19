;;;; forest.lisp

;;;;; BEGIN LICENSE BLOCK ;;;;;
;;;; 
;;;; Copyright (C) 2015 OpsResearch LLC (a Delaware company)
;;;; 
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU Affero General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU Affero General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Affero General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;; 
;;;; END LICENSE BLOCK ;;;;;

(in-package #:ml-optimizer)

(defun forest-list () 
  	(json:encode-json-to-string (mapcar #'cdr (cl-marklogic:get-forest-info))))

(defun forest-detail (forest-id)
   (json:encode-json-to-string (cl-marklogic:forest-properties forest-id)))

(hunchentoot:define-easy-handler (forest :uri "/forest" :default-request-type :get)
                                 (id)
                                 (setf (hunchentoot:content-type*) "application/json")
                                 (if id (forest-detail id) (forest-list)))


