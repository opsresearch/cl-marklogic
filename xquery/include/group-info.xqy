(:group-info.xqy:)

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

declare function local:group-info() { 

  let $config := admin:get-configuration()
  let $groups := map:map()
  let $_ :=
    for $group-id in admin:get-group-ids($config)
      let $props := map:map()
      let $_ := (
        map:put($props, ':time-stamp', current-dateTime()),
        map:put($props, ':group-id', xs:string($group-id)),
        map:put($props, ':group-name', admin:group-get-name($config, $group-id)),
        map:put($props, ':performance-metering-enabled', admin:group-get-performance-metering-enabled($config, $group-id)),
        map:put($props, ':performance-metering-period', admin:group-get-performance-metering-period($config, $group-id)),
        map:put($props, ':performance-metering-retain-daily', admin:group-get-performance-metering-retain-daily($config, $group-id)),
        map:put($props, ':performance-metering-retain-hourly', admin:group-get-performance-metering-retain-hourly($config, $group-id)),
        map:put($props, ':performance-metering-retain-raw', admin:group-get-performance-metering-retain-raw($config, $group-id)),
        map:put($props, ':hosts', 
          for $id in admin:group-get-host-ids($config, $group-id)
            let $m := map:map()
            let $_ := map:put($m, ':host-id', xs:string($id))
            let $_ := map:put($m, ':host-name', admin:host-get-name($config, $id))
            return $m)
        )
      return map:put($groups, xs:string($group-id), $props)

return $groups
};


