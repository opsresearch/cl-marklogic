;;;; info.lisp

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

(defvar *cluster-config* nil
  "The default global cached cluster config.
  The macro with-cluster-config can be used to override the global cached cluster config.")

(defun get-cluster-config()
  "Get the global cached cluster config."
  *cluster-config*)

(defun set-cluster-config(new-value)
  "Set the global cached cluster cache."
  (setf *cluster-config* new-value))

(defmacro with-cluster-config ((cluster-config-value) &body body)
  "Bind `cluster-config-value` to *cluster-config* to override the global cached cluster configuration."
  `(let ((*cluster-config* ,cluster-config-value))
     (progn
       ,@body)))

(defun write-cluster-config (to &optional (config (get-cluster-config)))
  (cond ((streamp to)  (write config :stream to :readably t))          
        (T (with-open-file (stream to :direction :output :if-exists :supersede)
                           (write config :stream stream :readably t)))))

(defun read-cluster-config (from)
  (cond ((streamp from)  (read from))
        (T (with-open-file (stream from :direction :input)
                           (read stream)))))

(defun cache-cluster-config ()
  (set-cluster-config (get-cluster-config-from-connection)))

(defun get-cluster-config-from-connection ()
  (with-cluster-config (nil)
                       (list
                         (cons :type "ccfg")
                         (cons :version "1")
                         (cons :name (ml-rest:connection-property :name))
                         (cons :cluster-info (get-cluster-info))
                         (cons :group-info (get-group-info))
                         (cons :host-info (get-host-info))
                         (cons :database-info (get-database-info))
                         (cons :forest-info (get-forest-info))
                         (cons :id-names (get-id-names))
                         )))

(defun cluster-config-property (property-name &optional (cluster-config *cluster-config*))
  (cdr (assoc property-name cluster-config)))

(defun load-cluster-config (cluster-config-name)
  (let ((config (read-cluster-config 
                  (merge-pathnames
                    (make-pathname :directory '(:relative "default-project") :name cluster-config-name :type "ccfg")
                    (asdf:system-source-directory :cl-marklogic)))))
    (cond ((not (equal (cluster-config-property :type config) "ccfg")) nil)
          ((not (equal (cluster-config-property :version config) "1")) nil)
          (T config))))

(defun save-cluster-config (&optional (cluster-config *cluster-config*))
  (write-cluster-config 
    (merge-pathnames
      (make-pathname :directory '(:relative "default-project") :name (cluster-config-property :name cluster-config) :type "ccfg")
      (asdf:system-source-directory :cl-marklogic))
    cluster-config))


