function outObject = matlab2py(inObject)
%MATLAB2PY Summary of this function goes here
%   Detailed explanation goes here
if istable(inObject)
    % Convert to py.pandas.DataFrame
    % table to struct
    outObject = table2struct(inObject);
    % Struct to py.dict
    outObject = pythontools.matlab2py(outObject);
    % Dict to py.pandas.DataFrame
    outObject = py.pandas.DataFrame(outObject);
elseif isa(inObject, 'struct')
    % Convert to py.dict
    outObject = py.dict();
    for k = fieldnames(inObject)'
        outObject{char(k)} = pythontools.matlab2py({inObject.(char(k))});
    end
elseif iscell(inObject) || (isnumeric(inObject) && numel(inObject)>1)
    if ndims(inObject) >= 2 || size(inObject, 2) > 1
        % Convert to numpy array
        % Reshape to 1-N
        outObject = reshape(inObject, 1, numel(inObject));
        % Transform to numpy array
        outObject = py.numpy.array(outObject);
        % Reshape into original size
        originalSize = py.list(uint64(size(inObject)));
        outObject = outObject.reshape(originalSize);
    else
        % Convert to list
        outObject = py.list(inObject);
    end
elseif ischar(inObject) || (isstring(inObject) && numel(inObject)==1)
    % Convert to string
    outObject = py.str(inObject);
elseif isstring(inObject) && numel(inObject)>1
    % Iterate and convert to string
    outObject = py.list();
    for value = inObject
        outObject.append(pythontools.matlab2py(value));
    end
elseif isinteger(inObject) && numel(inObject)==1
    % Convert to int
    outObject = py.int(inObject);
elseif isfloat(inObject) && numel(inObject)==1
    outObject = py.float(inObject);
else
    % Not necessary to convert or not yet supported
    outObject = inObject;
end


