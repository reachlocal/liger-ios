#! /usr/bin/env bash

instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ~/Library/Application\ Support/iPhone\ Simulator/7.0/Applications/5E30257C-B63E-4E9C-B94D-D77BF911525A/Liger.app -e UIASCRIPT Automation/LigerTest.js -e UIARESULTSPATH /tmp/
