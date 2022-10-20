%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from GenRamlModule

var commonInput = readUrl("classpath://input/test-input.json", "application/json")
var emptyArrayInput = readUrl("classpath://input/test-input-empty-array.json", "application/json")
var emptyObjectInput = readUrl("classpath://input/test-input-empty-object.json", "application/json")
---

"GenRamlModule" describedBy [
    "convert2raml" describedBy [
        "Test with required fields and strict types" in do {
            convert2raml(commonInput, false, true) must equalToResource("output/test-output-with-required-fileds-and-strict-types.json", "application/json")
        },

        "Test with no required fields and no strict types" in do {
            convert2raml(commonInput, true, false) must equalToResource("output/test-output-with-no-required-fileds-and-no-strict-types.json", "application/json")
        },

        "Test empty array type" in do {
            convert2raml(emptyArrayInput) must equalToResource("output/test-output-empty-array.json", "application/json")
        },

        "Test empty object type" in do {
            convert2raml(emptyObjectInput) must equalToResource("output/test-output-empty-object.json", "application/json")
        },
    ],
    "ramlTypeOf" describedBy [
        "Test boolean type" in do {
            ramlTypeOf(true) must equalTo("boolean")
        },

        "Test string type" in do {
            ramlTypeOf("string") must equalTo("string")
        },

        "Test number type" in do {
            ramlTypeOf(5) must equalTo("number")
        },

        "Test datetime type" in do {
            ramlTypeOf("2022-10-20T08:16:43.238309Z") must equalTo("datetime")
        }
    ],
]


