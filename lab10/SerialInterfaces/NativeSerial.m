classdef NativeSerial < SerialInterface
    properties (Access = private)
        baudRate double = 1000000;
        timeOut double = 0.005;
        comObj
    end
    
    methods
        function obj = NativeSerial(port)
           obj.comObj = serialport(port, obj.baudRate, 'Timeout', obj.timeOut);
        end

        function open(obj)
            pause(0.5);
            fopen(obj.comObj);
            pause(5);
        end

        function data_w = write(obj, u)
            u = max(min(u,1),-1);
            u = floor(255*u);
            write(obj.comObj, u, "uint8");
            data_w = uint8(u);
        end

        function data = read(obj)
            data = read(obj.comObj, 8, "uint8");
            if length(data) < 8
                data = zeros(8, 1);
            end
        end
        
        function flush(obj)
            flush(obj.comObj);
        end

        function close(obj)
            clear('obj.comObj');
        end
    end
end

