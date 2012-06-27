%******************************************************************************
%*** NI-DAQmx Attributes ******************************************************
%******************************************************************************
% copyright National Instruments
% adapted for use in matlab, by Jens Roesner, jan/25/2005
flag_NIconstants_defined = true;

%********** Calibration Info Attributes **********
DAQmx_SelfCal_Supported = hex2dec('1860'); % Indicates whether the device supports self calibration.
DAQmx_SelfCal_LastTemp = hex2dec('1864'); % Indicates in degrees Celsius the temperature of the device at the time of the last self calibration. Compare this temperature to the current onboard temperature to determine if you should perform another calibration.
DAQmx_ExtCal_RecommendedInterval = hex2dec('1868'); % Indicates in months the National Instruments recommended interval between each external calibration of the device.
DAQmx_ExtCal_LastTemp = hex2dec('1867'); % Indicates in degrees Celsius the temperature of the device at the time of the last external calibration. Compare this temperature to the current onboard temperature to determine if you should perform another calibration.
DAQmx_Cal_UserDefinedInfo = hex2dec('1861'); % Specifies a string that contains arbitrary, user-defined information. This number of characters in this string can be no more than Max Size.
DAQmx_Cal_UserDefinedInfo_MaxSize = hex2dec('191C'); % Indicates the maximum length in characters of Information.
DAQmx_Cal_DevTemp = hex2dec('223B'); % Indicates in degrees Celsius the current temperature of the device.

