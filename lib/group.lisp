;;;; group.lisp

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

(defun group-names (&optional (group-info (get-group-info)))
  "Get a list the group names in the group."
  (mapcar (lambda (entry) (cdr (assoc :group-name (cdr entry)))) group-info))

(defun group-name-p (group-name &optional (group-info (get-group-info)))
  "Get T if group-name exists or nil if not."
  (find group-name (group-names group-info) :test #'equal))

(defun group-ids (&optional (group-info (get-group-info)))
  "Get a list the group ids in the group."
  (mapcar #'car group-info))

(defun group-find-id-by-property (property value &optional (info (get-group-info)))
      (car (find value info :test (lambda (val entry) (equal val (cdr(assoc property (cdr entry))))))))

(defun group-properties (group-id &optional (group-info (get-group-info)))
  "Get the properties for a group-id."
  (cdr (assoc group-id group-info :test #'equal)))

(defun group-property (group-id property &optional (group-info (get-group-info)))
  "Get the value of a group property given the group-id and property.
    The available properties are:
      :time-stamp -> The date and time this a-list was created.
      :group-id    -> Id of this group.
      :group-name  -> String name of this group.
  "
  (cdr (assoc property (group-properties group-id group-info))))

(defun get-group-info()
  "Get a two tier nested a-lists containing properties of all of the groups in the group."
  (let ((group-info (assoc :group-info *cluster-config*)))
    (if group-info (cdr group-info)
        (evaluate-xquery 
          "
          xquery version '1.0-ml';
          import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
          (:#include to-sexpy :)
          (:#include group-info :)
          local:to-sexpy(local:group-info())
          "
          ))))



