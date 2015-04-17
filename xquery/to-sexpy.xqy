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

declare function local:to-sexpy($v) { 
	string-join(

		if(empty($v)) then " NIL "
		else if(count($v) gt 1) then local:seq-to-list($v)
		else
		typeswitch($v)
			case map:map 				return local:map-to-alist($v)
			case xs:string 				return (' &quot;', $v, '&quot; ')
			case xs:decimal 			return (' ', xs:string($v), ' ')
			case xs:float 				return (' ', xs:string($v), ' ')
			case xs:double 				return (' ', xs:string($v), ' ')
			case xs:boolean				return (' ', if($v) then 'T' else 'NIL', ' ')
			case xs:base64Binary		return (' &quot;', xs:string($v), '&quot; ')
			case xs:hexBinary			return (' &quot;', xs:string($v), '&quot; ')
			case xs:anyURI				return (' &quot;', xs:string($v), '&quot; ')
			case xs:QName				return (' &quot;', xs:string($v), '&quot; ')
			case xs:NOTATION			return (' &quot;', xs:string($v), '&quot; ')
			case xs:hexBinary			return (' &quot;', xs:string($v), '&quot; ')

			case xs:date 				return (' &quot;', xs:string($v), '&quot; ')
			case xs:time 				return (' &quot;', xs:string($v), '&quot; ')
			case xs:dateTime 			return (' &quot;', xs:string($v), '&quot; ')
			case xs:gYearMonth 			return (' &quot;', xs:string($v), '&quot; ')
			case xs:gYear 				return (' &quot;', xs:string($v), '&quot; ')
			case xs:gMonthDay 			return (' &quot;', xs:string($v), '&quot; ')
			case xs:gDay 				return (' &quot;', xs:string($v), '&quot; ')
			case xs:gMonth 				return (' &quot;', xs:string($v), '&quot; ')
			case xs:duration 			return (' &quot;', xs:string($v), '&quot; ')

			default 					return (' &quot;', xdmp:quote($v), '&quot; ')
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


