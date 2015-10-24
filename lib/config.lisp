;;;; config.lisp

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

(defvar *config* nil
  "A-list used by default for configuration.
  The macro with-config can be used to override the configuration.")

(defun get-config()
  "Get the global config value."
  *config*)

(defun set-config(new-value)
  "Set the global config value."
  (setf *config* new-value))

(defmacro with-config ((config-value) &body body)
  "Bind `config-value` to *config* to override the global config a-list."
  `(let ((*config* ,config-value))
     (progn
       ,@body)))

(defun write-config (to &optional (config (get-config)))
  (cond ((streamp to)  (write config :stream to :readably t))          
        (T (with-open-file (stream to :direction :output :if-exists :supersede)
                           (write config :stream stream :readably t)))))

(defun read-config (from)
  (cond ((streamp from)  (read from))
        (T (with-open-file (stream from :direction :input)
                           (read stream)))))

(defun config-property (property-name &optional (config *config*))
  (cdr (assoc property-name config)))

(defun load-config (config-name)
  (let ((config 
          (read-config 
            (merge-pathnames
              (make-pathname :directory '(:relative "default-project") :name config-name :type "cfg")
              (asdf:system-source-directory :cl-marklogic)))))
    (cond ((not (equal (config-property :type config) "cfg")) (print "Invalid :type"))
          ((not (equal (config-property :version config) "1")) (print "Invalid :version"))
          (T config))))

(defun save-config (&optional (config *config*))
  (write-config 
    (merge-pathnames
      (make-pathname :directory '(:relative "default-project") :name (config-property :name config) :type "cfg")
      (asdf:system-source-directory :cl-marklogic))
    config))

