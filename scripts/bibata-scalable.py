#!/usr/bin/env python3
"""Build a scalable (SVG) Bibata cursor theme for GNOME Shell 51+.

GNOME 51 draws the pointer only from SVG themes in the KDE `cursors_scalable`
layout and ignores XCursor files, so the packaged Bibata silently falls back to
Adwaita. This renders Bibata's own SVG sources into that layout and links the
packaged XCursors next to it for X11 clients.

  bibata-scalable.py                           Bibata-Modern-Classic into ~/.local/share/icons
  bibata-scalable.py Bibata-Modern-Ice         another variant
  bibata-scalable.py VARIANT --dest DIR        somewhere else (copy to /usr/local/share/icons for GDM)
"""
import argparse, json, os, re, shutil, subprocess, sys, tomllib
from pathlib import Path

REPO = 'https://github.com/ful1e5/Bibata_Cursor'
TAG = 'v2.0.7'  # matches the bibata-cursor-theme-bin package

ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
ap.add_argument('variant', nargs='?', default='Bibata-Modern-Classic')
ap.add_argument('--dest', type=Path, default=Path.home() / '.local/share/icons')
args = ap.parse_args()

src = Path(os.environ.get('XDG_CACHE_HOME', Path.home() / '.cache')) / 'bibata-src' / TAG
if not src.exists():
    subprocess.run(['git', '-c', 'advice.detachedHead=false', 'clone', '-q', '--depth', '1', '--branch', TAG, REPO, str(src)], check=True)

render = json.loads((src / 'render.json').read_text())
if args.variant not in render:
    sys.exit(f'unknown variant {args.variant}, have: {", ".join(render)}')
spec = render[args.variant]
svgdir = src / spec['dir']
config = 'right' if args.variant.endswith('-Right') else 'normal'
cursors = tomllib.loads((src / 'configs' / config / 'x.build.toml').read_text())['cursors']
fallback = cursors.pop('fallback_settings')

recolor = [(re.compile(re.escape(c['match']), re.I), c['replace']) for c in spec['colors']]

def paint(svg: Path) -> str:
    text = svg.read_text()
    for pattern, color in recolor:
        text = pattern.sub(color, text)
    return text

theme = args.dest / args.variant
out = theme / 'cursors_scalable'
shutil.rmtree(out, ignore_errors=True)
out.mkdir(parents=True)

aliases = {}
for c in cursors.values():
    name, stem = c['x11_name'], c['png'].removesuffix('.png')
    # Animated cursors are a directory of numbered frames, e.g. wait/wait-01.svg.
    frames = sorted((svgdir / name).glob(stem.replace('*', '??') + '.svg')) if '*' in stem else [svgdir / f'{stem}.svg']
    target = out / name
    target.mkdir()
    meta = []
    for frame in frames:
        (target / frame.name).write_text(paint(frame))
        # Hotspots are in the 256px source canvas; nominal_size 256 makes size 24
        # render 24px wide, exactly like the packaged XCursors.
        entry = {'filename': frame.name, 'hotspot_x': c.get('x_hotspot', fallback['x_hotspot']),
                 'hotspot_y': c.get('y_hotspot', fallback['y_hotspot']), 'nominal_size': 256}
        if len(frames) > 1:
            entry['delay'] = c.get('x11_delay', fallback['x11_delay'])
        meta.append(entry)
    (target / 'metadata.json').write_text(json.dumps(meta, indent=2) + '\n')
    for alias in c.get('x11_symlinks', []):
        aliases[alias] = name

# GNOME asks for all-resize, which Bibata only ships as all-scroll.
aliases.setdefault('all-resize', aliases.get('all-scroll', 'fleur'))
for alias, name in aliases.items():
    if not (out / alias).exists():
        (out / alias).symlink_to(name)

system = Path('/usr/share/icons') / args.variant
if (system / 'cursors').is_dir():
    link = theme / 'cursors'
    if link.is_symlink() or not link.exists():
        link.unlink(missing_ok=True)
        link.symlink_to(system / 'cursors')
index = system / 'index.theme'
(theme / 'index.theme').write_text(index.read_text() if index.exists() else f'[Icon Theme]\nName={args.variant}\n')

print(f'{args.variant}: {len(cursors)} cursors, {len(aliases)} aliases -> {theme}')
