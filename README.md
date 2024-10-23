This study introduces a new approach to ECG signal analysis, utilizing classical signal processing techniques without machine learning models.
The method uses time-domain features like R-R intervals and heart rate, along with frequency-domain features like spectral entropy, to detect various cardiac conditions. 
The research uses data from the MIT-BIH Arrhythmia Database. The method successfully identifies significant cardiac patterns, 
offering practical implications for automated ECG interpretation and telemedicine applications. 
The study suggests further improvements in classification accuracy by exploring larger datasets and additional features, 
contributing to the ongoing evolution of ECG analysis methodologies.

Dataset
For research purposes, the ECG signals were obtained from the PhysioNet service (http://www.physionet.org) from the MIT-BIH Arrhythmia database. The created database with ECG signals is described below. 1) The ECG signals were from 45 patients: 19 female (age: 23-89) and 26 male (age: 32-89). 2) The ECG signals contained 17 classes: normal sinus rhythm, pacemaker rhythm, and 15 types of cardiac dysfunctions (for each of which at least 10 signal fragments were collected). 3) All ECG signals were recorded at a sampling frequency of 360 [Hz] and a gain of 200 [adu / mV]. 4) For the analysis, 1000, 10-second (3600 samples) fragments of the ECG signal (not overlapping) were randomly selected. 5) Only signals derived from one lead, the MLII, were used. 6) Data are in mat format (Matlab).
