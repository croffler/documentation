@echo off
call generate-xap-navbar.bat
echo Starting Hugo...
hugo --config="sites/xap-docs/config.toml" server --watch --theme="xap-theme" --layoutDir="/sites/xap-docs/layouts"
popd
