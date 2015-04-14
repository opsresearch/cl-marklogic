(:forest-info.xqy:)

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

(:#include to-sexpy :)

declare function local:forest-info() { 

  let $config := admin:get-configuration()
  let $forests := map:map()
  let $_ :=
    for $forest-id in admin:get-forest-ids($config)
      let $props := map:map()
      let $_ := (
        map:put($props, ':name', admin:forest-get-name($config, $forest-id)),
        map:put($props, ':host', admin:forest-get-host($config, $forest-id)),
        map:put($props, ':database', admin:forest-get-database($config, $forest-id)),
        map:put($props, ':replicas', admin:forest-get-replicas($config, $forest-id)),
        map:put($props, ':data-directory', admin:forest-get-data-directory($config, $forest-id)),
        map:put($props, ':large-directory', admin:forest-get-large-data-directory($config, $forest-id)),
        map:put($props, ':fast-directory', admin:forest-get-fast-data-directory($config, $forest-id))
        )
      return map:put($forests, xs:string($forest-id), $props)

return local:to-sexpy($forests)
};


