# -*- coding: utf-8 -*-
# @Author: Ishan Khanna
# @Date:   2016-09-05 13:44:56
# @Last Modified by:   Ishan Khanna
# @Last Modified time: 2016-09-05 16:38:09
import subprocess
import json
import datetime
import re

with open('change-log.json', 'r+') as changeLog:
	latestRelease = json.load(changeLog)

	afterDate = '2016-09-12'

	output = subprocess.check_output(["git", "log", "--oneline", "--after="+afterDate])
	logs = output.split('\n')

	major = latestRelease['major']
	minor = latestRelease['minor']
	patch = latestRelease['patch']

	features = []
	fixes = []
	improvements = []

	p = re.compile('(\S{7}\s)(feat|fix)(:\s)(.*)')
	for log in logs:
		if "WIP" not in log:
			matchObj = re.match(p, log)
			if matchObj:
				message = matchObj.group(4)
				if "feat:" in log:
					features.append(message)
				elif "fix:" in log:
					fixes.append(message)

	minor = minor + len(features)
	patch = patch + len(fixes)

	latestRelease['minor'] = minor
	latestRelease['patch'] = patch

	latestRelease['features'] = features
	latestRelease['fixes'] = fixes

	changeLog.seek(0)
	changeLog.write(json.dumps(latestRelease, indent=4, sort_keys=True))
	changeLog.truncate()
	changeLog.close()
