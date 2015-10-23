(:id-names.xqy:)

(:;; ;;;;; BEGIN LICENSE BLOCK ;;;;;
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
;;;; ;;;;; END LICENSE BLOCK ;;;:)

declare function local:id-names() { 

  let $config := admin:get-configuration()
  let $ids := map:map()
  
  (: cluster names :)
  let $_ :=for $id in (admin:cluster-get-id($config), admin:cluster-get-foreign-cluster-ids($config))
    return map:put($ids, xs:string($id), xdmp:cluster-name($id))
 
  (: group names :)
  let $_ :=for $id in admin:get-group-ids($config)
    return map:put($ids, xs:string($id), admin:group-get-name($config, $id))
 
 (: host names :)
  let $_ :=for $id in admin:get-host-ids($config)
    return map:put($ids, xs:string($id), admin:host-get-name($config, $id))
 
(: database names :)
  let $_ :=for $id in admin:get-database-ids($config)
    return map:put($ids, xs:string($id), admin:database-get-name($config, $id))
 
 (: forest names :)
  let $_ :=for $id in admin:get-forest-ids($config)
    return map:put($ids, xs:string($id), admin:forest-get-name($config, $id))
 
return $ids
};


