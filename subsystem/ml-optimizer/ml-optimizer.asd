;;;; ml-optimizer.asd

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

(asdf:defsystem #:ml-optimizer
  :description "Common Lisp application to optimize MarkLogic clusters."
  :author "Donald Anderson <dranderson@OpsResearch.com>"
  :license "AGPL3"
  :depends-on
    (#:hunchentoot
     #:cl-json
     #:cl-marklogic
     #:cl-opsresearch)
  :serial t
  :components
    ((:file "package")
     (:file "ml-optimizer")
     (:module services
      :serial t
      :components 
        ((:file "services")
        (:file "cluster")
        (:file "group")
        (:file "host")
        (:file "database")
        (:file "forest")))))

