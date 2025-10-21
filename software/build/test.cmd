.venv\Scripts\activate
python - <<PY
import os, sys
try:
	import mbientlab.warble as w
	p = os.path.dirname(w.__file__)
	print("mbientlab.warble package:", p)
	print("mbientlab.warble\\lib:", os.path.join(p, "lib"))
	print("files:", os.listdir(os.path.join(p,"lib")) if os.path.isdir(os.path.join(p,"lib")) else "NO LIB DIR")
except Exception as e:
	print("mbientlab.warble import failed:", e)
	try:
		import warble as w2
		p = os.path.dirname(w2.__file__)
		print("warble package:", p)
		print("warble\\lib:", os.path.join(p, "lib"))
		print("files:", os.listdir(os.path.join(p,"lib")) if os.path.isdir(os.path.join(p,"lib")) else "NO LIB DIR")
	except Exception as e2:
		print("warble import failed too:", e2)
PY
