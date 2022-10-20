%dw 2.0

import * from ConstModule

/**
* `ramlTypeOf` function purpose is to match dataweave type with raml type.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `val` | Any | value which raml type function returns
* |===
*
*/

fun ramlTypeOf(val: Any): String = do { 
        var tmp = if ( val is String ) val as DateTime default val 
                  else val
        ---
        typeOf(tmp) match {
            case "String" -> "string"
            case "Object" -> "object"
            case "Array" -> "array"
            case "Number" -> "number"
            case "Boolean" -> "boolean"
            case "DateTime" -> "datetime"
            else -> "NOT_DEFINED_TYPE"
        }}

/**
* `convert2raml` function purpose is to generate raml datatype by any given object.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `val` | Any | 
* | `isOrNull` | Bool | if true it generates raml with types that contains nil as one of theirs value, otherwise all of them are strict. By default False.
* | `isRequired` | Bool | if true it generates raml with all required keys, otherwise all of them are optinal. By default True.
* |===
*
* === Example
*
* This example shows how the `convert2raml` function behaves under different inputs.
*
*       convert2raml(input, true, false)
*
*       convert2raml(input, false, true)
*
* ==== Source
*
*   {
*       "mess1": "mes",
*       "mess2": {
*           "sub_mess": 2
*           }
*    }
*
* ----
*
*    <note>
*    <to>Tove</to>
*    <from>Jani</from>
*    <heading>Reminder</heading>
*    <body>Don't forget me this weekend!</body>
*    </note>
*
* ==== Output
*
*   type: object
*    properties:
*    mess1: string
*    mess2:
*        type: object
*        properties:
*        sub_mess: number
*
* ----
*
*   type: object
*    properties:
*    note?:
*        type: object
*        properties:
*        to?: string?
*        from?: string?
*        heading?: string?
*        body?: string?
*/

fun convert2raml(arr: Array, isOrNull: Boolean = false, isRequired: Boolean = true): Object | String = 
    if ( isEmpty(arr))
        ARRAY_KEYWORD
    else
        {
            (TYPE_KEYWORD): ARRAY_KEYWORD,
            (ITEMS_KEYWORD): convert2raml(arr[0], isOrNull, isRequired),
        }

fun convert2raml(obj: Object, isOrNull: Boolean = false, isRequired: Boolean = true): Object | String = do {
        var props = obj mapObject ((value, key, index) -> 
                        do {
                            var pKey = if (isRequired) key else key ++ QUEST_MARK
                            ---
                            (pKey): convert2raml (value, isOrNull, isRequired) 
                        })
        ---
        if  (isEmpty(keysOf(obj))) 
            OBJECT_KEYWORD
        else 
            {
                (TYPE_KEYWORD): OBJECT_KEYWORD,
                (PROPS_KEYWORD): props  
            }
    }

fun convert2raml(val: Any, isOrNull: Boolean = false, isRequired: Boolean = true): String = if ( isOrNull ) ramlTypeOf( val ) ++ QUEST_MARK 
                                                                                            else ramlTypeOf( val )
