#!/usr/bin/env bash
#
# Problem 2: Pagination
#
# URL: http://axe.g0v.tw/level/2

# Sample answer:
#   [{"town": "東區", "village": "東勢里", "name" : "林錦全"}...]


url=http://axe-level-1.herokuapp.com/lv2

echo '['
curl -Ls "$url" | sed -Ee '/a href/!d; s/.*href="\?page=([0-9]+)">.*/\1/' | while read -r page; do
	page_url="$url?page=$page"
	rownum=0
	if [ "$page" -gt 1 ]; then
		echo ','
	fi
	curl -Ls "$page_url" | grep '<td>' |  while read -r field; do
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
done
echo ']'
