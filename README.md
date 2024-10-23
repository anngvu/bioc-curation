
## Curation of Bioconductor packages into BioTools schema

### About

Example curation of [Bioconductor](https://bioconductor.org/) software packages into the [bio.tools schema](https://github.com/bio-tools/biotoolsSchema) using OpenAI, especially focusing on the EDAM mapping part of the schema specification. Some of this will help us work out functionality to be optimized and built into [a tool](https://github.com/anngvu/accent) purposely built to help (Sage) curators curate data for projects that involve EDAM, such as https://cancercomplexity.synapse.org/Explore/Tools and https://openchallenges.io/challenge. However, this should also be useful outside of Sage and benefit the wider curation community.

This is experimental, and it might be interesting to compare with human-curated results, [EDAMmap](https://github.com/edamontology/edammap), or other approaches. 

### Methodology

To reproduce, make sure these tools are available; set up following their respective docs:
- [robot v1.9.6](http://robot.obolibrary.org/)
- [accent v0.45](https://github.com/anngvu/accent)
- [OpenAI API key](https://platform.openai.com/docs/quickstart) *See [OpenAI usage costs](https://github.com/anngvu/accent/tree/web-ui?tab=readme-ov-file#openai-usage-costs](https://github.com/anngvu/bioc-curation/?tab=readme-ov-file#openai-usage-costs).
- [jq v1.7](https://jqlang.github.io/jq/) 

1. `prep-edam.sh`: Script to download the latest stable EDAM, select terms useable for annotation, and then put into a JSON format `enums.json` for use with OpenAI.
2. `subschema.sh`: Wrangling bio.tools schema with `jq` to create the version compatible with OpenAI (see https://platform.openai.com/docs/guides/structured-outputs/supported-schemas). The schema is split into two schemas for different curation approaches:
  - Base schema (`base.json`):
    - A single tool object instead of current array because extraction will be per-tool.
    - Remove [unsupported type-specific keywords](https://platform.openai.com/docs/guides/structured-outputs/some-type-specific-keywords-are-not-yet-supported). 
    - Remove `biotoolsID` and `biotoolsCURIE`, which are normally admin-assigned and not curated. 
    - Remove `relation` component since it's out of scope to link similar existing bio.tools tools here.  
    - Remove `topics` and `function` since they go into their own subschema below.
    - For Main schema, the AI is given the Bioconductor package home page as the best source given the already concise, well-structured info there. 
  - EDAM mapping schema (`edammap.json`):
    - Contains `topics` and `function` components but with EDAM concepts inserted as enums.
    - One reason the EDAM mapping schema is factored out is because it can be pretty big with concepts inserted to enable AI to reference the ontology. But also, this part of the schema is matched to a more "optimal" text source to fill in `function`. Our human curator's intuition is to give it a package vignette instead for best results, since the vignette is supposed to demonstrate what the package does, while a terse package description will rarely mention file formats or example commands.

3. AI processing with custom prompt: 
  ```
  "You are a competent curation assistant with several tools and your disposal to implement the curation workflow for Bioconductor software packages. 
  You will help the user, who will give you a link to a Bioconductor package homepage such as https://bioconductor.org/packages/release/bioc/html/chromVAR.html.
  First, you will instruct the extraction agent to generate structured output adhering to the JSON schema at https://raw.githubusercontent.com/anngvu/bioc-curation/refs/heads/main/base.json.
  Once that JSON data is returned, you will review it to choose one vignette link. 
  Instruct the agent to use your vignette link to generate JSON for another schema at https://raw.githubusercontent.com/anngvu/bioc-curation/refs/heads/main/edammap.json.
  ```

4. Post-processing: Fill in term ids given labels. 

5. Post-processing: Merge the data and re-validate with original bio.tools schema.


### OpenAI usage costs

The cost is neglible for a couple of examples. The main feature used is [Structured Output](https://openai.com/index/introducing-structured-outputs-in-the-api/). This can be translated to the batch API for 50% reduction.




