classdef LegacySerial < SerialInterface
    properties (Access = private)
        baudRate double = 1000000;
        comObj
    end
    
    methods
        function obj = LegacySerial(port)
           obj.comObj = serial(port, 'BaudRate', obj.baudRate);
           obj.comObj.Timeout = 0.005;
        end

        function open(obj)
            pause(0.5);
            fopen(obj.comObj);
            pause(5);
        end

        function data_w = write(obj, u)
            u = max(min(u,1),-1);
            u = floor(255*u);
            fwrite(obj.comObj, u, "uint8");
            data_w = uint8(u);
        end

        function data = read(obj)
            data = fread(obj.comObj, 8, "uint8");
            if length(data) < 8
                data = zeros(8, 1);
            end
        end
        
        function flush(obj)
            flushinput(obj.comObj);
            flushoutput(obj.comObj);
        end

        function close(obj)
            fclose(obj.comObj);
            delete(obj.comObj);
            clear('obj.comObj');
        end
    end
end

