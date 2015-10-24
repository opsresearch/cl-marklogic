;;;; initialize.lisp

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

; init config
(set-config (load-config "Default"))

; init connection
(ml-rest:set-connection (ml-rest:load-connection (config-property :default-connection-name)))

; init cluster config
(set-cluster-config (load-cluster-config (config-property :default-load-name)))


(defun save-all-ccfg ()
  (ml-rest:set-connection (ml-rest:load-connection "Server"))
  (cache-cluster-config)
  (save-cluster-config)
  
  (ml-rest:set-connection (ml-rest:load-connection "Cluster"))
  (cache-cluster-config)
  (save-cluster-config)

  (ml-rest:set-connection (ml-rest:load-connection "Cluster-DR"))
  (cache-cluster-config)
  (save-cluster-config))
