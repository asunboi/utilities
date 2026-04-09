from __future__ import annotations

import argparse
from pathlib import Path

from pptx import Presentation
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_AUTO_SHAPE_TYPE
from pptx.util import Pt

EMU_PER_INCH = 914400
PROGRESS_SHAPE_PREFIX = "DeckDots Progress Dot"
BLACK = RGBColor(0x00, 0x00, 0x00)
WHITE = RGBColor(0xFF, 0xFF, 0xFF)


def progress_geometry(slide_width: int, slide_height: int, slide_count: int) -> tuple[int, int, int, int]:
    base_diameter = int(0.14 * EMU_PER_INCH)
    min_diameter = int(0.06 * EMU_PER_INCH)
    gap_factor = 0.75
    max_row_width = int(slide_width * 0.78)
    denominator = slide_count + gap_factor * max(slide_count - 1, 0)
    diameter = min(base_diameter, int(max_row_width / denominator))
    diameter = max(diameter, min_diameter)
    gap = int(diameter * gap_factor)
    total_width = slide_count * diameter + max(slide_count - 1, 0) * gap
    start_x = max((slide_width - total_width) // 2, 0)
    y = slide_height - int(0.18 * EMU_PER_INCH) - diameter
    return start_x, y, diameter, gap


def is_progress_shape(shape) -> bool:
    return getattr(shape, "name", "").startswith(PROGRESS_SHAPE_PREFIX)


def remove_existing_progress_shapes(slide) -> None:
    for shape in list(slide.shapes):
        if not is_progress_shape(shape):
            continue
        element = shape._element
        element.getparent().remove(element)


def add_progress_dots_to_slide(
    slide,
    slide_index: int,
    slide_count: int,
    slide_width: int,
    slide_height: int,
) -> None:
    remove_existing_progress_shapes(slide)
    start_x, y, diameter, gap = progress_geometry(slide_width, slide_height, slide_count)

    for dot_index in range(slide_count):
        x = start_x + dot_index * (diameter + gap)
        dot = slide.shapes.add_shape(MSO_AUTO_SHAPE_TYPE.OVAL, x, y, diameter, diameter)
        dot.name = f"{PROGRESS_SHAPE_PREFIX} {dot_index + 1}"
        dot.fill.solid()
        dot.fill.fore_color.rgb = BLACK if dot_index == slide_index else WHITE
        dot.line.color.rgb = BLACK
        dot.line.width = Pt(1)


def add_progress_dots_to_presentation(input_path: Path, output_path: Path) -> int:
    presentation = Presentation(str(input_path))
    slide_count = len(presentation.slides)

    for slide_index, slide in enumerate(presentation.slides):
        add_progress_dots_to_slide(
            slide=slide,
            slide_index=slide_index,
            slide_count=slide_count,
            slide_width=presentation.slide_width,
            slide_height=presentation.slide_height,
        )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    presentation.save(str(output_path))
    return slide_count


def default_output_path(input_path: Path) -> Path:
    return input_path.with_name(f"{input_path.stem}.progress-dots{input_path.suffix}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Add a simple bottom-row progress dot bar to every slide in a PowerPoint deck."
    )
    parser.add_argument("input_pptx", type=Path, help="Path to the input .pptx file.")
    parser.add_argument(
        "output_pptx",
        nargs="?",
        type=Path,
        help="Optional output path. Defaults to '<input>.progress-dots.pptx'.",
    )
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    input_path = args.input_pptx.resolve()
    output_path = (args.output_pptx or default_output_path(input_path)).resolve()

    slide_count = add_progress_dots_to_presentation(input_path, output_path)
    print(f"Wrote {output_path} with progress dots on {slide_count} slides.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
