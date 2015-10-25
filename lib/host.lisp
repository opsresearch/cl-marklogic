;;;; host.lisp

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

(defun host-names (&optional (host-info (get-host-info)))
  "Get a list the host names in the host."
  (mapcar (lambda (entry) (cdr (assoc :host-name (cdr entry)))) host-info))

(defun host-name-p (host-name &optional (host-info (get-host-info)))
  "Get T if host-name exists or nil if not."
  (find host-name (host-names host-info) :test #'equal))

(defun host-ids (&optional (host-info (get-host-info)))
  "Get a list the host ids in the cluster."
  (mapcar #'car host-info))

(defun host-find-id-by-property (property values &optional (info (get-host-info)))
      (if (listp values) (mapcar (lambda (value) (host-find-id-by-property property value info)) values)
      (car (find values info :test (lambda (val entry) (equal val (cdr(assoc property (cdr entry)))))))))

(defun host-properties (host-id &optional (host-info (get-host-info)))
  "Get the properties for a host-id."
  (cdr (assoc host-id host-info :test #'equal)))

(defun host-property (host-id property &optional (host-info (get-host-info)))
  "Get the value of a host property given the host-id and property.
    The available properties are:
      :time-stamp -> The date and time this a-list was created.
      :host-id    -> Id of this host.
      :host-name  -> String name of this host.
      :bind-port  -> Port number to which this host is bound.
      :host    -> Id of the host to which this host belongs.
      :zone     -> Zone where this host is assigned.
  "
  (cdr (assoc property (host-properties host-id host-info))))

(defun get-host-info()
  "Get a two tier nested a-lists containing properties of all of the hosts in the cluster."
  (let ((host-info (assoc :host-info *cluster-config*)))
    (if host-info (cdr host-info)
        (evaluate-xquery 
          "
          xquery version '1.0-ml';
          import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';
          (:#include to-sexpy :)
          (:#include host-info :)
          local:to-sexpy(local:host-info())
          "
          ))))





