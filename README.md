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

```
$ curl -s -X POST http://192.168.0.199:9090/hooks/console -H 'Content-Type: application/json' -d '{"vm_name": "node-1.nomad" }' | jq '.'
{
  "port": "1021",
  "user": "y99sf1cjKNHn",
  "password": "7M83IPmXeGyo0Fbx7FmMstepfdAvwvCD"
}
```
