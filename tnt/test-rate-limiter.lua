http_client = require('http.client').new()
address = 'http://ec2-13-53-199-37.eu-north-1.compute.amazonaws.com/kv/some-key'
test_interval_seconds = 10

initial_time = os.time(os.date("*t"))
current_time = initial_time
count_ok = 0
while current_time < initial_time + test_interval_seconds do
    response = http_client:request('GET', address)
    if response.status == 200 then
        count_ok = count_ok + 1
    end
    current_time = os.time(os.date("*t"))
end

print("Allowed request rate is " .. count_ok / test_interval_seconds .. "rps")
