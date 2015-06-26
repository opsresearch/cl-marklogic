;;;; cl-marklogic.asd

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

(asdf:defsystem #:cl-marklogic
  :description "Common Lisp library for accessing MarkLogic Server."
  :author "Donald Anderson <dranderson@OpsResearch.com>"
  :license "LGPL3"
  :depends-on (
    #:drakma
    #:local-time
    #:fiveam)
  :serial t
  :components ((:file "package")
               (:file "cl-marklogic")
               (:file "lisp/database")
               (:file "lisp/forest")
               (:file "lisp/host")
               (:file "lisp/rest-api")
               (:file "lisp/xquery")
               (:file "lisp/document")
               (:file "lisp/project")
               (:file "lisp/test")
               ))
