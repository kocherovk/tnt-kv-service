# Simple tarantool based key value http service

To start the app:
```bash
docker-compose build
docker-compose up
```

then look for api endpoint   
`http://127.0.0.1:8000/kv/some-key`  
or swagger ui  
`http://127.0.0.1:8000/swagger-ui/`

###  How to test rate limiter
Run 
```
tarantool test-rate-limiter.lua
```
see `tnt/test-rate-limiter.lua` for more details
