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

(defun expand-set-name (set-name host-sets &optional (max-depth 10))
  (let ((set (assoc set-name host-sets :test #'equal)))
    (if (and set (> max-depth 0))
        (alexandria:flatten
          (mapcar (lambda (name) (expand-set-name name host-sets (- max-depth 1))) (cdr set))) 
        set-name)))

(defun expand-host-set (host-set host-sets)
  (cons (car host-set) (expand-set-name (car host-set) host-sets)))

(defun expand-host-sets (host-sets)
  (mapcar (lambda (set) (expand-host-set set host-sets)) host-sets))

(defun get-expanded-host-sets ()
  (expand-host-sets (dependent-hosts-property :host-sets)))

(defun host-name-to-set-names (host-name &optional (expanded-sets (get-expanded-host-sets)))
  (remove nil (mapcar (lambda (set) (if (find host-name (cdr set) :test #'equal) (car set) nil))
                      expanded-sets)))

(defun set-names-to-host-names (set-names &optional (expanded-sets (get-expanded-host-sets)))
  (remove-duplicates
    (alexandria:flatten
      (mapcar (lambda (name) (cdr (assoc name expanded-sets :test #'equal))) set-names))
    :test #'equal))

(defun get-dependent-host-names (host-name)
  (remove-duplicates
    (cons host-name
          (set-names-to-host-names
            (host-name-to-set-names host-name)))
    :test #'equal))

(defun get-independent-host-names (host-name)
  (set-difference (cl-marklogic:host-names) (get-dependent-host-names host-name) :test #'equal))

(defun add-host-dependencies (host-id host-info)
  (let ((host-name (cl-marklogic:host-property host-id :host-name)))
    (cons (cons :dependent-sets (host-name-to-set-names host-name))
          (cons (cons :independent-hosts 
                      (cl-marklogic:host-find-id-by-property 
                        :host-name 
                        (get-independent-host-names host-name))) host-info))))
                      