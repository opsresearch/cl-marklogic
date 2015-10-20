;;;; test.lisp

;;;; ;;;;; BEGIN LICENSE BLOCK ;;;;;
;;;; 
;;;; Copyright (C) 2015 OpsResearch LLC (a Delaware company)
;;;; 
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License, version 3,
;;;; as published by the Free Software Foundation.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;; 
;;;; ;;;;; END LICENSE BLOCK ;;;;;

(in-package #:ml-test)

(defun test-marklogic ()
  (5am:explain! (5am:run 'smoke-test-marklogic))
   
  (cl-marklogic:with-cluster-config (nil)
                       (5am:explain! (5am:run 'connect-test-marklogic))))

(5am:test smoke-test-marklogic
          (5am:is ( cl-marklogic:group-name-p "Default"))
          (5am:is ( cl-marklogic:database-name-p "Documents"))
          (5am:is ( cl-marklogic:forest-name-p "Documents")))

(5am:test connect-test-marklogic
          (5am:is ( equal (cl-marklogic:ping) "pong"))
          (5am:is ( equal (cl-marklogic:echo "5am echo test") "5am echo test"))
          
          (5am:is (cl-marklogic:get-cluster-info))
          (5am:is (cl-marklogic:get-group-info))
          (5am:is (cl-marklogic:get-host-info))
          (5am:is (cl-marklogic:get-database-info))
          (5am:is (cl-marklogic:get-forest-info)))



