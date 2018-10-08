#!/usr/bin/env bash
#
# Problem 1: Basic table in HTML
#
# URL: http://axe.g0v.tw/level/1
#
# Sample answer:
#   [{"name": "王小明", "grades": {"國語": 90, "數學": 89, ...}}, ... ]
#

url=https://axe-level-1.herokuapp.com/
rownum=0
echo "["
curl -s "$url" | grep '<td>' | while read -r field; do
	value=$(echo "$field" | sed -E 's|<td>(.*)</td>|\1|')
	i=$((rownum % 6))
	if [ "$rownum" -gt 5 ]; then
		if [ "$i" -eq 0 ]; then
			if [ "$rownum" -gt 10 ]; then
				echo ","
			fi
			echo "{\"name\": \"$value\","
		elif [ "$i" -eq 1 ]; then
			echo "\"grades\": {\"國語\": $value,"
		elif [ "$i" -eq 2 ]; then
			echo "\"數學\": $value,"
		elif [ "$i" -eq 3 ]; then
			echo "\"自然\": $value,"
		elif [ "$i" -eq 4 ]; then
			echo "\"社會\": $value,"
		elif [ "$i" -eq 5 ]; then
			echo "\"健康教育\": $value}}"
		fi
	fi
	((rownum++))
done
echo "]"
