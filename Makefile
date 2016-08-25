HOST := localhost
PORT := 9200
base := http://$(HOST):$(PORT)

default: load

elasticsearch_available:
	curl $(base)

accounts.zip:
	wget 'https://github.com/bly2k/files/blob/master/accounts.zip?raw=true' -O accounts.zip
accounts.json: accounts.zip
	unzip accounts.zip

load:
	curl -s -XPOST '$(base)/bank/account/_bulk?pretty' --data-binary "@accounts.json" >/dev/null
	curl -s '$(base)/_cat/indices?v'

search_:
	curl '$(base)/bank/account/_search?q=firstname:Aurelia&size=10'; echo
search_jq:
	curl '$(base)/bank/account/_search?q=firstname:Aurelia&size=10' | jq .

clean:
	rm -f accounts.*
	curl -XDELETE '$(base)/bank'

docs:
	python -mwebbrowser https://www.elastic.co/guide/en/elasticsearch/reference/current/_exploring_your_data.html
