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

declare function local:i2s($ids){for $id in $ids return xs:string($id)};

declare function local:add-status-props($forest-id, $props){

 let $config := admin:get-configuration()
 let $status := xdmp:forest-status($forest-id)
 return (

    map:put($props, ':master-forest',         
      $status/fs:master-forest/text()),

    map:put($props, ':journals-size', 
      xs:unsignedLong($status/fs:journals-size/text())),

    map:put($props, ':large-data-size', 
      xs:unsignedLong($status/fs:large-data-size/text())),

    map:put($props, ':data-size', sum(xs:unsignedLong($status/fs:stands/fs:stand[fs:is-fast/text()='false']/fs:disk-size/text()))),

    map:put($props, ':memory-size', sum(xs:unsignedLong($status/fs:stands/fs:stand[fs:is-fast/text()='false']/fs:memory-size/text()))),

    map:put($props, ':fast-data-size', sum(xs:unsignedLong($status/fs:stands/fs:stand[fs:is-fast/text()='true']/fs:disk-size/text()))),

    map:put($props, ':fast-memory-size', sum(xs:unsignedLong($status/fs:stands/fs:stand[fs:is-fast/text()='true']/fs:memory-size/text()))),

    map:put($props, ':device-space', 
      xs:unsignedLong($status/fs:device-space/text())),

    map:put($props, ':large-device-space', 
      xs:unsignedLong($status/fs:large-device-space/text())),
    
    map:put($props, ':fast-device-space', 
      xs:unsignedLong($status/fs:fast-device-space/text()))
   )
};

declare function local:forest-info() { 

  let $config := admin:get-configuration()
  let $forests := map:map()
  let $_ :=
    for $forest-id in admin:get-forest-ids($config)
      let $props := map:map()
      let $_ := (
        map:put($props, ':time-stamp', current-dateTime()),
        map:put($props, ':forest-id', xs:string($forest-id)),
        map:put($props, ':forest-name', admin:forest-get-name($config, $forest-id)),
        map:put($props, ':host-id', xs:string(admin:forest-get-host($config, $forest-id))),
        map:put($props, ':database-id', xs:string(admin:forest-get-database($config, $forest-id))),
        map:put($props, ':data-dir', admin:forest-get-data-directory($config, $forest-id)),
        map:put($props, ':large-dir', admin:forest-get-large-data-directory($config, $forest-id)),
        map:put($props, ':fast-dir', admin:forest-get-fast-data-directory($config, $forest-id)),
        local:add-status-props($forest-id, $props),
        map:put($props, ':replica-forests', local:i2s(admin:forest-get-replicas($config, $forest-id))))
      return map:put($forests, xs:string($forest-id), $props)

return $forests
};


