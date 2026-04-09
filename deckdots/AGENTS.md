# DeckDots Agent Notes

- Project scope: build a small PowerPoint post-processing tool that adds a bottom-row progress indicator to each slide.
- Runtime environment: use the `deckdots` mamba environment.
- Activation command: `eval "$(mamba shell hook --shell zsh)" && mamba activate deckdots`
- Expected Python dependency: `python-pptx` is installed in that environment.
- Primary sample input: `/Users/asun/dev/utilities/deckdots/260406_okr.pptx`
- Config directory: `/Users/asun/dev/utilities/deckdots/configs`
- Sample config for the OKR deck: `/Users/asun/dev/utilities/deckdots/configs/260406_okr.yaml`
- Default script entrypoint: `/Users/asun/dev/utilities/deckdots/add_progress_dots.py`
- Current tracker behavior: load a config-driven topic/footer layout, group dots by topic from left to right, color the active topic black, color inactive topics grey, and keep a dot active across however many slides its `slides_per_dot` span covers.
- Validation approach: run the script in the `deckdots` environment and execute `python -m unittest deckdots.test_add_progress_dots`.
- Implementation preference: use `python-pptx` rather than manual OOXML editing unless there is a specific reason not to.
- Config format: prefer YAML with `topics`, `name`, and `slides_per_dot`; if `PyYAML` is missing, the built-in fallback parser supports this subset plus inline list syntax such as `[1, 2, 1]`.
- Rerun safety: keep tracker insertion idempotent by removing previously-added `DeckDots Tracker` shapes before redrawing them.
