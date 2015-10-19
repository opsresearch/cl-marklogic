(:cluster-info.xqy:)

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

declare function local:cluster-info() { 

  let $config := admin:get-configuration()
  let $clusters := map:map()
  let $_ :=
    for $cluster-id in (admin:cluster-get-id($config), admin:cluster-get-foreign-cluster-ids($config))
      let $props := map:map()
      let $_ := (
        map:put($props, ':time-stamp', current-dateTime()),
        map:put($props, ':cluster-id', xs:string($cluster-id)),
        map:put($props, ':cluster-name',  xdmp:cluster-name($cluster-id)),
        map:put($props, ':local-cluster-p', $cluster-id eq admin:cluster-get-id($config))

      )
      return map:put($clusters, xs:string($cluster-id), $props)

return $clusters
};


