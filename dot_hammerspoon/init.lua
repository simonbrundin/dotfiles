local isPaused = false
local timer = hs.timer.new(2, function()
    local hasVideo = false
    -- Check Safari
    local safariOutput = hs.execute("osascript /Users/simon/check_video.scpt")
    if string.match(safariOutput, "true") then
        hasVideo = true
    end
    -- Check Chrome
    local chromeOutput = hs.execute("chrome-cli execute \"Array.from(document.querySelectorAll('video')).some(v => !v.paused && !v.muted)\"")
    if string.match(chromeOutput, "true") then
        hasVideo = true
    end
    if hasVideo and not isPaused then
        hs.alert("Pausing Spotify")
        os.execute("/opt/homebrew/bin/spotify_player playback pause")
        isPaused = true
    elseif not hasVideo then
        isPaused = false
    end
end)
timer:start()