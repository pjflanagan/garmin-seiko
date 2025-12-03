
# Development

## Building the App

1. Make changes in `watch-face-template`.
2. Use `##key##` for templated data.
3. Run `python3 generateDev.py`
4. Open `schools/_development` in a new VSCode window
5. Run Monkey C scripts from there as normal

If you make changes in any of the `.mc` files, you can just replace them in the `watch-face-template` as they are not templated.
The files that contain templated data are:
- `manfiest.xml`
- `README.md`
- `resources/layout.xml`
- `resources/strings.xml`

## Making a font

- https://snowb.org/

## Generating a School

1. Add a school to `schools.json`
  - Ensure that `generate` is set to `true`
2. Ensure `generate` is set to `false` on schools you do not want to generate
3. Run `python3 generate.py`
4. Open a school by running `code watch-face/<schoolId>`
5. In the new schools `manifest.xml`, generate a new UUID
  - Copy and paste this UUID into `schools.json` so if we ever regenerate we keep the same UUID

## Generating Promo Images

1. Run `python3 generateSchoolPromoImages.py`

## Release

1. Go to Garmin ConnectIQ