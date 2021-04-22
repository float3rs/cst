'# MWS Version: Version 2019.4 - Mar 01 2019 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.0 fmax = 0.0
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


