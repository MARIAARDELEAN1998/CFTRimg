# CFTRimg

These scripts are designed for processing and analysis of fluorescence
images of live HEK293 cells, heterologously expressing soluble mCherry and
YFP(H148Q/I152L)-CFTR channels.


Here we provide information on how to use the MATLAB code for the image analysis
described in *“High-content assay for precision medicine discovery in cystic
fibrosis”* (Prins et al., 2019). The instructions will allow you to download a
set of images, get a copy of the script and run the analysis to obtain
information on CFTR membrane density, and CFTR ion channel function.

## Getting started

#### Install MATLAB
Install MATLAB R2017b (<https://uk.mathworks.com/products/matlab.html>)

the Image Processing Toolbox https://www.mathworks.com/products/image.html

the Optimization Toolbox https://uk.mathworks.com/products/optimization.html

#### Download the scripts and data
Go to <https://github.com/stellaprins/CFTRimg>, and download the ZIP
folder called *CFTRimg-master*. Unpack the folder, place it on
the Desktop and rename it *CFTRimg*.

The folder should contain three folders: *CFTRimg*, *Data* and *Input Files*
-   The *CFTRimg* folder contains the scripts and functions that are used to
    analyse the data
-   The *Data* folder contains sets of example images, suitable for the localisation 
		analysis (*local* folder), the I<sup>-</sup> first quenching analysis (*quench_Ifirst*
		folder) and the I<sup>-</sup> last quenching analysis (*quench_Ilast* folder)
-   The *Input Files* folder contains the scripts that provide image specifications 


#### Before starting the image analysis
-   Open MATLAB and add the *CFTRimg* folder and its subfolders to the 
		MATLAB path.

## CFTR membrane density
You can find the example data in *CFTRimg\>Data\>example_data_local*.
*The CFTRimg_Local.m* script will use the functions in *CFTRimg\>CFTRimg\>functions Local*
to segment and analyse images as described in Prins et al., (2019). In short, 
images of cytosolic mCherry are used for identification of single cells using 
thresholding and a watershed-based segmentation. After background correction,
the YFP and mCherry fluorescence intensity of each cell is normalized to the
median YFP and mCherry fluorescence intensities in WT-CFTR expressing cells. A
band within the border of each cell is defined as the membrane zone, and CFTR
membrane density is estimated by dividing the average normalized YFP
fluorescence intensity within the membrane zone by the average normalized
mCherry fluorescence over the entire cell.

The *example_input_local.m* file (in *Input Files*), is customized by the
experimenter and contains image specifications necessary for the analysis 
(for example pixel binning, number of images taken per well, microscope 
objective and normalisation conditions). Furthermore, it allows the 
filenames of the images to be matched to the experimental conditions used.


### The localisation analysis:
-   Open *CFTRimg_Local.m* located in the *CFTRimg* folder and run the script
    (choose *Add to path* if you have not already added this folder to the path).
-   A window will pop up asking you whether you want to save cropped images of
    segmented cells after the image analysis. Choose either Yes or No.
-   Folders to save the results in will be created in the main folder. The 
		workspace and excel files with the results will be saved in 
		*CFTRimg\>Results\>ResultsLocal.* 

### Results
The analysis results can be found on the Desktop in *CFTRimg\>Results\>ResultsLocal*

#### The workspace
The workspace resulting from running *CFTRimg_Local.m* contains the structures
*plate* and *resultsLocal*, containing the analysis results. The structure called 
*plate* contains the results per plate, per image. To access the fields with 
information about plate *n*, type **plate(n)** in the command window.

**>> plate(1)**

	>   plateStr: 'Plate_15771'
	>   experimentStr: 'Experiment 1'
	>   normConditionStr: 'WT 28°C'
	>   image: [48×1 struct]

**Plate(n)** contains a structure called *image* that can be accessed to view
the fields with information about each image. To access the information
about image *m* on plate *n*, type **plate(n).image(m)** in the command window.

**>> plate(1).image(1)**

	>   conditionStr: 'WT 28°C'
	>   redPath: 'C:\Users\USERNAME\Desktop\CFTRimg\Data\example_data_local\TimePoint_1\local_C02_s1_w2.TIF'
	>   yelPath: 'C:\Users\ USERNAME \Desktop\CFTRimg\Data\example_data_local\TimePoint_1\local_C02_s1_w1.TIF'
	>   binning: 0.5000
	>   boundingBox: [36×4 double]
	>   cellLocation: {36×4 cell}
	>   redEntire: [36×1 double]
	>   redOutside: [36×1 double]
	>   yelEntire: [36×1 double]
	>   yelOutside: [36×1 double]
	>   yelMembrane: [36×1 double]
	>   yelMembraneAbsolute: [36×1 double]
	>   yelEntireAbsolute: [36×1 double]
	>   redEntireAbsolute: [36×1 double]
	>   redBackground: 0.0147
	>   yelBackground: 0.0187
	>   cellN: [37 36]
	>   yelMembraneNeg: 1
	>   yelEntireNeg: 1
	>   redEntireNeg: 0
	>   deleteNeg: 1
	>   objective: 60

To access the fields with information about condition number *n*, type
**resultsLocal(n)** in the command window.

**>> resultsLocal(1)**

	>   condition: 'F508del + 10 µM VX-809 28°C'
	>   normCondition: 'WT 28°C'
	>   cellLocation: {528×4 cell}
	>   yelMembrane: [528×1 double]
	>   yelEntire: [528×1 double]
	>   redEntire: [528×1 double]
	>   yelMembraneNorm: [528×1 double]
	>   yelEntireNorm: [528×1 double]
	>   redEntireNorm: [528×1 double]
	>   yelMembraneAbsolute: [528×1 double]
	>   yelEntireAbsolute: [528×1 double]
	>   redEntireAbsolute: [528×1 double]
	>   memDens: [528×1 double]
	>   logMemDens: [528×1 double]
	>   localCellN: 528
	>   yelMembraneNeg: 8
	>   yelEntireNeg: 8
	>   redEntireNeg: 0
	>   deleteNeg: 8

#### Generated excel files

In addition to saving the workspace, running *CFTRimg_Local.m* results in
the generation of three excel files that are saved in *Results\>ResultsLocal*.
The tables with field/header descriptions below, can be used to describe the 
headers in the excel files.

- *fullLocalResult_yyyy_mm_dd_HHMM.xlsx*
For each cell the rows in the excel sheet contain the following information:
**experimentStr**, **plateIdx**, **condition**, **normCondition**,
**yelMembrane**, **yelEntire**, **redEntire**, **yelMembraneNorm**,
**yelEntireNorm**, **redEntireNorm**, **memDens** and **logMemDens**

- *LocalTable_yyyy_mm_dd_HHMM.xlsx*
Per plate, per condition, this excel sheet lists: **experimentStr**,
**condition, meanLogMemDens**, **meanRedEntireNorm** and 
**meanRedEntire**

- *LocalSummary_yyyy_mm_dd_HHMM.xlsx*
The mean log<sub>10</sub>&rho; on each plate is determined per condition and 
forms the subsample mean. For every condition, this excel sheet lists:
**condition**, **N**, **mean meanLogMemDens**, **lower CI**, **upper CI**, 
**cellN**, **deleteNeg**, **redEntireNeg**, **yelEntireNeg** and **yelMembraneNeg**

#### Cell images 
If you have chosen to save cropped images of segmented cells after the 
image analysis, images will appear in *Results\>ResultsLocal\>CellImages.* 
The white lines in the images denote the cell segmentation boundary and the 
&rho; is stamped on each image. Descriptions of the fields in structures 
of the workspace and in the headers of the excel files are listed in the
table below.

#### field / header descriptions in workspace and excel files

| field / header     	  | Description                                                                                                                                                                                 |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **plateStr**            | Plate label as specified in the *example_input_local.m* file                                                                                                                                |
| **experimentStr**       | Experiment label as specified in the *example_input_local.m* file                                                                                                                           |
| **condition**           | Label of the experimental conditions as specified in the *example_input_local.m* file                                                                                                       |
| **normCondition**       | Label of the condition used for normalisation (in this case “WT 28°C”), as specified in the *example_input_local.m* file                                                                    |
| **redPath**             | Filepaths for mCherry images                                                                                                                                                                     |
| **yelPath**             | Filepaths for YFP images                                                                                                                                                                          |
| **binning**             | With n×n pixel binning, this field is set to 1/n (in the *example_input_local.m* file 2×2 binning is used so this field is set to 1/2)                                                      |
| **objective**           | *60* for 60× objective power                                                                                                                                                                      |
| **redEntire**           | The average background corrected mCherry fluorescence intensity inside the cell selection                                                                                                   |
| **redOutside**          | The average background corrected mCherry fluorescence intensity outside the cell selection and within the boundingBox                                                                               |
| **yelEntire**           | The average background corrected YFP fluorescence intensity inside the cell selection                                                                                                       |
| **yelOutside**          | The average background corrected YFP fluorescence intensity outside the cell selection and within the boundingBox                                                                                   |
| **yelMembrane**         | The average background corrected YFP fluorescence intensity in the membrane zone                                                                                                            |
| **yelMembraneAbsolute** | The average YFP fluorescence intensity in the membrane zone                                                                                                                                 |
| **yelEntireAbsolute**   | The average YFP fluorescence intensity inside the cell selection                                                                                                                            |
| **redEntireAbsolute**   | The average mCherry fluorescence intensity inside the cell selection                                                                                                                        |
| **redBackground**       | The average mCherry background fluorescence intensity                                                                                                                                       |
| **yelBackground**       | The average YFP background fluorescence intensity                                                                                                                                           |
| **cellN**               | Group size of segmented cells ([before selection] [after selection])                                                                                                                        |
| **yelMembraneNeg**      | Number of cells with a negative average YFP fluorescence intensity in the membrane zone after background correction                                                                         |
| **yelEntireNeg**        | Number of cells with a negative average YFP fluorescence intensity inside the cell selection after background correction                                                                              |
| **redEntireNeg**        | Number of cells with a negative average mCherry fluorescence intensity inside the cell selection after background correction                                                                          |
| **deleteNeg**           | Number of cells deleted because of negative average YFP and / or mCherry fluorescence intensity after correction for background                                                             |
| **boundingBox**         | Pixel indices of boxes around selected cells                                                                                                                                              |
| **cellLocation**        | Column 1: plateStr<br>Column 2: plate number (n) <br>Column 3: image number (m) <br>Column 4: cell number                                                                                   |
| **yelMembraneNorm**     | The average background corrected YFP fluorescence intensity in the membrane zone, normalized to the median YFP fluorescence intensities in WT-CFTR expressing cells on the same plate       |
| **yelEntireNorm**       | The average background corrected YFP fluorescence intensity in the entire cell, normalized to the median YFP fluorescence intensities in WT-CFTR expressing cells on the same plate         |
| **redEntireNorm**       | The average background corrected mCherry fluorescence intensity in the entire cell, normalized to the median mCherry fluorescence intensities in WT-CFTR expressing cells on the same plate |
| **memDens**             | CFTR membrane density (&rho;) defined by **yelMembraneNorm**/**redEntireNorm**                                                                                                              |
| **logMemDens**          | The common logarithm of CFTR membrane density (log<sub>10</sub>&rho;) defined by log<sub>10</sub>(**memDens**)                                                                                                    |

<br>
<br>

|  header     	          | Description                                                                                                                                                                                 |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **plateIdx**            | plate number (n)                                                                                                                                                                            |
| **meanLogMemDens**      | mean **logMemDens**                                                                                                                                                                         |
| **meanRedEntireNorm**   | mean **redEntireNorm**                                                                                                                                                                      |
| **meanRedEntire**       | mean **redEntire**                                                                                                                                                                          |
| **N**                   | number of subsample log<sub>10</sub>&rho; means                                                                                                                                                        |
| **mean meanLogMemDens** | Mean of the subsample log<sub>10</sub>&rho; means                                                                                                                                                      |
| **lower CI**            | lower limit of the 95% confidence interval of log<sub>10</sub>&rho; (can only be calculated if N\>1)                                                                                                   |
| **upper CI**            | upper limit of the 95% confidence interval of log<sub>10</sub>&rho; (can only be calculated if N\>1)                                                                                                   |

## CFTR Function
For assessment of CFTR function, two different protocols were used; the 
I<sup>-</sup> first protocol (Langron et al., 2017) and the I<sup>-</sup> 
last protocol (Langron et al., 2018). You can find example data collected 
with the I<sup>-</sup> first protocol in *CFTRimg\>Data\>quench_Ifirst* 
and example data collected with the I<sup>-</sup> last protocol
in *CFTRimg\>Data\>quench_Ilast.*

For both protocols, cells were selected based on the mCherry fluorescence 
by means of thresholding. The YFP fluorescence in the cell selection is 
corrected for background and the average YFP fluorescence intensity is 
normalised to the time point before I<sup>-</sup> addition. For the images 
collected with the I<sup>-</sup> first protocol, the maximal influx of 
I<sup>-</sup> after the addition of Forskolin (test) or DMSO (control) is
determined together with the time point at which I<sup>-</sup> influx is 
highest. For the I<sup>-</sup> last protocol, quenching traces are fit
to a mathematical model (as described in Langron et al., 2018), to estimate
CFTR conductance (GCFTR).

As for the localisation analysis, the input files 
*example_input_quench_Ifirst.m* and *example_input_quench_Ilast.m*, are
customized by the experimenter and provide specifications necessary for 
image analysis (for example sampling frequency, timepoints of fluid addition
and normalisation conditions). These input files also allow the filenames 
of the images to be matched to the experimental conditions used.


### The I<sup>-</sup> first quenching analysis:
-   Open *CFTRimg_Quench_Ifirst.m* in *CFTRimg* and run the script
-   The resulting workspace (*quench_Ifirst_yyyy_mm_dd_HHMM.mat*) and an excel
    file with the results (*fullQuenchTimeline_yyyy_mm_dd_HHMM.xlsx)* will be
    saved in *Results\>ResultsQuench\>Ifirst.*

### The I<sup>-</sup> last quenching analysis:
-   Open *CFTRimg_Quench_Ilast.m* in *CFTRimg* and run the script
-   The resulting workspace (*quench_Ilast_yyyy_mm_dd_HHMM.mat*) and excel
    files with the results (*fullQuenchTimeline_yyyy_mm_dd_HHMM.xlsx* and
    *fullQuenchFitting_yyyy_mm_dd_HHMM.xlsx*) will be saved in
    *Results\>ResultsQuench\>Ilast.*


### Results
The analysis results can be found on the Desktop 
in *CFTRimg\>Results\>ResultsQuench*

#### The workspace

Both types of quenching analysis, the I<sup>-</sup> first as well as the 
I<sup>-</sup> last image analysis, result in a workspace that contains the 
structure called *plate*.

The structure *plate* contains the analysis results per plate, per well. 
To access the fields with information about plate *n*, type **plate(n)** 
in the command window.


**>> plate(1)**

	>   plateStr: '04-12-17 Plate_15771'
	>   experimentStr: '04-12-17'
	>   normCondition: 'WT + VX-770 28°C'
	>   well: [23×1 struct]

To access the fields with information about well *m* on plate *n*, type
**plate(n).well(m)** in the command window.

**>> plate(1).well(1)** 

	>   condition: 'WT + VX-770 28°C'
	>   test_control: 'test'
	>   redPath: {1×2 cell}
	>   yelPath: {1×70 cell}
	>   timeline: [5 26 70]
	>   timeStep: 2
	>   yelInsideOverT: [70×1 double]
	>   redInsideNorm: 0.8079
	>   redInside: 0.0381
	>   redMaskChange: 0.2063
	>   maxGrad: 0.1332
	>   maxGradLoc: 38

#### Generated excel files
Running the quenching analysis generates and saves an excel files in
*CFTRimg\>Results\>ResultsQuench\>Ifirst* for the I<sup>-</sup> first 
quenching analysis, and two excel files in *Results\>ResultsQuench\>Ilast* 
for the I<sup>-</sup> last quenching analysis.

- *fullQuenchTimeline_yyyy_mm_dd_HHMM.xlsx*
This sheet contains the normalised fluorescence intensity over time
(**TimePoint_1**, **TimePoint_2**, **TimePoint_3**, … **TimePoint_70**) 
for each well. For each well it also contains the **experimentStr**, 
**plateStr**, **condition**, **test_control**, **redInside**, **redInsideNorm**.

- *fullQuenchFitting_yyyy_mm_dd_HHMM.xlsx*
This file is only saved for the I<sup>-</sup> last quenching analysis. The
file contains the fitting results (**TimePoint_1**, **TimePoint_2**,
**TimePoint_3**, … **TimePoint_70**) for each well. For each well it also
contains the **experimentStr**, **plateStr**, **condition**,
**test_control**, **redInside**, **redInsideNorm**.

#### field / header descriptions in workspace and excel files

| Field                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                              |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **plateStr**                                                               | Experiment label as specified in the *example_input_local.m* file                                                                                                                                                                                                                                                                                                                                        |
| **experimentStr**                                                          | Label of the experimental conditions as specified in the *example_input_local.m* file                                                                                                                                                                                                                                                                                                                    |
| **normCondition**                                                          | Label of the condition used for normalisation as specified in the *example_input_local.m* file                                                                                                                                                                                                                                                                                                           |
| **test_control**                                                           | Addition of forskolin (test conditions) or DMSO (control conditions)                                                                                                                                                                                                                                                                                                                                     |
| **timeline**                                                               | [6 26 70] [timepoint after first fluid addition; timepoint after second fluid addition; last timepoint]                                                                                                                                                                                                                                                                                                  |
| **timeStep**                                                               | Time interval (in seconds) between successive images (2 seconds in this study)                                                                                                                                                                                                                                                                                                                           |
| **yelInsideOverT**                                                         | Normalised fluorescence intensity over time                                                                                                                                                                                                                                                                                                                                                              |
| **redInside**                                                              | The average background corrected mCherry fluorescence intensity inside the cell selection                                                                                                                                                                                                                                                                                                                |
| **redMaskChange**                                                          | The proportion of area in the cell selection that has no overlap between the first and last mCherry image.                                                                                                                                                                                                                                                                                               |
| **maxGrad**                                                                | The maximal I<sup>-</sup> influx rate after after the addition of forskolin or DMSO.                                                                                                                                                                                                                                                                                                                     |
| **maxGradLoc**                                                             | The timepoint at which the I<sup>-</sup> influx rate is maximal                                                                                                                                                                                                                                                                                                                                          |

<br>
<br>

| Header                                                                     | Description                                                                                                                                                                                                                                                                                                                                                                                              |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **label**                                                                  | condition_FSK/DMSO_Platestr                                                                                                                                                                                                                                                                                                                                                                              |
| **FSK/DMSO**                                                               | Specifies whether there was addition of forskolin (FSK, test conditions) or DMSO (control conditions)                                                                                                                                                                                                                                                                                                    |
| **y_0<br>y_3<br>y_5<br>...<br>y_39**																			 | y_0: normalised fluorescence intensity 0 seconds after the addition of I<sup>-</sup><br>y_3: normalised fluorescence intensity 3 seconds after the addition of I<sup>-</sup><br>y_5: normalised fluorescence intensity 5 seconds after the addition of I<sup>-</sup><br>y_5: normalised fluorescence intensity 5 seconds after the addition of I<sup>-</sup><br>...<br>y_39: normalised fluorescence intensity 39 seconds after the addition of I<sup>-</sup> |
| **error ratio (free/fixed)**                                               | **Error_free** / **Error_fixed**                                                                                                                                                                                                                                                                                                                                                                         |
| **G_free**                                                                 | Estimated steady-state CFTR conductance (model with four free parameters)                                                                                                                                                                                                                                                                                                                                |
| **G_free_norm**                                                            | **G_free** / **redInsideNorm**                                                                                                                                                                                                                                                                                                                                                                           |
| **Vm_free**                                                                | Estimated membrane potential at time of I<sup>-</sup> addition (model with four free parameters)                                                                                                                                                                                                                                                                                                         |
| **G_trans_free**                                                           | Estimated transient endogenous anion conductance (model with four free parameters)                                                                                                                                                                                                                                                                                                                       |
| **TAU_trans_free**                                                         | Estimated exponential decay time constant for transient endogenous anion conductance (model with four free parameters)                                                                                                                                                                                                                                                                                   |
| **Error_free**                                                             | The sum of squared residuals between the measured and predicted normalised fluorescence (model with four free parameters)                                                                                                                                                                                                                                                                                |
| **<br>pred_y_free_0<br>pred_y_free_3<br>pred_y_free_5<br>...<br>pred_y_free_39** | Using the model with four free parameters:<br> y_0: predicted normalised fluorescence intensity 0 seconds after the addition of I<sup>-</sup><br>y_3: predicted normalised fluorescence intensity 3 seconds after the addition of I<sup>-</sup><br>y_5: predicted normalised fluorescence intensity 5 seconds after the addition of I<sup>-</sup><br>...<br>y_39: predicted normalised fluorescence intensity 39 seconds after the addition of I<sup>-</sup> |
| **G_fixed**                                                                | Estimated steady-state CFTR conductance (model with two free parameters)                                                                                                                                                                                                                                                                                                                                 |
| **G_fixed_norm**                                                           | **G_fixed** / **redInsideNorm**                                                                                                                                                                                                                                                                                                                                                                          |
| **Vm_fixed**                                                               | Estimated membrane potential at time of I<sup>-</sup> addition (model with two free parameters)                                                                                                                                                                                                                                                                                                          |
| **G_trans_fixed**                                                          | Transient endogenous anion conductance fixed to average value measured for DMSO controls                                                                                                                                                                                                                                                                                                                 |
| **TAU_trans_fixed**                                                        | Exponential decay time constant for transient endogenous anion conductance fixed to average value measured for DMSO controls                                                                                                                                                                                                                                                                             |
| **Error_fixed**                                                            | The sum of squared residuals between the measured and predicted normalised fluorescence (model with two free parameters)                                                                                                                                                                                                                                                                                 |
| **<br>pred_y_fixed_0<br>pred_y_fixed_3<br>pred_y_fixed_5<br>...<br>pred_y_fixed_39** | Using the model with two free parameters: <br>y_0: predicted normalised fluorescence intensity 0 seconds after the addition of I<sup>-</sup><br>y_3: predicted normalised fluorescence intensity 3 seconds after the addition of I<sup>-</sup><br>y_5: predicted normalised fluorescence intensity 5 seconds after the addition of I<sup>-</sup><br>...<br>y_39: predicted normalised fluorescence intensity 39 seconds after the addition of I<sup>-</sup>  |


## References

Prins, S., Langron, E., Hastings, C., Hill, E., Stefan, A.C., Griffin, L.D.,
Vergani, P., (2019). High-content assay for precision medicine discovery in
cystic fibrosis. bioRxiv 631614; doi: https://doi.org/10.1101/631614

Langron, E, Simone, MI, Delalande, CMS, Reymond, JL, Selwood, DL, Vergani,
P (2017). Improved fluorescence assays to measure the defects associated with
F508del-CFTR allow identification of new active compounds. *Br J
Pharmacol* 174: 525– 539.

Langron E, Prins S, Vergani P (2018). Potentiation of the cystic fibrosis
transmembrane conductance regulator by VX-770 involves stabilization of the
pre-hydrolytic O1 state. *Br J Pharmacol* 175: 3990–4002
