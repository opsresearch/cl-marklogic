(:to-sexpy.xqy:)

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

declare function local:to-sexpy($value) { 
	string-join(
		if($value instance of map:map) then
			local:map-to-alist($value)
      	else if($value instance of xs:string) then
			(' &quot;', xs:string($value), '&quot; ')
		else if(count($value) eq 0) then
			" NIL "
		else if(count($value) gt 1) then
			local:seq-to-list($value)
		else
			(' ', xs:string($value), ' ')
		)
};

declare function local:seq-to-list($seq) { 
	string-join((
		'(',
		for $val in $seq
		  return 
			  local:to-sexpy($val),
		')'
	))
};

declare function local:map-to-alist($map) { 
	string-join((
		'(',
		for $key in map:keys($map)
			let $value := map:get($map, $key)
			return 
				('(', $key, ' . ', local:to-sexpy($value),')'),
		')'
	))
};


