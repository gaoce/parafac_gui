PARAFAC Toolbox
===============
A GUI to conduct PARAFAC for spectroscopy data.

0. This app requires MATLAB version 2012b or later. Tested on Windows 7 and Mac
   OS X. Unit test requires 2013a or later.

1. The following packages or toolboxes are used
  * [DOMFLuor](http://www.models.life.ku.dk/al_domfluor)
  * [PlotPub](http://www.mathworks.com/matlabcentral/fileexchange/47921-plotpub-publication-quality-graphs-in-matlab)
  * [FastPeakFind](http://www.mathworks.com/matlabcentral/fileexchange/37388-fast-2d-peak-finder)

2. For end user
  * Double click `PARAFAC.mlappinstall` to install

3. For developer
  0. Run `setup` before anything
  1. To start from new: click `Package App` under `APPS` tab; or just double
     click `PARAFAC.prj`
  2. In the upper left corner, add `main.m` as main file
  3. Click `Refresh` in `Files included through analysis` section
  4. In `Shared resources and helper files` section, add the following files
    * .mat files in nway toolbox inside `lib/DOMFLour`
  5. Fill out the other information, and click `Package`. The app should be in
     `dist` folder.
  6. Run `test` for unit testing.

4. Also for developers
  * It is **really** easy to get confused with Em and Ex, so I follow the rule that
    Em always comes first when they are together. For example, the signature of the
    function: `EEMData = buildTensor(fileNames, pathName, numEm, numEx)`

5. Screenshot
![screenshot](/screenshot.png)

6. Known bugs
  1. Currently there should be only 1 instance of this app running
