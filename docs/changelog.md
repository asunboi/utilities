
# Apr 3 

## 
The current template looks like this. 

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
     
| Directory/File | Description |
|----------------|-------------|
| .github | Contains GitHub relevant items, such as issue templates and workflows that should automatically be run. |
| debug | For short-lived analysis / temporary notebooks that usually get assigned into its proper place after the analysis is finished. Sort of like a capture directory. |
| documents | Not really used; I don't keep many documents related to projects within the project folder itself. |
| figures | Also not really used as it is currently, as many of the figures live with their associated code and intermediate data in results. |
| notebooks | Contains all the template notebooks for analysis. While notebooks can be created within results / project analysis, a clean version (no hardcoded paths, no code execution) should be saved in notebooks for future use across different datasets / configurations. |
| raw_data | Removed in place of a more simple data directory. Raw / processed data is also now stored in a whole directory with its own structure, as input datasets are often reused across programs. |
| src | Contains source code for editable packages, different from lib in the sense that these packages are meant to be complete installations with minor changes. Usually subrepos. |
| web | Deprecated; I forgot what the purpose of this was. |
| .gitignore | For ignoring file formats, contains common ignores that I use in my projects. |
| README.md | For project documentation, such as this file. Should be updated with any major changes to the project structure or organization. |

Project organization was both driven by a need for me to be organized after I couldn't figure out what I was doing in any of my previous archived projects, but also by these great reads:

https://jkh1.github.io/project_organisation.html  
https://jkh1.github.io/data_management_guide.html
