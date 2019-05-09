# MATLAB functions to run Python code

#### Configuration
In order to use MATLAB functions, please add the folder `matlab_python_tools`
to the MATLAB path using the `pathtool` function in the console.

```matlab
pathtool
```

This will open a new window. Click on "Add folder...", browse and select
the folder `matlab_python_tools`.

#### Select Python interpreter
The function `pythontools.env.activate` can be used to select the Python interpreter.
```matlab
pythontools.env.activate('environments_folder', 'pylidarcheck')
```

Then you can call any Python function through the `py` variable.

#### Examples

To create a Python list can use the following code:
```matlab
>> myList = py.list([1,2,3,4]);

myList =

  Python list with no properties.

    [1.0, 2.0, 3.0, 4.0]

```

You can also call functions from other modules. For example:
```matlab
>> myPath = 'path_to__a_file/filename.txt'

myPath =

    'path_to__a_file/filename.txt'

>> py.os.path.basename(myPath)

  Python str with no properties.

    filename.txt

```
