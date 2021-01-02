function bodyInfo = getBodyInfoByNumber(bodyID, celBodyData)
%getBodyInfoByNumber Summary of this function goes here
%   Detailed explanation goes here

    try
        bodyInfo = celBodyData.getBodyInfoById(bodyID);
    catch
        fields = fieldnames(celBodyData);

        bodyInfo = [];

        for i = 1:numel(fields)
            body = celBodyData.(fields{i});
            if(bodyID == body.id)
                bodyInfo = body;
                return;
            end
        end
    end
end

