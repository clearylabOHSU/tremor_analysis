
import os
import mbientlab.warble as w
from PyInstaller.utils.hooks import collect_all

# Locate warble.dll inside venv/site-packages
w_lib = os.path.join(os.path.dirname(w.__file__), 'lib', 'warble.dll')

# collect PyQt5 resources automatically (Qt plugins, etc.)
datas, binaries, hiddenimports = collect_all('PyQt5')

# Include UI and resource folder
datas += [('spiralDraw.ui', '.')]
datas += [('ims', 'ims')]

# Put warble.dll where MetaWear finds it
binaries.append((w_lib, 'mbientlab/warble'))

block_cipher = None

a = Analysis(
    ['SpiralDrawUI.py'],
    pathex=[],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hooksconfig={},
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    name='HIFU-Spiral',
    console=False,  # GUI app
)

# onedir output (recommended for first run/debug). You can pass --onefile at build time if you prefer.
coll = COLLECT(exe, a.binaries, a.zipfiles, a.datas, name='HIFU-Spiral')
