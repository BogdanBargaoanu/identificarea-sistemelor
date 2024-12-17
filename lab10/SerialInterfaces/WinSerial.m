classdef WinSerial < SerialInterface
    properties (SetAccess = private)
        baudRate double = 1000000
        readTimeout double = 0.005;
        writeTimeout double = 0.005;
        comObj
    end
    
    methods
        function obj = WinSerial(port)
            obj.comObj = rs232('GetParams', 'default');
            obj.comObj.Port = port;
            obj.comObj.BaudRate = obj.baudRate;
            obj.comObj.ReadTimeout = obj.readTimeout;
            obj.comObj.WriteTimeout = obj.writeTimeout;
        end
        
        function open(obj)
            rs232('open', obj.comObj);
            pause(5);
        end

        function [data_r, empty] = read(obj, numBits)
            if ~exist('numBits', 'var')
               numBits = 8;
            end 
            empty = false;

            [data_r, ~] = rs232('read', obj.comObj, numBits);
            if (isempty(data_r))
                empty = true;
                data_r = zeros(8, 1);
            end
        end

        function flush(obj)
            empty = false;
            while ~empty
                [~, empty] = obj.read;
            end
        end

        function data_w = write(obj, u)
            u = max(min(u,1),-1);
            u = floor(255*u);
            data_w = uint8(u);
            rs232('write', obj.comObj, data_w);
        end

        function close(obj)
            obj.flush
            rs232('close', obj.comObj);
        end
    end
end

