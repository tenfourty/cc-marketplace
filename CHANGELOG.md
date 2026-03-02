# Changelog

## [0.16.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.15.1...cc-marketplace-v0.16.0) (2026-03-02)


### Features

* add /focus command for tmux pane spotlight ([#44](https://github.com/tenfourty/cc-marketplace/issues/44)) ([d14593b](https://github.com/tenfourty/cc-marketplace/commit/d14593bfa931395e21502ed50c798cadd517ae33))

## [0.15.1](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.15.0...cc-marketplace-v0.15.1) (2026-03-02)


### Bug Fixes

* warn about using full calendar_uid for recurring events in /prep ([#42](https://github.com/tenfourty/cc-marketplace/issues/42)) ([6d0d59e](https://github.com/tenfourty/cc-marketplace/commit/6d0d59e741158c10c189356b4581cdb61f31c88b))

## [0.15.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.14.0...cc-marketplace-v0.15.0) (2026-03-02)


### Features

* use --counts for status summaries and flag tentative meetings ([#40](https://github.com/tenfourty/cc-marketplace/issues/40)) ([9c407ae](https://github.com/tenfourty/cc-marketplace/commit/9c407ae79beffd319d81672cd4bfdb24ffdfa390))

## [0.14.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.13.0...cc-marketplace-v0.14.0) (2026-03-02)


### Features

* complete --hide-declined and source-type coverage across all files ([#38](https://github.com/tenfourty/cc-marketplace/issues/38)) ([6009ab2](https://github.com/tenfourty/cc-marketplace/commit/6009ab27fdfdb23eef9f86b5fef8a0cef4feaed6))

## [0.13.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.12.0...cc-marketplace-v0.13.0) (2026-03-02)


### Features

* use gm my_status field and --hide-declined flag ([#36](https://github.com/tenfourty/cc-marketplace/issues/36)) ([1df45b2](https://github.com/tenfourty/cc-marketplace/commit/1df45b259e7458c962584f8511ebea164d60164f))

## [0.12.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.11.3...cc-marketplace-v0.12.0) (2026-03-02)


### Features

* skip declined meetings in /prep, /briefing, and briefer boot-up ([#34](https://github.com/tenfourty/cc-marketplace/issues/34)) ([53263a9](https://github.com/tenfourty/cc-marketplace/commit/53263a9313bf07470e6dbb7f007aea1241c572f9))

## [0.11.3](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.11.2...cc-marketplace-v0.11.3) (2026-03-02)


### Bug Fixes

* restore --title in /prep Granola push ([#32](https://github.com/tenfourty/cc-marketplace/issues/32)) ([e9ce6c0](https://github.com/tenfourty/cc-marketplace/commit/e9ce6c069450d77b2a1b0ed42c5bf79624f5fcc5))

## [0.11.2](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.11.1...cc-marketplace-v0.11.2) (2026-03-02)


### Bug Fixes

* remove --title from Granola push in /prep ([#30](https://github.com/tenfourty/cc-marketplace/issues/30)) ([b652c3f](https://github.com/tenfourty/cc-marketplace/commit/b652c3f5b50ff44fe7a7319f5a76506a8663bdf6))

## [0.11.1](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.11.0...cc-marketplace-v0.11.1) (2026-03-02)


### Bug Fixes

* debrief reads all meeting sources, not just transcript fallback ([#28](https://github.com/tenfourty/cc-marketplace/issues/28)) ([eaad77c](https://github.com/tenfourty/cc-marketplace/commit/eaad77c0e8f5f218125bd101af6e53d589292205))

## [0.11.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.10.3...cc-marketplace-v0.11.0) (2026-03-02)


### Features

* add meeting data source-type guidance (transcript &gt; notes &gt; ai-summary) ([#26](https://github.com/tenfourty/cc-marketplace/issues/26)) ([7d468cc](https://github.com/tenfourty/cc-marketplace/commit/7d468ccbf2bffbcfc139f93f798be7e7872d6294))

## [0.10.3](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.10.2...cc-marketplace-v0.10.3) (2026-03-02)


### Bug Fixes

* simplify Granola push — auto-create removes doc-not-found case ([#24](https://github.com/tenfourty/cc-marketplace/issues/24)) ([a07725c](https://github.com/tenfourty/cc-marketplace/commit/a07725c7e89a762399610217b408683d6e314c65))

## [0.10.2](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.10.1...cc-marketplace-v0.10.2) (2026-03-02)


### Bug Fixes

* use calendar UID for Granola push, drop auto-create ([#22](https://github.com/tenfourty/cc-marketplace/issues/22)) ([d717c6f](https://github.com/tenfourty/cc-marketplace/commit/d717c6f953bccfcc8643f8d5f9b67a04622379be))

## [0.10.1](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.10.0...cc-marketplace-v0.10.1) (2026-03-02)


### Bug Fixes

* make Granola push optional in /prep (ask user first) ([#20](https://github.com/tenfourty/cc-marketplace/issues/20)) ([1cf8700](https://github.com/tenfourty/cc-marketplace/commit/1cf8700b1bdf3ce0352f6631d39706429f469ce6))

## [0.10.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.9.0...cc-marketplace-v0.10.0) (2026-03-02)


### Features

* push prep notes to Granola after generating brief ([#18](https://github.com/tenfourty/cc-marketplace/issues/18)) ([7db1498](https://github.com/tenfourty/cc-marketplace/commit/7db1498a6383bcb9f09ab50fc3b97ca95b27d27c))

## [0.9.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.8.8...cc-marketplace-v0.9.0) (2026-03-02)


### Features

* absorb productivity plugin features (v0.5.0) ([99a7a25](https://github.com/tenfourty/cc-marketplace/commit/99a7a25fdda662e52afc861c053625a8ef794ca9))
* add coaching, risk analysis, and knowledge commands (v0.4.0) ([052eaaf](https://github.com/tenfourty/cc-marketplace/commit/052eaaf0acba8b8bf3f213f75b5e3d80a0dd6475))
* add Gmail, Google Calendar MCPs and integrate email across commands ([20b0119](https://github.com/tenfourty/cc-marketplace/commit/20b0119a87c935f1fb1da70a8e2c0d83651f48a4))
* **cos:** add /boot-team command with 3 persistent agents ([#4](https://github.com/tenfourty/cc-marketplace/issues/4)) ([a4a7656](https://github.com/tenfourty/cc-marketplace/commit/a4a7656d05d94df5b2d183e6ccc87d22d68dee23))
* **cos:** context freshness + project linking ([#2](https://github.com/tenfourty/cc-marketplace/issues/2)) ([99a5837](https://github.com/tenfourty/cc-marketplace/commit/99a58378afef4d845b0c048beadb663892fc2a3e))
* initial Chief of Staff plugin for Claude Cowork ([e0fbe22](https://github.com/tenfourty/cc-marketplace/commit/e0fbe22f0508500c87ef25a0aea25bd110c80624))
* restructure as marketplace repo with release automation ([c8f814a](https://github.com/tenfourty/cc-marketplace/commit/c8f814ad6db84bc0a89ead323f5e9f82e76a842e))
* use kbx view --plain and kbx note edit commands ([d0ae232](https://github.com/tenfourty/cc-marketplace/commit/d0ae232866e79308b47712438560ac0fc2f55ce4))


### Bug Fixes

* 45/55 layout ratio, descriptive agent names, ops session rename ([#9](https://github.com/tenfourty/cc-marketplace/issues/9)) ([8b06eb8](https://github.com/tenfourty/cc-marketplace/commit/8b06eb82faab97f93bc7cbea248909f0e54181bd))
* add culture to advisor pane title ([#14](https://github.com/tenfourty/cc-marketplace/issues/14)) ([148820f](https://github.com/tenfourty/cc-marketplace/commit/148820fbd2a1eb386abbce8792d01632fe923644))
* **cos:** add explicit tmux layout steps to /boot-team ([#7](https://github.com/tenfourty/cc-marketplace/issues/7)) ([97f9e56](https://github.com/tenfourty/cc-marketplace/commit/97f9e56f6bc8de6d851dde837501ca193edc81ce))
* **cos:** main session becomes ops instead of spawning separate agent ([#6](https://github.com/tenfourty/cc-marketplace/issues/6)) ([f123f99](https://github.com/tenfourty/cc-marketplace/commit/f123f99f1e3f3d20f5b549717ab6ad8d43f11441))
* enforce run_in_background for all worker agent spawning ([#12](https://github.com/tenfourty/cc-marketplace/issues/12)) ([fafc6a4](https://github.com/tenfourty/cc-marketplace/commit/fafc6a4e9e47a04a4c3152e7aaebdeae6bf81467))
* mandatory tmux layout, pane titles, explicit rename ([#11](https://github.com/tenfourty/cc-marketplace/issues/11)) ([035baf9](https://github.com/tenfourty/cc-marketplace/commit/035baf956f3fe5f633cd12dcddfb43584bcda047))
* use pane-border-format for all three pane titles ([#15](https://github.com/tenfourty/cc-marketplace/issues/15)) ([6d2dec2](https://github.com/tenfourty/cc-marketplace/commit/6d2dec2058de26485d096c11cdd61f94d6461cc3))
* use pane-border-format for ops pane title ([#13](https://github.com/tenfourty/cc-marketplace/issues/13)) ([6cc3397](https://github.com/tenfourty/cc-marketplace/commit/6cc3397f018ffa48ce92e3c34f75f9aa13d07dcc))

## [0.8.3](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.8.2...cc-marketplace-v0.8.3) (2026-03-02)


### Bug Fixes

* use pane-border-format for all three pane titles ([#15](https://github.com/tenfourty/cc-marketplace/issues/15)) ([6d2dec2](https://github.com/tenfourty/cc-marketplace/commit/6d2dec2058de26485d096c11cdd61f94d6461cc3))

## [0.8.2](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.8.1...cc-marketplace-v0.8.2) (2026-03-02)


### Bug Fixes

* 45/55 layout ratio, descriptive agent names, ops session rename ([#9](https://github.com/tenfourty/cc-marketplace/issues/9)) ([8b06eb8](https://github.com/tenfourty/cc-marketplace/commit/8b06eb82faab97f93bc7cbea248909f0e54181bd))
* add culture to advisor pane title ([#14](https://github.com/tenfourty/cc-marketplace/issues/14)) ([148820f](https://github.com/tenfourty/cc-marketplace/commit/148820fbd2a1eb386abbce8792d01632fe923644))
* enforce run_in_background for all worker agent spawning ([#12](https://github.com/tenfourty/cc-marketplace/issues/12)) ([fafc6a4](https://github.com/tenfourty/cc-marketplace/commit/fafc6a4e9e47a04a4c3152e7aaebdeae6bf81467))
* mandatory tmux layout, pane titles, explicit rename ([#11](https://github.com/tenfourty/cc-marketplace/issues/11)) ([035baf9](https://github.com/tenfourty/cc-marketplace/commit/035baf956f3fe5f633cd12dcddfb43584bcda047))
* use pane-border-format for ops pane title ([#13](https://github.com/tenfourty/cc-marketplace/issues/13)) ([6cc3397](https://github.com/tenfourty/cc-marketplace/commit/6cc3397f018ffa48ce92e3c34f75f9aa13d07dcc))

## [0.8.1](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.8.0...cc-marketplace-v0.8.1) (2026-03-02)


### Bug Fixes

* **cos:** add explicit tmux layout steps to /boot-team ([#7](https://github.com/tenfourty/cc-marketplace/issues/7)) ([97f9e56](https://github.com/tenfourty/cc-marketplace/commit/97f9e56f6bc8de6d851dde837501ca193edc81ce))

## [0.8.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.7.0...cc-marketplace-v0.8.0) (2026-03-02)


### Features

* **cos:** add /boot-team command with 3 persistent agents ([#4](https://github.com/tenfourty/cc-marketplace/issues/4)) ([a4a7656](https://github.com/tenfourty/cc-marketplace/commit/a4a7656d05d94df5b2d183e6ccc87d22d68dee23))


### Bug Fixes

* **cos:** main session becomes ops instead of spawning separate agent ([#6](https://github.com/tenfourty/cc-marketplace/issues/6)) ([f123f99](https://github.com/tenfourty/cc-marketplace/commit/f123f99f1e3f3d20f5b549717ab6ad8d43f11441))

## [0.7.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.6.0...cc-marketplace-v0.7.0) (2026-03-02)


### Features

* **cos:** context freshness + project linking ([#2](https://github.com/tenfourty/cc-marketplace/issues/2)) ([99a5837](https://github.com/tenfourty/cc-marketplace/commit/99a58378afef4d845b0c048beadb663892fc2a3e))

## [0.6.0](https://github.com/tenfourty/cc-marketplace/compare/cc-marketplace-v0.5.0...cc-marketplace-v0.6.0) (2026-02-25)


### Features

* absorb productivity plugin features (v0.5.0) ([99a7a25](https://github.com/tenfourty/cc-marketplace/commit/99a7a25fdda662e52afc861c053625a8ef794ca9))
* add coaching, risk analysis, and knowledge commands (v0.4.0) ([052eaaf](https://github.com/tenfourty/cc-marketplace/commit/052eaaf0acba8b8bf3f213f75b5e3d80a0dd6475))
* add Gmail, Google Calendar MCPs and integrate email across commands ([20b0119](https://github.com/tenfourty/cc-marketplace/commit/20b0119a87c935f1fb1da70a8e2c0d83651f48a4))
* initial Chief of Staff plugin for Claude Cowork ([e0fbe22](https://github.com/tenfourty/cc-marketplace/commit/e0fbe22f0508500c87ef25a0aea25bd110c80624))
* restructure as marketplace repo with release automation ([c8f814a](https://github.com/tenfourty/cc-marketplace/commit/c8f814ad6db84bc0a89ead323f5e9f82e76a842e))
* use kbx view --plain and kbx note edit commands ([d0ae232](https://github.com/tenfourty/cc-marketplace/commit/d0ae232866e79308b47712438560ac0fc2f55ce4))
