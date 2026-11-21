# Fenrir Browser theme

Firefox only installs signed add-ons, themes included, so this folder is the
theme's source and the ISO installs a signed copy.

To update the theme:

1. Edit `manifest.json` and bump `version`.
2. Sign it on addons.mozilla.org as an **unlisted** add-on
   (`web-ext sign --channel=unlisted` with your AMO API key, run in this folder).
3. Save the signed file here as `fenrir-theme-signed.xpi`.

`build.sh` copies `fenrir-theme-signed.xpi` into the ISO as
`/usr/lib/firefox/distribution/extensions/fenrir-theme@fenrirlinux.org.xpi`,
where the Firefox policy in `policies.json` installs it from. Without a signed
file the ISO still builds; Firefox just keeps its default theme.
