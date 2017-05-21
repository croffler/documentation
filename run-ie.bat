@echo off
call generate-ie-navbar.bat
echo Starting Hugo...
hugo --config="sites/ie-docs/config.toml" server --watch --theme="ie-theme" --layoutDir="/sites/ie-docs/layouts"
popd


