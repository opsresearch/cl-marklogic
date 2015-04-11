(:get-hosts.xqy:)

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

    xquery version '1.0-ml';

    import module namespace admin = 'http://marklogic.com/xdmp/admin' at '/MarkLogic/admin.xqy';

    let $config := admin:get-configuration()
    return
    string-join((
       '(',
       (
         for $host-id in admin:get-host-ids($config)
         return (
            concat('(', $host-id, ' . ('),
           concat('(',':name', ' . &quot;', admin:host-get-name($config, $host-id), '&quot;)'),
           concat('(',':port', ' . ', admin:host-get-port($config, $host-id), ')'),
           concat('(',':group-id', ' . ', admin:host-get-group($config, $host-id), ')'),
           concat('(',':group-name', ' . &quot;', admin:group-get-name($config, admin:host-get-group($config, $host-id)), '&quot;)'),
           if(admin:host-get-zone($config, $host-id)) then
             concat('(',':zone', ' . &quot;', admin:host-get-zone($config, $host-id), '&quot;)')
           else
             concat('(',':zone', ' . NIL)'),
           '))')
       ),
       ')'
    ))

    