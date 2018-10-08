#!/usr/bin/env bash
#
# Problem 3
#
# URL: https://axe-level-1.herokuapp.com/lv3/
#
# Sample answer:
#   [{"town": "東區", "village": "東勢里", "name" : "林錦全"}...]
#

set -e

url=https://axe-level-1.herokuapp.com/lv3/
url_next="$url?page=next"

rm -rf jar

page=0
echo '['
while true ; do
	resp=$(curl -b jar -c jar -Ls "$url")
	echo "$resp" > page_$page
	rownum=0
	if [ "$page" -gt 0 ]; then
		echo ','
	fi
	echo "$resp" | grep '<td>' | while read -r field; do
		value=$(echo "$field" | sed -E 's|<td>(.*)</td>|\1|')
		i=$((rownum % 3))
		if [ "$rownum" -gt 2 ]; then
			if [ "$i" -eq 0 ]; then
				if [ "$rownum" -gt 5 ]; then
					echo ','
				fi
				echo "{\"town\": \"$value\","
			elif [ "$i" -eq 1 ]; then
				echo "\"village\": \"$value\","
			elif [ "$i" -eq 2 ]; then
				echo "\"name\": \"$value\"}"
			fi
		fi
		((rownum++))
	done
	if ! grep -q '?page=next' <(echo "$resp"); then
		break
	fi

	((page++))
	url="$url_next"
done
echo ']'
