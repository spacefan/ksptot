classdef PattSrchPollMethodEnum < matlab.mixin.SetGet
    %FminconFiniteDiffTypeEnum Summary of this class goes here
    %   Detailed explanation goes here
    
    enumeration
        GPSPositiveBasis2N('GPSPositiveBasis2N', 'GPSPositiveBasis2N')
        GPSPositiveBasisNp1('GPSPositiveBasisNp1', 'GPSPositiveBasisNp1')
        GSSPositiveBasis2N('GSSPositiveBasis2N', 'GSSPositiveBasis2N')
        GSSPositiveBasisNp1('GSSPositiveBasisNp1', 'GSSPositiveBasisNp1')
        MADSPositiveBasis2N('MADSPositiveBasis2N', 'MADSPositiveBasis2N')
        MADSPositiveBasisNp1('MADSPositiveBasisNp1', 'MADSPositiveBasisNp1')
    end
    
    properties
        optionStr char = ''
        name char = '';
    end
    
    methods
        function obj = PattSrchPollMethodEnum(optionStr, name)
            obj.optionStr = optionStr;
            obj.name = name;
        end
    end
    
    methods(Static)
        function listBoxStr = getListBoxStr()
            m = enumeration('FminconFiniteDiffTypeEnum');
            [~,I] = sort({m.name});
            listBoxStr = {m(I).name};
        end
        
        function [ind, enum] = getIndForName(name)
            m = enumeration('FminconFiniteDiffTypeEnum');
            [~,I] = sort({m.name});
            m = m(I);
            ind = find(ismember({m.name},name),1,'first');
            enum = m(ind);
        end
    end
end