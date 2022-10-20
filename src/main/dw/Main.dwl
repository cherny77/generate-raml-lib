%dw 2.0
output application/yaml
import convert2raml from GenRamlModule

var inpt = readUrl("classpath://input.json", "application/json")
---
convert2raml(inpt, true, false)