(:local-host-info.xqy:)

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

(:#include map-to-alist :)

declare function local:host-info() { 

  let $config := admin:get-configuration()
  let $hosts := map:map()
  let $_ :=
    for $host-id in admin:get-host-ids($config)
      let $props := map:map()
      let $_ := (
        map:put($props, ':name', admin:host-get-name($config, $host-id)),
        map:put($props, ':port', admin:host-get-port($config, $host-id)),
        map:put($props, ':group-id', admin:host-get-group($config, $host-id)),
        map:put($props, ':group-name', admin:group-get-name($config, admin:host-get-group($config, $host-id))),

        if(admin:host-get-zone($config, $host-id)) then
          map:put($props, ':zone', admin:host-get-zone($config, $host-id))
        else
          ()
      )
      return map:put($hosts, xs:string($host-id), $props)

return local:map-to-alist($hosts)
};


