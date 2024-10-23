#!/bin/bash

jq '{
  "description": .description,
  "type": "object",
  "properties": {
    "name": (.definitions.tool.properties.name | del(.minLength, .maxLength, .pattern, .format)),
    "description": "Description of a bioinformatics tool.",
    "homepage": (.definitions.tool.properties.homepage | del(.minLength, .maxLength, .pattern, .format)),
    "version": (.definitions.tool.properties.version | del(.minLength, .maxLength, .pattern, .format)),
    "otherID": (.definitions.tool.properties.otherID | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "toolType": (.definitions.tool.properties.toolType | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "operatingSystem": (.definitions.tool.properties.operatingSystem | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "language": (.definitions.tool.properties.language | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "license": (.definitions.tool.properties.license | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "collectionID": (.definitions.tool.properties.collectionID | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "maturity": (.definitions.tool.properties.maturity | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "cost": (.definitions.tool.properties.cost | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "accessibility": (.definitions.tool.properties.accessibility | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "elixirPlatform": (.definitions.tool.properties.elixirPlatform | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "elixirNode": (.definitions.tool.properties.elixirNode | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)), 
    "elixirCommunity": (.definitions.tool.properties.elixirCommunity | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "link": (.definitions.tool.properties.link | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "download": (.definitions.tool.properties.download | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "documentation": (.definitions.tool.properties.documentation | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "publication": (.definitions.tool.properties.publication | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format)),
    "credit": (.definitions.tool.properties.credit | .type = ["string", "null"] | del(.minLength, .maxLength, .pattern, .format))
  },
  "required": ["name", "description", "homepage", "version", "otherID", "toolType", 
               "operatingSystem", "language", "license", "collectionID", "maturity", 
               "cost", "accessibility", "elixirPlatform", "elixirNode", "elixirCommunity",
               "link", "download", "documentation", "publication", "credit"],
  "definitions": {
    "urlftpType": (.definitions.urlftpType | del(.minLength, .maxLength, .pattern, .format)),
    "versionType": (.definitions.versionType | del(.minLength, .maxLength, .pattern, .format)),
    "textType": (.definitions.textType | del(.minLength, .maxLength, .pattern, .format))
  },
  "additionalProperties": false
}' biotoolsj.json > base.json


jq --argjson enums "$(cat enums.json)" '{
  "description": "EDAM mapping schema for topics and function.",
  "type": "object",
  "properties": {
    "topic": (.definitions.tool.properties.topic 
              | del(.items.properties.uri) 
              | .items.properties.term.enum = $enums.topics
              | .items.required = ["topic"]),
    "function": (.definitions.tool.properties.function | del(.items.properties.operation.items.properties.uri) 
    | .items.properties.operation.items.properties.term.enum = $enums.operations 
    | .items.properties.note = null
    | .items.properties.cmd = null
    | .items.required = ["operation", "input", "output"]),
  },
  "required": ["topic", "function"],
  "additionalProperties": false,
  "definitions": {
    "EDAMdata": { "title" : "EDAM data concept", 
                  "type": "object", 
                  "properties": {"type": "string",  
                                 "enum": $enums.data
                                }
                },
    "EDAMformat":  { "title" : "EDAM format concept", 
                     "type": "object", 
                     "properties": { 
                      "term": { "type": "string",  
                                "enum": $enums.formats
                               }
                      },
                      "required": ["term"],
                   },
  }
}' biotoolsj.json > edammap.json
