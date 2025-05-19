function [p] = get3dPos(colName, data)
    varNames = fieldnames(data);   % 提取变量名，返回 cell 数组
    mainVar = data.(varNames{1});  
    p = mainVar.Trajectories.Labeled.Data(find(strcmp(colName,mainVar.Trajectories.Labeled.Labels)) ,1:3,:);
end
            
        
function [theta_deg_list] = vectorAngle(p1Name, p2Name, intersectName, d)
    p1 = get3dPos(p1Name,d);
    p2 = get3dPos(p2Name,d);
    intersect = get3dPos(intersectName,d);
    
    v1 = p1 - intersect;
    v2 = p2 - intersect;
    
    % 防止除以零
    theta_deg_list = [];
    for i=1:length(v1)
        costheta = (v1(:,:,i)*v2(:,:,i)')/(norm(v1(:,:,i))*norm(v2(:,:,i))); % 余弦值
        theta_deg = acos(costheta)*180/pi; % 夹角°
        theta_deg_list(end+1) = theta_deg;
    end
end

