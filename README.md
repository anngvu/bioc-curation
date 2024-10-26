
## Curation of Bioconductor packages into BioTools schema

### About

Example curation of [Bioconductor](https://bioconductor.org/) software packages into the [bio.tools schema](https://github.com/bio-tools/biotoolsSchema) using OpenAI, focusing mainly on the EDAM mapping part of the curation specification. In the screenshot, one can see that basic tool info is pretty much already available for Bioconductor packages, but EDAM functionality is less well-characterized. Yet it is knowing input/output data and formats that could be really useful for certain applications. 

![image](https://github.com/user-attachments/assets/699b9d6f-06c7-45b0-abd9-2a1f14985d1d)


This also represents R&D work to define an optimal curation workflow to be encapsulated in tools to help (Sage) curators curate data for projects that involve EDAM, such as https://cancercomplexity.synapse.org/Explore/Tools and https://openchallenges.io/challenge. Aside from Sage curators, this might also be useful to the wider curation community.

These experimental results should be interesting to compare with existing curation, additional human-curated results, [EDAMmap](https://github.com/edamontology/edammap), or other approaches. 

### Methodology

> [!TIP]
> **Easiest is to go through and run the [example notebook](https://github.com/anngvu/bioc-curation/blob/update-notebook/Bioconductor_package_curation_with_OpenAI.ipynb) in Google Colab or locally.** You can modify the notebook to plug in other packages of interest. 
You will only need an OpenAI API key. 
*See section on [OpenAI usage costs](https://github.com/anngvu/bioc-curation/?tab=readme-ov-file#openai-usage-costs).

But to reproduce and understand the other prep as well, make sure these tools are available per instructions in the respective docs:
- [robot v1.9.6](http://robot.obolibrary.org/)
- [OpenAI API key](https://platform.openai.com/docs/quickstart)
- [jq v1.7](https://jqlang.github.io/jq/) 

#### Prep schemas
- `prep-edam.sh`: Script to download the latest stable EDAM, select terms useable for annotation, and then put into a JSON format `enums.json` for use with OpenAI.
- `subschema.sh`: Wrangling bio.tools schema with `jq` into two modified subschemas for many reasons: 
  1) Allows special focus on the EDAM mapping if everything else is already well-curated.
  2) The EDAM subschema is specifically structured for AI to more easily work with, with concept terms inserted as regular enums (there is post-processing to pull in uris).
  3) We often want to use different document sources for curating EDAM than when curating everything else.
  4) Doing two separate passes reduces the chance of going over context length limits.
  5) Initially, the idea was to use OpenAI's [strict structured outputs](https://platform.openai.com/docs/guides/structured-outputs/supported-schemas) if possible, though we ended up using customized prompting workflow for everything because strict structured 
  - Base schema (`base.json`):
    - A single tool object instead of current array because extraction will be per-tool.
    - Remove [unsupported type-specific keywords](https://platform.openai.com/docs/guides/structured-outputs/some-type-specific-keywords-are-not-yet-supported). 
    - Remove `biotoolsID` and `biotoolsCURIE`, which are normally admin-assigned and not curated. 
    - Remove `relation` component since it's out of scope to link similar existing bio.tools tools here.  
    - Remove `topics` and `function` since they're factored out into the EDAM mapping schema below.
    - For base schema, the AI is given the Bioconductor package home page as the best source given the already concise, well-structured info there. 
  - EDAM mapping schema (`edammap.json`):
    - Contains `topics` and `function` components but with EDAM concepts inserted as enums.
    - One reason the EDAM mapping schema is factored out is because it can be pretty big with concepts inserted to enable AI to reference the ontology. But also, this part of the schema is matched to a more "optimal" text source to fill in `function`. Our human curator's intuition is to give it some GitHub source or package vignette where there is more technical code demonstration of what the package does.

#### Prompt AI
See notebook for AI processing with custom prompts.

#### AI post-processing
See notebook for post AI-processing that involved pulling in term ids given labels, data merging, and final validation with original bio.tools schema. 

### Notes
#### OpenAI usage costs

The minimum cost is about 10 cents to curate a package using typical document sources. See the notebook for the example cost calculation. For further exploration with *a lot* more examples, one can focus only on the EDAM mapping schema or translate calls to the batch API for 50% reduction in cost.

#### Other

What document sources to provide is still human-decided. It would be an even better pipeline if we just start out with a package homepage for the basic curation, and then the AI knows how to choose a link for what would represent a good source for EDAM curation. 
