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
  "This is the default global cached cluster config.
  Use the macro with-cluster-config to wrap expressions that you want to use a different default configuration.")

(defun get-cluster-config()
  "This funtion returns the global cached cluster config."
  *cluster-config*)

(defun set-cluster-config(new-value)
  "This function sets the value of the global cached cluster cache."
  (setf *cluster-config* new-value))

(defmacro with-cluster-config ((cluster-config-value) &body body)
  "This macro binds `cluster-config-value` to *cluster-config* overriding the default cached cluster configuration for the wrapped expressions."
  `(let ((*cluster-config* ,cluster-config-value))
     (progn
       ,@body)))

(defun write-cluster-config (to &optional (config (get-cluster-config)))
  "This function writes a cluster configuration to a stream."
  (cond ((streamp to)  (write config :stream to :readably t))          
        (T (with-open-file (stream to :direction :output :if-exists :supersede)
                           (write config :stream stream :readably t)))))

(defun read-cluster-config (from)
  "This function reads a cluster configuration from a stream."
  (cond ((streamp from)  (read from))
        (T (with-open-file (stream from :direction :input)
                           (read stream)))))

(defun cache-cluster-config ()
  "This function refreshes the default cached cluster configuration from the default connection."
  (set-cluster-config (get-cluster-config-from-connection)))

(defun get-cluster-config-from-connection ()
  "This function fetches a fresh cluster configuration from the default connection."
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
  "This function accesses a property in a cluster configuration."
  (cdr (assoc property-name cluster-config)))

(defun load-cluster-config (cluster-config-name)
  "This function loads a cluster configuration from a project located in the system source tree into the default cached cluster configuration."
  (let ((config (read-cluster-config 
                  (merge-pathnames
                    (make-pathname :directory '(:relative "default-project") :name cluster-config-name :type "ccfg")
                    (asdf:system-source-directory :cl-marklogic)))))
    (cond ((not (equal (cluster-config-property :type config) "ccfg")) nil)
          ((not (equal (cluster-config-property :version config) "1")) nil)
          (T config))))

(defun save-cluster-config (&optional (cluster-config *cluster-config*))
  "This function saves a cluster configuration to a project located in the system source tree from the default cached cluster configuration."
  (write-cluster-config 
    (merge-pathnames
      (make-pathname :directory '(:relative "default-project") :name (cluster-config-property :name cluster-config) :type "ccfg")
      (asdf:system-source-directory :cl-marklogic))
    cluster-config))


