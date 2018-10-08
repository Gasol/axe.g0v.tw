#!/usr/bin/env bash
#
# Problem 4
#
# URL: https://axe-level-4.herokuapp.com/lv4/
#
# Sample answer:
#   [{"town": "東區", "village": "東勢里", "name" : "林錦全"}...]
#

set -e

url='https://axe-level-4.herokuapp.com/lv4/'
user_agent='Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'
curl_opts="-A '${user_agent}' -e '${url}; auto' -Ls"
echo '['
eval curl "$curl_opts" "$url" | sed -Ee '/a href/!d; s/.*href="\?page=([0-9]+)">.*/\1/' | while read -r page; do
	page_url="$url?page=$page"
	rownum=0
	if [ "$page" -gt 1 ]; then
		echo ','
	fi
	eval curl "$curl_opts" "$page_url" | grep '<td>' |  while read -r field; do
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
