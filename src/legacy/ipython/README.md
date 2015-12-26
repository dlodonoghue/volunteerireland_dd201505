### Setup a virtual environment for Python libraries
    
Using Anaconda distro, 

1. create a new virtual environment, installing packages from requirements file
    
        conda create -n volunteerireland_dd201505 --file requirements_conda
        source activate volunteerireland_dd201505

2. OPTIONAL install packages only available on binstar 
    

        (manual commands are shown in file requirements_binstar)

3. OPTIONAL install remaining packages pip:


        pip install -r requirements_pip
    
