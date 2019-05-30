# My Resume

The following repository contains the sources used to compile my CV, resume, and cover letters. My resume is essentially a heavily modified varient of [Awesome-CV](https://github.com/posquit0/Awesome-CV), where the majority of the complexity is moved from LaTeX to Jinja2 templating via [tmpl](https://github.com/HarrisonTotty/tmpl). In this way, all of the data associated with my abilities is contained within YAML files, and then translated accordingly into Jinja2 and then LaTeX.

## Build Process

A build is executed by running `build.sh` with a single command line argument, being one of `all`, `clean`, `clean-all`, `coverletter`, `cv`, `resume`, or `templates`. If `all`, `coverletter`, `cv`, or `resume` are selected, then the script begins by first translating the templates into their final `.tex` forms in the `build/` directory via:

```bash
tmpl src/tmpl.yaml --delete -o build
```

As indicated above, the primary template configuration file is `src/tmpl.yaml`, which will in-turn import additional YAML files under `src/yaml/` (where most of the raw data is located).

Once the templates have been translated into the `build/` directory, the script compiles the resulting LaTeX into `.pdf` files, which are moved into the `release/` directory.
