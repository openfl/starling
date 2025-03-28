# Starling Release Checklist

- Add release notes to _CHANGELOG.md_
	- Compare to previous tag on GitHub:
		`https://github.com/openfl/starling/compare/a.b.c...master`
	- Compare to previous tag in terminal:
		```sh
		git log a.b.c...master --oneline
		```
	- Sometimes, commits from previous releases show up, but most should be correct
- Update release note in _haxelib.json_
- Update version in _haxelib.json_ (may be updated already)
- Update version in _package.json_ (may be updated already)
- Update openfl version in _package.json_
	```json
	 "openfl": "^9.4.1",
	```
- Delete _node\_modules_ and _package-lock.json_.
- Run **`npm install`**.
	- On macOS, **`arch -x86_64 npm install`** may be required
- Update release date in _CHANGELOG.md_
- Tag release and push
	```sh
	git tag -s x.y.z -m "version x.y.z"
	git push origin x.y.z
	```
- Download _starling-haxelib_, _starling-npm.tgz_, and _starling-docs_ artifacts for tag from GitHub Actions
- Submit _.zip_ file to Haxelib with following command:
	```sh
	haxelib submit starling-haxelib.zip
	```
- Submit _.tgz_ file to npm with following command:
	```sh
	npm publish starling-npm.tgz
	```
- Create new release for tag on GitHub
	- Upload _starling-haxelib.zip_, _starling-npm.tgz_, and _starling-docs.zip_
