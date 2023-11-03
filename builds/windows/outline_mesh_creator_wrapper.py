import pathlib
import subprocess
from argparse import ArgumentParser

import trio


OUTLINE_THICKNESS = 0.25


async def main(args):
    parts = [str(OUTLINE_THICKNESS)]
    parts.extend(p.as_posix() for p in args.glb_paths)
    
    param = "--headless ++ " + " ".join(parts)

    async with trio.open_nursery() as nursery:
        process = await nursery.start(
            trio.run_process,
            "Outline Mesh Creator.exe " + param,
            # stdout=subprocess.PIPE
        )
        

if __name__ == "__main__":
    _parser = ArgumentParser()
    _parser.add_argument(
        "glb_paths",
        metavar="I",
        type=pathlib.Path,
        nargs="+"
    )

    args = _parser.parse_args()

    try:
        trio.run(main, args)
    except Exception:
        import traceback
        traceback.print_last()
    
    input("All done, press enter to exit: ")
