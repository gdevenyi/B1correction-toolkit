The directory test_data corresponds to the data used for the peer-reviewed publication:

Ramos Delgado P, Kuehne A, Periquito J, et al. B1 Inhomogeneity Correction of RARE MRI with Transceive Surface Radiofrequency Probes. Magnetic Resonance in Medicine 2020; 00:1-20. https://doi.org/10.1002/mrm.28333



FOLDER cryoprobe_data:

	* uniformData_cryo.mat: contains the registered T1 map, the 	cryoprobe data and the volume RF coil data of the uniform phantom 
	* exVivoData_cryo.mat: contains the registered T1 map, the 	cryoprobe data and the volume RF coil data of the ex vivo phantom 
	* inVivoData_cryo.mat: contains the registered T1 map, the 		cryoprobe data and the volume RF coil data of the in vivo mouse 
	* b1maps_cryo.mat: B1 maps of a uniform phantom

FOLDER cryoprobe_dataAUX:

	* phantom_sensCorrection_cryo.mat: contains the registered uniform 	phantom cryoprobe data for sensitivity-based B1 correction 
	* B1_rx_hybrid_cryo.mat: contains the B1+-corrected uniform phantom 	cryoprobe data for hybrid B1 correction 

FOLDER rtSUC_data (room-temperature surface RF coil):

	* flask_n1_flipbackData_rtSUC.mat: contains the registered T1 map, 	the surface RF coil data and the volume RF coil data (RARE with 	flipback) of the flask with low T1 and 100% water (n1)
	* flask_n2_flipbackData_rtSUC.mat: contains the registered T1 map, 	the surface RF coil data and the volume RF coil data (RARE with 	flipback) of the flask with low T1 and 50% water/50% d2O (n2)
	* flask_n3_flipbackData_rtSUC.mat: contains the registered T1 map, 	the surface RF coil data and the volume RF coil data (RARE with 	flipback) of the flask with high T1 and 100% water (n3)
	* flask_n4_flipbackData_rtSUC.mat: contains the registered T1 map, 	the surface RF coil data and the volume RF coil data (RARE with 	flipback) of the flask with high T1 and 50% water/50% d2O (n4)
	* flask_n1_NOflipbackData_rtSUC.mat: contains the registered T1 	map, the surface RF coil data and the volume RF coil data (RARE 	without flipback) of the flask with low T1 and 100% water (n1)
	* flask_n2_NOflipbackData_rtSUC.mat: contains the registered T1 	map, the surface RF coil data and the volume RF coil data (RARE 	without flipback) of the flask with low T1 and 50% water/50% d2O 	(n2)
	* flask_n3_NOflipbackData_rtSUC.mat: contains the registered T1 	map, the surface RF coil data and the volume RF coil data (RARE 	without flipback) of the flask with high T1 and 100% water (n3)
	* flask_n4_NOflipbackData_rtSUC.mat: contains the registered T1 	map, the surface RF coil data and the volume RF coil data (RARE 	without flipback) of the flask with high T1 and 50% water/50% d2O 	(n4)
	* b1map_rtSUC.mat: B1 map of a uniform phantom
FOLDER rtSUC_dataAUX (room-temperature surface RF coil):

	* phantom_sensCorrection_rtSUC.mat: contains the registered uniform 	phantom room-temperature surface RF coil data for sensitivity-based 	B1 correction 
	* B1_rx_hybrid_rtSUC.mat: contains the B1+-corrected uniform 	phantom room-temperature surface RF coil data for hybrid B1 	correction 

FOLDER RAREmodel_data:

	* RAREraw_flipback_modelData.mat: contains the RARE data (mean SI 	data, T1 relaxation times and the FA values associated with 	different reference powers) acquired with a volume RF coil using 	RARE with flipback 
	* RAREraw_NOflipback_modelData.mat: contains the RARE data (mean SI 	data, T1 relaxation times and the FA values associated with 	different reference powers) acquired with a volume RF coil using 	RARE without flipback

