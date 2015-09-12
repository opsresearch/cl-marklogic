;;;; ml-test.asd

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

(asdf:defsystem #:ml-test
  :description "Tests for the system cl-marklogic"
  :author "Donald Anderson <dranderson@opsresearch.com>"
  :license "GPL3"
  :depends-on(
	#:fiveam
	#:cl-marklogic
	#:ml-optimizer)
  :serial t
  :components (
	(:file "package")
	(:module tests
		:serial t
		:components ((:file "test-marklogic")
					(:file "test-optimizer")
					(:file "test")))
	(:file "ml-test")))

