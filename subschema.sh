#!/bin/bash

jq '{
  "description": .description,
  "type": "object",
  "properties": {
    "name": .definitions.tool.properties.name,
    "description": "Description of a bioinformatics tool.",
    "homepage": .definitions.tool.properties.homepage,
    "version": .definitions.tool.properties.version,
    "otherID": (.definitions.tool.properties.otherID | .type = ["string", "null"]),
    "toolType": (.definitions.tool.properties.toolType | .type = ["string", "null"]),
    "operatingSystem": (.definitions.tool.properties.operatingSystem | .type = ["string", "null"]),
    "language": (.definitions.tool.properties.language | .type = ["string", "null"]),
    "license": (.definitions.tool.properties.license | .type = ["string", "null"]),
    "collectionID": (.definitions.tool.properties.collectionID | .type = ["string", "null"]),
    "maturity": (.definitions.tool.properties.maturity | .type = ["string", "null"]),
    "cost": (.definitions.tool.properties.cost | .type = ["string", "null"]),
    "accessibility": (.definitions.tool.properties.accessibility | .type = ["string", "null"]),
    "elixirPlatform": (.definitions.tool.properties.elixirPlatform | .type = ["string", "null"]),
    "elixirNode": (.definitions.tool.properties.elixirNode | .type = ["string", "null"]),
    "elixirCommunity": (.definitions.tool.properties.elixirCommunity | .type = ["string", "null"]),
    "link": (.definitions.tool.properties.link | .type = ["string", "null"]),
    "download": (.definitions.tool.properties.download | .type = ["string", "null"]),
    "documentation": (.definitions.tool.properties.documentation | .type = ["string", "null"]),
    "publication": (.definitions.tool.properties.publication | .type = ["string", "null"]),
    "credit": (.definitions.tool.properties.credit | .type = ["string", "null"])
  },
  "required": ["name", "description", "homepage", "version", "otherID", "toolType", 
               "operatingSystem", "language", "license", "collectionID", "maturity", 
               "cost", "accessibility", "elixirPlatform", "elixirNode", "elixirCommunity",
               "link", "download", "documentation", "publication", "credit"],
  "definitions": {
    "urlftpType": .definitions.urlftpType,
    "versionType": .definitions.versionType,
    "textType": .definitions.textType
  },
  "additionalProperties": false
}' biotoolsj.json > edam_mapping.json 


jq --argjson enums "$(cat enums.json)" '{
  "description": "EDAM mapping schema for topics and function.",
  "type": "object",
  "properties": {
    "topic": (.definitions.tool.properties.topic 
              | .items.properties.uri = null 
              | .items.properties.term.enum = $enums.topics
              | .items.required = ["topic"]),
    "function": (.definitions.tool.properties.function | .items.properties.operation.items.properties.uri = null 
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
