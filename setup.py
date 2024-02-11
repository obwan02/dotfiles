import os
import sys
import shutil
import string
from typing import Optional
from pathlib import Path
from subprocess import run, CalledProcessError

def eprint(*args, **kwargs):
    """
    Same parameters as print, except writes to stderr by default
    """
    print(*args, file=sys.stderr, **kwargs)

def symlink(file: Path, target: Path, is_dir: bool = False):
    if file.exists() and file.is_symlink():
        print(f"skip {file} --> {target} :: already exists")
        return
    elif file.exists():
        raise FileExistsError(f"{file} exists, and is not a symlink!")

    if not target.exists():
        print(f"? {file} --> {target} :: making symlink, but target does not exist")
    else:
        print(f"+ {file} --> {target}")
        file.symlink_to(target, target_is_directory=is_dir)

def main(repo_dir: Path, nvim_executable: Optional[Path]):

    if nvim_executable:
        try:
            res = run([nvim_executable, "--headless", "+echo stdpath('config')", "+q"], capture_output=True, check=True)
            nvim_cfg_dir = Path(res.stderr.decode().strip())
            symlink(nvim_cfg_dir, repo_dir / '.config' / 'nvim', is_dir=True)
        except CalledProcessError as e:
            stderr = ">>> ".join(e.stderr.splitlines())
            eprint(f"'nvim' executable returned a non-zero exit code: {e}.\nSTDERR: \n {stderr}")
    else:
        eprint("Skipping .config/nvim symlink as path to nvim executable wasn't provided")

    if os.name not in ['nt', 'posix']:
        eprint("Unknown OS type :(, I only know about win32 and posix systems")
        return

    symlink(Path.home() / '.vimrc', repo_dir / '.vimrc')


    if os.name == "nt":
        eprint("! I do not know the location of kitty config for windows :(( plz help")
    else:
        symlink(Path.home() / '.config' / 'kitty', repo_dir / '.config' / 'kitty')

    if os.name == "nt":
        symlink(Path.home() / 'AppData' / 'Roaming' / '.emacs', repo_dir / '.emacs')
    else:
        symlink(Path.home() / '.emacs', repo_dir / '.emacs')

if __name__ == "__main__":
    if (nvim_executable := shutil.which("nvim")) is None:
        eprint("Couldn't find nvim executable in PATH")
    
    main(Path(__file__).parent, nvim_executable)
