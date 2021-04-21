<?xml version="1.0" encoding="UTF-8"?>
<MetaResultFile creator="Solver HFTD - Field 3DFD Monitor" version="20170330">
  <SpecialMaterials>
    <Background type="NORMAL"/>
    <Material name="Copper (annealed)" type="FIELDFREE"/>
  </SpecialMaterials>
  <SimulationProperties dB_Amplitude="20" encoded_unit="&amp;U:A^1.:m^-1" fieldname="surface current (f=3.6) [1]" fieldtype="Surface current" frequency="3.5999999046325683594"/>
  <MetaGeometryFile filename="model.gex" lod="1"/>
  <ResultGroups num_steps="1" transformation="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1">
    <SharedDataWith treepath="2D/3D Results\H-Field\h-field (f=3.6) [1]" rexname="h-field (f=3.6)_1,1_m3d.rex"/>
    <Frame index="0">
      <FieldResultFile filename="h-field (f=3.6)_1,1.m3d" type="m3d"/>
    </Frame>
  </ResultGroups>
  <ResultDataType complex="1" timedomain="0" vector="1"/>
  <SimulationDomain min="-49.36891937256 -20.8189201355 -30.38891983032" max="49.36891937256 47.8189201355 30.38891983032"/>
  <PlotSettings Plot="2" ignore_symmetry="0" deformation="0"/>
  <Source type="SOLVER"/>
</MetaResultFile>