%********** Channel Attributes **********
DAQmx_ChanType = hex2dec('187F'); % Indicates the type of the virtual channel.
DAQmx_PhysicalChanName = hex2dec('18F5'); % Indicates the name of the physical channel upon which this virtual channel is based.
DAQmx_ChanDescr = hex2dec('1926'); % Specifies a user-defined description for the channel.
DAQmx_AI_Max = hex2dec('17DD'); % Specifies the maximum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced maximum value that the device can measure with the current settings.
DAQmx_AI_Min = hex2dec('17DE'); % Specifies the minimum value you expect to measure. This value is in the units you specify with a units property.When you query this property, it returns the coerced minimum value that the device can measure with the current settings.
DAQmx_AI_CustomScaleName = hex2dec('17E0'); % Specifies the name of a custom scale for the channel.
DAQmx_AI_MeasType = hex2dec('0695'); % Indicates the measurement to take with the analog input channel and in some cases, such as for temperature measurements, the sensor to use.
DAQmx_AI_Voltage_Units = hex2dec('1094'); % Specifies the units to use to return voltage measurements from the channel.
DAQmx_AI_Temp_Units = hex2dec('1033'); % Specifies the units to use to return temperature measurements from the channel.
DAQmx_AI_Thrmcpl_Type = hex2dec('1050'); % Specifies the type of thermocouple connected to the channel. Thermocouple types differ in composition and measurement range.
DAQmx_AI_Thrmcpl_CJCSrc = hex2dec('1035'); % Indicates the source of cold-junction compensation.
DAQmx_AI_Thrmcpl_CJCVal = hex2dec('1036'); % Specifies the temperature of the cold junction if CJC Source is DAQmx_Val_ConstVal. Specify this value in the units of the measurement.
DAQmx_AI_Thrmcpl_CJCChan = hex2dec('1034'); % Indicates the channel that acquires the temperature of the cold junction if CJC Source is DAQmx_Val_Chan. If the channel is a temperature channel, NI-DAQmx acquires the temperature in the correct units. Other channel types, such as a resistance channel with a custom sensor, must use a custom scale to scale values to degrees Celsius.
DAQmx_AI_RTD_Type = hex2dec('1032'); % Specifies the type of RTD connected to the channel.
DAQmx_AI_RTD_R0 = hex2dec('1030'); % Specifies in ohms the sensor resistance at 0 deg C. The Callendar-Van Dusen equation requires this value. Refer to the sensor documentation to determine this value.
DAQmx_AI_RTD_A = hex2dec('1010'); % Specifies the 'A' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
DAQmx_AI_RTD_B = hex2dec('1011'); % Specifies the 'B' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
DAQmx_AI_RTD_C = hex2dec('1013'); % Specifies the 'C' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
DAQmx_AI_Thrmstr_A = hex2dec('18C9'); % Specifies the 'A' constant of the Steinhart-Hart thermistor equation.
DAQmx_AI_Thrmstr_B = hex2dec('18CB'); % Specifies the 'B' constant of the Steinhart-Hart thermistor equation.
DAQmx_AI_Thrmstr_C = hex2dec('18CA'); % Specifies the 'C' constant of the Steinhart-Hart thermistor equation.
DAQmx_AI_Thrmstr_R1 = hex2dec('1061'); % Specifies in ohms the value of the reference resistor if you use voltage excitation. NI-DAQmx ignores this value for current excitation.
DAQmx_AI_ForceReadFromChan = hex2dec('18F8'); % Specifies whether to read from the channel if it is a cold-junction compensation channel. By default, an NI-DAQmx Read function does not return data from cold-junction compensation channels.Setting this property to TRUE forces read operations to return the cold-junction compensation channel data with the other channels in the task.
DAQmx_AI_Current_Units = hex2dec('0701'); % Specifies the units to use to return current measurements from the channel.
DAQmx_AI_Strain_Units = hex2dec('0981'); % Specifies the units to use to return strain measurements from the channel.
DAQmx_AI_StrainGage_GageFactor = hex2dec('0994'); % Specifies the sensitivity of the strain gage.Gage factor relates the change in electrical resistance to the change in strain. Refer to the sensor documentation for this value.
DAQmx_AI_StrainGage_PoissonRatio = hex2dec('0998'); % Specifies the ratio of lateral strain to axial strain in the material you are measuring.
DAQmx_AI_StrainGage_Cfg = hex2dec('0982'); % Specifies the bridge configuration of the strain gages.
DAQmx_AI_Resistance_Units = hex2dec('0955'); % Specifies the units to use to return resistance measurements.
DAQmx_AI_Freq_Units = hex2dec('0806'); % Specifies the units to use to return frequency measurements from the channel.
DAQmx_AI_Freq_ThreshVoltage = hex2dec('0815'); % Specifies the voltage level at which to recognize waveform repetitions. You should select a voltage level that occurs only once within the entire period of a waveform. You also can select a voltage that occurs only once while the voltage rises or falls.
DAQmx_AI_Freq_Hyst = hex2dec('0814'); % Specifies in volts a window below Threshold Level. The input voltage must pass below Threshold Level minus this value before NI-DAQmx recognizes a waveform repetition at Threshold Level. Hysteresis can improve the measurement accuracy when the signal contains noise or jitter.
DAQmx_AI_LVDT_Units = hex2dec('0910'); % Specifies the units to use to return linear position measurements from the channel.
DAQmx_AI_LVDT_Sensitivity = hex2dec('0939'); % Specifies the sensitivity of the LVDT. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
DAQmx_AI_LVDT_SensitivityUnits = hex2dec('219A'); % Specifies the units of Sensitivity.
DAQmx_AI_RVDT_Units = hex2dec('0877'); % Specifies the units to use to return angular position measurements from the channel.
DAQmx_AI_RVDT_Sensitivity = hex2dec('0903'); % Specifies the sensitivity of the RVDT. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
DAQmx_AI_RVDT_SensitivityUnits = hex2dec('219B'); % Specifies the units of Sensitivity.
DAQmx_AI_SoundPressure_MaxSoundPressureLvl = hex2dec('223A'); % Specifies the maximum instantaneous sound pressure level you expect to measure. This value is in decibels, referenced to 20 micropascals. NI-DAQmx uses the maximum sound pressure level to calculate values in pascals for Maximum Value and Minimum Value for the channel.
DAQmx_AI_SoundPressure_Units = hex2dec('1528'); % Specifies the units to use to return sound pressure measurements from the channel.
DAQmx_AI_Microphone_Sensitivity = hex2dec('1536'); % Specifies the sensitivity of the microphone. This value is in mV/Pa. Refer to the sensor documentation to determine this value.
DAQmx_AI_Accel_Units = hex2dec('0673'); % Specifies the units to use to return acceleration measurements from the channel.
DAQmx_AI_Accel_Sensitivity = hex2dec('0692'); % Specifies the sensitivity of the accelerometer. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
DAQmx_AI_Accel_SensitivityUnits = hex2dec('219C'); % Specifies the units of Sensitivity.
DAQmx_AI_TEDS_Units = hex2dec('21E0'); % Indicates the units defined by TEDS information associated with the channel.
DAQmx_AI_Coupling = hex2dec('0064'); % Specifies the coupling for the channel.
DAQmx_AI_Impedance = hex2dec('0062'); % Specifies the input impedance of the channel.
DAQmx_AI_TermCfg = hex2dec('1097'); % Specifies the terminal configuration for the channel.
DAQmx_AI_InputSrc = hex2dec('2198'); % Specifies the source of the channel. You can use the signal from the I/O connector or one of several calibration signals. Certain devices have a single calibration signal bus. For these devices, you must specify the same calibration signal for all channels you connect to a calibration signal.
DAQmx_AI_ResistanceCfg = hex2dec('1881'); % Specifies the resistance configuration for the channel. NI-DAQmx uses this value for any resistance-based measurements, including temperature measurement using a thermistor or RTD.
DAQmx_AI_LeadWireResistance = hex2dec('17EE'); % Specifies in ohms the resistance of the wires that lead to the sensor.
DAQmx_AI_Bridge_Cfg = hex2dec('0087'); % Specifies the type of Wheatstone bridge that the sensor is.
DAQmx_AI_Bridge_NomResistance = hex2dec('17EC'); % Specifies in ohms the resistance across each arm of the bridge in an unloaded position.
DAQmx_AI_Bridge_InitialVoltage = hex2dec('17ED'); % Specifies in volts the output voltage of the bridge in the unloaded condition. NI-DAQmx subtracts this value from any measurements before applying scaling equations.
DAQmx_AI_Bridge_ShuntCal_Enable = hex2dec('0094'); % Specifies whether to enable a shunt calibration switch. Use Shunt Cal Select to select the switch(es) to enable.
DAQmx_AI_Bridge_ShuntCal_Select = hex2dec('21D5'); % Specifies which shunt calibration switch(es) to enable.Use Shunt Cal Enable to enable the switch(es) you specify with this property.
DAQmx_AI_Bridge_ShuntCal_GainAdjust = hex2dec('193F'); % Specifies the result of a shunt calibration. NI-DAQmx multiplies data read from the channel by the value of this property. This value should be close to 1.0.
DAQmx_AI_Bridge_Balance_CoarsePot = hex2dec('17F1'); % Specifies by how much to compensate for offset in the signal. This value can be between 0 and 127.
DAQmx_AI_Bridge_Balance_FinePot = hex2dec('18F4'); % Specifies by how much to compensate for offset in the signal. This value can be between 0 and 4095.
DAQmx_AI_CurrentShunt_Loc = hex2dec('17F2'); % Specifies the shunt resistor location for current measurements.
DAQmx_AI_CurrentShunt_Resistance = hex2dec('17F3'); % Specifies in ohms the external shunt resistance for current measurements.
DAQmx_AI_Excit_Src = hex2dec('17F4'); % Specifies the source of excitation.
DAQmx_AI_Excit_Val = hex2dec('17F5'); % Specifies the amount of excitation that the sensor requires. If Voltage or Current isDAQmx_Val_Voltage, this value is in volts. If Voltage or Current isDAQmx_Val_Current, this value is in amperes.
DAQmx_AI_Excit_UseForScaling = hex2dec('17FC'); % Specifies if NI-DAQmx divides the measurement by the excitation. You should typically set this property to TRUE for ratiometric transducers. If you set this property to TRUE, set Maximum Value and Minimum Value to reflect the scaling.
DAQmx_AI_Excit_UseMultiplexed = hex2dec('2180'); % Specifies if the SCXI-1122 multiplexes the excitation to the upper half of the channels as it advances through the scan list.
DAQmx_AI_Excit_ActualVal = hex2dec('1883'); % Specifies the actual amount of excitation supplied by an internal excitation source.If you read an internal excitation source more precisely with an external device, set this property to the value you read.NI-DAQmx ignores this value for external excitation.
DAQmx_AI_Excit_DCorAC = hex2dec('17FB'); % Specifies if the excitation supply is DC or AC.
DAQmx_AI_Excit_VoltageOrCurrent = hex2dec('17F6'); % Specifies if the channel uses current or voltage excitation.
DAQmx_AI_ACExcit_Freq = hex2dec('0101'); % Specifies the AC excitation frequency in Hertz.
DAQmx_AI_ACExcit_SyncEnable = hex2dec('0102'); % Specifies whether to synchronize the AC excitation source of the channel to that of another channel. Synchronize the excitation sources of multiple channels to use multichannel sensors. Set this property to FALSE for the master channel and to TRUE for the slave channels.
DAQmx_AI_ACExcit_WireMode = hex2dec('18CD'); % Specifies the number of leads on the LVDT or RVDT. Some sensors require you to tie leads together to create a four- or five- wire sensor. Refer to the sensor documentation for more information.
DAQmx_AI_Atten = hex2dec('1801'); % Specifies the amount of attenuation to use.
DAQmx_AI_Lowpass_Enable = hex2dec('1802'); % Specifies whether to enable the lowpass filter of the channel.
DAQmx_AI_Lowpass_CutoffFreq = hex2dec('1803'); % Specifies the frequency in Hertz that corresponds to the -3dB cutoff of the filter.
DAQmx_AI_Lowpass_SwitchCap_ClkSrc = hex2dec('1884'); % Specifies the source of the filter clock. If you need a higher resolution for the filter, you can supply an external clock to increase the resolution. Refer to the SCXI-1141/1142/1143 User Manual for more information.
DAQmx_AI_Lowpass_SwitchCap_ExtClkFreq = hex2dec('1885'); % Specifies the frequency of the external clock when you set Clock Source to DAQmx_Val_External.NI-DAQmx uses this frequency to set the pre- and post- filters on the SCXI-1141, SCXI-1142, and SCXI-1143. On those devices, NI-DAQmx determines the filter cutoff by using the equation f/(100*n), where f is the external frequency, and n is the external clock divisor. Refer to the SCXI-1141/1142/1143 User Manual for more...
DAQmx_AI_Lowpass_SwitchCap_ExtClkDiv = hex2dec('1886'); % Specifies the divisor for the external clock when you set Clock Source to DAQmx_Val_External. On the SCXI-1141, SCXI-1142, and SCXI-1143, NI-DAQmx determines the filter cutoff by using the equation f/(100*n), where f is the external frequency, and n is the external clock divisor. Refer to the SCXI-1141/1142/1143 User Manual for more information.
DAQmx_AI_Lowpass_SwitchCap_OutClkDiv = hex2dec('1887'); % Specifies the divisor for the output clock.NI-DAQmx uses the cutoff frequency to determine the output clock frequency. Refer to the SCXI-1141/1142/1143 User Manual for more information.
DAQmx_AI_ResolutionUnits = hex2dec('1764'); % Indicates the units of Resolution Value.
DAQmx_AI_Resolution = hex2dec('1765'); % Indicates the resolution of the analog-to-digital converter of the channel. This value is in the units you specify with Resolution Units.
DAQmx_AI_Dither_Enable = hex2dec('0068'); % Specifies whether to enable dithering.Dithering adds Gaussian noise to the input signal. You can use dithering to achieve higher resolution measurements by over sampling the input signal and averaging the results.
DAQmx_AI_Rng_High = hex2dec('1815'); % Specifies the upper limit of the input range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
DAQmx_AI_Rng_Low = hex2dec('1816'); % Specifies the lower limit of the input range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
DAQmx_AI_Gain = hex2dec('1818'); % Specifies a gain factor to apply to the channel.
DAQmx_AI_SampAndHold_Enable = hex2dec('181A'); % Specifies whether to enable the sample and hold circuitry of the device. When you disable sample and hold circuitry, a small voltage offset might be introduced into the signal.You can eliminate this offset by using Auto Zero Mode to perform an auto zero on the channel.
DAQmx_AI_AutoZeroMode = hex2dec('1760'); % Specifies when to measure ground. NI-DAQmx subtracts the measured ground voltage from every sample.
DAQmx_AI_DataXferMech = hex2dec('1821'); % Specifies the data transfer mode for the device.
DAQmx_AI_DataXferReqCond = hex2dec('188B'); % Specifies under what condition to transfer data from the onboard memory of the device to the buffer.
DAQmx_AI_MemMapEnable = hex2dec('188C'); % Specifies for NI-DAQmx to map hardware registers to the memory space of the customer process, if possible. Mapping to the memory space of the customer process increases performance. However, memory mapping can adversely affect the operation of the device and possibly result in a system crash if software in the process unintentionally accesses the mapped registers.
DAQmx_AI_DevScalingCoeff = hex2dec('1930'); % Indicates the coefficients of a polynomial equation that NI-DAQmx uses to scale values from the native format of the device to volts. Each element of the array corresponds to a term of the equation. For example, if index two of the array is 4, the third term of the equation is 4x^2. Scaling coefficients do not account for any custom scales or sensors contained by the channel.
DAQmx_AI_EnhancedAliasRejectionEnable = hex2dec('2294'); % Specifies whether to enable enhanced alias rejection. By default, enhanced alias rejection is enabled on supported devices. Leave this property set to the default value for most applications.
DAQmx_AO_Max = hex2dec('1186'); % Specifies the maximum value you expect to generate. The value is in the units you specify with a units property. If you try to write a value larger than the maximum value, NI-DAQmx generates an error. NI-DAQmx might coerce this value to a smaller value if other task settings restrict the device from generating the desired maximum.
DAQmx_AO_Min = hex2dec('1187'); % Specifies the minimum value you expect to generate. The value is in the units you specify with a units property. If you try to write a value smaller than the minimum value, NI-DAQmx generates an error. NI-DAQmx might coerce this value to a larger value if other task settings restrict the device from generating the desired minimum.
DAQmx_AO_CustomScaleName = hex2dec('1188'); % Specifies the name of a custom scale for the channel.
DAQmx_AO_OutputType = hex2dec('1108'); % Indicates whether the channel generates voltage or current.
DAQmx_AO_Voltage_Units = hex2dec('1184'); % Specifies in what units to generate voltage on the channel. Write data to the channel in the units you select.
DAQmx_AO_Current_Units = hex2dec('1109'); % Specifies in what units to generate current on the channel. Write data to the channel is in the units you select.
DAQmx_AO_OutputImpedance = hex2dec('1490'); % Specifies in ohms the impedance of the analog output stage of the device.
DAQmx_AO_LoadImpedance = hex2dec('0121'); % Specifies in ohms the load impedance connected to the analog output channel.
DAQmx_AO_IdleOutputBehavior = hex2dec('2240'); % Specifies the state of the channel when no generation is in progress.
DAQmx_AO_TermCfg = hex2dec('188E'); % Specifies the terminal configuration of the channel.
DAQmx_AO_ResolutionUnits = hex2dec('182B'); % Specifies the units of Resolution Value.
DAQmx_AO_Resolution = hex2dec('182C'); % Indicates the resolution of the digital-to-analog converter of the channel. This value is in the units you specify with Resolution Units.
DAQmx_AO_DAC_Rng_High = hex2dec('182E'); % Specifies the upper limit of the output range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
DAQmx_AO_DAC_Rng_Low = hex2dec('182D'); % Specifies the lower limit of the output range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
DAQmx_AO_DAC_Ref_ConnToGnd = hex2dec('0130'); % Specifies whether to ground the internal DAC reference. Grounding the internal DAC reference has the effect of grounding all analog output channels and stopping waveform generation across all analog output channels regardless of whether the channels belong to the current task. You can ground the internal DAC reference only when Source is DAQmx_Val_Internal and Allow Connecting DAC Reference to Ground at Runtime is...
DAQmx_AO_DAC_Ref_AllowConnToGnd = hex2dec('1830'); % Specifies whether to allow grounding the internal DAC reference at run time. You must set this property to TRUE and set Source to DAQmx_Val_Internal before you can set Connect DAC Reference to Ground to TRUE.
DAQmx_AO_DAC_Ref_Src = hex2dec('0132'); % Specifies the source of the DAC reference voltage. The value of this voltage source determines the full-scale value of the DAC.
DAQmx_AO_DAC_Ref_ExtSrc = hex2dec('2252'); % Specifies the source of the DAC reference voltage if Source is DAQmx_Val_External.
DAQmx_AO_DAC_Ref_Val = hex2dec('1832'); % Specifies in volts the value of the DAC reference voltage. This voltage determines the full-scale range of the DAC. Smaller reference voltages result in smaller ranges, but increased resolution.
DAQmx_AO_DAC_Offset_Src = hex2dec('2253'); % Specifies the source of the DAC offset voltage. The value of this voltage source determines the full-scale value of the DAC.
DAQmx_AO_DAC_Offset_ExtSrc = hex2dec('2254'); % Specifies the source of the DAC offset voltage if Source is DAQmx_Val_External.
DAQmx_AO_DAC_Offset_Val = hex2dec('2255'); % Specifies in volts the value of the DAC offset voltage.
DAQmx_AO_ReglitchEnable = hex2dec('0133'); % Specifies whether to enable reglitching.The output of a DAC normally glitches whenever the DAC is updated with a new value. The amount of glitching differs from code to code and is generally largest at major code transitions.Reglitching generates uniform glitch energy at each code transition and provides for more uniform glitches.Uniform glitch energy makes it easier to filter out the noise introduced from g...
DAQmx_AO_Gain = hex2dec('0118'); % Specifies in decibels the gain factor to apply to the channel.
DAQmx_AO_UseOnlyOnBrdMem = hex2dec('183A'); % Specifies whether to write samples directly to the onboard memory of the device, bypassing the memory buffer. Generally, you cannot update onboard memory after you start the task. Onboard memory includes data FIFOs.
DAQmx_AO_DataXferMech = hex2dec('0134'); % Specifies the data transfer mode for the device.
DAQmx_AO_DataXferReqCond = hex2dec('183C'); % Specifies under what condition to transfer data from the buffer to the onboard memory of the device.
DAQmx_AO_MemMapEnable = hex2dec('188F'); % Specifies if NI-DAQmx maps hardware registers to the memory space of the customer process, if possible. Mapping to the memory space of the customer process increases performance. However, memory mapping can adversely affect the operation of the device and possibly result in a system crash if software in the process unintentionally accesses the mapped registers.
DAQmx_AO_DevScalingCoeff = hex2dec('1931'); % Indicates the coefficients of a linear equation that NI-DAQmx uses to scale values from a voltage to the native format of the device.Each element of the array corresponds to a term of the equation. For example, if index two of the array is 4, the third term of the equation is 4x^2.Scaling coefficients do not account for any custom scales that may be applied to the channel.
DAQmx_DI_InvertLines = hex2dec('0793'); % Specifies whether to invert the lines in the channel. If you set this property to TRUE, the lines are at high logic when off and at low logic when on.
DAQmx_DI_NumLines = hex2dec('2178'); % Indicates the number of digital lines in the channel.
DAQmx_DI_DigFltr_Enable = hex2dec('21D6'); % Specifies whether to enable the digital filter for the line(s) or port(s). You can enable the filter on a line-by-line basis. You do not have to enable the filter for all lines in a channel.
DAQmx_DI_DigFltr_MinPulseWidth = hex2dec('21D7'); % Specifies in seconds the minimum pulse width the filter recognizes as a valid high or low state transition.
DAQmx_DI_Tristate = hex2dec('1890'); % Specifies whether to tristate the lines in the channel. If you set this property to TRUE, NI-DAQmx tristates the lines in the channel. If you set this property to FALSE, NI-DAQmx does not modify the configuration of the lines even if the lines were previously tristated. Set this property to FALSE to read lines in other tasks or to read output-only lines.
DAQmx_DI_DataXferMech = hex2dec('2263'); % Specifies the data transfer mode for the device.
DAQmx_DI_DataXferReqCond = hex2dec('2264'); % Specifies under what condition to transfer data from the onboard memory of the device to the buffer.
DAQmx_DO_InvertLines = hex2dec('1133'); % Specifies whether to invert the lines in the channel. If you set this property to TRUE, the lines are at high logic when off and at low logic when on.
DAQmx_DO_NumLines = hex2dec('2179'); % Indicates the number of digital lines in the channel.
DAQmx_DO_Tristate = hex2dec('18F3'); % Specifies whether to stop driving the channel and set it to a Hi-Z state.
DAQmx_DO_UseOnlyOnBrdMem = hex2dec('2265'); % Specifies whether to write samples directly to the onboard memory of the device, bypassing the memory buffer. Generally, you cannot update onboard memory after you start the task. Onboard memory includes data FIFOs.
DAQmx_DO_DataXferMech = hex2dec('2266'); % Specifies the data transfer mode for the device.
DAQmx_DO_DataXferReqCond = hex2dec('2267'); % Specifies under what condition to transfer data from the buffer to the onboard memory of the device.
DAQmx_CI_Max = hex2dec('189C'); % Specifies the maximum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced maximum value that the hardware can measure with the current settings.
DAQmx_CI_Min = hex2dec('189D'); % Specifies the minimum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced minimum value that the hardware can measure with the current settings.
DAQmx_CI_CustomScaleName = hex2dec('189E'); % Specifies the name of a custom scale for the channel.
DAQmx_CI_MeasType = hex2dec('18A0'); % Indicates the measurement to take with the channel.
DAQmx_CI_Freq_Units = hex2dec('18A1'); % Specifies the units to use to return frequency measurements.
DAQmx_CI_Freq_Term = hex2dec('18A2'); % Specifies the input terminal of the signal to measure.
DAQmx_CI_Freq_StartingEdge = hex2dec('0799'); % Specifies between which edges to measure the frequency of the signal.
DAQmx_CI_Freq_MeasMeth = hex2dec('0144'); % Specifies the method to use to measure the frequency of the signal.
DAQmx_CI_Freq_MeasTime = hex2dec('0145'); % Specifies in seconds the length of time to measure the frequency of the signal if Method is DAQmx_Val_HighFreq2Ctr. Measurement accuracy increases with increased measurement time and with increased signal frequency. If you measure a high-frequency signal for too long, however, the count register could roll over, which results in an incorrect measurement.
DAQmx_CI_Freq_Div = hex2dec('0147'); % Specifies the value by which to divide the input signal ifMethod is DAQmx_Val_LargeRng2Ctr. The larger the divisor, the more accurate the measurement. However, too large a value could cause the count register to roll over, which results in an incorrect measurement.
DAQmx_CI_Freq_DigFltr_Enable = hex2dec('21E7'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_Freq_DigFltr_MinPulseWidth = hex2dec('21E8'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_Freq_DigFltr_TimebaseSrc = hex2dec('21E9'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_Freq_DigFltr_TimebaseRate = hex2dec('21EA'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_Freq_DigSync_Enable = hex2dec('21EB'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_Period_Units = hex2dec('18A3'); % Specifies the unit to use to return period measurements.
DAQmx_CI_Period_Term = hex2dec('18A4'); % Specifies the input terminal of the signal to measure.
DAQmx_CI_Period_StartingEdge = hex2dec('0852'); % Specifies between which edges to measure the period of the signal.
DAQmx_CI_Period_MeasMeth = hex2dec('192C'); % Specifies the method to use to measure the period of the signal.
DAQmx_CI_Period_MeasTime = hex2dec('192D'); % Specifies in seconds the length of time to measure the period of the signal if Method is DAQmx_Val_HighFreq2Ctr. Measurement accuracy increases with increased measurement time and with increased signal frequency. If you measure a high-frequency signal for too long, however, the count register could roll over, which results in an incorrect measurement.
DAQmx_CI_Period_Div = hex2dec('192E'); % Specifies the value by which to divide the input signal if Method is DAQmx_Val_LargeRng2Ctr. The larger the divisor, the more accurate the measurement. However, too large a value could cause the count register to roll over, which results in an incorrect measurement.
DAQmx_CI_Period_DigFltr_Enable = hex2dec('21EC'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_Period_DigFltr_MinPulseWidth = hex2dec('21ED'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_Period_DigFltr_TimebaseSrc = hex2dec('21EE'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_Period_DigFltr_TimebaseRate = hex2dec('21EF'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_Period_DigSync_Enable = hex2dec('21F0'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_CountEdges_Term = hex2dec('18C7'); % Specifies the input terminal of the signal to measure.
DAQmx_CI_CountEdges_Dir = hex2dec('0696'); % Specifies whether to increment or decrement the counter on each edge.
DAQmx_CI_CountEdges_DirTerm = hex2dec('21E1'); % Specifies the source terminal of the digital signal that controls the count direction if Direction is DAQmx_Val_ExtControlled.
DAQmx_CI_CountEdges_CountDir_DigFltr_Enable = hex2dec('21F1'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_CountEdges_CountDir_DigFltr_MinPulseWidth = hex2dec('21F2'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseSrc = hex2dec('21F3'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseRate = hex2dec('21F4'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_CountEdges_CountDir_DigSync_Enable = hex2dec('21F5'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_CountEdges_InitialCnt = hex2dec('0698'); % Specifies the starting value from which to count.
DAQmx_CI_CountEdges_ActiveEdge = hex2dec('0697'); % Specifies on which edges to increment or decrement the counter.
DAQmx_CI_CountEdges_DigFltr_Enable = hex2dec('21F6'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_CountEdges_DigFltr_MinPulseWidth = hex2dec('21F7'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_CountEdges_DigFltr_TimebaseSrc = hex2dec('21F8'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_CountEdges_DigFltr_TimebaseRate = hex2dec('21F9'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_CountEdges_DigSync_Enable = hex2dec('21FA'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_AngEncoder_Units = hex2dec('18A6'); % Specifies the units to use to return angular position measurements from the channel.
DAQmx_CI_AngEncoder_PulsesPerRev = hex2dec('0875'); % Specifies the number of pulses the encoder generates per revolution. This value is the number of pulses on either signal A or signal B, not the total number of pulses on both signal A and signal B.
DAQmx_CI_AngEncoder_InitialAngle = hex2dec('0881'); % Specifies the starting angle of the encoder. This value is in the units you specify with Units.
DAQmx_CI_LinEncoder_Units = hex2dec('18A9'); % Specifies the units to use to return linear encoder measurements from the channel.
DAQmx_CI_LinEncoder_DistPerPulse = hex2dec('0911'); % Specifies the distance to measure for each pulse the encoder generates on signal A or signal B. This value is in the units you specify with Units.
DAQmx_CI_LinEncoder_InitialPos = hex2dec('0915'); % Specifies the position of the encoder when the measurement begins. This value is in the units you specify with Units.
DAQmx_CI_Encoder_DecodingType = hex2dec('21E6'); % Specifies how to count and interpret the pulses the encoder generates on signal A and signal B. DAQmx_Val_X1, DAQmx_Val_X2, and DAQmx_Val_X4 are valid for quadrature encoders only. DAQmx_Val_TwoPulseCounting is valid for two-pulse encoders only.
DAQmx_CI_Encoder_AInputTerm = hex2dec('219D'); % Specifies the terminal to which signal A is connected.
DAQmx_CI_Encoder_AInput_DigFltr_Enable = hex2dec('21FB'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_Encoder_AInput_DigFltr_MinPulseWidth = hex2dec('21FC'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_Encoder_AInput_DigFltr_TimebaseSrc = hex2dec('21FD'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_Encoder_AInput_DigFltr_TimebaseRate = hex2dec('21FE'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_Encoder_AInput_DigSync_Enable = hex2dec('21FF'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_Encoder_BInputTerm = hex2dec('219E'); % Specifies the terminal to which signal B is connected.
DAQmx_CI_Encoder_BInput_DigFltr_Enable = hex2dec('2200'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_Encoder_BInput_DigFltr_MinPulseWidth = hex2dec('2201'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_Encoder_BInput_DigFltr_TimebaseSrc = hex2dec('2202'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_Encoder_BInput_DigFltr_TimebaseRate = hex2dec('2203'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_Encoder_BInput_DigSync_Enable = hex2dec('2204'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_Encoder_ZInputTerm = hex2dec('219F'); % Specifies the terminal to which signal Z is connected.
DAQmx_CI_Encoder_ZInput_DigFltr_Enable = hex2dec('2205'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_Encoder_ZInput_DigFltr_MinPulseWidth = hex2dec('2206'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseSrc = hex2dec('2207'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseRate = hex2dec('2208'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_Encoder_ZInput_DigSync_Enable = hex2dec('2209'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_Encoder_ZIndexEnable = hex2dec('0890'); % Specifies whether to use Z indexing for the channel.
DAQmx_CI_Encoder_ZIndexVal = hex2dec('0888'); % Specifies the value to which to reset the measurement when signal Z is high and signal A and signal B are at the states you specify with Z Index Phase. Specify this value in the units of the measurement.
DAQmx_CI_Encoder_ZIndexPhase = hex2dec('0889'); % Specifies the states at which signal A and signal B must be while signal Z is high for NI-DAQmx to reset the measurement. If signal Z is never high while signal A and signal B are high, for example, you must choose a phase other than DAQmx_Val_AHighBHigh.
DAQmx_CI_PulseWidth_Units = hex2dec('0823'); % Specifies the units to use to return pulse width measurements.
DAQmx_CI_PulseWidth_Term = hex2dec('18AA'); % Specifies the input terminal of the signal to measure.
DAQmx_CI_PulseWidth_StartingEdge = hex2dec('0825'); % Specifies on which edge of the input signal to begin each pulse width measurement.
DAQmx_CI_PulseWidth_DigFltr_Enable = hex2dec('220A'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_PulseWidth_DigFltr_MinPulseWidth = hex2dec('220B'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_PulseWidth_DigFltr_TimebaseSrc = hex2dec('220C'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_PulseWidth_DigFltr_TimebaseRate = hex2dec('220D'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_PulseWidth_DigSync_Enable = hex2dec('220E'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_TwoEdgeSep_Units = hex2dec('18AC'); % Specifies the units to use to return two-edge separation measurements from the channel.
DAQmx_CI_TwoEdgeSep_FirstTerm = hex2dec('18AD'); % Specifies the source terminal of the digital signal that starts each measurement.
DAQmx_CI_TwoEdgeSep_FirstEdge = hex2dec('0833'); % Specifies on which edge of the first signal to start each measurement.
DAQmx_CI_TwoEdgeSep_First_DigFltr_Enable = hex2dec('220F'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_TwoEdgeSep_First_DigFltr_MinPulseWidth = hex2dec('2210'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseSrc = hex2dec('2211'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseRate = hex2dec('2212'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_TwoEdgeSep_First_DigSync_Enable = hex2dec('2213'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_TwoEdgeSep_SecondTerm = hex2dec('18AE'); % Specifies the source terminal of the digital signal that stops each measurement.
DAQmx_CI_TwoEdgeSep_SecondEdge = hex2dec('0834'); % Specifies on which edge of the second signal to stop each measurement.
DAQmx_CI_TwoEdgeSep_Second_DigFltr_Enable = hex2dec('2214'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_TwoEdgeSep_Second_DigFltr_MinPulseWidth = hex2dec('2215'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseSrc = hex2dec('2216'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseRate = hex2dec('2217'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_TwoEdgeSep_Second_DigSync_Enable = hex2dec('2218'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_SemiPeriod_Units = hex2dec('18AF'); % Specifies the units to use to return semi-period measurements.
DAQmx_CI_SemiPeriod_Term = hex2dec('18B0'); % Specifies the input terminal of the signal to measure.
DAQmx_CI_SemiPeriod_DigFltr_Enable = hex2dec('2219'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_SemiPeriod_DigFltr_MinPulseWidth = hex2dec('221A'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_SemiPeriod_DigFltr_TimebaseSrc = hex2dec('221B'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_SemiPeriod_DigFltr_TimebaseRate = hex2dec('221C'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_SemiPeriod_DigSync_Enable = hex2dec('221D'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_CtrTimebaseSrc = hex2dec('0143'); % Specifies the terminal of the timebase to use for the counter.
DAQmx_CI_CtrTimebaseRate = hex2dec('18B2'); % Specifies in Hertz the frequency of the counter timebase. Specifying the rate of a counter timebase allows you to take measurements in terms of time or frequency rather than in ticks of the timebase. If you use an external timebase and do not specify the rate, you can take measurements only in terms of ticks of the timebase.
DAQmx_CI_CtrTimebaseActiveEdge = hex2dec('0142'); % Specifies whether a timebase cycle is from rising edge to rising edge or from falling edge to falling edge.
DAQmx_CI_CtrTimebase_DigFltr_Enable = hex2dec('2271'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CI_CtrTimebase_DigFltr_MinPulseWidth = hex2dec('2272'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CI_CtrTimebase_DigFltr_TimebaseSrc = hex2dec('2273'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CI_CtrTimebase_DigFltr_TimebaseRate = hex2dec('2274'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CI_CtrTimebase_DigSync_Enable = hex2dec('2275'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CI_Count = hex2dec('0148'); % Indicates the current value of the count register.
DAQmx_CI_OutputState = hex2dec('0149'); % Indicates the current state of the out terminal of the counter.
DAQmx_CI_TCReached = hex2dec('0150'); % Indicates whether the counter rolled over. When you query this property, NI-DAQmx resets it to FALSE.
DAQmx_CI_CtrTimebaseMasterTimebaseDiv = hex2dec('18B3'); % Specifies the divisor for an external counter timebase. You can divide the counter timebase in order to measure slower signals without causing the count register to roll over.
DAQmx_CI_DataXferMech = hex2dec('0200'); % Specifies the data transfer mode for the channel.
DAQmx_CI_NumPossiblyInvalidSamps = hex2dec('193C'); % Indicates the number of samples that the device might have overwritten before it could transfer them to the buffer.
DAQmx_CI_DupCountPrevent = hex2dec('21AC'); % Specifies whether to enable duplicate count prevention for the channel.
DAQmx_CI_Prescaler = hex2dec('2239'); % Specifies the divisor to apply to the signal you connect to the counter source terminal. Scaled data that you read takes this setting into account. You should use a prescaler only when you connect an external signal to the counter source terminal and when that signal has a higher frequency than the fastest onboard timebase.
DAQmx_CO_OutputType = hex2dec('18B5'); % Indicates how to define pulses generated on the channel.
DAQmx_CO_Pulse_IdleState = hex2dec('1170'); % Specifies the resting state of the output terminal.
DAQmx_CO_Pulse_Term = hex2dec('18E1'); % Specifies on which terminal to generate pulses.
DAQmx_CO_Pulse_Time_Units = hex2dec('18D6'); % Specifies the units in which to define high and low pulse time.
DAQmx_CO_Pulse_HighTime = hex2dec('18BA'); % Specifies the amount of time that the pulse is at a high voltage. This value is in the units you specify with Units or when you create the channel.
DAQmx_CO_Pulse_LowTime = hex2dec('18BB'); % Specifies the amount of time that the pulse is at a low voltage. This value is in the units you specify with Units or when you create the channel.
DAQmx_CO_Pulse_Time_InitialDelay = hex2dec('18BC'); % Specifies in seconds the amount of time to wait before generating the first pulse.
DAQmx_CO_Pulse_DutyCyc = hex2dec('1176'); % Specifies the duty cycle of the pulses. The duty cycle of a signal is the width of the pulse divided by period. NI-DAQmx uses this ratio and the pulse frequency to determine the width of the pulses and the delay between pulses.
DAQmx_CO_Pulse_Freq_Units = hex2dec('18D5'); % Specifies the units in which to define pulse frequency.
DAQmx_CO_Pulse_Freq = hex2dec('1178'); % Specifies the frequency of the pulses to generate. This value is in the units you specify with Units or when you create the channel.
DAQmx_CO_Pulse_Freq_InitialDelay = hex2dec('0299'); % Specifies in seconds the amount of time to wait before generating the first pulse.
DAQmx_CO_Pulse_HighTicks = hex2dec('1169'); % Specifies the number of ticks the pulse is high.
DAQmx_CO_Pulse_LowTicks = hex2dec('1171'); % Specifies the number of ticks the pulse is low.
DAQmx_CO_Pulse_Ticks_InitialDelay = hex2dec('0298'); % Specifies the number of ticks to wait before generating the first pulse.
DAQmx_CO_CtrTimebaseSrc = hex2dec('0339'); % Specifies the terminal of the timebase to use for the counter. Typically, NI-DAQmx uses one of the internal counter timebases when generating pulses. Use this property to specify an external timebase and produce custom pulse widths that are not possible using the internal timebases.
DAQmx_CO_CtrTimebaseRate = hex2dec('18C2'); % Specifies in Hertz the frequency of the counter timebase. Specifying the rate of a counter timebase allows you to define output pulses in seconds rather than in ticks of the timebase. If you use an external timebase and do not specify the rate, you can define output pulses only in ticks of the timebase.
DAQmx_CO_CtrTimebaseActiveEdge = hex2dec('0341'); % Specifies whether a timebase cycle is from rising edge to rising edge or from falling edge to falling edge.
DAQmx_CO_CtrTimebase_DigFltr_Enable = hex2dec('2276'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_CO_CtrTimebase_DigFltr_MinPulseWidth = hex2dec('2277'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_CO_CtrTimebase_DigFltr_TimebaseSrc = hex2dec('2278'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_CO_CtrTimebase_DigFltr_TimebaseRate = hex2dec('2279'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_CO_CtrTimebase_DigSync_Enable = hex2dec('227A'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_CO_Count = hex2dec('0293'); % Indicates the current value of the count register.
DAQmx_CO_OutputState = hex2dec('0294'); % Indicates the current state of the output terminal of the counter.
DAQmx_CO_AutoIncrCnt = hex2dec('0295'); % Specifies a number of timebase ticks by which to increment each successive pulse.
DAQmx_CO_CtrTimebaseMasterTimebaseDiv = hex2dec('18C3'); % Specifies the divisor for an external counter timebase. You can divide the counter timebase in order to generate slower signals without causing the count register to roll over.
DAQmx_CO_PulseDone = hex2dec('190E'); % Indicates if the task completed pulse generation. Use this value for retriggerable pulse generation when you need to determine if the device generated the current pulse. When you query this property, NI-DAQmx resets it to FALSE.
DAQmx_CO_Prescaler = hex2dec('226D'); % Specifies the divisor to apply to the signal you connect to the counter source terminal. Pulse generations defined by frequency or time take this setting into account, but pulse generations defined by ticks do not. You should use a prescaler only when you connect an external signal to the counter source terminal and when that signal has a higher frequency than the fastest onboard timebase.

%********** Export Signal Attributes **********
DAQmx_Exported_AIConvClk_OutputTerm = hex2dec('1687'); % Specifies the terminal to which to route the AI Convert Clock.
DAQmx_Exported_AIConvClk_Pulse_Polarity = hex2dec('1688'); % Indicates the polarity of the exported AI Convert Clock. The polarity is fixed and independent of the active edge of the source of the AI Convert Clock.
DAQmx_Exported_10MHzRefClk_OutputTerm = hex2dec('226E'); % Specifies the terminal to which to route the 10MHz Clock.
DAQmx_Exported_20MHzTimebase_OutputTerm = hex2dec('1657'); % Specifies the terminal to which to route the 20MHz Timebase.
DAQmx_Exported_SampClk_OutputBehavior = hex2dec('186B'); % Specifies whether the exported Sample Clock issues a pulse at the beginning of a sample or changes to a high state for the duration of the sample.
DAQmx_Exported_SampClk_OutputTerm = hex2dec('1663'); % Specifies the terminal to which to route the Sample Clock.
DAQmx_Exported_SampClkTimebase_OutputTerm = hex2dec('18F9'); % Specifies the terminal to which to route the Sample Clock Timebase.
DAQmx_Exported_DividedSampClkTimebase_OutputTerm = hex2dec('21A1'); % Specifies the terminal to which to route the Divided Sample Clock Timebase.
DAQmx_Exported_AdvTrig_OutputTerm = hex2dec('1645'); % Specifies the terminal to which to route the Advance Trigger.
DAQmx_Exported_AdvTrig_Pulse_Polarity = hex2dec('1646'); % Indicates the polarity of the exported Advance Trigger.
DAQmx_Exported_AdvTrig_Pulse_WidthUnits = hex2dec('1647'); % Specifies the units of Width Value.
DAQmx_Exported_AdvTrig_Pulse_Width = hex2dec('1648'); % Specifies the width of an exported Advance Trigger pulse. Specify this value in the units you specify with Width Units.
DAQmx_Exported_RefTrig_OutputTerm = hex2dec('0590'); % Specifies the terminal to which to route the Reference Trigger.
DAQmx_Exported_StartTrig_OutputTerm = hex2dec('0584'); % Specifies the terminal to which to route the Start Trigger.
DAQmx_Exported_AdvCmpltEvent_OutputTerm = hex2dec('1651'); % Specifies the terminal to which to route the Advance Complete Event.
DAQmx_Exported_AdvCmpltEvent_Delay = hex2dec('1757'); % Specifies the output signal delay in periods of the sample clock.
DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity = hex2dec('1652'); % Specifies the polarity of the exported Advance Complete Event.
DAQmx_Exported_AdvCmpltEvent_Pulse_Width = hex2dec('1654'); % Specifies the width of the exported Advance Complete Event pulse.
DAQmx_Exported_AIHoldCmpltEvent_OutputTerm = hex2dec('18ED'); % Specifies the terminal to which to route the AI Hold Complete Event.
DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity = hex2dec('18EE'); % Specifies the polarity of an exported AI Hold Complete Event pulse.
DAQmx_Exported_ChangeDetectEvent_OutputTerm = hex2dec('2197'); % Specifies the terminal to which to route the Change Detection Event.
DAQmx_Exported_CtrOutEvent_OutputTerm = hex2dec('1717'); % Specifies the terminal to which to route the Counter Output Event.
DAQmx_Exported_CtrOutEvent_OutputBehavior = hex2dec('174F'); % Specifies whether the exported Counter Output Event pulses or changes from one state to the other when the counter reaches terminal count.
DAQmx_Exported_CtrOutEvent_Pulse_Polarity = hex2dec('1718'); % Specifies the polarity of the pulses at the output terminal of the counter when Output Behavior is DAQmx_Val_Pulse. NI-DAQmx ignores this property if Output Behavior is DAQmx_Val_Toggle.
DAQmx_Exported_CtrOutEvent_Toggle_IdleState = hex2dec('186A'); % Specifies the initial state of the output terminal of the counter when Output Behavior is DAQmx_Val_Toggle. The terminal enters this state when NI-DAQmx commits the task.
DAQmx_Exported_SyncPulseEvent_OutputTerm = hex2dec('223C'); % Specifies the terminal to which to route the Synchronization Pulse Event.
DAQmx_Exported_WatchdogExpiredEvent_OutputTerm = hex2dec('21AA'); % Specifies the terminalto which to route the Watchdog Timer Expired Event.

%********** Device Attributes **********
DAQmx_Dev_ProductType = hex2dec('0631'); % Indicates the product name of the device.
DAQmx_Dev_SerialNum = hex2dec('0632'); % Indicates the serial number of the device. This value is zero if the device does not have a serial number.

%********** Read Attributes **********
DAQmx_Read_RelativeTo = hex2dec('190A'); % Specifies the point in the buffer at which to begin a read operation. If you also specify an offset with Offset, the read operation begins at that offset relative to the point you select with this property. The default value is DAQmx_Val_CurrReadPos unless you configure a Reference Trigger for the task. If you configure a Reference Trigger, the default value is DAQmx_Val_FirstPretrigSamp.
DAQmx_Read_Offset = hex2dec('190B'); % Specifies an offset in samples per channel at which to begin a read operation. This offset is relative to the location you specify with RelativeTo.
DAQmx_Read_ChannelsToRead = hex2dec('1823'); % Specifies a subset of channels in the task from which to read.
DAQmx_Read_ReadAllAvailSamp = hex2dec('1215'); % Specifies whether subsequent read operations read all samples currently available in the buffer or wait for the buffer to become full before reading. NI-DAQmx uses this setting for finite acquisitions and only when the number of samples to read is -1. For continuous acquisitions when the number of samples to read is -1, a read operation always reads all samples currently available in the buffer.
DAQmx_Read_AutoStart = hex2dec('1826'); % Specifies if an NI-DAQmx Read function automatically starts the taskif you did not start the task explicitly by using DAQmxStartTask(). The default value is TRUE. Whenan NI-DAQmx Read function starts a finite acquisition task, it also stops the task after reading the last sample.
DAQmx_Read_OverWrite = hex2dec('1211'); % Specifies whether to overwrite samples in the buffer that you have not yet read.
DAQmx_Read_CurrReadPos = hex2dec('1221'); % Indicates in samples per channel the current position in the buffer.
DAQmx_Read_AvailSampPerChan = hex2dec('1223'); % Indicates the number of samples available to read per channel. This value is the same for all channels in the task.
DAQmx_Read_TotalSampPerChanAcquired = hex2dec('192A'); % Indicates the total number of samples acquired by each channel. NI-DAQmx returns a single value because this value is the same for all channels.
DAQmx_Read_OverloadedChansExist = hex2dec('2174'); % Indicates if the device detected an overload in any channel in the task. Reading this property clears the overload status for all channels in the task. You must read this property before you read Overloaded Channels. Otherwise, you will receive an error.
DAQmx_Read_OverloadedChans = hex2dec('2175'); % Indicates the names of any overloaded virtual channels in the task. You must read Overloaded Channels Exist before you read this property. Otherwise, you will receive an error.
DAQmx_Read_ChangeDetect_HasOverflowed = hex2dec('2194'); % Indicates if samples were missed because change detection events occurred faster than the device could handle them. Some devices detect overflows differently than others.
DAQmx_Read_RawDataWidth = hex2dec('217A'); % Indicates in bytes the size of a raw sample from the task.
DAQmx_Read_NumChans = hex2dec('217B'); % Indicates the number of channels that an NI-DAQmx Read function reads from the task. This value is the number of channels in the task or the number of channels you specify with Channels to Read.
DAQmx_Read_DigitalLines_BytesPerChan = hex2dec('217C'); % Indicates the number of bytes per channel that NI-DAQmx returns in a sample for line-based reads. If a channel has fewer lines than this number, the extra bytes are FALSE.
DAQmx_ReadWaitMode = hex2dec('2232'); % Specifies how an NI-DAQmx Read function waits for samples to become available.

%********** Switch Channel Attributes **********
DAQmx_SwitchChan_Usage = hex2dec('18E4'); % Specifies how you can use the channel. Using this property acts as a safety mechanism to prevent you from connecting two source channels, for example.
DAQmx_SwitchChan_MaxACCarryCurrent = hex2dec('0648'); % Indicates in amperes the maximum AC current that the device can carry.
DAQmx_SwitchChan_MaxACSwitchCurrent = hex2dec('0646'); % Indicates in amperes the maximum AC current that the device can switch. This current is always against an RMS voltage level.
DAQmx_SwitchChan_MaxACCarryPwr = hex2dec('0642'); % Indicates in watts the maximum AC power that the device can carry.
DAQmx_SwitchChan_MaxACSwitchPwr = hex2dec('0644'); % Indicates in watts the maximum AC power that the device can switch.
DAQmx_SwitchChan_MaxDCCarryCurrent = hex2dec('0647'); % Indicates in amperes the maximum DC current that the device can carry.
DAQmx_SwitchChan_MaxDCSwitchCurrent = hex2dec('0645'); % Indicates in amperes the maximum DC current that the device can switch. This current is always against a DC voltage level.
DAQmx_SwitchChan_MaxDCCarryPwr = hex2dec('0643'); % Indicates in watts the maximum DC power that the device can carry.
DAQmx_SwitchChan_MaxDCSwitchPwr = hex2dec('0649'); % Indicates in watts the maximum DC power that the device can switch.
DAQmx_SwitchChan_MaxACVoltage = hex2dec('0651'); % Indicates in volts the maximum AC RMS voltage that the device can switch.
DAQmx_SwitchChan_MaxDCVoltage = hex2dec('0650'); % Indicates in volts the maximum DC voltage that the device can switch.
DAQmx_SwitchChan_WireMode = hex2dec('18E5'); % Indicates the number of wires that the channel switches.
DAQmx_SwitchChan_Bandwidth = hex2dec('0640'); % Indicates in Hertz the maximum frequency of a signal that can pass through the switch without significant deterioration.
DAQmx_SwitchChan_Impedance = hex2dec('0641'); % Indicates in ohms the switch impedance. This value is important in the RF domain and should match the impedance of the sources and loads.

%********** Switch Device Attributes **********
DAQmx_SwitchDev_SettlingTime = hex2dec('1244'); % Specifies in seconds the amount of time to wait for the switch to settle (or debounce). NI-DAQmx adds this time to the settling time of the motherboard. Modify this property only if the switch does not settle within the settling time of the motherboard. Refer to device documentation for supported settling times.
DAQmx_SwitchDev_AutoConnAnlgBus = hex2dec('17DA'); % Specifies if NI-DAQmx routes multiplexed channels to the analog bus backplane. Only the SCXI-1127 and SCXI-1128 support this property.
DAQmx_SwitchDev_Settled = hex2dec('1243'); % Indicates when Settling Time expires.
DAQmx_SwitchDev_RelayList = hex2dec('17DC'); % Indicates a comma-delimited list of relay names.
DAQmx_SwitchDev_NumRelays = hex2dec('18E6'); % Indicates the number of relays on the device. This value matches the number of relay names in Relay List.
DAQmx_SwitchDev_SwitchChanList = hex2dec('18E7'); % Indicates a comma-delimited list of channel names for the current topology of the device.
DAQmx_SwitchDev_NumSwitchChans = hex2dec('18E8'); % Indicates the number of switch channels for the current topology of the device. This value matches the number of channel names in Switch Channel List.
DAQmx_SwitchDev_NumRows = hex2dec('18E9'); % Indicates the number of rows on a device in a matrix switch topology. Indicates the number of multiplexed channels on a device in a mux topology.
DAQmx_SwitchDev_NumColumns = hex2dec('18EA'); % Indicates the number of columns on a device in a matrix switch topology. This value is always 1 if the device is in a mux topology.
DAQmx_SwitchDev_Topology = hex2dec('193D'); % Indicates the current topology of the device. This value is one of the topology options in DAQmxSwitchSetTopologyAndReset().

%********** Switch Scan Attributes **********
DAQmx_SwitchScan_BreakMode = hex2dec('1247'); % Specifies the break mode between each entry in a scan list.
DAQmx_SwitchScan_RepeatMode = hex2dec('1248'); % Specifies if the task advances through the scan list multiple times.
DAQmx_SwitchScan_WaitingForAdv = hex2dec('17D9'); % Indicates if the switch hardware is waiting for anAdvance Trigger. If the hardware is waiting, it completed the previous entry in the scan list.

%********** Scale Attributes **********
DAQmx_Scale_Descr = hex2dec('1226'); % Specifies a description for the scale.
DAQmx_Scale_ScaledUnits = hex2dec('191B'); % Specifies the units to use for scaled values. You can use an arbitrary string.
DAQmx_Scale_PreScaledUnits = hex2dec('18F7'); % Specifies the units of the values that you want to scale.
DAQmx_Scale_Type = hex2dec('1929'); % Indicates the method or equation form that the custom scale uses.
DAQmx_Scale_Lin_Slope = hex2dec('1227'); % Specifies the slope, m, in the equation y = mx+b.
DAQmx_Scale_Lin_YIntercept = hex2dec('1228'); % Specifies the y-intercept, b, in the equation y = mx+b.
DAQmx_Scale_Map_ScaledMax = hex2dec('1229'); % Specifies the largest value in the range of scaled values. NI-DAQmx maps this value to Pre-Scaled Maximum Value. Reads clip samples that are larger than this value. Writes generate errors for samples that are larger than this value.
DAQmx_Scale_Map_PreScaledMax = hex2dec('1231'); % Specifies the largest value in the range of pre-scaled values. NI-DAQmx maps this value to Scaled Maximum Value.
DAQmx_Scale_Map_ScaledMin = hex2dec('1230'); % Specifies the smallest value in the range of scaled values. NI-DAQmx maps this value to Pre-Scaled Minimum Value. Reads clip samples that are smaller than this value. Writes generate errors for samples that are smaller than this value.
DAQmx_Scale_Map_PreScaledMin = hex2dec('1232'); % Specifies the smallest value in the range of pre-scaled values. NI-DAQmx maps this value to Scaled Minimum Value.
DAQmx_Scale_Poly_ForwardCoeff = hex2dec('1234'); % Specifies an array of coefficients for the polynomial that converts pre-scaled values to scaled values. Each element of the array corresponds to a term of the equation. For example, if index three of the array is 9, the fourth term of the equation is 9x^3.
DAQmx_Scale_Poly_ReverseCoeff = hex2dec('1235'); % Specifies an array of coefficients for the polynomial that converts scaled values to pre-scaled values. Each element of the array corresponds to a term of the equation. For example, if index three of the array is 9, the fourth term of the equation is 9y^3.
DAQmx_Scale_Table_ScaledVals = hex2dec('1236'); % Specifies an array of scaled values. These values map directly to the values in Pre-Scaled Values.
DAQmx_Scale_Table_PreScaledVals = hex2dec('1237'); % Specifies an array of pre-scaled values. These values map directly to the values in Scaled Values.

%********** System Attributes **********
DAQmx_Sys_GlobalChans = hex2dec('1265'); % Indicates an array that contains the names of all global channels saved on the system.
DAQmx_Sys_Scales = hex2dec('1266'); % Indicates an array that contains the names of all custom scales saved on the system.
DAQmx_Sys_Tasks = hex2dec('1267'); % Indicates an array that contains the names of all tasks saved on the system.
DAQmx_Sys_DevNames = hex2dec('193B'); % Indicates an array that contains the names of all devices installed in the system.
DAQmx_Sys_NIDAQMajorVersion = hex2dec('1272'); % Indicates the major portion of the installed version of NI-DAQ, such as 7 for version 7.0.
DAQmx_Sys_NIDAQMinorVersion = hex2dec('1923'); % Indicates the minor portion of the installed version of NI-DAQ, such as 0 for version 7.0.

%********** Task Attributes **********
DAQmx_Task_Name = hex2dec('1276'); % Indicates the name of the task.
DAQmx_Task_Channels = hex2dec('1273'); % Indicates the names of all virtual channels in the task.
DAQmx_Task_NumChans = hex2dec('2181'); % Indicates the number of virtual channels in the task.
DAQmx_Task_Complete = hex2dec('1274'); % Indicates whether the task completed execution.

%********** Timing Attributes **********
DAQmx_SampQuant_SampMode = hex2dec('1300'); % Specifies if a task acquires or generates a finite number of samples or if it continuously acquires or generates samples.
DAQmx_SampQuant_SampPerChan = hex2dec('1310'); % Specifies the number of samples to acquire or generate for each channel if Sample Mode is DAQmx_Val_FiniteSamps. If Sample Mode is DAQmx_Val_ContSamps, NI-DAQmx uses this value to determine the buffer size.
DAQmx_SampTimingType = hex2dec('1347'); % Specifies the type of sample timing to use for the task.
DAQmx_SampClk_Rate = hex2dec('1344'); % Specifies the sampling rate in samples per channel per second. If you use an external source for the Sample Clock, set this input to the maximum expected rate of that clock.
DAQmx_SampClk_Src = hex2dec('1852'); % Specifies the terminal of the signal to use as the Sample Clock.
DAQmx_SampClk_ActiveEdge = hex2dec('1301'); % Specifies on which edge of a clock pulse sampling takes place. This property is useful primarily when the signal you use as the Sample Clock is not a periodic clock.
DAQmx_SampClk_TimebaseDiv = hex2dec('18EB'); % Specifies the number of Sample Clock Timebase pulses needed to produce a single Sample Clock pulse.
DAQmx_SampClk_Timebase_Rate = hex2dec('1303'); % Specifies the rate of the Sample Clock Timebase. Some applications require that you specify a rate when you use any signal other than the onboard Sample Clock Timebase. NI-DAQmx requires this rate to calculate other timing parameters.
DAQmx_SampClk_Timebase_Src = hex2dec('1308'); % Specifies the terminal of the signal to use as the Sample Clock Timebase.
DAQmx_SampClk_Timebase_ActiveEdge = hex2dec('18EC'); % Specifies on which edge to recognize a Sample Clock Timebase pulse. This property is useful primarily when the signal you use as the Sample Clock Timebase is not a periodic clock.
DAQmx_SampClk_Timebase_MasterTimebaseDiv = hex2dec('1305'); % Specifies the number of pulses of the Master Timebase needed to produce a single pulse of the Sample Clock Timebase.
DAQmx_SampClk_DigFltr_Enable = hex2dec('221E'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_SampClk_DigFltr_MinPulseWidth = hex2dec('221F'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_SampClk_DigFltr_TimebaseSrc = hex2dec('2220'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_SampClk_DigFltr_TimebaseRate = hex2dec('2221'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_SampClk_DigSync_Enable = hex2dec('2222'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_ChangeDetect_DI_RisingEdgePhysicalChans = hex2dec('2195'); % Specifies the names of the digital lines or ports on which to detect rising edges. The lines or ports must be used by virtual channels in the task. You also can specify a string that contains a list or range of digital lines or ports.
DAQmx_ChangeDetect_DI_FallingEdgePhysicalChans = hex2dec('2196'); % Specifies the names of the digital lines or ports on which to detect rising edges. The lines or ports must be used by virtual channels in the task. You also can specify a string that contains a list or range of digital lines or ports.
DAQmx_OnDemand_SimultaneousAOEnable = hex2dec('21A0'); % Specifies whether to update all channels in the task simultaneously, rather than updating channels independently when you write a sample to that channel.
DAQmx_AIConv_Rate = hex2dec('1848'); % Specifies the rate at which to clock the analog-to-digital converter. This clock is specific to the analog input section of an E Series device.
DAQmx_AIConv_Src = hex2dec('1502'); % Specifies the terminal of the signal to use as the AI Convert Clock.
DAQmx_AIConv_ActiveEdge = hex2dec('1853'); % Specifies on which edge of the clock pulse an analog-to-digital conversion takes place.
DAQmx_AIConv_TimebaseDiv = hex2dec('1335'); % Specifies the number of AI Convert Clock Timebase pulses needed to produce a single AI Convert Clock pulse.
DAQmx_AIConv_Timebase_Src = hex2dec('1339'); % Specifies the terminalof the signal to use as the AI Convert Clock Timebase.
DAQmx_MasterTimebase_Rate = hex2dec('1495'); % Specifies the rate of the Master Timebase.
DAQmx_MasterTimebase_Src = hex2dec('1343'); % Specifies the terminal of the signal to use as the Master Timebase. On an E Series device, you can choose only between the onboard 20MHz Timebase or the RTSI7 terminal.
DAQmx_RefClk_Rate = hex2dec('1315'); % Specifies the frequency of the Reference Clock.
DAQmx_RefClk_Src = hex2dec('1316'); % Specifies the terminal of the signal to use as the Reference Clock.
DAQmx_SyncPulse_Src = hex2dec('223D'); % Specifies the terminal of the signal to use as the synchronization pulse. The synchronization pulse resets the clock dividers and the ADCs/DACs on the device.
DAQmx_SyncPulse_SyncTime = hex2dec('223E'); % Indicates in seconds the delay required to reset the ADCs/DACs after the device receives the synchronization pulse.
DAQmx_SyncPulse_MinDelayToStart = hex2dec('223F'); % Specifies in seconds the amount of time that elapses after the master device issues the synchronization pulse before the task starts.
DAQmx_DelayFromSampClk_DelayUnits = hex2dec('1304'); % Specifies the units of Delay.
DAQmx_DelayFromSampClk_Delay = hex2dec('1317'); % Specifies the amount of time to wait after receiving a Sample Clock edge before beginning to acquire the sample. This value is in the units you specify with Delay Units.

%********** Trigger Attributes **********
DAQmx_StartTrig_Type = hex2dec('1393'); % Specifies the type of trigger to use to start a task.
DAQmx_DigEdge_StartTrig_Src = hex2dec('1407'); % Specifies the name of a terminal where there is a digital signal to use as the source of the Start Trigger.
DAQmx_DigEdge_StartTrig_Edge = hex2dec('1404'); % Specifies on which edge of a digital pulse to start acquiring or generating samples.
DAQmx_DigEdge_StartTrig_DigFltr_Enable = hex2dec('2223'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_DigEdge_StartTrig_DigFltr_MinPulseWidth = hex2dec('2224'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_DigEdge_StartTrig_DigFltr_TimebaseSrc = hex2dec('2225'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_DigEdge_StartTrig_DigFltr_TimebaseRate = hex2dec('2226'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_DigEdge_StartTrig_DigSync_Enable = hex2dec('2227'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_AnlgEdge_StartTrig_Src = hex2dec('1398'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Start Trigger.
DAQmx_AnlgEdge_StartTrig_Slope = hex2dec('1397'); % Specifies on which slope of the trigger signal to start acquiring or generating samples.
DAQmx_AnlgEdge_StartTrig_Lvl = hex2dec('1396'); % Specifies at what threshold in the units of the measurement or generation to start acquiring or generating samples. Use Slope to specify on which slope to trigger on this threshold.
DAQmx_AnlgEdge_StartTrig_Hyst = hex2dec('1395'); % Specifies a hysteresis level in the units of the measurement or generation. If Slope is DAQmx_Val_RisingSlope, the trigger does not deassert until the source signal passes belowLevel minus the hysteresis. If Slope is DAQmx_Val_FallingSlope, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
DAQmx_AnlgEdge_StartTrig_Coupling = hex2dec('2233'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_AnlgWin_StartTrig_Src = hex2dec('1400'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Start Trigger.
DAQmx_AnlgWin_StartTrig_When = hex2dec('1401'); % Specifies whether the task starts acquiring or generating samples when the signal enters or leaves the window you specify with Bottom and Top.
DAQmx_AnlgWin_StartTrig_Top = hex2dec('1403'); % Specifies the upper limit of the window. Specify this value in the units of the measurement or generation.
DAQmx_AnlgWin_StartTrig_Btm = hex2dec('1402'); % Specifies the lower limit of the window. Specify this value in the units of the measurement or generation.
DAQmx_AnlgWin_StartTrig_Coupling = hex2dec('2234'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_StartTrig_Delay = hex2dec('1856'); % Specifies an amount of time to wait after the Start Trigger is received before acquiring or generating the first sample. This value is in the units you specify with Delay Units.
DAQmx_StartTrig_DelayUnits = hex2dec('18C8'); % Specifies the units of Delay.
DAQmx_StartTrig_Retriggerable = hex2dec('190F'); % Specifies whether to enable retriggerable counter pulse generation. When you set this property to TRUE, the device generates pulses each time it receives a trigger. The device ignores a trigger if it is in the process of generating pulses.
DAQmx_RefTrig_Type = hex2dec('1419'); % Specifies the type of trigger to use to mark a reference point for the measurement.
DAQmx_RefTrig_PretrigSamples = hex2dec('1445'); % Specifies the minimum number of pretrigger samples to acquire from each channel before recognizing the reference trigger. Post-trigger samples per channel are equal to Samples Per Channel minus the number of pretrigger samples per channel.
DAQmx_DigEdge_RefTrig_Src = hex2dec('1434'); % Specifies the name of a terminal where there is a digital signal to use as the source of the Reference Trigger.
DAQmx_DigEdge_RefTrig_Edge = hex2dec('1430'); % Specifies on what edge of a digital pulse the Reference Trigger occurs.
DAQmx_AnlgEdge_RefTrig_Src = hex2dec('1424'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Reference Trigger.
DAQmx_AnlgEdge_RefTrig_Slope = hex2dec('1423'); % Specifies on which slope of the source signal the Reference Trigger occurs.
DAQmx_AnlgEdge_RefTrig_Lvl = hex2dec('1422'); % Specifies in the units of the measurement the threshold at which the Reference Trigger occurs.Use Slope to specify on which slope to trigger at this threshold.
DAQmx_AnlgEdge_RefTrig_Hyst = hex2dec('1421'); % Specifies a hysteresis level in the units of the measurement. If Slope is DAQmx_Val_RisingSlope, the trigger does not deassert until the source signal passes below Level minus the hysteresis. If Slope is DAQmx_Val_FallingSlope, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
DAQmx_AnlgEdge_RefTrig_Coupling = hex2dec('2235'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_AnlgWin_RefTrig_Src = hex2dec('1426'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Reference Trigger.
DAQmx_AnlgWin_RefTrig_When = hex2dec('1427'); % Specifies whether the Reference Trigger occurs when the source signal enters the window or when it leaves the window. Use Bottom and Top to specify the window.
DAQmx_AnlgWin_RefTrig_Top = hex2dec('1429'); % Specifies the upper limit of the window. Specify this value in the units of the measurement.
DAQmx_AnlgWin_RefTrig_Btm = hex2dec('1428'); % Specifies the lower limit of the window. Specify this value in the units of the measurement.
DAQmx_AnlgWin_RefTrig_Coupling = hex2dec('1857'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_AdvTrig_Type = hex2dec('1365'); % Specifies the type of trigger to use to advance to the next entry in a scan list.
DAQmx_DigEdge_AdvTrig_Src = hex2dec('1362'); % Specifies the name of a terminal where there is a digital signal to use as the source of the Advance Trigger.
DAQmx_DigEdge_AdvTrig_Edge = hex2dec('1360'); % Specifies on which edge of a digital signal to advance to the next entry in a scan list.
DAQmx_DigEdge_AdvTrig_DigFltr_Enable = hex2dec('2238'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_PauseTrig_Type = hex2dec('1366'); % Specifies the type of trigger to use to pause a task.
DAQmx_AnlgLvl_PauseTrig_Src = hex2dec('1370'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the trigger.
DAQmx_AnlgLvl_PauseTrig_When = hex2dec('1371'); % Specifies whether the task pauses above or below the threshold you specify with Level.
DAQmx_AnlgLvl_PauseTrig_Lvl = hex2dec('1369'); % Specifies the threshold at which to pause the task. Specify this value in the units of the measurement or generation. Use Pause When to specify whether the task pauses above or below this threshold.
DAQmx_AnlgLvl_PauseTrig_Hyst = hex2dec('1368'); % Specifies a hysteresis level in the units of the measurement or generation. If Pause When is DAQmx_Val_AboveLvl, the trigger does not deassert until the source signal passes below Level minus the hysteresis. If Pause When is DAQmx_Val_BelowLvl, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
DAQmx_AnlgLvl_PauseTrig_Coupling = hex2dec('2236'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_AnlgWin_PauseTrig_Src = hex2dec('1373'); % Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the trigger.
DAQmx_AnlgWin_PauseTrig_When = hex2dec('1374'); % Specifies whether the task pauses while the trigger signal is inside or outside the window you specify with Bottom and Top.
DAQmx_AnlgWin_PauseTrig_Top = hex2dec('1376'); % Specifies the upper limit of the window. Specify this value in the units of the measurement or generation.
DAQmx_AnlgWin_PauseTrig_Btm = hex2dec('1375'); % Specifies the lower limit of the window. Specify this value in the units of the measurement or generation.
DAQmx_AnlgWin_PauseTrig_Coupling = hex2dec('2237'); % Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
DAQmx_DigLvl_PauseTrig_Src = hex2dec('1379'); % Specifies the name of a terminal where there is a digital signal to use as the source of the Pause Trigger.
DAQmx_DigLvl_PauseTrig_When = hex2dec('1380'); % Specifies whether the task pauses while the signal is high or low.
DAQmx_DigLvl_PauseTrig_DigFltr_Enable = hex2dec('2228'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_DigLvl_PauseTrig_DigFltr_MinPulseWidth = hex2dec('2229'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseSrc = hex2dec('222A'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseRate = hex2dec('222B'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_DigLvl_PauseTrig_DigSync_Enable = hex2dec('222C'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
DAQmx_ArmStartTrig_Type = hex2dec('1414'); % Specifies the type of trigger to use to arm the task for a Start Trigger. If you configure an Arm Start Trigger, the task does not respond to a Start Trigger until the device receives the Arm Start Trigger.
DAQmx_DigEdge_ArmStartTrig_Src = hex2dec('1417'); % Specifies the name of a terminal where there is a digital signal to use as the source of the Arm Start Trigger.
DAQmx_DigEdge_ArmStartTrig_Edge = hex2dec('1415'); % Specifies on which edge of a digital signal to arm the task for a Start Trigger.
DAQmx_DigEdge_ArmStartTrig_DigFltr_Enable = hex2dec('222D'); % Specifies whether to apply the pulse width filter to the signal.
DAQmx_DigEdge_ArmStartTrig_DigFltr_MinPulseWidth = hex2dec('222E'); % Specifies in seconds the minimum pulse width the filter recognizes.
DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseSrc = hex2dec('222F'); % Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseRate = hex2dec('2230'); % Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
DAQmx_DigEdge_ArmStartTrig_DigSync_Enable = hex2dec('2231'); % Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.

%********** Watchdog Attributes **********
DAQmx_Watchdog_Timeout = hex2dec('21A9'); % Specifies in seconds the amount of time until the watchdog timer expires. A value of -1 means the internal timer never expires. Set this input to -1 if you use an Expiration Trigger to expire the watchdog task.
DAQmx_WatchdogExpirTrig_Type = hex2dec('21A3'); % Specifies the type of trigger to use to expire a watchdog task.
DAQmx_DigEdge_WatchdogExpirTrig_Src = hex2dec('21A4'); % Specifies the name of a terminal where a digital signal exists to use as the source of the Expiration Trigger.
DAQmx_DigEdge_WatchdogExpirTrig_Edge = hex2dec('21A5'); % Specifies on which edge of a digital signal to expire the watchdog task.
DAQmx_Watchdog_DO_ExpirState = hex2dec('21A7'); % Specifies the state to which to set the digital physical channels when the watchdog task expires.You cannot modify the expiration state of dedicated digital input physical channels.
DAQmx_Watchdog_HasExpired = hex2dec('21A8'); % Indicates if the watchdog timer expired. You can read this property only while the task is running.

%********** Write Attributes **********
DAQmx_Write_RelativeTo = hex2dec('190C'); % Specifies the point in the buffer at which to write data. If you also specify an offset with Offset, the write operation begins at that offset relative to this point you select with this property.
DAQmx_Write_Offset = hex2dec('190D'); % Specifies in samples per channel an offset at which a write operation begins. This offset is relative to the location you specify with Relative To.
DAQmx_Write_RegenMode = hex2dec('1453'); % Specifies whether to allow NI-DAQmx to generate the same data multiple times.
DAQmx_Write_CurrWritePos = hex2dec('1458'); % Indicates the number of the next sample for the device to generate. This value is identical for all channels in the task.
DAQmx_Write_SpaceAvail = hex2dec('1460'); % Indicates in samples per channel the amount of available space in the buffer.
DAQmx_Write_TotalSampPerChanGenerated = hex2dec('192B'); % Indicates the total number of samples generated by each channel in the task. This value is identical for all channels in the task.
DAQmx_Write_RawDataWidth = hex2dec('217D'); % Indicates in bytes the required size of a raw sample to write to the task.
DAQmx_Write_NumChans = hex2dec('217E'); % Indicates the number of channels that an NI-DAQmx Write function writes to the task. This value is the number of channels in the task.
DAQmx_Write_DigitalLines_BytesPerChan = hex2dec('217F'); % Indicates the number of bytes expected per channel in a sample for line-based writes. If a channel has fewer lines than this number, NI-DAQmx ignores the extra bytes.

%********** Physical Channel Attributes **********
DAQmx_PhysicalChan_TEDS_MfgID = hex2dec('21DA'); % Indicates the manufacturer ID of the sensor.
DAQmx_PhysicalChan_TEDS_ModelNum = hex2dec('21DB'); % Indicates the model number of the sensor.
DAQmx_PhysicalChan_TEDS_SerialNum = hex2dec('21DC'); % Indicates the serial number of the sensor.
DAQmx_PhysicalChan_TEDS_VersionNum = hex2dec('21DD'); % Indicates the version number of the sensor.
DAQmx_PhysicalChan_TEDS_VersionLetter = hex2dec('21DE'); % Indicates the version letter of the sensor.
DAQmx_PhysicalChan_TEDS_BitStream = hex2dec('21DF'); % Indicates the TEDS binary bitstream without checksums.
DAQmx_PhysicalChan_TEDS_TemplateIDs = hex2dec('228F'); % Indicates the IDs of the templates in the bitstream in BitStream.


%******************************************************************************
% *** NI-DAQmx Values **********************************************************
% ******************************************************************************/

%******************************************************/
%***Non-Attribute Function Parameter Values ***/
%******************************************************/

%*** Values for the Mode parameter of DAQmxTaskControl ***  
DAQmx_Val_Task_Start = 0; % Start
DAQmx_Val_Task_Stop =1; % Stop
DAQmx_Val_Task_Verify =2; % Verify
DAQmx_Val_Task_Commit =3; % Commit
DAQmx_Val_Task_Reserve = 4; % Reserve
DAQmx_Val_Task_Unreserve = 5; % Unreserve
DAQmx_Val_Task_Abort = 6; % Abort

%*** Values for the Action parameter of DAQmxControlWatchdogTask ***
DAQmx_Val_ResetTimer = 0; % Reset Timer
DAQmx_Val_ClearExpiration =1; % Clear Expiration

%*** Values for the Line Grouping parameter of DAQmxCreateDIChan and DAQmxCreateDOChan ***
DAQmx_Val_ChanPerLine =0; % One Channel For Each Line
DAQmx_Val_ChanForAllLines =1; % One Channel For All Lines

%*** Values for the Fill Mode parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16, DAQmxReadBinaryI32, DAQmxReadBinaryU32,
%DAQmxReadDigitalU8, DAQmxReadDigitalU32, DAQmxReadDigitalLines ***
%*** Values for the Data Layout parameter of DAQmxWriteAnalogF64, DAQmxWriteBinaryI16, DAQmxWriteDigitalU8, DAQmxWriteDigitalU32, DAQmxWriteDigitalLines ***
DAQmx_Val_GroupByChannel = 0; % Group by Channel
DAQmx_Val_GroupByScanNumber =1; % Group by Scan Number

%*** Values for the Signal Modifiers parameter of DAQmxConnectTerms ***/
DAQmx_Val_DoNotInvertPolarity =0; % Do not invert polarity
DAQmx_Val_InvertPolarity = 1; % Invert polarity

%*** Values for the Action paramter of DAQmxCloseExtCal ***
DAQmx_Val_Action_Commit =0; % Commit
DAQmx_Val_Action_Cancel =1; % Cancel

%*** Values for the Trigger ID parameter of DAQmxSendSoftwareTrigger ***
DAQmx_Val_AdvanceTrigger = 12488; % Advance Trigger

%*** Value set for the ActiveEdge parameter of DAQmxCfgSampClkTiming ***
DAQmx_Val_Rising = 10280; % Rising
DAQmx_Val_Falling =10171; % Falling

%*** Value set SwitchPathType ***
%*** Value set for the output Path Status parameter of DAQmxSwitchFindPath ***
DAQmx_Val_PathStatus_Available = 10431; % Path Available
DAQmx_Val_PathStatus_AlreadyExists = 10432; % Path Already Exists
DAQmx_Val_PathStatus_Unsupported = 10433; % Path Unsupported
DAQmx_Val_PathStatus_ChannelInUse =10434; % Channel In Use
DAQmx_Val_PathStatus_SourceChannelConflict = 10435; % Channel Source Conflict
DAQmx_Val_PathStatus_ChannelReservedForRouting = 10436; % Channel Reserved for Routing

%*** Value set for the Units parameter of DAQmxCreateAIThrmcplChan, DAQmxCreateAIRTDChan, DAQmxCreateAIThrmstrChanIex, DAQmxCreateAIThrmstrChanVex and DAQmxCreateAITempBuiltInSensorChan ***
DAQmx_Val_DegC = 10143; % Deg C
DAQmx_Val_DegF = 10144; % Deg F
DAQmx_Val_Kelvins =10325; % Kelvins
DAQmx_Val_DegR = 10145; % Deg R

%*** Value set for the state parameter of DAQmxSetDigitalPowerUpStates ***
DAQmx_Val_High = 10192; % High
DAQmx_Val_Low =10214; % Low
DAQmx_Val_Tristate = 10310; % Tristate

%*** Value set RelayPos ***
%*** Value set for the state parameter of DAQmxSwitchGetSingleRelayPos and DAQmxSwitchGetMultiRelayPos ***
DAQmx_Val_Open = 10437; % Open
DAQmx_Val_Closed = 10438; % Closed

%*** Value for the Terminal Config parameter of DAQmxCreateAIVoltageChan, DAQmxCreateAICurrentChan and DAQmxCreateAIVoltageChanWithExcit ***
DAQmx_Val_Cfg_Default =-1; % Default

%*** Value for the Timeout parameter of DAQmxWaitUntilTaskDone
DAQmx_Val_WaitInfinitely = -1.0;

%*** Value for the Number of Samples per Channel parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16,
%DAQmxReadBinaryI32, DAQmxReadBinaryU32, DAQmxReadDigitalU8, DAQmxReadDigitalU32,
%DAQmxReadDigitalLines, DAQmxReadCounterF64, DAQmxReadCounterU32 and DAQmxReadRaw ***
DAQmx_Val_Auto = -1;

%/******************************************************/
%/*** = Attribute Values = ***/
%/******************************************************/

%*** Values for DAQmx_AI_ACExcit_WireMode ***
%*** Value set ACExcitWireMode ***
DAQmx_Val_4Wire =4; % 4-Wire
DAQmx_Val_5Wire =5; % 5-Wire

%*** Values for DAQmx_AI_MeasType ***
%*** Value set AIMeasurementType ***
DAQmx_Val_Voltage =10322; % Voltage
DAQmx_Val_Current =10134; % Current
DAQmx_Val_Voltage_CustomWithExcitation = 10323; % More:Voltage:Custom with Excitation
DAQmx_Val_Freq_Voltage = 10181; % Frequency
DAQmx_Val_Resistance = 10278; % Resistance
DAQmx_Val_Temp_TC =10303; % Temperature:Thermocouple
DAQmx_Val_Temp_Thrmstr = 10302; % Temperature:Thermistor
DAQmx_Val_Temp_RTD = 10301; % Temperature:RTD
DAQmx_Val_Temp_BuiltInSensor = 10311; % Temperature:Built-in Sensor
DAQmx_Val_Strain_Gage =10300; % Strain Gage
DAQmx_Val_Position_LVDT =10352; % Position:LVDT
DAQmx_Val_Position_RVDT =10353; % Position:RVDT
DAQmx_Val_Accelerometer =10356; % Accelerometer
DAQmx_Val_SoundPressure_Microphone = 10354; % Sound Pressure:Microphone
DAQmx_Val_TEDS_Sensor =12531; % TEDS Sensor

%*** Values for DAQmx_AO_IdleOutputBehavior ***
%*** Value set AOIdleOutputBehavior ***
DAQmx_Val_ZeroVolts =12526; % Zero Volts
DAQmx_Val_HighImpedance =12527; % High Impedance
DAQmx_Val_MaintainExistingValue =12528; % Maintain Existing Value

%*** Values for DAQmx_AO_OutputType ***
%*** Value set AOOutputChannelType ***
DAQmx_Val_Voltage =10322; % Voltage
DAQmx_Val_Current =10134; % Current

%*** Values for DAQmx_AI_Accel_SensitivityUnits ***
%*** Value set AccelSensitivityUnits1 ***
DAQmx_Val_mVoltsPerG = 12509; % mVolts/g
DAQmx_Val_VoltsPerG =12510; % Volts/g

%*** Values for DAQmx_AI_Accel_Units ***
%*** Value set AccelUnits2 ***
DAQmx_Val_AccelUnit_g =10186; % g
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_SampQuant_SampMode ***
%*** Value set AcquisitionType ***
DAQmx_Val_FiniteSamps =10178; % Finite Samples
DAQmx_Val_ContSamps =10123; % Continuous Samples
DAQmx_Val_HWTimedSinglePoint = 12522; % Hardware Timed Single Point

%*** Values for DAQmx_AnlgLvl_PauseTrig_When ***
%*** Value set ActiveLevel ***
DAQmx_Val_AboveLvl = 10093; % Above Level
DAQmx_Val_BelowLvl = 10107; % Below Level

%*** Values for DAQmx_AI_RVDT_Units ***
%*** Value set AngleUnits1 ***
DAQmx_Val_Degrees =10146; % Degrees
DAQmx_Val_Radians =10273; % Radians
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_CI_AngEncoder_Units ***
%*** Value set AngleUnits2 ***
DAQmx_Val_Degrees =10146; % Degrees
DAQmx_Val_Radians =10273; % Radians
DAQmx_Val_Ticks =10304; % Ticks
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_AI_AutoZeroMode ***
%*** Value set AutoZeroType1 ***
DAQmx_Val_None = 10230; % None
DAQmx_Val_Once = 10244; % Once

%*** Values for DAQmx_SwitchScan_BreakMode ***
%*** Value set BreakMode ***
DAQmx_Val_NoAction = 10227; % No Action
DAQmx_Val_BreakBeforeMake =10110; % Break Before Make

%*** Values for DAQmx_AI_Bridge_Cfg ***
%*** Value set BridgeConfiguration1 ***
DAQmx_Val_FullBridge = 10182; % Full Bridge
DAQmx_Val_HalfBridge = 10187; % Half Bridge
DAQmx_Val_QuarterBridge =10270; % Quarter Bridge
DAQmx_Val_NoBridge = 10228; % No Bridge

%*** Values for DAQmx_CI_MeasType ***
%*** Value set CIMeasurementType ***
DAQmx_Val_CountEdges = 10125; % Count Edges
DAQmx_Val_Freq = 10179; % Frequency
DAQmx_Val_Period = 10256; % Period
DAQmx_Val_PulseWidth = 10359; % Pulse Width
DAQmx_Val_SemiPeriod = 10289; % Semi Period
DAQmx_Val_Position_AngEncoder =10360; % Position:Angular Encoder
DAQmx_Val_Position_LinEncoder =10361; % Position:Linear Encoder
DAQmx_Val_TwoEdgeSep = 10267; % Two Edge Separation

%*** Values for DAQmx_AI_Thrmcpl_CJCSrc ***
%*** Value set CJCSource1 ***
DAQmx_Val_BuiltIn =10200; % Built-In
DAQmx_Val_ConstVal = 10116; % Constant Value
DAQmx_Val_Chan = 10113; % Channel

%*** Values for DAQmx_CO_OutputType ***
%*** Value set COOutputType ***
DAQmx_Val_Pulse_Time = 10269; % Pulse:Time
DAQmx_Val_Pulse_Freq = 10119; % Pulse:Frequency
DAQmx_Val_Pulse_Ticks =10268; % Pulse:Ticks

%*** Values for DAQmx_ChanType ***
%*** Value set ChannelType ***
DAQmx_Val_AI = 10100; % Analog Input
DAQmx_Val_AO = 10102; % Analog Output
DAQmx_Val_DI = 10151; % Digital Input
DAQmx_Val_DO = 10153; % Digital Output
DAQmx_Val_CI = 10131; % Counter Input
DAQmx_Val_CO = 10132; % Counter Output

%*** Values for DAQmx_CI_CountEdges_Dir ***
%*** Value set CountDirection1 ***
DAQmx_Val_CountUp =10128; % Count Up
DAQmx_Val_CountDown =10124; % Count Down
DAQmx_Val_ExtControlled =10326; % Externally Controlled

%*** Values for DAQmx_CI_Freq_MeasMeth ***
%*** Values for DAQmx_CI_Period_MeasMeth ***
%*** Value set CounterFrequencyMethod ***
DAQmx_Val_LowFreq1Ctr =10105; % Low Frequency with 1 Counter
DAQmx_Val_HighFreq2Ctr = 10157; % High Frequency with 2 Counters
DAQmx_Val_LargeRng2Ctr = 10205; % Large Range with 2 Counters

%*** Values for DAQmx_AI_Coupling ***
%*** Value set Coupling1 ***
DAQmx_Val_AC = 10045; % AC
DAQmx_Val_DC = 10050; % DC
DAQmx_Val_GND =10066; % GND

%*** Values for DAQmx_AnlgEdge_StartTrig_Coupling ***
%*** Values for DAQmx_AnlgWin_StartTrig_Coupling ***
%*** Values for DAQmx_AnlgEdge_RefTrig_Coupling ***
%*** Values for DAQmx_AnlgWin_RefTrig_Coupling ***
%*** Values for DAQmx_AnlgLvl_PauseTrig_Coupling ***
%*** Values for DAQmx_AnlgWin_PauseTrig_Coupling ***
%*** Value set Coupling2 ***
DAQmx_Val_AC = 10045; % AC
DAQmx_Val_DC = 10050; % DC

%*** Values for DAQmx_AI_CurrentShunt_Loc ***
%*** Value set CurrentShuntResistorLocation1 ***
DAQmx_Val_Internal = 10200; % Internal
DAQmx_Val_External = 10167; % External

%*** Values for DAQmx_AI_Current_Units ***
%*** Values for DAQmx_AO_Current_Units ***
%*** Value set CurrentUnits1 ***
DAQmx_Val_Amps = 10342; % Amps
DAQmx_Val_FromCustomScale =10065; % From Custom Scale
DAQmx_Val_FromTEDS = 12516; % From TEDS

%*** Value set CurrentUnits2 ***
DAQmx_Val_Amps = 10342; % Amps
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_AI_DataXferMech ***
%*** Values for DAQmx_AO_DataXferMech ***
%*** Values for DAQmx_DI_DataXferMech ***
%*** Values for DAQmx_DO_DataXferMech ***
%*** Values for DAQmx_CI_DataXferMech ***
%*** Value set DataTransferMechanism ***
DAQmx_Val_DMA =10054; % DMA
DAQmx_Val_Interrupts = 10204; % Interrupts
DAQmx_Val_ProgrammedIO = 10264; % Programmed I/O

%*** Values for DAQmx_Watchdog_DO_ExpirState ***
%*** Value set DigitalLineState ***
DAQmx_Val_High = 10192; % High
DAQmx_Val_Low =10214; % Low
DAQmx_Val_Tristate = 10310; % Tristate
DAQmx_Val_NoChange = 10160; % No Change

%*** Values for DAQmx_StartTrig_DelayUnits ***
%*** Value set DigitalWidthUnits1 ***
DAQmx_Val_SampClkPeriods = 10286; % Sample Clock Periods
DAQmx_Val_Seconds =10364; % Seconds
DAQmx_Val_Ticks =10304; % Ticks

%*** Values for DAQmx_DelayFromSampClk_DelayUnits ***
%*** Value set DigitalWidthUnits2 ***
DAQmx_Val_Seconds =10364; % Seconds
DAQmx_Val_Ticks =10304; % Ticks

%*** Values for DAQmx_Exported_AdvTrig_Pulse_WidthUnits ***
%*** Value set DigitalWidthUnits3 ***
DAQmx_Val_Seconds =10364; % Seconds

%*** Values for DAQmx_CI_Freq_StartingEdge ***
%*** Values for DAQmx_CI_Period_StartingEdge ***
%*** Values for DAQmx_CI_CountEdges_ActiveEdge ***
%*** Values for DAQmx_CI_PulseWidth_StartingEdge ***
%*** Values for DAQmx_CI_TwoEdgeSep_FirstEdge ***
%*** Values for DAQmx_CI_TwoEdgeSep_SecondEdge ***
%*** Values for DAQmx_CI_CtrTimebaseActiveEdge ***
%*** Values for DAQmx_CO_CtrTimebaseActiveEdge ***
%*** Values for DAQmx_SampClk_ActiveEdge ***
%*** Values for DAQmx_SampClk_Timebase_ActiveEdge ***
%*** Values for DAQmx_AIConv_ActiveEdge ***
%*** Values for DAQmx_DigEdge_StartTrig_Edge ***
%*** Values for DAQmx_DigEdge_RefTrig_Edge ***
%*** Values for DAQmx_DigEdge_AdvTrig_Edge ***
%*** Values for DAQmx_DigEdge_ArmStartTrig_Edge ***
%*** Values for DAQmx_DigEdge_WatchdogExpirTrig_Edge ***
%*** Value set Edge1 ***
DAQmx_Val_Rising = 10280; % Rising
DAQmx_Val_Falling =10171; % Falling

%*** Values for DAQmx_CI_Encoder_DecodingType ***
%*** Value set EncoderType2 ***
DAQmx_Val_X1 = 10090; % X1
DAQmx_Val_X2 = 10091; % X2
DAQmx_Val_X4 = 10092; % X4
DAQmx_Val_TwoPulseCounting = 10313; % Two Pulse Counting

%*** Values for DAQmx_CI_Encoder_ZIndexPhase ***
%*** Value set EncoderZIndexPhase1 ***
DAQmx_Val_AHighBHigh = 10040; % A High B High
DAQmx_Val_AHighBLow =10041; % A High B Low
DAQmx_Val_ALowBHigh =10042; % A Low B High
DAQmx_Val_ALowBLow = 10043; % A Low B Low

%*** Values for DAQmx_AI_Excit_DCorAC ***
%*** Value set ExcitationDCorAC ***
DAQmx_Val_DC = 10050; % DC
DAQmx_Val_AC = 10045; % AC

%*** Values for DAQmx_AI_Excit_Src ***
%*** Value set ExcitationSource ***
DAQmx_Val_Internal = 10200; % Internal
DAQmx_Val_External = 10167; % External
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_AI_Excit_VoltageOrCurrent ***
%*** Value set ExcitationVoltageOrCurrent ***
DAQmx_Val_Voltage =10322; % Voltage
DAQmx_Val_Current =10134; % Current

%*** Values for DAQmx_Exported_CtrOutEvent_OutputBehavior ***
%*** Value set ExportActions2 ***
DAQmx_Val_Pulse =10265; % Pulse
DAQmx_Val_Toggle = 10307; % Toggle

%*** Values for DAQmx_Exported_SampClk_OutputBehavior ***
%*** Value set ExportActions3 ***
DAQmx_Val_Pulse =10265; % Pulse
DAQmx_Val_Lvl =10210; % Level

%*** Values for DAQmx_AI_Freq_Units ***
%*** Value set FrequencyUnits ***
DAQmx_Val_Hz = 10373; % Hz
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_CO_Pulse_Freq_Units ***
%*** Value set FrequencyUnits2 ***
DAQmx_Val_Hz = 10373; % Hz

%*** Values for DAQmx_CI_Freq_Units ***
%*** Value set FrequencyUnits3 ***
DAQmx_Val_Hz = 10373; % Hz
DAQmx_Val_Ticks =10304; % Ticks
DAQmx_Val_FromCustomScale =10065; % From Custom Scale


%*** Values for DAQmx_AI_DataXferReqCond ***
%*** Values for DAQmx_DI_DataXferReqCond ***
%*** Value set InputDataTransferCondition ***
DAQmx_Val_OnBrdMemMoreThanHalfFull = 10237; % On Board Memory More than Half Full
DAQmx_Val_OnBrdMemNotEmpty = 10241; % On Board Memory Not Empty

%*** Values for DAQmx_AI_TermCfg ***
%*** Value set InputTermCfg ***
DAQmx_Val_RSE =10083; % RSE
DAQmx_Val_NRSE = 10078; % NRSE
DAQmx_Val_Diff = 10106; % Differential
DAQmx_Val_PseudoDiff = 12529; % Pseudodifferential

%*** Values for DAQmx_AI_LVDT_SensitivityUnits ***
%*** Value set LVDTSensitivityUnits1 ***
DAQmx_Val_mVoltsPerVoltPerMillimeter = 12506; % mVolts/Volt/mMeter
DAQmx_Val_mVoltsPerVoltPerMilliInch =12505; % mVolts/Volt/0.001 Inch

%*** Values for DAQmx_AI_LVDT_Units ***
%*** Value set LengthUnits2 ***
DAQmx_Val_Meters = 10219; % Meters
DAQmx_Val_Inches = 10379; % Inches
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_CI_LinEncoder_Units ***
%*** Value set LengthUnits3 ***
DAQmx_Val_Meters = 10219; % Meters
DAQmx_Val_Inches = 10379; % Inches
DAQmx_Val_Ticks =10304; % Ticks
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_CI_OutputState ***
%*** Values for DAQmx_CO_Pulse_IdleState ***
%*** Values for DAQmx_CO_OutputState ***
%*** Values for DAQmx_Exported_CtrOutEvent_Toggle_IdleState ***
%*** Values for DAQmx_DigLvl_PauseTrig_When ***
%*** Value set Level1 ***
DAQmx_Val_High = 10192; % High
DAQmx_Val_Low =10214; % Low

%*** Values for DAQmx_AIConv_Timebase_Src ***
%*** Value set MIOAIConvertTbSrc ***
DAQmx_Val_SameAsSampTimebase = 10284; % Same as Sample Timebase
DAQmx_Val_SameAsMasterTimebase = 10282; % Same as Master Timebase
DAQmx_Val_20MHzTimebase =12537; % 20MHz Timebase

%*** Values for DAQmx_AO_DataXferReqCond ***
%*** Values for DAQmx_DO_DataXferReqCond ***
%*** Value set OutputDataTransferCondition ***
DAQmx_Val_OnBrdMemEmpty =10235; % On Board Memory Empty
DAQmx_Val_OnBrdMemHalfFullOrLess = 10239; % On Board Memory Half Full or Less
DAQmx_Val_OnBrdMemNotFull =10242; % On Board Memory Less than Full

%*** Values for DAQmx_AO_TermCfg ***
%*** Value set OutputTermCfg ***
DAQmx_Val_RSE =10083; % RSE
DAQmx_Val_Diff = 10106; % Differential
DAQmx_Val_PseudoDiff = 12529; % Pseudodifferential

%*** Values for DAQmx_Read_OverWrite ***
%*** Value set OverwriteMode1 ***
DAQmx_Val_OverwriteUnreadSamps = 10252; % Overwrite Unread Samples
DAQmx_Val_DoNotOverwriteUnreadSamps =10159; % Do Not Overwrite Unread Samples

%*** Values for DAQmx_Exported_AIConvClk_Pulse_Polarity ***
%*** Values for DAQmx_Exported_AdvTrig_Pulse_Polarity ***
%*** Values for DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity ***
%*** Values for DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity ***
%*** Values for DAQmx_Exported_CtrOutEvent_Pulse_Polarity ***
%*** Value set Polarity2 ***
DAQmx_Val_ActiveHigh = 10095; % Active High
DAQmx_Val_ActiveLow =10096; % Active Low


%*** Values for DAQmx_AI_RTD_Type ***
%*** Value set RTDType1 ***
DAQmx_Val_Pt3750 = 12481; % Pt3750
DAQmx_Val_Pt3851 = 10071; % Pt3851
DAQmx_Val_Pt3911 = 12482; % Pt3911
DAQmx_Val_Pt3916 = 10069; % Pt3916
DAQmx_Val_Pt3920 = 10053; % Pt3920
DAQmx_Val_Pt3928 = 12483; % Pt3928
DAQmx_Val_Custom = 10137; % Custom

%*** Values for DAQmx_AI_RVDT_SensitivityUnits ***
%*** Value set RVDTSensitivityUnits1 ***
DAQmx_Val_mVoltsPerVoltPerDegree = 12507; % mVolts/Volt/Degree
DAQmx_Val_mVoltsPerVoltPerRadian = 12508; % mVolts/Volt/Radian

%*** Values for DAQmx_Read_RelativeTo ***
%*** Value set ReadRelativeTo ***
DAQmx_Val_FirstSample =10424; % First Sample
DAQmx_Val_CurrReadPos =10425; % Current Read Position
DAQmx_Val_RefTrig =10426; % Reference Trigger
DAQmx_Val_FirstPretrigSamp = 10427; % First Pretrigger Sample
DAQmx_Val_MostRecentSamp = 10428; % Most Recent Sample


%*** Values for DAQmx_Write_RegenMode ***
%*** Value set RegenerationMode1 ***
DAQmx_Val_AllowRegen = 10097; % Allow Regeneration
DAQmx_Val_DoNotAllowRegen =10158; % Do Not Allow Regeneration

%*** Values for DAQmx_AI_ResistanceCfg ***
%*** Value set ResistanceConfiguration ***
DAQmx_Val_2Wire =2; % 2-Wire
DAQmx_Val_3Wire =3; % 3-Wire
DAQmx_Val_4Wire =4; % 4-Wire

%*** Values for DAQmx_AI_Resistance_Units ***
%*** Value set ResistanceUnits1 ***
DAQmx_Val_Ohms = 10384; % Ohms
DAQmx_Val_FromCustomScale =10065; % From Custom Scale
DAQmx_Val_FromTEDS = 12516; % From TEDS

%*** Value set ResistanceUnits2 ***
DAQmx_Val_Ohms = 10384; % Ohms
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_AI_ResolutionUnits ***
%*** Values for DAQmx_AO_ResolutionUnits ***
%*** Value set ResolutionType1 ***
DAQmx_Val_Bits = 10109; % Bits

%*** Values for DAQmx_SampTimingType ***
%*** Value set SampleTimingType ***
DAQmx_Val_SampClk =10388; % Sample Clock
DAQmx_Val_Handshake =10389; % Handshake
DAQmx_Val_Implicit = 10451; % Implicit
DAQmx_Val_OnDemand = 10390; % On Demand
DAQmx_Val_ChangeDetection =12504; % Change Detection

%*** Values for DAQmx_Scale_Type ***
%*** Value set ScaleType ***
DAQmx_Val_Linear = 10447; % Linear
DAQmx_Val_MapRanges =10448; % Map Ranges
DAQmx_Val_Polynomial = 10449; % Polynomial
DAQmx_Val_Table =10450; % Table

%*** Values for DAQmx_AI_Bridge_ShuntCal_Select ***
%*** Value set ShuntCalSelect ***
DAQmx_Val_A =12513; % A
DAQmx_Val_B =12514; % B
DAQmx_Val_AandB =12515; % A and B

%*** Value set Signal ***
DAQmx_Val_AIConvertClock = 12484; % AI Convert Clock
DAQmx_Val_10MHzRefClock =12536; % 10MHz Reference Clock
DAQmx_Val_20MHzTimebaseClock = 12486; % 20MHz Timebase Clock
DAQmx_Val_SampleClock =12487; % Sample Clock
DAQmx_Val_AdvanceTrigger = 12488; % Advance Trigger
DAQmx_Val_ReferenceTrigger = 12490; % Reference Trigger
DAQmx_Val_StartTrigger = 12491; % Start Trigger
DAQmx_Val_AdvCmpltEvent =12492; % Advance Complete Event
DAQmx_Val_AIHoldCmpltEvent = 12493; % AI Hold Complete Event
DAQmx_Val_CounterOutputEvent = 12494; % Counter Output Event
DAQmx_Val_ChangeDetectionEvent = 12511; % Change Detection Event
DAQmx_Val_WDTExpiredEvent =12512; % Watchdog Timer Expired Event

%*** Values for DAQmx_AnlgEdge_StartTrig_Slope ***
%*** Values for DAQmx_AnlgEdge_RefTrig_Slope ***
%*** Value set Slope1 ***
DAQmx_Val_RisingSlope =10280; % Rising
DAQmx_Val_FallingSlope = 10171; % Falling

%*** Values for DAQmx_AI_SoundPressure_Units ***
%*** Value set SoundPressureUnits1 ***
DAQmx_Val_Pascals =10081; % Pascals
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_AI_Lowpass_SwitchCap_ClkSrc ***
%*** Values for DAQmx_AO_DAC_Ref_Src ***
%*** Values for DAQmx_AO_DAC_Offset_Src ***
%*** Value set SourceSelection ***
DAQmx_Val_Internal = 10200; % Internal
DAQmx_Val_External = 10167; % External

%*** Values for DAQmx_AI_StrainGage_Cfg ***
%*** Value set StrainGageBridgeType1 ***
DAQmx_Val_FullBridgeI =10183; % Full Bridge I
DAQmx_Val_FullBridgeII = 10184; % Full Bridge II
DAQmx_Val_FullBridgeIII =10185; % Full Bridge III
DAQmx_Val_HalfBridgeI =10188; % Half Bridge I
DAQmx_Val_HalfBridgeII = 10189; % Half Bridge II
DAQmx_Val_QuarterBridgeI = 10271; % Quarter Bridge I
DAQmx_Val_QuarterBridgeII =10272; % Quarter Bridge II

%*** Values for DAQmx_AI_Strain_Units ***
%*** Value set StrainUnits1 ***
DAQmx_Val_Strain = 10299; % Strain
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_SwitchScan_RepeatMode ***
%*** Value set SwitchScanRepeatMode ***
DAQmx_Val_Finite = 10172; % Finite
DAQmx_Val_Cont = 10117; % Continuous

%*** Values for DAQmx_SwitchChan_Usage ***
%*** Value set SwitchUsageTypes ***
DAQmx_Val_Source = 10439; % Source
DAQmx_Val_Load = 10440; % Load
DAQmx_Val_ReservedForRouting = 10441; % Reserved for Routing

%*** Value set TEDSUnits ***
DAQmx_Val_FromCustomScale =10065; % From Custom Scale
DAQmx_Val_FromTEDS = 12516; % From TEDS

%*** Values for DAQmx_AI_Temp_Units ***
%*** Value set TemperatureUnits1 ***
DAQmx_Val_DegC = 10143; % Deg C
DAQmx_Val_DegF = 10144; % Deg F
DAQmx_Val_Kelvins =10325; % Kelvins
DAQmx_Val_DegR = 10145; % Deg R
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_AI_Thrmcpl_Type ***
%*** Value set ThermocoupleType1 ***
DAQmx_Val_J_Type_TC =10072; % J
DAQmx_Val_K_Type_TC =10073; % K
DAQmx_Val_N_Type_TC =10077; % N
DAQmx_Val_R_Type_TC =10082; % R
DAQmx_Val_S_Type_TC =10085; % S
DAQmx_Val_T_Type_TC =10086; % T
DAQmx_Val_B_Type_TC =10047; % B
DAQmx_Val_E_Type_TC =10055; % E

%*** Values for DAQmx_CO_Pulse_Time_Units ***
%*** Value set TimeUnits2 ***
DAQmx_Val_Seconds =10364; % Seconds

%*** Values for DAQmx_CI_Period_Units ***
%*** Values for DAQmx_CI_PulseWidth_Units ***
%*** Values for DAQmx_CI_TwoEdgeSep_Units ***
%*** Values for DAQmx_CI_SemiPeriod_Units ***
%*** Value set TimeUnits3 ***
DAQmx_Val_Seconds =10364; % Seconds
DAQmx_Val_Ticks =10304; % Ticks
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_RefTrig_Type ***
%*** Value set TriggerType1 ***
DAQmx_Val_AnlgEdge = 10099; % Analog Edge
DAQmx_Val_DigEdge =10150; % Digital Edge
DAQmx_Val_AnlgWin =10103; % Analog Window
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_ArmStartTrig_Type ***
%*** Values for DAQmx_WatchdogExpirTrig_Type ***
%*** Value set TriggerType4 ***
DAQmx_Val_DigEdge =10150; % Digital Edge
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_AdvTrig_Type ***
%*** Value set TriggerType5 ***
DAQmx_Val_DigEdge =10150; % Digital Edge
DAQmx_Val_Software = 10292; % Software
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_PauseTrig_Type ***
%*** Value set TriggerType6 ***
DAQmx_Val_AnlgLvl =10101; % Analog Level
DAQmx_Val_AnlgWin =10103; % Analog Window
DAQmx_Val_DigLvl = 10152; % Digital Level
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_StartTrig_Type ***
%*** Value set TriggerType8 ***
DAQmx_Val_AnlgEdge = 10099; % Analog Edge
DAQmx_Val_DigEdge =10150; % Digital Edge
DAQmx_Val_AnlgWin =10103; % Analog Window
DAQmx_Val_None = 10230; % None

%*** Values for DAQmx_Scale_PreScaledUnits ***
%*** Value set UnitsPreScaled ***
DAQmx_Val_Volts =10348; % Volts
DAQmx_Val_Amps = 10342; % Amps
DAQmx_Val_DegF = 10144; % Deg F
DAQmx_Val_DegC = 10143; % Deg C
DAQmx_Val_DegR = 10145; % Deg R
DAQmx_Val_Kelvins =10325; % Kelvins
DAQmx_Val_Strain = 10299; % Strain
DAQmx_Val_Ohms = 10384; % Ohms
DAQmx_Val_Hz = 10373; % Hz
DAQmx_Val_Seconds =10364; % Seconds
DAQmx_Val_Meters = 10219; % Meters
DAQmx_Val_Inches = 10379; % Inches
DAQmx_Val_Degrees =10146; % Degrees
DAQmx_Val_Radians =10273; % Radians
DAQmx_Val_g =10186; % g
DAQmx_Val_Pascals =10081; % Pascals
DAQmx_Val_FromTEDS = 12516; % From TEDS

%*** Values for DAQmx_AI_Voltage_Units ***
%*** Value set VoltageUnits1 ***
DAQmx_Val_Volts =10348; % Volts
DAQmx_Val_FromCustomScale =10065; % From Custom Scale
DAQmx_Val_FromTEDS = 12516; % From TEDS

%*** Values for DAQmx_AO_Voltage_Units ***
%*** Value set VoltageUnits2 ***
DAQmx_Val_Volts =10348; % Volts
DAQmx_Val_FromCustomScale =10065; % From Custom Scale

%*** Values for DAQmx_ReadWaitMode ***
%*** Value set WaitMode ***
DAQmx_Val_WaitForInterrupt = 12523; % Wait For Interrupt
DAQmx_Val_Poll = 12524; % Poll
DAQmx_Val_Yield =12525; % Yield

%*** Values for DAQmx_AnlgWin_StartTrig_When ***
%*** Values for DAQmx_AnlgWin_RefTrig_When ***
%*** Value set WindowTriggerCondition1 ***
DAQmx_Val_EnteringWin =10163; % Entering Window
DAQmx_Val_LeavingWin = 10208; % Leaving Window

%*** Values for DAQmx_AnlgWin_PauseTrig_When ***
%*** Value set WindowTriggerCondition2 ***
DAQmx_Val_InsideWin =10199; % Inside Window
DAQmx_Val_OutsideWin = 10251; % Outside Window

%*** Value set WriteBasicTEDSOptions ***
DAQmx_Val_WriteToEEPROM =12538; % Write To EEPROM
DAQmx_Val_WriteToPROM =12539; % Write To PROM Once
DAQmx_Val_DoNotWrite = 12540; % Do Not Write

%*** Values for DAQmx_Write_RelativeTo ***
%*** Value set WriteRelativeTo ***
DAQmx_Val_FirstSample =10424; % First Sample
DAQmx_Val_CurrWritePos = 10430; % Current Write Position



%/******************************************************************************
% *** NI-DAQmx Error Codes *****************************************************
% ******************************************************************************/

DAQmxSuccess = (0);

%DAQmxFailed(error); = ((error);<0);

% Error and Warning Codes
DAQmxErrorWriteNotCompleteBeforeSampClk =(-209801);
DAQmxErrorReadNotCompleteBeforeSampClk = (-209800);
DAQmxErrorEveryNSamplesEventNotSupportedForNonBufferedTasks =(-200848);
DAQmxErrorBufferedAndDataXferPIO = (-200847);
DAQmxErrorCannotWriteWhenAutoStartFalseAndTaskNotRunning = (-200846);
DAQmxErrorNonBufferedAndDataXferInterrupts = (-200845);
DAQmxErrorWriteFailedMultipleCtrsWithFREQOUT = (-200844);
DAQmxErrorReadNotCompleteBefore3SampClkEdges = (-200843);
DAQmxErrorCtrHWTimedSinglePointAndDataXferNotProgIO =(-200842);
DAQmxErrorPrescalerNot1ForInputTerminal =(-200841);
DAQmxErrorPrescalerNot1ForTimebaseSrc =(-200840);
DAQmxErrorSampClkTimingTypeWhenTristateIsFalse = (-200839);
DAQmxErrorOutputBufferSizeNotMultOfXferSize =(-200838);
DAQmxErrorSampPerChanNotMultOfXferSize = (-200837);
DAQmxErrorWriteToTEDSFailed =(-200836);
DAQmxErrorSCXIDevNotUsablePowerTurnedOff = (-200835);
DAQmxErrorCannotReadWhenAutoStartFalseBufSizeZeroAndTaskNotRunning = (-200834);
DAQmxErrorCannotReadWhenAutoStartFalseHWTimedSinglePtAndTaskNotRunning = (-200833);
DAQmxErrorCannotReadWhenAutoStartFalseOnDemandAndTaskNotRunning =(-200832);
DAQmxErrorSimultaneousAOWhenNotOnDemandTiming =(-200831);
DAQmxErrorMemMapAndSimultaneousAO =(-200830);
DAQmxErrorWriteFailedMultipleCOOutputTypes = (-200829);
DAQmxErrorWriteToTEDSNotSupportedOnRT =(-200828);
DAQmxErrorVirtualTEDSDataFileError = (-200827);
DAQmxErrorTEDSSensorDataError =(-200826);
DAQmxErrorDataSizeMoreThanSizeOfEEPROMOnTEDS = (-200825);
DAQmxErrorPROMOnTEDSContainsBasicTEDSData =(-200824);
DAQmxErrorPROMOnTEDSAlreadyWritten = (-200823);
DAQmxErrorTEDSDoesNotContainPROM = (-200822);
DAQmxErrorHWTimedSinglePointNotSupportedAI = (-200821);
DAQmxErrorHWTimedSinglePointOddNumChansInAITask =(-200820);
DAQmxErrorCantUseOnlyOnBoardMemWithProgrammedIO =(-200819);
DAQmxErrorSwitchDevShutDownDueToHighTemp = (-200818);
DAQmxErrorExcitationNotSupportedWhenTermCfgDiff =(-200817);
DAQmxErrorTEDSMinElecValGEMaxElecVal = (-200816);
DAQmxErrorTEDSMinPhysValGEMaxPhysVal = (-200815);
DAQmxErrorCIOnboardClockNotSupportedAsInputTerm =(-200814);
DAQmxErrorInvalidSampModeForPositionMeas = (-200813);
DAQmxErrorTrigWhenAOHWTimedSinglePtSampMode =(-200812);
DAQmxErrorDAQmxCantUseStringDueToUnknownChar = (-200811);
DAQmxErrorDAQmxCantRetrieveStringDueToUnknownChar =(-200810);
DAQmxErrorClearTEDSNotSupportedOnRT =(-200809);
DAQmxErrorCfgTEDSNotSupportedOnRT =(-200808);
DAQmxErrorProgFilterClkCfgdToDifferentMinPulseWidthBySameTask1PerDev = (-200807);
DAQmxErrorProgFilterClkCfgdToDifferentMinPulseWidthByAnotherTask1PerDev = (-200806);
DAQmxErrorNoLastExtCalDateTimeLastExtCalNotDAQmx = (-200804);
DAQmxErrorCannotWriteNotStartedAutoStartFalseNotOnDemandHWTimedSglPt = (-200803);
DAQmxErrorCannotWriteNotStartedAutoStartFalseNotOnDemandBufSizeZero =(-200802);
DAQmxErrorCOInvalidTimingSrcDueToSignal =(-200801);
DAQmxErrorCIInvalidTimingSrcForSampClkDueToSampTimingType =(-200800);
DAQmxErrorCIInvalidTimingSrcForEventCntDueToSampMode = (-200799);
DAQmxErrorNoChangeDetectOnNonInputDigLineForDev =(-200798);
DAQmxErrorEmptyStringTermNameNotSupported =(-200797);
DAQmxErrorMemMapEnabledForHWTimedNonBufferedAO = (-200796);
DAQmxErrorDevOnboardMemOverflowDuringHWTimedNonBufferedGen = (-200795);
DAQmxErrorCODAQmxWriteMultipleChans =(-200794);
DAQmxErrorCantMaintainExistingValueAOSync =(-200793);
DAQmxErrorMStudioMultiplePhysChansNotSupported = (-200792);
DAQmxErrorCantConfigureTEDSForChan = (-200791);
DAQmxErrorWriteDataTypeTooSmall =(-200790);
DAQmxErrorReadDataTypeTooSmall = (-200789);
DAQmxErrorMeasuredBridgeOffsetTooHigh =(-200788);
DAQmxErrorStartTrigConflictWithCOHWTimedSinglePt = (-200787);
DAQmxErrorSampClkRateExtSampClkTimebaseRateMismatch =(-200786);
DAQmxErrorInvalidTimingSrcDueToSampTimingType =(-200785);
DAQmxErrorVirtualTEDSFileNotFound =(-200784);
DAQmxErrorMStudioNoForwardPolyScaleCoeffs =(-200783);
DAQmxErrorMStudioNoReversePolyScaleCoeffs =(-200782);
DAQmxErrorMStudioNoPolyScaleCoeffsUseCalc =(-200781);
DAQmxErrorMStudioNoForwardPolyScaleCoeffsUseCalc = (-200780);
DAQmxErrorMStudioNoReversePolyScaleCoeffsUseCalc = (-200779);
DAQmxErrorCOSampModeSampTimingTypeSampClkConflict =(-200778);
DAQmxErrorDevCannotProduceMinPulseWidth =(-200777);
DAQmxErrorCannotProduceMinPulseWidthGivenPropertyValues =(-200776);
DAQmxErrorTermCfgdToDifferentMinPulseWidthByAnotherTask =(-200775);
DAQmxErrorTermCfgdToDifferentMinPulseWidthByAnotherProperty =(-200774);
DAQmxErrorDigSyncNotAvailableOnTerm =(-200773);
DAQmxErrorDigFilterNotAvailableOnTerm =(-200772);
DAQmxErrorDigFilterEnabledMinPulseWidthNotCfg =(-200771);
DAQmxErrorDigFilterAndSyncBothEnabled =(-200770);
DAQmxErrorHWTimedSinglePointAOAndDataXferNotProgIO = (-200769);
DAQmxErrorNonBufferedAOAndDataXferNotProgIO =(-200768);
DAQmxErrorProgIODataXferForBufferedAO =(-200767);
DAQmxErrorTEDSLegacyTemplateIDInvalidOrUnsupported = (-200766);
DAQmxErrorTEDSMappingMethodInvalidOrUnsupported =(-200765);
DAQmxErrorTEDSLinearMappingSlopeZero = (-200764);
DAQmxErrorAIInputBufferSizeNotMultOfXferSize = (-200763);
DAQmxErrorNoSyncPulseExtSampClkTimebase =(-200762);
DAQmxErrorNoSyncPulseAnotherTaskRunning =(-200761);
DAQmxErrorAOMinMaxNotInGainRange = (-200760);
DAQmxErrorAOMinMaxNotInDACRange =(-200759);
DAQmxErrorDevOnlySupportsSampClkTimingAO = (-200758);
DAQmxErrorDevOnlySupportsSampClkTimingAI = (-200757);
DAQmxErrorTEDSIncompatibleSensorAndMeasType =(-200756);
DAQmxErrorTEDSMultipleCalTemplatesNotSupported = (-200755);
DAQmxErrorTEDSTemplateParametersNotSupported = (-200754);
DAQmxErrorParsingTEDSData =(-200753);
DAQmxErrorMultipleActivePhysChansNotSupported =(-200752);
DAQmxErrorNoChansSpecdForChangeDetect =(-200751);
DAQmxErrorInvalidCalVoltageForGivenGain =(-200750);
DAQmxErrorInvalidCalGain = (-200749);
DAQmxErrorMultipleWritesBetweenSampClks =(-200748);
DAQmxErrorInvalidAcqTypeForFREQOUT = (-200747);
DAQmxErrorSuitableTimebaseNotFoundTimeCombo2 = (-200746);
DAQmxErrorSuitableTimebaseNotFoundFrequencyCombo2 =(-200745);
DAQmxErrorRefClkRateRefClkSrcMismatch =(-200744);
DAQmxErrorNoTEDSTerminalBlock =(-200743);
DAQmxErrorCorruptedTEDSMemory =(-200742);
DAQmxErrorTEDSNotSupported = (-200741);
DAQmxErrorTimingSrcTaskStartedBeforeTimedLoop =(-200740);
DAQmxErrorPropertyNotSupportedForTimingSrc = (-200739);
DAQmxErrorTimingSrcDoesNotExist =(-200738);
DAQmxErrorInputBufferSizeNotEqualSampsPerChanForFiniteSampMode = (-200737);
DAQmxErrorFREQOUTCannotProduceDesiredFrequency2 =(-200736);
DAQmxErrorExtRefClkRateNotSpecified =(-200735);
DAQmxErrorDeviceDoesNotSupportDMADataXferForNonBufferedAcq = (-200734);
DAQmxErrorDigFilterMinPulseWidthSetWhenTristateIsFalse = (-200733);
DAQmxErrorDigFilterEnableSetWhenTristateIsFalse =(-200732);
DAQmxErrorNoHWTimingWithOnDemand = (-200731);
DAQmxErrorCannotDetectChangesWhenTristateIsFalse = (-200730);
DAQmxErrorCannotHandshakeWhenTristateIsFalse = (-200729);
DAQmxErrorLinesUsedForStaticInputNotForHandshakingControl =(-200728);
DAQmxErrorLinesUsedForHandshakingControlNotForStaticInput =(-200727);
DAQmxErrorLinesUsedForStaticInputNotForHandshakingInput =(-200726);
DAQmxErrorLinesUsedForHandshakingInputNotForStaticInput =(-200725);
DAQmxErrorDifferentDITristateValsForChansInTask =(-200724);
DAQmxErrorTimebaseCalFreqVarianceTooLarge =(-200723);
DAQmxErrorTimebaseCalFailedToConverge =(-200722);
DAQmxErrorInadequateResolutionForTimebaseCal = (-200721);
DAQmxErrorInvalidAOGainCalConst =(-200720);
DAQmxErrorInvalidAOOffsetCalConst =(-200719);
DAQmxErrorInvalidAIGainCalConst =(-200718);
DAQmxErrorInvalidAIOffsetCalConst =(-200717);
DAQmxErrorDigOutputOverrun = (-200716);
DAQmxErrorDigInputOverrun =(-200715);
DAQmxErrorAcqStoppedDriverCantXferDataFastEnough = (-200714);
DAQmxErrorChansCantAppearInSameTask =(-200713);
DAQmxErrorInputCfgFailedBecauseWatchdogExpired = (-200712);
DAQmxErrorAnalogTrigChanNotExternal =(-200711);
DAQmxErrorTooManyChansForInternalAIInputSrc =(-200710);
DAQmxErrorTEDSSensorNotDetected =(-200709);
DAQmxErrorPrptyGetSpecdActiveItemFailedDueToDifftValues =(-200708);
DAQmxErrorRoutingDestTermPXIClk10InNotInSlot2 =(-200706);
DAQmxErrorRoutingDestTermPXIStarXNotInSlot2 =(-200705);
DAQmxErrorRoutingSrcTermPXIStarXNotInSlot2 = (-200704);
DAQmxErrorRoutingSrcTermPXIStarInSlot16AndAbove =(-200703);
DAQmxErrorRoutingDestTermPXIStarInSlot16AndAbove = (-200702);
DAQmxErrorRoutingDestTermPXIStarInSlot2 =(-200701);
DAQmxErrorRoutingSrcTermPXIStarInSlot2 = (-200700);
DAQmxErrorRoutingDestTermPXIChassisNotIdentified = (-200699);
DAQmxErrorRoutingSrcTermPXIChassisNotIdentified =(-200698);
DAQmxErrorFailedToAcquireCalData = (-200697);
DAQmxErrorBridgeOffsetNullingCalNotSupported = (-200696);
DAQmxErrorAIMaxNotSpecified =(-200695);
DAQmxErrorAIMinNotSpecified =(-200694);
DAQmxErrorOddTotalBufferSizeToWrite =(-200693);
DAQmxErrorOddTotalNumSampsToWrite =(-200692);
DAQmxErrorBufferWithWaitMode = (-200691);
DAQmxErrorBufferWithHWTimedSinglePointSampMode = (-200690);
DAQmxErrorCOWritePulseLowTicksNotSupported = (-200689);
DAQmxErrorCOWritePulseHighTicksNotSupported =(-200688);
DAQmxErrorCOWritePulseLowTimeOutOfRange =(-200687);
DAQmxErrorCOWritePulseHighTimeOutOfRange = (-200686);
DAQmxErrorCOWriteFreqOutOfRange =(-200685);
DAQmxErrorCOWriteDutyCycleOutOfRange = (-200684);
DAQmxErrorInvalidInstallation =(-200683);
DAQmxErrorRefTrigMasterSessionUnavailable =(-200682);
DAQmxErrorRouteFailedBecauseWatchdogExpired =(-200681);
DAQmxErrorDeviceShutDownDueToHighTemp =(-200680);
DAQmxErrorNoMemMapWhenHWTimedSinglePoint = (-200679);
DAQmxErrorWriteFailedBecauseWatchdogExpired =(-200678);
DAQmxErrorDifftInternalAIInputSrcs = (-200677);
DAQmxErrorDifftAIInputSrcInOneChanGroup =(-200676);
DAQmxErrorInternalAIInputSrcInMultChanGroups = (-200675);
DAQmxErrorSwitchOpFailedDueToPrevError = (-200674);
DAQmxErrorWroteMultiSampsUsingSingleSampWrite =(-200673);
DAQmxErrorMismatchedInputArraySizes =(-200672);
DAQmxErrorCantExceedRelayDriveLimit =(-200671);
DAQmxErrorDACRngLowNotEqualToMinusRefVal = (-200670);
DAQmxErrorCantAllowConnectDACToGnd = (-200669);
DAQmxErrorWatchdogTimeoutOutOfRangeAndNotSpecialVal =(-200668);
DAQmxErrorNoWatchdogOutputOnPortReservedForInput = (-200667);
DAQmxErrorNoInputOnPortCfgdForWatchdogOutput = (-200666);
DAQmxErrorWatchdogExpirationStateNotEqualForLinesInPort =(-200665);
DAQmxErrorCannotPerformOpWhenTaskNotReserved = (-200664);
DAQmxErrorPowerupStateNotSupported = (-200663);
DAQmxErrorWatchdogTimerNotSupported =(-200662);
DAQmxErrorOpNotSupportedWhenRefClkSrcNone =(-200661);
DAQmxErrorSampClkRateUnavailable = (-200660);
DAQmxErrorPrptyGetSpecdSingleActiveChanFailedDueToDifftVals =(-200659);
DAQmxErrorPrptyGetImpliedActiveChanFailedDueToDifftVals =(-200658);
DAQmxErrorPrptyGetSpecdActiveChanFailedDueToDifftVals =(-200657);
DAQmxErrorNoRegenWhenUsingBrdMem = (-200656);
DAQmxErrorNonbufferedReadMoreThanSampsPerChan =(-200655);
DAQmxErrorWatchdogExpirationTristateNotSpecdForEntirePort =(-200654);
DAQmxErrorPowerupTristateNotSpecdForEntirePort = (-200653);
DAQmxErrorPowerupStateNotSpecdForEntirePort =(-200652);
DAQmxErrorCantSetWatchdogExpirationOnDigInChan = (-200651);
DAQmxErrorCantSetPowerupStateOnDigInChan = (-200650);
DAQmxErrorPhysChanNotInTask =(-200649);
DAQmxErrorPhysChanDevNotInTask = (-200648);
DAQmxErrorDigInputNotSupported = (-200647);
DAQmxErrorDigFilterIntervalNotEqualForLines =(-200646);
DAQmxErrorDigFilterIntervalAlreadyCfgd = (-200645);
DAQmxErrorCantResetExpiredWatchdog = (-200644);
DAQmxErrorActiveChanTooManyLinesSpecdWhenGettingPrpty =(-200643);
DAQmxErrorActiveChanNotSpecdWhenGetting1LinePrpty =(-200642);
DAQmxErrorDigPrptyCannotBeSetPerLine = (-200641);
DAQmxErrorSendAdvCmpltAfterWaitForTrigInScanlist = (-200640);
DAQmxErrorDisconnectionRequiredInScanlist =(-200639);
DAQmxErrorTwoWaitForTrigsAfterConnectionInScanlist = (-200638);
DAQmxErrorActionSeparatorRequiredAfterBreakingConnectionInScanlist = (-200637);
DAQmxErrorConnectionInScanlistMustWaitForTrig =(-200636);
DAQmxErrorActionNotSupportedTaskNotWatchdog =(-200635);
DAQmxErrorWfmNameSameAsScriptName =(-200634);
DAQmxErrorScriptNameSameAsWfmName =(-200633);
DAQmxErrorDSFStopClock = (-200632);
DAQmxErrorDSFReadyForStartClock =(-200631);
DAQmxErrorWriteOffsetNotMultOfIncr = (-200630);
DAQmxErrorDifferentPrptyValsNotSupportedOnDev =(-200629);
DAQmxErrorRefAndPauseTrigConfigured =(-200628);
DAQmxErrorFailedToEnableHighSpeedInputClock =(-200627);
DAQmxErrorEmptyPhysChanInPowerUpStatesArray =(-200626);
DAQmxErrorActivePhysChanTooManyLinesSpecdWhenGettingPrpty =(-200625);
DAQmxErrorActivePhysChanNotSpecdWhenGetting1LinePrpty =(-200624);
DAQmxErrorPXIDevTempCausedShutDown = (-200623);
DAQmxErrorInvalidNumSampsToWrite = (-200622);
DAQmxErrorOutputFIFOUnderflow2 = (-200621);
DAQmxErrorRepeatedAIPhysicalChan = (-200620);
DAQmxErrorMultScanOpsInOneChassis =(-200619);
DAQmxErrorInvalidAIChanOrder = (-200618);
DAQmxErrorReversePowerProtectionActivated =(-200617);
DAQmxErrorInvalidAsynOpHandle =(-200616);
DAQmxErrorFailedToEnableHighSpeedOutput =(-200615);
DAQmxErrorCannotReadPastEndOfRecord =(-200614);
DAQmxErrorAcqStoppedToPreventInputBufferOverwriteOneDataXferMech = (-200613);
DAQmxErrorZeroBasedChanIndexInvalid =(-200612);
DAQmxErrorNoChansOfGivenTypeInTask = (-200611);
DAQmxErrorSampClkSrcInvalidForOutputValidForInput =(-200610);
DAQmxErrorOutputBufSizeTooSmallToStartGen =(-200609);
DAQmxErrorInputBufSizeTooSmallToStartAcq = (-200608);
DAQmxErrorExportTwoSignalsOnSameTerminal = (-200607);
DAQmxErrorChanIndexInvalid = (-200606);
DAQmxErrorRangeSyntaxNumberTooBig =(-200605);
DAQmxErrorNULLPtr =(-200604);
DAQmxErrorScaledMinEqualMax =(-200603);
DAQmxErrorPreScaledMinEqualMax = (-200602);
DAQmxErrorPropertyNotSupportedForScaleType = (-200601);
DAQmxErrorChannelNameGenerationNumberTooBig =(-200600);
DAQmxErrorRepeatedNumberInScaledValues = (-200599);
DAQmxErrorRepeatedNumberInPreScaledValues =(-200598);
DAQmxErrorLinesAlreadyReservedForOutput =(-200597);
DAQmxErrorSwitchOperationChansSpanMultipleDevsInList = (-200596);
DAQmxErrorInvalidIDInListAtBeginningOfSwitchOperation =(-200595);
DAQmxErrorMStudioInvalidPolyDirection =(-200594);
DAQmxErrorMStudioPropertyGetWhileTaskNotVerified = (-200593);
DAQmxErrorRangeWithTooManyObjects =(-200592);
DAQmxErrorCppDotNetAPINegativeBufferSize = (-200591);
DAQmxErrorCppCantRemoveInvalidEventHandler = (-200590);
DAQmxErrorCppCantRemoveEventHandlerTwice = (-200589);
DAQmxErrorCppCantRemoveOtherObjectsEventHandler =(-200588);
DAQmxErrorDigLinesReservedOrUnavailable =(-200587);
DAQmxErrorDSFFailedToResetStream = (-200586);
DAQmxErrorDSFReadyForOutputNotAsserted = (-200585);
DAQmxErrorSampToWritePerChanNotMultipleOfIncr =(-200584);
DAQmxErrorAOPropertiesCauseVoltageBelowMin = (-200583);
DAQmxErrorAOPropertiesCauseVoltageOverMax =(-200582);
DAQmxErrorPropertyNotSupportedWhenRefClkSrcNone =(-200581);
DAQmxErrorAIMaxTooSmall =(-200580);
DAQmxErrorAIMaxTooLarge =(-200579);
DAQmxErrorAIMinTooSmall =(-200578);
DAQmxErrorAIMinTooLarge =(-200577);
DAQmxErrorBuiltInCJCSrcNotSupported =(-200576);
DAQmxErrorTooManyPostTrigSampsPerChan =(-200575);
DAQmxErrorTrigLineNotFoundSingleDevRoute = (-200574);
DAQmxErrorDifferentInternalAIInputSources =(-200573);
DAQmxErrorDifferentAIInputSrcInOneChanGroup =(-200572);
DAQmxErrorInternalAIInputSrcInMultipleChanGroups = (-200571);
DAQmxErrorCAPIChanIndexInvalid = (-200570);
DAQmxErrorCollectionDoesNotMatchChanType = (-200569);
DAQmxErrorOutputCantStartChangedRegenerationMode = (-200568);
DAQmxErrorOutputCantStartChangedBufferSize = (-200567);
DAQmxErrorChanSizeTooBigForU32PortWrite =(-200566);
DAQmxErrorChanSizeTooBigForU8PortWrite = (-200565);
DAQmxErrorChanSizeTooBigForU32PortRead = (-200564);
DAQmxErrorChanSizeTooBigForU8PortRead =(-200563);
DAQmxErrorInvalidDigDataWrite =(-200562);
DAQmxErrorInvalidAODataWrite = (-200561);
DAQmxErrorWaitUntilDoneDoesNotIndicateDone = (-200560);
DAQmxErrorMultiChanTypesInTask = (-200559);
DAQmxErrorMultiDevsInTask =(-200558);
DAQmxErrorCannotSetPropertyWhenTaskRunning = (-200557);
DAQmxErrorCannotGetPropertyWhenTaskNotCommittedOrRunning = (-200556);
DAQmxErrorLeadingUnderscoreInString =(-200555);
DAQmxErrorTrailingSpaceInString =(-200554);
DAQmxErrorLeadingSpaceInString = (-200553);
DAQmxErrorInvalidCharInString =(-200552);
DAQmxErrorDLLBecameUnlocked =(-200551);
DAQmxErrorDLLLock =(-200550);
DAQmxErrorSelfCalConstsInvalid = (-200549);
DAQmxErrorInvalidTrigCouplingExceptForExtTrigChan =(-200548);
DAQmxErrorWriteFailsBufferSizeAutoConfigured = (-200547);
DAQmxErrorExtCalAdjustExtRefVoltageFailed =(-200546);
DAQmxErrorSelfCalFailedExtNoiseOrRefVoltageOutOfCal =(-200545);
DAQmxErrorExtCalTemperatureNotDAQmx =(-200544);
DAQmxErrorExtCalDateTimeNotDAQmx = (-200543);
DAQmxErrorSelfCalTemperatureNotDAQmx = (-200542);
DAQmxErrorSelfCalDateTimeNotDAQmx =(-200541);
DAQmxErrorDACRefValNotSet =(-200540);
DAQmxErrorAnalogMultiSampWriteNotSupported = (-200539);
DAQmxErrorInvalidActionInControlTask = (-200538);
DAQmxErrorPolyCoeffsInconsistent = (-200537);
DAQmxErrorSensorValTooLow =(-200536);
DAQmxErrorSensorValTooHigh = (-200535);
DAQmxErrorWaveformNameTooLong =(-200534);
DAQmxErrorIdentifierTooLongInScript =(-200533);
DAQmxErrorUnexpectedIDFollowingSwitchChanName =(-200532);
DAQmxErrorRelayNameNotSpecifiedInList =(-200531);
DAQmxErrorUnexpectedIDFollowingRelayNameInList = (-200530);
DAQmxErrorUnexpectedIDFollowingSwitchOpInList =(-200529);
DAQmxErrorInvalidLineGrouping =(-200528);
DAQmxErrorCtrMinMax =(-200527);
DAQmxErrorWriteChanTypeMismatch =(-200526);
DAQmxErrorReadChanTypeMismatch = (-200525);
DAQmxErrorWriteNumChansMismatch =(-200524);
DAQmxErrorOneChanReadForMultiChanTask =(-200523);
DAQmxErrorCannotSelfCalDuringExtCal =(-200522);
DAQmxErrorMeasCalAdjustOscillatorPhaseDAC =(-200521);
DAQmxErrorInvalidCalConstCalADCAdjustment =(-200520);
DAQmxErrorInvalidCalConstOscillatorFreqDACValue =(-200519);
DAQmxErrorInvalidCalConstOscillatorPhaseDACValue = (-200518);
DAQmxErrorInvalidCalConstOffsetDACValue =(-200517);
DAQmxErrorInvalidCalConstGainDACValue =(-200516);
DAQmxErrorInvalidNumCalADCReadsToAverage = (-200515);
DAQmxErrorInvalidCfgCalAdjustDirectPathOutputImpedance = (-200514);
DAQmxErrorInvalidCfgCalAdjustMainPathOutputImpedance = (-200513);
DAQmxErrorInvalidCfgCalAdjustMainPathPostAmpGainAndOffset =(-200512);
DAQmxErrorInvalidCfgCalAdjustMainPathPreAmpGain =(-200511);
DAQmxErrorInvalidCfgCalAdjustMainPreAmpOffset =(-200510);
DAQmxErrorMeasCalAdjustCalADC =(-200509);
DAQmxErrorMeasCalAdjustOscillatorFrequency = (-200508);
DAQmxErrorMeasCalAdjustDirectPathOutputImpedance = (-200507);
DAQmxErrorMeasCalAdjustMainPathOutputImpedance = (-200506);
DAQmxErrorMeasCalAdjustDirectPathGain =(-200505);
DAQmxErrorMeasCalAdjustMainPathPostAmpGainAndOffset =(-200504);
DAQmxErrorMeasCalAdjustMainPathPreAmpGain =(-200503);
DAQmxErrorMeasCalAdjustMainPathPreAmpOffset =(-200502);
DAQmxErrorInvalidDateTimeInEEPROM =(-200501);
DAQmxErrorUnableToLocateErrorResources = (-200500);
DAQmxErrorDotNetAPINotUnsigned32BitNumber =(-200499);
DAQmxErrorInvalidRangeOfObjectsSyntaxInString =(-200498);
DAQmxErrorAttemptToEnableLineNotPreviouslyDisabled = (-200497);
DAQmxErrorInvalidCharInPattern = (-200496);
DAQmxErrorIntermediateBufferFull = (-200495);
DAQmxErrorLoadTaskFailsBecauseNoTimingOnDev =(-200494);
DAQmxErrorCAPIReservedParamNotNULLNorEmpty = (-200493);
DAQmxErrorCAPIReservedParamNotNULL = (-200492);
DAQmxErrorCAPIReservedParamNotZero = (-200491);
DAQmxErrorSampleValueOutOfRange =(-200490);
DAQmxErrorChanAlreadyInTask =(-200489);
DAQmxErrorVirtualChanDoesNotExist =(-200488);
DAQmxErrorChanNotInTask =(-200486);
DAQmxErrorTaskNotInDataNeighborhood =(-200485);
DAQmxErrorCantSaveTaskWithoutReplace = (-200484);
DAQmxErrorCantSaveChanWithoutReplace = (-200483);
DAQmxErrorDevNotInTask = (-200482);
DAQmxErrorDevAlreadyInTask = (-200481);
DAQmxErrorCanNotPerformOpWhileTaskRunning =(-200479);
DAQmxErrorCanNotPerformOpWhenNoChansInTask = (-200478);
DAQmxErrorCanNotPerformOpWhenNoDevInTask = (-200477);
DAQmxErrorCannotPerformOpWhenTaskNotRunning =(-200475);
DAQmxErrorOperationTimedOut =(-200474);
DAQmxErrorCannotReadWhenAutoStartFalseAndTaskNotRunningOrCommitted = (-200473);
DAQmxErrorCannotWriteWhenAutoStartFalseAndTaskNotRunningOrCommitted =(-200472);
DAQmxErrorTaskVersionNew = (-200470);
DAQmxErrorChanVersionNew = (-200469);
DAQmxErrorEmptyString =(-200467);
DAQmxErrorChannelSizeTooBigForPortReadType = (-200466);
DAQmxErrorChannelSizeTooBigForPortWriteType =(-200465);
DAQmxErrorExpectedNumberOfChannelsVerificationFailed = (-200464);
DAQmxErrorNumLinesMismatchInReadOrWrite =(-200463);
DAQmxErrorOutputBufferEmpty =(-200462);
DAQmxErrorInvalidChanName =(-200461);
DAQmxErrorReadNoInputChansInTask = (-200460);
DAQmxErrorWriteNoOutputChansInTask = (-200459);
DAQmxErrorPropertyNotSupportedNotInputTask = (-200457);
DAQmxErrorPropertyNotSupportedNotOutputTask =(-200456);
DAQmxErrorGetPropertyNotInputBufferedTask =(-200455);
DAQmxErrorGetPropertyNotOutputBufferedTask = (-200454);
DAQmxErrorInvalidTimeoutVal =(-200453);
DAQmxErrorAttributeNotSupportedInTaskContext = (-200452);
DAQmxErrorAttributeNotQueryableUnlessTaskIsCommitted = (-200451);
DAQmxErrorAttributeNotSettableWhenTaskIsRunning =(-200450);
DAQmxErrorDACRngLowNotMinusRefValNorZero = (-200449);
DAQmxErrorDACRngHighNotEqualRefVal = (-200448);
DAQmxErrorUnitsNotFromCustomScale =(-200447);
DAQmxErrorInvalidVoltageReadingDuringExtCal =(-200446);
DAQmxErrorCalFunctionNotSupported =(-200445);
DAQmxErrorInvalidPhysicalChanForCal =(-200444);
DAQmxErrorExtCalNotComplete =(-200443);
DAQmxErrorCantSyncToExtStimulusFreqDuringCal = (-200442);
DAQmxErrorUnableToDetectExtStimulusFreqDuringCal = (-200441);
DAQmxErrorInvalidCloseAction = (-200440);
DAQmxErrorExtCalFunctionOutsideExtCalSession = (-200439);
DAQmxErrorInvalidCalArea = (-200438);
DAQmxErrorExtCalConstsInvalid =(-200437);
DAQmxErrorStartTrigDelayWithExtSampClk = (-200436);
DAQmxErrorDelayFromSampClkWithExtConv =(-200435);
DAQmxErrorFewerThan2PreScaledVals =(-200434);
DAQmxErrorFewerThan2ScaledValues = (-200433);
DAQmxErrorPhysChanOutputType = (-200432);
DAQmxErrorPhysChanMeasType = (-200431);
DAQmxErrorInvalidPhysChanType =(-200430);
DAQmxErrorLabVIEWEmptyTaskOrChans =(-200429);
DAQmxErrorLabVIEWInvalidTaskOrChans =(-200428);
DAQmxErrorInvalidRefClkRate =(-200427);
DAQmxErrorInvalidExtTrigImpedance =(-200426);
DAQmxErrorHystTrigLevelAIMax = (-200425);
DAQmxErrorLineNumIncompatibleWithVideoSignalFormat = (-200424);
DAQmxErrorTrigWindowAIMinAIMaxCombo =(-200423);
DAQmxErrorTrigAIMinAIMax = (-200422);
DAQmxErrorHystTrigLevelAIMin = (-200421);
DAQmxErrorInvalidSampRateConsiderRIS = (-200420);
DAQmxErrorInvalidReadPosDuringRIS =(-200419);
DAQmxErrorImmedTrigDuringRISMode = (-200418);
DAQmxErrorTDCNotEnabledDuringRISMode = (-200417);
DAQmxErrorMultiRecWithRIS =(-200416);
DAQmxErrorInvalidRefClkSrc = (-200415);
DAQmxErrorInvalidSampClkSrc =(-200414);
DAQmxErrorInsufficientOnBoardMemForNumRecsAndSamps = (-200413);
DAQmxErrorInvalidAIAttenuation = (-200412);
DAQmxErrorACCouplingNotAllowedWith50OhmImpedance = (-200411);
DAQmxErrorInvalidRecordNum = (-200410);
DAQmxErrorZeroSlopeLinearScale = (-200409);
DAQmxErrorZeroReversePolyScaleCoeffs = (-200408);
DAQmxErrorZeroForwardPolyScaleCoeffs = (-200407);
DAQmxErrorNoReversePolyScaleCoeffs = (-200406);
DAQmxErrorNoForwardPolyScaleCoeffs = (-200405);
DAQmxErrorNoPolyScaleCoeffs =(-200404);
DAQmxErrorReversePolyOrderLessThanNumPtsToCompute =(-200403);
DAQmxErrorReversePolyOrderNotPositive =(-200402);
DAQmxErrorNumPtsToComputeNotPositive = (-200401);
DAQmxErrorWaveformLengthNotMultipleOfIncr =(-200400);
DAQmxErrorCAPINoExtendedErrorInfoAvailable = (-200399);
DAQmxErrorCVIFunctionNotFoundInDAQmxDLL =(-200398);
DAQmxErrorCVIFailedToLoadDAQmxDLL =(-200397);
DAQmxErrorNoCommonTrigLineForImmedRoute =(-200396);
DAQmxErrorNoCommonTrigLineForTaskRoute = (-200395);
DAQmxErrorF64PrptyValNotUnsignedInt =(-200394);
DAQmxErrorRegisterNotWritable =(-200393);
DAQmxErrorInvalidOutputVoltageAtSampClkRate =(-200392);
DAQmxErrorStrobePhaseShiftDCMBecameUnlocked =(-200391);
DAQmxErrorDrivePhaseShiftDCMBecameUnlocked = (-200390);
DAQmxErrorClkOutPhaseShiftDCMBecameUnlocked =(-200389);
DAQmxErrorOutputBoardClkDCMBecameUnlocked =(-200388);
DAQmxErrorInputBoardClkDCMBecameUnlocked = (-200387);
DAQmxErrorInternalClkDCMBecameUnlocked = (-200386);
DAQmxErrorDCMLock =(-200385);
DAQmxErrorDataLineReservedForDynamicOutput = (-200384);
DAQmxErrorInvalidRefClkSrcGivenSampClkSrc =(-200383);
DAQmxErrorNoPatternMatcherAvailable =(-200382);
DAQmxErrorInvalidDelaySampRateBelowPhaseShiftDCMThresh = (-200381);
DAQmxErrorStrainGageCalibration =(-200380);
DAQmxErrorInvalidExtClockFreqAndDivCombo = (-200379);
DAQmxErrorCustomScaleDoesNotExist =(-200378);
DAQmxErrorOnlyFrontEndChanOpsDuringScan =(-200377);
DAQmxErrorInvalidOptionForDigitalPortChannel = (-200376);
DAQmxErrorUnsupportedSignalTypeExportSignal =(-200375);
DAQmxErrorInvalidSignalTypeExportSignal =(-200374);
DAQmxErrorUnsupportedTrigTypeSendsSWTrig = (-200373);
DAQmxErrorInvalidTrigTypeSendsSWTrig = (-200372);
DAQmxErrorRepeatedPhysicalChan = (-200371);
DAQmxErrorResourcesInUseForRouteInTask = (-200370);
DAQmxErrorResourcesInUseForRoute = (-200369);
DAQmxErrorRouteNotSupportedByHW =(-200368);
DAQmxErrorResourcesInUseForExportSignalPolarity =(-200367);
DAQmxErrorResourcesInUseForInversionInTask = (-200366);
DAQmxErrorResourcesInUseForInversion = (-200365);
DAQmxErrorExportSignalPolarityNotSupportedByHW = (-200364);
DAQmxErrorInversionNotSupportedByHW =(-200363);
DAQmxErrorOverloadedChansExistNotRead =(-200362);
DAQmxErrorInputFIFOOverflow2 = (-200361);
DAQmxErrorCJCChanNotSpecd =(-200360);
DAQmxErrorCtrExportSignalNotPossible = (-200359);
DAQmxErrorRefTrigWhenContinuous =(-200358);
DAQmxErrorIncompatibleSensorOutputAndDeviceInputRanges = (-200357);
DAQmxErrorCustomScaleNameUsed =(-200356);
DAQmxErrorPropertyValNotSupportedByHW =(-200355);
DAQmxErrorPropertyValNotValidTermName =(-200354);
DAQmxErrorResourcesInUseForProperty =(-200353);
DAQmxErrorCJCChanAlreadyUsed = (-200352);
DAQmxErrorForwardPolynomialCoefNotSpecd =(-200351);
DAQmxErrorTableScaleNumPreScaledAndScaledValsNotEqual =(-200350);
DAQmxErrorTableScalePreScaledValsNotSpecd =(-200349);
DAQmxErrorTableScaleScaledValsNotSpecd = (-200348);
DAQmxErrorIntermediateBufferSizeNotMultipleOfIncr =(-200347);
DAQmxErrorEventPulseWidthOutOfRange =(-200346);
DAQmxErrorEventDelayOutOfRange = (-200345);
DAQmxErrorSampPerChanNotMultipleOfIncr = (-200344);
DAQmxErrorCannotCalculateNumSampsTaskNotStarted =(-200343);
DAQmxErrorScriptNotInMem = (-200342);
DAQmxErrorOnboardMemTooSmall = (-200341);
DAQmxErrorReadAllAvailableDataWithoutBuffer =(-200340);
DAQmxErrorPulseActiveAtStart = (-200339);
DAQmxErrorCalTempNotSupported =(-200338);
DAQmxErrorDelayFromSampClkTooLong =(-200337);
DAQmxErrorDelayFromSampClkTooShort = (-200336);
DAQmxErrorAIConvRateTooHigh =(-200335);
DAQmxErrorDelayFromStartTrigTooLong =(-200334);
DAQmxErrorDelayFromStartTrigTooShort = (-200333);
DAQmxErrorSampRateTooHigh =(-200332);
DAQmxErrorSampRateTooLow = (-200331);
DAQmxErrorPFI0UsedForAnalogAndDigitalSrc = (-200330);
DAQmxErrorPrimingCfgFIFO = (-200329);
DAQmxErrorCannotOpenTopologyCfgFile =(-200328);
DAQmxErrorInvalidDTInsideWfmDataType = (-200327);
DAQmxErrorRouteSrcAndDestSame =(-200326);
DAQmxErrorReversePolynomialCoefNotSpecd =(-200325);
DAQmxErrorDevAbsentOrUnavailable = (-200324);
DAQmxErrorNoAdvTrigForMultiDevScan = (-200323);
DAQmxErrorInterruptsInsufficientDataXferMech = (-200322);
DAQmxErrorInvalidAttentuationBasedOnMinMax = (-200321);
DAQmxErrorCabledModuleCannotRouteSSH = (-200320);
DAQmxErrorCabledModuleCannotRouteConvClk = (-200319);
DAQmxErrorInvalidExcitValForScaling =(-200318);
DAQmxErrorNoDevMemForScript =(-200317);
DAQmxErrorScriptDataUnderflow =(-200316);
DAQmxErrorNoDevMemForWaveform =(-200315);
DAQmxErrorStreamDCMBecameUnlocked =(-200314);
DAQmxErrorStreamDCMLock =(-200313);
DAQmxErrorWaveformNotInMem = (-200312);
DAQmxErrorWaveformWriteOutOfBounds = (-200311);
DAQmxErrorWaveformPreviouslyAllocated =(-200310);
DAQmxErrorSampClkTbMasterTbDivNotAppropriateForSampTbSrc = (-200309);
DAQmxErrorSampTbRateSampTbSrcMismatch =(-200308);
DAQmxErrorMasterTbRateMasterTbSrcMismatch =(-200307);
DAQmxErrorSampsPerChanTooBig = (-200306);
DAQmxErrorFinitePulseTrainNotPossible =(-200305);
DAQmxErrorExtMasterTimebaseRateNotSpecified =(-200304);
DAQmxErrorExtSampClkSrcNotSpecified =(-200303);
DAQmxErrorInputSignalSlowerThanMeasTime =(-200302);
DAQmxErrorCannotUpdatePulseGenProperty = (-200301);
DAQmxErrorInvalidTimingType =(-200300);
DAQmxErrorPropertyUnavailWhenUsingOnboardMemory =(-200297);
DAQmxErrorCannotWriteAfterStartWithOnboardMemory = (-200295);
DAQmxErrorNotEnoughSampsWrittenForInitialXferRqstCondition = (-200294);
DAQmxErrorNoMoreSpace =(-200293);
DAQmxErrorSamplesCanNotYetBeWritten =(-200292);
DAQmxErrorGenStoppedToPreventIntermediateBufferRegenOfOldSamples = (-200291);
DAQmxErrorGenStoppedToPreventRegenOfOldSamples = (-200290);
DAQmxErrorSamplesNoLongerWriteable = (-200289);
DAQmxErrorSamplesWillNeverBeGenerated =(-200288);
DAQmxErrorNegativeWriteSampleNumber =(-200287);
DAQmxErrorNoAcqStarted = (-200286);
DAQmxErrorSamplesNotYetAvailable = (-200284);
DAQmxErrorAcqStoppedToPreventIntermediateBufferOverflow =(-200283);
DAQmxErrorNoRefTrigConfigured =(-200282);
DAQmxErrorCannotReadRelativeToRefTrigUntilDone = (-200281);
DAQmxErrorSamplesNoLongerAvailable = (-200279);
DAQmxErrorSamplesWillNeverBeAvailable =(-200278);
DAQmxErrorNegativeReadSampleNumber = (-200277);
DAQmxErrorExternalSampClkAndRefClkThruSameTerm = (-200276);
DAQmxErrorExtSampClkRateTooLowForClkIn = (-200275);
DAQmxErrorExtSampClkRateTooHighForBackplane =(-200274);
DAQmxErrorSampClkRateAndDivCombo = (-200273);
DAQmxErrorSampClkRateTooLowForDivDown =(-200272);
DAQmxErrorProductOfAOMinAndGainTooSmall =(-200271);
DAQmxErrorInterpolationRateNotPossible = (-200270);
DAQmxErrorOffsetTooLarge = (-200269);
DAQmxErrorOffsetTooSmall = (-200268);
DAQmxErrorProductOfAOMaxAndGainTooLarge =(-200267);
DAQmxErrorMinAndMaxNotSymmetric =(-200266);
DAQmxErrorInvalidAnalogTrigSrc = (-200265);
DAQmxErrorTooManyChansForAnalogRefTrig = (-200264);
DAQmxErrorTooManyChansForAnalogPauseTrig = (-200263);
DAQmxErrorTrigWhenOnDemandSampTiming = (-200262);
DAQmxErrorInconsistentAnalogTrigSettings = (-200261);
DAQmxErrorMemMapDataXferModeSampTimingCombo =(-200260);
DAQmxErrorInvalidJumperedAttr =(-200259);
DAQmxErrorInvalidGainBasedOnMinMax = (-200258);
DAQmxErrorInconsistentExcit =(-200257);
DAQmxErrorTopologyNotSupportedByCfgTermBlock = (-200256);
DAQmxErrorBuiltInTempSensorNotSupported =(-200255);
DAQmxErrorInvalidTerm =(-200254);
DAQmxErrorCannotTristateTerm = (-200253);
DAQmxErrorCannotTristateBusyTerm = (-200252);
DAQmxErrorNoDMAChansAvailable =(-200251);
DAQmxErrorInvalidWaveformLengthWithinLoopInScript =(-200250);
DAQmxErrorInvalidSubsetLengthWithinLoopInScript =(-200249);
DAQmxErrorMarkerPosInvalidForLoopInScript =(-200248);
DAQmxErrorIntegerExpectedInScript =(-200247);
DAQmxErrorPLLBecameUnlocked =(-200246);
DAQmxErrorPLLLock =(-200245);
DAQmxErrorDDCClkOutDCMBecameUnlocked = (-200244);
DAQmxErrorDDCClkOutDCMLock = (-200243);
DAQmxErrorClkDoublerDCMBecameUnlocked =(-200242);
DAQmxErrorClkDoublerDCMLock =(-200241);
DAQmxErrorSampClkDCMBecameUnlocked = (-200240);
DAQmxErrorSampClkDCMLock = (-200239);
DAQmxErrorSampClkTimebaseDCMBecameUnlocked = (-200238);
DAQmxErrorSampClkTimebaseDCMLock = (-200237);
DAQmxErrorAttrCannotBeReset =(-200236);
DAQmxErrorExplanationNotFound =(-200235);
DAQmxErrorWriteBufferTooSmall =(-200234);
DAQmxErrorSpecifiedAttrNotValid =(-200233);
DAQmxErrorAttrCannotBeRead = (-200232);
DAQmxErrorAttrCannotBeSet =(-200231);
DAQmxErrorNULLPtrForC_Api =(-200230);
DAQmxErrorReadBufferTooSmall = (-200229);
DAQmxErrorBufferTooSmallForString =(-200228);
DAQmxErrorNoAvailTrigLinesOnDevice = (-200227);
DAQmxErrorTrigBusLineNotAvail =(-200226);
DAQmxErrorCouldNotReserveRequestedTrigLine = (-200225);
DAQmxErrorTrigLineNotFound = (-200224);
DAQmxErrorSCXI1126ThreshHystCombination =(-200223);
DAQmxErrorAcqStoppedToPreventInputBufferOverwrite =(-200222);
DAQmxErrorTimeoutExceeded =(-200221);
DAQmxErrorInvalidDeviceID =(-200220);
DAQmxErrorInvalidAOChanOrder = (-200219);
DAQmxErrorSampleTimingTypeAndDataXferMode =(-200218);
DAQmxErrorBufferWithOnDemandSampTiming = (-200217);
DAQmxErrorBufferAndDataXferMode =(-200216);
DAQmxErrorMemMapAndBuffer =(-200215);
DAQmxErrorNoAnalogTrigHW = (-200214);
DAQmxErrorTooManyPretrigPlusMinPostTrigSamps = (-200213);
DAQmxErrorInconsistentUnitsSpecified = (-200212);
DAQmxErrorMultipleRelaysForSingleRelayOp = (-200211);
DAQmxErrorMultipleDevIDsPerChassisSpecifiedInList =(-200210);
DAQmxErrorDuplicateDevIDInList = (-200209);
DAQmxErrorInvalidRangeStatementCharInList =(-200208);
DAQmxErrorInvalidDeviceIDInList =(-200207);
DAQmxErrorTriggerPolarityConflict =(-200206);
DAQmxErrorCannotScanWithCurrentTopology =(-200205);
DAQmxErrorUnexpectedIdentifierInFullySpecifiedPathInList = (-200204);
DAQmxErrorSwitchCannotDriveMultipleTrigLines = (-200203);
DAQmxErrorInvalidRelayName = (-200202);
DAQmxErrorSwitchScanlistTooBig = (-200201);
DAQmxErrorSwitchChanInUse =(-200200);
DAQmxErrorSwitchNotResetBeforeScan = (-200199);
DAQmxErrorInvalidTopology =(-200198);
DAQmxErrorAttrNotSupported = (-200197);
DAQmxErrorUnexpectedEndOfActionsInList = (-200196);
DAQmxErrorPowerBudgetExceeded =(-200195);
DAQmxErrorHWUnexpectedlyPoweredOffAndOn =(-200194);
DAQmxErrorSwitchOperationNotSupported =(-200193);
DAQmxErrorOnlyContinuousScanSupported =(-200192);
DAQmxErrorSwitchDifferentTopologyWhenScanning =(-200191);
DAQmxErrorDisconnectPathNotSameAsExistingPath =(-200190);
DAQmxErrorConnectionNotPermittedOnChanReservedForRouting = (-200189);
DAQmxErrorCannotConnectSrcChans =(-200188);
DAQmxErrorCannotConnectChannelToItself = (-200187);
DAQmxErrorChannelNotReservedForRouting = (-200186);
DAQmxErrorCannotConnectChansDirectly = (-200185);
DAQmxErrorChansAlreadyConnected =(-200184);
DAQmxErrorChanDuplicatedInPath = (-200183);
DAQmxErrorNoPathToDisconnect = (-200182);
DAQmxErrorInvalidSwitchChan =(-200181);
DAQmxErrorNoPathAvailableBetween2SwitchChans = (-200180);
DAQmxErrorExplicitConnectionExists = (-200179);
DAQmxErrorSwitchDifferentSettlingTimeWhenScanning =(-200178);
DAQmxErrorOperationOnlyPermittedWhileScanning =(-200177);
DAQmxErrorOperationNotPermittedWhileScanning = (-200176);
DAQmxErrorHardwareNotResponding =(-200175);
DAQmxErrorInvalidSampAndMasterTimebaseRateCombo =(-200173);
DAQmxErrorNonZeroBufferSizeInProgIOXfer =(-200172);
DAQmxErrorVirtualChanNameUsed =(-200171);
DAQmxErrorPhysicalChanDoesNotExist = (-200170);
DAQmxErrorMemMapOnlyForProgIOXfer =(-200169);
DAQmxErrorTooManyChans = (-200168);
DAQmxErrorCannotHaveCJTempWithOtherChans = (-200167);
DAQmxErrorOutputBufferUnderwrite = (-200166);
DAQmxErrorSensorInvalidCompletionResistance =(-200163);
DAQmxErrorVoltageExcitIncompatibleWith2WireCfg = (-200162);
DAQmxErrorIntExcitSrcNotAvailable =(-200161);
DAQmxErrorCannotCreateChannelAfterTaskVerified = (-200160);
DAQmxErrorLinesReservedForSCXIControl =(-200159);
DAQmxErrorCouldNotReserveLinesForSCXIControl = (-200158);
DAQmxErrorCalibrationFailed =(-200157);
DAQmxErrorReferenceFrequencyInvalid =(-200156);
DAQmxErrorReferenceResistanceInvalid = (-200155);
DAQmxErrorReferenceCurrentInvalid =(-200154);
DAQmxErrorReferenceVoltageInvalid =(-200153);
DAQmxErrorEEPROMDataInvalid =(-200152);
DAQmxErrorCabledModuleNotCapableOfRoutingAI =(-200151);
DAQmxErrorChannelNotAvailableInParallelMode =(-200150);
DAQmxErrorExternalTimebaseRateNotKnownForDelay = (-200149);
DAQmxErrorFREQOUTCannotProduceDesiredFrequency = (-200148);
DAQmxErrorMultipleCounterInputTask = (-200147);
DAQmxErrorCounterStartPauseTriggerConflict = (-200146);
DAQmxErrorCounterInputPauseTriggerAndSampleClockInvalid =(-200145);
DAQmxErrorCounterOutputPauseTriggerInvalid = (-200144);
DAQmxErrorCounterTimebaseRateNotSpecified =(-200143);
DAQmxErrorCounterTimebaseRateNotFound =(-200142);
DAQmxErrorCounterOverflow =(-200141);
DAQmxErrorCounterNoTimebaseEdgesBetweenGates = (-200140);
DAQmxErrorCounterMaxMinRangeFreq = (-200139);
DAQmxErrorCounterMaxMinRangeTime = (-200138);
DAQmxErrorSuitableTimebaseNotFoundTimeCombo =(-200137);
DAQmxErrorSuitableTimebaseNotFoundFrequencyCombo = (-200136);
DAQmxErrorInternalTimebaseSourceDivisorCombo = (-200135);
DAQmxErrorInternalTimebaseSourceRateCombo =(-200134);
DAQmxErrorInternalTimebaseRateDivisorSourceCombo = (-200133);
DAQmxErrorExternalTimebaseRateNotknownForRate =(-200132);
DAQmxErrorAnalogTrigChanNotFirstInScanList = (-200131);
DAQmxErrorNoDivisorForExternalSignal = (-200130);
DAQmxErrorAttributeInconsistentAcrossRepeatedPhysicalChannels =(-200128);
DAQmxErrorCannotHandshakeWithPort0 = (-200127);
DAQmxErrorControlLineConflictOnPortC = (-200126);
DAQmxErrorLines4To7ConfiguredForOutput = (-200125);
DAQmxErrorLines4To7ConfiguredForInput =(-200124);
DAQmxErrorLines0To3ConfiguredForOutput = (-200123);
DAQmxErrorLines0To3ConfiguredForInput =(-200122);
DAQmxErrorPortConfiguredForOutput =(-200121);
DAQmxErrorPortConfiguredForInput = (-200120);
DAQmxErrorPortConfiguredForStaticDigitalOps =(-200119);
DAQmxErrorPortReservedForHandshaking = (-200118);
DAQmxErrorPortDoesNotSupportHandshakingDataIO =(-200117);
DAQmxErrorCannotTristate8255OutputLines =(-200116);
DAQmxErrorTemperatureOutOfRangeForCalibration =(-200113);
DAQmxErrorCalibrationHandleInvalid = (-200112);
DAQmxErrorPasswordRequired = (-200111);
DAQmxErrorIncorrectPassword =(-200110);
DAQmxErrorPasswordTooLong =(-200109);
DAQmxErrorCalibrationSessionAlreadyOpen =(-200108);
DAQmxErrorSCXIModuleIncorrect =(-200107);
DAQmxErrorAttributeInconsistentAcrossChannelsOnDevice =(-200106);
DAQmxErrorSCXI1122ResistanceChanNotSupportedForCfg = (-200105);
DAQmxErrorBracketPairingMismatchInList = (-200104);
DAQmxErrorInconsistentNumSamplesToWrite =(-200103);
DAQmxErrorIncorrectDigitalPattern =(-200102);
DAQmxErrorIncorrectNumChannelsToWrite =(-200101);
DAQmxErrorIncorrectReadFunction =(-200100);
DAQmxErrorPhysicalChannelNotSpecified =(-200099);
DAQmxErrorMoreThanOneTerminal =(-200098);
DAQmxErrorMoreThanOneActiveChannelSpecified =(-200097);
DAQmxErrorInvalidNumberSamplesToRead = (-200096);
DAQmxErrorAnalogWaveformExpected = (-200095);
DAQmxErrorDigitalWaveformExpected =(-200094);
DAQmxErrorActiveChannelNotSpecified =(-200093);
DAQmxErrorFunctionNotSupportedForDeviceTasks = (-200092);
DAQmxErrorFunctionNotInLibrary = (-200091);
DAQmxErrorLibraryNotPresent =(-200090);
DAQmxErrorDuplicateTask =(-200089);
DAQmxErrorInvalidTask =(-200088);
DAQmxErrorInvalidChannel = (-200087);
DAQmxErrorInvalidSyntaxForPhysicalChannelRange = (-200086);
DAQmxErrorMinNotLessThanMax =(-200082);
DAQmxErrorSampleRateNumChansConvertPeriodCombo = (-200081);
DAQmxErrorAODuringCounter1DMAConflict =(-200079);
DAQmxErrorAIDuringCounter0DMAConflict =(-200078);
DAQmxErrorInvalidAttributeValue =(-200077);
DAQmxErrorSuppliedCurrentDataOutsideSpecifiedRange = (-200076);
DAQmxErrorSuppliedVoltageDataOutsideSpecifiedRange = (-200075);
DAQmxErrorCannotStoreCalConst =(-200074);
DAQmxErrorSCXIModuleNotFound = (-200073);
DAQmxErrorDuplicatePhysicalChansNotSupported = (-200072);
DAQmxErrorTooManyPhysicalChansInList = (-200071);
DAQmxErrorInvalidAdvanceEventTriggerType = (-200070);
DAQmxErrorDeviceIsNotAValidSwitch =(-200069);
DAQmxErrorDeviceDoesNotSupportScanning = (-200068);
DAQmxErrorScanListCannotBeTimed =(-200067);
DAQmxErrorConnectOperatorInvalidAtPointInList =(-200066);
DAQmxErrorUnexpectedSwitchActionInList = (-200065);
DAQmxErrorUnexpectedSeparatorInList =(-200064);
DAQmxErrorExpectedTerminatorInList = (-200063);
DAQmxErrorExpectedConnectOperatorInList =(-200062);
DAQmxErrorExpectedSeparatorInList =(-200061);
DAQmxErrorFullySpecifiedPathInListContainsRange =(-200060);
DAQmxErrorConnectionSeparatorAtEndOfList = (-200059);
DAQmxErrorIdentifierInListTooLong =(-200058);
DAQmxErrorDuplicateDeviceIDInListWhenSettling =(-200057);
DAQmxErrorChannelNameNotSpecifiedInList =(-200056);
DAQmxErrorDeviceIDNotSpecifiedInList = (-200055);
DAQmxErrorSemicolonDoesNotFollowRangeInList =(-200054);
DAQmxErrorSwitchActionInListSpansMultipleDevices = (-200053);
DAQmxErrorRangeWithoutAConnectActionInList = (-200052);
DAQmxErrorInvalidIdentifierFollowingSeparatorInList =(-200051);
DAQmxErrorInvalidChannelNameInList = (-200050);
DAQmxErrorInvalidNumberInRepeatStatementInList = (-200049);
DAQmxErrorInvalidTriggerLineInList = (-200048);
DAQmxErrorInvalidIdentifierInListFollowingDeviceID = (-200047);
DAQmxErrorInvalidIdentifierInListAtEndOfSwitchAction = (-200046);
DAQmxErrorDeviceRemoved =(-200045);
DAQmxErrorRoutingPathNotAvailable =(-200044);
DAQmxErrorRoutingHardwareBusy =(-200043);
DAQmxErrorRequestedSignalInversionForRoutingNotPossible =(-200042);
DAQmxErrorInvalidRoutingDestinationTerminalName =(-200041);
DAQmxErrorInvalidRoutingSourceTerminalName = (-200040);
DAQmxErrorRoutingNotSupportedForDevice = (-200039);
DAQmxErrorWaitIsLastInstructionOfLoopInScript =(-200038);
DAQmxErrorClearIsLastInstructionOfLoopInScript = (-200037);
DAQmxErrorInvalidLoopIterationsInScript =(-200036);
DAQmxErrorRepeatLoopNestingTooDeepInScript = (-200035);
DAQmxErrorMarkerPositionOutsideSubsetInScript =(-200034);
DAQmxErrorSubsetStartOffsetNotAlignedInScript =(-200033);
DAQmxErrorInvalidSubsetLengthInScript =(-200032);
DAQmxErrorMarkerPositionNotAlignedInScript = (-200031);
DAQmxErrorSubsetOutsideWaveformInScript =(-200030);
DAQmxErrorMarkerOutsideWaveformInScript =(-200029);
DAQmxErrorWaveformInScriptNotInMem = (-200028);
DAQmxErrorKeywordExpectedInScript =(-200027);
DAQmxErrorBufferNameExpectedInScript = (-200026);
DAQmxErrorProcedureNameExpectedInScript =(-200025);
DAQmxErrorScriptHasInvalidIdentifier = (-200024);
DAQmxErrorScriptHasInvalidCharacter =(-200023);
DAQmxErrorResourceAlreadyReserved =(-200022);
DAQmxErrorSelfTestFailed = (-200020);
DAQmxErrorADCOverrun = (-200019);
DAQmxErrorDACUnderflow = (-200018);
DAQmxErrorInputFIFOUnderflow = (-200017);
DAQmxErrorOutputFIFOUnderflow =(-200016);
DAQmxErrorSCXISerialCommunication =(-200015);
DAQmxErrorDigitalTerminalSpecifiedMoreThanOnce = (-200014);
DAQmxErrorDigitalOutputNotSupported =(-200012);
DAQmxErrorInconsistentChannelDirections =(-200011);
DAQmxErrorInputFIFOOverflow =(-200010);
DAQmxErrorTimeStampOverwritten = (-200009);
DAQmxErrorStopTriggerHasNotOccurred =(-200008);
DAQmxErrorRecordNotAvailable = (-200007);
DAQmxErrorRecordOverwritten =(-200006);
DAQmxErrorDataNotAvailable = (-200005);
DAQmxErrorDataOverwrittenInDeviceMemory =(-200004);
DAQmxErrorDuplicatedChannel =(-200003);
DAQmxWarningTimestampCounterRolledOver =(200003);
DAQmxWarningInputTerminationOverloaded =(200004);
DAQmxWarningADCOverloaded = (200005);
DAQmxWarningPLLUnlocked = (200007);
DAQmxWarningCounter0DMADuringAIConflict = (200008);
DAQmxWarningCounter1DMADuringAOConflict = (200009);
DAQmxWarningStoppedBeforeDone = (200010);
DAQmxWarningRateViolatesSettlingTime =(200011);
DAQmxWarningRateViolatesMaxADCRate =(200012);
DAQmxWarningUserDefInfoStringTooLong =(200013);
DAQmxWarningTooManyInterruptsPerSecond =(200014);
DAQmxWarningPotentialGlitchDuringWrite =(200015);
DAQmxWarningDevNotSelfCalibratedWithDAQmx = (200016);
DAQmxWarningAISampRateTooLow =(200017);
DAQmxWarningAIConvRateTooLow =(200018);
DAQmxWarningReadOffsetCoercion =(200019);
DAQmxWarningPretrigCoercion = (200020);
DAQmxWarningSampValCoercedToMax = (200021);
DAQmxWarningSampValCoercedToMin = (200022);
DAQmxWarningPropertyVersionNew =(200024);
DAQmxWarningUserDefinedInfoTooLong =(200025);
DAQmxWarningCAPIStringTruncatedToFitBuffer =(200026);
DAQmxWarningSampClkRateTooLow = (200027);
DAQmxWarningPossiblyInvalidCTRSampsInFiniteDMAAcq = (200028);
DAQmxWarningRISAcqCompletedSomeBinsNotFilled =(200029);
DAQmxWarningPXIDevTempExceedsMaxOpTemp =(200030);
DAQmxWarningOutputGainTooLowForRFFreq = (200031);
DAQmxWarningOutputGainTooHighForRFFreq =(200032);
DAQmxWarningMultipleWritesBetweenSampClks = (200033);
DAQmxWarningDeviceMayShutDownDueToHighTemp =(200034);
DAQmxWarningRateViolatesMinADCRate =(200035);
DAQmxWarningSampClkRateAboveDevSpecs =(200036);
DAQmxWarningCOPrevDAQmxWriteSettingsOverwrittenForHWTimedSinglePoint = (200037);
DAQmxWarningLowpassFilterSettlingTimeExceedsUserTimeBetween2ADCConversions = (200038);
DAQmxWarningLowpassFilterSettlingTimeExceedsDriverTimeBetween2ADCConversions = (200039);
DAQmxWarningSampClkRateViolatesSettlingTimeForGen = (200040);
DAQmxWarningReadNotCompleteBeforeSampClk =(209800);
DAQmxWarningWriteNotCompleteBeforeSampClk = (209801);
DAQmxErrorInvalidSignalModifier_Routing = (-89150);
DAQmxErrorRoutingDestTermPXIClk10InNotInSlot2_Routing = (-89149);
DAQmxErrorRoutingDestTermPXIStarXNotInSlot2_Routing = (-89148);
DAQmxErrorRoutingSrcTermPXIStarXNotInSlot2_Routing =(-89147);
DAQmxErrorRoutingSrcTermPXIStarInSlot16AndAbove_Routing = (-89146);
DAQmxErrorRoutingDestTermPXIStarInSlot16AndAbove_Routing =(-89145);
DAQmxErrorRoutingDestTermPXIStarInSlot2_Routing = (-89144);
DAQmxErrorRoutingSrcTermPXIStarInSlot2_Routing =(-89143);
DAQmxErrorRoutingDestTermPXIChassisNotIdentified_Routing =(-89142);
DAQmxErrorRoutingSrcTermPXIChassisNotIdentified_Routing = (-89141);
DAQmxErrorTrigLineNotFoundSingleDevRoute_Routing =(-89140);
DAQmxErrorNoCommonTrigLineForRoute_Routing =(-89139);
DAQmxErrorResourcesInUseForRouteInTask_Routing =(-89138);
DAQmxErrorResourcesInUseForRoute_Routing =(-89137);
DAQmxErrorRouteNotSupportedByHW_Routing = (-89136);
DAQmxErrorResourcesInUseForInversionInTask_Routing =(-89135);
DAQmxErrorResourcesInUseForInversion_Routing =(-89134);
DAQmxErrorInversionNotSupportedByHW_Routing = (-89133);
DAQmxErrorResourcesInUseForProperty_Routing = (-89132);
DAQmxErrorRouteSrcAndDestSame_Routing = (-89131);
DAQmxErrorDevAbsentOrUnavailable_Routing =(-89130);
DAQmxErrorInvalidTerm_Routing = (-89129);
DAQmxErrorCannotTristateTerm_Routing =(-89128);
DAQmxErrorCannotTristateBusyTerm_Routing =(-89127);
DAQmxErrorCouldNotReserveRequestedTrigLine_Routing =(-89126);
DAQmxErrorTrigLineNotFound_Routing =(-89125);
DAQmxErrorRoutingPathNotAvailable_Routing = (-89124);
DAQmxErrorRoutingHardwareBusy_Routing = (-89123);
DAQmxErrorRequestedSignalInversionForRoutingNotPossible_Routing = (-89122);
DAQmxErrorInvalidRoutingDestinationTerminalName_Routing = (-89121);
DAQmxErrorInvalidRoutingSourceTerminalName_Routing =(-89120);
DAQmxStatusCouldNotConnectToServer_Routing =(-88900);
DAQmxStatusDeviceNameNotFound_Routing = (-88717);
DAQmxStatusLocalRemoteDriverVersionMismatch_Routing = (-88716);
DAQmxStatusDuplicateDeviceName_Routing =(-88715);
DAQmxStatusRuntimeAborting_Routing = (-88710);
DAQmxStatusRuntimeAborted_Routing = (-88709);
DAQmxStatusResourceNotInPool_Routing = (-88708);
DAQmxStatusDriverDeviceGUIDNotFound_Routing = (-88705);

