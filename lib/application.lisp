;;;; application.lisp

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

(defun install-database (database-name &key (forest-create-name nil)) 
  (unless (database-name-p database-name) (database-create database-name :forest-create-name forest-create-name)))

(defun install-rest-server (group-name server-name port database-name modules-database-name)
  (rest-api-create group-name server-name port database-name modules-database-name))

(defun install-base-modules (database-name &key (clear nil))
  (ingest-source-directory database-name :cl-marklogic "modules" :clear clear))

(defun install-base-data (database-name &key (clear nil))
  (ingest-source-directory database-name :cl-marklogic "data" :clear clear))
