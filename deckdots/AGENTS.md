# DeckDots Agent Notes

- Project scope: build a small PowerPoint post-processing tool that adds a bottom-row progress indicator to each slide.
- Runtime environment: use the `deckdots` mamba environment.
- Activation command: `eval "$(mamba shell hook --shell zsh)" && mamba activate deckdots`
- Expected Python dependency: `python-pptx` is installed in that environment.
- Primary sample input: `/Users/asun/dev/utilities/deckdots/260406_okr.pptx`
- Default script entrypoint: `/Users/asun/dev/utilities/deckdots/add_progress_dots.py`
- Current MVP behavior: open a `.pptx`, count slides, add one outlined circle per slide at the bottom, fill the current slide's circle black, and save a new `.pptx`.
- Validation approach: run the script in the `deckdots` environment and execute `python -m unittest deckdots.test_add_progress_dots`.
- Implementation preference: use `python-pptx` rather than manual OOXML editing unless there is a specific reason not to.
- Rerun safety: keep progress-dot insertion idempotent by removing previously-added `DeckDots Progress Dot` shapes before redrawing them.
