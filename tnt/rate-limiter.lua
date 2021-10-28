local rateLimiter = {
    new = function(limit)
        return {
            limit = limit,
            current = 0,
            check_timestamp = 0,
        }
    end,

    inc = function(rateLimiter)
        current_timestamp = os.time(os.date("*t"))

        if rateLimiter.check_timestamp == current_timestamp then
            if rateLimiter.current + 1 > rateLimiter.limit then
                error("rate limit exceeded")
            end

            rateLimiter.current = rateLimiter.current + 1
        else
            rateLimiter.current = 1
            rateLimiter.check_timestamp = current_timestamp
        end
    end
}


return rateLimiter