# Generate Raml Lib

This tiny **DataWeave** lib has the only purpose to generate RAML datatypes by any data samples, written on different DSLs like `JSON`, `XML`, `CSV`, `YML`.


## How to Use It

Unfortunately, for now, the author didn`t find a way to create an executable file in order to run it from CLI, therefore we will use Visual Code for this purpose. 

1. Install Visual Studio Code and its DataWeave extension.
You can find out how to do it here: https://developer.mulesoft.com/tutorials-and-howtos/dataweave/dataweave-extension-vscode-getting-started/
2. Import generate-raml-lib folder into  Visual Studio Code.
3. Run ```mvn clean install```
4. Open ``src/main/dw/Main.dwl`` file. There you can see the variable `inpt` that store file data by its path. This file has the structure you want to convert to RAML datatype. So there could be link to any file, but do not forget to change second parameter of the function `readUrl` according to the format you use to proceed with reading the file properly.
6. Function `convert2raml(inpt, isOrNull, isRequired)` has 3 parameters: 
    - `inpt` depics data structure we want to convert to RAML datatype
    - `isOrNull` is responsible for making type of fields strict or united with `nil` (by default `False`)
    - `isRequired` is responsible for making fields required or not (by default `True`)
7. Click on the run button.

## Example

content of file `input.json`

```
{
    "mess1": "mes",
    "mess2": {
        "sub_mess": 2,
        "sub_mess_arr": [
            {
            "arr_elem": true
            }],
        "sub_mess_arr_prim": [ "dsds", "SDSF"]
    }
}
```
---
content of file Main.hs 

```
%dw 2.0
output application/yaml
import convert2raml from GenRamlModule

var inpt = readUrl("classpath://input.json", "application/json")
---
convert2raml(inpt, true, false)
```
---
 
 output

 ```
 %YAML 1.2
---
type: object
properties:
  mess1?: string?
  mess2?:
    type: object
    properties:
      sub_mess?: number?
      sub_mess_arr?:
        type: array
        items:
          type: object
          properties:
            arr_elem?: boolean?
      sub_mess_arr_prim?:
        type: array
        items: string?
```
---
