;;;; dependent-hosts.lisp

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

(defvar *dependent-hosts* nil
  "A-list used by default for dependent host sets.
  The macro with-dependent-hosts can be used to override the dependent-hosts.")

(defun get-dependent-hosts()
  "Get the global dependent-hosts value."
  *dependent-hosts*)

(defun set-dependent-hosts(new-value)
  "Set the global dependent-hosts value."
  (setf *dependent-hosts* new-value))

(defmacro with-dependent-hosts ((dependent-hosts-value) &body body)
  "Bind `dependent-hosts-value` to *dependent-hosts* to override the global dependent-hosts a-list."
  `(let ((*dependent-hosts* ,dependent-hosts-value))
     (progn
       ,@body)))

(defun write-dependent-hosts (to &optional (dependent-hosts (get-dependent-hosts)))
  (cond ((streamp to)  (write dependent-hosts :stream to :readably t))          
        (T (with-open-file (stream to :direction :output :if-exists :supersede)
                           (write dependent-hosts :stream stream :readably t)))))

(defun read-dependent-hosts (from)
  (cond ((streamp from)  (read from))
        (T (with-open-file (stream from :direction :input)
                           (read stream)))))

(defun dependent-hosts-property (property-name &optional (dependent-hosts *dependent-hosts*))
  (cdr (assoc property-name dependent-hosts)))

(defun load-dependent-hosts (dependent-hosts-name)
  (let ((dependent-hosts 
          (read-dependent-hosts 
            (merge-pathnames
              (make-pathname :directory '(:relative "default-project") :name dependent-hosts-name :type "dpnd")
              (asdf:system-source-directory :ml-optimizer)))))
    (cond ((not (equal (dependent-hosts-property :type dependent-hosts) "dpnd")) (print "Invalid :type"))
          ((not (equal (dependent-hosts-property :version dependent-hosts) "1")) (print "Invalid :version"))
          (T dependent-hosts))))

(defun save-dependent-hosts (&optional (dependent-hosts *dependent-hosts*))
  (write-config 
    (merge-pathnames
      (make-pathname :directory '(:relative "default-project") :name (dependent-hosts-property :name dependent-hosts) :type "dpnd")
      (asdf:system-source-directory :ml-optimizer))))

(defun get-host-dependent-set-names (host-name)
  nil)

(defun add-host-dependencies (host-id host-properties &optional (host-info (cl-marklogic:get-host-info)))
  (let ((host-name (cl-marklogic:host-property host-id :host-name host-info)))
    (cons (cons :dependent-sets '("Rack-1" "Switch-1" "SAN-1")) host-properties)))


