#!/usr/bin/env bash
echo "opt"
ls -la /opt

echo "opt/tfenv"
ls -la /opt/tfenv

echo "opt/tfenv/versions"
ls -la /opt/tfenv/versions

echo "list"
tfenv /opt/tfenv/bin/tfenv list

echo "version"
tfenv /opt/tfenv/bin/tfenv version-name