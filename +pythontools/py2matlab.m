function outObject = py2matlab(inObject)
%PY2MATLAB Summary of this function goes here
%   Detailed explanation goes here
numericTypes = {...
            'py.int', 'py.float', ...
            'py.numpy.float', 'py.numpy.float16', 'py.numpy.float32', ...
            'py.numpy.float64', 'py.numpy.int', 'py.numpy.int0', ...
            'py.numpy.int8', 'py.numpy.int16', 'py.numpy.int32', ...
            'py.numpy.int64', 'py.numpy.uint', 'py.numpy.uint0', ...
            'py.numpy.uint8', 'py.numpy.uint16', 'py.numpy.uint32', ...
            'py.numpy.uint64', 'py.numpy.uintc', 'py.numpy.uintp'};
switch class(inObject)
    case 'py.dict'
        % Convert to struct
        outObject = struct(inObject);
        for f = fieldnames(outObject)'
            outObject.(char(f)) = pythontools.py2matlab(outObject.(char(f)));
        end 
    case {'py.list', 'py.tuple'}
        % Convert to cell array
        outObject = cellfun(@pythontools.py2matlab, cell(inObject), ...
            'UniformOutput', false);
    case  'py.numpy.ndarray'
        % Convert to py.list first then to cell array
        % Reshape to 1-N
        outObject = inObject.reshape(inObject.size);
        % Transform to matlab object
        switch ['py.numpy.' char(py.str(inObject.dtype))]
            case numericTypes
                % https://fr.mathworks.com/matlabcentral/answers/157347-convert-python-numpy-array-to-double
                outObject = double(py.array.array('d', py.numpy.nditer(inObject)));
            otherwise
                outObject = pythontools.py2matlab(outObject.tolist());         
        end        
        % Reshape into original size
        if py.len(inObject.shape) == 1
            originalSize = {1, double(inObject.shape{1})};
        else
            originalSize = pythontools.py2matlab(inObject.shape);
        end
        
        if ~isempty(originalSize)
            outObject = reshape(outObject, originalSize{:});
        end
    case numericTypes
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