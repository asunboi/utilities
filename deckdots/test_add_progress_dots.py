from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from pptx import Presentation

from deckdots.add_progress_dots import (
    PROGRESS_SHAPE_PREFIX,
    add_progress_dots_to_presentation,
)

SAMPLE_DECK = Path(__file__).with_name("260406_okr.pptx")


class AddProgressDotsTest(unittest.TestCase):
    def test_adds_one_dot_per_slide_and_highlights_current_slide(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir) / "output.pptx"
            slide_count = add_progress_dots_to_presentation(SAMPLE_DECK, output_path)
            presentation = Presentation(str(output_path))

            self.assertEqual(slide_count, 14)

            first_slide_dots = self.progress_shapes(presentation.slides[0])
            middle_slide_dots = self.progress_shapes(presentation.slides[6])
            last_slide_dots = self.progress_shapes(presentation.slides[-1])

            self.assertEqual(len(first_slide_dots), 14)
            self.assertEqual(self.fill_colors(first_slide_dots).count("000000"), 1)
            self.assertEqual(self.fill_colors(first_slide_dots)[0], "000000")
            self.assertEqual(self.fill_colors(first_slide_dots)[1], "FFFFFF")

            self.assertEqual(self.fill_colors(middle_slide_dots).count("000000"), 1)
            self.assertEqual(self.fill_colors(middle_slide_dots)[6], "000000")

            self.assertEqual(self.fill_colors(last_slide_dots).count("000000"), 1)
            self.assertEqual(self.fill_colors(last_slide_dots)[-1], "000000")

    def test_rerunning_does_not_duplicate_progress_dots(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            first_output = Path(tmpdir) / "first-output.pptx"
            second_output = Path(tmpdir) / "second-output.pptx"

            add_progress_dots_to_presentation(SAMPLE_DECK, first_output)
            add_progress_dots_to_presentation(first_output, second_output)

            presentation = Presentation(str(second_output))
            self.assertEqual(len(self.progress_shapes(presentation.slides[0])), 14)
            self.assertEqual(len(self.progress_shapes(presentation.slides[-1])), 14)

    def progress_shapes(self, slide) -> list:
        dots = [shape for shape in slide.shapes if getattr(shape, "name", "").startswith(PROGRESS_SHAPE_PREFIX)]
        dots.sort(key=lambda shape: shape.left)
        return dots

    def fill_colors(self, shapes: list) -> list[str]:
        return [str(shape.fill.fore_color.rgb) for shape in shapes]


if __name__ == "__main__":
    unittest.main()
