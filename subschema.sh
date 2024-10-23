#!/bin/bash

jq '
def clean_constraints:
  walk(
    if type == "object" then
      del(.minLength, .maxLength, .pattern, .format,
          .minimum, .maximum, .multipleOf,
          .patternProperties, .unevaluatedProperties, .propertyNames, .minProperties, .maxProperties,
          .unevaluatedItems, .contains, .minContains, .maxContains, .minItems, .maxItems, .uniqueItems, .anyOf)
    else .
    end
  );

{
  "description": .description,
  "type": "object",
  "properties": {
    "name": (.definitions.tool.properties.name | clean_constraints),
    "description": "Description of a bioinformatics tool.",
    "homepage": (.definitions.tool.properties.homepage | clean_constraints),
    "version": (.definitions.tool.properties.version | clean_constraints),
    "otherID": (.definitions.tool.properties.otherID | .type = ["string", "null"] | clean_constraints),
    "toolType": (.definitions.tool.properties.toolType | .type = ["string", "null"] | clean_constraints),
    "operatingSystem": (.definitions.tool.properties.operatingSystem | .type = ["string", "null"] | clean_constraints),
    "language": (.definitions.tool.properties.language | .type = ["string", "null"] | clean_constraints),
    "license": (.definitions.tool.properties.license | .type = ["string", "null"] | clean_constraints),
    "collectionID": (.definitions.tool.properties.collectionID | .type = ["string", "null"] | clean_constraints),
    "maturity": (.definitions.tool.properties.maturity | .type = ["string", "null"] | clean_constraints),
    "cost": (.definitions.tool.properties.cost | .type = ["string", "null"] | clean_constraints),
    "accessibility": (.definitions.tool.properties.accessibility | .type = ["string", "null"] | clean_constraints),
    "elixirPlatform": (.definitions.tool.properties.elixirPlatform | .type = ["string", "null"] | clean_constraints),
    "elixirNode": (.definitions.tool.properties.elixirNode | .type = ["string", "null"] | clean_constraints),
    "elixirCommunity": (.definitions.tool.properties.elixirCommunity | .type = ["string", "null"] | clean_constraints),
    "link": (.definitions.tool.properties.link | .type = ["string", "null"] | clean_constraints),
    "download": (.definitions.tool.properties.download | .type = ["string", "null"] | clean_constraints),
    "documentation": (.definitions.tool.properties.documentation | .type = ["string", "null"] | clean_constraints),
    "publication": (.definitions.tool.properties.publication | .type = ["string", "null"] | clean_constraints),
    "credit": (.definitions.tool.properties.credit | .type = ["string", "null"] | clean_constraints)
  },
  "required": ["name", "description", "homepage", "version", "otherID", "toolType", 
               "operatingSystem", "language", "license", "collectionID", "maturity", 
               "cost", "accessibility", "elixirPlatform", "elixirNode", "elixirCommunity",
               "link", "download", "documentation", "publication", "credit"],
  "definitions": {
    "urlftpType": (.definitions.urlftpType | clean_constraints),
    "versionType": (.definitions.versionType | clean_constraints),
    "textType": (.definitions.textType | clean_constraints)
  },
  "additionalProperties": false
}' biotoolsj.json > base.json


jq --argjson enums "$(cat enums.json)" '

def clean_constraints:
  walk(
    if type == "object" then
      del(.minLength, .maxLength, .pattern,
          .minimum, .maximum, .multipleOf,
          .patternProperties, .unevaluatedProperties, .propertyNames, .minProperties, .maxProperties,
          .unevaluatedItems, .contains, .minContains, .maxContains, .minItems, .maxItems, .uniqueItems, 
          .anyOf, ."$comment", .examples)
    else .
    end
  );

{
  
  "name": "EDAM mapping",
  "description": "Description of topics and function for a bioinformatics using the EDAM vocabulary.",
  "type": "object",
  "properties": {
    "topic": (.definitions.tool.properties.topic 
              | del(.items.properties.uri) 
              | .items.properties.term.enum = $enums.topics
              | .items.required = ["term"]
              | .items.additionalProperties = false
              | clean_constraints),
    "function": (.definitions.tool.properties.function 
    | del(.items.properties.operation.items.properties.uri) 
    | .items.properties.operation.items.properties.term.enum = $enums.operations 
    | del(.items.properties.note)
    | del(.items.properties.cmd)
    | .items.properties.operation.required = ["term"]
    | .items.properties.input.items.additionalProperties = false
    | .items.properties.input.items.required = ["data", "format"]
    | .items.properties.output.items.required = ["data", "format"]
    | .items.properties.output.items.additionalProperties = false
    | .items.additionalProperties = false
    | .items.required = ["operation", "input", "output"]
    | clean_constraints),
  },
  "required": ["topic", "function"],
  "additionalProperties": false,
  "definitions": {
    "EDAMdata": { "title" : "EDAM data concept", 
                  "type": "object", 
                  "properties": {
                     "term": { "type": "string",  
                                "enum": $enums.data
                              }
                  },
                  "required": ["term"],
                  "additionalProperties": false,
                },
    "EDAMformat":  { "title" : "EDAM format concept", 
                     "type": "object", 
                     "properties": { 
                      "term": { "type": "string",  
                                "enum": $enums.formats
                               }
                      },
                    "required": ["term"],
                    "additionalProperties": false,
                   },
  }
}' biotoolsj.json > edammap.json
