(:/cl-marklogic/to-sexpy.xqy:)

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

xquery version "1.0-ml";
declare namespace clml = "http://opsresearch.com/cl-marklogic";

declare function clml:to-sexpy($v) {
  local:to-sexpy($v)
};

(: ---- CUT HERE ---- :)

declare function local:to-sexpy($v) { 
	string-join(

		if(empty($v)) then " NIL "
		else if(count($v) gt 1) then local:seq-to-list($v)
		else
		typeswitch($v)
			case map:map 				return local:map-to-alist($v)
			case xs:string 				return local:tos($v)
			case xs:decimal 			return xs:string($v)
			case xs:float 				return xs:string($v)
			case xs:double 				return xs:string($v)
			case xs:boolean				return if($v) then 'T' else 'NIL'
			case xs:base64Binary		return local:tos($v)
			case xs:hexBinary			return local:tos($v)
			case xs:anyURI				return local:tos($v)
			case xs:QName				return local:tos($v)
			case xs:NOTATION			return local:tos($v)
			case xs:hexBinary			return local:tos($v)

			case xs:date 				return concat('@', xs:string($v))
			case xs:time 				return concat('@', xs:string($v))
			case xs:dateTime 			return concat('@', xs:string($v))
			case xs:gYearMonth 			return concat('@', xs:string($v), '-1')
			case xs:gYear 				return concat('@', xs:string($v), '-1-1')
			case xs:gMonthDay 			return local:tos($v)
			case xs:gDay 				return local:tos($v)
			case xs:gMonth 				return local:tos($v)
			case xs:duration 			return local:tos($v)

			default 					return local:tos(xdmp:quote($v))
		,' ')
};

declare function local:tos($v){
	concat('&quot;', replace(xs:string($v), "&quot;", "\\&quot;"), '&quot;')
};

declare function local:seq-to-list($seq) { 
	string-join((
		'(',
		for $val in $seq
		  return 
			  local:to-sexpy($val),
		')'
	), ' ')
};

declare function local:map-to-alist($map) { 
	string-join((
		'(',
		for $key in map:keys($map)
			let $value := map:get($map, $key)
			return 
				('(', $key, ' . ', local:to-sexpy($value),')'),
		')'
	),' ')
};
