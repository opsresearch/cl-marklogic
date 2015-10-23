;;;; id-names.lisp

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

(defun get-id-names()
  "Get a two tier nested a-lists containing the names associated with an ID."
  (let ((id-names (assoc :id-names *cluster-config*)))
    (if id-names (cdr id-names)
        (evaluate-xquery
          "
          xquery version '1.0-ml';
          import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
          (:#include to-sexpy :)
          (:#include id-names :)
          local:to-sexpy(local:id-names())
          "
          ))))