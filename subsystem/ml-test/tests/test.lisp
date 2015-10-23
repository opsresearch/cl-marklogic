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

(defun test-all ()
	"Run unit tests for cl-marklogic and subsystems."
  (test-marklogic)
  (test-optimizer))

(defun test-with-servers ()
  (ml-rest:with-connection
    ((ml-rest:load-connection "Server"))
    (test-marklogic))
  (ml-rest:with-connection
    ((ml-rest:load-connection "Cluster"))
    (test-marklogic))
  (ml-rest:with-connection
    ((ml-rest:load-connection "Cluster-DR"))
    (test-marklogic)))


