function year = getMatlabVersionYear()
    year = version;
    year = str2double(year(1:2));
end