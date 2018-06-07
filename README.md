# Test Webhook

https://github.com/adnanh/webhook


```
 webhook -hooks hooks.json -port 9090 -verbose
```


```
curl -X POST \
  http://localhost:9090/hooks/create-service \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
	"team": "Team name",
	"domain": "www.example.com",
	"application": "gitlab"
}'
```
