classdef AbstractGeometricPoint < matlab.mixin.SetGet & matlab.mixin.Heterogeneous
    %AbstractGeometricPoint Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %marker
        markerColor(1,1) ColorSpecEnum = ColorSpecEnum.Red;
        markerShape(1,1) MarkerStyleEnum = MarkerStyleEnum.RightTriangle;
        
        %ground track line
        trkLineColor(1,1) ColorSpecEnum = ColorSpecEnum.Black;
        trkLineSpec(1,1) LineSpecEnum = LineSpecEnum.DottedLine;
    end
    
    methods        
        newCartElem = getPositionAtTime(obj, time, inFrame)
        
        name = getName(obj)
        
        setName(obj, name)
        
        listboxStr = getListboxStr(obj)
        
        useTf = openEditDialog(obj)
        
        tf = usesGroundObj(obj, groundObj)
        
        tf = usesGeometricPoint(obj, point)
        
        tf = usesGeometricVector(obj, vector)
        
        tf = usesGeometricCoordSys(obj, coordSys)
        
        tf = usesGeometricRefFrame(obj, refFrame)
        
        tf = isInUse(obj, lvdData)
    end
end