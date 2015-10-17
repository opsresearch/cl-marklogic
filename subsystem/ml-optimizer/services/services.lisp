;;;; services.lisp

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

(defun ids-to-string (atom)
  (cond
    ((null atom) atom)
    ((not (listp atom)) atom)
    ((eq :host-id (car atom)) (cons (car atom) (write-to-string (cdr atom))))
    ((eq :database-id (car atom)) (cons (car atom) (write-to-string (cdr atom))))
    ((eq :forest-id (car atom)) (cons (car atom) (write-to-string (cdr atom))))
    (T (cons (ids-to-string (car atom)) (ids-to-string (cdr atom))))))

