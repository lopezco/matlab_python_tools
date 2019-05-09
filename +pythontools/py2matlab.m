function outObject = py2matlab(inObject)
%PY2MATLAB Summary of this function goes here
%   Detailed explanation goes here
switch class(inObject)
    case 'py.dict'
        % Convert to struct
        outObject = struct(inObject);
        for f = fieldnames(outObject)'
            outObject.(char(f)) = pythontools.py2matlab(outObject.(char(f)));
        end 
    case {'py.list', 'py.tuple'}
        % Convert to cell array
        outObject = cellfun(@pythontools.py2matlab, cell(inObject));
    case  'py.numpy.ndarray'
        % Convert to py.list first then to cell array
        % Reshape to 1-N
        outObject = inObject.reshape(inObject.size);
        % Transform to matlab object
        outObject = pythontools.py2matlab(outObject.tolist());
        % Reshape into original size
        originalSize = cell(inObject.shape);
        outObject = reshape(outObject, originalSize{:});
    case {...
            'py.int', 'py.float', ...
            'py.numpy.float', 'py.numpy.float16', 'py.numpy.float32', 'py.numpy.float64', ...
            'py.numpy.int', 'py.numpy.int0', 'py.numpy.int8', 'py.numpy.int16', 'py.numpy.int32', 'py.numpy.int64'}
        % Convert to double
        outObject = double(py.float(inObject));
    case 'py.pandas.core.frame.DataFrame'
        % Convert to py.dict then to json string and then to table
        % TO DO: Look for a way to do this more efficiently 
        tmp = py.json.dumps(inObject.to_dict('records'));
        tmp = jsondecode(char(tmp));
        outObject = struct2table(tmp);
    case {'py.str', 'py.unicode'}
        % Convert to char
        outObject = char(inObject);
    case 'double'
        if isempty(inObject)
            outObject = NaN;
        else
            outObject = inObject;
        end
    otherwise
        % Not necessary to convert or not yet supported
        outObject = inObject;
end


