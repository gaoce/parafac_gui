PARAFAC Toolbox
===============
A GUI to conduct PARAFAC for spectroscopy data.

0. This app requires MATLAB version 2012b or later.

1. The following packages or toolboxes are used
  * [DOMFLuor](http://www.models.life.ku.dk/al_domfluor)
  * [export_fig](http://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig)
  * [FastPeakFind](http://www.mathworks.com/matlabcentral/fileexchange/37388-fast-2d-peak-finder)
  * [RotateXLabels](http://www.mathworks.com/matlabcentral/fileexchange/45172-rotatexlabels)

2. For end user
  * Double click `dist/PARAFAC.mlappinstall` to install
  * The plotting functionality requires [ghostscript](http://www.ghostscript.com/), download and install from there

3. For developer
  0. Run `configPath.m` before anything
  1. To start from new: click `Package App` under `APPS` tab; or just double
     click `PARAFAC.prj`
  2. In the upper left corner, add `main.m` as main file
  3. Click `Refresh` in `Files included through analysis` section
  4. In `Shared resources and helper files` section, add the following files
    * .mat files in nway toolbox inside `lib/DOMFLour`
    * .ignore folder and files inside in `lib/export_fig`
  5. Fill out the other information, and click `Package`

4. Also for developers
  * It is **really** easy to get confused with Em and Ex, so I follow the rule that
    Em always comes first when they are together. For example, the signature of the
    function: `EEMData = buildTensor(fileNames, pathName, numEm, numEx)`

5. Screenshot
![screenshot](/screenshot.png)
