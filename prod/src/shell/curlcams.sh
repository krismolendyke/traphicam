#!/usr/bin/env bash

#url=http://www.dot35.state.pa.us/public/Districts/District6/WebCams/
url=http://www.dot35.state.pa.us/public/Districts/District5/WebCams/
out=test.txt

curl "${url}D5cam[001-100].jpg" --silent -o 'AAA.jpg' -# -w "%{url_effective} %{http_code}\n" > ${out}
