
## Curation of Bioconductor packages into BioTools schema

### About

Example curation of [Bioconductor](https://bioconductor.org/) software packages into the [bio.tools schema](https://github.com/bio-tools/biotoolsSchema) using OpenAI, focusing mainly on the EDAM mapping part of the schema specification. Referring to the example screenshot below, "basic" tool description is widely available for Bioconductor packages but EDAM functionality is less well-characterizeed, which is why it is the focus here.  



Some of this will help us work out functionality to be optimized and built into [a tool](https://github.com/anngvu/accent) purposely built to help (Sage) curators curate data for projects that involve EDAM, such as https://cancercomplexity.synapse.org/Explore/Tools and https://openchallenges.io/challenge. However, this should also be useful outside of Sage and benefit the wider curation community.

This is experimental, and it might be interesting to compare with existing results, additional human-curated results, [EDAMmap](https://github.com/edamontology/edammap), or other approaches. 

### Methodology

Rerun the example notebook in Google Colab or locally; plug in other packages of interest. 
You will only need an OpenAI API key. 
*See [OpenAI usage costs](https://github.com/anngvu/accent/tree/web-ui?tab=readme-ov-file#openai-usage-costs](https://github.com/anngvu/bioc-curation/?tab=readme-ov-file#openai-usage-costs).

To reproduce the entire prep as well, make sure these tools are available; set up following their respective docs:
- [robot v1.9.6](http://robot.obolibrary.org/)
- [OpenAI API key](https://platform.openai.com/docs/quickstart)
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

3. See notebook: AI processing with custom prompts.

4. See notebook: Post AI-processing with fill in term ids given labels, data merging, and final validation. 


### OpenAI usage costs

The minimum cost is about 10 cents to curate a package two different document sources. See the notebook for the cost calculator with costs for the example. The functionality can be translated to the batch API for 50% reduction in cost.




