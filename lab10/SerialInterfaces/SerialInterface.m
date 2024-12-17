classdef SerialInterface
    methods (Abstract)
        open(obj)
        read(obj, numBits)
        flush(obj)
        write(obj, u)
        close(obj)
    end
end

