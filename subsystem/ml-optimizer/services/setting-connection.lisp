;;;; setting-connection.lisp

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

;;;; ((:type           . "rest")
;;;; (:version         . "1")
;;;; (:name            . "Localhost")
;;;; (:protocol        . "http")
;;;; (:host            . "localhost")
;;;; (:port            . 8000)
;;;; (:eval-path       . "/LATEST/eval")
;;;; (:documents-path  . "/LATEST/documents")
;;;; (:rest-apis-path  . "/LATEST/rest-apis")
;;;; (:user            . "admin")
;;;; (:password        . "passw0rd"))

(in-package #:ml-optimizer)

(defun setting-connection-detail ()
  ;(print (ml-rest:get-connection))
  (let ((conn (ml-rest:get-connection)))
    (json:encode-json-to-string 
      `((:setting-id . "connection")
        (:setting-name . "Connection")
        (:setting-instance . "Current");,(cdr (assoc :name conn)))
        (:parameters . 
                     (((id . "connection.host")
                       (name . "Host")
                       (value . ,(cdr (assoc :host conn))))
                      ((id . "connection.protocol")
                       (name . "Protocol")
                       (value . ,(cdr (assoc :protocol conn))))
                      ((id . "connection.port")
                       (name . "Port")
                       (value . ,(cdr (assoc :port conn))))
                      ((id . "connection.user")
                       (name . "User")
                       (value . ,(cdr (assoc :user conn))))
                      ((id . "connection.password")
                       (name . "Passsword")
                       (value . ,(cdr (assoc :password conn))))
                      
                      ))))))








