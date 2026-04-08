
## 2026-04-03 - 

**Commits:** `f46b49e`, `c6c8866`, `70ca661`

Beyond output naming conventions for each project, I need to establish guidelines for the purpose of these template directories and what type of files I am storing in them so that I save time thinking about it when new file formats come up. 

Original template from the last change:
| Directory/File | Description |
|----------------|-------------|
| .github | Contains GitHub relevant items, ssuch as issue templates and workflows that should automatically be run. |
| debug | For short-lived analysis / temporary notebooks that usually get assigned into its proper place after the analysis is finished. Sort of like a capture directory. |
| documents | Not really used; I don't keep many documents related to projects within the project folder itself. |
| figures | Also not really used as it is currently, as many of the figures live with their associated code and intermediate data in results. |
| notebooks | Contains all the template notebooks for analysis. While notebooks can be created within results / project analysis, a clean version (no hardcoded paths, no code execution) should be saved in notebooks for future use across different datasets / configurations. |
| raw_data | Removed in place of a more simple data directory. Raw / processed data is also now stored in a whole directory with its own structure, as input datasets are often reused across programs. |
| src | Contains source code for editable packages, different from lib in the sense that these packages are meant to be complete installations with minor changes. Usually subrepos. |
| web | Deprecated; I forgot what the purpose of this was. |
| .gitignore | For ignoring file formats, contains common ignores that I use in my projects. |
| README.md | For project documentation, such as this file. Should be updated with any major changes to the project structure or organization. |

I no longer use raw_data, and web should be removed. 
Documents can be shortened to docs; see project_docs.md for more detail, but storing changelogs, notes, references, etc. 
src was also a bit cluttered between packages that I often edited vs smalls scripts that I ran once or twice; changed the purpose of src to only contain full editable packages / subrepos, while lib can be used for all the extra clutter.

Added agentic framework to the template directory. Still have to actually fill out AGENTS.md and the rest of the instruction files, but at least this starts a path for agentic use in all my projects. 



## 2025-10-24 - Creating Template Directory

**Commits:** `0c337f3`, `f84e703`
**Refs:** [REF-001, REF-002]

Project organization was both driven by a need for me to be organized after I couldn't figure out what I was doing in any of my previous archived projects, but also by these great reads by a forum in biostars and Jean-Karim Heriche at EMBL.

The current template looks like this, mainly inspired by the biostars entry.

```
.
├── .github
│   ├── ISSUE_TEMPLATE
│   │   └── jira-template.md
│   └── workflows
│       ├── backfill-dates.yml
│       ├── backfill-project-dates.yml
│       ├── duration_status.yml
│       ├── main.yml
│       ├── track-issue-dates.yml
│       └── update_end.yml
├── debug
├── documents
├── figures
├── notebooks
├── raw_data
├── src
├── web
├── .gitignore
├── README.md
└── TODO.md
```
    