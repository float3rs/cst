'# MWS Version: Version 2019.4 - Mar 01 2019 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = fmin fmax = fmax
'# created = '[VERSION]2019.4|28.0.2|20190301[/VERSION]


'@ use template: foldeddipole000.cfg

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------




'@ define material: FR-4 (lossy)

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.025"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.3"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With 


'@ new component: component1

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Component.New "component1" 


'@ define brick: component1:substrate

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-(lsubs/2)", "lsubs/2" 
     .Yrange "hsubs", "0" 
     .Zrange "0", "-tsubs" 
     .Create
End With


'@ define curve polygon: curve1:polygon outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon outer" 
     .Curve "curve1" 
     .Point "-dfeed/2", "0" 
     .LineTo "(-dfeed/2)-wfeed", "0" 
     .LineTo "(-dfeed/2)-wfeed", "hfeed" 
     .LineTo "-ldip/2", "hfeed" 
     .LineTo "-ldip/2", "hfeed+hdip" 
     .LineTo "ldip/2", "hfeed+hdip" 
     .LineTo "ldip/2", "hfeed" 
     .LineTo "(dfeed/2)+wfeed", "hfeed" 
     .LineTo "(dfeed/2)+wfeed", "0" 
     .LineTo "dfeed/2", "0" 
     .LineTo "dfeed/2", "hfeed+wdip" 
     .LineTo "(ldip/2)-wdip", "hfeed+wdip" 
     .LineTo "(ldip/2)-wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+wdip" 
     .LineTo "-dfeed/2", "hfeed+wdip" 
     .LineTo "-dfeed/2", "0" 
     .Create 
End With 


'@ define curve polygon: curve2:polygon inner

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon inner" 
     .Curve "curve2" 
     .Point "(-dfeed/2)+wfeed+offset", "0" 
     .LineTo "(-dfeed/2)-wfeed+wfeed+offset", "0" 
     .LineTo "(-dfeed/2)-wfeed+wfeed+offset", "hfeed+wdip+offset" 
     .LineTo "(-ldip/2)+wdip+offset", "hfeed+wdip+offset" 
     .LineTo "(-ldip/2)+wdip+offset", "hfeed+hdip-wdip-offset" 
     .LineTo "(ldip/2)-wdip-offset", "hfeed+hdip-wdip-offset" 
     .LineTo "(ldip/2)-wdip-offset", "hfeed+wdip+offset" 
     .LineTo "(dfeed/2)+wfeed-wfeed-offset", "hfeed+wdip+offset" 
     .LineTo "(dfeed/2)+wfeed-wfeed-offset", "0" 
     .LineTo "(dfeed/2)-wfeed-offset", "0" 
     .LineTo "(dfeed/2)-wfeed-offset", "hfeed+wdip+offset+wdip" 
     .LineTo "(ldip/2)-wdip-offset-wdip", "hfeed+wdip+offset+wdip" 
     .LineTo "(ldip/2)-wdip-offset-wdip", "hfeed+hdip-wdip-offset-wdip" 
     .LineTo "(-ldip/2)+wdip+offset+wdip", "hfeed+hdip-wdip-offset-wdip" 
     .LineTo "(-ldip/2)+wdip+offset+wdip", "hfeed+wdip+offset+wdip" 
     .LineTo "(-dfeed/2)+offset+wfeed", "hfeed+wdip+offset+wdip" 
     .LineTo "(-dfeed/2)+offset+wfeed", "0" 
     .Create 
End With 


'@ define material: Copper (annealed)

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.HeatCapacity "0.39"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With 


'@ define extrudeprofile: component1:conductor outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "conductor outer" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Thickness "-tcond" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "False" 
     .Curve "curve1:polygon outer" 
     .Create
End With


'@ delete shape: component1:conductor outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Delete "component1:conductor outer" 


'@ delete curve item: curve1:polygon outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Curve.DeleteCurveItem "curve1", "polygon outer" 


'@ delete curve item: curve2:polygon inner

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Curve.DeleteCurveItem "curve2", "polygon inner" 


'@ activate local coordinates

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
WCS.ActivateWCS "local"


'@ define curve polygon: curve1:polygon outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon outer" 
     .Curve "curve1" 
     .Point "-dfeed/2", "0" 
     .LineTo "(-dfeed/2)-wfeed", "0" 
     .LineTo "(-dfeed/2)-wfeed", "hfeed" 
     .LineTo "-ldip/2", "hfeed" 
     .LineTo "-ldip/2", "hfeed+hdip" 
     .LineTo "ldip/2", "hfeed+hdip" 
     .LineTo "ldip/2", "hfeed" 
     .LineTo "(dfeed/2)+wfeed", "hfeed" 
     .LineTo "(dfeed/2)+wfeed", "0" 
     .LineTo "dfeed/2", "0" 
     .LineTo "dfeed/2", "hfeed+wdip" 
     .LineTo "(ldip/2)-wdip", "hfeed+wdip" 
     .LineTo "(ldip/2)-wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+hdip-wdip" 
     .LineTo "(-ldip/2)+wdip", "hfeed+wdip" 
     .LineTo "-dfeed/2", "hfeed+wdip" 
     .LineTo "-dfeed/2", "0" 
     .Create 
End With 


