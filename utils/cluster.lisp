;;;; cluster.lisp

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

(defun cluster-names (&optional (cluster-info (get-cluster-info)))
  "Get a list the cluster names in the cluster."
  (mapcar (lambda (entry) (cdr (assoc :cluster-name (cdr entry)))) cluster-info))

(defun cluster-name-p (cluster-name &optional (cluster-info (get-cluster-info)))
  "Get T if cluster-name exists or nil if not."
  (find cluster-name (cluster-names cluster-info) :test #'equal))

(defun cluster-ids (&optional (cluster-info (get-cluster-info)))
  "Get a list of the cluster ids known to the local cluster."
  (mapcar #'car cluster-info))

(defun cluster-properties (cluster-id &optional (cluster-info (get-cluster-info)))
  "Get the properties for a cluster-id."
  (cdr (assoc cluster-id cluster-info :test #'equal)))

(defun cluster-property (cluster-id property &optional (cluster-info (get-cluster-info)))
  "Get the value of a cluster property given the cluster-id and property.
    The available properties are:
      :time-stamp -> The date and time this a-list was created.
      :cluster-id    -> Id of this cluster.
  "
  (cdr (assoc property (cdr (assoc cluster-id cluster-info)))))

(defun get-cluster-info()
  "Get a two tier nested a-lists containing properties of all of the clusters in the cluster."
  (evaluate-xquery 
    "
    xquery version '1.0-ml';
    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
    (:#include to-sexpy :)
    (:#include cluster-info :)
    local:to-sexpy(local:cluster-info())
    "
    ))




