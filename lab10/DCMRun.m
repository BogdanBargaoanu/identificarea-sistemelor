classdef DCMRun < handle
    properties (Access = private)
        comInterface
        kAng = 360/1024
        Ts = 10e-3;
        lastT = 0;
    end

    methods (Access = private)
        function this = DCMRun(type, port, Ts)
            addpath(genpath(pwd)); % add dependencies to path
            this.Ts = Ts;
            isLegacy = getMatlabVersionYear <= 19;
            
            if (port == "-")
                port = getLastAvailablePort(isLegacy);
            else
                port = port{1};
            end

            this.comInterface = handleGetComInterface(port, type, isLegacy);           
        end

        function open(this)
            this.comInterface.open();
            this.comInterface.write([1 0 1]); % start signal
            this.comInterface.flush;
            disp('Session started.');
        end

        function [velocity, alpha] = read(this)
            data = this.comInterface.read();

            alpha = this.uint8ToDouble(data(1:4))*this.kAng;
            velocity = this.uint8ToDouble(data(5:8))*60/1024/0.0025/3.2902;
        end

        function data_w = write(this, u)
            data_w = this.comInterface.write(u);
        end

        function close(this)
            this.comInterface.write([0 185/255 0]); % stop signal
            this.comInterface.close;
            disp('Session terminated.');
        end
    end
    
    methods (Static, Access = private)
        function [u, type, port, Ts] = parseRunInputs(u, varargin) 
            p = inputParser;
            expectedTypes = {"auto", "native", "windows"};
            
            addRequired(p, "u", @(t) isnumeric(t));
            addOptional(p, "type", "auto", @(t) any(validatestring(t, expectedTypes)))
            addOptional(p, "port", "-" , @isstring);
            addOptional(p, "Ts", 10e-3 ,@(t) isnumeric(t) && isscalar(t) && (t > 0));
            
            parse(p, u, varargin{:});
            
            u = p.Results.u;
            type = p.Results.type;
            port = p.Results.port;
            Ts = p.Results.Ts;
        end
    end

    methods (Static)
        function doub = uint8ToDouble(data)
            sig = 1;
            if data(4)>=128
                sig = -1;
                data(1:4)=255-data(1:4);
                data(1)=data(1)+1;
            end
            doub = sig*cast(typecast(uint8(data(1:4)), 'int32'), 'double');
        end

        function [velocity, alpha, time] = run(u, varargin)
            p = inputParser;
            expectedTypes = {"auto", "native", "windows"};
            
            addRequired(p, "u", @(t) isnumeric(t));
            addOptional(p, "type", "auto", @(t) any(validatestring(t, expectedTypes)))
            addOptional(p, "port", "-" , @isstring);
            addOptional(p, "Ts", 10e-3 ,@(t) isnumeric(t) && isscalar(t) && (t > 0));
            
            parse(p, u, varargin{:});
            
            u = p.Results.u;
            type = p.Results.type;
            port = p.Results.port;
            Ts = p.Results.Ts;
            
            toggleWarnings('off');

            serialObj = DCMRun(type, port, Ts);

            N = length(u);
            time = zeros(1, N);
            velocity = zeros(1, N);
            alpha = zeros(1,N);

            try
                serialObj.open();
                for k = 1:N
                    t = tic;
                    serialObj.write(u(k)/2 + 0.5);
                    [velocity(k), alpha(k)] = serialObj.read;
                    pauses(serialObj.Ts, t);
                    if (k > 1)
                        time(k) = time(k-1) + toc(t);
                    end
                end
                serialObj.close;
                toggleWarnings('on');
            catch err
                serialObj.close;
                toggleWarnings('on');
                rethrow(err)
            end
        end
        
        function [velocity, alpha, time] = runOnline(u, callback, varargin)
            p = inputParser;
            expectedTypes = {"auto", "native", "windows"};
            
            addRequired(p, "u", @(t) isnumeric(t));
            addOptional(p, "type", "auto", @(t) any(validatestring(t, expectedTypes)))
            addOptional(p, "port", "-" , @isstring);
            addOptional(p, "Ts", 10e-3 ,@(t) isnumeric(t) && isscalar(t) && (t > 0));
            
            parse(p, u, varargin{:});
            
            u = p.Results.u;
            type = p.Results.type;
            port = p.Results.port;
            Ts = p.Results.Ts;
            
            toggleWarnings('off');

            serialObj = DCMRun(type, port, Ts);

            N = length(u);
            time = zeros(1, N);
            velocity = zeros(1, N);
            alpha = zeros(1,N);

            try
                serialObj.open();
                for k = 1:N
                    t = tic;
                    serialObj.write(u(k)/2 + 0.5);
                    [velocity(k), alpha(k)] = serialObj.read;
                    pauses(serialObj.Ts, t);
                    if (k > 1)
                        time(k) = time(k-1) + toc(t);
                    end
                    callback(velocity(k), time(k));
                end
                serialObj.close;
                toggleWarnings('on');
            catch err
                serialObj.close;
                toggleWarnings('on');
                rethrow(err)
            end
        end

        function serialObj = start(varargin) 
            p = inputParser;
            expectedTypes = {"auto", "native", "windows"};
            
            addOptional(p, "type", "auto", @(t) any(validatestring(t, expectedTypes)))
            addOptional(p, "port", "-" , @isstring);
            addOptional(p, "Ts", 10e-3 ,@(t) isnumeric(t) && isscalar(t) && (t > 0));
            
            parse(p, varargin{:});
            
            type = p.Results.type;
            port = p.Results.port;
            ts = p.Results.Ts;
            
            toggleWarnings('off');

            serialObj = DCMRun(type, port, ts);
            serialObj.open;
        end
    end
    methods 
        function y = step(this, u)
            try 
                p = inputParser;
                addRequired(p, "u", @(t) isnumeric(t) && isscalar(t));
            
                parse(p, u);
                u = p.Results.u;
    
                this.lastT = tic;
                this.write(u/2 + 0.5);
                [y, ~] = this.read;
            catch err
                this.close;
                toggleWarnings('on');
                rethrow(err)
            end
        end

        function time = wait(this)
            if this.lastT == 0 
                this.lastT = tic;
            end
            pauses(this.Ts, this.lastT);
            time = toc(this.lastT);
        end

        function stop(this)
            toggleWarnings('on');
            this.close();
        end
    end
end

function toggleWarnings(toggle)
    warning(toggle, 'serialport:serialport:ReadWarning')
    warning(toggle, 'instrument:serial:ClassToBeRemoved')
    warning(toggle, 'instrument:seriallist:FunctionToBeRemoved')
end

function comInterface = handleGetComInterface(port, type, isLegacy)
    if ((type == "auto" && ispc) || type ~= "native") && getPortNumber(port) <= 8
        comInterface = WinSerial(port);
        disp("Using rs232.dll");
    elseif ((type == "auto" && isunix) || type == "native") || ~(getPortNumber(port) <= 8)
        if isLegacy
            comInterface = LegacySerial(port);
            disp("Using legacy serial");
        else
            comInterface = NativeSerial(port);
            disp("Using native serial");
        end
    end
end