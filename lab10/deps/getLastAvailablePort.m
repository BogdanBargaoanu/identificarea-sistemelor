function port = getLastAvailablePort(isLegacy)
    if isLegacy
        availablePorts = seriallist("available");
    else
        availablePorts = serialportlist("available");
    end
    lastPort = availablePorts(end);
    port = lastPort{1};
end