'@ define curve polygon: curve2:polygon inner

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon inner" 
     .Curve "curve2" 
     .Point "(-dfeed/2)+wfeed+offset", "0" 
     .LineTo "(-dfeed/2)-wfeed+wfeed+offset", "0" 
     .LineTo "(-dfeed/2)-wfeed+wfeed+offset", "hfeed+wdip+offset" 
     .LineTo "(-ldip/2)+wdip+offset", "hfeed+wdip+offset" 
     .LineTo "(-ldip/2)+wdip+offset", "hfeed+hdip-wdip-offset" 
     .LineTo "(ldip/2)-wdip-offset", "hfeed+hdip-wdip-offset" 
     .LineTo "(ldip/2)-wdip-offset", "hfeed+wdip+offset" 
     .LineTo "(dfeed/2)+wfeed-wfeed-offset", "hfeed+wdip+offset" 
     .LineTo "(dfeed/2)+wfeed-wfeed-offset", "0" 
     .LineTo "(dfeed/2)-wfeed-offset", "0" 
     .LineTo "(dfeed/2)-wfeed-offset", "hfeed+wdip+offset+wdip" 
     .LineTo "(ldip/2)-wdip-offset-wdip", "hfeed+wdip+offset+wdip" 
     .LineTo "(ldip/2)-wdip-offset-wdip", "hfeed+hdip-wdip-offset-wdip" 
     .LineTo "(-ldip/2)+wdip+offset+wdip", "hfeed+hdip-wdip-offset-wdip" 
     .LineTo "(-ldip/2)+wdip+offset+wdip", "hfeed+wdip+offset+wdip" 
     .LineTo "(-dfeed/2)+offset+wfeed", "hfeed+wdip+offset+wdip" 
     .LineTo "(-dfeed/2)+offset+wfeed", "0" 
     .Create 
End With 


'@ new component: conductors

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Component.New "conductors" 


'@ define extrudeprofile: conductors:conductor outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "conductor outer" 
     .Component "conductors" 
     .Material "Copper (annealed)" 
     .Thickness "-tcond" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "False" 
     .Curve "curve1:polygon outer" 
     .Create
End With


'@ define extrudeprofile: conductors:inner

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "inner" 
     .Component "conductors" 
     .Material "Copper (annealed)" 
     .Thickness "-tcond" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "False" 
     .Curve "curve2:polygon inner" 
     .Create
End With


'@ rename block: conductors:conductor outer to: conductors:outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Rename "conductors:conductor outer", "outer"


'@ new component: connectors

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Component.New "connectors" 


'@ define brick: connectors:plus

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Brick
     .Reset 
     .Name "plus" 
     .Component "connectors" 
     .Material "Copper (annealed)" 
     .Xrange "-(dfeed/2)", "-(dfeed/2)+offset" 
     .Yrange "0", "wfeed" 
     .Zrange "0", "tcond" 
     .Create
End With


'@ define brick: connectors:negative

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Brick
     .Reset 
     .Name "negative" 
     .Component "connectors" 
     .Material "Copper (annealed)" 
     .Xrange "(dfeed/2)-offset", "dfeed/2" 
     .Yrange "0", "wfeed" 
     .Zrange "0", "tcond" 
     .Create
End With


'@ rename block: connectors:plus to: connectors:positive

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Rename "connectors:plus", "positive"


'@ boolean add shapes: conductors:inner, conductors:outer

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Add "conductors:inner", "conductors:outer" 


'@ boolean add shapes: connectors:negative, connectors:positive

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Add "connectors:negative", "connectors:positive" 


'@ boolean add shapes: conductors:inner, connectors:negative

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Add "conductors:inner", "connectors:negative" 


'@ rename block: conductors:inner to: conductors:combined

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solid.Rename "conductors:inner", "combined"


'@ delete component: connectors

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Component.Delete "connectors" 


'@ define frequency range

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Solver.FrequencyRange "fmin", "fmax" 


'@ clear picks

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Pick.ClearAllPicks 


'@ pick similar faces

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Pick.PickSimilarFacesFromFaceId "conductors:combined", "38" 


'@ define port: 1

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .Folder "" 
     .NumberOfModes "1" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "20" 
     .TextMaxLimit "1" 
     .Coordinates "Free" 
     .Orientation "ymin" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-(dfeed/2)-wfeed-(k*tsubs)", "(dfeed/2)+wfeed+(k*tsubs)" 
     .Yrange "0", "0" 
     .Zrange "-(k*tsubs)", "K*tsubs" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "0.0", "0.0" 
     .SingleEnded "False" 
     .AddPotentialPicked "1", "positive", "conductors:combined", "46" 
     .AddPotentialPicked "1", "negative", "conductors:combined", "38" 
     .WaveguideMonitor "False" 
     .Create 
End With 


'@ reset mcalc defaults

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Mesh.ResetToMCalcDefaults


'@ set PBA version

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
Mesh.PBAVersion "2019030119"


'@ set mesh properties (Hexahedral)

'[VERSION]2019.4|28.0.2|20190301[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "15" 
     .Set "StepsPerWaveFar", "15" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "20" 
     .Set "StepsPerBoxFar", "1" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "1" 
     .Set "RatioLimitGeometry", "20" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .Set "PlaneMergeVersion", "2" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementOn", "0" 
     .Set "FaceRefinementPolicy", "2" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementOn", "0" 
     .Set "EllipseRefinementPolicy", "2" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementOn", "1" 
     .Set "EdgeRefinementPolicy", "1" 
     .Set "EdgeRefinementRatio", "6" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "0" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "1"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "1"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
End With 
With Discretizer 
     .ConnectivityCheck "False"
     .UsePecEdgeModel "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "0.001" 
     .PointAccEnhancement "0" 
     .TSTVersion "0"
	  .PBAVersion "2019030119" 
End With 


